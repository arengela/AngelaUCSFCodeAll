function [ps_fdr,h_fdr] = MT_FDR_PRDS (ps_raw,fdr_alpha)

%This function implements the step-up procedure of Benjamini and Hochberg
%(1995). This is a sequentially-rejective procedure that tests the p-values
%from largest to smallest (it is called step "up" because it goes from the
%least significant to the most significant). This method controls the 
%family wise error (FWE) weakly (if the omnibus null hypothesis of no
%effects anywhere is true, then there is only a 5% chance that this test
%will reject one or more local null hypotheses.) This procedure was proven
%to control the false-discovery rate (FDR) at the specified alpha
%level.
%
%Strictly speaking, this test assumes that the joint distributions of the
%test statistics where the null hypothesis holds are "positive regression
%dependent on each subset" (PRDS) (Benjamini and Yekutieli (2001)).
%
%INPUTS
%
%ps_raw [any size]: A list or matrix of any size of all the p-values for
%all the "hypotheses" that were tested. It is important to enter all of
%them at once and this is assumed in this script. Otherwise the test will
%be wrong! Also note that the p-values should already be corrected for a
%two-tailed test if that was the case.
%
%fdr_alpha (0<fdr_alpha<1): The false-discovery rate that would like to be
%maintained with this rejection procedure. This is also the level at which
%FWE is controlled weakly.
%
%
%OUTPUTS:
%
%ps_fdr [same size as ps_raw]: The adjusted p-values after the correction
%procedure.
%
%h_fdr [same size as ps_raw]: The outcome of the hsd procedure,
%where 1=accept, 0=reject.
%
%Erik Edwards
%U.C. Berkeley
%Fall, 2004

if nargin<2
    fdr_alpha=0.05;
end

m=prod(size(ps_raw)); %Total number of p-values

ps_fdr=zeros(size(ps_raw));
[ps_raw,indx]=sort(ps_raw(:));
for i=m-1:-1:1
    ps_raw(i) = min([ps_raw(i+1); (m/i)*ps_raw(i)]);
end
ps_fdr(indx)=ps_raw;

if nargout>1
    h_fdr=zeros(size(ps_fdr));
    h_fdr(find(ps_fdr<=fdr_alpha))=1;
end


% h_fdr=zeros(size(ps_raw));
% 
% m=prod(size(ps_raw)); %Total number of p-values, by Hochberg's labelling
% i=m;
% ps=ps_raw(:);
% while i>0 & max(ps)>fdr_alpha*i/m
%     %h_fdr(find(ps_raw==max(ps)))=0;
%     ps=ps(find(ps<max(ps)));
%     i=length(ps);
% end
% h_fdr(find(ps_raw<=max(ps)))=1;
% 
% if i==0
%     disp(['No hypotheses rejected; accept omnibus null hypothesis at ' num2str(fdr_alpha)]);
% end