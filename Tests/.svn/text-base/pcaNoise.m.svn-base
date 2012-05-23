z=zscore(handles.ecogDS.data,0,2);
%OR
z=handles.ecogDS.data-repmat(mean(handles.ecogDS.data,2),[1,size(handles.ecogDS.data,2)]);

[PC,S,L]=princomp(z');

figure
for i=1:16
    subplot(4,4,i)
    imagesc(reshape(PC(:,i),16,16)')
end


figure
for i=1:16
    subplot(4,4,i)
    specgram(S(:,i),[],400)


end
%%
[a,b,c]=specgram(z(1,:),[],400);
figure
surf(c,b,10*log10(abs(a)),'EdgeColor','none');   
%%

z2=zscore( handles.ecogNormalized.data,0,2);
[PC2,S2,L2]=princomp(z2');
figure
for i=1:16
    subplot(4,4,i)
    imagesc(reshape(PC2(:,i),16,16)')
end


figure
for i=1:16
    subplot(4,4,i)
    specgram(S2(:,i),[],400)


end
%%
%PCA Convolution

v=cov(zscore(handles.ecogDS.data,0,2)');
[PC,S,L]=princomp(v');

figure
for i=1:16
    subplot(4,4,i)
    imagesc(reshape(PC(:,i),16,16)')
end

figure
for i=1:16
    subplot(4,4,i)
    specgram(S(:,i),[],400)


end
%%
%PCA in 16 Channel blocks
a=figure
b=figure
c=1
i=1
while c<257
    [PC,S,L]=princomp(z(c:c+15,:)');
    x(i,:)=PC(:,1)';
    x2(i,:)=PC(:,2)';
    %imagesc(reshape(PC(:,i),16,16)')
    figure(a)
    subplot(4,4,i)
    specgram(S(:,1),[],400)
    
    figure(b)
    subplot(4,4,i)
    specgram(S(:,2),[],400)

    c=c+16
    i=i+1
end
figure
imagesc(x)
figure
imagesc(x2)
%%
%plot spectrum of CAR
c=1
figure
for i=1:16
    subplot(4,4,i)
    specgram(CAR(c,:),[],400)
    c=c+16;

end

for i=1:16
    subplot(4,4,i)
    specgram(SCORE(:,i),[],400)


end
%%
%Subtract mean, do PCA, 16 channel blocks
ignoreChans=[handles.badChannels handles.suspiciousChannels];
usechans= setdiff([1:size(handles.ecogDS.data,1)],ignoreChans);
c=1;
CAR=[];
i=0;
%calculate common average reference by 16-channel blocks
while c<=size(handles.ecogDS.data,1)
    channelMeans=mean(handles.ecogDS.data(c:c+15,:),2);
    dataZeroMean=handles.ecogDS.data(c:c+15,:)-repmat(channelMeans,1,size(handles.ecogDS.data,2));
    % do PCA
    [PC,SCORE,LATENT]=princomp(dataZeroMean(intersect((c:c+15),usechans)-(c-1),:)'); %requires the statistics toolbox
    n=SCORE(:,1); %That should be the noise (eigenvector with largest eigenvalue)
        % We project the channels onto the noise, to obtain the noise fraction
    w=((dataZeroMean*n)/norm(n)^2); %A vector of weights for the noise (one for each channel
    noiseInChannel=repmat(n,1,length(w))*diag(w); %just a trick to get the noise vectors appropriately scaled for each channel
    % and then we subtract the noise fraction from the data with zero mean
    noiseReducedChannels=dataZeroMean-noiseInChannel'; % Subtract the noise fraction
    % add the mean back 
    ecog.data(c:c+15,:)=noiseReducedChannels+repmat(channelMeans,1,size(noiseReducedChannels,2));
    %figure; plot(noiseReducedChannels');axis tight
    
    c=c+16
end
 
%%