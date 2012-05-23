function varargout = CVGUI_KB(varargin)
% CVGUI M-file for CVGUI.fig
%      CVGUI, by itself, creates a new CVGUI or raises the existing
%      singleton*.
%
%      H = CVGUI returns the handle to a new CVGUI or the handle to
%      the existing singleton*.
%
%      CVGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CVGUI.M with the given input arguments.
%
%      CVGUI('Property','Value',...) creates a new CVGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CVGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CVGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CVGUI

% Last Modified by GUIDE v2.5 22-Mar-2011 11:32:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CVGUI_OpeningFcn, ...
    'gui_OutputFcn',  @CVGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CVGUI is made visible.
function CVGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CVGUI (see VARARGIN)

% Choose default command line output for CVGUI
handles.output = hObject;

% Update handles structure
subject = get(handles.popupmenu5,'String');
subject = subject{get(handles.popupmenu5,'value')};
load ([subject 'favg']);
load ([subject 'allphn']);
handles.Y = Y;
handles.labs = labs;
handles.labnote = labnote;
guidata(hObject, handles);
% Nima starts here:
set(handles.popupmenu1,'string',{'none',unotes{:}});
set(handles.popupmenu2,'string',{'none',unotes{:}});
set(handles.popupmenu3,'string',{'none',unotes{:}});
set(handles.popupmenu4,'string',{'none',unotes{:}});
% UIWAIT makes CVGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CVGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cvind = [];
erflag = get(handles.checkbox6,'value');
lnwd = str2num(num2str(get(handles.edit7,'string')));
set(handles.pushbutton1,'String','Busy');
set(handles.pushbutton1,'ForegroundColor',[1 0 0]);
for cnt1 = 1:4
    tmp = get(handles.(['popupmenu' num2str(cnt1)]),'value')-1;
    if tmp>0
        cvind = [cvind tmp];
    end
end
subject = get(handles.popupmenu5,'String');
subject = subject{get(handles.popupmenu5,'value')};
load ([subject 'favg']);
colcode = ['b','r','g','k'];
colind = 1;
tic;
if get(handles.checkbox1,'value')
    figure;
else
    figure(100);
end
favg = zeros(size(handles.Y,1), size(handles.Y,2) ,length(handles.labnote));
fstd = zeros(size(handles.Y,1), size(handles.Y,2) ,length(handles.labnote));
for cnt1 = 1:length(handles.labnote)
    favg(:,:,cnt1) = mean(handles.Y(:,:,handles.labs==cnt1),3);
    fstd(:,:,cnt1) = std (handles.Y(:,:,handles.labs==cnt1),[],3)/...
        sqrt(length(find(handles.labs==cnt1)));
end
for cnt1 = 1:256
    disp([num2str(cnt1) ' out of 256']);
    subplot(16,16,cnt1);
    hold off;
    tmp = favg(cnt1,2:end,:);
    mx = max(tmp(:))*1.05; mn = min(tmp(:));
    colind = 1;
    for cnt2 = cvind
        %         disp(unotes{cnt2});
        %         mx = max2(favg(:,2:end,cnt2))*1.05; mn = min2(favg(:,2:end,cnt2));
        plot(squeeze(favg(cnt1,2:end,cnt2)),colcode(colind),'linewidth',lnwd);
        if erflag
            h = fill([1:size(favg,2)-1 size(favg,2)-1:-1:1],...
                [squeeze(favg(cnt1,2:end,cnt2)+fstd(cnt1,2:end,cnt2)) ...
                squeeze(favg(cnt1,end:-1:2,cnt2)-fstd(cnt1,end:-1:2,cnt2))],colcode(colind));
            set(h,'edgecolor',colcode(colind));
            alpha(.3);
        end
        hold on;
        colind = colind+1;
    end
    set(gca,'xticklabel','');
    set(gca,'yticklabel','');
    axis ([0 size(favg,2) mn mx]);%axis off;
    line([bef*100-1 bef*100-1],[mn mx],'linestyle','-.','color','k');
    t = text(4,mx-(mx-mn)*.2,num2str(cnt1));
    set(t,'FontSize',10);
    %     print ('-depsc2',[unotes{cnt2}]);
end
drawnow;
set(handles.pushbutton1,'String','OK');
set(handles.pushbutton1,'ForegroundColor',[0 0 0]);
toc
% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5

% subject change
subject = get(handles.popupmenu5,'String');
subject = subject{get(handles.popupmenu5,'value')};
load ([subject 'favg']);
load ([subject 'allphn']);
handles.Y = Y;
handles.labs = labs;
handles.labnote = labnote;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gridind = reshape(1:256,[16 16]);
inds = gridind(6:end,5:13);
data = guidata(hObject);
Y = data.Y;
labs = data.labs;
thislab = get(handles.popupmenu1,'value')-1;
labnote = data.labnote;
ay = Y(inds(:),:,:);
ay(1:2,:,:) = 0; ay(12,:,:)=0;
ay = reshape(ay,[11 9 size(ay,2) size(ay,3)]);
sdelay = str2num(get(handles.edit1,'string'));
smoothing = str2num(get(handles.edit2,'string'));
if smoothing>0,
    dsk = fspecial('disk',smoothing);
else
    dsk = 1;
end
if get(handles.checkbox1,'value')
    figure;
else
    figure(200);
    hold off;
end
tmpy = mean(ay(:,:,:,labs==thislab),4);
mx = max(tmpy(:)); mn = min(tmpy(:));
for cnt1 = 1:size(tmpy,3)
    tmpt = tmpy(:,:,cnt1);
    tmpt = flipud((tmpt));
    tmpt = conv2(tmpt,dsk,'same');
    surf(tmpt);
    %     im(tmpt)
    axis([1 size(tmpy,2) 1 size(tmpy,1) mn mx]);
    set(gca,'xtick',1:9);
    set(gca,'ytick',1:11);
    set(gca,'xticklabel',(inds(1,1:9)));
    set(gca,'yticklabel',flipud(inds(1:11,1)));
    %     set(gca,'cameraposition',[35.1083 51.4661 34.2347]);
    drawnow;
    pause(sdelay);
end
title(labnote{thislab});

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = guidata(hObject);
e1 = str2num(get(handles.edit3,'string'));
e2 = str2num(get(handles.edit4,'string'));
e3 = str2num(get(handles.edit8,'string'));
cvind = []; colcode = ['b','r','g','k'];
for cnt1 = 1:4
    tmp = get(handles.(['popupmenu' num2str(cnt1)]),'value')-1;
    if tmp>0
        cvind = [cvind tmp];
    end
end
thislab = cvind(1);
labnote = data.labnote;
Y = data.Y;
labs = data.labs;
n = str2num(get(handles.edit5,'string'));
dsk = ones(1,n)/n;
if get(handles.checkbox1,'value')
    figure;
else
    figure(300);
    hold off;
end
ay = cat(1,mean(Y(e1,:,labs==thislab),1),mean(Y(e2,:,labs==thislab),1),mean(Y(e3,:,labs==thislab),1));
% ay = Y([e1 e2],:,labs==thislab);
if get(handles.checkbox2,'value')
    subplot(2,2,1);
    rng = str2num(get(handles.edit6,'string'));
    rnglab = -40:50;
    ind1 = []; ind2 = [];
    for cnt1 = 1:size(ay,3)
        tmp1 = conv2(ay(:,:,cnt1),dsk,'same');
        tmp1(:,1:rng(1)) = -inf;
        tmp1(:,rng(end):end)=-inf;
        [m1,ind1(cnt1)] = max(tmp1(1,:));
        [m2,ind2(cnt1)] = max(tmp1(2,:));
    end
    plot(ind1,ind2,'.');
    % axis([0 90 0 90]);
    set(gca,'xtick',0:5:90);
    set(gca,'ytick',0:5:90);
    set(gca,'xticklabel',rnglab(1:5:end));
    set(gca,'yticklabel',rnglab(1:5:end));
    line([0,90],[0 90],'linestyle','--');
    line([40 40],[rng(1) rng(end)],'linestyle',':','color','r');
    line([rng(1) rng(end)],[40 40],'linestyle',':','color','r');
    title([labnote{thislab} '   -   N: ' num2str(size(ay,3)) '  cr: ' num2str(corrnum(ind1,ind2),'%2.3f')])
    xlabel(['electrode ' num2str(e1)]);
    ylabel(['electrode ' num2str(e2)]);
    ax = [rng(1)-10 rng(end)+10 rng(1)-10 rng(end)+10];
    ax = max(ax,0); ax = min(ax,90);
    axis(ax);
end
if get(handles.checkbox5,'value')
    subplot(2,2,2);
    hold off;
    plot(squeeze(ay(1,:,:)),'k');
    hold on;
    tmp1 = squeeze(ay(1,:,:));
    tmp2 = mean(tmp1,2);tmp2 = tmp2(:)';
    tmp3 = std(tmp1,[],2)/sqrt(size(tmp1,2));tmp3 = tmp3(:)';
    plot(tmp2,'y','linewidth',2);
    axis tight;
    h = fill([1:length(tmp2) length(tmp2):-1:1],[tmp2+tmp3 tmp2(end:-1:1)-tmp3(end:-1:1)],'y');
    set(h,'edgecolor','y');
    alpha(.5);
    title(e1);
    
    subplot(2,2,4);
    hold off;
    plot(squeeze(ay(2,:,:)),'k');
    hold on;
    tmp1 = squeeze(ay(2,:,:));
    tmp2 = mean(tmp1,2);tmp2 = tmp2(:)';
    tmp3 = std(tmp1,[],2)/sqrt(size(tmp1,2));tmp3 = tmp3(:)';
    plot(tmp2,'y','linewidth',2);
    axis tight;
    h = fill([1:length(tmp2) length(tmp2):-1:1],[tmp2+tmp3 tmp2(end:-1:1)-tmp3(end:-1:1)],'y');
    set(h,'edgecolor','y');
    alpha(.5);
    title(e2);
end
if get(handles.checkbox3,'value')
    subplot(2,2,3);
    a = permute(ay,[3 2 1]);
    hold off;
    thd = 0;
    tmp1 = a(:,:,1);
    tmp2 = a(:,:,2);
    %     tmp1(abs(tmp1)<(thd*std2(tmp1)))=NaN;
    %     tmp2(abs(tmp2)<(thd*std2(tmp2)))=NaN;
    for cnt2 = 1:size(tmp1,1)
        plot(tmp1(cnt2,:),tmp2(cnt2,:),'k');
        hold on;
    end
    
    %     tmp1 = squeeze(mean(a,1));
    %     tmp2 = squeeze(std(a,[],1));
    %     plot(tmp1(:,1),tmp1(:,2),'k','linewidth',2);
    % is this even possible!??!
    %     fill([tmp1(:,1)'-tmp2(:,1)' tmp1(end:-1:1,1)'+tmp2(:,1)'],...
    %          [tmp1(:,2)'-tmp2(:,2)' tmp1(end:-1:1,2)'+tmp2(end:-1:1,2)'],'b')
    %     set(h,'edgecolor','y');
    %     alpha(.5);
    
    
    a = squeeze(mean(a,1));
    plot(a(:,1),a(:,2),'y','linewidth',2);
    axis tight;
    a = axis;
    line([a(1) a(2)],[0 0],'linestyle','--');
    line([0 0],[a(3) a(4)],'linestyle','--');
end
if get(handles.checkbox4,'value')
    if get(handles.checkbox1,'value')
        figure;
    else
        figure(400);
        hold off;
    end
    for cnt1 = 1:length(cvind)
        ay = cat(1,mean(Y(e1,:,labs==cvind(cnt1)),1),mean(Y(e2,:,labs==cvind(cnt1)),1),...
            mean(Y(e3,:,labs==cvind(cnt1)),1));
        ay = mean(ay,3);
        ay = conv2(ay,dsk,'same');
                figure(400);
        hold on;
        for iii = 1:size(ay,2)
            switch colcode(cnt1)
                case 'b'
                    plot3(ay(1,iii),ay(2,iii),ay(3,iii),'o','Color',[0 0 iii/size(ay,2)],'linewidth',2);
                case 'r'
                    plot3(ay(1,iii),ay(2,iii),ay(3,iii),'o','Color',[iii/size(ay,2) 0 0],'linewidth',2);
                    
                case 'g'
                    plot3(ay(1,iii),ay(2,iii),ay(3,iii),'o','Color',[0 iii/size(ay,2) 0],'linewidth',2);
                case 'k'
                    plot3(ay(1,iii),ay(2,iii),ay(3,iii),'o','Color',[iii/size(ay,2) iii/size(ay,2) iii/size(ay,2)],'linewidth',2);
            end
        end
        plot3(ay(1,:),ay(2,:),ay(3,:),colcode(cnt1),'linewidth',1);
        hold on;
        plot3(ay(1,40),ay(2,40),ay(3,40),'marker','*y','markersize',10,'linewidth',2);
        plot3(ay(1,1),ay(2,1),ay(3,1),'marker','*y','markersize',10,'linewidth',2);
        plot3(ay(1,end),ay(2,end),ay(3,end),'marker','*y','markersize',10,'linewidth',2);
        
        
        grid on;
    end
    %     legend(labnote(cvind));
    xlabel(e1); ylabel(e2); zlabel(e3);
end

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
