function ecogNormalized=subtractCAR_16ChanBlocks(ecog,badChannels,oecog)

usechans= setdiff([1:size(ecog.data,1)],badChannels);


%calculate common average reference by 16-channel blocks
r=floor(size(ecog.data,1)/16);
if rem(r,16)==0
    extra=0
else
    extra=size(ecog.data,1)-r*16;
end

CAR=[];
for i=1:r
    CAR=[CAR;repmat(mean(ecog.data(intersect((i*16-15:i*16),usechans),:),1),16,1)];
end

if extra>0
     CAR=[CAR;repmat(mean(ecog.data(intersect(((r+1)*16-15:end),usechans),:),1),extra,1)];
end

%subtract common average reference from data
ecogNormalized.data=oecog.data-CAR;
ecogNormalized.sampDur=ecog.sampDur;
ecogNormalized.sampFreq=ecog.sampFreq;
ecogNormalized.selectedChannels=ecog.selectedChannels;
fprintf('\nCAR subtracted\n')