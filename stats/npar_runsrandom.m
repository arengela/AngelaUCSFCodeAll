function [runsrandompval,runsrandompval1,runsrandompval2,runsrandomnormalpval,numruns]=npar_runsrandom(data,k);
% npar_runsrandom called by npar_main performs nonparametric runs test for randomness
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
% Program: npar_runsrandom.m
% Includes:
%   Runs test for Randomness
% Called by:
%   npar_main.m
%
% Maintenance:
%
%%% Need to learn how to perform exact probability
%   using normal approximation (Sprent 1998 (Data Driven Statistical Methods) ex 6.16 for exact calculation)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Runs test for Randomness section END

% Will use +1 and -1 (the sign) of the data after the difference from the median
% has been taken as the two types of data.

datasign=zeros(k,2);
for i=1:k;
 datasign(i,1)=abs(data(i));
 datasign(i,2)=sign(data(i));
end;

runs=datasign(:,2);

plus = find(data>0);
numtype1=length(plus);               % type1 is number of +1
minus = find(data<0);
numtype2=length(minus);              % type2 is number of -1

% calculate the number of runs
numruns=1; % start at one
currenttype=datasign(1,2);
for i=2:k;
 if datasign(i,2)~=currenttype;
  numruns=numruns+1;
  currenttype=datasign(i,2);
 end;
end;

%%% Need to learn how to perform exact probability
%%% Left tail probability runsrandompval1
runsrandompval1=0;
for i=2:numruns;
 % Calculate probability of this number of runs (S&S pg 112)
 if mod(i,2)==1;          % if odd
  s=(i-1)/2;
  if numtype1>s & numtype2>s;
   term1=nchoosek(numtype1-1,s-1)*nchoosek(numtype2-1,s);
   term2=nchoosek(numtype1-1,s)*nchoosek(numtype2-1,s-1);
   term3=nchoosek(k,numtype1);
   runsrandompval=(term1+term2)/term3;
  else;
   runsrandompval=0;
  end;
 else;                         % if even
  s=i/2;
  if numtype1>s & numtype2>s;
   term1=nchoosek(numtype1-1,s-1)*nchoosek(numtype2-1,s-1);
   term3=nchoosek(k,numtype1);
   runsrandompval=2*(term1)/term3;
  else;
   runsrandompval=0;
  end;
 end;
 runsrandompval1=runsrandompval1+runsrandompval;
end;
%%% Right tail probability runsrandompval2;
runsrandompval2=0;
for i=numruns:k-1
 % Calculate probability of this number of runs (S&S pg 112)
 if mod(i,2)==1;          % if odd
  s=(i-1)/2;
  if numtype1>s & numtype2>s;
   term1=nchoosek(numtype1-1,s-1)*nchoosek(numtype2-1,s);
   term2=nchoosek(numtype1-1,s)*nchoosek(numtype2-1,s-1);
   term3=nchoosek(k,numtype1);
   runsrandompval=(term1+term2)/term3;
  else;
   runsrandompval=0;
  end;
 else;                         % if even
  s=i/2;
  if numtype1>s & numtype2>s;
   term1=nchoosek(numtype1-1,s-1)*nchoosek(numtype2-1,s-1);
   term3=nchoosek(k,numtype1);
   runsrandompval=2*(term1)/term3;
  else;
   runsrandompval=0;
  end;
 end;
 runsrandompval2=runsrandompval2+runsrandompval;
end;

if mod(numruns,2)==1;          % if odd
 s=(numruns-1)/2;
 term1=nchoosek(numtype1-1,s-1)*nchoosek(numtype2-1,s);
 term2=nchoosek(numtype1-1,s)*nchoosek(numtype2-1,s-1);
 term3=nchoosek(k,numtype1);
 runsrandompval=(term1+term2)/term3;
else;                         % if even
 s=numruns/2;
 term1=nchoosek(numtype1-1,s-1)*nchoosek(numtype2-1,s-1);
 term3=nchoosek(k,numtype1);
 runsrandompval=2*(term1)/term3;
end;

%%% p-value via Normal approximation
meanr=1+2*numtype1*numtype2/k;
varr=2*numtype1*numtype2*(2*numtype1*numtype2-k)/((k^2)*(k-1));
if numruns<meanr;  % continuity correction
 zr=(numruns+.5-meanr)/sqrt(varr);
else
 zr=(numruns-.5-meanr)/sqrt(varr);
end;

pval1=normcdf(zr);
pval2=1-normcdf(zr);
if pval1<pval2;
 runsrandomnormalpval=pval1;
else;
 runsrandomnormalpval=pval2;
end;

%%% Runs test for Randomness section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%