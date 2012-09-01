function [pitind,meansmall,datasmallsum,u1,pval1,datalargesum,u2,pval2,pitmanindnormalpval]=npar_pitmanind(data,data2,k,k2,exact)
% npar_pitmanind called by npar_main performs nonparametric pitman test for independent samples
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
% Program: npar_pitmanind.m
% Includes:
%   Pitman for Independent samples
% Called by:
%   npar_main.m
%
%
%  IN PROGRESS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if k<=k2;
 datasmall=data;
 datalarge=data2;
else;
 datasmall=data2;
 datalarge=data;
end;

dataall=[datasmall;datalarge];      % all the data together
datasmallsum=sum(datasmall);        % Sm sum of the data from the smaller data
datalargesum=sum(datalarge);        % Sn sum of the data from the larger data

pitind=sum(nchoosek(dataall,k),2);     % pitind includes all sums of combinations of the data chosen k at a time
n=length(pitind);

u1=length(find(pitind <= datasmallsum));   % the number of sums at least as extreme as datasmall
u2=length(find(pitind >= datasmallsum));
pval1=u1/n;                            % pvalues are the proportion of these
pval2=u2/n;

%%% p-value via Normal approximation
meansmall=mean(pitind);                 % This is the mean of data chosen k at a time
varsmall=var(pitind);                   % This is the variance of data chosen k at a time
if datasmallsum<meansmall;  % continuity correction
 zval=(datasmallsum+.5-meansmall)/sqrt(varsmall);
else
 zval=(datasmallsum-.5-meansmall)/sqrt(varsmall);
end;
normalpval1=normcdf(zval);
normalpval2=1-normcdf(zval);
if normalpval1<normalpval2;
 pitmanindnormalpval=normalpval1;
else;
 pitmanindnormalpval=normalpval2;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
