%% FIND BAD TRIALS
clear d
for p=1:8
    for eidx=[2 4 5]
            AllP{p}.Tall{eidx}.Data.Artifacts.badTrials=[];
            ch=setdiff(1:AllP{p}.Tall{eidx}.Data.channelsTot,AllP{p}.Tall{eidx}.Data.Artifacts.badChannels);
            d=zscore(squeeze(mean(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,:,:,:)),1)),[],1);
            [a,b]=find(zscore(mean(d,1))>5);
            AllP{p}.Tall{eidx}.Data.Artifacts.badTrials=unique([AllP{p}.Tall{eidx}.Data.Artifacts.badTrials b']);
            imagesc(d')
        end
        input('b')
    end
end


%% MAKE DATA STRUCTURE OF AVE WAVEFORM FOR SHORT AND LONG WORDS: ONLY SAMPLES USED FOR CLUSTERING
allD.data=[];
allD.p=[];
allD.ch=[];
samps={1:400, 1:250, 101:300}

i=1;
for p=1:8
    ch=1:AllP{p}.Tall{2}.Data.channelsTot;
    ch=setdiff(ch,AllP{p}.Tall{2}.Data.Artifacts.badChannels);

    d=[];
    ehold=[];
    for eidx=[2 4 5]
        d{eidx}=[];
        e=find([2 4 5]==eidx);
        ind=AllP{p}.Tall{eidx}.Data.findTrials('1','n','n');
        for condIdx=1:2
            useind=setdiff(ind.(['cond' int2str(condIdx)]),AllP{p}.Tall{eidx}.Data.Artifacts.badTrials);
            
            d{eidx}=[d{eidx} mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,samps{e},:,useind),4)];
            ehold=[ehold repmat(eidx,1,length(samps{find([2 4 5]==eidx)}))];
        end
    end
    dcat=horzcat(d{2},d{4},d{5});
    allD.data=vertcat(allD.data,dcat);
    allD.p=vertcat(allD.p,repmat(p,size(dcat,1),1));
    allD.ch=vertcat(allD.ch,ch');
    i=i+1;
end
%%
%% MAKE DATA STRUCTURE OF AVE WAVEFORM FOR SHORT AND LONG WORDS:ALL DATA
allD.dataAll=[];
i=1;
for p=1:8
    ch=1:AllP{p}.Tall{2}.Data.channelsTot;
    ch=setdiff(ch,AllP{p}.Tall{2}.Data.Artifacts.badChannels);
    d=[];
    for eidx=[2 4 5]
        d{eidx}=[];
        e=find([2 4 5]==eidx);
        ind=AllP{p}.Tall{eidx}.Data.findTrials('1','n','n');
        for condIdx=1:2
            useind=setdiff(ind.(['cond' int2str(condIdx)]),AllP{p}.Tall{eidx}.Data.Artifacts.badTrials);
            d{eidx}=[d{eidx} mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,1:400,:,useind),4)];
            
        end
    end
    dcat=horzcat(d{2},d{4},d{5});
    allD.dataAll=vertcat(allD.dataAll,dcat);
   
end
%% USE ONLY ACTIVE CHANNELS
[H,pval]=ttest2(allD.data',allD.data(:,70:150)',.01);
[pval,sig]=MT_FDR_PRDS(pval,0.01);
idx=find(sig);
allD.data(idx,:);
allD.dataAll(idx,:);
allD.ch(idx);
allD.p(idx);
%% CHECK ANALOG
analog={[],[],[]}
for p=1:8
    for eidx=[2 4 5]
        e=find([2 4 5]==eidx);
        analog{e}=vertcat(analog{e},squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.analog400Env(1,:,:,:))');
    end
end

for e=1:3
    subplot(1,3,e)
    imagesc(zscore(analog{e},[],2),[0 2])
    hl=line([400*2 400*2],[0 length(analog{e})]);
    set(hl,'Color','w')
end

%% SET EMPTY EVENTS TO NAN
for p=1:8
    for eidx=[2 4 5]
        AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
    end
end

%% GET AVERAGE WL AND RESPONSE TIME

col={[7 9],[11 13],[13 15]}
for p=1:8
    for eidx=[2 4 5]
        e=find([2 4 5]==eidx);
        ind=AllP{p}.Tall{eidx}.Data.findTrials('1','n','n');
        for i=1:2
            rt=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(ind.(['cond' int2str(i)]),col{e}(2)))-...
                cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(ind.(['cond' int2str(i)]),col{e}(1)));
            pr=prctile(rt,99);
            idx=find(rt<p & rt>-pr);
            responseTime{p,e,i}=nanmedian(rt(idx));
            
            hist(rt(idx));
            %keyboard
        end
    end
end


%% CLUSTER
samps={[1:400]+400, [1:250]+800, [101:300]+800+500}


for knum=3:20
    [kgroup,centroid]=kmeans(allD.data(:,:),knum,'Distance','correlation','EmptyAction','drop','Replicates',5);
    %[S,h]=silhouette(allD.data,kgroup,'correlation')
    allD.kgroup=kgroup;
    allD.centroid=centroid;
    %use=find(S>=0);
    S=[];
    for k=1:knum
        idx=find(allD.kgroup==k);
        R=corr(allD.data(idx,:)',centroid');
        S=[S (R(:,k)./max(R(:,setdiff(1:knum,k)),[],2))'];
    end
    hist(S)
    Smean(knum)=mean(S(:));
    title(mean(S))
    %input('b')
end


%% LDA ON CLUSTERS
clear dat
for kIdx=1:length(kGroups)
    k=kGroups(kIdx,1);
    idx=find(allD.kgroup==k);
    dat{kIdx}=allD.dataAll(idx(1:50),:)';
end

[ldcoeff, ldvec] = lda(dat);

clf

colormat=jet
for i=1:10
    for kIdx=1:length(kGroups)
        subplot(2,5,i)
        color=colormat(round(kIdx*(64/length(kGroups))),:);
        plot(dat{kIdx}*ldvec(:,i),'Color',color)
        hold on
    end
end


%% CHECK LDs
colorjet=colormap(jet)

clf
for kIdx=1:knum
  for eidx=[2 4 5]
        e=find([2 4 5]==eidx);
        idx=find(ehold==eidx);
        d=ldvec(idx,kIdx)';
        subplot(1,3,(1-1)*3+e)        
        plot(d(1,1:length(d)/2))
        hold on
        plot(d(1,length(d)/2+1:end),'r')
        %plot((ldvec(idx,kIdx))','Color',colorjet(round(kIdx/length(kGroups)*length(colorjet)),:))
        %plot(mean(dat{kIdx},1),'Color',colorjet(round(kIdx/length(kGroups)*length(colorjet)),:))
        hold on
    end
    input('n')
    clf
end
%%
clf%% PCA ON CLUSTERS
dat2=horzcat(dat{:});
[COEFF, SCORE, LATENT] = PRINCOMP(dat2(:,:)); 
for i=1:length(kGroups)
    %subplot(2,5,i)
    color=colormat(round(i*(64/length(kGroups))),:);
    plot(dat2(:,:)*(COEFF(:,i)),'Color',color)
    %input('b')
    hold on
end
%%
% PLOT SCORES OF PCA
maxD=100;
for i=1:10
    clf
    a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
    imshow(repmat(a,[1 1 3]))
    hold on
    for p=1:8
        idx=find(allD.p==p);
        SCORE(find(SCORE>maxD))=maxD;
        SCORE(find(SCORE<=-maxD))=-maxD;
        try
            idx2=find(SCORE(idx,i)>=0);
            plotManyPolygons(BrainCoord(p).newXY',10,rgb('red'),SCORE(idx(idx2),i)./max(SCORE(idx(idx2),i)),10)
        
        end
%         try
%             idx2=find(SCORE(idx,i)<0);
%             plotManyPolygons(BrainCoord(p).newXY',10,rgb('blue'),SCORE(idx(idx2),i)./-maxD,10)
%         end
    end
    input('n')
end
%% LDA BY WORD TYPE AND KGROUP
clear dat
for kIdx=1:length(kGroups)
    k=kGroups(kIdx,1);
    idx=find(allD.kgroup==k);
    dat{1}=allD.dataAll(idx,[1601:2000])';
    dat{2}=allD.dataAll(idx,[1601:2000]+400)';
    [ldcoeff, ldvec] = lda(dat);                                                                                        
    for i=1:5
        plot(dat{1}*(ldvec(:,i)),'Color','r')
        hold on
        plot(dat{2}*(ldvec(:,i)),'Color','b')
        input('b')
        clf
    end
end


%% SVM

for n=1:10
    idx=find(ismember(allD.kgroup,kGroups(:,1)));
    idx=idx(ceil(rand(1,length(idx))*length(idx)));
    train_data=allD.data(idx(1:round(.8*length(idx)),:));
    test_data=allD.data(idx(round(.8*length(idx)):end,:));

    train_label=allD.kgroup(idx(1:round(.8*length(idx)),:));
    test_label=allD.kgroup(idx(round(.8*length(idx)):end,:));    
    
    [bestc, bestg, bestcv, model, predicted_label, accuracy, decision_values] = svm(train_data, train_label,test_data, test_label);
    SVMout.predicted_label=predicted_label;
    SVMout.accuracy=accuracy;
    SVMout.decision_values=decision_values;
    SVMout.bestc=bestc;
    SVMout.bestg=bestg;
    SVMout.bestcv=bestcv;
    SVMout.model=model;
end

%% GET P VALUES
samps={[1:400 801:1200 1601:2000],[401:800 1201:1600 2001:2400]}
for sl=1:2
    stack{sl}=allD.dataAll(:,samps{sl});
end


for k=1:30
    idx=find(allD.kgroup==k);
    for e=1:2
        [ps_raw{k,e},bse,base_boot_means]=singleConditionStats(stack{e}(idx,:),[100 190],[200:size(allD.dataAll,2)]);
    end
    
    [ps_raw_2cond{k}]=twoConditionStats(stack{1}(idx,:),stack{2}(idx,:),[201:size(allD.dataAll,2)],ps_raw{k,1},ps_raw{k,2},200,200);
end
%%
for k=1:30
    for e=1:2
        ps_raw{k,e}(200)=NaN;
        ps_raw_2cond{k}(200)=NaN;
    end
end
 %% MDS CLUSTER GROUPS
 idx=find(ismember(allD.kgroup,kGroups(:,1)));
 dist=pdist(allD.data(idx,:),'correlation');
 y=mdscale(dist,3);
 %%
 clf
 colorjet=colormap(jet);
 for kIdx=1:length(kGroups)
     k=kGroups(kIdx,1)
     idx2=find(allD.kgroup(idx)==k);
     color=colorjet(findNearest(floor((kIdx-1)*length(colorjet)/(size(kGroups,1)-1)),1:64),:);
     %scatter(y(idx2,1),y(idx2,2),[],repmat(color,[length(idx2),1]))

     scatter3(y(idx2,1),y(idx2,2),y(idx2,3),[],repmat(color,[length(idx2),1]))
     hold on
 end
 
 %% MDS WL
 d1=allD.dataAll(:,[1:400 801:1200  1601:2000]);
 d2=allD.dataAll(:,[401:800 1201:1600  2001:2400]);

idx=find(ismember(allD.kgroup,kGroups(:,1)));
dist=pdist(vertcat(d1(idx,:),d2(idx,:)),'correlation');
y=mdscale(dist,3);
 %%
 for kIdx=1:length(kGroups)
    clf
    k=kGroups(kIdx,1)
    idx2=find((allD.kgroup(idx)==k));
    color=rgb('red')
    scatter3(y(idx2+length(y)/2+1,1),y(idx2+length(y)/2+1,2),y(idx2+length(y)/2+1,3),[],repmat(color,[length(idx2),1]))
    hold on
    color=rgb('blue')
    scatter3(y(idx2,1),y(idx2,2),y(idx2,3),[],repmat(color,[length(idx2),1]))
    input('b')
 end
%% CORR BY WL
clf
clear ind
allD.cond1=[]
allD.cond2=[]

        step=20
for s=1:400/step
    cursamps=(s-1)*step+1:(s)*step
    a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
imshow(repmat(a,[1 1 3]))
        hold on 
    for p=1:8
        ch=1:AllP{p}.Tall{2}.Data.channelsTot;
        ch=setdiff(ch,AllP{p}.Tall{2}.Data.Artifacts.badChannels);
        d=[];
        for eidx=4
            d{eidx}=[];
            e=find([2 4 5]==eidx);
            ind{p,eidx}=AllP{p}.Tall{eidx}.Data.findTrials('2','y','n');
            d1= squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,cursamps,:,ind{p,eidx}.cond1),2));
            d2= squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,cursamps,:,ind{p,eidx}.cond2),2));
            [R,pval]=corr(cat(2,d1,d2)',[repmat(1,1,size(d1,2)) repmat(2,1,size(d2,2))]','Type','Spearman');   
            color=colorjet(findNearest(floor((p-1)*length(colorjet)/(8-1)),1:length(colorjet)),:);
            %color=rgb('red');
            R(find(R<.4))=0;
            try
                plotManyPolygons(BrainCoord(p).newXY(:,find(pval<.01))',100,color,R(find(pval<.01)).^2,8)
            end
        end
    end
    title(cursamps(1))
    input('b')
    clf
end
%%
idx=find(ismember(allD.kgroup,kGroups(:,1)'))
d=allD.data(idx,:);
Y=pdist(d);
[H,T]=dendrogram(linkage(Y,'average'))