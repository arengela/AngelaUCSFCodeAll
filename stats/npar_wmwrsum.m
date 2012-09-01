function [unstat,umstat,u1,pval1,u2,pval2,wmwnormalpval]=npar_wmwrsum(data,data2,k,k2,exact)
% npar_wmwrsum called by npar_main performs nonparametric wilcoxon-mann-whitney rank-sum test
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
% Program: npar_wmwrsum.m
% Includes:
%   Wilcoxon-Mann-Whitney rank-sum
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wilcoxon-Mann-Whitney rank-sum section BEGIN

[dataindx,xx] = tiedrank([data;data2]);  % obtain ranks (works for ties)
data=dataindx(1:k)';                     % replace data with ranks
data2=dataindx(k+1:k+k2)';               % replace data2 with ranks

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
 temp=find(datalarge==datasmall(i)); % ties get scored as 1/2 p151
 unstat=unstat+length(temp)/2;
 temp=find(datalarge>datasmall(i));
 unstat=unstat+length(temp);
end;
umstat=0;
for i=1:klarge;
 temp=find(datasmall==datalarge(i)); % ties get scored as 1/2 p151
 umstat=umstat+length(temp)/2;
 temp=find(datasmall>datalarge(i));
 umstat=umstat+length(temp);
end;

unstat
umstat

dataall=sort([datasmall;datalarge]);      % all the data together (sorted for tempsmall stripping below)

%exact = 0;
if exact == 1;
 wilcoxmw=nchoosek(dataall,k);     % wilcoxmw includes all sums of combinations of the data chosen k at a time
 n=length(wilcoxmw);

 uwmw=zeros(n,1);                    % for every possibility of the wilcoxmw, compute the U statistic
 for j=1:n;
  tempsmall=wilcoxmw(j,:)';
  temptemp=dataall;
  kk=k+k2;            % the number of elements in templarge which decreases to k2 when k are removed
  for ii=1:k;         % remove the tempsmall elements from dataall to form templarge
   temptempind=find(temptemp(1:kk)==tempsmall(ii));
   for jj=temptempind(1):kk-1;
    temptemp(jj)=temptemp(jj+1);
   end;
   kk=kk-1;
  end;
  templarge=temptemp(1:kk);
  if kk~=k2;
   error('kk ~= k2 !!!')
  end;

  for i=1:ksmall;
   temp=find(templarge==tempsmall(i)); % ties get scored as 1/2 p151
   if temp>0
  %temp
  %tempsmall(i)
  %templarge
  %length(temp)
  %length(temp)/2
  %uwmw(j)
  %pause
   uwmw(j)=uwmw(j)+length(temp)/2;
   end;
   temp=find(templarge>tempsmall(i));
   uwmw(j)=uwmw(j)+length(temp);
  end;
 end;

 %uwmw=sort(uwmw);
 %n
 u1a=length(find(uwmw<=umstat));      % the number of sums at least as extreme as datasmall
 u1b=length(find(uwmw>=umstat));
 pval1a=u1a/n;                         % pvalues are the proportion of these
 pval1b=u1b/n;
 u1=min(u1a,u1b);
 pval1=min(pval1a,pval1b);
 %u1
 %u2
 %u3=u1+u2
 %uwmw(1:u1+3)
 %pval2a=u2a/n                         % pvalues are the proportion of these
 %pval2b=u2b/n
 u2a=length(find(uwmw<=unstat));      % the number of sums at least as extreme as datasmall
 u2b=length(find(uwmw>=unstat));
 pval2a=u2a/n;                         % pvalues are the proportion of these
 pval2b=u2b/n;
 u2=min(u2a,u2b);
 pval2=min(pval2a,pval2b);
 %u1
 %u2
 %u3=u1+u2
 %uwmw(n-u2-3:n)
 %pval1=u1/n                         % pvalues are the proportion of these
 %pval2=u2/n
else;
 u1=9999;
 pval1=9999;
 u2=9999;
 pval2=9999;
end;

%%% p-value via Normal approximation (based on s-val as on pg 169)
sval=dataall;
wmwmean=(k/(k+k2))*sum(sval);
wmwvar=((k*k2)/((k+k2)*(k+k2-1)))*(sum(sval.^2)-(1/(k+k2))*(sum(sval))^2);
smstat=umstat+(1/2)*k*(k+1);
if smstat<wmwmean;  % continuity correction
 zval=(smstat+.5-wmwmean)/sqrt(wmwvar);
else
 zval=(smstat-.5-wmwmean)/sqrt(wmwvar);
end;
normalpval1=normcdf(zval);
normalpval2=1-normcdf(zval);
if normalpval1<normalpval2;
 wmwnormalpval=normalpval1;
else;
 wmwnormalpval=normalpval2;
end;

%sval
%wmwmean
%wmwvar
%smstat
%zval

%%% Wilcoxon-Mann-Whitney rank-sum section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%