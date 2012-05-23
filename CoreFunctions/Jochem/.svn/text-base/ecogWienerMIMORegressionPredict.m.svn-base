function [Yhat]=ecogWienerMIMORegressionPredict(ecog,Y,W,intervalLength,intervalOffset)
%[Yhat]=ecogWienerMIMORegressionPredict(ecog,Y,W,intervalLength,intervalOffset) Apply MIMO Wiener regression to predict Yhat
%
% Purpose: Apply Multiple Input Multiple Output (MIMO) Wiener regression 
% to predict Yhat from X accoring to Yhat=X*W, i.e. predicts Y 
% (the movement or stimulus feature)from X (the ecog data).
%
% Yhat is predicted from multiple shifted version of X because W extends in
% time and establishes a certain temporal relation between X and Y that can 
% be interpreted in terms of causality (see below). Heres X causal on Y means
% that effects in X have an influence on what happens later in time in Y. 
% 
% INPUT:
% ecog:     An ecog structure with fields:
%           data
%           sampDur
% Y:        The matrix of time series of external variables (measured movements,
%           or stimulus parameters). Variables change along the first
%           dimension and time increases along the second.
% W:        The matrix W as returned by ecogWienerMIMORegressionTrain
%           The first entry might be an offset and must be discarded.
% intervalLength:
%           The length of the intervall of the regression filter 
%           (in milliseconds). The number of estimated regression parameters 
%           per external variable is intervalLengthInSamples*numberOfChannelsInX 
% intervalOffset:
%           Time offset between the brain data and external variables:
%           Four cases can be distinguished:
% 
%           intervalOffset<=-intervalLength: 
% returns a regression marix W with purely  
% causal effects of X on Y. If both absolute values are equal returns the  
% W with the shortest lag with purely causal effects of X on Y. Decreasing  
% the offset further (its a negative value!) produces X on Y causal Ws with  
% longer lags
% 
%           0>=intervalOffset>-intervalLength: 
% returns a matrix W producing mixed X 
% and Y on X causal effects. 
%
%           intervalOffset>=1: 
%produces the filter with the shortest lag with purely 
% causal effects of Y on X. Further increasing the offset (its a positive 
% value!) produces Y on X causal Ws with longer lags.
%
%           intervalOffset=0 and intervalLength=1
%           standard regression
% OUTPUT:
% Yhat:     The predicted Y-values.  
%           Due to the filter length some Yhat-values at the end will be
%           set to zero. Moreover, with negative offsets some Yhat-values at
%           the begin will be zero. This is because the Wiener regression 
%           working backwards in time cannot predit all Yhats at the begin. 
%           NEED A WORKAROUND FOR THIS: MAYBE PREPENDING X with zeros  
% Requirements: 

% 091129 JR wrote it based on Brian's code
% TODO: a function that allows us to to this online.   


%% Input check

if length(size(ecog.data))>2 && length(size(ecog.data))<3
    disp('Repetitions seem to exist. Will concatenate trials into one sequence!')
    error('not implemented yet')
    %there are atleatstwo way to do that: first concatenate tneh shift of
    %vice versa. the datloss in the second case is larger
end

%% We make the lagged X matrix first
% make shift indices
intervalLengthSamp=round(intervalLength/ecog.sampDur); % ms to samples
intervalOffsetSamp=round(intervalOffset/ecog.sampDur);

%pre allocat space. We throw away what is cut off by the lag
nChannels=size(ecog.data,1);

% distinguish cases the for X matrix set up
if intervalOffsetSamp<=0 %older points in X are used to predict newer points in Y
    shiftIdx=[0:intervalLengthSamp-1]; %we start with the first samples
else %Newer points in X are used to predict older points in Y
    shiftIdx=[0:intervalLengthSamp-1]+intervalOffsetSamp;
end

% the new number of samples is determined by the overlap of the Y and all
% shifted X columns and Y. The loss by non-overlap is abs(lag)+max(shiftIdx)
nSamplesNew=size(ecog.data,2)-abs(intervalOffsetSamp)-max(shiftIdx)-1;
X=zeros(nSamplesNew,nChannels*length(shiftIdx));

%Make X
for k=1:length(shiftIdx)
    X(:,(k-1)*nChannels+1:k*nChannels)=ecog.data(:,shiftIdx(k)+1:shiftIdx(k)+nSamplesNew)';
end

% We may want ot have normalized data
%X=zscore(X);

%% Now the prediction: 
Yhat=X*W;
