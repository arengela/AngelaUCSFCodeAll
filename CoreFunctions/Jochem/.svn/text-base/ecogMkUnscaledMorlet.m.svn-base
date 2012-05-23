function [theWavelet,scalingFac]=ecogMkUnscaledMorlet(centerFreq,sampFreq,nCycles,scalingType)
%  [theWavelet,scalingFac]=anoMkUnscaledMorlet(centerFreq,sampFreq,nCycles,scalingType)
% An unscaled Morlet Wavelet (see C. Herrmann tutorial)
% INPUT:
% centerFreq:               The wavelets center frequency (Hz)
% sampFrequency:       The sampling frequency (Hz)
% nCycles:                    The number of significant cycles in the wavelet.
%                                    If the empty matrix is passed 6 is assumed
% scalingType:              When 'a' is passed returns a scale factor that
%                                   yields onstant amplitude scaling over different frequencies
%                                    When 'e' ist passed constant energy caling will be achieved.
%                                    (default)
%OUTPUT:
% theWavelet:               The complex morlet wavelet
% scalingFac:                The corresponding scaling factor or the coefficients
%                                   See input argument scalingType for options
%                                   The scale factor has to be passed to the convolution routine.
%
% 102703 JR wrote it

if nargin < 2
    error('Not enough input arguments')
end

if isempty(nCycles)
    nCycles=6;              %number of significant cycles
end
if isempty(scalingType) 
    scalingType='e';
end
%sampFreq=100;      %the sampling frequency (samples/unit)
dt=1/sampFreq;      %duration of a sampling interval
%centerFreq=.5;               %center frequency (Hz)
lambda=1/centerFreq;
sigmaT=nCycles/(6*centerFreq);   %The wavelets sigma in the time domain
t=-nCycles/centerFreq+lambda/4:dt:nCycles/centerFreq+lambda/4;          %A timebase
theWavelet=exp(i*2*pi*centerFreq*t+(-t.^2/(sigmaT.^2*2)));

switch (scalingType)
case 'e'
    scalingFac=sqrt(sigmaT*sqrt(pi)); %Scaling that makes energy spectrum comparable between frequencies (makes power spectra comparable)
case 'a'
    scalingFac=sqrt(2/pi)/sigmaT;  %Scaling that makes amplitude spectrum comparable between frequencies. Same as the Gabor Scaling factor,
otherwise
    error('We should never get here')
end
%aPsyEnergy=sqrt(sigmaT*sqrt(pi)); %Scaling that makes energy spectrum comparable between frequencies (makes power spectra comparable)
%aPsyAmplitude=sqrt(2/pi)/sigmaT;  %Scaling that makes amplitude spectrum comparable between frequencies. Same as the Gabor Scaling factor,

return;

        
        
    
