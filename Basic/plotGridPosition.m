function [h,p]=plotGridPosition(epos)
coltot=16;
h=0;
m=floor(epos/coltot);
n=rem(epos,coltot);
if n==0
    n=coltot;
    m=m-1;
end
p(1)=6*(n-1)/100+.03;
p(2)=6.2*(15-m)/100+0.01;
p(3)=.055;
p(4)=.055;
%h=subplot('Position',p);
%text(2,4,int2str(epos));
hold on