function ecog=loadHTKtoEcog(filename)

currentPath=pwd;
cd(filename)
[data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
handles.sampFreq=sampFreq;
ecog.data=zeros(256,size(data,2),size(data,1));
%LOAD HTK FILES
for nBlocks=1:4
    for k=1:64
        varName1=['Wav' num2str(nBlocks) num2str(k)];
        chanNum=(nBlocks-1)*64+k;
        [data, sampFreq, tmp, chanNum] = readhtk (sprintf('%s.htk',varName1));           
        ecog.data(chanNum,:,:)=data';
    end
end

baselineDurMs=0;
sampDur=1000/sampFreq;
ecog.sampDur=sampDur;
ecog.sampFreq=sampFreq;
try
    cd ..
    cd Artifacts
    load 'badTimeSegments.mat'
    fid = fopen('badChannels.txt');
    tmp = fscanf(fid, '%d');
    badChannels=tmp';
    fclose(fid);
   	ecog.badChannels=badChannels;
    ecog.badTimeSegments=badTimeSegments;
end

cd(currentPath)