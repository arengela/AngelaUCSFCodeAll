function [spit,statm,sminus,pval1,statp,splus,pval2,n,pitmannormalpval]=npar_pitman(data,k,exact)
% npar_pitman called by npar_main performs nonparametric pitman test
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
% Program: npar_pitman.m
% Includes:
%   Pitman
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate S+ (splus) S- (sminus) and pvalues from the data

splusidx = find(data>0);            % S+
splus = abs(sum(data(splusidx)));
sminusidx = find(data<0);           % S-
sminus = abs(sum(data(sminusidx)));

if splus<sminus;
 sval=splus;
else;
 sval=sminus;
end;

if exact==1;                % if k too large for exact results, normal approximation only
 n=2^k;                     % n = total number of sign permutations
 pit=zeros(n,1);            % pit used to store S+ for each permutation
 b=zeros(k,1);              % b is temporary binary number place holder vector
 
 for i=1:n;                 % compute binary numbers and S+ values
  temp=i;                   % temp is decimal number to be converted to binary
  for j=1:k;                % conversion to binary
   b(j,1)=mod(temp,2);
   temp=temp-b(j,1);
   temp=temp/2;
  end;
  pit(i)=dot(abs(data),b);  % compute S+ using dot product of our data with the binary number
 end;
 spit=sort(pit);            % spit is the sorted pit (S+) values
 
 % compute the test statistic by finding the rank
 statp = 1;                       % S+ rank
 while spit(statp) <= splus;
     statp=statp+1;
     if statp>n;
         break;
     end;
 end;
 statp=statp-1;
 statm = 1;                       % S- rank
 while spit(statm) <= sminus;
     statm=statm+1;
     if statm>n;
         break;
     end;
 end;
 statm=statm-1;
 
 % report the p-values
 pval2=statp/n;          % S+
 pval1=statm/n;          % S-
else; % normal approximation only
%% assign all other values to 0 to avoid warnings.
 pval1=0;
 pval2=0;
 spit=0;
 statm=0;
 statp=0;
 n=0;
end;


%%% p-value via Normal approximation
pitmean=.5*(splus+sminus);
pitvar=.5^2*dot(data,data);
if sval<pitmean;  % continuity correction
 zval=(sval+.5-pitmean)/sqrt(pitvar);
else
 zval=(sval-.5-pitmean)/sqrt(pitvar);
end;
normalpval1=normcdf(zval);
normalpval2=1-normcdf(zval);
if normalpval1<normalpval2;
 pitmannormalpval=normalpval1;
else;
 pitmannormalpval=normalpval2;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
