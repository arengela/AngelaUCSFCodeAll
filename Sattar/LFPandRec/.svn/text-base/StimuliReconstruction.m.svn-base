function [g,rstim] = StimuliReconstruction (StimTrain, TrainResp, TestResp, g, Lag)
%
% stimulus reconstruction from neural responses
%
% StimTrain is the time-frequency representation of the training stimulus
% TrainResp is the corresponding neural responses to the training stimulus
% TestResp is the neural response reserved for testing
% g are the reconstruction filters (if empty, they will be calculated)
% Lag: are the time delays of the stimulus used for the estimation. Default
% is -5 to 7
% returns 
% g: reconstruction filters
% rstim: reconstructed stimulus from TestResp responses
%
% TrainStimuli: frequency*time
% TrainResp:    time*channel
% TestResp:     time*channel
%
%
% Nima Mesgarani, nimail@gmail.com
% (Mesgarani et. al. J. Neurophysiology 2009)


if ~exist('g','var'), g=[];end
if ~exist('TestResp','var') || isempty(TestResp)
    TestResp=[];
end
if ~exist('Lag','var') || isempty(Lag)
    Lag = [-5:7];
end
if ~isempty(StimTrain)
    TrainResp(isnan(TrainResp))=0;
    TrainRespLag = LagGeneratorNew(TrainResp,Lag);
    if ~isempty(TestResp)
    end
    disp('finding RR...');
    RR = TrainRespLag'*TrainRespLag;
    disp('finding RS...');
    RS = StimTrain*TrainRespLag;
    disp('finding g...');
    %
    %
    [u,s,v] = svd(RR);
    tmp1 = diag(s);
    tmp2 = tmp1/sum(tmp1);
    for cnt1 = 1:length(tmp2)
        if sum(tmp2(1:cnt1))>0.95, 
            break;
        end
    end
    tmp1 = 1./tmp1;
    tmp1(cnt1+1:end) = 0;
    g = (v*diag(tmp1)*u')*RS';
    %
%     g = pinv(RR)*RS';
%         g = RS' \ RR;
    disp('done...');
end
if ~isempty(TestResp)
    TestResp(isnan(TestResp))=0;
    TestRespLag  = LagGeneratorNew(TestResp,Lag);
    rstim = g'*TestRespLag';
end