function plotAmpPhasePolar256_matrix(ave)
%%plot average AA at low frequency phases for all channels in radial graph (currently works
%for 256 channels)
%in polar coordinates:
%theta-axis is [-pi pi]
%r-axis is frequency band [1 40]
%color is zscore of AA power
figure
for chanIt=1:256
    m=floor(chanIt/16);
    n=rem(chanIt,16);
    
    if n==0
        n=16;
        m=m-1;
    end
    
    po(1)=6*(n-1)/100+.03;
    po(2)=6.2*(15-m)/100+0.01;
    
    po(3)=.055;
    po(4)=.055;
    h=subplot('Position',po);
    
    
    [X,Y]=cylinder(1:size(squeeze(ave(chanIt,:,:)),1),98);
    
    surf(X,Y,squeeze(ave(chanIt,:,:)));
    view(2)
    shading interp

end