Tall{1}=PLVTests(38,2,1:256,'aa')
Tall{2}=PLVTests(39,2,1:256,'aa')
%% SMOOTH AND DOWNSAMPLE TO 100 Hz
usesamps=200:400
for x=1:2
    for c=1:256
        for tr=1:size(Tall{x}.Data.segmentedEcog.zscore_separate,4)
            Tall{x}.Data.segmentedEcog.smoothed100(c,:,:,tr)=smooth(resample(squeeze(Tall{x}.Data.segmentedEcog.zscore_separate(c,:,:,tr)),1,4),10);
        end
    end
end
%% PLOT ZSCORES FOR ACTIVE VS PASSIVE LISTENING
figure
for epos=1:256
    plotGridPosition(epos);
    plot(squeeze(mean(Tall{1}.Data.segmentedEcog.smoothed100(epos,:,:,:),4)))
    hold on
    plot(squeeze(mean(Tall{2}.Data.segmentedEcog.smoothed100(epos,:,:,:),4)),'r')
    axis([0 400 -1 5])
end

%% TTEST ACTIVE VS PASSIVE LISTENING
ind{1}=Tall{1}.Data.findTrials('1','n','n')
ind{2}=Tall{2}.Data.findTrials('1','n','n')
%%
figure
 chPlot=[91 92 93 109 110 121 136 137 223 117 164 ]
for c=chPlot%1:256
    [t,p]=ttest2([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))]',...
        [squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{2}.cond2))]',.01,'right','equal');
    tIdx=find(t);
    [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);

    
    errorarea(mean([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))],2),ste([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{1}.cond2))],2))
    hold on
    [hl,hp]=errorarea(mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{2}.cond2))],2),ste([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,usesamps,:,ind{2}.cond2))],2))
    set(hp,'FaceColor','r');set(hl,'Color','r')

    try
        hl=line([tIdx(find(h_fdr)); tIdx(find(h_fdr))],[mean([squeeze(Tall{1}.Data.segmentedEcog.smoothed100(c,tIdx(find(h_fdr))+199,:,ind{1}.cond2))],2), mean([squeeze(Tall{2}.Data.segmentedEcog.smoothed100(c,tIdx(find(h_fdr))+199,:,ind{1}.cond2))],2)]')
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
    saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    clf
end
%%
%% Ave over 50 ms seg
for x=1:2
	sidx=1;
    for s=1:5:200-5    
        Tall{x}.Data.segmentedEcog.ave50ms(:,sidx,:)=squeeze(mean(Tall{x}.Data.segmentedEcog.smoothed100(:,(s:s+5)+200,:,:),2))
        sidx=sidx+1;
    end
end

%% T-Test ON DATA THAT'S BEEN AVERAGED EVERY 50 MS
for c=1:256
    [t,p]=ttest2([squeeze(Tall{1}.Data.segmentedEcog.ave50ms(c,:,ind{1}.cond2))]',...
        [squeeze(Tall{2}.Data.segmentedEcog.ave50ms(c,:,ind{2}.cond2))]',.01,'right','equal');
    tIdx=find(t);
    [ps_fdr,h_fdr]=MT_FDR_PRDS(p(tIdx),.01);  
    electrodes(c).ActivePassiveTTest_50ms=zeros(1,length(t));
    electrodes(c).ActivePassiveTTest_50ms(tIdx(find(h_fdr)))=1;  
end
%% plot T-Test significant channels over time
figure
tOut=vertcat(electrodes.ActivePassiveTTest_50ms);
chidx=find(sum(tOut,2)>2);
time=[1:50:2000]
for s=1:length(t)     
    visualizeGrid(5,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],chidx,sum(tOut(chidx,s),2))
    title(int2str(time(s)))
    saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    %input('n')
end
%%
t=sum(tOut(:,:),2)
chidx=find(t>20)
visualizeGrid(5,['E:\General Patient Info\' Tall{1}.Data.patientID '\brain.jpg'],chidx,sum(tOut(chidx,:),2))
