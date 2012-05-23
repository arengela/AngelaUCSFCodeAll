function grid2channel(ch)

%{
if rem(ch,64)==0
    e=64
    b=floor(ch/64)
else
    b=floor(ch/64)+1
    e=rem(ch,64)
end
%}
row=ceil(ch/32);
tmp=ch-floor(ch/32)*32;

if tmp<=16
    col=ceil(tmp/2);
else
    tmp=tmp-16;
    col=ceil(tmp/2);
end


(row-1)*8+col

