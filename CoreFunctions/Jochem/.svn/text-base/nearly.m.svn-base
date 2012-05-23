function [sample] = nearly(tim,timeArray)

% [sample] = nearly(tim,timeArray)
% 
% PURPOSE: 
% Find closest sample index to the time 
% in tim and return the index.
% INPUT:
% tim:       Target time point(s). Can be a vector of target time points.
% timeArray: A vector holding a time basis e.g. of an ECoG measurement
%            This is assumed to be a montonically increasing series of
%            numbers.
% OUTPUT:    
% sample:    The index to the sample closest to the targeted time point
% EXAMPLE:
% timeArray=1:100; tim=[-100 2.4 105];
% sample = nearly(tim,timeArray);
% sample should hold [1 3 100]


sample = zeros(size(tim));
tmp=zeros(length(tim),2);
for k=1:length(tim)
  t=min(find(timeArray > tim(k)));
  if ~isempty(t)
    tmp(k,1) = t;
  else
      [y,idx]=max(timeArray);
    tmp(k,1)=idx; % nothing is larger, we choose the max
  end
  t=max(find(timeArray <= tim(k)));
  if ~isempty(t)
    tmp(k,2) = t;
  else 
    [y,idx]=min(timeArray);
    tmp(k,2)=idx; %nothing is smaller, we choose the min
  end
  [y,idx]=min([abs(timeArray(tmp(k,1))-tim(k)),abs(timeArray(tmp(k,2))-tim(k))]);
  sample(k)=tmp(k,idx);
end