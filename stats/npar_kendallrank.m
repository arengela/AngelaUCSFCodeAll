function [tkstat,pval1,pval2,tknormalpval]=npar_kendallrank(data,data2,k,k2,exact)
% npar_kendallrank called by npar_main performs nonparametric kendall rank correlation coefficient test
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
% Program: npar_kendallrank.m
% Includes:
%   Kendall Rank Correlation Coefficient
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kendall Rank Correlation Coefficient section BEGIN

%%% calculate tk statistics
tkstat=KendallTau(data,data2);

n=factorial(k);
k=length(data);
sd=sort(data);
permsx=perms(data)';
permsn=length(permsx);
probs=zeros(permsn,k+1);
for i=1:permsn;
 for j=1:k;
  probs(i,j+1)=permsx(j,i);      % i,2..k+1 includes permutations of data ranks
 end;
 probs(i,1)=KendallTau(sd,permsx(:,i)); % i,1 includes tk values
end

u1=length(find(probs(:,1)<=tkstat));      % the number of tk at least as extreme as probs
u2=length(find(probs(:,1)>=tkstat));
pval1=u1/n;                         % pvalues are the proportion of these
pval2=u2/n;

tknormalpval=9999;


%%% Kendall Rank Correlation Coefficient section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%