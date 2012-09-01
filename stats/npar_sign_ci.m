function [datasign,signs,signpval,signnormalpval]=npar_sign_ci(data,k,dataorg)
% npar_sign called by npar_main performs nonparametric sign test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Nonparametric Statistical Tests in Matlab
%
% Author:
%   Erik B. Erhardt                                             erike@wpi.edu
%   Statistics Graduate Student and Teaching Assistant
%   Dept. of Mathematical Sciences                             (508) 831-5546
%   Worcester Polytechnic Institute                                    SH 204
%   100 Institute Rd.
%   Worcester, MA  01609-2280
%
% Date: 2/6/2003 1:30PM
%
% Program: npar_sign_ci.m
% Includes:
%   Sign Confidence Intervals                                                                                                             %
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Sign Confidence Intervals section BEGIN
%%% Confidence Interval for the median
signci=sort(dataorg);
signmedian=median(dataorg);
for i=1:k/2;
  signcil=signci(i);
  signciu=signci(k-i+1);
  signcipval=1-2*binocdf(i-1,k,.5);
  fprintf('%6.5f Confidence Limit on the Median %6.5f (index %3i): (%6.5f,%6.5f) \n',signcipval,signmedian,i,signcil,signciu);
end;
%%% Sign Confidence Intervals section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%