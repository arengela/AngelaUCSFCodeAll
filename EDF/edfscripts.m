%%UNPACK EDF DATA
edfPath='E:\EEG\RawEDF\EC34'
structPath='E:\EEG\RawEDF\EC34'
contents=dir(edfPath)
cd(edfPath)
subj='EC34'
x=1;

for i=3:length(contents)
    %[ allChanData, samplingRates, annotations, headerInfo ] = edfExtractAllData( contents(i).name);
    [headerInfo] = edfExtractHeader(contents(i).name);
    %[annotations] = edfExtractAnnotations(contents(i).name);
    
    
    
    %EDFstruct(x).allChanData=allChanData;
    %EDFstruct(x).samplingRates=samplingRates;
    %EDFstruct(x).annotations=annotations;
    EDFstruct(x).headerInfo=headerInfo;
    eegStartTime=datestr(datenum(EDFstruct.headerInfo.startDateVec)+EDFstruct.headerInfo.factionsecondstart/(60*60*24));
    try
        copyfile(contents(i).name,[structPath filesep subj '_' num2str( datevec(eegStartTime)) '.edf'])
    catch
        
    end
    
    %save([structPath filesep 'EDFstruct_' subj '_' num2str( datevec(eegStartTime))],'EDFstruct','-v7.3');
end
%% GET EDT STRUCT TIMES
structNames=dir([structPath '/*.mat'])
for i=1:length(structNames)
    tmp=regexp(structNames(i).name,'_','split');
    tmp2=regexp(tmp{3},'.mat','split');
    edfStructTimes(i)=datenum(str2num(tmp2{1}));
end
%% GET TIME AND FILE
TDTMainPath='E:\RawTDT'
HTKMainPath='E:\PreprocessedFiles'
blockName='EC34_B25';
subj=regexp(blockName,'_','split');
TDTPath=[TDTMainPath filesep subj{1} filesep blockName];
contents=dir(TDTPath)
f=getFileNames('blocks',1:256)

blockTime=datestr(contents(4).datenum-.01)

diffTime=datenum(blockTime)-edfStructTimes;
diffTime(diffTime<0)=10000;
[~,i]=min(diffTime);
%load([structPath filesep structNames(i).name])

eegStartTime=datenum(EDFstruct.headerInfo.startDateVec)+EDFstruct.headerInfo.factionsecondstart/(60*60*24)

elapsedSec=(datenum(blockTime)-eegStartTime)*24*60*60;
startSamp=elapsedSec*400-20*60*400;
durationSamp=60*60*400;
clear Rcoef maxLag maxR

%% GET CHANS
grid=reshape(1:256,16,16);

tmp=[repmat([1 0],1,8);zeros(1,16)];
usepos=repmat(tmp,8,1);
usechan=grid(find(usepos))';

%% GET XCORR
eegdata=zeros(length(EDFstruct.allChanData),length(startSamp:startSamp+durationSamp));
for chan=1:length(EDFstruct.allChanData)
    d=EDFstruct.allChanData{chan}';
    d400=resample(d,400,512);
    dcut=d400;
    dcut=d400(startSamp:startSamp+durationSamp);
    eegdata(chan,:)=dcut;
end
%%
Rcoef=NaN(256,length(EDFstruct.allChanData) );
maxLag=NaN(256,length(EDFstruct.allChanData) );
for ecogchan=usechan(1:1:end)
    fname=f{ecogchan};
    cd([HTKMainPath filesep subj{1} filesep blockName filesep 'Downsampled400']);
    [a,b,c]=readhtk([ fname '.htk']);
    a=detrend(a);
    for chan=41:length(EDFstruct.allChanData)
        dcut=eegdata(chan,:);
        [r,lags]=xcorr(dcut,a);
        [maxR(chan,ecogchan),idx]=max(r);
        maxLag(chan,ecogchan)=lags(idx);
        try
            a2=dcut(maxLag(chan,ecogchan):maxLag(chan,ecogchan)+length(a)-1);
            tmp=corrcoef(a,a2(1:length(a)));
            Rcoef(chan,ecogchan)=tmp(1,2);
        catch
            Rcoef(chan,ecogchan)=NaN;
        end
    end
end
%% CUT OUT EEG DATA AND SAVE AS HTK
[m,idx]=max(Rcoef(:,1:2:end),[],1)
lag=mode(sum(maxLag(idx,1:2:end).*eye(size(maxLag(idx,1:2:end))),1));

for chan=1:length(EDFstruct.allChanData)
    d=EDFstruct.allChanData{chan}';
    d400=resample(d,400,512);
    dcut=d400(startSamp:startSamp+durationSamp);
    a2=dcut(lag:lag+length(a)-1);
    try
        mkdir([HTKMainPath filesep subj{1} filesep blockName filesep 'EEG']);
    end
    cd([HTKMainPath filesep subj{1} filesep blockName filesep 'EEG']);
    writehtk(['eeg' int2str(chan) '.htk'],a2,400,chan);
end
%% LOAD EEG
f=getFileNames('eeg',1:length(EDFstruct.allChanData))
eeg=loadHTKFile_Name([HTKMainPath filesep subj{1} filesep blockName filesep 'EEG'],f);

%% LOAD ECOG
f=getFileNames('blocks',usechan)
ecog=loadHTKFile_Name([HTKMainPath filesep subj{1} filesep blockName filesep 'Downsampled400'],f);
%% XCORR ALL EEG AND ECOG DATA
R=zeros(size(ecog.data,1),size(eeg.data,1));
for c1=1:size(ecog.data,1)
    for c2=1:size(eeg.data,1)
        tmp=corrcoef(ecog.data(c1,:),eeg.data(c2,:));
        R(c1,c2)=tmp(1,2);
    end
end

%%
tdtPath='E:\RawTDT\EC34\EC34_B25'
htkPath='E:\PreprocessedFiles\EC34\EC34_B25'
contents=dir([tdtPath '/*.Tbk'])
[data,fs]=readhtk([htkPath '/RawHTK/Wav11.htk']);
sampFreq=400
lengthSec=length(data)/fs
[edfData,headerInfo]=loadEDFData(datevec(addtodate(datenum(contents.date),-30,'second')),ceil(lengthSec)+30+30,'E:\EEG\RawEDF\EC34',1);  filenames=getFileNames(namingConv,channels);
filenames=getFileNames('blocks',1:256);
ecog=loadHTKFile_Name([htkPath filesep 'RawHTK'],filenames,timeInt);
baselineDurMs=0;
sampDur=1000/ecog.sampFreq;
ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
ecog=downsampleEcog(ecog,sampFreq,ecog.sampFreq);
%%
for cidx=1:64
    c=usechan(cidx);
    try
        [syncedEdfData,R,normalizedHtkData,maxlag]=syncEDFtoTDT(ecog.data(c,:),eegdata(41+cidx,:));
        holdR(c)=R;
        holdLag(c)=maxlag;
    catch
        holdR(c)=NaN;
        holdLag(c)=NaN;
    end
%     startSamp=12001;
%     holdR(c)=corr(edfData(8,startSamp:startSamp-1+size(ecog.data,2))',ecog.data(c,:)');

end
 imagesc(reshape(holdR,16,16)')
 %%
   [syncedEdfData,R,normalizedHtkData,maxlag]=syncEDFtoTDT(ecog.data(:,:),eegdata(41:41+64-1,:));
   %%
   for c=1:64
        tmp=corrcoef(zscore(syncedEdfData(c,:)),zscore(ecog.data(c,:)));
        R(c)=tmp(1,2);
   end
%%
a=detrend(ecog.data(1,:));
for chan=1:128
    dcut=zscore(eegdata(chan,:),[],2);
    [r(chan,:),lags]=xcorr(dcut,a);
end
%%
usesamp=lags(rlag(41)):lags(rlag(41))+length(a)-1;

%%
for c=1:64
    [R(c,:),lags]=xcorr(eegdata(40+c,:),ecog.data(c,:));
    [rmax(c),idx]=max(R(c,:));
    lag(c)=lags(idx);
end
%% LOW PASS DATA
sampFreq=400;
for cidx=1:size(ecog.data,1)
    %Low Gamma Bandpass
    dat1=ecog.data(cidx,:);
%     ord=7; %make this 5 for faster
%     [b,a]=butter(ord,55/(sampFreq/2),'low');
%     dat1=filtfilt(b,a,dat1);
%     [b,a]=butter(ord,4/(sampFreq/2),'high');
%     dat1=filtfilt(b,a,dat1);
    for c=41:41+63
        dat2=eegdata(c,:);
    %     ord=7; %make this 5 for faster
    %     [b,a]=butter(ord,55/(sampFreq/2),'low');
    %     dat2=filtfilt(b,a,dat2);   
    %     [r,lags]=xcorr(dat2,dat1);
    %     [b,a]=butter(ord,4/(sampFreq/2),'high');
    %     dat2=filtfilt(b,a,dat2);    
    try
        [syncedEdfData,normalizedHtkData,R(cidx,c),pval(cidx,c),maxlag(cidx,c)]=syncEDFtoTDT(dat1,dat2);
    catch
    end
        
    end
    
end
%%
highR=zeros(1,256);
grid=highR;
eegc=zeros(1,256);
for c=[1:39 41:64]
    %[m,idx]=sort(R(:,c+40),'descend');
    %highR(idx(1:4))=c;
    [m,idx]=max(Rcut(:,c));
    grid(idx)=m
    eegc(idx)=c;
end
%% ecog R
ecogR18=zeros(256);
for c=1:256
    for c2=1:256
        tmp=corrcoef(ecog18.data(c,:),ecog18.data(c2,:));
        ecogR18(c,c2)=tmp(1,2);
    end
end
%%
grid2=[1 2; 3 4]
gridB=grid2
for i=2:8
    gridB=[gridB grid2+(i-1)*4]
end

grid3=gridB
for i=2:8
    gridB=[gridB ;grid3+(i-1)*32]
end
%%



