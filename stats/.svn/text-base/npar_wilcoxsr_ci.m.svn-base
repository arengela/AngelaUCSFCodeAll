function npar_wilcoxsr_ci(dataorg,k,n,spit)
% npar_wilcoxsr_ci called by npar_main performs nonparametric wilcox signed-rank confidence intervals
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
% Program: npar_wilcoxsr_ci.m
% Includes:
%   Wilcoxon Signed-Rank Confidence Intervals using Walsh averages
% Called by:
%   npar_main.m
%
% Maintenance:
%
  % this statement corrects the subscripts, but the CIs are not exact.
%   walshind=fix(walshind);   % in case of tie this will not be integer
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wilcoxon Confidence Intervals based on Walsh Averages section BEGIN
% Ref S&S pg 52-57
% Create Walsh Averages from original data
walshavg=zeros(k*(k+1)/2,1);
datawalsh=sort(dataorg);
ii=0;
for i=1:k;
 for j=i:k;
  ii=ii+1;
  walshavg(ii,1)=(datawalsh(i)+datawalsh(j))/2;
 end;
end;

walshavg=sort(walshavg);

%%% walshest = Median point estimator
walshn=k*(k+1)/2;             % walshn = number of walsh averages
if mod(walshn,2)==1;          % if odd, just take middle value
 idown=(walshn+1)/2;
 walshest=(walshavg(idown));
else;                         % if even, take average of middle two values
 idown=(walshn)/2;
 iup=idown+1;
 walshest=(walshavg(idown)+walshavg(iup))/2;
end;

% printing switch
walshindold=0;

%%% Start from the ends and remove end values toward the center until walshalpha level is reached
walshalpha=.15;
walshind=0;
spitvalold=0;
%%% Use p-values to get end-points of CI
for i=2:n;
 walshpval=i/n;
 if walshpval > (walshalpha/2);              % if pvalue is bigger than max limit, break
  break;
 end;
  % Use smaller of S+,S- for index of walsh average
  spit1=spit(i);
  spit2=spit(n-i+1);
  if spit1<spit2;
   walshind=spit1;
  else;
   walshind=spit2;
  end;
  % this statement corrects the subscripts (they were not integers), but the CIs are not exact.
  walshind=fix(walshind);   % in case of tie this will not be integer
  if walshindold ~= walshind;
   walshcil=walshavg(walshind);
   walshciu=walshavg(k*(k+1)/2-walshind+1);
   walshprob=1-walshpval*2;
   fprintf('%6.5f Confidence Limit on the Median %6.5f (index %3i): (%6.5f,%6.5f) \n',walshprob,walshest,walshind,walshcil,walshciu);
   walshindold=walshind;
 end;
end;
%%% Wilcoxon Confidence Intervals based on Walsh Averages section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%