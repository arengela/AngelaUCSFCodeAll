function popupPlot(hObject, eventdata)

hFig = get(hObject, 'parent');
%if strcmp(get(hFig,'SelectionType'),'open')
  % this was a double click, do something
  %disp('do something')
  tmp=get(gca,'Children')
   set(gca,'Color','y') 
  y=get(findobj(tmp(3)))
  tmpfig=figure  
  set(gcf,'Color','w')
  plot(y.XData,y.YData)
  hold on
  y=get(findobj(tmp(2)))
  plot(y.XData,y.YData,'r')
  plot([1200+2.4*400 1201+2.4*400],y.YData,'c')
    axis tight
    uiwait
    set(hObject,'Color','w') 
%end