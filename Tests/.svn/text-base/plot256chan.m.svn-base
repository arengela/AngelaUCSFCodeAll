function plot256chan(ave,plottype,ave2)
%%plot average AA at low frequency phases for all channels in radial graph (currently works
%for 256 channels)
%in polar coordinates:
%theta-axis is [-pi pi]
%r-axis is frequency band [1 40]
%color is zscore of AA power
figure
set(gcf,'Color','w')
maxave=max(max(max(ave,[],3),[],1),[],2)*.55;
%minave=min(min(min(ave,[],3),[],1),[],2);
minave=0;

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
    
    switch plottype
        case 'polar'
            [X,Y]=cylinder(1:size(squeeze(ave(chanIt,:,:)),1),98);

            surf(X,Y,squeeze(ave(chanIt,:,:)));
            view(2)
            shading interp
             caxis([minave maxave])

             colormap(flipud(pink))
             text(-50,-50,num2str(chanIt))

        case 'cart'
            pcolor(squeeze(ave(chanIt,:,:)));shading interp
             caxis([minave maxave])

             colormap(flipud(pink))
             text(1,-1,num2str(chanIt))

        case 'line'

            plot(squeeze(ave(chanIt,1,:)))
            maxave=max(max(max(ave,[],3),[],1),[],2)*1.1;
            %axis([1 15 minave maxave])
            text(1,minave,num2str(chanIt))
            if exist('ave2')
                hold on
                 plot(squeeze(ave2(chanIt,1,:)),'r')
                maxave=max(max(max(ave,[],3),[],1),[],2)*1.1;
                %axis([1 15 minave maxave])
                text(1,minave,num2str(chanIt))
            end

    end
            set(gca,'xtick',[],'ytick',[])
            

end
colorbar('north')