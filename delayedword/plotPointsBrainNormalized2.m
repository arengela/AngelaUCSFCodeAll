function xy=plotPointsBrainNormalized2(devSF,devCS,xySF,xyCS,origin)
num=5;
g=polyfit(xySF(1,num:end-9),xySF(2,num:end-9),1)
yline=polyval(g,1:1000);
plot(yline);
originNew(1)=findNearest(origin(1),1:1000)
originNew(2)=yline(originNew(1));
origin=originNew;
for i=1:length(devSF)    
    syms x y
    f1=sprintf('(x)^2+(y)^2 = (%d)^2',devSF);
    f2=sprintf(' %d*(x+ %d)+%d=(%d-y)',g(1),originNew(1),g(2),originNew(2));
    c=solve(f1,f2)
    
    
    if devSF<0
        [~,idx]=(min(double([c.x(1) c.x(2)])));
    else
        [~,idx]=(max(double([c.x(1) c.x(2)])));
    end
    
    newSF(1)=origin(1)+c.x(idx)
    newSF(2)=origin(2)-c.y(idx)
    %plot(newSF(1),newSF(2),'*r')

    
    g(3)=-(newSF(1)*-1/g(1))+newSF(2);
    z=sqrt(devSF^2+devCS^2);
    f3=sprintf('(x)^2+(y)^2 = (%d)^2',z);
    f4=sprintf(' %s*(x+ %s)+%s=(%s-y)',num2str(-1/g(1)),num2str(origin(1)),num2str(g(3)),num2str(origin(2)));
    c=solve(f3,f4)
    
    
    plot(polyval([-1/g(1),g(3)],1:1000));
    
    
    
    if devCS>0
        [~,idx]=(max(double([c.y(1) c.y(2)])));
    else
        [~,idx]=(min(double([c.y(1) c.y(2)])));
    end
    
    
    plot(origin(1)+c.x(idx),origin(2)-c.y(idx),'*b')
    xy(1)=origin(1)+c.x(idx);
    xy(2)=origin(2)-c.y(idx);
end