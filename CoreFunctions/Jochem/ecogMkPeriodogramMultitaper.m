function [ecog]=ecogMkPeriodogramMultitaper(ecog,trialList,params) %Calculate a periodogram for each data channel
% amplitudeSpectrum=ecogPeriodogram(ecog,trialList,param) %Calculate a periodogram for each data channel
% PURPOSE:
% Calculate a periodogram in the specified frequency range for each ecog
% channel
%
% INPUT:
% ecog:         An ecog structure with at least the fields data and sampDur
% freqRange:    The range of frequencies for the periodogram
%
% OUTPUT:
% ampSpectrum:  The amplitudespectra. One for each channel
% freqs:        The frequency axis for plotting the spectra
%
% Requirements: Signal processing toolbox


% We might want to calculate the spectrum at pre-specified frequencies

%ampSpectrum=periodogram(ecog.data'));

%(ecog,trialList,param)
% Purpose:  Calculate the periodograms of the time series data.
%           Optimized for separation of frequency bands.
%           Builds upon the chronux toolbox.
%           Adds the periodograms as a separet field to the input structure
%
% INPUT:
% ecog:      an ecog structure
% trialList: OPTIONAL: A vector with trialnumbers to process. Default is
%            all
% param:     OPTIONAL: A structure of paramters for periodogram calculation
%            passed to 'mtspecgramc'. The fields missing in the structure passed
%            will be filled with the default values
%
%            params.Fs        Default 1000/ecog.sampDur; sampling frequency
%            params.fpass     Default [0 200] frequency range (Hz) of interest
%            params.tapers    Default [3 5] tapers
%            params.trialave  Default 0 average over trials (1 averages and
%                             only one periodogram will be retured)
%            params.err       Default 0 no error computation (1 untesteted so far)
%            params.pad       Default -1 width of padding -1 means same
%                             length as time series (0 1 2.. is possible see
%                             ecogRaw2ecog for explanation)
%
% OUTPUT:
% ecog:     Returns the ecog structure with the field periodogram added that
%           contains the following fields:
%           trialList:  Indices of the trials processed
%
% TODO: Include some bandwidth handling; Can we get errors;

% 090122 JR wrote it

% INPUT HANDLING
if  ~exist('trialList') || isempty(trialList) %if nothing was passed or [] was passed
    ecog.periodogram.trialList=1:size(ecog.data,3);
elseif nargin>1
    ecog.periodogram.trialList=trialList;
else
    error('Should never get get here')
end
if  ~exist('param','var') || isempty(param) || ~isfield(ecog.periodogram,'params') %if nothing was passed or [] was passed or field does not exist
    ecog.periodogram.params.movingWin=[0.5 0.01]; % set the moving window dimensions
    ecog.periodogram.params.Fs=params.Fs; % sampling frequency
    ecog.periodogram.params.fpass=[0 200]; % frequency of interest
    ecog.periodogram.params.tapers=[3 5]; % tapers
    ecog.periodogram.params.trialave=0; % average over trials
    ecog.periodogram.params.err=0; % no error computation
    ecog.periodogram.params.pad=-1; % padding for frequency analysis
elseif nargin>2  %We assumes that the params contains meaningful information
    if isfield(params,'movingWin')
        ecog.periodogram.params.movingWin=params.movingWin;
    else
        ecog.periodogram.params.movingWin=[0.5 0.01]; % set the moving window dimensions
    end
    if isfield(params,'Fs')
        ecog.periodogram.params.Fs=params.Fs;
    else
        ecog.periodogram.params.Fs=1000/ecog.sampDur; % sampling frequency
    end
    if isfield(params,'fpass')
        ecog.periodogram.params.fpass=params.fpass;
    else
        ecog.periodogram.params.fpass=[0 200]; % frequency of interest
    end
    if isfield(params,'tapers')
        ecog.periodogram.params.tapers=params.tapers;
    else
        ecog.periodogram.params.tapers=[3 5]; % tapers
    end
    if isfield(params,'trialave')
        ecog.periodogram.params.trialave=params.trialave; % average over trials
    else
        ecog.periodogram.params.trialave=0;
    end
    if isfield(params,'err')
        ecog.periodogram.params.err=params.err;
    else
        ecog.periodogram.params.err=0; % no error computation
    end
    if isfield(params,'pad')
        ecog.periodogram.params.pad=params.pad;
    else
        ecog.periodogram.params.pad=-1; % no error computation
    end
elseif nargin>2 && isfield(ecog.periodogram,'params') % this will overwrite only what has been passed. The above will overwrite in any case and makes sure that all fields exist after this function is passed
    if isfield(params,'movingWin')
        ecog.periodogram.params.movingWin=params.movingWin;
    end
    if isfield(params,'Fs')
        ecog.periodogram.params.Fs=params.Fs;
    end
    if isfield(params,'fpass')
        ecog.periodogram.params.fpass=params.fpass;
    end
    if isfield(params,'tapers')
        ecog.periodogram.params.tapers=params.tapers;
    end
    if isfield(params,'trialave')
        ecog.periodogram.params.trialave=params.trialave; % average over trials
    end
    if isfield(params,'err')
        ecog.periodogram.params.err=params.err;
    end
    if isfield(params,'pad')
        ecog.periodogram.params.pad=params.pad;
    end
end
% END OF INPUT PROCESSING

%Calculate the periodograms
for k=1:size(ecog.data,3)
    tmp=squeeze(ecog.data(:,:,k));
    if ecog.periodogram.params.err==0
        [s,f]=mtspectrumc(tmp',ecog.periodogram.params);
        
    else
        [s,f,sErr]=mtspectrumc(tmp',ecog.periodogram.params);
    end
    if k==1
        ecog.periodogram.periodogram=zeros([size(s), size(ecog.data,3)]);
        if ecog.periodogram.params.err~=0
            ecog.periodogram.periodogramSErr=ecog.periodogram.periodogram;
        end
        %ecog.periodogram.centerTime=t;
        ecog.periodogram.centerFrequency=f;
    end
    ecog.periodogram.periodogram(:,:,k)=s;
    if ecog.periodogram.params.err~=0
        ecog.periodogram.periodogramSErr(:,:,k)=sErr;
    end
end

if ecog.periodogram.params.trialave==1
    ecog.periodogram.periodogram=mean(ecog.periodogram.periodogram,3);
end