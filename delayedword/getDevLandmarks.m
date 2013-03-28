function [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,i,ch)

xySF=BrainCoord(i).xySF
xyCS=BrainCoord(i).xyCS
xy=BrainCoord(i).xy
gridDist=BrainCoord(i).gridDist
clear devCS devSF xyCur
for c=1:length(ch)
    xyCur(:,c)=xy(:,ch(c));
    [devCS(c),devSF(c)]=getSulcusDev(xyCur(:,c),xySF,xyCS);
end
