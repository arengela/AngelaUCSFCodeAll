function [channeldata, samplingRate] = edfExtractChanFull(fullfilepath, channelNo)
% edfExtractChanFull.m extracts all samples from a single channel from edf 
%       or edf+ file and returns the resulting list of channel data
%
% Usage example:[channeldata, samplingRate] = edfExtractChanFull('My/File/Path/filename.edf', 1)
% 
% Input:   fullfilepath - 	string listing full path to edf file 
%           channelNo -     integer listing of channel.
% Output:  channeldata is array in microVolts (or whatever chaninfo says)
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE:  BE CAREFUL if using this on a non-Nicolet exported EDF file, may need to
% change certain fields, or pay attention to things ignored. 
% Note: this extracts header twice, but the delay is relatively
% insignificant. 


%% User Settings
eegfile=fullfilepath;

%% Get info
hinfo = edfExtractHeader(eegfile);
        ns = hinfo.nchan;
        nrecords = hinfo.nrecords;
        duration = hinfo.duration;
maxSec = hinfo.nrecords*hinfo.duration;


clipBounds = [0, maxSec];
[channeldata, samplingRate] = edfExtractChanClip(fullfilepath, channelNo, clipBounds);

end
