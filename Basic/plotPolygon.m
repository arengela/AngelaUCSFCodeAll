function plotPolygon(center,sides,colormat,alpha,sizeRatio)

[x,y]=makePolygon(center,sides,sizeRatio);
h=fill(x,y,colormat);
set(h,'EdgeColor','none')
set(h,'FaceAlpha',alpha)