function [Tall,E]=analyzeData(n,ch,Tall,events)
%%INITIATE 
brainFile='C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\'
destFile='E:\DelayWord\Figure1_withCAR\'
% %% LOAD DATA
Tall{2}=PLVTests(n,2,ch,'aa')
Tall{4}=PLVTests(n,4,ch,'aa')

Tall{2}.Data.ecogBaseline.data=reshape(Tall{2}.Data.segmentedEcog.data(:,500:800,:,:),Tall{2}.Data.channelsTot,[]);
Tall{2}.Data.ecogBaseline.std(:,1,1)=std(Tall{2}.Data.ecogBaseline.data,[],2);
Tall{2}.Data.ecogBaseline.mean(:,1,1)=mean(Tall{2}.Data.ecogBaseline.data,2);

try
    Tall{5}=PLVTests(n,5,ch,'aa')
    Tall{5}.Data.BaselineChoice='rest';
    Tall{5}.Data.ecogBaseline=Tall{2}.Data.ecogBaseline;
    Tall{5}.Data.calcZscore(1,1);
    Tall{5}.Data.ecogBaseline.zscore_separate=zscore(Tall{5}.Data.ecogBaseline.data,[],2)
catch
end
Tall{4}.Data.BaselineChoice='rest';
Tall{2}.Data.BaselineChoice='rest';

Tall{4}.Data.ecogBaseline=Tall{2}.Data.ecogBaseline;
Tall{4}.Data.calcZscore(1,1);
Tall{2}.Data.calcZscore(1,1);
Tall{2}.Data.ecogBaseline.zscore_separate=zscore(Tall{2}.Data.ecogBaseline.data,[],2)
Tall{4}.Data.ecogBaseline.zscore_separate=zscore(Tall{4}.Data.ecogBaseline.data,[],2)
%% SMOOTH AND DOWNSAMPLE TO 100 Hz
usesamps=[1:400]
for x=events
    try
        for c=1:256
            for tr=1:size(Tall{x}.Data.segmentedEcog.zscore_separate,4)
                Tall{x}.Data.segmentedEcog.smoothed100(c,:,:,tr)=smooth(resample(squeeze(Tall{x}.Data.segmentedEcog.zscore_separate(c,:,:,tr)),1,4),20);
            end
        end
    end
end

%% GET ACTIVE ELECTRODES FOR PERC AND PROD
usesamps=[100:300]
chTot=size(Tall{2}.Data.segmentedEcog.smoothed100,1);
for eidx=events
    Tall{eidx}.Data.ecogBaseline.zscore_separate=smoothDim( Tall{eidx}.Data.ecogBaseline.zscore_separate,2,10);  
    indices=Tall{eidx}.Data.findTrials('1','n','n');
    indicesB=Tall{2}.Data.findTrials('1','n','n');

    %indices.cond2=setdiff(1:size(Tall{eidx}.Data.segmentedEcog.data,4),Tall{eidx}.Data.Artifacts.badtr);
    %indicesB.cond2=setdiff(1:size(Tall{2}.Data.segmentedEcog.data,4),Tall{eidx}.Data.Artifacts.badtr);
    for c=1:chTot
        [t,p]=ttest2(squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2))',...
            repmat(squeeze(mean(Tall{eidx}.Data.ecogBaseline.zscore_separate,2)),1,length(usesamps)),.01,'right','unequal');
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
activeCh=unique(vertcat(tmp{:})')

%% GET PEAK, START, END END OF ACTIVITY TIMES; PLOT EACH CHANNEL
for eidx=events
    %%
        indices=Tall{eidx}.Data.findTrials('1','n','n')
        indicesB=Tall{2}.Data.findTrials('1','n','n')
        for c=1:chTot
            if ismember(c,activeCh)
                [t,p]=ttest2([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2))]',...
                    repmat(squeeze(mean(Tall{eidx}.Data.ecogBaseline.zscore_separate,2)),1,length(usesamps)),.01,'right','unequal');
                errorarea(mean([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,indices.cond2))],2),ste([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,indices.cond2))],2))
                hold on
                try
                    plot(find(E{eidx}.electrodes(c).activeTTest)+usesamps(1),1,'.')
                end
                title(int2str(c))

                electrodes(c).TTest=t;
                if sum(electrodes(c).TTest)>10
                    [electrodes(c).maxAmp,electrodes(c).peakIdx]=max(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2),4),[],2);
                    electrodes(c).startTime=(find(t,1,'first'))/100*1000;
                    electrodes(c).stopTime=(find(t,1,'last'))/100*1000;
                    tsamps=find(E{eidx}.electrodes(c).activeTTest);
                    [electrodes(c).maxAmp,tmpidx]=max(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps(1)+tsamps,:,indices.cond2),4));
                    electrodes(c).peakIdx=tsamps(tmpidx);
                    electrodes(c).peakTime=(electrodes(c).peakIdx/100)*1000;

                else
                    electrodes(c).maxAmp=100000;
                    electrodes(c).peakIdx=100000;
                    electrodes(c).startTime=100000;
                    electrodes(c).stopTime=100000;
                    electrodes(c).peakTime=100000;
                end
                try
                    line([(electrodes(c).startTime/1000)*100+usesamps(1) (electrodes(c).startTime/1000)*100+usesamps(1)],[0 10])
                    line([(electrodes(c).peakTime/1000)*100+usesamps(1) (electrodes(c).peakTime/1000)*100+usesamps(1)],[0 10])
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

%% SAVE OUTPUT
% cd(destFile)
% [~,block]=fileparts( Tall{2}.Data.MainPath)
% save(['Tall_' block],'Tall','-v7.3')
% save(['E_' block],'E','-v7.3')

