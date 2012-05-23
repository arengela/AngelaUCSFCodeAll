function [freqband,cenfreq] = make_ecog_freqbands(nbands)
% function [freqband,cenfreq] = make_ecog_freqbands(nbands)
 
freqs_low(1)=0;
freqs_high(1)=0.9;
for iband=2:nbands
    freqs_low(iband)=freqs_high(iband-1)*0.85;
    freqs_high(iband)=freqs_low(iband)+1.1*(freqs_high(iband-1)-freqs_low(iband-1));
    freqband(iband,:) = [freqs_low(iband) freqs_high(iband)];
end
cenfreq = mean(freqband')';