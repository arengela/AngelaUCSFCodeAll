function popupImage2(hObject, eventdata)

hFig = get(hObject, 'parent');
%if strcmp(get(hFig,'SelectionType'),'open')
% this was a double click, do something
%disp('do something')
tmp=get(gca,'Children')
%set(gca,'Color','y')
y=get(findobj(tmp(5)))
figure
subplot(3,1,1);
imagesc(y.CData,[-1 2])
colormap(flipud(gray))
freezeColors;

hold on
y=get(findobj(tmp(2)))
plot(y.XData,y.YData,'r')

try
    y=get(findobj(tmp(3)))
    plot(y.XData,y.YData,'r')
end
axis tight
subplot(3,1,2)
y=get(findobj(tmp(5)))
plot(mean(y.CData,1));
hold on
tmp2=get(gca,'YTick');
y=get(findobj(tmp(2)))
plot(y.XData,tmp2([1,end]),'r')
subplot(3,1,3)

y=get(findobj(tmp(5)))
try
    %folder=regexp(pwd,'\','split')
    tmp=get(hFig,'parent');
    patientID=get(tmp,'Name');
    ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,str2num(y.String),[],2,[],[]);
    colormap('gray');
end
uiwait
%set(hObject,'Color','w')
%end