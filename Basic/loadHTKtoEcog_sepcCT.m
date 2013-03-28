function ecog=loadHTKtoEcog_specCT(filename,channels,timeInt)
%Load HTK to ecog matrix; specify channel count and time interval
%channelsTot= number of channels
%timeInt= time interval
 
currentPath=pwd;
cd(filename)




if elecNum>0
    blockNum=blockNum-1;
end
for c=channels
    blockNum=ceil(c/64);
    k=rem(c,64);
    if k==0
        k=64;
    end       
    if isempty(timeInt)
        if c==channels(1);
            [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
            handles.sampFreq=sampFreq;
            ecog.data=zeros(channelsTot,size(data,2),size(data,1));
        end
        %LOAD HTK FILES       
        varName1=['Wav' num2str(nBlocks) num2str(k)];
        chanNum=(nBlocks-1)*64+k;
        [data, sampFreq] = readhtk (sprintf('%s.htk',varName1));
        ecog.data(chanNum,:,:)=data';
        fprintf([int2str(chanNum) '.'])
    else
        if c==channels(1);
            [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk',timeInt);
            handles.sampFreq=sampFreq;
            ecog.data=zeros(channelsTot,size(data,2),size(data,1));
        end
        %LOAD HTK FILES        
        varName1=['Wav' num2str(nBlocks) num2str(k)];
        chanNum=(nBlocks-1)*64+k;
        [data, sampFreq] = readhtk (sprintf('%s.htk',varName1),timeInt);
        ecog.data(chanNum,:,:)=data';
        fprintf([int2str(chanNum) '.'])     
    end
end
baselineDurMs=0;
sampDur=1000/sampFreq;
ecog.sampDur=sampDur;
ecog.sampFreq=sampFreq;
cd(currentPath)