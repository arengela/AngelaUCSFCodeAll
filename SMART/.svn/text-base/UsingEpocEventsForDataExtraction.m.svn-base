TT = actxcontrol('TTank.X');
invoke(TT,'ConnectServer','Local','Me');
e=invoke(TT,'OpenTank','c:\TDT\Openex\Tanks\demotank2','R');% this should all have error checking but I have left it out.
e1=invoke(TT,'SelectBlock','test6');% this should all have error checking but I have left it out.
if e1+e==2 
%the part above is self explanatory
MyEpocs=invoke(TT,'GetEpocsV','Valu',0,0,1000); % Returns the Epoc events for Trigger returns a NaN event in this case
%tranges = invoke (TT, 'GetValidTimeRangesV');% Gets the start and end of the Time ranges.
Filt1 = invoke (TT, 'SetFilterWithDescEx','Valu=3')% Sets the filter to last triggered events  change this changes the time range
Filt = invoke(TT,'SetepocTimeFilterV', 'Valu',-2, 4)% Sets the Time filter so that the Epoc event occurs in the 
% of the sequence.
tranges = invoke (TT, 'GetValidTimeRangesV');% Gets the start and end of the Time ranges.
bara = invoke (TT, 'ReadWavesOnTimeRangeV', 'Wav1', 1);% reads back the baracudda epoc stream data.
SampFreq=invoke(TT,'ParseEvInfoV',0,1,9);% Gets the sampling rate for that event
time=(1: SampFreq*(tranges(2)-tranges(1))+1)/SampFreq+tranges(1);
plot(time,bara*500);
hold
pause(3)
xLFP = invoke (TT, 'ReadWavesOnTimeRangeV', 'Wav2', 1);
plot(time,xLFP)
hold
end
