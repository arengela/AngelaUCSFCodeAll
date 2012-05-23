function data=loadHTKtoEcog_onechan(chanNum,timeInt)
%Load HTK to ecog matrix; specify channel count and time interval
%channelsTot= number of channels
%timeInt= time interval
blockNum=ceil(chanNum/64);
elecNum=rem(chanNum,64);
if elecNum==0
    elecNum=64;
end
if isempty(timeInt)
    %LOAD HTK FILES   
    
    varName1=['Wav' num2str(blockNum) num2str(elecNum)];
    [data, sampFreq] = readhtk (sprintf('%s.htk',varName1));  
    
    
else
    varName1=['Wav' num2str(blockNum) num2str(elecNum)];
    [data, sampFreq] = readhtk (sprintf('%s.htk',varName1),timeInt);
end

