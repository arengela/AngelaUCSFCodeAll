function [W]=ecogWienerMIMORegressionTrain(ecog,Y,intervalLength,intervalOffset,lambda)
%[W]=ecogWienerMIMORegressionTrain(ecog,Y,intervalLength,intervalOffset,lambda) Calclulate a MIMO Wiener regression 
%
% Purpose: Calculate the Multiple Input Multiple Output (MIMO) Wiener regression 
% matrix W that does Y=X*W, i.e. predicts Y (the movement or stimulus feature)
% from X (the ecog data). Ridge regression is used to estimate W.
%
% Y is regressed with multiple shifted version of X. Therefore, W extends in
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
% W:        The matrix W to predict Y from X in the equation Yhat=X*W.
%           The first enttry in W is an offset and must be discarde for
%           prediction.
%
% Requirements: 
% Currently the ststistics toolbox for ridge regression. 

% 091129 JR wrote it based on Brian's code
% TODO: Potential new code ridge regression code is appended at the end of the function.  


%% DEBUG
DEBUG=0;
if DEBUG
    intervalLength=250; % in ms
    intervalOffset=-350; % in ms
    lambda=0.1;
    ecog.sampDur=1000/80;
    tS=0:ecog.sampDur:300000;
    ecog.data=[];
    for k=1:15
        ecog.data(k,:)=sin(tS*2*pi*1.5/1000)+normrnd(0,2,1,length(tS));
    end
    for k=1:15
        ecog.data(15+k,:)=normrnd(0,2,1,length(tS));
    end
    ecog.data(:)=0;ecog.data(:,30)=1;

    ecog.selectedChannels=1:30;
    Y=sin(tS*2*pi*1.5/1000);
    Y(:)=0; Y(30)=1;
end
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

%%  now chop the Y matrix
% We may want to include ones for the offset

if intervalOffsetSamp>=0 %newer points in X are used to predict older points in Y
    Y=Y(:,1:end-intervalOffsetSamp-max(shiftIdx)-1)'; %we chop only from the end
else %older points in X are used to predict newer points in Y
    if intervalOffsetSamp+max(shiftIdx)+1>=0
        Y=Y(:,abs(intervalOffsetSamp)+1:end-max(shiftIdx)-1)'; % chop lag from begin and interval length from end
    else
        Y=Y(:,abs(intervalOffsetSamp)-max(shiftIdx):end)'; %we chop only from the begin
    end
end
%Y=zscore(Y);
%% DEBUG output
if DEBUG
    figure;imagesc([Y(1:60) X(1:60,:)])
    figure;imagesc([Y(1:60) X(1:60,1)])
end
%% Now the ridge regression
% We estimate the coefficients for each column in Y separately

for k=1:size(Y,2)
    W(k,:)=ridge(Y(:,k),X,lambda,0);
    %     if any(isfinite(S(:,ff)))
    %     Arobust(ff,:)=robustfit(Q,S(:,ff));
    %     end
    
end
W=W';


%Sample code for ridge regression from
%http://www-stat.stanford.edu/~susan/courses/b494/index/node34.html
% function bks=ridge(Z,Y,kvalues)
% % Ridge Function of Z (centered, explanatory)
% % Y is the response, 
% % kvalues are the values where to compute
% [n,p]=size(Z);
% ZpY=Z'*Y;
% ZpZ=Z'*Z;
% m=length(kvalues);
% bks=ones(p,m);
% for k =1:m
%  bks(:,k)=(ZpZ+diag(kvalues(k)))\ZpY;
% end
% >> kvalues=(0:.05:.5)
% kvalues =
%   Columns 1 through 7 
%          0    0.0500    0.1000    0.1500    0.2000    0.2500    0.3000
%   Columns 8 through 11 
%     0.3500    0.4000    0.4500    0.5000
% >> ridge(Z,Y,(0:.05:.5))
% ans =
%   Columns 1 through 7 
%     1.5511    1.5176    1.4882    1.4622    1.4390    1.4183    1.3996
%     0.5102    0.4775    0.4488    0.4234    0.4009    0.3806    0.3624
%     0.1019    0.0678    0.0378    0.0113   -0.0122   -0.0334   -0.0524
%    -0.1441   -0.1762   -0.2043   -0.2292   -0.2514   -0.2713   -0.2892
%   Columns 8 through 11 
%     1.3827    1.3673    1.3532    1.3403
%     0.3459    0.3309    0.3172    0.3046
%    -0.0696   -0.0853   -0.0997   -0.1128
%    -0.3054   -0.3201   -0.3336   -0.3460
% %Formula gives for choice of k:
% >> norm(Yhat-Yc)^2
% ans =
%    47.8636
% >> 47.8636/(13-5)
% ans =
%     5.9829   % estimates the variance sigma^2
% >> bk0'*bk0
% ans =
%     2.6973
% >> k=(4*5.9829)/2.6973
% k =
%     8.8724     % This is a suggested value for k





