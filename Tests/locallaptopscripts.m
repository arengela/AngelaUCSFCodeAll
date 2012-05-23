processingPlotSingleStacked_inputZscoreGUI_sorted(EC18_B1_seg.zscore,3000*400/1000,[],EC18_B1_seg.rt{i},gridlayout);


%%
%Find corresponding wordlengths for listening and repetition trials
rt1=EC18_B1_seg.rt{1};          
rt2=EC18_B2_seg.rt{1};

idx=[];
for n=1:28
    idx=[idx findNearest(rt2(n),rt1)];
    rt1(idx)=-1;
end
 
EC18_B1_seg_v2.zscore=squeeze(EC18_B1_seg.zscore(:,:,idx));
EC18_B1_seg_v2.rt{1}=EC18_B1_seg.rt{1}(idx);

figure
processingPlotSingleStacked_inputZscoreGUI_sorted(EC18_B1_seg.zscore(:,:,idx)-EC18_B2_seg.zscore{1}(:,:,:),3000*400/1000,[],EC18_B2_seg.rt{1},gridlayout);

%%
badchannels=find(isnan(zScore{1}(:,1,1)))
figure
	for i=1:length(zScore)        
	    processingPlotAllChannels_inputZscoreGUI(mean(zScore{i},3),colors{i},3000*400/1000,badchannels,[],[],gridlayout);
        hold on		
    end	
    
    
 %%
 %Analog/Behavioral analyses
 