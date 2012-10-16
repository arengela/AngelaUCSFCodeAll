load('C:\Users\ego\Dropbox\AngelaUCSFFiles\DelayWordBackup\notes')
brainFile='C:\Users\ego\Dropbox\ChangLab\General Patient Info\'
%% EC23
Tall{2}=PLVTests(10,2,1:256,'aa')
Tall{5}=PLVTests(10,5,1:256,'aa')
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
%% SMOOTH AND DOWNSAMPLE TO 100 Hz
usesamps=[100:300]
for x=[2 5]
    for c=1:256
        for tr=1:size(Tall{x}.Data.segmentedEcog.zscore_separate,4)
            Tall{x}.Data.segmentedEcog.smoothed100(c,:,:,tr)=smooth(resample(squeeze(Tall{x}.Data.segmentedEcog.zscore_separate(c,:,:,tr)),1,4),20);
        end
    end
end

%% GET ACTIVE ELECTRODES FOR PERC AND PROD
for eidx=[2 5]
    indices=Tall{eidx}.Data.findTrials('1','n','n')
    indicesB=Tall{2}.Data.findTrials('1','n','n')   
    for c=1:256
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
end
activeCh=unique([tmp{2}' tmp{5}'])
block=2;
notes(block).activeCh=activeCh;
notes(block).percCh=tmp{2}';
notes(block).prodCh=setdiff(tmp{5}',tmp{2}');
figure
visualizeGrid(2,[brainFile Tall{2}.Data.patientID '\brain.jpg'],activeCh)
%% PLOT PERCEPTION CHANNELS
figure
visualizeGrid(2,[brainFile Tall{2}.Data.patientID '\brain.jpg'],notes(block).percCh)
%% PLOT PRODUCTION CHANNELS
figure
visualizeGrid(2,[brainFile Tall{2}.Data.patientID '\brain.jpg'],notes(block).prodCh)
%% SET STG AND MOTOR CHANNELS
notes(block).stgCh=tmp{2}';
notes(block).motorCh=setdiff(tmp{5}',tmp{2}');
%% GET PEAK, START, END END OF ACTIVITY TIMES; PLOT EACH CHANNEL
for eidx=[2 5]
    %%
    indices=Tall{eidx}.Data.findTrials('1','n','n')
    indicesB=Tall{2}.Data.findTrials('1','n','n')
    for c=1:256
        %plotGridPosition(c);
        if ismember(c,activeCh)
            [t,p]=ttest2([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2))]',...
                repmat(squeeze(mean(Tall{2}.Data.segmentedEcog.smoothed100(c,1:200,:,indicesB.cond2),2)),1,length(usesamps)),.01,[],'unequal');
            tIdx=find(t);
            [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);
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
            hold off
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
electrodes=E{eidx}.electrodes
pkTime=mean(vertcat([electrodes.startTime],[electrodes.peakTime]));
[~,sortIdx]=sort(pkTime)
ch=find(pkTime~=100000 & pkTime>0 & pkTime<3000 & ~ismember(1:256,Tall{eidx}.Data.Artifacts.badChannels) & [electrodes.startTime]<2000 & ...
    sum(vertcat(electrodes.TTest),2)'>10)
ch=intersect(ch,notes(block).activeCh)
[~,s]=sort(pkTime(ch));
% line([vertcat(electrodes(sortIdx).startTime) vertcat(electrodes(sortIdx).stopTime)]',[1:256;1:256])
% hold on
% plot([electrodes(sortIdx).peakTime],1:256,'.')

% VISUALIZE PEAK TIMES ON BRAIN
figure

visualizeGrid(9,[brainFile Tall{eidx}.Data.patientID '\brain.jpg'],ch(s),pkTime(ch),[],ones(1,length(ch))*100);
%figure
%visualizeGrid(51,[brainFile Tall{eidx}.Data.patientID '\brain.jpg'],ch(s),1500-pkTime(ch));
colormap((modhot))
%colormap(pink)
%colormap(autumn.*copper)
h=colorbar
%extremeRange2=linspace(min(pkTime(ch)),max(pkTime(ch)),256)
extremeRange2=linspace(0,2000,256);
idx=findNearest([0:100:2000],extremeRange2) 
set(h,'YTick',idx)
set(h,'YTickLabel',[-500:100:1000])
clear idxAll
children=get(gca,'Children')
dots=get(children(1))
for i=1:length(dots.Children)
    idxAll(i)=findNearest(pkTime(ch(i)),extremeRange2)
end
set(children(1),'CData',idxAll)

%% PLOT PERC AND PRODUCTION DATA VERTICALLY
% SORTED BY PRODUCTION PEAK TIME
eidx=5;
electrodes=E{eidx}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)
ch=find(pkTime~=100000 & pkTime>0 & pkTime<2000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels) & [electrodes.startTime]<1500 & ...
    sum(vertcat(electrodes.TTest),2)'>30)
%ch=intersect(ch,[notes(block).stgCh notes(block).motorCh]);
%s=find(ismember(ch,notes(block).stgCh));
%s=[s find(ismember(ch,notes(block).motorCh))];
figure
colorjet=jet.*repmat([.8 .8 .8],length(jet),1)
colorjet=colormap(modhot)
 [~,s]=sort(pkTime(ch));
% for c=1:length(ch)
%     [a,b]=find(Tall{2}.Data.gridlayout.usechans==ch(c));
%     h(c)=sqrt(a^2+b^2);
% end
% [~,s]=sort(h);


%extremeRange=linspace(min(pkTime(ch)),max(pkTime(ch)),64)  
extremeRange=linspace(500,2000,64);
vertShift=fliplr((1:length(s))./2);
%s=fliplr(s)
for i=1:length(s)
    if pkTime(ch(s(i)))~=100000
    %subplot(1,2,2)
        subplot('Position',[.51 .1 .4 .9])
        idx=findNearest(pkTime(ch(s(i))),extremeRange)
        data=mean([squeeze(Tall{5}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indices.cond2))],2);
        hold on
        hl=plot(data+vertShift(i),'Color',colorjet(idx,:),'LineWidth',2)
        set(gca,'Box','off')
        set(gca,'Visible','off')
        hl=line([200 200],[-1 max(vertShift)])
        set(hl,'Color','k')
    end
    
    subplot('Position',[.1 .1 .4 .9])
    if E{2}.electrodes(ch(s(i))).peakTime==100000
        continue
    end
    idx=findNearest(E{2}.electrodes(ch(s(i))).peakTime,extremeRange)
    data=mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
    hl=plot(data+vertShift(i),'Color',colorjet(idx,:),'LineWidth',2)
    hold on
    hl=line([200 200],[-1 max(vertShift)])
    set(gca,'Box','off')
    set(gca,'Visible','off')
    set(hl,'Color','k')
end
%% GO THROUGH EACH CHANNEL AND REJECT BAD ONES

for i=1:length(s)
    subplot(1,2,2)
    idx=findNearest(pkTime(ch(s(i))),extremeRange)
    data=mean([squeeze(Tall{5}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indices.cond2))],2);
    hold on
    hl=plot(data,'Color',colorjet(idx,:),'LineWidth',2)
    set(gca,'Box','off')
    set(gca,'Visible','off')
    hl=line([200 200],[-1 5])
    set(hl,'Color','k')
    
    subplot(1,2,1)
    idx=findNearest(E{2}.electrodes(ch(s(i))).startTime,extremeRange)
    data=mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
    hl=plot(data,'Color',colorjet(idx,:),'LineWidth',2)
    hold on
    hl=line([200 200],[-1 5])
    set(gca,'Box','off')
    set(gca,'Visible','off')
    set(hl,'Color','k')
    r=input('n','s')
    if strcmp(r,'n')
        bad(i)=ch(s(i));
    end
    clf
end
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
    idx=findNearest(pkTime(ch(s(i))),extremeRange)
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
for c=1:256
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
    visualizeGrid(5,[brainFile Tall{2}.Data.patientID '\brain.jpg'],chidx,sum(tOut(chidx,s),2))
    title(int2str(time(s)))
    %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    input('n')
end

%% PLOT ELECTRODES ON BRAIN THAT HAD MOST TIME POINTS THAT ARE DIFFERENT
figure
s=sum(vertcat(electrodes.PercProdTTest_50ms),2);
ch2=find(s(ch)>1)
visualizeGrid(5,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],ch(ch2),s(ch(ch2)));
