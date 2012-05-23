function [segmented_ecog]=segmentingEcogGUI_2events(pathName, processed_ecog, desiredSubsets, timeWindow, badTimeIntervals, sampFreq,prelimToggle)
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

%convert time window from ms to number of samples

for i=1:size(timeWindow,2)
    sampWindow{i}=round((timeWindow{i}*processed_ecog.sampFreq)/1000);
end

segmented_ecog.data=cell(1,length(desiredSubsets));

label_file='transcript_all.lab'; 
[ev1 ev2 s] = textread(label_file,'%f%f%s');
ev1=ev1(2:end);
ev2=ev2(2:end);

try
    load allConditions;
catch
    ss=unique(s);
    tmp=cellfun(@isempty,ss);
    allConditions=ss(~tmp);
    cd([pathName filesep 'Analog'])
    save('allConditions','allConditions'); 
end
%{
ev1(end+1)=ev2(end);
E_times=ev1/(1000*10000);


E=(ev1/(1000*10000));  % event triggers (sec)
%}
load allEventTimes;
E=cell2mat(allEventTimes(:,1));
s=allEventTimes(:,2);
segmentTimes=[E-timeWindow{1}(1)/1000, E+timeWindow{1}(2)/1000];
s3=s;


%Discard bad segmentss
%{
for b=1:size(badTimeIntervals,1)
    for t=1:size(segmentTimes,1)
        if (badTimeIntervals(b,1)>=segmentTimes(t,1)) & (badTimeIntervals(b,1)<=segmentTimes(t,2)) | (badTimeIntervals(b,2)>=segmentTimes(t,1)) & (badTimeIntervals(b,2)<=segmentTimes(t,2))
            s3{t}='0';
        end
    end
end
%}


notinclude=[];
d=[];
for i=1:length(desiredSubsets)
    if size(desiredSubsets{i},1)>2 
        if desiredSubsets{i}(3,:)~=0
            notinclude=horzcat(desiredSubsets{i}(3,:),notinclude);
        end
    end
   d=horzcat(d,desiredSubsets{i})
end

notinclude=unique(notinclude);
uniqueEventType=setdiff(unique(d),notinclude);

uniqueEventType=uniqueEventType(find(uniqueEventType>0));
eventTS=zeros(1,size(processed_ecog.data,2));

for i=1:length(uniqueEventType)
    tmp=strmatch(allConditions(uniqueEventType(i)),s3,'exact');
    eventTS(round(E(tmp,1)*sampFreq))=uniqueEventType(i); 
end



if ~isempty(notinclude)
    for i=1:length(notinclude)
        tmp=strmatch(allConditions(notinclude(i)),s3,'exact');
        eventTS(round(E(tmp,1)*sampFreq))=0; 
    end
end

timeWindow{1}=repmat(timeWindow{1},1,size(desiredSubsets,2));

%make segment for each subset
%loops around trigger sets.
for k=1:length(desiredSubsets) 
    triggerIdx=[];
    curTriggers=desiredSubsets{k};
    for m=1:size(curTriggers,2)
        triggerIdx=[triggerIdx find(eventTS==curTriggers(1,m))];
    end
    goodIdx=find(triggerIdx>1+sampWindow{k}(1) & triggerIdx<length(processed_ecog.data(1,:,1))-sampWindow{k}(2));
    triggerIdx=unique(triggerIdx(goodIdx));	   

%%
checkSound=0;
    %checkSound=input('Check Analog?')
    if checkSound
        chan=input('Analog Chan?')
        desiredSubsets{k}
        [an,f,t]=readhtk(sprintf('ANIN%i.htk',chan));
        figure
        for i=1:length(triggerIdx)           
             seg=an((triggerIdx(i)*(f/400))-sampWindow{1}(1):(triggerIdx(i)*(f/400)+sampWindow{1}(2)));
            %subplot(4,5,i)    
            subplot(2,1,1)
            title(int2str(curTriggers))
            specgram(seg,[],f,250)
            grid on
            %line([0 .5],[900 900])
            set(gca,'YTick',0:1000:12000)
            subplot(2,1,2)
            plot(seg)
            axis tight
            h=line([1000,1000],[min(seg),max(seg)])
            set(h,'Color','r')
            keyboard
        end
    end	

%%
    if ~isempty(triggerIdx)
        segmented_ecog(k).data=makeDataSegmentGUI(processed_ecog.data,triggerIdx,sampWindow{k}(1), sampWindow{k}(2));        
        segmented_ecog(k).eventTS=makeDataSegmentGUI(eventTS,triggerIdx,sampWindow{k}(1),sampWindow{k}(2));
        segmented_ecog(k).desiredSubsets=desiredSubsets{k};
    else
        disp(['No events for trigger: ' num2str(k)]);
    end    
    
    %second event must be present
    if size(desiredSubsets{k},1)>1
        %[c,r]=find(squeeze(segmented_ecog.eventTS{k}==desiredSubsets{k}(2,:)))
        [c,r]=find(ismember(squeeze(segmented_ecog(k).eventTS(:,sampWindow{k}(1):end,:,:)),desiredSubsets{k}(2,:)));

        segmented_ecog(k).data=segmented_ecog(k).data(:,:,:,r);
        segmented_ecog(k).eventTS=segmented_ecog(k).eventTS(:,:,:,r);
        segmented_ecog(k).desiredSubsets=desiredSubsets{k};
    end

    
    fprintf('Number of Events for Subset %s: %d\n',int2str(desiredSubsets{k}),size(segmented_ecog(k).data,4));
end


