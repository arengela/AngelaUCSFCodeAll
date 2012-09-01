function [data,k]=npar_wilcoxsr(data,k)
% npar_wilcoxsr called by npar_main performs nonparametric wilcoxon signed-rank test
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
% Program: npar_wilcoxsr.m
% Includes:
%   Wilcoxon signed-rank (convert to ranks then use npar_pitman.m)
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wilcox signed-rank section BEGIN
datasign=zeros(k,2);
for i=1:k;
 % decompose data into magnitudes (,1) and signs (,2)
 datasign(i,1)=abs(data(i));
 datasign(i,2)=sign(data(i));
end;

datasign=sortrows(datasign,1);   % sort datasign by magnitude, keeping associated sign in (:,2)

%%% remove 0 values BEGIN
  % switch for removing 0 values before or after the assignment of ranks (1=before,0=after)
remove0before=0;

% this removes the 0 values before the assigning of ranks
datasign0idx = max(find(datasign(:,1)==0));
if datasign0idx >=1;
 datasigntemp=zeros(k-datasign0idx,2);  %temporary datasign vector for removing 0 values
 ii=0;
 for j=datasign0idx+1:k;
  ii=ii+1;
  datasigntemp(ii,:)=datasign(j,:);
 end;
 k=ii;                           % new value of k after 0s are removed
 datasign=zeros(k,2);            % reinitialize datasign and update from datasigntemp with no 0s
 datasign=datasigntemp;
end;
%%% remove 0 values END

[dataindx,xx]=tiedrank(datasign(:,1));          % obtain ranks (works for ties)
dataindx=dataindx';

%%% remove 0 values BEGIN
if datasign0idx >=1;
 if remove0before == 0;
  % this removes the 0 values after the assigning of ranks
  % by increasing the ranks by the number of 0s in the data
  datasign0idxl=length(datasign0idx);
  datasign0idx=datasign0idx*ones(datasign0idxl,1);
  dataindx=dataindx+datasign0idx;
 end;
end;
%%% remove 0 values END

wilcoxsr=zeros(k,1);
for i=1:k;
 wilcoxsr(i)=dataindx(i,1)*datasign(i,2);
end;
data=wilcoxsr;
%%% Wilcox signed-rank section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%