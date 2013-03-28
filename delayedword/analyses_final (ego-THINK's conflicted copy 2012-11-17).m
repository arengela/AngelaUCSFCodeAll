%%LOAD AND SAVE ALL BLOCKS
patients={'EC18','EC16','EC22','EC23','EC24','EC29','EC28'}
brainFile='E:\General Patient Info\'
n=0
for p=1:length(patients)-1%n=[1 17 9 11 10 34 43 ]%1 433
    if n~=17 & p~=2
        ch=1:256;
        events=[2 4 5]
        
    else
        ch=1:128;
        events=[2 4 5]
    end
    load(['E:\DelayWord\Figure1_withCAR\Tall_' patients{p} '_B1'])
    load(['E:\DelayWord\Figure1_withCAR\E_' patients{p} '_B1'])
    events=[2 4 5]
    %[Tall,E]=analyzeData(n,ch,[],events)
    p=find(strcmp(Tall{2}.Data.patientID,patients))
    [~,r]=fileparts(Tall{2}.Data.MainPath)
    s=regexp(r,'_','split')
    blocknum=regexp(s{2},'[123456789]','match')
    if str2num(blocknum{1})~=1
        continue
    end
    AllP{p}.Tall=Tall;
    AllP{p}.E=E;
    
    %% GET CS AND SF ELECTRODES
    load(['E:\DelayWord\Figure1_withCAR\BrainCoord'])
    %     load(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\regdata.mat'])
    %     visualizeGrid(2,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],[]);
    %     hold on
    %     scatter(BrainCoord(p).xySF(1,:),BrainCoord(p).xySF(2,:),'fill')
    %     scatter(BrainCoord(p).xyCS(1,:),BrainCoord(p).xyCS(2,:),'fill')
    %     BrainCoord(p).xy=xy;
    %     scatter(BrainCoord(p).xy(1,:),BrainCoord(p).xy(2,:),'fill')
    %     BrainCoord(p).gridDist=pdist(xy(:,[1,16])');
    %
    %% VIEW ALL ELECTRODES AND ENTER BAD TRIALS
    figure(2)
    for eidx=events
        usech=setdiff(ch,AllP{p}.Tall{eidx}.Data.Artifacts.badChannels);
        usesamp=100:300;
        subplot(2,1,1)
        d=zscore(detrend(squeeze(mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,:),1),2))));
        plot(d)
        subplot(2,1,2)
        imagesc(squeeze(mean( AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,:),1))')
        AllP{p}.Tall{eidx}.Data.Artifacts.badtr=[];
        AllP{p}.Tall{eidx}.Data.Artifacts.badtr=find(abs(d)>2);
        AllP{p}.Tall{eidx}.Data.Params.usetr=setdiff(1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.data,4),AllP{p}.Tall{eidx}.Data.Artifacts.badtr);
        %keyboard
    end
end
%%
for p=1:length(patients)-1
    %% GET CS AND SF ELECTRODES
    %load(['E:\DelayWord\Figure1_withCAR\BrainCoord'])
    load(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\regdata.mat'])
    visualizeGrid(2,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],[]);
    hold on
    scatter(BrainCoord(p).xySF(1,:),BrainCoord(p).xySF(2,:),'fill')
    scatter(BrainCoord(p).xyCS(1,:),BrainCoord(p).xyCS(2,:),'fill')
    BrainCoord(p).xy=xy;
    scatter(BrainCoord(p).xy(1,:),BrainCoord(p).xy(2,:),'fill')
    BrainCoord(p).gridDist=pdist(xy(:,[1,16])');
    input('n')
end
%% GET RID OF PEAK DUE TO BEEP
for p=1:length(patients)-1
    usesamps=[1:400]
    %     for x=5
    %         AllP{p}.Tall{x}.Data.segmentedEcog.smoothed100=[]
    %         for c=1:AllP{p}.Tall{x}.Data.channelsTot
    %             for tr=1:size( AllP{p}.Tall{x}.Data.segmentedEcog.zscore_separate,4)
    %                 AllP{p}.Tall{x}.Data.segmentedEcog.smoothed100(c,:,:,tr)=smooth(resample(squeeze(AllP{p}.Tall{x}.Data.segmentedEcog.zscore_separate(c,:,:,tr)),1,4),20);
    %             end
    %         end
    %     end
    %     AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100Hold=AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100;
    usetr=AllP{p}.Tall{5}.Data.Params.usetr;
    idx=find(cellfun(@isempty,AllP{p}.Tall{5}.Data.segmentedEcog.event(:,[13])))
    for i=1:length(idx)
        AllP{p}.Tall{5}.Data.segmentedEcog.event{idx(i),15}=0
    end
    idx=find(cellfun(@isempty,AllP{p}.Tall{5}.Data.segmentedEcog.event(:,[11])))
    for i=1:length(idx)
        AllP{p}.Tall{5}.Data.segmentedEcog.event{idx(i),13}=0
    end
    beepsamp=(vertcat(AllP{p}.Tall{5}.Data.segmentedEcog.event{:,[15]})-vertcat(AllP{p}.Tall{5}.Data.segmentedEcog.event{:,[13]}))*100
    for tr=usetr
        if abs(beepsamp(tr))>200
            samps=1:200;
        else
            samps=round(200-beepsamp(tr)-20):round(200-beepsamp(tr)+130);
        end
        AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(AllP{p}.Tall{2}.Data.Params.activeCh,samps,:,tr)=NaN;
    end
end
%%
powerpoint_object=SAVEPPT2('test','init')
for p=1:length(patients)-1
    for eidx=[2 4 5]
        AllP{p}.Tall{eidx}.Data.plotData('line',1,'1','n','n')
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveppt2('ppt',powerpoint_object,'scale','on','stretch','on');
        close all
    end
end








%%
figure
for p=1:length(patients)-1
    clf
    for c=1:AllP{p}.Tall{5}.Data.channelsTot;
        plotGridPosition(c)
        usetr=AllP{p}.Tall{5}.Data.Params.usetr;
        hold on
        %        plot(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100Hold(c,:,:,usetr),4),'r','LineWidth',2)
        %        plot(nanmean(AllP{p}.Tall{4}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),'Color',rgb('green'),'LineWidth',2)
        
        plot(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr)))%
        [hl,hp]=errorarea(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),sqrt(nanstd(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr),[],4)./length(~isnan(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,1,1,usetr)))))
        set(hl,'LineWidth',2)
        line([200 200],[-2 5])
    end
    input('n')
end
%%


%% GET PEAK TIME FOR EACH TRIAL
for p=1:length(patients)-1
    %%
    for eidx=5%events
        clf
        %         usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
        %         idx=find(cellfun(@isempty,AllP{p}.Tall{5}.Data.segmentedEcog.event(:,[13])))
        %         for i=1:length(idx)
        %             AllP{p}.Tall{5}.Data.segmentedEcog.event{idx(i),15}=0
        %         end
        %         idx=find(cellfun(@isempty,AllP{p}.Tall{5}.Data.segmentedEcog.event(:,[11])))
        %         for i=1:length(idx)
        %             AllP{p}.Tall{5}.Data.segmentedEcog.event{idx(i),13}=0;
        %         end
        %         beepsamp=(vertcat(AllP{p}.Tall{5}.Data.segmentedEcog.event{:,[15]})-vertcat(AllP{p}.Tall{5}.Data.segmentedEcog.event{:,[13]}))*100
        %         [~,usetr]=sort(beepsamp(usetr));
        for c=1:AllP{p}.Tall{eidx}.Data.channelsTot
            plotGridPosition(c);
            
            
            
            %plot(squeeze(nanmean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4)));
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100Hold(c,:,:,usetr))')
            chBin=sum(vertcat(AllP{p}.E{eidx}.electrodes.TTest),2);
            usech=find(chBin>20);
            %usech=AllP{p}.Tall{eidx}.Data.Params.activeCh
            AllP{p}.Tall{eidx}.Data.Params.activeCh=reshape(usech,1,[]);
            %usech=find([AllP{p}.E{eidx}.electrodes.peakTime]~=100000);
            if ismember(c,usech)
                set(gca,'Color','y')
                hold on
                sigSamps=find([AllP{p}.E{eidx}.electrodes(c).TTest])+100;
                try
                    plot(sigSamps,0,'r.')
                catch
                    AllP{p}.Tall{eidx}.Data.Params.activeCh=setdiff(AllP{p}.Tall{eidx}.Data.Params.activeCh,c)
                end
                [maxAmp,tmp]=max(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,sigSamps,1,:)),[],1);
                maxIdx=sigSamps(tmp);
                maxIdx(find(isnan(maxAmp)))=NaN;
                %                 maxAmp=prctile(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,sigSamps,1,:)),95);
                %                 for tr=1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100,4)
                %                     try
                %                         maxIdx(tr)=sigSamps(find(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,sigSamps,1,tr))>=maxAmp(tr),1,'first'));
                %                     catch
                %                         maxIdx(tr)=NaN;
                %                     end
                %                 end
                
                AllP{p}.E{eidx}.electrodes(c).maxAmpTr=maxAmp(usetr);
                AllP{p}.E{eidx}.electrodes(c).maxIdxTr=maxIdx(usetr);
                if nanmean(maxAmp)<.8 %| range(maxIdx)>50
                    AllP{p}.E{eidx}.electrodes(c).maxAmpTr=NaN;
                    AllP{p}.E{eidx}.electrodes(c).maxIdxTr=NaN;
                else
                    plot(nanmedian(maxIdx),2,'*')
                    plot(maxIdx(usetr),1:length(usetr),'.r')
                end
                
                
            else
                AllP{p}.E{eidx}.electrodes(c).maxAmpTr=NaN;
                AllP{p}.E{eidx}.electrodes(c).maxIdxTr=NaN;
            end
            %axis([0 400 -1 5])
            axis tight
        end
        %notSig=input('n','s')
        notSig=[]
        if ~isempty(notSig)
            AllP{p}.Tall{eidx}.Data.Params.activeCh=setdiff(usech,str2num(notSig));
        end
        keyboard
    end
end


%% PLOT PEAK
clf
e=1;
for eidx=[2 5]
    subplot(1,2,e)
    scatterAllPatientsPeak
    input('n')
    e=e+1;
end

%% PARTIAL CORR TO WL AND WF
eidx=2
close all
extremeRange=linspace(-1,1,64);
usesamp=100:300
%%
for p=1:length(patients)-1
    Labels=AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,8);
    getWordProp;
    ct1=cell2mat(wordProp.f(:));
    tmp=ones(length(wordProp.ed),1);
    tmp(find(strcmp(wordProp.ed,'easy')))=2;
    ct2=tmp;
    v=cell2mat(wordProp.l(:))
    usech=AllP{p}.Tall{eidx}.Data.usechans
    usetr=setdiff(1:length(ct1),[find(strcmp('n',wordProp.ed)) reshape(AllP{p}.Tall{eidx}.Data.Artifacts.badtr,1,[])]);
    dat=squeeze(prctile(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),99,2));
    %dat=squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,usetr),2));
    [dat,midx]=max(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),[],2);
    dat=squeeze(dat);
    midx=squeeze(midx);
    [R,pval]=partialcorr(midx', v(usetr),[ct2(usetr) ct1(usetr)],'type','Spearman');
    %[R,pval]=corr(dat', v(usetr),'type','Spearman');
    [pval,h_fdr]=MT_FDR_PRDS(pval,.05);
    chidx=find(pval<.05 & R>.2);
    ch=usech(chidx)
    idx=findNearest(R(chidx),extremeRange);
    figure(1)
    %getChLocations
    d=R(chidx);
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,R(chidx)');
    %figure(2)
    %plotDataOnBrain
    input('n')
    clf
end
set(gcf,'Color','w')
%%
colormat=jet
for c=ch
    %plot(v(usetr),dat(c,:)','r.')
    for t=usetr
        plot(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamp,:,t)),'Color',colormat(v(t)*floor(size(colormat,1)/13),:),'LineWidth',2)
        hold on
    end
    title(int2str(c))
    input('n')
    hold off
end
%%
gscatter(repmat(v(usetr),[length(ch),1]),dat(ch,:))



%% mds ALL
clf
dat=[];
colormat=vertcat(rgb('blue'),rgb('red'))
sidx=1;
usesamp=100:300
for s=50:5:250-5
    usesamp=sampMat{2}(s):sampMat{2}(s+5)
    %%
    for p=1:length(patients)-1
        try
            usech=AllP{p}.Tall{eidx}.Data.Params.activeCh;
            usetr=setdiff(1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100z,4),[AllP{p}.Tall{eidx}.Data.Artifacts.badtr]);
            %tmpdat=permute(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100z(usech,usesamp,:,usetr),[2 1 4 3]);
            d=squeeze(prctile(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100z(usech,usesamp,:,usetr),99,2))';
            badtr=find(zscore(mean(d'))>2);
            usetr2=setdiff(1:length(usetr),badtr);
            pMat(p).d=pdist(d(usetr2,:));
            pMat(p).d=pMat(p).d./max(pMat(p).d);
            %figure;imagesc(squareform(pMat(p).d))
            sqD=squareform(pMat(p).d);
            usetr3=setdiff(1:length(usetr2),find(zscore(mean(sqD,2))>2));
            %mdXY=mdscale(sqD(usetr3,usetr3),3);
            Labels=AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,8);
            getWordProp;
            grpidx=ones(length(wordProp.ed),1);
            grpidx(find(strcmp(wordProp.ed,'easy')))=2;
            %grpidx=round(cell2mat(wordProp.l))+1;
            
            AllP{p}.Tall{eidx}.Data.Artifacts.badtr=setdiff(1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100z,4),usetr(usetr2(usetr3)));
            grpidx=grpidx(usetr(usetr2(usetr3)));
            %scatter3(mdXY(:,1),mdXY(:,2),mdXY(:,3),100,colormat(grpidx,:),markershape{p},'fill')
            %h=gscatter(mdXY(:,1),mdXY(:,2),grpidx(usetr(usetr2(usetr3))),colorjet([1 50],:),markershape{p},5)
            hold on
            
            
            
            d=d(usetr2(usetr3),:);
            
            [kgroup,centroid,sumd,dos] = kmeans(d, 2);
            sil=silhouette(d,kgroup);
            [stats(p).savg(sidx,:),stats(p).se(sidx,:)] = grpstats(sil,kgroup,{'mean','ste'});
            
            imagesc([kgroup grpidx])
            input('m')
        end
    end
    sidx=sidx+1;
    title(usesamp)
    %input('m')
    clf
end

%%
for p=1:5
    errorarea(stats(p).savg,stats(p).se)
    hold on
end

tmp=cat(3,stats.savg)
plot(mean(tmp,3))
%% PLOT ACTIVE ELECTRODES FOR PERC AND PROD
for p=1:length(patients)-1
    figure(p+6+6)
    eidx=2
    usech=AllP{p}.Tall{eidx}.Data.Params.activeCh;
    d=repmat(1,1,length(usech));
    %d=[AllP{p}.E{eidx}.electrodes(usech).maxAmp]
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d);
    %     eidx=4
    %     usech=AllP{p}.Tall{eidx}.Data.Params.activeCh;
    %     visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,repmat(1,1,length(usech)),[],[],[],rgb('yellow'),0);
    eidx=5
    usech=setdiff(AllP{p}.Tall{eidx}.Data.Params.activeCh,usech);
    d=repmat(1,1,length(usech));
    %d=[AllP{p}.E{eidx}.electrodes(usech).maxAmp]
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d,[],[],[],rgb('blue'),0);
    
    usech=intersect(AllP{p}.Tall{2}.Data.Params.activeCh,AllP{p}.Tall{5}.Data.Params.activeCh);
    d=repmat(1,1,length(usech));
    %d=[AllP{p}.E{eidx}.electrodes(usech).maxAmp]
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d,[],[],[],rgb('yellow'),0);

    tmat=vertcat(AllP{p}.E{4}.electrodes.TTest);
    usech=find(sum(tmat(:,100:120),2)>15)
    d=repmat(1,1,length(usech));
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d,[],[],[],rgb('black'),0);
end
%%
for p=1:length(patients)-1
    figure(p)
    usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]) reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);
    d1=max(mean(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(usech,:,:,:),4),[],2);
    d2=max(mean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(usech,:,:,:),4),[],2);

    %d=[AllP{p}.E{eidx}.electrodes(usech).maxAmp]
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech(find(d1>d2)),ones(length(find(d1>d2))));
    
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech(find(d2>d1)),ones(length(find(d2>d1))),[],[],[],rgb('blue'),0);

    %     eidx=4
    %     usech=AllP{p}.Tall{eidx}.Data.Params.activeCh;
    %     visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,repmat(1,1,length(usech)),[],[],[],rgb('yellow'),0);
    eidx=5
    usech=setdiff(AllP{p}.Tall{5}.Data.Params.activeCh,AllP{p}.Tall{2}.Data.Params.activeCh);
    d=repmat(1,1,length(usech));
    %d=[AllP{p}.E{eidx}.electrodes(usech).maxAmp]
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d,[],[],[],rgb('cyan'),0);
    
    eidx=2
    usech=setdiff(AllP{p}.Tall{2}.Data.Params.activeCh,AllP{p}.Tall{5}.Data.Params.activeCh);
    d=repmat(1,1,length(usech));
    %d=[AllP{p}.E{eidx}.electrodes(usech).maxAmp]
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d,[],[],[],rgb('pink'),0);
 
         
    tmat=vertcat(AllP{p}.E{4}.electrodes.TTest);
    usech=find(sum(tmat(:,100:110),2)>5)
    d=repmat(1,1,length(usech));
    %visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d,[],[],[],rgb('black'),0);
%%
end
%%
colorcell{2}='r'
colorcell{4}='k'
colorcell{5}='b'

for p=1:length(patients)-1
    figure(p)    
    for eidx=[2 5 4]
        for c=1:AllP{p}.Tall{eidx}.Data.channelsTot
            plotGridPosition(c);
            usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            if eidx==5
                plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100Hold(c,:,:,usetr),4),colorcell{eidx},'LineWidth',2)
            else
                plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),colorcell{eidx},'LineWidth',2)
            end
            hold on
            if ismember(c,AllP{p}.Tall{eidx}.Data.Params.activeCh)
                scatter(1,eidx,50,colorcell{eidx},'fill')
            end
            line([200 200],[-1 5])
            axis tight        
            if ismember(c,AllP{p}.Tall{eidx}.Data.Artifacts.badChannels)
                set(gca,'Color','y')
        	end
        end

    end
  
end
%%
for i=1:6
    figure(i)
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveppt2('ppt',powerpoint_object,'stretch','off');
end