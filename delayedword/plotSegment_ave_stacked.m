function keep=plotSegment_ave_stacked (zScoreall,imagePath,channels,aligned_ms,aligned_fs,buffer,bounds,events)

%% PLot segments zScore, reject bad trials try median

figure
set(gcf,'Color','w')

if isempty(aligned_ms)
    aligned_ms=3000;
    aligned_fs=(aligned_ms/1000)*400;
end
keep=0;

if isempty(bounds)
    maxY=9;
    minY=-4
else 
    maxY=max(bounds);
    minY=min(bounds);;
end

if isempty(buffer)
    buffer=[3 3];
end

if isempty(channels)
    channels=256;
end

if isempty(events)
    events=1:6;
end
    
xticklabelneg=[1:buffer(1)/1000];
xticklabelpos=[1:buffer(2)/1000];
xticklabel=[-fliplr(xticklabelneg) 0 xticklabelpos];


plotrows=1
hFigure=figure
set(hFigure,'Units','normalized');
set(hFigure,'OuterPosition',[.1 .1 .70 .40]);


hFigure1=figure
set(hFigure,'Units','normalized');
set(hFigure,'OuterPosition',[.1 .5 .70 .40]);

hFigure2=figure
set(hFigure,'Units','normalized');
set(hFigure,'OuterPosition',[.8 .1 .20 .20]);
eventtext={'slide','word onset','word offset','beep','response onset','responseoffset'}
%%
i=1
while i<=length(ch)
    
    ch=channels(i)
    type=1;
    
    %%
    for event=events
        
        set(0,'CurrentFigure',hFigure1)


        subplot(plotrows,6,event)

        [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);

        usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
        Y=squeeze(zScoreall(type).data{event}(ch,aligned_fs-buffer(1)*400+1:aligned_fs+buffer(2)*400,usetrials));
        E=std(Y,[],2)/sqrt(size(Y,2));
        errorarea(mean(Y,2),E);
        hp=line([aligned_fs aligned_fs],[ minY maxY]);
        set(hp,'Color','r')
        ht=text(aligned_fs+5, maxY-2,eventtext{event})
        set(ht,'Color','r')
        axis([0 2400 minY maxY])
        set(gca,'XTick',[0:400:(sum(buffer)/1000)*400]);
        set(gca,'XTickLabel',xticklabel)
        %title(int2str(ch))
        %set(gcf,'Name',int2str(ch))
        title(['N=' int2str(length(usetrials))])



        set(0,'CurrentFigure',hFigure2)

        subplot(plotrows,6,event)

        imagesc(Y',[0 3])
        %pcolor(tmp);
        colormap(flipud(pink))
        hold on
        plot([aligned_fs aligned_fs+.001],[0 length(usetrials)],'r')
        plot(aligned_fs+zScoreall(type).rt{event}(usetrials),1:length(usetrials),'r')
        hold off
      %axis([0 1600 minY maxY])
        set(gca,'XTick',[0:400:(sum(buffer)/1000)*400]);
        set(gca,'XTickLabel',xticklabel)
    
    
    end
    
    
    set(0,'CurrentFigure',hFigure)
    %figure(hFigure)
    %subplot(2,5,6)
    %imagePath='E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg';
    visualizeGrid(2,imagePath,ch)
    colormap gray
    
    
    
    r=input('Next\n','s')
    if strcmp('y',r)        
        keep=[keep ch];
    elseif strcmp('b',r)
       i=i-2;
    end
    i=i+1;
end
