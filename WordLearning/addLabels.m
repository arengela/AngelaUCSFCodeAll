function addLabels(fig)
%% RESET AXES OF PLOTS
hplots=get(fig,'Children');
set(gcf,'Color','w')
for  chanNum=1:length(hplots)
    axes(hplots(chanNum))
    %axis tight
    %set(hplots(chanNum),'CLim',[-1.5 1.5]);
    %set(hplots(chanNum),'YLim',[-5 5]);
    %set(hplots(chanNum),'XLim',[1 2]);
    %axis tight
    set(hplots(chanNum),'XTickLabel',[]);
    set(hplots(chanNum),'YTickLabel',[]);
    pos=get(hplots(chanNum),'Position');
    if pos(2)>.5
        set(hplots(chanNum),'Color',rgb('lightyellow'))
    else
        set(hplots(chanNum),'Color',rgb('lavender'))
    end
    set(hplots(chanNum),'Color',rgb('white'))    
    p=get(hplots(chanNum),'Position');
    epos=getGridPosition(p);
    text(4,2,int2str(epos));
end
%%
% axes('position',[0,0,1,1],'visible','off');
% Locations={'L-Front','L-Par','L-Cent1','L-Cent','L-Lat','L-Subtmp','L-Depth','L-Micro'...
%     'R-Front','R-Par','R-Cent1','R-Cent2','R-Lat','R-Subtmp','R-Depth','R-Micro'}
% Locations=fliplr(Locations);
% for n=1:16
%     p(1)=6*(n-1)/100+.03;
%     p(2)=.002
%     text(p(2),p(1),Locations{n})
% end
