function [seg,bas]=ecogSegmentTS(tS,triggerIdx,preDurSamp,postDurSamp)
% [seg,bas]=ecogSegmentTS(tS,triggerIdx,preDurSamp,postDurSamp) Create zero baseline datasegments around the indces in triggerIdx
%
% INPUT:
% tS:           A matrix of data time series. Values in triggerIdx are assumed to 
%               refer to indices along the first dimension of tS
% triggerIdx:   A vector of indices marking the segment start in the first 
%               dimension of tS.
% preDurSamp:   The number of pre-trigger samples in the segment extracted.
% postDurSamp:  The number of pre-trigger samples in the segment extracted.
%
% OUTPUT:       
% seg:          An ND-array containing the segments with size
%               length(1:preDurSamp+postDurSamp) X size(tS,2) X length(triggerIdx)
%               correponding to segment length X number of channels X
%               number of segments. The baseline (mean(preDurSamp)) was
%               subtracted from each segment
% bas:          An array containing the baselines of the segments. Size is
%               1 X size(tS,2) X length(triggerIdx)
% USAGE:
% [seg, bas]=ecogSegmentTS(Dec_CAReeg',fingerMovOnsetIdx,200/sampDurMs,1500/sampDurMs);

% 081223 jr wrote it

% reserve space
seg=zeros(length(1:preDurSamp+postDurSamp),size(tS,2),length(triggerIdx));
% get the segments
for k=1:length(triggerIdx)
    seg(:,:,k)=tS(triggerIdx(k)-preDurSamp+1:triggerIdx(k)+postDurSamp,:);
end
% subtract the baseline 
bas=mean(seg(1:preDurSamp+postDurSamp,:,:),1);
seg=seg-repmat(bas,[size(seg,1),1,1]);
