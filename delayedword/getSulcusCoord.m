function [xDev,yDev]=getSulcusCoord(xyCur,xySF,xyCS)
    idx=findNearest(xyCur(1),xySF(1,:));
    xDev=xySF(1,idx);
    idx=findNearest(xyCur(2),xyCS(2,:));
    yDev=xyCS(2,idx);