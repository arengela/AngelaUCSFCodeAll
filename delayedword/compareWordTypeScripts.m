%%%%%%%%%%%%%%%%%%%%
%INITIATE VARIABLES
%%%%%%%%%%%%%%%%%%%%
%%
load('E:\DelayWord\brocawords.mat');
load('E:\DelayWord\frequencybands');
load('E:\DelayWord\wordpairs');
%% SET WHICH CHANNELS, TRIALS, AND SAMPLES TO USE
badtr=[27 29  39 41 45];
badtr=[ 39 41];
badtr=[]
%badtr=find(cellfun(@(x) isequal(x,0),wordProp.ed))
usetr=setdiff(1:size(T.Data.segmentedEcog.zscore_separate,4),badtr);
usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels);
usesamp=801:1400;
%% GET WORD PROPERTIES FOR WORD EVENTS
Labels=T.Data.segmentedEcog.event(usetr,8);
clear wordLength wordFreq wordProp
for i=1:length(Labels)
    idx=find(strcmp(Labels(i), {brocawords.names}'))
    if isempty(idx)
        wordProp.l{i}=0;
        wordProp.f{i}=0;
        wordProp.rp{i}=0;
        wordProp.ed{i}=0;
        wordProp.sl{i}=0;
    else
        wordProp.l{i}=brocawords(idx).lengthval;
        wordProp.f{i}=brocawords(idx).logfreq_HAL;
        wordProp.rp{i}=brocawords(idx).realpseudo;
        wordProp.ed{i}=brocawords(idx).difficulty;
        wordProp.sl{i}=brocawords(idx).lengthtype;
    end
    wordProp.name{i}=Labels{i};
end
wordLength=cell2mat(wordProp.l);
wordFreq=cell2mat(wordProp.f);
%% SMOOTH AND DOWNSAMPLE TO 100 Hz
for x=[2 5]
    for c=1:256
        for tr=1:size(Tall{x}.Data.segmentedEcog.zscore_separate,4)
            Tall{x}.Data.segmentedEcog.smoothed100(c,:,:,tr)=smooth(resample(squeeze(Tall{x}.Data.segmentedEcog.zscore_separate(c,:,:,tr)),1,4),10);
        end
    end
end
T=Tall{2}

%% Ave over 50 ms seg
sidx=1;
for x=[2 5]
    for s=1:5:200-5    
        Tall{x}.Data.segmentedEcog.ave50ms(:,sidx,:)=squeeze(mean(Tall{x}.Data.segmentedEcog.smoothed100(:,(s:s+5)+200,:,:),2))
        sidx=sidx+1;
    end
end
T=Tall{2}

%% Ave over 100 ms seg
sidx=1;
for x=[2 5]
    for s=1:10:200-10    
        T.Data.segmentedEcog.ave100ms(:,sidx,:)=squeeze(mean(T.Data.segmentedEcog.smoothed100(:,(s:s+10)+100,:,:),2))
        sidx=sidx+1;
    end
end
T=Tall{2}
%% SMOOTH DATA
clear D pc dat D_sm B_sm
D=squeeze(T.Data.segmentedEcog.zscore_separate(usechan,usesamp,:,:));
B=squeeze(T.Data.segmentedEcog.zscore_separate(usechan,201:800,:,:));
L=1:length(usetr);
D_sm=zeros(length(usechan),length(usesamp),length(L));
B_sm=D_sm;
for ch=1:length(usechan)
    for tr=1:length(L)
        D_sm(ch,:,tr)=smooth(D(ch,:,tr),10);
        %B_sm(ch,:,tr)=smooth(B(ch,:,tr),10);
    end
end
%%
%%%%%%%%%%%%%%%%%%%%%%
%DISTANCES: ALL ECOG
%%%%%%%%%%%%%%%%%%%%%%

%% DISTANCE OF CHANNELS BETWEEN TRIALS
badtr=[6 12 17 20 24 29 41 45]
tr=setdiff(1:size(D_sm,3),badtr)
p=pdist(squeeze(mean(D_sm(:,:,tr),2))')
figure
imagesc(squareform(p),[0 10])
set(gca,'YTick',1:length(usetr))
set(gca,'YTickLabel',Labels)

%% MDS SPACE
figure
x=mdscale(squareform(p),3);
scatter3(x(:,1),x(:,2),x(:,3),'filled')
text(x(:,1),x(:,2),x(:,3),T.Data.segmentedEcog.event(usetr(tr),8))
gscatter3(x(:,1),x(:,2),x(:,3),wordProp.ed)
figure
x=mdscale(squareform(p),2);
scatter(x(:,1),x(:,2),'filled')
text(x(:,1),x(:,2),T.Data.segmentedEcog.event(usetr,8))
gscatter(x(:,1),x(:,2),wordProp.rp',[rgb('red');rgb('lightblue')])

%%
p=pdist(squeeze(mean(T.Data.segmentedEcog.ave50ms(:,:,1:end),2))');
imagesc(squareform(p))


%% DISTANCE OF CHANNELS BETWEEN TRIALS
figure
samps=1:50:600;
for t=1:length(samps)-1
    p=pdist(squeeze(mean(D_sm(:,samps(t):samps(t+1),tr),2))');
    opts = statset('MaxIter',200);
    distTime(t).x=mdscale(squareform(p),2,'Options',opts); 
    distTime(t).p=p;
end

for t=1:length(samps)-1
    subplot(5,8,t)
    imagesc(squareform(distTime(t).p),[0 25])
end
%%
%[~,sidx]=sort([wordProp.f{tr}])
grp=grp2idx(wordProp.ed(tr))
[~,sidx]=sort(grp)

colorjet=jet
figure
coord=cat(3,distTime(1:length(samps)-1).x)
for n=1:length(samps)-1
    %scatter3(squeeze(coord(sidx,1,n)),squeeze(coord(sidx,2,n)),squeeze(coord(sidx,3,n)),100,colorjet(round(linspace(1,64,length(tr))),:),'filled')
    %hold on
    %plot3(squeeze(coord(:,1,n)),squeeze(coord(:,2,n)),squeeze(coord(:,3,n)),'Color',colorjet(n*2,:))
    %text(squeeze(coord(:,1,n)),squeeze(coord(:,2,n)),squeeze(coord(:,3,n)),T.Data.segmentedEcog.event(usetr(tr),8))
    gscatter(squeeze(coord(sidx,1,n)),squeeze(coord(sidx,2,n)),grp(sidx),[rgb('blue');rgb('red')])
    %text(squeeze(coord(:,1,n)),squeeze(coord(:,2,n)),T.Data.segmentedEcog.event(usetr(tr),8))

    %hold on
    %if n==11
        
    %end
    input('n')

end
%%
colorjet=jet
figure
coord=cat(3,distTime(1:length(samps)-1).x)
for n=1:length(tr)
    %scatter3(squeeze(coord(n,1,:)),squeeze(coord(n,2,:)),squeeze(coord(n,3,:)),100,colorjet(round(linspace(1,64,length(samps)-1)),:),'filled')
    scatter(squeeze(coord(n,1,:)),squeeze(coord(n,2,:)),100,colorjet(round(linspace(1,64,length(samps)-1)),:),'filled')

    hold on
    %plot3(squeeze(coord(n,1,:)),squeeze(coord(n,2,:)),squeeze(coord(n,3,:)),'LineWidth',4)
    plot(squeeze(coord(n,1,:)),squeeze(coord(n,2,:)),'LineWidth',4)

    grid on
    %scatter(squeeze(coord(n,1,:)),squeeze(coord(n,2,:)),100,colorjet(round(linspace(1,64,39)),:),'filled')
    %hold on
    title(T.Data.segmentedEcog.event(usetr(tr(n)),8))
    set(gca,'XLim',[-7 7],'YLim',[-4 4],'ZLim',[-4 4])
    input('n')
    hold off
end




%% DISTANCE OF CHANNELS BETWEEN TRIALS
for t=1:size(T.Data.segmentedEcog.ave50ms,2)
    p=pdist(squeeze(T.Data.segmentedEcog.ave50ms(:,t,tr))');
    opts = statset('MaxIter',1000);
    distTime(t).x=mdscale(squareform(p),3,'Options',opts); 
    distTime(t).p=p;
end
%% PLOT DISTANCE MATRICES OVER TIME
for t=1:size(T.Data.segmentedEcog.ave50ms,2)
    subplot(5,8,t)
    imagesc(squareform(distTime(t).p),[0 25])
end

%%
colorjet=jet
figure
coord=cat(3,distTime.x)
for n=1:length(tr)
    scatter3(squeeze(coord(n,1,:)),squeeze(coord(n,2,:)),squeeze(coord(n,3,:)),100,colorjet(round(linspace(1,64,39)),:),'filled')
    %scatter(squeeze(coord(n,1,:)),squeeze(coord(n,2,:)),100,colorjet(round(linspace(1,64,39)),:),'filled')
    hold on
    %input('n')
end
%%
colorjet=jet
figure
coord=cat(3,distTime.x)
for t=1:39
    %scatter3(squeeze(coord(n,1,:)),squeeze(coord(n,2,:)),squeeze(coord(n,3,:)),100,colorjet(round(linspace(1,64,39)),:),'filled')
    scatter(distTime(t).x(:,1),distTime(t).x(:,2),100,colorjet(round(linspace(1,64,51)),:),'filled')
    %hold on
    input('n')
end

%%
    
%%
%%%%%%%%%%%%%%%%%%%%%%
%PSEUDOWORD EFFECTS
%%%%%%%%%%%%%%%%%%%%%%

%% GET PSEUDO vs REAL INDICES
indices=T.Data.findTrials('6','n','n')
idx1=find(ismember(usetr,indices.cond1));%Real
idx2=find(ismember(usetr,indices.cond2));%Pseudo

%Get matching real and psuedo words
ii=1
clear realIdx psIdx
for i=1:length(idx1)
    realW=Labels(idx1(i))
    idx=find(strcmp(realW,wordpairs(:,1)))
    psW=wordpairs(idx,2);
    if ~isempty(psW) & find(strcmp(psW,Labels))
        realIdx(ii)=idx1(i);
        psIdx(ii)=find(strcmp(psW,Labels))
        ii=ii+1;
    end
end
%% T-TEST BETWEEN PSEUDO AND REAL MATCHING WORDS
for c=1:length(usechan)
    for s=1:10:length(usesamp)-10
        samp=s;
        [h(c,s),p(c,s)]=ttest(mean(D_sm(c,samp+10,realIdx),2),mean(D_sm(c,samp+10,psIdx),2),0.05);
    end
end
dd=cumsum(h,2);
d=zeros(1,256);
d(usechan)=dd(:,end);
imagesc(reshape(d,16,16))
visualizeGrid(1,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan,dd(:,end)');

%% PLOT T-TEST RESULTS
idx=1
figure
for  s=1:25:length(usesamp)
    subplot(5,8,idx)
    hold on
    d=sum(h(:,s:s+25),2)';
    d2=zeros(1,256);
    d2(usechan)=d;
    dz=d2;
    imagesc(flipud(reshape(dz,16,16)'),[0 5])
    axis tight
    %visualizeGrid(1,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan,dz);
    %axis([200 1300 100 1000])
    title(usesamp(s))
    idx=idx+1;
end
%% PLOT DATA of real vs pseudo matched words
figure
for i=1:256
    plotGridPosition(i);
    hold on
    errorarea(squeeze(mean(T.Data.segmentedEcog.zscore_separate(i,:,1,realIdx),4)),squeeze(ste(T.Data.segmentedEcog.zscore_separate(i,:,1,realIdx),4)))
    hold on    
    [hl,hp]=errorarea(squeeze(mean(T.Data.segmentedEcog.zscore_separate(i,:,1,psIdx),4)),squeeze(ste(T.Data.segmentedEcog.zscore_separate(i,:,1,psIdx),4)))
    set(hl,'Color','r')
    set(hp,'FaceColor','r')
    axis([0 1600 -3 5])
   % plot(squeeze(mean(T.Data.segmentedEcog.zscore_separate(i,:,1,realIdx),4))-squeeze(mean(T.Data.segmentedEcog.zscore_separate(i,:,1,psIdx),4)))
end
%%

%% TTEST Real VS Pseudo LISTENING PLOTTING
chPlot=[85 101 118 244 211]
%figure
for c=1:256
    [t,p]=ttest2([squeeze(T.Data.segmentedEcog.smoothed100(c,usesamps,:,realIdx))]',...
        [squeeze(T.Data.segmentedEcog.smoothed100(c,usesamps,:,psIdx))]',.01,'both','equal');
    
    
    
    tIdx=find(t);
    [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);

    
    errorarea(mean([squeeze(T.Data.segmentedEcog.smoothed100(c,usesamps,:,realIdx))],2),ste([squeeze(T.Data.segmentedEcog.smoothed100(c,usesamps,:,realIdx))],2))
    hold on
    [hl,hp]=errorarea(mean([squeeze(T.Data.segmentedEcog.smoothed100(c,usesamps,:,psIdx))],2),ste([squeeze(T.Data.segmentedEcog.smoothed100(c,usesamps,:,psIdx))],2))
    set(hp,'FaceColor','r');set(hl,'Color','r')

    try
        hl=line([tIdx(find(h_fdr)); tIdx(find(h_fdr))],[mean([squeeze(T.Data.segmentedEcog.smoothed100(c,tIdx(find(h_fdr))+199,:,realIdx))],2), mean([squeeze(T.Data.segmentedEcog.smoothed100(c,tIdx(find(h_fdr))+199,:,psIdx))],2)]')
        set(hl,'Color','k')
    end
    axis([0 200 -1 7])
    title(int2str(c))    
    %r=input('n','s')
    if ~strcmp(r,'n')
        keep(c)=1;
    end
    electrodes(c).RealPseudoTTest=zeros(1,200);
    electrodes(c).RealPseudoTTest(tIdx(find(h_fdr)))=1;  
    saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    clf
end

%% Ave over 50 ms seg
sidx=1;
for s=1:5:200-5    
    T.Data.segmentedEcog.ave50ms(:,sidx,:)=squeeze(mean(T.Data.segmentedEcog.smoothed100(:,(s:s+5)+200,:,:),2))
    sidx=sidx+1;
end
%% T-Test ON DATA THAT'S BEEN AVERAGED EVERY 50 MS
for c=1:256
    [t,p]=ttest2([squeeze(T.Data.segmentedEcog.ave50ms(c,:,realIdx))]',...
        [squeeze(T.Data.segmentedEcog.ave50ms(c,:,psIdx))]',.01,'both','equal');
    tIdx=find(t);
    [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);  
    electrodes(c).RealPseudoTTest_50ms=zeros(1,length(t));
    electrodes(c).RealPseudoTTest_50ms(tIdx(find(h_fdr)))=1;  
end

%% plot T-Test significant channels over time
%figure
tOut=vertcat(electrodes.RealPseudoTTest_50ms);
chidx=find(sum(tOut,2)>2);
time=[1:50:2000]
for s=1:length(t)     
    visualizeGrid(5,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],chidx,sum(tOut(chidx,s),2))
    title(int2str(time(s)))
    saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    %input('n')
end
%%

visualizeGrid(5,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],chidx,sum(tOut(chidx,s:s+20),2))

%% CLASSIFY PSEUDO VS REAL
usetr2=[realIdx psIdx]
group=grp2idx(wordProp.rp(usetr2));
figure
sidx=1
for s=1:50:length(usesamp)-100
    for i=1:20
        %%
        clear tmp2
        testIdx=ceil(rand(1,round(length(usetr2)*.8))*length(usetr2));
        trainIdx=setdiff(1:length(usetr2),testIdx);
        tmp=permute(D_sm(:,s:s+100,usetr2),[3 1 2]);
        for j=1:length(usetr2)
           tmp3=dct(squeeze(tmp(j,:,:)));
           tmp2(j,:,:)=tmp3(:,1:3);
        end
        tmp2=max(tmp,[],3);
        D=reshape(tmp2,length(usetr2),[]);

        [bestc, bestg, bestcv, model, predicted_label, accuracy, decision_values] =...
            svm(D(trainIdx,:), group(trainIdx),D(testIdx,:),group(testIdx));
        svmOut(i).bestc=bestc;
        svmOut(i).bestg=bestg;
        svmOut(i).bestcv=bestcv;
        svmOut(i).model=model;
        svmOut(i).predicted_label=predicted_label;
        svmOut(i).accuracy=accuracy(1);
        svmOut(i).decision_values=decision_values;
        svmOut(i).testIdx=testIdx;
        svmOut(i).actual_label=group(testIdx);
    end
    subplot(4,5,sidx)
    plot([svmOut.accuracy])
    hist([svmOut.accuracy])
    title([usesamp(s)  mean([svmOut.accuracy])])
    sidx=sidx+1;
end
%%

%%%%%%%%%%%%%%%%%%%%%%
%WORD LENGTH EFFECTS
%%%%%%%%%%%%%%%%%%%%%%

%% PARTIAL CORRELATION CHANNELS: Length with Freq Correlation Removed
sidx=1
for s=1:25:length(usesamp)-25
    for c=1:length(usechan)
        ecog=squeeze(mean(mean(D_sm(c,s:s+25,idx1),2),1));
        [R,p]=partialcorr([ecog cell2mat(wordProp.l(idx1))'],cell2mat(wordProp.f(idx1))','type','Spearman');
        Rall.R(c,sidx)=R(1,2);
        Rall.p(c,sidx)=p(1,2);
    end
    sidx=sidx+1;
end
%%
figure
c=find(usechan==247)
[~,idx]=sort(cell2mat(wordProp.l))
d1=squeeze(mean(mean(D_sm(c,:,idx1),1),1))
imagesc(d1(:,idx)')
title(int2str(usechan(c)))
%% PARTIAL CORRELATION CHANNELS: Frequency with Length Effects Removed
%{
sidx=1
for s=1:25:length(usesamp)-25
    for c=1:length(usechan)
        ecog=squeeze(mean(mean(D_sm(c,s:s+25,idx1),2),1));
        [R,p]=partialcorr([ecog cell2mat(wordProp.f(idx1))'],cell2mat(wordProp.l(idx1))','type','Spearman');
        Rall.R(c,sidx)=R(1,2);
        Rall.p(c,sidx)=p(1,2);
    end
    sidx=sidx+1;
end
%}
%% plot significant correlation for time segments
figure
sidx=1
for s=1:25:length(usesamp)-25
    %subplot(5,8,sidx)
    idx=find(Rall.p(:,sidx)<=0.05 & Rall.R(:,sidx).^2>=.16);
    d=zeros(1,256);
    d(usechan(idx'))=Rall.R(idx,sidx);
    imagesc(reshape(d,16,16)',[-1 1])
   labelGridOnMatix
    %visualizeGrid(2,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],find(d.^2>0));
    %visualizeGrid(1,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],1:256,d);
    title(usesamp(s))
    sidx=sidx+1;
    input('n')
    
end
%% PLOT R and p-values OVER TIME
figure
for c=1:length(usechan)
    plotGridPosition(usechan(c));
    errorarea(Rall.R(c,:),Rall.p(c,:));
end

%% TTEST SHORT VS LONG
choice=1
eidx=2
ind{eidx}=Tall{eidx}.Data.findTrials(int2str(choice),'y','n')
fieldNames={'ShortLongTTest_50ms','EasyDifficult_50ms','Frequency_50ms'}
%% T-Test ON DATA THAT'S BEEN AVERAGED EVERY 50 MS
for c=1:256
    [t,p]=ttest2([squeeze(Tall{eidx}.Data.segmentedEcog.ave50ms(c,:,ind{eidx}.cond1))]',...
        [squeeze(Tall{eidx}.Data.segmentedEcog.ave50ms(c,:,ind{eidx}.cond2))]',.01,'both','equal');
    tIdx=find(t);
    [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);  
    electrodes(c).(fieldNames{choice})=zeros(1,length(t));
    electrodes(c).(fieldNames{choice})(tIdx(find(h_fdr)))=1;  
end
%% plot T-Test significant channels over time
figure
tOut=vertcat(electrodes.(fieldNames{choice}));
chidx=find(sum(tOut,2)>2);
time=[1:50:2000]
for s=1:length(t)     
    visualizeGrid(5,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],chidx,sum(tOut(chidx,s),2))
    title(int2str(time(s)))
    %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    input('n')
end
%%
%%
figure
for c=1:256
    [t,p]=ttest2([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond1))]',...
        [squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))]',.01,'both','equal');
    tIdx=find(t);
    [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);

    
    errorarea(mean([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond1))],2),ste([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond1))],2))
    hold on
    [hl,hp]=errorarea(mean([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))],2),ste([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))],2))
    set(hp,'FaceColor','r');set(hl,'Color','r')

    try
        hl=line([tIdx(find(h_fdr)); tIdx(find(h_fdr))],[mean([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,tIdx(find(h_fdr))+199,:,ind{1}.cond1))],2), mean([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,tIdx(find(h_fdr))+199,:,ind{1}.cond2))],2)]')
        set(hl,'Color','k')
    end
    axis([0 200 -1 5])
    title(int2str(c))    
    r=input('n','s')
    if ~strcmp(r,'n')
        keep(c)=1;
    end
    electrodes(c).ActivePassiveTTest=zeros(1,200);
    electrodes(c).ActivePassiveTTest(tIdx(find(h_fdr)))=1;  
    %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    clf
end




%% CLASSIFY WORD LENGTH
usetr2=idx1;
group=grp2idx(cell2mat(wordProp.l));
group=grp2idx(wordProp.ed);

%%
figure
sidx=1
for s=1:50:length(usesamp)-100
    for i=1:20
        %%
        clear tmp2
        testIdx=ceil(rand(1,round(length(usetr2)*.8))*length(usetr2));
        trainIdx=setdiff(1:length(usetr2),testIdx);
        tmp=permute(D_sm(:,s:s+100,usetr2),[3 1 2]);
        for j=1:length(usetr2)
           tmp3=dct(squeeze(tmp(j,:,:)));
           tmp2(j,:,:)=tmp3(:,1:3);
        end
        tmp2=max(tmp,[],3);
        D=reshape(tmp2,length(usetr2),[]);

        [bestc, bestg, bestcv, model, predicted_label, accuracy, decision_values] =...
            svm(D(trainIdx,:), group(trainIdx),D(testIdx,:),group(testIdx));
        svmOut(i).bestc=bestc;
        svmOut(i).bestg=bestg;
        svmOut(i).bestcv=bestcv;
        svmOut(i).model=model;
        svmOut(i).predicted_label=predicted_label;
        svmOut(i).accuracy=accuracy(1);
        svmOut(i).decision_values=decision_values;
        svmOut(i).testIdx=testIdx;
        svmOut(i).actual_label=group(testIdx);
    end
    subplot(4,5,sidx)
    plot([svmOut.accuracy])
    hist([svmOut.accuracy])
    title([usesamp(s)  mean([svmOut.accuracy])])
    sidx=sidx+1;
end
%% CORRELATION TO ACOUSTIC ENV
for i=1:length(usetr)
    tmp=abs(hilbert(squeeze(T.Data.segmentedEcog.analog24Hz(1,:,1,usetr(i)))));
    tmp2=resample(tmp,400,round(2.4414e+004));
    anEnv(i,:)=tmp2(usesamp);
end

%% XCORR TO ACOUSTIC ENV
a=anEnv;
for c=1:length(usechan)
    d=squeeze(D_sm(c,:,:))';
    for tr=1:size(D_sm,3)
        tmp=xcorr2(d(tr,:),a(tr,:));
        Rword.xR(c,:,tr)=tmp;
    end
end
%% PLOT XCORR OF ACOUSTIC TO ECOG
figure
for c=1:length(usechan)
    plotGridPosition(usechan(c));
    [~,idx]=sort(cell2mat(wordProp.l(idx1)));
    imagesc(squeeze(Rword.xR(c,:,[idx1(idx) idx2]))',[0 50])
    axis tight
end
%% PLOT PEAK OF XCORR
figure
Rword.pk=zeros(1,256);
for c=1:length(usechan)
    [maxXR,idx]=max(squeeze(Rword.xR(c,:,:))',[],2);
    if 1% mean(maxXR>10)
        Rword.pk(usechan(c))=mean(maxXR);
    end
end
imagesc(reshape(Rword.pk,[16,16])')
labelGridOnMatix
%% Partial Corr of Word Length to Max XCorr of acoustic to ecog
figure
Rword.wL=zeros(1,256)
for c=1:length(usechan)
    [maxXR,idx]=max(squeeze(Rword.xR(c,:,:))',[],2);
    [tmp,p]=partialcorr([idx(idx1),cell2mat(wordProp.l(idx1))'],cell2mat(wordProp.f(idx1))','Type','Spearman');
    Rword.wL(usechan(c))=tmp(1,2);
    Rword.p(usechan(c))=p(1,2);
end
wL=Rword.wL;
wL(Rword.p>.01)=0;
imagesc(reshape(wL,16,16)')
%visualizeGrid(5,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],1:256,wL);
%% T-Test over time to find activated electrodes
for c=1:256
    t(c)=ttest2(squeeze(mean(T.Data.segmentedEcog.zscore_separate(c,801:1200,:,:),4))',squeeze(mean(T.Data.segmentedEcog.zscore_separate(c,1:800,:,:),4))',0.01);
end
figure
for c=1:256
    if t(c)==1
        plotGridPosition(c);
        plot(squeeze(mean(T.Data.segmentedEcog.zscore_separate(c,:,:,:),4)))
    end
end
%%
for c=1:length(usechan)
    for s=1:4000    
        tresult(c,s)=ttest(squeeze(T.Data.segmentedEcog.zscore_separate(usechan(c),s,:,:)));
    end
end
%%
figure
for c=1:10
    %if t(c)==1
        plotGridPosition(usechan(c));
        plot(squeeze(mean(T.Data.segmentedEcog.zscore_separate(usechan(c),:,:,:),4)))
        hold on
        idx=find(tresult(c,:)==1);
        if ~isempty(idx)
            plot(idx,1,'r.')
        end
    %end
end
%% CORR BETWEEN MOTOR SITES AND OTHER ELECTRODES
seedch=find(ismember(usechan,[247]))
%[kgroup2,c]=kmeans(mean(D_sm,3),length(seedch),'Distance','correlation','Start',mean(D_sm(seedch,:,:),3),'EmptyAction','drop');
%seedch=find(usechan==102)
meanC=mean(squeeze(D_sm(seedch,:,:)),2)
for c=1:length(usechan)
    for tr=1:size(D_sm,3)
        %[tmp,p]=corrcoef(zscore(squeeze(D_sm(seedch,1:400,tr))),zscore(squeeze(D_sm(c,1:400,tr))));
        [tmp,p]=corrcoef(zscore(squeeze(mean(D_sm(seedch,:,tr),3)))',zscore(squeeze(mean(D_sm(c,:,tr),3)))');

        Rall.motor(c,tr)=tmp(1,2);
        Rall.motorp(c,tr)=p(1,2); 
    end
end
%%
Rall.mean=mean(Rall.motor,2);
Rall.meanp=mean(Rall.motorp,2);
d=zeros(1,256);
p=prctile(Rall.mean,90)

for c=1:length(usechan)
    if Rall.meanp(c)<=0.05 & Rall.mean(c)>p
        d(usechan(c))=Rall.mean(c);
    end
end
figure
%visualizeGrid(1,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],1:256,d);
visualizeGrid(2,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],find(d));

%imagesc(reshape(d,16,16)')
%%
figure
c=find(ismember(usechan,find(d)))
plot(mean(D_sm(c,:,:),3)','LineWidth',3)
 legend(cellfun(@num2str,(num2cell(find(d))),'UniformOutput',0))
 %%
 %%
figure
c=find(ismember(usechan,find(d)))
for i=1:length(c)
   plot(squeeze(D_sm(c(3),:,:)),'LineWidth',3)
end
%%
figure
[~,idx]=sort(cell2mat(wordProp.l))
for c=1:length(usechan)
    plotGridPosition(usechan(c));
    imagesc(squeeze(T.Data.segmentedEcog.zscore_separate(c,:,:,idx))')
    axis tight
end

