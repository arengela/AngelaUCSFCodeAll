function tVals=ecogTValues(ecog1,ecog2)
% tVals=ecogTValues(ecog1,ecog2) Calculate t values for two set comparison
%
% PURPOSE:  Calculates t values for the point wise differences between
%           ecog1 and ecog2 data. 
%           If you want to perform a t test on the data and
%           you are not sure whether variances are equal
%           use corrected df's df=1/( (c^2/(n1-1)) + ((1-c)^2/(n2-1)))
%           with c=se(mu1)/(se(mu1)+se(mu2)) se is the standard error of
%           the mean (Bortz 1993, p.133)
%           If n1+n2 >= 50 T_VAL has normal distribution
%           
% INPUT: 
% ecog1:    An ecog structure
% ecog2:    An ecog structure
%
% OUTPUT:
% tVals:    A matrix of t values (size(ecog.data,1) by size(ecog.data,2))

% 090108 JR wrote it

var1=var(ecog1.data,0,3);
var2=var(ecog2.data,0,3);
mu1=mean(ecog1.data,3);
mu2=mean(ecog2.data,3);
n1=size(ecog1.data,3);
n2=size(ecog2.data,3);

seMeanDiff=sqrt( ((n1-1)*var1 + (n2-1)*var2)./((n1-1)+(n2-1)) ) .* sqrt(1/n1 + 1/n2);
tVals = (mu1-mu2)./seMeanDiff;
