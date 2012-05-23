function ecog=ecogPCANoiseRemoval(ecog)
% ecog=ecogPCANoiseremoval(ecog) remove common mode noise in each trial
%
% Purpose: Remove influences of external noise or active reference
%          This type of noise is assumend to vary from trial to trial. 
%          The approach taken here is to estimate in each trial a noise
%          signal by performing a PCA on the trials timeseries' (think of 
%          the channels as repetitions). The first eigenvector is selected 
%          is assumed to represent the common mode noise. The noise
%          fraction in each channel is estimated by projecting each signal
%          timeseries (channel) onto the noise timeseries. Finally the
%          channel wise noise fraction estimated is subtracted from the 
%          original time series, The noise fraction is only calculated from
%          the selected channels. The noise reduction is applied to all
%          channels. 
%
% INPUT:   An ecog structure
%
% OUTPUT: An ecog structure with denoised data. 
%         The PC used for denoising is stored in the field 'refChanTS' and
%         the noise fraction for each channel is strored in a new field 
%         'pCAWeights'
%
% REQUIREMENTS: The statistics toolbox

% 090107 JR wrote it
% 090107 JR PCs are calculated on the selected channels but noise
%           projection is now done on all channels

plotIt=0;
% We do this trial by trial
ecogNR=ecog;
for k=1:size(ecog.data,3)
    if 1 %if 1, noise reduction on all channels
        %zeor center each 
        channelMeans=mean(ecog.data(:,:,k),2);
        dataZeroMean=ecog.data(:,:,k)-repmat(channelMeans,1,size(ecog.data,2));
        % do PCA
        [PC,SCORE,LATENT]=princomp(dataZeroMean(ecog.selectedChannels,:)'); %requires the statistics toolbox
        n=SCORE(:,1); %That should be the noise (eigenvector with largest eigenvalue)
        if 0 %that's for plotting things
            m=mean(ecog.data(ecog.selectedChannels,:,k),1)';
            mZ=m-mean(m);
            nInMZ=mZ-mZ'*n/norm(n)^2*n;
            figure;plot(ecog.timebase, -n/10,'k',ecog.timebase,mZ,'b',ecog.timebase,nInMZ,'r',ecog.timebase,(mZ-nInMZ),'g');%,,ecog.timebase,s-mean(s),'k');
            legend('1st eigenvector/10','Mean over active channels', 'example: noise in mean','mean-noiseInMean') 
        end
        % We project the channels onto the noise, to obtain the noise fraction
        w=((dataZeroMean*n)/norm(n)^2); %A vector of weights for the noise (one for each channel
        noiseInChannel=repmat(n,1,length(w))*diag(w); %just a trick to get the noise vectors appropriately scaled for each channel
        % and then we subtract the noise fraction from the data with zero mean
        noiseReducedChannels=dataZeroMean-noiseInChannel'; % Subtract the noise fraction
        % add the mean back 
        ecog.data(:,:,k)=noiseReducedChannels+repmat(channelMeans,1,size(noiseReducedChannels,2));
        ecog.refChanTS(1,:,k)=n';
        ecog.pCAWeights(:,k)=w;
        %figure; plot(noiseReducedChannels');axis tight
    end

    if 0 % CAN GO: old code reduces noise only in slected channels 
    %zeor center each 
    channelMeans=mean(ecog.data(ecog.selectedChannels,:,k),2);
    dataZeroMean=ecog.data(ecog.selectedChannels,:,k)-repmat(channelMeans,1,size(ecog.data,2));
    % do PCA
    [PC,SCORE,LATENT]=princomp(dataZeroMean'); %requires the statistics toolbox
    n=SCORE(:,1); %That should be the noise (eigenvector with largest eigenvalue)
    if 1 %that's for plotting things
        m=mean(ecog.data(ecog.selectedChannels,:,k),1)';
        mZ=m-mean(m);
        nInMZ=mZ-mZ'*n/norm(n)^2*n;
        figure;plot(ecog.timebase, -n/10,'k',ecog.timebase,mZ,'b',ecog.timebase,nInMZ,'r',ecog.timebase,(mZ-nInMZ),'g');%,,ecog.timebase,s-mean(s),'k');
        legend('1st eigenvector/10','Mean over active channels', 'example: noise in mean','mean-noiseInMean') 
    end
    % We project the channels onto the noise, to obtain the noise fraction
    w=((dataZeroMean*n)/norm(n)^2); %A vector of weights for the noise (one for each channel
    noiseInChannel=repmat(n,1,length(w))*diag(w); %just a trick to get the noise vectors appropriately scaled for each channel
    % and then we subtract the noise fraction from the data with zero mean
    noiseReducedChannels=dataZeroMean-noiseInChannel'; % Subtract the noise fraction
    % add the mean back 
    ecog.data(ecog.selectedChannels,:,k)=noiseReducedChannels+repmat(channelMeans,1,size(noiseReducedChannels,2));
    %figure; plot(noiseReducedChannels');axis tight
    end
end
%warning('Noise reduction was done only on the selected channels!')


