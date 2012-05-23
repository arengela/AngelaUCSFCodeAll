function [ecog]=ecogMkSpectrogramHilbert(ecog,frequencyBandsHz)
%[ecog]=ecogMkSpectrogramHilbert(ecog,frequencyBandsHz) Spectrogram of ecog time series based on hilbert transform
%
% PURPOSE:  Spectrogram of ecog time series. 
%           Scaling of the spectrograms is a bit complicated here.
%           The approach here is to set the norm of the window function 
%           in fourier space to 1 in each band. Thus the norm of the
%           spectrogram of an impulse response in time is also 1.
%           Use the Morlet spectrogram if between bands comparisons are
%           important or z-score your data. 
%
% INPUT:
% ecog:          An ecog structure with field data. Data can be a 3D array 
%                with multiple trials. However, available memory might be a 
%                problem
% frequencyBandsHz: A matrix containing the pairs of lower and upper frequency  
%                bands of the spectrogram in column 1 and two respectively. 
%                They are defined in HZ. 
%                The highest frequency is half the sampling frequency (Nyquist).
%                The lowest frequncy is 0
%
% OUTPUT:
% ecog:          An ecog structure with new substructure 'spectrogram'
%                eocg.spectrogram.creator='hilbert'                
%                ecog.spectrogram.spectrogram the spectrograms with frequency 
%                                 along the 4th dimension
%                ecog.spectrogram.params.Fs: 1000/ecog.sampDur the sampling frequency
%                ecog.spectrogram.centerFrequency: the central frequencies of the bands
%                ecog.spectrogram.params.fpass: the frequency bands
%                ecog.spectrogram.centerTime: the timebase of the spectrogram

% 090411 JR modified Lavi's original implementation to conform with the ecog standards 

%DEBUG
% linear: freqBands=[0 4;4 8;8 16;16 30;30 50;50 70; 70 90; 90 110; 110 130; 130 150; 150 170; 170 190; 190 210];
% frequencyBandsHz=[(2.^(1:7))' (2.^(2:8))' ];frequencyBandsHz(1,1)=0; %log linear  
% ecog.sampDur=1; %1 kHZ sampling frequency
% ecog.timebase=0:999; % One second of data 
% ecog.spectrogram.centerFrequency=mean(frequencyBandsHz,2);
% % make a signal with a flat amplitude spectrum and amplitude 1 
% ecog.data=zeros(64,1000,3);
% ecog.data(:,500,1)=1;
% ecog.data(:,468:531,2)=diag(ones(1,64));
% ecog.data(:,468:531,3)=diag(1:64);
% figure; plot(abs(fft(ecog.data)));
% [ecog]=ecogMkSpectrogramHilbert(ecog,frequencyBandsHz)
% figure;imagesc(ecog.spectrogram.spectrogram); colorbar


%Space for the result
eocg.spectrogram.creator='hilbert';
ecog.spectrogram.spectrogram=zeros([size(ecog.data),size(frequencyBandsHz,1)]);
ecog.spectrogram.params.Fs=1000/ecog.sampDur;
ecog.spectrogram.centerFrequency=mean(frequencyBandsHz,2);
ecog.spectrogram.params.fpass=frequencyBandsHz;
ecog.spectrogram.centerTime=ecog.timebase;

for k=1:size(ecog.data,3)
        signalFft=fft(ecog.data(:,:,k)');
        for f=1:size(ecog.spectrogram.params.fpass,1)
            ecog.spectrogram.spectrogram(:,:,k,f)=abs(myhilbert(signalFft,ecog.spectrogram.params.Fs,ecog.spectrogram.params.fpass(f,1),ecog.spectrogram.params.fpass(f,2),0))';
        end
end


return

%%-------------------------------------------------------------------------
function [filt_signal]=myhilbert(input, sampling_rate, lower_bound, upper_bound, tm_OR_fr)
%  [filt_signal]=myhilbert(input, sampling_rate, lower_bound, upper_bound, tm_OR_fr)
%     input         - input signal to be filtered (time or frequency domain)
%     sampling_rate - signal's sampling rate
%     lower_bound     - lower frequency bound for bandpass filtering
%     upper_bound   - upper frequency bound for bandpass filtering
%     tm_OR_fr      - 1 if the input signal is in the time domain, 0 if it
%                     is in the frequency domain
%
%  The function returns the filtered signal (low->high) in the time domain
%
    if (nargin<5)
        tm_OR_fr=1;
    end
    if (nargin<4)
        error('Please enter at least 4 arguments');
    end

    max_freq=sampling_rate/2;
    df=2*max_freq/length(input);
    centre_freq=(upper_bound+lower_bound)/2;
    filter_width=upper_bound-lower_bound;
    x=0:df:max_freq;
    gauss=exp(-(x-centre_freq).^2);
    %gauss=(sign(gauss-0.5)+1)/2;
    
    cnt_gauss = round(centre_freq/df);
	flat_padd = round(filter_width/df);  % flat padding at the max value of the gaussian
	padd_left = floor(flat_padd/2);
	padd_right = ceil(flat_padd/2);
    
	our_wind = [gauss((padd_left+1):cnt_gauss) ones(1,flat_padd) gauss((cnt_gauss+1):(end-padd_right))];
    our_wind=[our_wind zeros(1,length(input)-length(our_wind))];
    %normalize the window 
    our_wind=our_wind/norm(our_wind);
    
    if (tm_OR_fr==1)
        input=fft(input,[],2);
	end        
    our_wind = repmat(our_wind',1,size(input,2));
    filt_signal=ifft(input.*our_wind);
return



        
        
    
