function ecogTDTData2MatlabConvertMultTags(rawDataPath,blockName,varargin)
%function
%ecogTDTData2MatlabConvertMultTags(rawDataPath,blockName,tags2Export,channels2Export) Dump all channels in a TDT block to matlab files
%
% PURPOSE:  Transform raw TDT data to matlab files. Each channel is written
%           into a separate mat-file. Precision is single. Function is a wrapper
%           for ecogTDTData2Matlab where the actual work is done.
%
% INPUT:
% rawDataPath:      The directory where the raw TDT files live
%                   e.g. D:\Data\Ecog\GP22_B20\
% blockName:        The data block to read: e.g. GP22_B20 (Note Ecog2_ will
%                   be prepended read the TDT files. This should match their
%                   naming scheme).
% tags2Export:      OPTIONAL: A cell array of four letter strings listing the
%                   the tags be exported. Think of a tag as a container for
%                   a set of channels that somehow belong together (e.g. ECOG,
%                   ANAL etc.). Call 'ecogTDTGetBlockInfo' to obtain a list
%                   of avaibale tags.
%                   DEFAULT: All tags containing at least one channel.
% chans2Convert:    OPTIONAL: A cell array of channels to convert. Each
%                   cell lists lists the channel numbers for the correponding
%                   tag. e.g. 1:64 will convert the first 64 channels. Note
%                   that specified channels that do not exist with a certain
%                   tag will not be exported
%                   DEFAULT: All channels found for with a tag
%
% OUTPUT:           The data are written to mat-files in the same path where
%                   the TDT files live. The naming is tagnameNumberOfChannel
%                   i.e. ECOG1.mat ECOG2.mat... or ANAL1.mat, ANAL2.mat...
%                   A params-structure saved in each file holds information
%                   about sampling frequency etc
%
% EXAMPLE:
% ecogTDTData2MatlabConvertMultTags(pwd,'HD6_Block2',{'Wave','ANIN'},{[1 14],[1 3]})
% Dumps Wave1, Wave14, ANIN1, and ANIN3 of HD6_Block2 and we are currently
% in the directory where the *.tev file lives
%
% REQUIREMENTS:     This function requires Microsoft Windows, the
%                   TDT drivers, an OpenDeveloper installed (the latter reqquires
%                    OpenEx)
%                   Get the software from www.tdt.com. OpenEX and OpenDeveloper are
%                   password protected
%

% 090402 JR wrote it
% 090812 JR Major bug in chouce of tags fixed 
%           Choice of channels is now functional


if nargin<2
    disp('ecogTDTData2MatlabConvertMultTags: Not enough input arguments. Quitting!')
    return;
end

paramsGlobal=ecogTDTGetBlockInfo(rawDataPath,blockName);

%dump everthing
if nargin<3
    % get info about the tank content
    paramsGlobal=ecogTDTGetBlockInfo(rawDataPath,blockName);
    for k=1:size(paramsGlobal.tagNames,1)
        if ~isempty(paramsGlobal.nChannels(k)) & paramsGlobal.nChannels(k)>0
            sampFreq = ecogTDTData2Matlab(rawDataPath,blockName,1:paramsGlobal.nChannels(k),paramsGlobal.tagNames(k,:),rawDataPath,paramsGlobal.tagNames(k,:));
        end
    end
end
% tag names were passed
nChannels=[];
if nargin>=3
    tagNames=varargin{1};
    if nargin>=4
        channelLists=varargin{2};
    else
        nChannels={[]};
    end
    for k=1:length(tagNames)
        tagExistsFlag=0;
        for m=1:size(paramsGlobal.tagNames,1)
            % find the number of available channels
            if strcmp(tagNames{k},paramsGlobal.tagNames(m,:))
                if nargin<4 % dump all channels with that tag if nothing was passed
                    nChannels=1:paramsGlobal.nChannels(m);
                else
                    nChannels=channelLists{k};
                end
                tagExistsFlag=1;

                % dump the data if something was found
                if ~isempty(nChannels) & nChannels>0
                    sampFreq = ecogTDTData2Matlab(rawDataPath,blockName,nChannels,tagNames{k},rawDataPath,tagNames{k});
                end
            end
        end
        if ~tagExistsFlag
            disp(['Tag: ' tagNames{k} 'not found. Use ecogTDTGetBlockInfo to get a list of available tags.'])
        end
    end
end
