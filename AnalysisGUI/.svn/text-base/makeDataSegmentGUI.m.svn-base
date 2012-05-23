function seg=makeDataSegmentGUI(data,triggerIdx,preDurSamp, postDurSamp)

seg=zeros(size(data,1),(preDurSamp+postDurSamp), size(data,3),length(triggerIdx));
% get the segments
for k=1:length(triggerIdx)
    seg(:,:,:,k)=data(:,triggerIdx(k)-preDurSamp+1:triggerIdx(k)+postDurSamp,:);
end