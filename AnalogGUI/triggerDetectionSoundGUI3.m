function handles=triggerDetectionSoundGUI3(handles,stimuli)

a=sprintf('ANIN%d ',handles.soundCardChNum);
analogueChannels2Use=regexp(a,' ','split');
analogueChannels2Use=analogueChannels2Use(1:end-1);

%intervalStartEndSeconds=[1 1220];% defines the interval of data to use (in seconds)
minThresh=repmat(.9,1,length(analogueChannels2Use)); %An event is triggered when this value is exceeded. One entry for each analogue channel
%minDurOfStimulusInSeconds=repmat(0.7,1,length(analogueChannels2Use)); % That is the duration of the event.This is a "dead time" after an event was detected. Other events happening during this interval are ignored.
minDurOfStimulusInSeconds=repmat(.5,1,length(analogueChannels2Use)); % That is the duration of the event.This is a "dead time" after an event was detected. Other events happening during this interval are ignored.

stimulusLogFiles2Use={'trialslog_sounds.mat'};


%variables for result visualization
checkResultVisually=1;%user parameter
pre=0.1; % interval start prior to the event
dur=0.4; % displpay interval duration

for k=1:length(analogueChannels2Use)
    %load stimulus logfile
    
    %cd(sprintf('%s/%s',handles.pathName,handles.folderName))
    
    
    %load analogue channel
    [analog_data,analog_params.sampFreq]=readhtk(sprintf('%s.htk',analogueChannels2Use{k}));
    %intervalStartEndSample=nearly(intervalStartEndSeconds,(1:length(analog_data))/analog_params.sampFreq);
    %analog_data(1:intervalStartEndSample(1))=0;
    %analog_data(intervalStartEndSample(2):end)=0;
    %min trigger duration to samples
    minDurOfStimulusInSamples=round(minDurOfStimulusInSeconds(k)*analog_params.sampFreq);
    % I) Stimulus order from trialslog

    %onsetSamp=round(onsetTime*analog_params.sampFreq);
    
    
    
    %II) Sound onsets from sound channel
    % differentiate the time series
    dData=[0 diff(analog_data)];
    toneOnset=abs(dData>minThresh); %candidate onset
    toneOnset= [0 diff(toneOnset)>minThresh]; % correct offset introduced by diff
    for m=1:length(toneOnset) % find the first sample with a slope above threshold and then skip the samples within the rest of the tone
        if toneOnset(m)==1
            for n=1:minDurOfStimulusInSeconds*analog_params.sampFreq
                toneOnset(m+n)=0;
            end
            m=m+n;
        end
    end
    
    %toneOnset(1:intervalStartEndSample(1))=0;
    %toneOnset(intervalStartEndSample(2):end)=0;
    
    
    length(find(toneOnset))
    % III) Match stimulus order with sound onset to make trigger vector
    trigger_analogfreq=zeros(length(analog_data),2);
    tmp=find(toneOnset>0);
    
    trigger_analogfreq(tmp)=1; % This places the correct stimulus code at the correct temporal positionof the trigger vector. idx holds the index in the stimulus order for a specific stimulus type.
    
    disp(['Number of triggersfound: ' num2str(length(find(trigger_analogfreq>0)))])
    %Save what we have
   
     
    %{
    %Now we have to downsample to the same sample frequency as the brain data
    currentPath=pwd;
    cd(sprintf('%s/%s/%s',handles.pathName,handles.folderName,'RawHTK'))
    [ecog_data,ecog_params.sampFreq]=readhtk('Wav11.htk');
    cd(currentPath);
    ecogDataLength=length(ecog_data);
    clear ecog_data;
    decFac=analog_params.sampFreq/ecog_params.sampFreq;
    oldIdx=find(trigger_analogfreq>0);
    newIdx=round(oldIdx/decFac);
    trigger_ecogfreq_pre=zeros(1,ecogDataLength);
    trigger_ecogfreq=zeros(1,ecogDataLength);
    for m=1:length(newIdx)
        trigger_ecogfreq_pre(newIdx(m))=trigger_analogfreq(oldIdx(m));
    end
    
    
    
    %are the triggers good?
   
    [B,A] = butter(3,1/(2*decFac),'low'); %factor to nyquits of downsampled sequence
    analog_data=filtfilt(B,A,double(analog_data));
    aninDS=analog_data(1:decFac:end);
    %}   
    
    % load the downssampled trigger and compared it to the downsampled analog channel
    %idx=find(trigger_analogfreq);
    times=tmp/analog_params.sampFreq;
    times=times';

    BadTimesConverterGUI2 (times,sprintf('prelim_AN%d.lab',handles.soundCardChNum))

    fprintf('Check events in Wavesurfer. Type return to continue\n')
    keyboard
    label_file=sprintf('prelim_AN%d.lab',handles.soundCardChNum); 
    [ev1 ev2 s] = textread(label_file,'%f%f%s');

    %stopIdx=strmatch('stop',s);
    ev1=ev1(2:end);
    ev1(end+1)=ev2(end);

    E_times=ev1/(1000*10000);
    E=ceil((ev1/(1000*10000))*analog_params.sampFreq);
    if stimuli~=1
        ev1=ev1(2:end);
        ev1(end+1)=ev2(end);

        E_times=ev1/(1000*10000);
        E=ceil((ev1/(1000*10000))*analog_params.sampFreq);
        BadTimesConverterGUI2 (times,sprintf('transcript_AN%d.lab',handles.soundCardChNum))
    else
    load('trialslog_sounds.mat')
    BadTimesConverterGUI3 (E_times,trialslog(:,1),sprintf('transcript_AN%d.lab',handles.soundCardChNum))

    fprintf('Check events in Wavesurfer. Type return to continue\n')
    keyboard
    end
    
    %{
    for i=1:size(E,1)
        mark=strmatch(trialslog{i},availStim);
        trigger_ecogfreq(E(i))=mark;
    end
    
    
    eval(sprintf('handles.trigger%s=trigger_ecogfreq',analogueChannels2Use{k}));
    save(['trigger'  analogueChannels2Use{k}],'trigger_ecogfreq','ecog_params')
    movefile(sprintf('trigger%s.mat', analogueChannels2Use{k}),sprintf('%s/%s',handles.pathName,handles.folderName)) 
    
    if length(analogueChannels2Use)>k
        flag = 0;
        while flag==0
            r=input(['Continue processing next set? [y]/n '],'s');
            if strcmpi('y',r)
                flag = 1;
                % Next channel
            elseif strcmpi('n',r)
                error(['User aborted. Current channel: ' analogueChannels2Use{k}]);
                flag=0;
            else
                disp('Inavlid answer. Try again.')
                flag=0;
            end
        end
    end
    %}
end