function [triggerTS,summedAnalogue]=ecogDigitalChannels2Trigger(basePath,fNames,decValues)
% [triggerTS,summedAnalogue]=ecogDigitalChannels2Trigger(basePath,fNames,decValues) % convert a set of digital channels to one analogue trigger channel
%
% PURPOSE:
% Suppose there a three digital channels each containing a series of zeros
% an ones coding events in a timeseries. This function mutliplies each 
% timeseries with the respective values in decVals and the sums the product 
% timepoint by timepoint. The resulting analogue timeseries is returned (optional)
% and a trigger time series where only the onset of a series of values is
% retained. 
% Example:
% [triggerTS,summedAnalogue]=ecogDigitalChannels2Trigger(pwd,{'analog_1','analog_2','analog_3','analog_4'},power(2,0:3))
%
% Restriction: A signals (series of ones) must have the same duration in all digital 
% channels. Otherwise this function will not work correctly.  
%
% INPUT:
% basePath:     The path where the mat files ccontaining thze digital
%               channels live. One timeseries per file is expected and only
%               one variable in the amt-file is allowed.
%
% fNames:       The names of the files containing the analogue channels 
%               in a cell array.
%
% decValues:    The decimal multiplier in the same order as the filenames 
% 
% OUTPUT: 
% triggerTS:    The timeseries of analogue trigger values. Only one sample
%               is set.
% 
% summedAnalogue: The timeseries of analogue values. The original length 
%               of the series of values is retained. OPTIONAL

% 091215 JR wrote it

data=[];
for k=1:length(fNames)
    fileloc=strcat(basePath,filesep,fNames{k},'.mat');
    if exist(fileloc,'file')
        aux=load(fileloc);
    else
        error(['Digital channel: ' fileloc ' not found'])
    end
    data=[data;aux.(cell2mat(fieldnames(aux)))];
end
thresh=std(data(:))*0.1; % allow some noise in the channels
if isrow(decValues)
    decValues=decValues';
end
summedAnalogue=sum(((((data')>thresh)*decValues)'),1);
triggerTS=summedAnalogue;
triggerTS = [0 diff(triggerTS)];
triggerTS(find(triggerTS<0))=0;
