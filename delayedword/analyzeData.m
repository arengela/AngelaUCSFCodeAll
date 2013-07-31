function [Tall,E]=analyzeData(n,ch,Tall,events)
%%INITIATE 
brainFile='C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\'
destFile='E:\DelayWord\Figure1_withCAR_slideBaseline_ev3\'
% %% LOAD DATA
tmp=PLVTests(n,2,1,'aa')

%quickPreprocessing_ALL(tmp.FilePath,3,0,1); 


if isempty(Tall)
    Tall{2}=PLVTests(n,2,ch,'aa')
    try
        Tall{4}=PLVTests(n,4,ch,'aa')
    end
    try
        Tall{5}=PLVTests(n,5,ch,'aa')
    end

end
Tall{2}.Data.ecogBaseline.data=reshape(Tall{2}.Data.segmentedEcog.data(:,500:800,:,:),Tall{2}.Data.channelsTot,[]);
Tall{2}.Data.ecogBaseline.std(:,1,1)=std(Tall{2}.Data.ecogBaseline.data,[],2);
Tall{2}.Data.ecogBaseline.mean(:,1,1)=mean(Tall{2}.Data.ecogBaseline.data,2);

Tall{2}.Data.ecogBaseline.zscore_separate=zscore(Tall{2}.Data.ecogBaseline.data,[],2)
[a,b]=find(Tall{2}.Data.ecogBaseline.zscore_separate(setdiff(1:Tall{2}.Data.channelsTot,Tall{2}.Data.Artifacts.badChannels),:)>6);
Tall{2}.Data.ecogBaseline.zscore_separate(:,unique(b))=[];
try
    Tall{5}.Data.BaselineChoice='rest';
    Tall{5}.Data.ecogBaseline=Tall{2}.Data.ecogBaseline;
    Tall{5}.Data.calcZscore(1,1);
catch
end
Tall{4}.Data.BaselineChoice='rest';
Tall{2}.Data.BaselineChoice='rest';

Tall{4}.Data.ecogBaseline=Tall{2}.Data.ecogBaseline;
Tall{4}.Data.calcZscore(1,1);
Tall{2}.Data.calcZscore(1,1);



%% SMOOTH AND DOWNSAMPLE TO 100 Hz
for x=events
    Tall{x}.Data.ecogBaseline.smoothed100=[];
    for c=1:Tall{x}.Data.channelsTot
        for tr=1:size(Tall{x}.Data.segmentedEcog.zscore_separate,4)
            Tall{x}.Data.segmentedEcog.smoothed100(c,:,:,tr)=smooth(resample(squeeze(Tall{x}.Data.segmentedEcog.zscore_separate(c,:,:,tr)),1,4),15);
        end
        Tall{x}.Data.ecogBaseline.smoothed100(c,:)=smooth(resample(Tall{x}.Data.ecogBaseline.zscore_separate(c,:),1,4),15);
    end
end
% 
% %% GET ACTIVE ELECTRODES FOR PERC AND PROD
% usesamps=[200:300]
% chTot=size(Tall{2}.Data.segmentedEcog.smoothed100,1);
% for eidx=events
%     usetr=1:size(Tall{2}.Data.segmentedEcog.smoothed100,4);
%     indices=Tall{eidx}.Data.findTrials('1','n','n');
%     indicesB=Tall{2}.Data.findTrials('1','n','n');    
%     
%     %GET BAD TRIALS
%     usech=setdiff(1:chTot,Tall{eidx}.Data.Artifacts.badChannels);
%     usesamp=100:300;
%     d=zscore(detrend(squeeze(mean(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,:),1),2))));
%     imagesc(squeeze(mean( Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,:),1))')
%     Tall{eidx}.Data.Artifacts.badtr=[];
%     Tall{eidx}.Data.Artifacts.badtr=find(abs(d)>2);
%     Tall{eidx}.Data.Params.usetr=setdiff(1:size(Tall{eidx}.Data.segmentedEcog.data,4),Tall{eidx}.Data.Artifacts.badtr);   
%     
%     %T-TEST AGAIN BASELINE TO GET ACTIVE
%     indices.cond2=setdiff(1:size(Tall{eidx}.Data.segmentedEcog.data,4),Tall{eidx}.Data.Artifacts.badtr);
%     indicesB.cond2=setdiff(1:size(Tall{2}.Data.segmentedEcog.data,4),Tall{eidx}.Data.Artifacts.badtr);
%     for c=1:chTot
% %         [t,p]=ttest2(squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2))',...
% %             repmat(squeeze(mean(Tall{eidx}.Data.ecogBaseline.zscore_separate(c,:),2)),length(usetr),length(usesamps)),.01,'right','unequal');        
%         [t,p]=ttest2(reshape(squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2)),1,[]),Tall{eidx}.Data.ecogBaseline.smoothed100(c,:),.01,[],'unequal');
%         %tIdx=find(t);
%         %[ps_fdr,h_fdr]=MT_FDR_PRDS(p,.05);
%         %t=zeros(1,length(t));
%         %t(find(h_fdr))=1;
%         E{eidx}.electrodes(c).activeTTest=t;
%         
%         plotGridPosition(c);plot(squeeze(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,:),4)))
%         axis([0 400 -1 7])
%         if t==1 
%             set(gca,'Color','y')
%         end
%         
%         if ismember(c,Tall{eidx}.Data.Artifacts.badChannels)
%             set(gca,'Color','k')
%         end              
%     end
%     tOut=vertcat(E{eidx}.electrodes.activeTTest)
%     %tmp{eidx}=find(sum(tOut(100:150),2)>5);
%     tmp{eidx}=find(sum(tOut,2)==1);
%     Tall{eidx}.Data.Params.activeCh=tmp{eidx};
%     %input('n')
%     clf
% end
% activeCh=unique(vertcat(tmp{:})')
% 
% %% GET PEAK, START, END END OF ACTIVITY TIMES; PLOT EACH CHANNEL
% for eidx=events
%     %%
%         indices=Tall{eidx}.Data.findTrials('1','n','n')
%         indicesB=Tall{2}.Data.findTrials('1','n','n')
%         for c=1:chTot
%             if ismember(c,activeCh)
%                 [t,p]=ttest2([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2))]',...
%                     repmat(squeeze(Tall{eidx}.Data.ecogBaseline.zscore_separate(c,:))',1,length(usesamps)),.01,'right','unequal');
%                 [ps_fdr,h_fdr]=MT_FDR_PRDS(p,.01);
%                 t=zeros(1,length(t));
%                 t(find(h_fdr))=1;
%                 electrodes(c).TTest=t;
%                 errorarea(mean([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,indices.cond2))],2),ste([squeeze(Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,indices.cond2))],2))
%                 hold on
%                 try
%                     plot(find(electrodes(c).TTest)+usesamps(1),1,'.')
%                 end
%                 title(int2str(c))
% 
%                 if sum(electrodes(c).TTest)>10
%                     [electrodes(c).maxAmp,electrodes(c).peakIdx]=max(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps,:,indices.cond2),4),[],2);
%                     electrodes(c).startTime=(find(t,1,'first'))/100*1000;
%                     electrodes(c).stopTime=(find(t,1,'last'))/100*1000;
%                     tsamps=find(electrodes(c).TTest);
%                     [electrodes(c).maxAmp,tmpidx]=max(mean(Tall{eidx}.Data.segmentedEcog.smoothed100(c,usesamps(1)+tsamps,:,indices.cond2),4));
%                     electrodes(c).peakIdx=tsamps(tmpidx);
%                     electrodes(c).peakTime=(electrodes(c).peakIdx/100)*1000;
% 
%                 else
%                     electrodes(c).maxAmp=100000;
%                     electrodes(c).peakIdx=100000;
%                     electrodes(c).startTime=100000;
%                     electrodes(c).stopTime=100000;
%                     electrodes(c).peakTime=100000;
%                 end
%                 try
%                     line([(electrodes(c).startTime/1000)*100+usesamps(1) (electrodes(c).startTime/1000)*100+usesamps(1)],[0 10])
%                     line([(electrodes(c).peakTime/1000)*100+usesamps(1) (electrodes(c).peakTime/1000)*100+usesamps(1)],[0 10])
%                 end
%                 %r=input('n','s')
%                 r='y'
%                 if ~strcmp(r,'n') & ~strcmp(r,'g')
%                     keep(c)=1;
%                 elseif strcmp(r,'g')
%                     [x,y]=ginput(2);
%                     d=find(electrodes(c).TTest)
%                     didx=findNearest(x(1),d);
%                     electrodes(c).startTime=(d(didx)/100)*1000;
%                     d=find(electrodes(c).TTest)
%                     didx=findNearest(x(2),d);
%                     electrodes(c).startTime=(d(didx)/100)*1000;
%                 else
%                     keep(c)=0
%                     electrodes(c).maxAmp=100000;
%                     electrodes(c).peakIdx=100000;
%                     electrodes(c).startTime=100000;
%                     electrodes(c).stopTime=100000;
%                     electrodes(c).peakTime=100000;
%                 end
%                 clf
%             else
%                 electrodes(c).maxAmp=100000;
%                 electrodes(c).peakIdx=100000;
%                 electrodes(c).startTime=100000;
%                 electrodes(c).stopTime=100000;
%                 electrodes(c).peakTime=100000;
%                 t=zeros(1,length(t));
%                 electrodes(c).TTest=t;
%             end
%         end
%         E{eidx}.electrodes=electrodes;
% end

%% SAVE OUTPUT
cd(destFile)
[~,block]=fileparts( Tall{2}.Data.MainPath)
save(['Tall_2000_10000_' block],'Tall','-v7.3')
%save(['E_2000_10000_' block],'E','-v7.3')

