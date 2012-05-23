function ecogDS=loadHTKtoEcog_DS_save(filename,channelsTot,timeInt)
%Load HTK to ecog matrix; specify channel count and time interval
%channelsTot= number of channels
%timeInt= time interval


currentPath=pwd;
cd(filename)

    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
    handles.sampFreq=sampFreq;
    ecog.sampFreq=sampFreq;
    ecog.data=zeros(channelsTot,size(data,2),size(data,1));
    %LOAD HTK FILES
    for nBlocks=1:4
        for k=1:64
            varName1=['Wav' num2str(nBlocks) num2str(k)];
            chanNum=(nBlocks-1)*64+k;
            [data, sampFreq] = readhtk (sprintf('%s.htk',varName1));    
            %ecog.data(chanNum,:,:)=resample(data',2^11, 5^6);
            
            ecog.data(chanNum,:,:)=data';
        end
    end

   
baselineDurMs=0;
sampDur=1000/ecog.sampFreq;
ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);



%Downsample to 400
fprintf('Downsampling Begin\n');
for i=1:size(ecog.data,1)
    ecogDS.data(i,:)=resample(ecog.data(i,:),2^11, 5^6);%Downsample to 400 Hz
    fprintf('%i\n',i)
end


ecogDS.sampFreq=400;
cd(currentPath)
[a,b]=fileparts(filename);
saveEcogToHTK([a filesep 'ecogDS'],ecogDS)

cd(currentPath)