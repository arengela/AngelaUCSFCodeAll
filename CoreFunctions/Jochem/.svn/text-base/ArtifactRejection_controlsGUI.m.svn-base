function varargout = ArtifactRejection_controlsGUI(varargin)
% ARTIFACTREJECTION_CONTROLSGUI M-file for ArtifactRejection_controlsGUI.fig
%      ARTIFACTREJECTION_CONTROLSGUI, by itself, creates a new ARTIFACTREJECTION_CONTROLSGUI or raises the existing
%      singleton*.
%
%      H = ARTIFACTREJECTION_CONTROLSGUI returns the handle to a new ARTIFACTREJECTION_CONTROLSGUI or the handle to
%      the existing singleton*.
%
%      ARTIFACTREJECTION_CONTROLSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARTIFACTREJECTION_CONTROLSGUI.M with the given input arguments.
%
%      ARTIFACTREJECTION_CONTROLSGUI('Property','Value',...) creates a new ARTIFACTREJECTION_CONTROLSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before ArtifactRejection_controlsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ArtifactRejection_controlsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ArtifactRejection_controlsGUI

% Last Modified by GUIDE v2.5 31-Jul-2009 13:34:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ArtifactRejection_controlsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ArtifactRejection_controlsGUI_OutputFcn, ...
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


% --- Executes just before ArtifactRejection_controlsGUI is made visible.
function ArtifactRejection_controlsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ArtifactRejection_controlsGUI (see VARARGIN)

% Choose default command line output for ArtifactRejection_controlsGUI
handles.output = hObject;
handles.axesFig=varargin{1};
handles.MR_lines=[];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ArtifactRejection_controlsGUI wait for user response (see UIRESUME)
% uiwait(handles.controlFig);


% --- Outputs from this function are returned to the command line.
function varargout = ArtifactRejection_controlsGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function AT_maxSlope_Callback(hObject, eventdata, handles)
% hObject    handle to AT_maxSlope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AT_maxSlope as text
%        str2double(get(hObject,'String')) returns contents of AT_maxSlope as a double


% --- Executes during object creation, after setting all properties.
function AT_maxSlope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_maxSlope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AT_on.
function AT_on_Callback(hObject, eventdata, handles)
% hObject    handle to AT_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AT_on



function AT_interval_Callback(hObject, eventdata, handles)
% hObject    handle to AT_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AT_interval as text
%        str2double(get(hObject,'String')) returns contents of AT_interval as a double


% --- Executes during object creation, after setting all properties.
function AT_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AT_shift_Callback(hObject, eventdata, handles)
% hObject    handle to AT_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AT_shift as text
%        str2double(get(hObject,'String')) returns contents of AT_shift as a double


% --- Executes during object creation, after setting all properties.
function AT_shift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AT_shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EV_on.
function EV_on_Callback(hObject, eventdata, handles)
% hObject    handle to EV_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EV_on



function EV_maxDeviation_Callback(hObject, eventdata, handles)
% hObject    handle to EV_maxDeviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EV_maxDeviation as text
%        str2double(get(hObject,'String')) returns contents of EV_maxDeviation as a double


% --- Executes during object creation, after setting all properties.
function EV_maxDeviation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EV_maxDeviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in IV_on.
function IV_on_Callback(hObject, eventdata, handles)
% hObject    handle to IV_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IV_on



function IV_maxStdDev_Callback(hObject, eventdata, handles)
% hObject    handle to IV_maxStdDev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of IV_maxStdDev as text
%        str2double(get(hObject,'String')) returns contents of IV_maxStdDev as a double


% --- Executes during object creation, after setting all properties.
function IV_maxStdDev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IV_maxStdDev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axesHandles=guidata(handles.axesFig);
[FileName,PathName,FilterIndex] = uiputfile(['ecog-',date,'.mat'],'Save isGood');
ecog=axesHandles.ecog;
try
    save([PathName,FileName],'ecog');
catch
    disp('Did not save.');
end

% --- Executes on button press in IV_on.
function MR_on_Callback(hObject, eventdata, handles)
% hObject    handle to IV_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function MR_beginning_Callback(hObject, eventdata, handles)
% hObject    handle to MR_beginning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MR_beginning as text
%        str2double(get(hObject,'String')) returns contents of MR_beginning as a double


% --- Executes during object creation, after setting all properties.
function MR_beginning_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MR_beginning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MR_end_Callback(hObject, eventdata, handles)
% hObject    handle to MR_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MR_end as text
%        str2double(get(hObject,'String')) returns contents of MR_end as a double


% --- Executes during object creation, after setting all properties.
function MR_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MR_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reject.
function reject_Callback(hObject, eventdata, handles)
% hObject    handle to reject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.MR_lines);
handles.MR_lines=[];
guidata(handles.controlFig,handles);
controlParams=updateControlParams(handles);
axesHandles=guidata(handles.axesFig);
axesParams=updateAxesParams(axesHandles);
sL=axesParams.start_location;
pI=axesParams.plot_interval;
if controlParams.MR_on==1
    axesHandles.ecog.isGood(:,controlParams.MR_beginning:controlParams.MR_end)=false(length(axesHandles.ecog.selectedChannels),controlParams.MR_end-controlParams.MR_beginning+1);
end
if controlParams.AT_on==1
    axesHandles.ecog.isGood = AR_AbnormalTrends_3(axesHandles.ecog.data,axesHandles.ecog.isGood,handles);
end
if controlParams.EV_on==1
    axesHandles.ecog.isGood(:,sL:(sL+pI))=AR_ExtremeValues(axesHandles.ecog.data(:,sL:(sL+pI)),axesHandles.ecog.isGood(:,sL:(sL+pI)),controlParams.EV_maxDeviation);
end
if controlParams.IV_on==1
    axesHandles.ecog.isGood(:,sL:(sL+pI))=AR_ImprobableValues(axesHandles.ecog.data(:,sL:(sL+pI)),axesHandles.ecog.isGood(:,sL:(sL+pI)),controlParams.IV_maxStdDev);
end
guidata(handles.axesFig,axesHandles);
AR_plotterRed(handles);




% --- Executes on button press in MR_unreject.
function MR_unreject_Callback(hObject, eventdata, handles)
% hObject    handle to MR_unreject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.MR_lines);
handles.MR_lines=[];
guidata(handles.controlFig,handles);
controlParams=updateControlParams(handles);
axesHandles=guidata(handles.axesFig);
axesHandles.ecog.isGood(:,controlParams.MR_beginning:controlParams.MR_end)=true(length(axesHandles.ecog.selectedChannels),controlParams.MR_end-controlParams.MR_beginning+1);
guidata(handles.axesFig,axesHandles);


% --- Executes on button press in MR_input.
function MR_input_Callback(hObject, eventdata, handles)
% hObject    handle to MR_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.MR_lines);
axesHandles=guidata(handles.axesFig);
axes(axesHandles.ecg_axes)
hold on
MR_beginning=ginput(1);
set(handles.MR_beginning,'String',num2str(MR_beginning(1)));
h1=plot(axesHandles.ecg_axes,[MR_beginning(1) MR_beginning(1)],get(axesHandles.ecg_axes,'YLim'),'r');
MR_end=ginput(1);
set(handles.MR_end,'String',num2str(MR_end(1)));
h2=plot(axesHandles.ecg_axes,[MR_end(1) MR_end(1)],get(axesHandles.ecg_axes,'YLim'),'m');
handles.MR_lines=[h1;h2];
guidata(handles.controlFig,handles);
hold off



% --- Executes on button press in unreject_page.
function unreject_page_Callback(hObject, eventdata, handles)
% hObject    handle to unreject_page (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.MR_lines);
handles.MR_lines=[];
guidata(handles.controlFig,handles);
controlParams=updateControlParams(handles);
axesHandles=guidata(handles.axesFig);
axesParams = updateAxesParams(axesHandles);
axesHandles.ecog.isGood(:,axesParams.start_location:axesParams.start_location+axesParams.plot_interval)=true(length(axesHandles.ecog.selectedChannels),axesParams.plot_interval+1);
guidata(handles.axesFig,axesHandles);
AR_plotterRed(handles)


function AR_plotterRed(handles)
% Who to blame: Nikolai Kalnin
axesHandles=guidata(handles.axesFig);
axesParams = updateAxesParams(axesHandles);
show=[axesParams.start_location,axesParams.start_location+axesParams.plot_interval];
axesHandles=guidata(handles.axesFig);
axes(axesHandles.ecg_axes);

AR_plotter(axesHandles.ecg_axes,axesHandles.ecog,show);

hold('on')
timeBase_sec=axesHandles.ecog.timebase/1000;
scaleFac=var(axesHandles.ecog.data(:,show(1):show(2)),0,2);
scaleVec=[1:length(axesHandles.ecog.selectedChannels)]'*max(scaleFac)*1/50; %The multiplier is arbitrary. Find a better solution
tmp=axesHandles.ecog.data(axesHandles.ecog.selectedChannels,show(1):show(2))+repmat(scaleVec,1,show(2)-show(1)+1);

x=timeBase_sec;

[badIndn,badIndm]=find(~axesHandles.ecog.isGood(:,show(1):show(2)));
%plot red points
plot(x(badIndm),tmp(badIndn+(badIndm-1)*length(axesHandles.ecog.selectedChannels)),'.r','markerSize',4);
hold('off');

