function popupImage3(hObject, eventdata)
global EC18_B2_seg;
global EC18_B1_seg_v2;
global idx;

hFig = get(hObject, 'parent');
%if strcmp(get(hFig,'SelectionType'),'open')
% this was a double click, do something
%disp('do something')
tmp=get(gca,'Children')
%set(gca,'Color','y')
y=get(findobj(tmp(5)))
figure

min=0;
max=2;

subplot(2,3,1);
imagesc(y.CData,[min max])
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
subplot(2,3,4)
y=get(findobj(tmp(5)))
plot(mean(y.CData,1));
hold on
tmp2=get(gca,'YTick');
y=get(findobj(tmp(2)))
plot(y.XData,tmp2([1,end]),'r')
subplot(2,3,5)

try
    %folder=regexp(pwd,'\','split')
    %tmp=get(hFig,'parent');
    %patientID=get(tmp,'Name');
    patientID='EC18';
    %ECogDataVis (['C:\Users\ego\Dropbox\ChangLab\General Patient Info\' patientID],patientID,str2num(y.String),[],2,[],[]);
    ECogDataVis (['C:\Users\ego\Dropbox\ChangLab\General Patient Info\' patientID],patientID, str2num(get(tmp(1),'String')),[],2,[],[]);

    %colormap('gray');
end


subplot(2,3,2);
imagesc(squeeze(EC18_B2_seg.zscore{1}(str2num( get(tmp(1),'String')),:,:))',[min max]);
hold on
eventSamp=3*400;
plot([eventSamp+EC18_B2_seg.rt{1}],[1:size(EC18_B2_seg.zscore{1},3)],'r')

plot([eventSamp eventSamp+.001],[0 size(EC18_B2_seg.zscore{1},3)],'r')
        colormap(flipud(gray))
        
        
        subplot(2,3,3);
imagesc(squeeze(EC18_B1_seg_v2.zscore(str2num( get(tmp(1),'String')),:,:))',[min max]);
hold on
eventSamp=3*400;
plot([eventSamp+EC18_B1_seg_v2.rt{1}],[1:size(EC18_B2_seg.zscore{1},3)],'r')

plot([eventSamp eventSamp+.001],[0 size(EC18_B2_seg.zscore{1},3)],'r')
        colormap(flipud(gray))
        
uiwait
%set(hObject,'Color','w')
%end