function [realdata,imagdata]=loadHTKtoEcog_onechan_complex(mainpath,chanNum,timeInt)
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
    cd([mainpath '\HilbReal_4to200_40band'])
    varName1=['Wav' num2str(blockNum) num2str(elecNum)];
    [realdata, sampFreq] = readhtk (sprintf('%s.htk',varName1));
    
    cd([mainpath '\HilbImag_4to200_40band'])
    [imagdata, sampFreq] = readhtk (sprintf('%s.htk',varName1));
    
    
else
    cd([mainpath '\HilbReal_4to200_40band'])    
    varName1=['Wav' num2str(blockNum) num2str(elecNum)];
    [realdata, sampFreq] = readhtk (sprintf('%s.htk',varName1),timeInt);
    
    cd([mainpath '\HilbImag_4to200_40band'])    
    [imagdata, sampFreq] = readhtk (sprintf('%s.htk',varName1),timeInt); 
    
end


