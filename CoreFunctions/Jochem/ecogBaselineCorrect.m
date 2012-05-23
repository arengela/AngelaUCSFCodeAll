function ecog=ecogBaselineCorrect(ecog)
% ecog=ecogBaselineCorrect(ecog) set the baseline to zero average
%
% INPUT:
% ecog:         An ecog structure
%
% OUTPUT:
% ecog:         An ecog structure with baselines in data set to zero
%               average. This in done for each time series separately

% 090501 JR wrote it

% we loop over trials 
% this strategy requires a bit more time but saves memory
for k=1:size(ecog.data,3)
    tmp=repmat(squeeze(mean(ecog.data(:,1:ecog.nBaselineSamp,k),2)),1,ecog.nSamp);
    ecog.data(:,:,k)=ecog.data(:,:,k)-tmp;
end