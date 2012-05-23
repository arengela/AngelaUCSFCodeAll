function varargout = scrollspectrograms(varargin)
% SCROLLSPECTROGRAMS MATLAB code for scrollspectrograms.fig
%      SCROLLSPECTROGRAMS, by itself, creates a new SCROLLSPECTROGRAMS or raises the existing
%      singleton*.
%
%      H = SCROLLSPECTROGRAMS returns the handle to a new SCROLLSPECTROGRAMS or the handle to
%      the existing singleton*.
%
%      SCROLLSPECTROGRAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCROLLSPECTROGRAMS.M with the given input arguments.
%
%      SCROLLSPECTROGRAMS('Property','Value',...) creates a new SCROLLSPECTROGRAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scrollspectrograms_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scrollspectrograms_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scrollspectrograms

% Last Modified by GUIDE v2.5 10-Oct-2011 17:42:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scrollspectrograms_OpeningFcn, ...
                   'gui_OutputFcn',  @scrollspectrograms_OutputFcn, ...
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


% --- Executes just before scrollspectrograms is made visible.
function scrollspectrograms_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scrollspectrograms (see VARARGIN)

% Choose default command line output for scrollspectrograms
handles.output = hObject;
pathName='E:\PreprocessedFiles\EC15\EC15_B2';
flag=6;
input=1;

[a,b,c]=fileparts(pathName);
blockName=b;
cd(pathName)
fprintf('File opened: %s\n',pathName)
fprintf('Block: %s',blockName)

%%
%Set default Values
switch flag
    case 6
        sampFreq=1200;
    otherwise
        sampFreq=400;
end


freqRange=[70 150];

%%LOAD MATLAB VARIABLE
switch input
    case 1 %Human ecog (rawHTK)
        channelsTot=64;
        timeInt=[];
        ecog=loadHTKtoEcog_CT(sprintf('%s/%s',pathName,'RawHTK'),channelsTot,timeInt);
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);    
        ecogDS=downsampleEcog(ecog,sampFreq);

    case 2 %Downsampled ecog
        channelsTot=256;
        timeInt=[];
        ecog=loadHTKtoEcog_CT(sprintf('%s/%s',pathName,'ecogDS'),channelsTot,timeInt);
    case 3 %Rat ecog
        %channelsTot=96;
        channelsTot=128;
        timeInt=[];
        ecog=loadHTKtoEcog_rat_CT(sprintf('%s/%s',pathName,'RawHTK'),channelsTot,timeInt);
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
        ecog=downsampleEcog(ecog,400);
    
    otherwise
        channelsTot=256;
        timeInt=[];
        ecog=loadHTKtoEcog_CT(sprintf('%s/%s/%s','/data_store/raw/human/EC2',blockName,'RawHTK'),channelsTot,timeInt);
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);    
        ecog=downsampleEcog(ecog,400);
       
end

ecogDS.sampFreq=sampFreq;
badChannels=[];
badTimeSegments=[];
ecog.badChannels=[];
ecog.badTimeSegments=[];

handles.ecog=ecog;
handles.ecogDS=ecogDS;

handles.badChannels=badChannels;
handles.badTimeSegments=badTimeSegments;
handles.pathName=pathName;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scrollspectrograms wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scrollspectrograms_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%keyboard;

cur=get(hObject,'Value');
timeInt=2;
ch=46
%totTime=size(handles.ecog.data,2)/handles.ecog.sampFreq;

%startTime=cur*totTime;
%endTime=startTime+timeInt*handles.ecog.sampFreq;

totLength=size(handles.ecogDS.data,2)
startIdx=cur*totLength;
endIdx=startIdx+timeInt*handles.ecogDS.sampFreq;

d=handles.ecogDS.data(ch,startIdx:endIdx);

axes(handles.axes2)
plot(d);
axis tight
v5 = wav2aud(d,[10 200 -2 log2(round(handles.ecogDS.sampFreq)/16000)]);
axes(handles.axes1)

aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(round(handles.ecogDS.sampFreq)/16000)]);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
