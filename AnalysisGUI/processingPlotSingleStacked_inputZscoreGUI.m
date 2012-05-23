function processingPlotSingleStacked_inputZscoreGUI(zScore,eventSamp,badChannels,gridlayout)

%{
PURPOSE: Plots average energy of segment for all channels. Outputs a subplot for each channel.

INPUT: One segmented 3D matrix of ecog data- dimensions: nChannels x nSamps x nRepetitions
%}

%{
fid = fopen('badChannels.txt');
tmp = fscanf(fid, '%d');
badChannels=tmp';
fclose(fid);
%}
%ztmp=zScore(setdiff(1:256,badChannels),:);
%maxZallchan=max(max(zScore,[],2),[],3);
%minZallchan=min(min(zScore,[],2),[],3);
%diff=maxZallchan-minZallchan;
%diff(badChannels)=NaN;
%maxdiff=max(diff)
%maxZ=1;
%minZ=0;


usechans=gridlayout.usechans;
extra=gridlayout.extra;

rowtot=gridlayout.dim(1);
coltot=gridlayout.dim(2);
%figure

if length(usechans)>256
    usechans=1:256;
    extra=size(zScore,1)-length(usechans);
end


%PLOT ALL CHANNELS
for i=1:length(usechans)
    m=floor(i/coltot);
     n=rem(i,coltot);

     if n==0
         n=coltot;
         m=m-1;
     end    
    p(1)=6*(n-1)/100+.03;
    p(2)=6.2*(15-m)/100+0.01;
    
    p(3)=.055;
    p(4)=.055; 
    ha=subplot('Position',p);
    
    if ismember(badChannels,usechans(i))
    else
        %imagesc(squeeze(zScore(i,:,:))',[minZallchan(i) minZallchan(i)+maxdiff])
        h2=imagesc(squeeze(zScore(usechans(i),:,:))',[-1 2]);
        h=text(p(1),p(2),int2str(usechans(i)));
        set(h,'BackgroundColor','w')
        %axis tight

        hold on
    colormap(flipud(gray))

        %axis([0 length(zScore(1,:)) minZallchan(i) minZallchan(i)+maxdiff(i)])
        plot([eventSamp eventSamp+.001],[0 size(zScore,3)],'r')
    end
     text(1,0,num2str(usechans(i)))
     set(gca,'xtick',[],'ytick',[])  

    set(h2, 'ButtonDownFcn', @popupImage)    
    %set(gca,'xtick',[],'ytick',[])  
    %text(1,minZallchan(i)+maxdiff(i)-0.1,num2str(usechans(i)))
    %plot(meanOfBaseline(usechans(n),:),'c');
    %plot(meandata(usechans(n),:),'m')
end

if extra~=0
    figure
    for i=1:length(extra)
        m=floor(i/16);
        n=rem(i,16);

        if n==0
            n=16;
            m=m-1;
        end

        p(1)=6*(n-1)/100+.03;
        p(2)=6.2*(15-m)/100+0.01;

        p(3)=.055;
        p(4)=.055; 
        h=subplot('Position',p);
        
        
        if ismember(badChannels,usechans(i))
        else
            %imagesc(squeeze(zScore(i,:,:))',[minZallchan(i) minZallchan(i)+maxdiff])
            h2=imagesc(squeeze(zScore(usechans(i),:,:))');
            h=text(p(1),p(2),int2str(usechans(i)));
            set(h,'BackgroundColor','w')
            %axis tight

            hold on
            %axis([0 length(zScore(1,:)) minZallchan(i) minZallchan(i)+maxdiff(i)])
            plot([eventSamp eventSamp+.001],[0 size(zScore,3)],'w')
        end
    end
    set(gcf,'Name',patient)
    set(ha2, 'ButtonDownFcn', @popupImage)    

end
