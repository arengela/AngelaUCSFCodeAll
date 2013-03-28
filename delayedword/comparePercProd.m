%% EC23
Tall{2}=PLVTests(10,2,1:256,'aa')
Tall{3}=PLVTests(10,2,1:256,'aa')
Tall{4}=PLVTests(10,4,1:256,'aa')
Tall{5}=PLVTests(10,5,1:256,'aa')


%% EC28
Tall{2}=PLVTests(34,2,1:256,'aa')
Tall{5}=PLVTests(34,5,1:256,'aa')
%%
%% EC28
Tall{2}=PLVTests(34,2,1:256,'aa')
Tall{5}=PLVTests(34,5,1:256,'aa')
%% EC18
Tall{2}=PLVTests(1,2,1:256,'aa')
Tall{5}=PLVTests(1,5,1:256,'aa')
%% EC22
Tall{2}=PLVTests(9,2,1:256,'aa')
Tall{5}=PLVTests(9,5,1:256,'aa')
%% EC24
Tall{2}=PLVTests(9,2,1:256,'aa')
Tall{5}=PLVTests(9,5,1:256,'aa')
%% EC16
Tall{2}=PLVTests(9,2,1:256,'aa')
Tall{5}=PLVTests(9,5,1:256,'aa')
%%
brainFile='C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\'
%% DELETE BAD TRIALS
eidx=2
badtr=16
Tall{eidx}.Data.Params.badtr=badtr
Tall{eidx}.Data.segmentedEcog.zscore_separate(:,:,:,badtr)=[];
Tall{eidx}.Data.segmentedEcog.data(:,:,:,badtr)=[];
Tall{eidx}.Data.segmentedEcog.event(badtr,:)=[];

%% SMOOTH AND DOWNSAMPLE TO 100 Hz
usesamps=[1:400]
for x=[2 5]
    for c=1:256
        for tr=1:size(Tall{x}.Data.segmentedEcog.zscore_separate,4)
            Tall{x}.Data.segmentedEcog.smoothed100(c,:,:,tr)=smooth(resample(squeeze(Tall{x}.Data.segmentedEcog.zscore_separate(c,:,:,tr)),1,4),20);
        end
    end
end
%% GET ACTIVE ELECTRODES FOR PERC AND PROD
usesamps=[100:300]
chTot=size(Tall{2}.Data.segmentedEcog.smoothed100,1);
for eidx=[2 5 ]
    indices=Tall{eidx}.Data.findTrials('1','n','n')
    indicesB=Tall{2}.Data.findTrials('1','n','n')
    for c=1:chTot
        [t,p]=ttest2(squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2))',...
            repmat(squeeze(mean(Tall{2}.Data.segmentedEcog.smoothed100(c,1:200,:,indicesB.cond2),2)),1,length(usesamps)),.01,'right','unequal');
        tIdx=find(t);
        [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);
        t=zeros(1,length(t));
        t(tIdx(find(h_fdr)))=1;
        E{eidx}.electrodes(c).activeTTest=t;
    end
    tOut=vertcat(E{eidx}.electrodes.activeTTest)
    tmp{eidx}=find(sum(tOut,2)>25 & sum(tOut,2)<200 );
    Tall{eidx}.Data.Params.activeCh=tmp{eidx};
end
activeCh=unique([tmp{2}' tmp{5}'])
%figure
%visualizeGrid(2,[brainFile Tall{2}.Data.patientID '\brain.jpg'],activeCh)
%%

%% GET PEAK, START, END END OF ACTIVITY TIMES; PLOT EACH CHANNEL
for eidx=[2 5]
    %%
    indices=Tall{eidx}.Data.findTrials('1','n','n')
    indicesB=Tall{2}.Data.findTrials('1','n','n')
    for c=1:256
        if ismember(c,activeCh)
            [t,p]=ttest2([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2))]',...
                repmat(squeeze(mean(Tall{2}.Data.segmentedEcog.smoothed100(c,1:200,:,indicesB.cond2),2)),1,length(usesamps)),.01,[],'unequal');
            tIdx=find(t);
            [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.05);
            t=zeros(1,length(t));
            t(tIdx(find(h_fdr)))=1;
            if eidx==2
                t(1:100)=0;
            end
            errorarea(mean([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,indices.cond2))],2),ste([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,indices.cond2))],2))
            hold on
            %[hl,hp]=errorarea(mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,:,:,indicesB.cond2))],2),ste([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,:,:,indicesB.cond2))],2))
            %set(hl,'Color','r');set(hp,'FaceColor','r')
            try
                plot(find(t)+usesamps(1),1,'.')
            end
            title(int2str(c))
            
            electrodes(c).TTest=t;
            if sum(electrodes(c).TTest)>10
                [electrodes(c).maxAmp,electrodes(c).peakIdx]=max(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2),4),[],2);
                electrodes(c).startTime=(find(t,1,'first'))/100*1000;
                electrodes(c).stopTime=(find(t,1,'last'))/100*1000;
                [electrodes(c).maxAmp,electrodes(c).peakIdx]=max(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps(1)+(find(electrodes(c).TTest,1):find(electrodes(c).TTest,1,'last')),:,indices.cond2),4));
                electrodes(c).peakTime=((electrodes(c).peakIdx+find(electrodes(c).TTest,1))/100)*1000;
                
            else
                electrodes(c).maxAmp=100000;
                electrodes(c).peakIdx=100000;
                electrodes(c).startTime=100000;
                electrodes(c).stopTime=100000;
                electrodes(c).peakTime=100000;
            end
            try
                line([(electrodes(c).startTime/1000)*100+usesamps(1) (electrodes(c).startTime/1000)*100+usesamps(1)],[0 5])
                line([(electrodes(c).peakTime/1000)*100+usesamps(1) (electrodes(c).peakTime/1000)*100+usesamps(1)],[0 5])
            end
            %r=input('n','s')
            r='y'
            if ~strcmp(r,'n') & ~strcmp(r,'g')
                keep(c)=1;
            elseif strcmp(r,'g')
                [x,y]=ginput(2);
                d=find(electrodes(c).TTest)
                didx=findNearest(x(1),d);
                electrodes(c).startTime=(d(didx)/100)*1000;
                d=find(electrodes(c).TTest)
                didx=findNearest(x(2),d);
                electrodes(c).startTime=(d(didx)/100)*1000;
            else
                keep(c)=0
                electrodes(c).maxAmp=100000;
                electrodes(c).peakIdx=100000;
                electrodes(c).startTime=100000;
                electrodes(c).stopTime=100000;
                electrodes(c).peakTime=100000;
            end
            clf
        else
            electrodes(c).maxAmp=100000;
            electrodes(c).peakIdx=100000;
            electrodes(c).startTime=100000;
            electrodes(c).stopTime=100000;
            electrodes(c).peakTime=100000;
            t=zeros(1,length(t));
            electrodes(c).TTest=t;
        end
    end
    E{eidx}.electrodes=electrodes;
end
%% GET RELEVANT ELECTRODES
eidx=5;
figure
electrodes=E{2}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)
ch1=find(pkTime~=100000 & pkTime>700 & pkTime<2000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels) & [electrodes.startTime]<1500 & ...
    sum(vertcat(electrodes.TTest),2)'>30)
electrodes=E{5}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)
ch2=find(pkTime~=100000 & pkTime>700 & pkTime<2000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels) & [electrodes.startTime]<1500 & ...
    sum(vertcat(electrodes.TTest),2)'>30)
ch=[ch1 ch2];
[~,s]=sort(pkTime(ch));


electrodes=E{eidx}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)

%% PLOT PERC AND PRODUCTION DATA VERTICALLY
% SORTED BY PRODUCTION PEAK TIME
eidx=5;
electrodes=E{eidx}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)
ch=find(pkTime~=100000 & pkTime>700 & pkTime<2000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels) & [electrodes.startTime]<1500 & ...
    sum(vertcat(electrodes.TTest),2)'>30)
ch=activeCh
figure
colorjet=hot.*repmat(rgb('gold'),length(jet),1)
%colorjet=colormap(gray.*autumn)
%colorjet=flipud(jet)
%colorjet=(hot.*(copper))

[~,s]=sort(pkTime(ch));
%extremeRange=linspace(min(pkTime(ch)),max(pkTime(ch)),64)
extremeRange=linspace(500,2000,64);
vertShift=fliplr((1:length(s))./2);
for i=1:length(s)
    subplot('Position',[.55 0 .45 .9])
    if ismember(ch(s(i)),Tall{5}.Data.Params.activeCh)
        idx=findnearest(pkTime(ch(s(i))),extremeRange)
        data=mean([squeeze(Tall{5}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indices.cond2))],2);
        hold on
        hl=plot(data+vertShift(i),'Color',colorjet(idx,:),'LineWidth',2)
        set(gca,'Box','off')
        set(gca,'Visible','off')
        hl=line([200 200],[-1 max(vertShift)])
        set(hl,'Color',rgb('gray'),'LineStyle','--')
    else 
        data=mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
         hl=plot(data+vertShift(i),'Color',rgb('lightgray'),'LineWidth',2)
    end
            axis tight

    subplot('Position',[.05 0 .45 .9])   
    if ismember(ch(s(i)),Tall{2}.Data.Params.activeCh)
        idx=findnearest(E{2}.electrodes(ch(s(i))).peakTime,extremeRange)
        data=mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
        hl=plot(data+vertShift(i),'Color',colorjet(idx,:),'LineWidth',2)
        hold on
        hl=line([200 200],[-1 max(vertShift)])
        set(gca,'Box','off')
        set(gca,'Visible','off')
        set(hl,'Color',rgb('gray'),'LineStyle','--')
    else 
        data=mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
         hl=plot(data+vertShift(i),'Color',rgb('lightgray'),'LineWidth',2)
    end
    text(-40,data(1)+vertShift(i),int2str(ch(s(i))),'FontSize',8','Color',rgb('gray'))
            axis tight

        
end
set(gcf,'Position',[1039 70 497 841],'Color','w')

%% PLOT PERC AND PRODUCTION DATA VERTICALLY
% SORTED BY PRODUCTION PEAK TIME
% ALL CHANNELS GRAY EXCEPT FOR ONES NEAR STIM SITES
eidx=5;
electrodes=E{eidx}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)
figure
colorjet=jet.*repmat([.8 .8 .8],length(jet),1)
colorjet=colormap(autumn.*copper)
colorjet=flipud(jet)
colorjet=hot.*repmat(rgb('gold'),length(jet),1)

[~,s]=sort(pkTime(ch));
%extremeRange=linspace(min(pkTime(ch)),max(pkTime(ch)),64)
extremeRange=linspace(900,2000,64);
vertShift=fliplr((1:length(s))./1);
set(gcf,'Color','w')
for i=1:length(s)
    %subplot(1,2,2)
    subplot('Position',[.55 0 .45 .9])

    if 1%ismember(ch(s(i)),Tall{5}.Data.Params.activeCh)
        idx=findnearest(pkTime(ch(s(i))),extremeRange)
        data=mean([squeeze(Tall{5}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indices.cond2))],2);
        hold on
       if ismember(ch(s(i)),[Tall{2}.Data.Params.stimSites(1).ch])
            hl=plot(data+vertShift(i),'Color',rgb('red'),'LineWidth',2)
        %elseif ismember(ch(s(i)),[Tall{2}.Data.Params.stimSites(2).ch])
            hl=plot(data+vertShift(i),'Color',rgb('purple'),'LineWidth',2)            
        else
            hl=plot(data+vertShift(i),'Color',rgb('lightgray'),'LineWidth',2)
        end

        set(gca,'Box','off')
        set(gca,'Visible','off')
        hl=line([200 200],[-1 max(vertShift)])
        set(hl,'Color',rgb('gray'),'LineStyle','--')
        axis tight

    end
    if 1%ismember(ch(s(i)),Tall{2}.Data.Params.activeCh)
        %subplot(1,2,1)
        subplot('Position',[.05 0 .45 .9])
        idx=findnearest(E{2}.electrodes(ch(s(i))).peakTime,extremeRange)
        data=mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
        
        if ismember(ch(s(i)),[Tall{2}.Data.Params.stimSites(1).ch])
            hl=plot(data+vertShift(i),'Color',rgb('red'),'LineWidth',2)
        %elseif ismember(ch(s(i)),[Tall{2}.Data.Params.stimSites(2).ch])
            hl=plot(data+vertShift(i),'Color',rgb('purple'),'LineWidth',2)            
        else
            hl=plot(data+vertShift(i),'Color',rgb('lightgray'),'LineWidth',2)
        end
        hold on
        hl=line([200 200],[-1 max(vertShift)])
        set(gca,'Box','off')
        set(gca,'Visible','off')
        set(hl,'Color',rgb('gray'),'LineStyle','--')
        text(-40,data(1)+vertShift(i),int2str(ch(s(i))),'FontSize',8','Color',rgb('gray'))
        axis tight

    end
end
set(gcf,'Position',[1039 70 497 841])

%% PLOT STIM SITES
figure
visualizeGrid(2,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],intersect(ch,Tall{2}.Data.Params.stimSites(1).ch),[],[],[],[],rgb('red'),1)
visualizeGrid(2,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],intersect(ch,Tall{2}.Data.Params.stimSites(2).ch),[],[],[],[],rgb('purple'),0)


%% PLOT MEAN FOR INDIVIDUAL ELECTRODES VERTICALLY
figure
eidx=2
colorjet=jet.*repmat([.8 .8 .8],length(jet),1)
colorjet=colormap(autumn.*copper)
[~,s]=sort(pkTime(ch));
extremeRange=linspace(min(pkTime(ch)),max(pkTime(ch)),64)
vertShift=fliplr((1:length(s))./2);
indices=Tall{eidx}.Data.findTrials('1','n','n')
for i=1:length(s)
    idx=findnearest(pkTime(ch(s(i))),extremeRange)
    data=mean([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(ch(s(i)),usesamps,:,indices.cond2))],2);
    hl=plot(data+vertShift(i),'Color',colorjet(idx,:),'LineWidth',2)
    %p = patchline(1:length(data),data+vertShift(i),'edgecolor',colorjet(idx,:),'linewidth',3,'edgealpha',0.8);
    hold on
end
set(gca,'Box','off')
set(gca,'Visible','off')

%% T-TEST PERCEPTION AND PRODUCTION DIFFERENCES
ind{1}=Tall{2}.Data.findTrials('1','n','n')
ind{2}=Tall{5}.Data.findTrials('1','n','n')
figure
for c=1:chTot
    [t,p]=ttest2([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))]',...
        [squeeze(Tall{5}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{2}.cond2))]',.01,'right','equal');
    tIdx=find(t);
    [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);
    errorarea(mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))],2),ste([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))],2))
    hold on
    [hl,hp]=errorarea(mean([squeeze(Tall{5}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{2}.cond2))],2),ste([squeeze(Tall{5}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{2}.cond2))],2))
    set(hp,'FaceColor','r');set(hl,'Color','r')
    try
        hl=line([tIdx(find(h_fdr)); tIdx(find(h_fdr))],[mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,tIdx(find(h_fdr))+199,:,ind{1}.cond2))],2), mean([squeeze(Tall{5}.Data.segmentedEcog.smoothed100(c,tIdx(find(h_fdr))+199,:,ind{1}.cond2))],2)]')
        set(hl,'Color','k')
    end
    axis([0 200 -1 5])
    title(int2str(c))
    %r=input('n','s')
    if ~strcmp(r,'n')
        keep(c)=1;
    end
    electrodes(c).PercProdTTest_50ms=zeros(1,length(t));
    electrodes(c).PercProdTTest_50ms(tIdx(find(h_fdr)))=1;
    %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    clf
end
%% PLOT T-TEST RESULTS OVER TIME ON BRAIN
figure
tOut=vertcat(electrodes.PercProdTTest_50ms);
chidx=find(sum(tOut,2)>2);
time=[1:50:2000]
for s=1:length(t)
    %visualizeGrid(5,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],chidx,sum(tOut(chidx,s),2))
    visualizeGrid(1,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],chidx,sum(tOut(chidx,s),2))
    title(int2str(time(s)))
    %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    input('n')
end

%% PLOT ELECTRODES ON BRAIN THAT HAD MOST TIME POINTS THAT ARE DIFFERENT
figure
s=sum(vertcat(electrodes.PercProdTTest_50ms),2);
ch2=find(s(ch)>1)
visualizeGrid(5,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],ch(ch2),s(ch(ch2)));
%% PLOT PERCEPTION AND PRODUCTION ON SAME PLOT ALL CHANNELS
figure
for epos=1:chTot
    if ~ismember(epos,activeCh)
        continue
    end
    plotGridPosition(epos);
    plot(mean(Tall{2}.Data.segmentedEcog.zscore_separate(epos,:,:,:),4));
    hold on
    plot(mean(Tall{5}.Data.segmentedEcog.zscore_separate(epos,:,:,:),4),'r');
    line([800 800],[-1 7])
    axis tight
end
%% Ave over 100 ms seg
for eidx=[2 5]
    sidx=1;
    for s=1:10:200-10    
        Tall{eidx}.Data.segmentedEcog.ave100ms(:,sidx,:)=squeeze(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(:,(s:s+10)+100,:,:),2))
        sidx=sidx+1;
    end
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
figure
eidx=5
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\modhot')
colorjet=hot.*repmat(rgb('gold'),length(jet),1)
tOut=vertcat(E{eidx}.electrodes.TTest);
chidx=find(sum(tOut,2)>2);
time=[-100:50:100]
visualizeGrid(5,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],[],[],[],[],[],colorjet(idx,:),1);
ch=activeCh
for s=(200/step):-1:1   
    data=mean(tOut(:,(s-1)*step+1:(s)*step),2);
    idx=findNearest(((s-1)*step+1)*10,extremeRange);
    visualizeGrid(1,['E:\General Patient Info\' Tall{eidx}.Data.patientID '\brain.jpg'],1:256,data',[],[],[],colorjet(idx,:),0);
    %title(int2str(time(s)))
    %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    hold on
    input('n')    
end
set(gcf,'Color','w')
%%
eidx=2
figure
visualizeGrid(5,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],[],[],[],[],[],colorjet(idx,:),1);
pkTime=[E{eidx}.electrodes.peakTime]
ch=find(pkTime~=100000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels))
pkTime=[E{eidx}.electrodes(ch).peakTime]
step=2
s=(200/step)
chidx=1
while ~isempty(chidx) | s==1
    startTime=((s-1)*step+1)*10;
    stopTime=((s)*step)*10;
    chidx=find(pkTime<=stopTime )
    idx=findNearest(startTime,extremeRange);
    visualizeGrid(1,['E:\General Patient Info\' Tall{eidx}.Data.patientID '\brain.jpg'],ch(chidx),ones(size(chidx)),[],[],[],colorjet(idx,:),0);
    %title(int2str(time(s)))
    %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    hold on
    %input('n')    
    s=s-1;
end
%%
eidx=2
figure
%visualizeGrid(5,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],[],[],[],[],[],colorjet(idx,:),1);
pkTime=[E{eidx}.electrodes.peakTime]
ch=find(pkTime~=100000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels))
pkTime=[E{eidx}.electrodes(ch).peakTime]
step=2
s=(200/step)
chidx=1
figure
line([-1000 1000],[0 0])
line([0 0],[-1000 1000])
hold on
while ~isempty(chidx) | s==1
    startTime=((s-1)*step+1)*10;
    stopTime=((s)*step)*10;
    chidx=find(pkTime<=stopTime )
    idx=findNearest(startTime,extremeRange);
    for c=1:length(chidx)
        xyCur=xy(:,ch(chidx(c)));
        %[posSF,posCS]=getSulcusDev(xyCur,xySF,xyCS);

        [devCS,devSF]=getSulcusDev(xyCur,xySF,xyCS);
        scatter(devCS,devSF,100,colorjet(idx,:),'fill')
        hold on
    end
    %title(int2str(time(s)))
    %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    %hold off
    %input('n')    
    s=s-1;
    %clf
end
