function hfilt_chansdat = hfilt_chans(chansdat,fs,freqbands)
% function hfilt_chansdat = hfilt_chans(chansdat,fs,freqbands)
% is based on ecog_hilbert2.m
% each row of chansdat is the time waveform of a different grid channel
 
yes_verbose = 0;
 
[nchans,nsamps] = size(chansdat);
max_freq=fs/2;
nfft = 2^ceil(log2(nsamps));
df=max_freq/(nfft/2);
[nbands,duh] = size(freqbands);
hfilt_chansdat = zeros(nchans,nbands,nsamps);
 
if yes_verbose, fprintf('fft(chansdat)...'); end
fft_chansdat=fft(chansdat,nfft,2);
if yes_verbose, fprintf('done\n'); end
for iband = 1:nbands
  lower_bound = freqbands(iband,1);
  upper_bound = freqbands(iband,2);
  centre_freq=(upper_bound+lower_bound)/2;
  filter_width=upper_bound-lower_bound;
  x=0:df:max_freq;
  gauss=exp(-(x-centre_freq).^2);
  cnt_gauss = round(centre_freq/df);
  flat_padd = round(filter_width/df);  % flat padding at the max value of the gaussian
  padd_left = floor(flat_padd/2);
  padd_right = ceil(flat_padd/2);
  our_wind = [gauss((padd_left+1):cnt_gauss) ones(1,flat_padd) gauss((cnt_gauss+1):(end-padd_right))];
  our_wind=[our_wind zeros(1,nfft-length(our_wind))];
  our_wind = repmat(our_wind,nchans,1);
  ifft_hfilt_chansdat = ifft(fft_chansdat.*our_wind,nfft,2);
  hfilt_chansdat(:,iband,:) = ifft_hfilt_chansdat(:,1:nsamps);
  if yes_verbose, fprintf('.'); if ~rem(iband,50), fprintf('%d\n',iband); end; end
end
if yes_verbose, fprintf('%d\n',iband); end