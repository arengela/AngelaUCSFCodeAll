function [ allChanData, samplingRates, annotations, headerInfo ] = edfExtractAllData( fullfilepath )
%[ allChan, samplingRate, annotations, headerInfo ] = edfExtractAllData( fullfilepath )
%   Extracts all channel information from a edf file path including all
%   channel information in mV, sampling rates, annotations if file is an
%   edf+, and headerInformation which may be useful.
%
% Example usage: 
%  [ allChanData, samplingRates, annotations, headerInfo ] = edfExtractAllData('/Users/Vera/Desktop/WorkingFiles/S5/edfDataSz/s5_10_10_09_14_35_05ecog3.edf');
% 
% Input: string of full file path
%
% Output:
%       allChanData: cell array, with all non-annotation data samples
%           from each channel arranged here.  allChanData{1} contains channel
%           1 data from entire file
%       samplingRates:  all channel sampling rates
%       annotations:  either annotations from edf+ file, or empty matix if
%           not an edf+ file
%       headerInfo: headerInformation 
%
%
% Warning: for most files, loading all data information will be too large
% to hold in memory all at same time and also take a very long time to
% load.  Only use this for small files. 
% 
% Note: this will use edfExtractHeader multiple times, could design this to
% only be used once, but would complicate function calls with varargin. May
% be a good idea in future


%% Get info
hinfo = edfExtractHeader(fullfilepath);
        nChannels = hinfo.nchan;
maxSec = hinfo.nrecords*hinfo.duration;
clipBounds = [0, maxSec];

if hinfo.isEdfPlus
    %If it is an EDF+ file
    annotations = edfExtractAnnotations(fullfilepath);
    fprintf('\nAnnotations extracted\n Beginning data extraction \n');
    
    allChanData = cell(1, nChannels-1);
    samplingRates = zeros(1, nChannels-1);
    for k=1:nChannels-1
       %Warning: assumes annotation are last channel
       [allChanData{k}, samplingRates(k)] = edfExtractChanClip(fullfilepath, k, clipBounds);
       fprintf('Extracted channel %g\n', k);
%edfExtractChanFull(  fullfilepath, k); 
    end
else
   %If is regular EDF file (not EDF+ file)
    annotations = [];
    allChanData = cell(1, nChannels);
    samplingRates = zeros(1, nChannels);
    for k=1:nChannels
       [allChanData{k}, samplingRates(k)] = edfExtractChanClip(fullfilepath, k, clipBounds); % edfExtractChanFull(  fullfilepath, k); 
    end
end
headerInfo = hinfo;
end

