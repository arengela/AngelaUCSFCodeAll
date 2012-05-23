function [data,tVal,superThreshIdx]=ecogSpiderDataFeatureSelectTValues(data,objective,crit)
%[data]=ecogSpiderDataFeatureSelectTValues(data,objective,crit) %feature selection based on t-statistics  
%
% INPUT:
% data:     The data with repetitions along the first column
%           see ecogSpiderEcog2InputData how to obtain that format
% objective: A vector containing class labels for repetitions (1 or -1)
% crit:     The t-values threshold criterion. Only samples fullfilling 
%           abs(tVals)> are included in the output data.
%
% OUTPUT:   
% data:     The data with columns containing below threshold samples
%           deleted.
% tVal:     A vector of t-Values
% superThreshIdx: The indices of columns with superthreshold t-values in 
%           the input data. Use e.g. for displaying selected features.

% Whos to blame:
% 090501 JR wrote it

% tValues
idx1=find(objective==1);
idx2=find(objective==-1);
tVal=getTValues(mean(data(idx1,:),1),var(data(idx1,:),0,1),length(idx1),...
        mean(data(idx2,:),1),var(data(idx2,:),0,1),length(idx2));
superThreshIdx=find(abs(tVal>crit));
data=data(:,superThreshIdx);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Helper function
function tVals=getTValues(mu1,var1,n1,mu2,var2,n2);

seMeanDiff=sqrt( ((n1-1)*var1 + (n2-1)*var2)./((n1-1)+(n2-1)) ) .* sqrt(1/n1 + 1/n2);
tVals = (mu1-mu2)./seMeanDiff;
return;
