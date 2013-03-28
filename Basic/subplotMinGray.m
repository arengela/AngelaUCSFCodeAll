function p=subplotMinGray(m,n,i,j,buffer)
if nargin<5
    buffer=.02;
end
y=((1-.05)-m*buffer)/m;
x=((1)-m*buffer)/n;
p=[(buffer*j+x*j)+buffer 1-(buffer*i+y*i) x y];
%subplot('Position',p)