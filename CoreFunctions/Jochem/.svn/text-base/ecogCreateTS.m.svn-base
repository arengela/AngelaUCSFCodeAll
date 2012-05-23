% get number samples for 1200 ms interval
nSamp = round(1.0*srate);
nSamp2 = round(0.2*srate);

channels = setdiff(1:size(Dec_CAReeg,1),bad_chan);
TS = zeros(length(channels),nSamp+nSamp2,length(goodTrial));
onset = fingerMovOnsetIdx-nSamp2+1;
offset = fingerMovOnsetIdx+nSamp;

for k=1:length(goodTrial),
    % baseline correction
    baseline = repmat(...
        mean(Dec_CAReeg(channels,onset(k)-100:onset(k)),2) ...
        ,1,nSamp+nSamp2);
    TS(:,:,k) = Dec_CAReeg(channels,onset(k):offset(k)) ...
        - baseline;
end

