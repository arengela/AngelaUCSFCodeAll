function ecog=loadHTKtoEcog_CT(filename,channelsTot,timeInt)
%Load HTK to ecog matrix; specify channel count and time interval
%channelsTot= number of channels
%timeInt= time interval

currentPath=pwd;
cd(filename)
blockNum=floor(channelsTot/64);
elecNum=rem(channelsTot,64);
if isempty(timeInt)
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
    handles.sampFreq=sampFreq;
    ecog.data=zeros(channelsTot,size(data,2),size(data,1));
    %LOAD HTK FILES
    for nBlocks=1:blockNum
        for k=1:64
            varName1=['Wav' num2str(nBlocks) num2str(k)];
            chanNum=(nBlocks-1)*64+k;
            [data, sampFreq] = readhtk (sprintf('%s.htk',varName1));               
            ecog.data(chanNum,:,:)=data';
            fprintf([int2str(chanNum) '.'])

        end
    end

    if elecNum>0
        for i=1:elecNum
            varName1=['Wav' num2str(blockNum+1) num2str(i)];
            [data, sampFreq,tmp,chanNum] = readhtk (sprintf('%s.htk',varName1));           
            ecog.data(chanNum,:,:)=data';        
            fprintf([int2str(chanNum) '.'])
        end   

    end

else
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk',timeInt);
    handles.sampFreq=sampFreq;
    ecog.data=zeros(channelsTot,size(data,2),size(data,1));
    %LOAD HTK FILES
    for nBlocks=1:blockNum
        for k=1:64
            varName1=['Wav' num2str(nBlocks) num2str(k)];
            chanNum=(nBlocks-1)*64+k;
            [data, sampFreq] = readhtk (sprintf('%s.htk',varName1),timeInt);           
            ecog.data(chanNum,:,:)=data';
            fprintf([int2str(chanNum) '.'])

        end
    end

    if elecNum>0
        for i=1:elecNum
            varName1=['Wav' num2str(blockNum+1) num2str(i)];
            [data, sampFreq,tmp,chanNum] = readhtk (sprintf('%s.htk',varName1),timeInt);           
            ecog.data(chanNum,:,:)=data';  
           fprintf([int2str(chanNum) '.'])
        end   

    end
end
baselineDurMs=0;
sampDur=1000/sampFreq;
ecog.sampDur=sampDur;
ecog.sampFreq=sampFreq;
cd(currentPath)