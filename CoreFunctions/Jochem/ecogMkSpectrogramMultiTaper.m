function ecog=ecogMkSpectrogramMultiTaper(ecog,trialList,param)
% ecog=ecogMkSpectrogramMultiTaper(ecog,trialList,param) calculates spectrograms of ecog data using the multitaper technique implemented in the chronux toolbox
%
% Purpose:  Calculate the spectrograms of the time series data. 
%           Optimized for separation of frequency bands.
%           Builds upon the chronux toolbox.
%           Adds the spectrograms as a separet field to the input structure
% 
% INPUT:
% ecog:      an ecog structure
% trialList: OPTIONAL: A vector with trialnumbers to process. Default is
%            all
% param:     OPTIONAL: A structure of paramters for spectrogram calculation
%            passed to 'mtspecgramc'. The fields missing in the structure passed
%            will be filled with the default values
%
%            params.movingWin Default [0.5 0.05] set the moving window
%            width and stepsize in seconds
%            params.Fs        Default 1000/ecog.sampDur; sampling frequency
%            params.fpass     Default [0 200] frequency range (Hz) of interest
%            params.tapers    Default [3 5] tapers
%            params.trialave  Default 0 average over trials (1 averages and 
%                             only one spectrogram will be retured)
%            params.err       Default 0 no error computation (1 untesteted so far)
%            params.pad       Default -1 width of padding -1 means same
%                             length as time series (0 1 2.. is possible see 
%                             ecogRaw2ecog for explanation) 
%
% OUTPUT:
% ecog:     Returns the ecog structure with the field spectrogram added that 
%           contains the following fields:
%           trialList:  Indices of the trials processed
% 
% TODO: Include some bandwidth handling; Can we get errors; 

% 090122 JR wrote it

% INPUT HANDLING
if  ~exist('trialList') || isempty(trialList) %if nothing was passed or [] was passed
    ecog.spectrogram.trialList=1:size(ecog.data,3);
elseif nargin>1 
    ecog.spectrogram.trialList=trialList;
else
    error('Should never get get here')
end
if  ~exist('param','var') || isempty(param) || ~isfield(ecog.spectrogram,'params') %if nothing was passed or [] was passed or field does not exist
    ecog.spectrogram.params.movingWin=[0.5 0.01]; % set the moving window dimensions
    ecog.spectrogram.params.Fs=1000/ecog.sampDur; % sampling frequency
    ecog.spectrogram.params.fpass=[0 200]; % frequency of interest
    ecog.spectrogram.params.tapers=[3 5]; % tapers
    ecog.spectrogram.params.trialave=0; % average over trials
    ecog.spectrogram.params.err=0; % no error computation
    ecog.spectrogram.params.pad=-1; % padding for frequency analysis
elseif nargin>2  %We assumes that the params contains meaningful information 
    if isfield(params,'movingWin')
        ecog.spectrogram.params.movingWin=params.movingWin;
    else
        ecog.spectrogram.params.movingWin=[0.5 0.01]; % set the moving window dimensions
    end
    if isfield(params,'Fs')
        ecog.spectrogram.params.Fs=params.Fs;
    else
        ecog.spectrogram.params.Fs=1000/ecog.sampDur; % sampling frequency
    end
    if isfield(params,'fpass')
        ecog.spectrogram.params.fpass=params.fpass;
    else
        ecog.spectrogram.params.fpass=[0 200]; % frequency of interest
    end
    if isfield(params,'tapers')
        ecog.spectrogram.params.tapers=params.tapers;
    else
        ecog.spectrogram.params.tapers=[3 5]; % tapers
    end
    if isfield(params,'trialave')
        ecog.spectrogram.params.trialave=params.trialave; % average over trials
    else 
        ecog.spectrogram.params.trialave=0;
    end
    if isfield(params,'err')
        ecog.spectrogram.params.err=params.err;
    else 
        ecog.spectrogram.params.err=0; % no error computation
    end
    if isfield(params,'pad')
        ecog.spectrogram.params.pad=params.pad;
    else 
        ecog.spectrogram.params.pad=-1; % no error computation
    end
elseif nargin>2 && isfield(ecog.spectrogram,'params') % this will overwrite only what has been passed. The above will overwrite in any case and makes sure that all fields exist after this function is passed
    if isfield(params,'movingWin')
        ecog.spectrogram.params.movingWin=params.movingWin;
    end
    if isfield(params,'Fs')
        ecog.spectrogram.params.Fs=params.Fs;
    end
    if isfield(params,'fpass')
        ecog.spectrogram.params.fpass=params.fpass;
    end
    if isfield(params,'tapers')
        ecog.spectrogram.params.tapers=params.tapers;
    end
    if isfield(params,'trialave')
        ecog.spectrogram.params.trialave=params.trialave; % average over trials
    end
    if isfield(params,'err')
        ecog.spectrogram.params.err=params.err;
    end
    if isfield(params,'pad')
        ecog.spectrogram.params.pad=params.pad;
    end
end
% END OF INPUT PROCESSING

%Calculate the spectrograms
if size(ecog.data,3)==1 %saves some meory if we do a whole run at once 
    [ecog.spectrogram.spectrogram,ecog.spectrogram.centerTime,ecog.spectrogram.centerFrequency]=mtspecgramc(ecog.data',ecog.spectrogram.params.movingWin,ecog.spectrogram.params);
else
    for k=1:size(ecog.data,3) % do trial after trial 
        tmp=squeeze(ecog.data(:,:,k));
        [s,t,f]=mtspecgramc(tmp',ecog.spectrogram.params.movingWin,ecog.spectrogram.params);
        if k==1
            ecog.spectrogram.spectrogram=zeros([size(s), size(ecog.data,3)]);
            ecog.spectrogram.centerTime=t;
            ecog.spectrogram.centerFrequency=f;
        end
        ecog.spectrogram.spectrogram(:,:,:,k)=s;
    end
end

if ecog.spectrogram.params.trialave==1
    ecog.spectrogram.spectrogram=mean(ecog.spectrogram.spectrogram,4);
end





