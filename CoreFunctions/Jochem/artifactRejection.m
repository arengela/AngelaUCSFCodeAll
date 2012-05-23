% AIM IN THIS SCRIPT IS TO
%% B) DETERMINE BAD TEMPORAL INTERVALS WITH SIGNAL JUMPS ETC
%% C) DETERMINE BAD CHANNELS
%% EACH OF THE BELOW CODE SEGMENTS IS DESIGNED FOR ONE OR MORE OF THESE TASKS
%% COMMENTS INDICATE WHERE USER DATA ARE REUIRED.
%%
%% STEP 2: BAD SEGMENTS AND BAD CHANNELS BASED ON VISUAL INSPECTION
% This might require several cycles
% *** User parameters 1/2
nameOfEcogFileToLoad='ecog'; % the data file we work on
nameOfEcogFileForResults='ecog'; % the data file we write to


%RUN THIS TO LOOK AT THE DATA
load(nameOfEcogFileToLoad)
ecog.nBaselineSamp=ecog.nSamp;
ecog=ecogBaselineCorrect(ecog);
ecogTSGUI(ecog)

% *** User Parameters 2/2. BASED ON INSPECTION DEFINE THESES VARIABLES
badIntervalsSeconds=[[0 1]; [ecog.timebase(end)-1000 ecog.timebase(end)]./1000]; %Bad intervals are defined in pairs of data [[startSec1 endSec1]; [startSec2 endSec2];....]
badChannels=[49 113:116 124 128 256]; % a list of bad channels in addition to the list found by the automatic criteria. Overlaps will be removed.
minMaxVariabilityInChannel=[30 60];

%Remove bad intervals
if ~isempty(badIntervalsSeconds)
    badIntervalsSamples=reshape(nearly(badIntervalsSeconds(:)*1000,ecog.timebase),size(badIntervalsSeconds,1),size(badIntervalsSeconds,2));
    badIntervalsSampleIdx=[];
    for k=1:size(badIntervalsSamples,1) %make a vector of sample indices
        badIntervalsSampleIdx=[badIntervalsSampleIdx badIntervalsSamples(k,1):badIntervalsSamples(k,2)];
    end
    ecog.data(:,badIntervalsSampleIdx)=[];
    ecog.triggerTS(:,badIntervalsSampleIdx)=[];
    ecog.nSamp=size(ecog.data,2);
    ecog.nBaselineSamp=ecog.nSamp;
    ecog.timebase=(0:ecog.nSamp)*ecog.sampDur;
    ecog.badChannels=badChannels;
end
save(nameOfEcogFileForResults, '-v7.3','ecog')

%% STEP 3: BAD CHANNELS BY STANDARD DEVIATION
% *** User parameters 1/2
nameOfEcogFileToLoad='ecog'; % the data file we work on
nameOfEcogFileForResults='ecog'; % the data file we write to

%RUN THIS TO LOOK AT THE DATA
load(nameOfEcogFileToLoad)
s=std(ecog.data')
figure;plot(s); axis tight
hold on; plot(ecog.badChannels,s(ecog.badChannels),'r.')
legend({'standard deviation', 'currently marked bad channels'})

% *** User parameters 2/2 MINIMUM AND MAXIMUM STANDRADDEVIATION BASED ON PLOT
minMaxStandarddeviation=[35 60];

%Set bad channels and make sure there are no copies
idx=find(s<minMaxStandarddeviation(1) | s>minMaxStandarddeviation(2));
ecog.badChannels=unique([ecog.badChannels idx]);
% save what we have
save(nameOfEcogFileForResults, '-v7.3','ecog')

%% STEP 4: BAD CHANNELS BY PERIODOGRAM
% *** User parameters 1/2
nameOfEcogFileToLoad='ecog'; % the data file we work on
nameOfEcogFileForResults='ecog'; % the data file we write to
periodogramFrequencyband=[0 200]; % the frequency band to look at
badChannels=[]; % Enter bad channels from periodogram here
showInGuiOrSingleChannel='s'; % 'g' for GUI 's'for a sequence of single channel plots
%showFrequencyBandInSingleChannelDisplay=periodogramFrequencyband; % [1 20];% if you want to focuson a certain frequency band to detect bad channels in the single channel display
showFrequencyBandInSingleChannelDisplay=[1 200];% if you want to focuson a certain frequency band to detect bad channels in the single channel display

%RUN THIS TO LOOK AT THE DATA.
load(nameOfEcogFileToLoad)
ecogDS=ecogDownsampleTS(ecog,periodogramFrequencyband(end)*2); % Downsample to be more memory efficient.
clear params
params.Fs=1000/ecogDS.sampDur; 
params.fpass=periodogramFrequencyband;
params.tapers=[2*ecogDS.timebase(end)/1000/10 5];
ecogDS=ecogMkPeriodogramMultitaper(ecogDS,1,params);
%fStepsPerHz=1/(ecogDS.periodogram.centerFrequency(2)-ecogDS.periodogram.centerFrequency(1));
p=[]
count=1;
ecogDS.periodogram.periodogram=ecogDS.periodogram.periodogram';
for k=periodogramFrequencyband(1):periodogramFrequencyband(2)-1 % New periodogram has 1HZ resolution
    p=[p mean(ecogDS.periodogram.periodogram(:,nearly(k,ecogDS.periodogram.centerFrequency):nearly(k+1,ecogDS.periodogram.centerFrequency)),2)];
end
f=[periodogramFrequencyband(1):periodogramFrequencyband(2)-1];
if strcmp(showInGuiOrSingleChannel,'g')
    ecogDS.data=log10(p);
    ecogDS.timebase=[periodogramFrequencyband(1):periodogramFrequencyband(2)-1]*1000;
    ecogDS.sampDur=1000;
    ecogTSGUI(ecogDS)
elseif strcmp(showInGuiOrSingleChannel,'s')
    idx=nearly(showFrequencyBandInSingleChannelDisplay,f);
    f=f(idx(1):idx(2));
    s=std(log10(p(ecogDS.selectedChannels,idx(1):idx(2))));
    m=mean(log10(p(ecogDS.selectedChannels,idx(1):idx(2))));
    for k=1:size(ecogDS.periodogram.periodogram,1);
        plot(f, m-s,'k-');
        hold on
        plot(f, m+s,'k-');
        plot(f,log10(p(k,idx(1):idx(2))),'r');
        title(['Channel #: ' num2str(k)]);
        legend('mean +- 1 std','','current channel')
        xlabel('frequency [Hz]');
        ylabel('log energy [log10 uV]')
        hold off;
        r=input('good channel? [y]/n ','s');
        if isempty(r) || strcmpi('y',r)
            % skip this channel
        elseif strcmpi('n',r)
            badChannels=[badChannels k];
        else
            disp('Inavlid answer. Keeping channels marked good')
            % skip this channel
        end
    end
end


%Set bad channels and make sure there are no copies
ecog.badChannels=unique([ecog.badChannels badChannels]);
% save what we have
save(nameOfEcogFileForResults, '-v7.3','ecog')
