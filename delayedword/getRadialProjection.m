function [angles,rho]=getRadialProjection(xyO,xAxis,xy)

c=polyfit([xyO(1) xAxis(1)],[xyO(2) xAxis(2)],1);

for i=1:size(xy,2)
    
    tmp=triangle_angles([xy(:,i),xyO,xAxis]','r');
    angles(i)=tmp(2);
    rho(i)=pdist([xyO xy(:,i)]');    
    
    linePoint=polyval(c,xy(1,i));
    if linePoint>xy(2,i)
        angles(i)=2*pi-tmp(2);
    end

end