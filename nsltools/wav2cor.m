function [aud,cor] = wav2cor (w,fs,par,rv,sv)
%
% par: [10 10 -2 0 0 0 1]
if ~exist('fs','var') || isempty(fs)
    fs = 16000;
end
if ~exist('par','var') || isempty(par),
    par = [10 10 -2 0 0 0 1];
end
if ~exist('rv','var') || isempty(rv)
    rv = [1 2 4 8 16 32];
    sv = [0.25 0.5 1 2 4 8];
end
aud = wav2aud(w,par(1:4));
aud = aud.^.25;
% aud = aud-min2(aud);
% aud = log(1+aud);
% aud = log(aud);
% aud(aud<-max(aud(:)))=-max(aud(:));
cor = aud2cor(aud,par,rv,sv,'tmp');