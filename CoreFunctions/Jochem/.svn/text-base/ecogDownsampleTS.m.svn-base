function ecog=ecogDownsampleTS(ecog,newFrequencyHz)
% ecog=ecogDownsampleTS(ecog1,newFrequencyHz) Downsample ecog time series data
%
% PURPOSE:  Downsamples the time series in an ecog dataset to a new lower
%           frequency. Prior to downsampling the data are filtered at
%           Nyquist frequency (newFrequencyHz/2)
%           
% INPUT: 
% ecog:    An ecog structure
% newFrequencyHz: The new sampling frequency expressed in Hertz. So far
%          only simple sample picking is used. Therefore use only multiples 
%          of the original frequency to downsample
% OUTPUT:
% ecog:    An ecog structure with downsampled data and updated fields:
%          timebase, sampDur, nSamp, lastBaselineSamp,
%          refChanTS
%

% 090119 JR wrote it
% 091214 JR downsample triggerTs and refChanTS and timebase must not exist
nyquistFreq=newFrequencyHz/2;
newSampDur=1000/newFrequencyHz;
ecog=ecogFilterTemporal(ecog,[0 nyquistFreq],3);

%simple approach: just take every nth sample
sampRaster=newSampDur/ecog.sampDur;
sampIdx=round([1:sampRaster:ecog.nSamp]);

tmp=zeros(size(ecog.data,1),length(sampIdx),size(ecog.data,3));
for k=1:size(ecog.data,3)
    for ch=1:size(ecog.data,1)
        tmp(ch,:,k)=ecog.data(ch,sampIdx,k);
    end
end
ecog.data=tmp;

%Now the other fields
if isfield(ecog,'refChanTS');
    ecog.refChanTS=ecog.refChanTS(sampIdx);
end
if isfield(ecog,'timebase');
    ecog.timebase=ecog.timebase(sampIdx);
end
if isfield(ecog,'triggerTS')
    oriIdx=find(ecog.triggerTS~=0); % only non-zero vaklues are regarded as informative
    idx=round(oriIdx/(newSampDur/ecog.sampDur));
    zIdx=find(idx==0); % zero is not allowed
    if ~isempty(zIdx)
        idx(zIdx)=1;
    end
    if length(idx)~=length(unique(idx))
        warning('Some trigger have the same index in the new dataset -> some might be overwritten')
    end
    tmp=zeros(1,size(ecog.data,2));
    tmp(idx)=ecog.triggerTS(oriIdx);
    ecog.triggerTS=tmp;
end
ecog.sampDur=newSampDur;
ecog.nSamp=size(ecog.data,2);
if isfield(ecog,'timebase')
    ecog.nBaselineSamp=max(find(ecog.timebase<0));
end
