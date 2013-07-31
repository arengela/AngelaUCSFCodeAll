function ecog=loadHTKtoEcog_CT_Downsample(filename,channelsTot,timeInt)
%Load HTK to ecog matrix; specify channel count and time interval
%channelsTot= number of channels
%timeInt= time interval

currentPath=pwd;
cd(filename)
blockNum=ceil(channelsTot/64);
elecNum=rem(channelsTot,64);

if elecNum>0
    blockNum=blockNum-1;
end
if isempty(timeInt)
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
    m=400/400;
    n=round(sampFreq/3.0518e+03);
    data=resample(data,m*2^11, n*5^6);
    handles.sampFreq=sampFreq;
    ecog.data=zeros(channelsTot,size(data,2),size(data,1));
 
    %LOAD HTK FILES
    for nBlocks=1:blockNum
        for k=1:64
            varName1=['Wav' num2str(nBlocks) num2str(k)];
            chanNum=(nBlocks-1)*64+k;
            [data, sampFreq] = readhtk (sprintf('%s.htk',varName1));               
            data=data'*1e6;
            ecog.data(chanNum,:)=resample(data,m*2^11, n*5^6);            
            fprintf([int2str(chanNum) '.'])
        end
    end

    if elecNum>0
        for i=1:elecNum
            varName1=['Wav' num2str(blockNum+1) num2str(i)];
            [data, sampFreq,tmp,chanNum] = readhtk (sprintf('%s.htk',varName1));
            data=data'*1e6;
            ecog.data(chanNum,:)=resample(data,m*2^11, n*5^6);            
            fprintf([int2str(chanNum) '.'])
        end   

    end

else
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk',timeInt);
       m=400/400;
    n=round(sampFreq/3.0518e+03);
    handles.sampFreq=sampFreq;
    ecog.data=zeros(channelsTot,size(data,2),size(data,1));
 
    %LOAD HTK FILES
    for nBlocks=1:blockNum
        for k=1:64
            varName1=['Wav' num2str(nBlocks) num2str(k)];
            chanNum=(nBlocks-1)*64+k;
            [data, sampFreq] = readhtk (sprintf('%s.htk',varName1),timeInt);           
            data=data'*1e6;          
            ecog.data(chanNum,:)=resample(data,m*2^11, n*5^6);     
            fprintf([int2str(chanNum) '.'])

        end
    end

    if elecNum>0
        for i=1:elecNum
            varName1=['Wav' num2str(blockNum+1) num2str(i)];
            [data, sampFreq,tmp,chanNum] = readhtk (sprintf('%s.htk',varName1),timeInt);           
            data=data'*1e6;
            ecog.data(chanNum,:)=resample(data,m*2^11, n*5^6);      
           fprintf([int2str(chanNum) '.'])
        end   

    end
end
baselineDurMs=0;
sampDur=1000/sampFreq;
ecog.sampDur=sampDur;
ecog.sampFreq=sampFreq;
cd(currentPath)