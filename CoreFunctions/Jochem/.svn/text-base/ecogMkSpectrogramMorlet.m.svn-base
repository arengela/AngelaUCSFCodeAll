function [ecog]=ecogMkSpectrogramMorlet(ecog,centerFrequency,significantCycles)
% ecog=ecogMkSpectrogramMorlet(ecog,centerFrequency,significantCycles) Spectrogram of ecog time series based on Morlet wavelet transform
%
% PURPOSE:  Calculate a spectrogram using a Morlet wavelet transform. 
%           The output is amplitude scaled (i.e. the spectrogram reflects the
%           actual amplitude of the input signal).
%           The sequence analyzed should be at least twice as long as the 
%           wavelet to reduce edge artifacts. For example if you are analyzing 
%           the 4Hz band with a wavelet with 6 significant cycles your time 
%           series should be at least 3 seconds long (2*1.5S wavelet
%           length)   
%           Fewer significant cycles in the wavelet increases
%           the correlation between frequency bands but increases temporal
%           resolution.
%           Code for testing is in the function.
%
% INPUT:
% ecog:          An ecog structure with field data. Data can be a 3D array 
%                with multiple trials. However, available memory might be a 
%                problem
% centerFrequency: A vector with the center frequencies of the morlet
%                They are defined in HZ. 
%                The highest frequency is half the sampling frequency (Nyquist).
%                The lowest frequncy is above 0. 
%                Default: [2 6 10 20 30 40 50 70 80 90 100 120 140 160 180
%                200]
% significantCycles: The number of significant cycles of the sine under the
%                gaussian window. 
%                Default: 6
%
% OUTPUT:
% ecog:          An ecog structure with new substructure 'spectrogram'
%                eocg.spectrogram.creator='morlet'                
%                ecog.spectrogram.spectrogram the spectrograms with frequency 
%                                 along the 4th dimension
%                ecog.spectrogram.params.Fs: 1000/ecog.sampDur the sampling frequency
%                ecog.spectrogram.centerFrequency: the central frequencies of the bands
%                ecog.spectrogram.params.fpass: the frequency bands
%                ecog.spectrogram.centerTime: the timebase of the spectrogram

% 090414 JR wrote it

%DEBUG and check frequency response
% % from 16 cycles/segment on edge effects do not play a role anymore
% % linear: freqBands=[0 4;4 8;8 16;16 30;30 50;50 70; 70 90; 90 110; 110 130; 130 150; 150 170; 170 190; 190 210];
% centerFrequency=[2 4 8 16 32 64 128 256] %log linear  
% significantCycles=4*ones(1,length(centerFrequency));
% segmentDur=3000;
% ecog.sampDur=1; %1 kHZ sampling frequency
% ecog.timebase=0:segmentDur-1; % One second of data 
% ecog.spectrogram.centerFrequency=centerFrequency;
% % make a signal with a flat amplitude spectrum and amplitude 1 
% ecog.data=zeros(64,segmentDur,3);
% ecog.data(:,segmentDur/2,1)=1;
% ecog.data(1:length(centerFrequency),:,2)=sin(repmat([0:2*pi*segmentDur/1000/(segmentDur-1):2*pi*segmentDur/1000]',1,length(centerFrequency))*diag(centerFrequency))';
% ecog.data(:,segmentDur/2-32:segmentDur/2+31,3)=diag(1:64);
% % figure; plot(abs(fft(ecog.data)));
% %[ecog]=ecogMkSpectrogramMorlet(ecog,frequencyBandsHz);
% figure;subplot(3,1,1);imagesc(ecog.data(:,:,1)); colorbar
% subplot(3,1,2);imagesc(ecog.data(:,:,2)); colorbar
% subplot(3,1,3);imagesc(ecog.data(:,:,3)); colorbar
% 
if nargin<2
    centerFrequency=[2 6 10 20 30 40 50 70 80 90 100 120 140 160 180 200]; 
end
if nargin<3
    significantCycles=6*ones(1,length(centerFrequency)); 
end

%Space for the result
eocg.spectrogram.creator='morlet';
ecog.spectrogram.spectrogram=zeros([size(ecog.data),length(centerFrequency)]);
ecog.spectrogram.params.Fs=1000/ecog.sampDur;
ecog.spectrogram.centerFrequency=centerFrequency;
ecog.spectrogram.centerTime=ecog.timebase;
ecog.spectrogram.significantCycles=significantCycles;

for k=1:length(centerFrequency)
    [ecog.spectrogram.theWavelet{k},scalingFac(k)]=ecogMkUnscaledMorlet(centerFrequency(k),ecog.spectrogram.params.Fs,significantCycles(k),'a');
    %We may have to pad the fft of the wavelet
    if length(ecog.spectrogram.theWavelet{k})<=size(ecog.data,2)
        theWaveletFft{k}=fft(ecog.spectrogram.theWavelet{k},size(ecog.data,2));
    else
        theWaveletFft{k}=fft(ecog.spectrogram.theWavelet{k});
    end
end

for k=1:size(ecog.data,3)
    for f=1:length(ecog.spectrogram.centerFrequency)
        if length(ecog.spectrogram.theWavelet{f})<=size(ecog.data,2) %We already padded the wavelet
            signalFft=fft(ecog.data(:,:,k)');
            wavFft=repmat(theWaveletFft{f}',1,size(signalFft,2));
            tmp=signalFft.*abs(wavFft); %abs produces the correct time lag
            ecog.spectrogram.spectrogram(:,:,k,f)=abs(ifft(real(tmp)*scalingFac(f)/ecog.spectrogram.params.Fs+i*imag(tmp)*scalingFac(f)/ecog.spectrogram.params.Fs))';
        else %We have to pad the time series since the wavelet is longer
            signalFft=fft(ecog.data(:,:,k)',length(ecog.spectrogram.theWavelet{f}));
            wavFft=repmat(theWaveletFft{f}',1,size(signalFft,2));
            tmp=signalFft.*abs(wavFft);
            tmp=ifft(real(tmp)*scalingFac(f)/ecog.spectrogram.params.Fs+i*imag(tmp)*scalingFac(f)/ecog.spectrogram.params.Fs)';
            %remove the padding
            ecog.spectrogram.spectrogram(:,:,k,f)=abs(tmp(:,1:size(ecog.data,2)));
        end
    end
end


return

