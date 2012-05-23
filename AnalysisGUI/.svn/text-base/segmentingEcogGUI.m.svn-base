function [segmented_ecog, eventTS]=segmentingEcogGUI(pathName, processed_ecog, desiredSubsets, timeWindow, badTimeIntervals, dataInterval, sampFreq, prelimToggle, eventType)

%{
PURPOSE: Segment ecog data around desired event onsets, using specified window.

INPUTS:
processed_ecog: Ecog structure that includes the ecog data timeseries
eventTS:        Timeseries array that specifies the sample where an event occurs
desiredSubsets: Cell array that includes the subsets of events the data should be segmented around (must be in the form of cell array!)
timeWindow:     A 2-element array with the pre- and post- duration (in ms) around event onset 

OUTPUTS:
segmented_ecog: Structure, with the data field being a cell array that includes the segmented data 3D matrix for all desired subsets
%}

%currentpath = pwd;
%cd(pathName);

if strcmp(eventType,'Auto')
    eventTS=processed_ecog.triggerTS;
else
    eventTS=makeEventTSGUI(length(processed_ecog.data(1,:,1)), processed_ecog.sampFreq, timeWindow{1}, badTimeIntervals, dataInterval, prelimToggle);
    timeWindow{1}=repmat(timeWindow{1},1,size(desiredSubsets,2));
end

%convert time window from ms to number of samples
for i=1:size(timeWindow,2)
    sampWindow{i}=round((timeWindow{i}*processed_ecog.sampFreq)/1000);
end

segmented_ecog.data=cell(1,length(desiredSubsets));





%make segment for each subset
for k=1:length(desiredSubsets) %loops around trigger sets. 
    triggerIdx=[];
    curTriggers=desiredSubsets{k};
    for m=1:length(curTriggers)
        triggerIdx=[triggerIdx find(eventTS==curTriggers(m))];
    end
	
goodIdx=find(triggerIdx>1+sampWindow{k}(1) & triggerIdx<length(processed_ecog.data(1,:,1))-sampWindow{k}(2));
triggerIdx=triggerIdx(goodIdx);	
	
	
	
    if ~isempty(triggerIdx)
        segmented_ecog.data{k}=makeDataSegmentGUI(processed_ecog.data,triggerIdx,sampWindow{k}(1), sampWindow{k}(2));        
        segmented_ecog.eventTS{k}=makeDataSegmentGUI(eventTS,triggerIdx,sampWindow{k}(1),sampWindow{k}(2));
        segmented_ecog.desiredSubsets{k}=desiredSubsets{k};
    else
        disp(['No events for trigger: ' num2str(k)]);
    end
    
    printf('Number of Events for Subset %s: %d\n',int2str(desiredSubsets{k}),size(segmented_ecog.data{k},4));
end



%{
segmented_ecog.timebase=processed_ecog.timebase;
segmented_ecog.sampDur=processed_ecog.sampDur;
segmented_ecog.sampFreq=processed_ecog.sampFreq;
segmented_ecog.baselineDur=processed_ecog.baselineDur;
segmented_ecog.nSamp=processed_ecog.nSamp;
segmented_ecog.nBaselineSamp=processed_ecog.nBaselineSamp;
segmented_ecog.selectedChannels=processed_ecog.selectedChannels;
segmented_ecog.badChannels=processed_ecog.badChannels;
segmented_ecog.excludeBad=processed_ecog.excludeBad;
segmented_ecog.channel2GridMatrixIdx=processed_ecog.channel2GridMatrixIdx;
%}

%cd(currentpath);
