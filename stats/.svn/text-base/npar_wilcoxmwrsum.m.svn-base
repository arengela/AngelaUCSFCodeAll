function  [unstat,umstat,u1,pval1,u2,pval2,wmwnormalpval]=npar_wilcoxmwrsum(data,data2,k,k2)
% npar_wilcoxmwrsum called by npar_main performs nonparametric wilcoxon-mann-whitney rank-sum test
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
% Program: npar_wilcoxmwrsum.m
% Includes:
%   Wilcoxon-Mann-Whitney rank-sum
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wilcoxon-Mann-Whitney rank-sum section BEGIN

if k<=k2;
 datasmall=data;
 datalarge=data2;
 ksmall=k;
 klarge=k2;
else;
 datasmall=data2;
 datalarge=data;
 ksmall=k2;
 klarge=k;
end;

%%% calculate Un and Um statistics
unstat=0;
for i=1:ksmall;
 temp = find(datalarge>datasmall(i));
 unstat=unstat+length(temp);
end;
umstat=0;
for i=1:klarge;
 temp = find(datasmall>datalarge(i));
 umstat=umstat+length(temp);
end;

dataall=[datasmall;datalarge];      % all the data together

wilcoxmw=nchoosek(dataall,k);     % wilcoxmw includes all sums of combinations of the data chosen k at a time
n=length(wilcoxmw);

uwmw=zeros(n,1);
for j=1:n;
 tempsmall=wilcoxmw(j,:)';
 templarge=setdiff(dataall,tempsmall);
 for i=1:ksmall;
  temp=find(templarge>tempsmall(i));
  uwmw(j)=uwmw(j)+length(temp);
 end;
 uwmw(j);
end;

u1=length(find(uwmw <= umstat));   % the number of sums at least as extreme as datasmall
u2=length(find(uwmw >= umstat));
pval1=u1/n;                            % pvalues are the proportion of these
pval2=u2/n;

wmwnormalpval=1000;

%%% Wilcoxon-Mann-Whitney rank-sum section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
