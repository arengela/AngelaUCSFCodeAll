function varargout = scrollGridSpec(varargin)
% SCROLLGRIDSPEC MATLAB code for scrollGridSpec.fig
%      SCROLLGRIDSPEC, by itself, creates a new SCROLLGRIDSPEC or raises the existing
%      singleton*.
%
%      H = SCROLLGRIDSPEC returns the handle to a new SCROLLGRIDSPEC or the handle to
%      the existing singleton*.
%
%      SCROLLGRIDSPEC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCROLLGRIDSPEC.M with the given input arguments.
%
%      SCROLLGRIDSPEC('Property','Value',...) creates a new SCROLLGRIDSPEC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scrollGridSpec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scrollGridSpec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scrollGridSpec

% Last Modified by GUIDE v2.5 11-Oct-2011 17:34:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scrollGridSpec_OpeningFcn, ...
                   'gui_OutputFcn',  @scrollGridSpec_OutputFcn, ...
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


% --- Executes just before scrollGridSpec is made visible.
function scrollGridSpec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scrollGridSpec (see VARARGIN)

% Choose default command line output for scrollGridSpec
handles.output = hObject;

figure(1)
% Update handles structure
guidata(hObject, handles);
% Update handles structure

% UIWAIT makes scrollGridSpec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scrollGridSpec_OutputFcn(hObject, eventdata, handles) 
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
cur=get(hObject,'Value');
timeInt=3;

totLength=size(handles.ecogDS.data,2)
startIdx=cur*totLength;
endIdx=startIdx+timeInt*handles.ecogDS.sampFreq;
d=handles.ecogDS.data(1,startIdx:endIdx);
v5 = wav2aud(d,[10 200 -2 log2(round(handles.ecogDS.sampFreq)/16000)]);

gridspec=zeros(size(v5,1)*8,size(v5,2)*8)';
%figure
c=1;
HW=hanning(200);
for i=1:16
    for k=1:16
        d=handles.ecogDS.data((i-1)*k+k,startIdx:endIdx);
        d(end-100:end)=HW(100:200)'.*d(end-100:end);
        d(1:100)=HW(1:100)'.*d(1:100);
        
        v5 = wav2aud(d,[10 200 -2 log2(round(handles.ecogDS.sampFreq)/16000)]);
        v5=mapstd(v5'.^.5)';
        v5(find(v5<0))=0;
        v5=v5/max(v5(:));
        
        r=i*size(v5,1)-size(v5,1)+1;
        col=k*size(v5,2)-size(v5,2)+1;
        gridspec(col:col+size(v5,2)-1,r:r+size(v5,1)-1)=flipud(v5');
        %{
        set(0,'CurrentFigure',1);

        subplot(8,8,c)
        plot(d)
        c=c+1;
        %}
    end
end
%{
set(0,'CurrentFigure',1);
c=1;
for i=1:8
    for k=1:8
        d=handles.ecogDS.data((i-1)*k+k,startIdx:endIdx);
        v5 = wav2aud(d,[10 200 -2 log2(round(handles.ecogDS.sampFreq)/16000)]);
        subplot(8,8,c)
        aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(round(handles.ecogDS.sampFreq)/16000)]);
        hold on
        plot(d/(max(d)/300),'w')
        c=c+1;
        
       
    end
end
%}



    axes(handles.axes1)
    mm=max(gridspec(:));
    imagesc(gridspec,[0 mm]);
    %aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(round(handles.ecogDS.sampFreq)/16000)]);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

pathName=get(hObject,'String');
% Update handles structure
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
        channelsTot=256;
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

try
    cd(sprintf('%s/Artifacts',pathName))
    load 'badTimeSegments.mat'
    fid = fopen('badChannels.txt');
    tmp = fscanf(fid, '%d');
    handles.badChannels=tmp';
    fclose(fid);
    cd(pathName)
catch
    handles.badChannels=[];
    badTimeSegments=[];
    cd(pathName)
end
ignoreChans=[handles.badChannels];
usechans= setdiff(1:size(ecogDS.data,1),ignoreChans);
ecogDS.data=detrend(ecogDS.data','constant')';
CAR=[];
CAR=[CAR;repmat(mean(ecogDS.data(usechans,:),1),size(ecogDS.data,1),1)];


handles.ecog=ecog;
handles.ecogDS.data=ecogDS.data-CAR;
handles.ecogDS.sampFreq=1200;

handles.badChannels=badChannels;
handles.badTimeSegments=badTimeSegments;
handles.pathName=pathName;
guidata(hObject, handles);


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


% --- Executes on key press with focus on axesFig or any of its controls.
function axesFig_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to axesFig (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
try
    switch eventdata.Key
      case 'rightarrow'
       page_forward_Callback(hObject, eventdata, handles)
      case 'leftarrow'
          page_back_Callback(hObject, eventdata, handles)
          
      case 'uparrow'
        channelScrollUp_Callback(hObject, eventdata, handles)
      case 'downarrow'
        channelScrollDown_Callback(hObject, eventdata, handles)
        
    end
catch
    axesFig_WindowScrollWheelFcn(hObject, eventdata, handles)

end



% --- Executes on scroll wheel click while the figure is in focus.
function axesFig_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to axesFig (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
if eventdata.VerticalScrollCount==1
    edit1_CreateFcn(hObject, eventdata, handles)
elseif eventdata.VerticalScrollCount==-1
    edit1_CreateFcn(hObject, eventdata, handles)
end
