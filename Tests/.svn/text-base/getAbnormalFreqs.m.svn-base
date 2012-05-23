function [bad_f,w]=getAbnormalFreqs(pathName,w)
channelsTot=256;
timeInt=[];
ecog=loadHTKtoEcog_CT(sprintf('%s/%s',pathName,'RawHTK'),channelsTot,timeInt);
baselineDurMs=0;
sampDur=1000/ecog.sampFreq;
ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
ecog=downsampleEcog(ecog,400);

[a,b,c]=fileparts(pathName);
blockName=b;
cd(pathName)
fprintf('File opened: %s\n',pathName)
fprintf('Block: %s',blockName)

ecog.selectedChannels=1:size(ecog.data,1);
ecog.sampDur=1000/400;
ecog.sampFreq=400;
ecog.timebase=[0:(size(ecog.data,2)-1)]*sampDur;
badChannels=[];
badTimeSegments=[];
ecog.badChannels=[];
ecog.badTimeSegments=[];
%%
%LOAD ARTIFACT FILES
cd(sprintf('%s/Artifacts',pathName))
try
    load 'badTimeSegments.mat'
    fid = fopen('badChannels.txt');
    tmp = fscanf(fid, '%d');
    badChannels=tmp';
    fclose(fid);
    cd(pathName)
catch
    'No Artifacts'
    bad_f=[];
    return
end

%%
%Set default Values
sampFreq=400;
freqRange=[70 150];

%detect bad f
Pall=[];
b=1
for i=1:256
    
    [Pall(b,:),f]=periodogram(ecog.data(i,:),[],[],400);
    b=b+1
end
logPeriodogram=20*log10(Pall);

m=mean(logPeriodogram(setdiff(1:256,badChannels),:),1);
smean10000=smooth(m,10000);
for i=1:256
    s1000_Pall(i,:)=smooth(logPeriodogram(i,:),100);
end
diff_sm=s1000_Pall-repmat(smean10000',[256,1]);
diff_sm_norm=detrend(diff_sm')';
diff_sm=diff_sm_norm;

abs_diff=abs(diff_sm);
for i=1:256
    x=find(abs_diff(i,:)>12);
    m=unique(round(f(x)));
    bad_f{i}=m(find(m>0));
end
w=w+1;

