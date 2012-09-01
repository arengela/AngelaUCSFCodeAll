function popupImage(hObject, eventdata)

hFig = get(hObject, 'parent');
%if strcmp(get(hFig,'SelectionType'),'open')
% this was a double click, do something
%disp('do something')
tmp=get(gca,'Children')
%set(gca,'Color','y')
y=get(findobj(tmp(4)))
figure
subplot(3,1,1);
try
    imagesc(y.CData,[-1 2])
    colormap(flipud(gray))
    freezeColors;
catch
    plot(y.YData,'k')
end




hold on
y=get(findobj(tmp(2)))
plot(y.XData,y.YData,'r')

try
    y=get(findobj(tmp(3)))
    plot(y.XData,y.YData,'r')
end
axis tight
subplot(3,1,2)
y=get(findobj(tmp(2)));
hold on
plot(y.XData,[-1 2],'r')
axis tight



subplot(3,1,3)
y=get(findobj(tmp(4)))
try
    %folder=regexp(pwd,'\','split')
    tmp=get(hFig,'parent');
    patientID=get(tmp,'Name');
    ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,str2num(y.String),[],2,[],[]);
    colormap('gray');
end
%uiwait
%set(hObject,'Color','w')
%end