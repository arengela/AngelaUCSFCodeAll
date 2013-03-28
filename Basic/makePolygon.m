function [x,y]=makePolygon(center,sides,sizeRatio)

t = (1/16:1/(sides):1)'*2*pi;
x = sin(t)*sizeRatio+center(1);
y = cos(t)*sizeRatio + center(2);