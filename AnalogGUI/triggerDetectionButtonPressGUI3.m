function handles=triggerDetectionButtonPressGUI3(handles)

a=sprintf('ANIN%d ',handles.buttonPressChNum);
analogueChannels2Use=regexp(a,' ','split');
analogueChannels2Use=analogueChannels2Use(1:end-1);

%intervalStartEndSeconds=[5 1220];% defines the interval of data to use (in seconds)
minThresh=repmat(0.1,1,length(analogueChannels2Use));  %An event is triggered when this value is exceeded. One entry for each analogue channel
minDurOfStimulusInSeconds=repmat(.75,1,length(analogueChannels2Use)); % That is the duration of the event.This is a "dead time" after an event was detected. Other events happening during this interval are ignored.

%variables for result visualization
checkResultVisually=1;
pre=0.5; % interval start prior to the event
dur=1; % displpay interval duration

%RUN THIS TO MAKE THE TRIGGERS

%Load the analogue channel
for k=1:length(analogueChannels2Use)
    
    [analog_data,analog_params.sampFreq]=readhtk(sprintf('%s.htk',analogueChannels2Use{k}));%load analog channel
    %intervalStartEndSample=nearly(intervalStartEndSeconds,(1:length(analog_data))/analog_params.sampFreq);
    %analog_data(1:intervalStartEndSample(1))=0;
    %analog_data(intervalStartEndSample(2):end)=0;
    %min trigger duration to samples
    minDurOfStimulusInSamples=round(minDurOfStimulusInSeconds(k)*analog_params.sampFreq);
    threshData=double(analog_data>minThresh(k));%find all data above threshold
    trigger_buttonfreq=zeros(size(threshData));
    count=1;
    
    %go through each sample, keep the first non-zero trigger, and convert
    %the rest of that stimulus to 0
    while count<length(analog_data)
        if threshData(count)==1
            trigger_buttonfreq(count)=1;
            count=count+minDurOfStimulusInSamples;
        else
            count=count+1;
        end
    end
    
    clear threshData;
    %Check the triggers
    %Actually we do this below after downsampling the trigger time series to
    %the sampling rate of the neuronal data
    if 0
        if checkResultVisually
            %check if all onsets are correct
            idx=find(trigger_buttonfreq);
            figure;
            r=ceil(-pre*params.sampFreq:(-pre+dur)*analog_params.sampFreq);
            timebase=r*1000/analog_params.sampFreq;
            for m=1:length(idx)
                plot(timebase,[threshData(r+idx(m));data(r+idx(m));trigger_buttonfreq(r+idx(m))*2]');
                input(num2str(m));
            end
        end
    end
  
    
   %{
    %Now we have to downsample to the same sample frequency as the brain data
    currentPath=pwd;
    cd(sprintf('%s/%s/%s',handles.pathName,handles.folderName,'RawHTK'))
    [ecog_data,ecog_params.sampFreq]=readhtk('Wav11.htk');    
    cd(currentPath);
    ecogDataLength=length(ecog_data);
    clear ecog_data;
    
    decFac=analog_params.sampFreq/ecog_params.sampFreq;
    oldIdx=find(trigger_buttonfreq>0);
    newIdx=round(oldIdx/decFac);
    trigger_ecogfreq_pre=zeros(1,ecogDataLength);
    trigger_ecogfreq=zeros(1,ecogDataLength);

    for m=1:length(newIdx)
        trigger_ecogfreq_pre(newIdx(m))=trigger_buttonfreq(oldIdx(m));
    end
    
    %}
    
    
    %are the triggers good?
    
    %Downsample the button-press data to the brain data frequency for
    %viewing purposes
    
    %{
    
    [B,A] = butter(3,1/(2*decFac),'low'); %factor to nyquits of downsampled sequence
    analog_data=filtfilt(B,A,double(analog_data));
    aninDS=analog_data(1:decFac:end);
    
    %}
    % load the downssampled trigger and compared it to the downsampled analog channel
    idx=find(trigger_buttonfreq);
    
    
    times=idx/analog_params.sampFreq;
    times=times';
    BadTimesConverterGUI2 (times,sprintf('prelim_AN%d.lab',handles.buttonPressChNum(k)))

    fprintf('Check events in Wavesurfer. Type return to continue\n')
    keyboard
    label_file=sprintf('prelim_AN%d.lab',handles.buttonPressChNum(k)); 
    [ev1 ev2 s] = textread(label_file,'%f%f%s');
    
    ev1=ev1(2:end);
    ev1(end+1)=ev2(end);

    E_times=ev1/(1000*10000);
    E=ceil((ev1/(1000*10000))*analog_params.sampFreq);
    BadTimesConverterGUI2 (times,sprintf('transcript_AN%d.lab',handles.buttonPressChNum(k)))

    %{
    %stopIdx=strmatch('stop',s);
    ev1=ev1(2:end);
    ev1(end+1)=ev2(end);

    E_times=ev1/(1000*10000);
    E=ceil((ev1/(1000*10000))*analog_params.sampFreq);
    %{
    BadTimesConverterGUI3 (E_times,trialslog,sprintf('stimlus_log2_AN%d.lab',handles.buttonPressChNum(k)))

    printf('Check events in Wavesurfer. Type return to continue\n')
    keyboard
   
%}
    for i=1:size(E,1)
        
        trigger_ecogfreq(E(i))=1;
    end
    
    eval(sprintf('handles.trigger%s=trigger_ecogfreq',analogueChannels2Use{k}));
    save(['trigger'  analogueChannels2Use{k}],'trigger_ecogfreq','ecog_params')
    movefile(sprintf('trigger%s.mat', analogueChannels2Use{k}),sprintf('%s/%s',handles.pathName,handles.folderName)) 
    %{
    figure;
    %pre=0;dur=0.02;
    r=ceil(-pre*ecog_params.sampFreq:(-pre+dur)*ecog_params.sampFreq);
    timebase=r*1000/ecog_params.sampFreq;
    for m=1:length(idx)
        plot(timebase,aninDS(r+idx(m)))
        hold on
        plot(timebase,trigger_ecogfreq(r+idx(m))*0.1,'r');
        
        title(['Channel:' analogueChannels2Use{k} ' trial # : ' num2str(m)])
        input(num2str(m));
        hold off
    end
    %}
    
    
 
    
    %Go analyze next analog channel
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
