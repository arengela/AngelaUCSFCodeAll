function plotAmpPhaseCart256(ave)
%plot average AA at low frequency phases for all channels (currently works
%for 256 channels)
%x-axis is [-pi to pi]
%y-axis is frequency band [1 to 40]
%color is zscore of AA power
figure
for chanIt=1:256
    %plot amplitude of high frequency band by phase
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
    
    pcolor(squeeze(ave(chanIt,:,25:end)));shading interp
    text(1,0,num2str(chanIt))
    set(gca,'xtick',[],'ytick',[])
end