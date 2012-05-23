function varargout = analog_GUI(varargin)
% ANALOG_GUI M-file for analog_GUI.fig
%      ANALOG_GUI, by itself, creates a new ANALOG_GUI or raises the existing
%      singleton*.
%
%      H = ANALOG_GUI returns the handle to a new ANALOG_GUI or the handle to
%      the existing singleton*.
%
%      ANALOG_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALOG_GUI.M with the given input arguments.
%
%      ANALOG_GUI('Property','Value',...) creates a new ANALOG_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analog_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analog_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analog_GUI

% Last Modified by GUIDE v2.5 12-Apr-2011 15:14:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analog_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @analog_GUI_OutputFcn, ...
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


% --- Executes just before analog_GUI is made visible.
function analog_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analog_GUI (see VARARGIN)

% Choose default command line output for analog_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analog_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = analog_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inputFileLocation_Callback(hObject, eventdata, handles)
% PURPOSE: GET LOCATION OF DATA
% hObject    handle to inputFileLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputFileLocation as text
%        str2double(get(hObject,'String')) returns contents of inputFileLocation as a double
handles.pathName=get(hObject,'String');
[a,b,c]=fileparts(handles.pathName);
handles.blockName=b;
cd(handles.pathName);
handles.folderName=sprintf('%s_data',handles.blockName);
handles.stimuli=0;
guidata(hObject, handles);
fprintf('File opened: %s\n',handles.pathName);
fprintf('Block: %s',handles.blockName);



% --- Executes on selection change in selectAnalogCh.
function selectAnalogCh_Callback(hObject, eventdata, handles)
% hObject    handle to selectAnalogCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns selectAnalogCh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectAnalogCh

contents = get(hObject,'String');
handles.analogChNum =contents{get(hObject,'Value')};
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function selectAnalogCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectAnalogCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in convertAnalogtoWav.
function convertAnalogtoWav_Callback(hObject, eventdata, handles)
% hObject    handle to convertAnalogtoWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd('Analog')
[data,sampFreq] = readhtk ( sprintf('ANIN%s.htk',handles.analogChNum));
wavwrite((0.99*data/max(abs(data)))', sampFreq,sprintf('analog%s',handles.analogChNum));



guidata(hObject, handles);
fprintf('File converted to .wav file')

cd(handles.pathName);



% --- Executes on selection change in buttonPressAnalogCh.
function buttonPressAnalogCh_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPressAnalogCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns buttonPressAnalogCh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from buttonPressAnalogCh

handles.buttonPressChNum =get(hObject,'Value');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function buttonPressAnalogCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonPressAnalogCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in soundCardEventsAnalogCh.
function soundCardEventsAnalogCh_Callback(hObject, eventdata, handles)
% hObject    handle to soundCardEventsAnalogCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns soundCardEventsAnalogCh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from soundCardEventsAnalogCh

handles.soundCardChNum =get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function soundCardEventsAnalogCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soundCardEventsAnalogCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in getSoundEvents.
function getSoundEvents_Callback(hObject, eventdata, handles)
% hObject    handle to getSoundEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd('Analog')

handles=triggerDetectionSoundGUI3(handles,handles.stimuli)
guidata(hObject, handles);
cd(handles.pathName);


% --- Executes on button press in buttonPressEvents.
function buttonPressEvents_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPressEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd('Analog')
%cd('Epochs')
%handles=triggerDetectionButtonPressGUI_rat(handles)

handles=triggerDetectionButtonPressGUI3(handles)
guidata(hObject, handles);
cd(handles.pathName);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to inputFileLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputFileLocation as text
%        str2double(get(hObject,'String')) returns contents of inputFileLocation as a double


% --- Executes during object creation, after setting all properties.
function inputFileLocation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputFileLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectANcombine.
function selectANcombine_Callback(hObject, eventdata, handles)
% hObject    handle to selectANcombine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectANcombine contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectANcombine
handles.combineChannels =get(hObject,'Value');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function selectANcombine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectANcombine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in combineAN.
function combineAN_Callback(hObject, eventdata, handles)
% hObject    handle to combineAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd(sprintf('%s/Analog',handles.pathName))

for i=1:size(handles.combineChannels,2)
    files{i}=sprintf('transcript_AN%i.lab',handles.combineChannels(i));
end
    
    
if ~isfield(handles,'newLabels_input')
    makeCombinedEventFiles(files)
else
    makeCombinedEventFiles(files,eval(handles.newLabels_input));
end
cd(handles.pathName);

function newLabels_Callback(hObject, eventdata, handles)
% hObject    handle to newLabels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newLabels as text
%        str2double(get(hObject,'String')) returns contents of newLabels as a double

handles.newLabels_input =get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function newLabels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newLabels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard


% --- Executes on button press in stimuli.
function stimuli_Callback(hObject, eventdata, handles)
% hObject    handle to stimuli (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stimuli

handles.stimuli=get(hObject,'Value');
guidata(hObject, handles);

