%Another test
%Test

%%
%LOAD FILES
load 'badTimeSegments.mat'
handles.badTimeSegments=badTimeSegments;

fid = fopen('badChannels.txt');
tmp = fscanf(fid, '%d');
handles.badChannels=tmp';
fclose(fid);
%guidata(hObject, handles);
%set(handles.inputBadChannels,'String',int2str(handles.badChannels));


%%

%SUBTRACT CAR
usechans= setdiff(1:256,handles.badChannels);
e=seg2(:,:,:,1);
r=seg2(:,:,:,141);

ecog.sampDur=1000/400;
ecog.sampFreq=400;

%%
ecog.data=e;
filtered_event=ecogFilterTemporal(ecog,[1 200],3);
filtered_event.sampFreq=400;

ecog.data=r;
filtered_rest=ecogFilterTemporal(ecog,[1 200],3);
filtered_rest.sampFreq=400;
%%

c=1;
CAR=[]
ecogCARSubtracted.data=[];
while c<=size(filtered.data,1)
    currentChans=intersect((c:c+15),usechans);
    dataZeroMean=filtered.data(intersect((c:c+15),usechans),:);
    CAR=mean(dataZeroMean,1);
    
    n=CAR';
    w=(dataZeroMean*n)/norm(n)^2;
    noiseInChannel=repmat(n,1,length(w))*diag(w); %just a trick to get the noise vectors appropriately scaled for each channel
    % and then we subtract the noise fraction from the data with zero mean
    noiseReducedChannels=dataZeroMean-noiseInChannel'; % Subtract the noise fraction
    ecogCARSubtracted.data(currentChans,:)=noiseReducedChannels;
    c=c+16;
end
%handles.ecogNormalized.timebase=handles.ecogDS.timebase;
ecogCARSubtracted.sampDur=handles.ecogDS.sampDur;
ecogCARSubtracted.sampFreq=handles.ecogDS.sampFreq;
%handles.ecogNormalized.baselineDur=handles.ecogDS.baselineDur;
%handles.ecogNormalized.nSamp=handles.ecogDS.nSamp;
%ecogNormalized.nBaselineSamp=ecog.nBaselineSamp;
ecogCARSubtracted.selectedChannels=handles.ecogDS.selectedChannels;