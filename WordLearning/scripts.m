Labels=T.Data.segmentedEcog.event(:,2)

L=T.Data.segmentedEcog.event(:,3)
numLabel=grp2idx(L)
%%
figure
for epos=1:256
    for numIdx=[ 3 4 5]%[1 2]%[1 2 5 3 4]
    	plotGridPosition(epos);
        plot(squeeze(mean(T.Data.segmentedEcog.zscore_separate(epos,800:1500,:,numLabel==numIdx),4)),'Color',colorjet((numIdx-1)*(round(64/5))+1,:),'LineWidth',2)
        hold on
        axis([0 700 -1 5])
        set(gca,'XTick',[],'YTick',[])
    end
end
%%
for i=1:length(T.Data.segmentedEcog.event')
    anEnv(i,:)=abs(hilbert(squeeze(T.Data.segmentedEcog.analog(2,:,800:1500,i)))');
end
%%
figure
    for numIdx=[ 3 4 5]%[1 2]%[1 2 5 3 4]
        plot(mean(anEnv(numLabel==numIdx,:),1),'Color',colorjet((numIdx-1)*(round(64/5))+1,:),'LineWidth',2)
        hold on
        %axis([0 700 -1 5])
        set(gca,'XTick',[],'YTick',[])
    end
%%
figure
for epos=1:256
   plotGridPosition(epos);
   plot(mean(T_WL.Data.segmentedEcog.zscore_separate(epos,800:1500,:,:),4))
   hold on
   plot(mean(T_rep.Data.segmentedEcog.zscore_separate(epos,800:1500,:,:),4),'r')
   axis([0 700 -1 7])
   set(gca,'XTick',[],'YTick',[])
end

