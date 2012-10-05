function popupImage4(hObject, eventdata)

hFig = get(hObject, 'parent');
%if strcmp(get(hFig,'SelectionType'),'open')
% this was a double click, do something
%disp('do something')
tmp=get(gca,'Children')
%set(gca,'Color','y')
newFig=figure;
subplot(3,1,1);

for child=1:length(tmp)
    y=get(findobj(tmp(child)))    
    hold on
    if isfield(y,'CData')
        imagesc(flipud(y.CData))
        %colormap(flipud(gray))
        %freezeColors;
    elseif isfield(y,'XData')
         %plot(y.XData,y.YData,'k')
    elseif isfield(y,'String')
        title(y.String)
    end
end
axis tight

subplot(3,1,2)
for child=1:length(tmp)
    y=get(findobj(tmp(child)))    
    hold on
    if isfield('CData',y)
        dim=size(y.CData)
       d1=y.CData(1:dim(1)/2);
       d2=y.CData(dim(1)/2:end);
       %colormap(flipud(gray))
       plot(d1)
       hold on
       plot(d2,'r')
    end
end


subplot(3,1,3)
y=get(findobj(tmp(1)))
try
    tmp=get(hFig,'parent');
    patientID=get(tmp,'Name');
    ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,str2num(y.String),[],2,[],[]);
    colormap('gray');
end
%uiwait
set(hObject,'Color','w')
set(newFig,'Position',[100 200 200 400])
%end