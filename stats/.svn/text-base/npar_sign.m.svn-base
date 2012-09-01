function [datasign,signs,signpval,signnormalpval]=npar_sign(data,k,dataorg)
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
% Program: npar_sign.m
% Includes:
%   Sign and Sign Confidence Intervals                                                                                                             %
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Sign section BEGIN
datasign=zeros(k,2);          % decompose data into magnitudes (,1) and signs (,2)
for i=1:k;
 datasign(i,1)=abs(data(i));
 datasign(i,2)=sign(data(i));
end;

datasign=sortrows(datasign,1);
[dx,dataindx]=sort(datasign);

plus = find(datasign(:,2)>0);          % number of positive signs
signsp=sum(datasign(plus,2));
minus = find(datasign(:,2)<0);
signsm=abs(sum(datasign(minus,2)));

if signsp<signsm;                      % use least number of signs
 signs=signsp;
else;
 signs=signsm;
end;

%%% exact p-value
signpval=binocdf(signs,k,.5);          % calculate the binomial probability of one and both tails

%%% p-value via Normal approximation
mean=.5*(signsp+signsm);
var=.5^2*(signsp+signsm);
if signs<mean;  % continuity correction
 zval=(signs+.5-mean)/sqrt(var);
else
 zval=(signs-.5-mean)/sqrt(var);
end;
pval1=normcdf(zval);
pval2=1-normcdf(zval);
if pval1<pval2;
 signnormalpval=pval1;
else;
 signnormalpval=pval2;
end;

%%% Sign section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%