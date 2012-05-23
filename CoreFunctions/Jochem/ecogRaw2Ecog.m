function ecog=ecogRaw2Ecog(data,baselineDurMs,sampDur,badChannels,sampFreq, refChan,channel2GridMatrixIdx)
% ecog=ecogRaw2Ecog(data,baselineDurMs,sampDur,badChannels,refChan,channel2GridMatrixIdx) create an ecog structure with trials  
% PURPOSE:
% Create a ecog structure from raw data.
% At least data and timebase need to be passed.
% The baseline duration is calculated as the last sample in timabse with a
% negative value
%
% INPUT:
% data:         A matrix with dimensions channels x timepoints x trials
% baselineDurMs: The baseline duration in ms
% samDurMs:     The duration of one sample in ms (1000/sampling frequency
%               in Hz)
% badChannels:  Indices to bad channels 
% sampFreq:     sampling frequency
% refChan:      The number of the reference channel in "data".
% channel2GridMatrixIdx: A nChannels x 2 matrix OR a scalar value
%               If scalar: defines the number of columns used for plots on
%               grid matrices
%               If matrix: a list of cartesian x (column 1) and y (column 2)
%               defining the position for each channel in the matrix plot
%               See command 'subplot' for more information.
%               See command 'ecogMatrixPlotTS' to see how this field can be
%               changed post hoc
%
% OUTPUT:
% ecog:         A structure with fields: 
%               data: holds the measured time series multiplied by 1e6.
%               This should convert to muV
%               (channels x timepoints x trials)
%                      
%               timebase: A vector containing the acquisition 
%               time (in ms) for each sample(size(data,2) x 1) 
%               baselineDur: the baseline duration in ms
%               nSamp: the number of samplles in a trial
%               nBaselineSamp: the index pointing to the last baseline
%               selectedChannels: channels other functions should operate
%               upon
%               badChannels: Indices to bad channels;
%               excludeBad: Signals if bad channels should be removed from
%               the analysis. Functions aware of a channel list will remove
%               bad channels from the analysis if this flag is set to 1.
%               OPTIONAL FIELDS
%               refChanNum: the number of the refrence channel (only a
%               refrence time serieres was contained in the original data matrix
%               refChanTS: the time series of the reference channel
%               sampDur: the duration of a sample in ms
% TODO: If ref is some other channel than 64 we have to deal with the
%       shifts in channel numbering

% 090105 JR wrote it
% 090121 JR added field channel2GridMatrixIdx

if nargin>2
    ecog.data=data*1e6;
    ecog.timebase=[0:(size(data,2)-1)]*sampDur-baselineDurMs;
    ecog.sampDur=sampDur;
    ecog.sampFreq=sampFreq;
    ecog.baselineDur=baselineDurMs;
    ecog.nSamp=length(ecog.timebase);
    ecog.nBaselineSamp=ceil(baselineDurMs/sampDur); %CHECK THAT CEIL() CANNOT GO WRONG!!
    ecog.selectedChannels=1:size(ecog.data,1);
    ecog.badChannels=badChannels;
    ecog.excludeBad=0;
else 
    warning('Creating a structure with fields left empty!')
    ecog.data=[];
    ecog.timebase=[];
    ecog.sampDur=[];
    ecog.sampFreq=[];
    ecog.nSamp=[];
    ecog.nBaselineSamp=[];
    ecog.selectedChannels=[];
    ecog.badChannels=[];
    ecog.excludeBad=0;
end

if nargin>5
    if ~isempty(refChan)
        ecog.refChanNum=refChan;
        ecog.refChanTS=ecog.data(ecog.refChanNum,:,:);
        ecog.data=ecog.data(setdiff(1:size(ecog.data,1),ecog.refChanNum),:,:);
        ecog.selectedChannels=1:size(ecog.data,1);
    else
        ecog.refChanTS=[];
    end
end

if nargin>6 && ~isempty(channel2GridMatrixIdx)
    if prod(size(channel2GridMatrixIdx))==1   %A scalar calculate the matrix
        nRows=ceil(size(ecog.data,1)/channel2GridMatrixIdx);
        [channel2SubplotX, channel2SubplotY] = meshgrid([1:nColumns],[1:nRows]); % We work in cartesian coordinates on this
        %This is how we will index the subplots in the matrix of plots
        ecog.channel2GridMatrixIdx=[channel2SubplotX(1:size(ecog.data,1))' channel2SubplotY(1:size(ecog.data,1))'];
    else
        ecog.channel2GridMatrixIdx=channel2GridMatrixIdx;
    end
else % Nothing was passed. We assume a square grid
    nRows=ceil(sqrt(size(ecog.data,1)));
    nColumns=ceil(size(ecog.data,1)/nRows);
    [channel2SubplotX, channel2SubplotY] = meshgrid([1:nColumns],[1:nRows]); % We work in cartesian coordinates on this
    %This is how we will index the subplots in the matrix of plots
    ecog.channel2GridMatrixIdx=[channel2SubplotX(1:size(ecog.data,1))' channel2SubplotY(1:size(ecog.data,1))'];
end

% if nargin>5 && ~isemtpy(params)
%     ecog.spectrogram.params.movingWin=[0.5 0.01]; % set the moving window dimensions
%     ecog.spectrogram.params.Fs=1000/ecog.sampDur; % sampling frequency
%     ecog.spectrogram.params.fpass=[0 200]; % The range of frequencies to analyze
%     ecog.spectrogram.params.tapers=[3 5]; %DEFAULT [3 5] keep [TW K] with k<2TW increasings seems to better lokalize frequency in spectrum 
%     ecog.spectrogram.params.trialave=0; % average over trials
%     ecog.spectrogram.params.err=0; % no error computation
%     ecog.spectrogram.params.pad=-1; % -1 pad is as long as sequence 0: pad is next power of two larger than sequence length, 1: pad is next+1 powers of two larger, 2: pad ist next+2 powers longer

