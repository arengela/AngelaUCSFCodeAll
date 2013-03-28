function [posSF,posCS]=getSulcusPos(xyCur,xySF,xyCS)
    idx=findNearest(xyCur(1),xySF(1,:));
    idx2=findSecondNearest(xyCur(1),xySF(1,:));
    posSF=xySF(2,idx);
    idx=findNearest(xyCur(2),xyCS(2,:));
    posCS=xyCS(2,idx);