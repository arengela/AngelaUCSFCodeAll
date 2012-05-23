function varargout = ArtifactRejection_axesGUI(varargin)
% ARTIFACTREJECTION_AXESGUI M-file for ArtifactRejection_axesGUI.fig
%      ARTIFACTREJECTION_AXESGUI, by itself, creates a new ARTIFACTREJECTION_AXESGUI or raises the existing
%      singleton*.
%
%      H = ARTIFACTREJECTION_AXESGUI returns the handle to a new ARTIFACTREJECTION_AXESGUI or the handle to
%      the existing singleton*.
%
%      ARTIFACTREJECTION_AXESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARTIFACTREJECTION_AXESGUI.M with the given input arguments.
%
%      ARTIFACTREJECTION_AXESGUI('Property','Value',...) creates a new ARTIFACTREJECTION_AXESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ArtifactRejection_axesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ArtifactRejection_axesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ArtifactRejection_axesGUI

% Last Modified by GUIDE v2.5 29-Jul-2009 12:10:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ArtifactRejection_axesGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ArtifactRejection_axesGUI_OutputFcn, ...
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


% --- Executes just before ArtifactRejection_axesGUI is made visible.
function ArtifactRejection_axesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ArtifactRejection_axesGUI (see VARARGIN)

% Choose default command line output for ArtifactRejection_axesGUI
handles.output = hObject;
handles.ecog=varargin{1};
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ArtifactRejection_axesGUI wait for user response (see UIRESUME)
% uiwait(handles.axesFig);


% --- Outputs from this function are returned to the command line.
function varargout = ArtifactRejection_axesGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in page_back.
function page_back_Callback(hObject, eventdata, handles)
% hObject    handle to page_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[axesParams]=updateAxesParams(handles);
s_l=axesParams.start_location;
p_i=axesParams.plot_interval;
if s_l - p_i < 1
    AR_plotter(handles.ecg_axes,handles.ecog,[1,1+p_i]);
    set(handles.start_location,'String','0');
else
    AR_plotter(handles.ecg_axes,handles.ecog,[s_l-p_i,s_l]);
    set(handles.start_location,'String',num2str((s_l - p_i)*handles.ecog.sampDur/1000));
end


% --- Executes on button press in scroll_back.
function scroll_back_Callback(hObject, eventdata, handles)
% hObject    handle to scroll_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[axesParams]=updateAxesParams(handles);
s_l=axesParams.start_location;
p_i=axesParams.plot_interval/3;
if s_l - round(p_i) < 1
    AR_plotter(handles.ecg_axes,handles.ecog,[1,1+round(p_i*3)]);
    set(handles.start_location,'String','0');
else
    AR_plotter(handles.ecg_axes,handles.ecog,[s_l-round(p_i),s_l+round(p_i*2/3)]);
    set(handles.start_location,'String',num2str((s_l - round(p_i))*handles.ecog.sampDur/1000));
end


function start_location_Callback(hObject, eventdata, handles)
% hObject    handle to start_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_location as text
%        str2double(get(hObject,'String')) returns contents of start_location as a double


% --- Executes during object creation, after setting all properties.
function start_location_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plot_interval_Callback(hObject, eventdata, handles)
% hObject    handle to plot_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plot_interval as text
%        str2double(get(hObject,'String')) returns contents of plot_interval as a double


% --- Executes during object creation, after setting all properties.
function plot_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in scroll_forward.
function scroll_forward_Callback(hObject, eventdata, handles)
% hObject    handle to scroll_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecog=handles.ecog;
[m,n]=size(ecog.data);
[axesParams]=updateAxesParams(handles);
s_l=axesParams.start_location;
p_i=axesParams.plot_interval/3;
if s_l + round(4*p_i) > n
    AR_plotter(handles.ecg_axes,handles.ecog,[n-round(p_i*3),n]);
    set(handles.start_location,'String',num2str((n-round(p_i*3))*handles.ecog.sampDur/1000));
else
    AR_plotter(handles.ecg_axes,handles.ecog,[s_l+round(p_i),s_l+round(4*p_i)]);
    set(handles.start_location,'String',num2str((s_l + round(p_i))*handles.ecog.sampDur/1000));
end

% --- Executes on button press in page_forward.
function page_forward_Callback(hObject, eventdata, handles)
% hObject    handle to page_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecog=handles.ecog;
[m,n]=size(ecog.data);
[axesParams]=updateAxesParams(handles);
s_l=axesParams.start_location;
p_i=axesParams.plot_interval;
if s_l + 2*p_i > n
    AR_plotter(handles.ecg_axes,handles.ecog,[n-p_i,n]);
    set(handles.start_location,'String',num2str((n-p_i)*handles.ecog.sampDur/1000));
else
    AR_plotter(handles.ecg_axes,handles.ecog,[s_l+p_i,s_l+2*p_i]);
    set(handles.start_location,'String',num2str((s_l + p_i)*handles.ecog.sampDur/1000));
end

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update(handles)


function AR_plotter(h,ecog,show)
%pH=ecogStackedTSPlot(ecog,trialNum) plot time series stacked in one column
%
% INPUT:
% ecog:     An ecog structure
% trialNum: The number of the trial to plot
%
% OUTPUT:
% pH:       An array of plot handles
%


% 090109 JR wrote it
% 090713 NK stole it

timeBase_sec=ecog.timebase/1000;
scaleFac=var(ecog.data(:,show(1):show(2)),0,2);
scaleVec=[1:length(ecog.selectedChannels)]'*max(scaleFac)*1/50; %The multiplier is arbitrary. Find a better solution
tmp=ecog.data(ecog.selectedChannels,show(1):show(2))+repmat(scaleVec,1,show(2)-show(1)+1);

%A line indicating zero for every channel
x=repmat([timeBase_sec(show(1));timeBase_sec(show(2))],1,length(scaleVec));
y=[scaleVec';scaleVec'];
plot(h,x,y,'color','k');

hold(h,'on');
c=get(h,'colororder');
set(h,'colororder',c(1:2,:));
x=timeBase_sec(show(1):show(2));
plot(h,x,tmp);
xlabel(h,'Time(Seconds)');
ylabel(h,'Mircovolts');
axis(h,'tight');
hold(h,'off');



function []=update(handles)
[axesParams]=updateAxesParams(handles);
s_l=axesParams.start_location;
p_i=axesParams.plot_interval;
AR_plotter(handles.ecg_axes,handles.ecog,[s_l,s_l+p_i]);



% --- Executes when axesFig is resized.
function axesFig_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to axesFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        fpos = get(handles.axesFig,'Position');
        set(handles.controlPanel,'Position',...
                [(fpos(3)/2-50) 0 100 3.85])
        set(handles.ecg_axes,'Position',...
          [13 7 fpos(3)*140/155 fpos(4)*32/40])
