function [xDev,yDev]=getSulcusDev(xyCur,xySF,xyCS)
    idx=findNearest(xyCur(1),xySF(1,:));
    idx2=findSecondNearest(xyCur(1),xySF(1,:));
    p=xyCur;
    a=xySF(:,idx);
    v=xySF(:,idx2);
    c=polyfit([a(1) v(1)],[a(2) v(2)],1)
    m=c(1)
    b=c(2);
    x0=xyCur(1)
    y0=xyCur(2)  
    x1 = (m*y0+x0-m*b)/(m^2+1)
    y1 = (m^2*y0+m*x0+b)/(m^2+1)   
    yDev=pdist([p,[x1 ;y1]]')
    %yDev=xySF(2,idx)-xyCur(2);
    if p(2)>y1
        yDev=-yDev;
    end
    
    idx=findNearest(xyCur(2),xyCS(2,:));
    idx2=findSecondNearest(xyCur(2),xyCS(2,:));
    a=xyCS(:,idx);
    v=xyCS(:,idx2);
    c=polyfit([a(1) v(1)],[a(2) v(2)],1)
    m=c(1)
    b=c(2);
    x0=xyCur(1)
    y0=xyCur(2)  
    x1 = (m*y0+x0-m*b)/(m^2+1)
    y1 = (m^2*y0+m*x0+b)/(m^2+1)   
    xDev=pdist([p,[x1 ;y1]]')
    if p(1)<x1
        xDev=-xDev;
    end
    %xDev=xyCur(1)-xyCS(1,idx);