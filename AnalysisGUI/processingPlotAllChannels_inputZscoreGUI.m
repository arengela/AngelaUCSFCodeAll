function processingPlotAllChannels_inputZscoreGUI(zScore,color,eventSamp,badChannels,bounds,z_std,gridlayout)

%{
PURPOSE: Plots average energy of segment for all channels. Outputs a subplot for each channel.

INPUT: One segmented 3D matrix of ecog data- dimensions: nChannels x nSamps x nRepetitions
%}

usechans=gridlayout.usechans;
extra=gridlayout.extra;


%ztmp=zScore(setdiff(1:256,badChannels),:);
if isempty(bounds)
    maxZallchan=max(zScore,[],2);
    minZallchan=min(zScore,[],2);
else 
    maxZallchan=1;
    minZallchan=-1;
end
a=find(maxZallchan>.75);
%a=find(max(zScore(:,200:300),[],2)>1)
diff=maxZallchan-minZallchan;
diff(badChannels)=NaN;
maxdiff=max(diff);
%maxZ=1;
%minZ=0;

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
    if find(ismember(badChannels,usechans(i)))
        set(gca,'Color','k') 
        %{
         %%Not sure what this piece of code does...

    elseif ~isempty(get(gca,'Children'))
        

            v=axis;
            m=mean(v(3:4));
            range_v=v(4)-v(3);
            max_c=minZallchan(usechans(i))+maxdiff;
            min_c=minZallchan(usechans(i));

            zScore(usechans(i),:)=zScore(usechans(i),:)*range_v/(max_c-min_c);
            mid_c=mean([max(zScore(usechans(i),:)),min(zScore(usechans(i),:))]);
            plot(zScore(usechans(i),:)-(mid_c-m),color)
            %z=zScore(usechans(i),:)-(mid_c-m);
            %jbfill(1:length(z),z+std(z),z-std(z));
        %}
    else
        
            
            plot(zScore(usechans(i),:),color)
                    hold on
            X=1:size(zScore(usechans(i),:),2);
%             try
%                 hp=patch([X, fliplr(X)], [zScore(usechans(i),:)+z_std(usechans(i),:),fliplr(zScore(usechans(i),:)-z_std(usechans(i),:))],'m');
%                 set(hp,'FaceAlpha',.5);
%                 set(hp,'EdgeColor','none');            
%                %z_std=zScore(usechans(i),:);
%                jbfill(1:length(zScore(usechans(i),:)),zScore(usechans(i),:)+z_std(usechans(i),:),zScore(usechans(i),:)-z_std(usechans(i),:),'m','m',[],0.3);
% 
%             end
axis tight
            hold on
            if isempty(bounds)
                    %axis([0 length(zScore(1,:)) minZallchan(usechans(i)) minZallchan(usechans(i))+maxdiff])
                    %axis([0 length(zScore(1,:)) minZallchan(usechans(i)) maxZallchan(usechans(i))])

                    %plot([eventSamp,eventSamp+0.001],[minZallchan(usechans(i)), minZallchan(usechans(i))+maxdiff],'r')
                    plot([eventSamp,eventSamp+0.001],[-1, 5],'r')
                    axis([0 length(zScore(1,:)) -1 5])
                   %plot([eventSamp+800,eventSamp+800+0.001],[minZallchan(usechans(i)), minZallchan(usechans(i))+maxdiff],'g')
                    %axis([0 length(zScore(1,:)) -.5 1])
                    axis tight
            %set(gca,'xtick',[],'ytick',[])  
                    %text(1,3,num2str(usechans(i)))
                    text(1,4.5,num2str(usechans(i)))
                    
            else
                   axis([0 length(zScore(1,:)) minZallchan maxZallchan]);
                   %axis tight
            end
       

    end
         set(h, 'ButtonDownFcn', @popupPlot)    

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

        if find(ismember(badChannels,extra(i)))
            set(gca,'Color','k')
        else 
            plot(zScore(extra(i),:),color)
            %axis tight
            hold on
            axis([0 length(zScore(1,:)) minZallchan(extra(i)) minZallchan(extra(i))+maxdiff])
            plot([eventSamp,eventSamp+0.001],[minZallchan(extra(i)), minZallchan(extra(i))+maxdiff],'r')
            %set(gca,'xtick',[],'ytick',[])  
            text(1,minZallchan(i)+maxdiff-0.1,num2str(extra(i)))
        end
    end
end
