function [YY,tt,ff]=stft_hann(y,fs,wl,sp)
%This runs the short-time Fourier transform (STFT) quickly for rather short
%sequences where memory is not a big issue.
%It uses Hann (cosine) window with 50% overlap (perfect-reconstruction)
%INPUTS:
%y : [Nx1] signal
%fs: sampling frequency of y in Hz
%wl: [int] STFT window length in samps
%sp: [N x 1] 1/0 of keep/reject (only run where sp==1, else output 0)
%OUTPUTS:
%YY: [wl/2 x nwins] STFT (complex-valued power) (usually take abs())
%tt: [1 x nwins] time for columns of YY in secs (1st sample of y is t=0)
%ff: [wl/2 x 1] frequency for rows of YY

N=length(y); 
if size(y,2)==N, 
    y=y'; 
end

if nargin<4 || isempty(sp), sp=ones([N 1],'uint8'); end
if nargin<3 || isempty(wl), wl=2^nextpow2(fix(.015*fs)); end

win=.5+.5*cos(linspace(-pi,pi,wl+1)); %Hann win
win=win(1:wl)'; %truncated back to even length
%figure; plot(1:wl,win); grid on; return;

win=.5+.5*cos(linspace(-pi,pi,wl+1));
win=win(1:wl)'; %truncated back to even length
wss=1:wl/2:N-wl+1; %window start samples
if nargout>1, tt=(wss+wl/2-1)/fs; end
%figure; plot(linspace(0,1,wl),win); grid on; return;
%figure; plot((0:wl-1)/fs,win); grid on; return;

nwins=length(wss); %number of windows
sp=sp(wss+wl/2); %figure; plot(tt,sp); return;
YY=zeros([wl/2+1 nwins],'double');
usewins=intersect(1:nwins,find(sp==1));
for nw=usewins
    Y=fft(y(wss(nw):wss(nw)+wl-1).*win,wl);
    YY(:,nw)=Y(1:wl/2+1);
end
if nargout>2, ff=(0:wl/2)*(fs/wl); end
