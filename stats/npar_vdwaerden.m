function [data,k]=npar_vdwaerden(data,k)
% npar_vdwaerden called by npar_main performs nonparametric Van Der Waerden normal scores test
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
% Program: npar_vdwaerden.m
% Includes:
%   Van Der Waerden normal scores
%      (first use Wilcoxon Sign Ranks, then convert to normal scores then use npar_pitman.m)
% Called by:
%   npar_main.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Van Der Waerden section BEGIN
% use ranks from npar_wilcoxsr.m
datasign=zeros(k,2);
for i=1:k;
 % decompose data into magnitudes (,1) and signs (,2)
 datasign(i,1)=abs(data(i));
 datasign(i,2)=sign(data(i));
end;

datasign=sortrows(datasign,1);   % sort datasign by magnitude, keeping associated sign in (:,2)

vdw=zeros(k,1);

for i=1:k;
 datasign(i,1)=datasign(i,1)/(k+1);  % transform ranks to normal quantiles

 datasign(i,1)=norminv(datasign(i,1),0,1) + 3;  % obtain z-values from standard normal cdf
                                                % add 3 to each score to make positive (for k < 700)
 vdw(i)=datasign(i,1)*datasign(i,2);  % assign signs to quantiles
end;
data=vdw;
%%% Van Der Waerden section END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%