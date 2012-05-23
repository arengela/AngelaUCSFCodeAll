function processingPlotAllSpectrograms_inputZscoreGUI(zScore, eventSamp,badChannels,bounds,gridlayout)

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
if isempty(bounds)
    maxZallchan=max(max(max(zScore,[],2),[],3),[],1);
    minZallchan=min(min(min(zScore,[],2),[],3),[],1);
else
    maxZallchan=bounds(2);
    minZallchan=bounds(1);
end
%diff=maxZallchan-minZallchan;
%diff(badChannels)=NaN;
%maxdiff=max(diff)
%maxZ=1;
%minZ=0;


usechans=gridlayout.usechans;
extra=gridlayout.extra;

rowtot=gridlayout.dim(1);
coltot=gridlayout.dim(2);




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
    h=subplot('Position',p);
    
    if ismember(badChannels,usechans(i))
    else
        imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:)))))

        %imagesc(flipud(squeeze(zScore(i,:,:))'),[minZallchan maxZallchan])
        %imagesc(flipud(squeeze(zScore(i,:,:))'),[-5 5])


        %axis tight

        hold on
        plot([eventSamp eventSamp+0.001],[0 size(zScore,2)],'w')

        %set(gca,'xtick',[],'ytick',[])  
    end
        text(1,0,num2str(usechans(i)))
        %plot(meanOfBaseline(usechans(n),:),'c');
        %plot(meandata(usechans(n),:),'m')
        set(h, 'ButtonDownFcn', @popupImage)    
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
        %imagesc(flipud(squeeze(zScore(256+i,:,:))'),[minZallchan maxZallchan])
        imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:))')))


        %axis tight

        hold on
        plot([eventSamp eventSamp+0.001],[0 size(zScore,2)],'w')

        %set(gca,'xtick',[],'ytick',[])  
        end
        text(1,0,num2str(usechans(i)))
    end
end