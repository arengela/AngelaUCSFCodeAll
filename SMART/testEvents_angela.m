%% variables to be intialized
desired_ANchan = 1;
desired_ANchan2 = 2; % ADD TO GUI 
threshold = .5;
threshold2 = .7; % ADD TO GUI 
sampling_rate = 3;
num_events = 1;
indLastEvent = 0;
eventIndices = zeros(2,50); % 50 = max number of events expected
numeventFLAG = 2; % 1 or 2  ADD TO GUI 

%%
ANNewData_finalMAT = [0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 1 ;...
    0 0 2 2 0 0 0 0 2 0 0 0 0 0 0 2 0 0 0 0 ];
ANfinalPos = 20;
%% detect events
% run this function only if numeventFLAG==2
%
% FUNCTION NAME
% function [detected_num_events, num_events,indLastEvent,eventIndices] =
% parseEvents( ANNewData_finalMAT, ANfinalPos, desired_ANchan,
% desired_ANchan2, threshold, threshold2, sampling_rate, num_events,
% indLastEvent, eventIndices)

event=(ANNewData_finalMAT(desired_ANchan,:)>threshold);
trigger1=[(diff(event)>0) 0];
detected_num_events = sum(trigger1);

event=(ANNewData_finalMAT(desired_ANchan2,:)>threshold2);
trigger2=[2*(diff(event)>0) 0];
detected_num_events2 = sum(trigger2)/2;

triggers = trigger1+trigger2; %this takes care of when 2 events happen at the same time

while indLastEvent<ANfinalPos
    % find onset of 1st events for the first two trials
    event1onset = find([zeros(1,indLastEvent) triggers(indLastEvent+1:ANfinalPos)]==1,2);
    if ~isempty(event1onset)
        %find 2nd event that occurs after 1st event
        event2onset =  find([zeros(1,event1onset(1)) triggers(event1onset(1)+1:ANfinalPos)]==2,1);
        
        %find previous trial's 1st and 2nd event
        latest1eventonset= find(triggers(1:event1onset(1)-1)==1);
        if ~isempty(latest1eventonset)
            latest1eventonset = latest1eventonset(end);
        else
            latest1eventonset = -1*sampling_rate;
        end
        latest2eventonset = find(triggers(1:event1onset(1))==2);
        if ~isempty(latest2eventonset)
            latest2eventonset = latest2eventonset(end);
        else
            latest2eventonset = -1*sampling_rate;
        end
    end
    
    if isempty(event2onset) || isempty(event1onset) %no events found
        indLastEvent = ANfinalPos;
    elseif length(event1onset)~=2 % 2nd trial was not found
        break;
    elseif (event2onset-event1onset(1))<=2*sampling_rate && (event2onset-event1onset(1))>0 && ...
            (event1onset(2)-event2onset)>=1*sampling_rate && ...
            (event1onset(1)-latest2eventonset)>=1*sampling_rate &&...
            (event1onset(1)-latest1eventonset)>=1*sampling_rate
        % 2nd event occured within 0-2 seconds of 1st event
        % 2nd trial occured after 1 second of 2nd event
        % 1st event occured after 1 second of previous trial's 2nd event
        % 1st event occured after 1 second of previous trial's 1st event
        eventIndices(:,num_events) = [event1onset(1); event2onset];
        indLastEvent = event1onset(1);
        num_events = num_events+1;
    else
        % next interation will look for events only after 2nd trial
        indLastEvent = event1onset(2)-1;
    end
end


%% to plot
set(0,'currentfigure',handles.figure1);
set(handles.figure1,'CurrentAxes',fh5);
hold on
plot(matlab_loopCounter,detected_num_events,'*');
grid on;

set(0,'currentfigure',handles.figure1);
set(handles.figure1,'CurrentAxes',fh5)
hold on
plot(matlab_loopCounter,num_events-1,'r*');
