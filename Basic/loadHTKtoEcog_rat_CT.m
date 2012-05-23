function ecog=loadHTKtoEcog_rat_CT(filename,channelsTot,timeInt,inputdata)
%Load HTK to ecog matrix; specify channel count and time interval
%channelsTot= number of channels
%timeInt= time interval

if ~exist('inputdata')
    inputdata='human';
end
    
currentPath=pwd;
cd(filename)
    %blockNum=floor(channelsTot/64);
    %elecNum=rem(channelsTot,64);
if isempty(timeInt) | strmatch(inputdata,'rat')
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wave1.htk',timeInt);
    handles.sampFreq=sampFreq;
    %ecog.data=zeros(channelsTot,size(data,2),size(data,1));
    %LOAD HTK FILES
    for chanNum=1:channelsTot
            varName1=['Wave' int2str(chanNum)];

            [data, sampFreq] = readhtk (sprintf('%s.htk',varName1),timeInt);    
            %ecog.data(chanNum,:,:)=resample(data',2^11, 5^6);
            
            ecog.data(chanNum,:,:)=data';
            fprintf([int2str(chanNum) '.'])
    end

    
else
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk',timeInt);
    handles.sampFreq=sampFreq;
    ecog.data=zeros(channelsTot,size(data,2),size(data,1));
    %LOAD HTK FILES
     for chanNum=1:channelsTot
            varName1=['Wav' chanNum];
            [data, sampFreq] = readhtk (sprintf('%s.htk',varName1),timeInt);           
            ecog.data(chanNum,:,:)=data';
        
     end
end
baselineDurMs=0;
sampDur=1000/sampFreq;
ecog.sampDur=sampDur;
ecog.sampFreq=sampFreq;
cd(currentPath)