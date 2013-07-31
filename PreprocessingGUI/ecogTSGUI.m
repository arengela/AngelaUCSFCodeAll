function varargout= ecogTSGUI(varargin)
% ecogTSGUI M-file for ecogTSGUI.fig
%      ecogTSGUI, by itself, creates a new ecogTSGUI or raises the existing
%      singleton*.
%
%      H = ecogTSGUI returns the handle to a new ecogTSGUI or the handle to
%      the existing singleton*.
%
%      ecogTSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ecogTSGUI.M with the given input arguments.
%
%      ecogTSGUI('Property','Value',...) creates a new ecogTSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ecogTSGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ecogTSGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ecogTSGUI

% Last Modified by GUIDE v2.5 17-Jan-2013 11:39:01

% Begin initialization code - DO NOT EDIT

%global BAD_INTERVALS

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ecogTSGUI_OpeningFcn, ...
    'gui_OutputFcn',  @ecogTSGUI_OutputFcn, ...
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Figure Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before ecogTSGUI is made visible.
function ecogTSGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ecogTSGUI (see VARARGIN)

% Choose default command line output for ecogTSGUI

handles.output = hObject;
handles.ecog=varargin{1};
handles.badIntervals=handles.ecog.badIntervals;
% Make sure that channel selection is populated first
set(handles.channelSelector,'String',num2str(handles.ecog.selectedChannels)) %number of channels selected
set(handles.editVerticalScale,'String','128');
%set(handles.nChannelsDisplayed,'String',num2str(length(handles.ecog.selectedChannels))) %number of channels simultaneously displayed

set(handles.channelScrollDown,'UserData',[1:str2double(get(handles.nChannelsDisplayed,'String'))]); %number of channels simultaneously displayed
set(handles.axesFig,'CloseRequestFcn',@closeFigure_Callback);


%%%%DUMMY EVENTS%%%%%%

handles.eventmarkers(1).time = 5;
handles.eventmarkers(2).time = 10;
handles.eventmarkers(3).time = 15;

handles.eventmarkers(1).name = 'A';
handles.eventmarkers(2).name = 'A';
handles.eventmarkers(3).name = 'B';

handles.eventmarkers(1).condition = 1;
handles.eventmarkers(2).condition = 2;
handles.eventmarkers(3).condition = 1;

%%%%%%%%%%%%%%%

% Draw Timeline
axes(handles.timeline_axes)
total_dur = length(handles.ecog.data)/handles.ecog.sampFreq;
line([0 total_dur],[.5 .5],'Color','k');

%plot events
if isfield(handles,'eventmarkers')
    handles.colorvec = [1 .7 0; 1 0 1; 0 1 1; 1 .41 .7]; %orange, magenta, cyan, hot pink
    events = handles.eventmarkers;
    for i=1:length(events)
        condition = events(i).condition;
        c = handles.colorvec(condition,:);
        x = events(i).time;
        line('XData',[x x],'YData',[0 1],'Color',c);
    end
end

%plot current rect
handles.current_rect = patch([0 0 0 0],[0 1 1 0],'g','FaceAlpha',.5);
axis tight
axis off


refreshScreen(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ecogTSGUI wait for user response (see UIRESUME)
uiwait(handles.axesFig);


% --- Outputs from this function are returned to the command line.
function varargout = ecogTSGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;
varargout{2} = handles.badIntervals;
close force
%delete(hObject)
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Channel Selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in channelSelector.
function channelSelector_Callback(hObject, eventdata, handles)
% hObject    handle to channelSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp=get(handles.channelSelector,'String');

if evalin('base',['exist(''' tmp ''',''var'')']) %check for variable in base workspace
    chanNums=evalin('base',tmp);
    if isempty(chanNums)
        display([tmp ' is empty! Channels not updated.'])
        return
    end
else
    try % check for an expression that can be expanded into numbers
        chanNums=eval(tmp);
        chanNums=checkValidChannelNumbers(chanNums,handles);
    catch
        display ('Not a valid matlab expression. Selected channel list unchanged.')
        return
    end
end
handles.ecog.selectedChannels=chanNums; %will not transfer to workspaces outside this function
set(handles.channelSelector,'String',num2str(handles.ecog.selectedChannels));
set(handles.channelSelector,'Userdata',num2str(handles.ecog.selectedChannels));

%check if the size of channel block to be siaplayed is compatible
if str2double(get(handles.nChannelsDisplayed,'String')) >length(chanNums)
    set(handles.nChannelsDisplayed,'String', num2str(length(chanNums)));
end
%set the actually displayed list of channels
set(handles.channelScrollDown,'UserData',[1:str2num(get(handles.nChannelsDisplayed,'String'))]); %number of channels simultaneously displayed
refreshScreen(hObject, eventdata, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns channelSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channelSelector


function nChannelsDisplayed_Callback(hObject, eventdata, handles)
% hObject    handle to nChannelsDisplayed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This is the block size of the index list in the channel selector array of
% channels
% the scroll down buttons will hold the exact indices in that block in UserData

nChanToShow=str2double(get(hObject,'String'));
nChanToShow=nChanToShow(1); %make sure we have a scalar
% make we have sure indices will be in a valid range
chanToShow=str2num(get(handles.channelSelector,'String'));
if nChanToShow<1
    nChanToShow=1;
elseif nChanToShow > length(chanToShow)
    nChanToShow=length(chanToShow);
end
set(hObject,'String',num2str(nChanToShow)); % the number of channels to show, if necessary corrected
set(handles.channelScrollDown,'userData',[1:nChanToShow]); % Always start with the first block of channels if the number of channels has changed
refreshScreen(hObject, eventdata, handles);


% --- Executes on button press in channelScrollDown.
function channelScrollDown_Callback(hObject, eventdata, handles)
% hObject    handle to channelScrollDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
blockIndices=get(handles.channelScrollDown,'userData');
nChanToShow=str2double(get(handles.nChannelsDisplayed,'String'));
blockIndices=blockIndices-nChanToShow;
if blockIndices(1)<=1
    blockIndices=1:nChanToShow; %first possible block
end
set(handles.channelScrollDown,'userData',blockIndices);
refreshScreen(hObject, eventdata, handles);


% --- Executes on button press in channelScrollUp.
function channelScrollUp_Callback(hObject, eventdata, handles)
% hObject    handle to channelScrollUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
blockIndices=get(handles.channelScrollDown,'userData');
nChanToShow=str2double(get(handles.nChannelsDisplayed,'String'));
chanToShow=str2num(get(handles.channelSelector,'String'));
blockIndices=blockIndices+nChanToShow;
if blockIndices(end)>length(chanToShow)
    blockIndices=length(chanToShow)-length(blockIndices)+1:length(chanToShow); %last possible block
end
set(handles.channelScrollDown,'userData',blockIndices);
refreshScreen(hObject, eventdata, handles);


function chanNums=checkValidChannelNumbers(chanNums,handles)
if any(chanNums<1) || any(chanNums>size(handles.ecog.data,2))
    display(['Removed channels out of valid range from list. Valid: 1:' num2str(size(handles.ecog.data,2))])
    chanNums(find(chanNums<1))=[];
    chanNums(find(chanNums>size(handles.ecog.data,2)))=[];
end


% --- Executes during object creation, after setting all properties.
function channelSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function nChannelsDisplayed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nChannelsDisplayed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function start_location_Callback(hObject, eventdata, handles)
%NO CALLBACK REQUIRED. ITS TEXT
% hObject    handle to start_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[axesParams]=getCurXAxisPosition(hObject, eventdata, handles);
%interval at least one sample long
if axesParams.intervalStartSamples < handles.ecog.sampDur; %too eraly
    axesParams.intervalStartSamples=1; %set to the first sample
    setXAxisPositionSamples(hObject, eventdata, handles,axesParams);
end

if axesParams.intervalStartSamples+axesParams.intervalLengthSamples-1 > size(handles.ecog.data,2) %too late
    axesParams.intervalStartSamples=size(handles.ecog.data,2)-axesParams.intervalLengthSamples+1;
    setXAxisPositionSamples(hObject, eventdata, handles,axesParams);
end
refreshScreen(hObject, eventdata, handles);


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
%NO CALLBACK REQUIRED. ITS TEXT
% hObject    handle to plot_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotIntervalGuiUnits=str2double(get(hObject,'String'));
%interval at least one sample long
if plotIntervalGuiUnits*1000 < handles.ecog.sampDur
    plotIntervalGuiUnits=handles.ecog.sampDur/1000;
    set(hObject,'String',num2str(plotIntervalGuiUnits));
    % if interval is longer than avaiable data
elseif plotIntervalGuiUnits*1000/handles.ecog.sampDur > size(handles.ecog.data,2)
    plotIntervalGuiUnits=(size(handles.ecog.data,2)-1)*handles.ecog.sampDur/1000;
    set(hObject,'String',num2str(plotIntervalGuiUnits));
end
refreshScreen(hObject, eventdata, handles);


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

% --- Executes on button press in page_back.
function page_back_Callback(hObject, eventdata, handles)
[m,n]=size(handles.ecog.data);
[axesParams]=getCurXAxisPosition(hObject, eventdata, handles);
%new interval start
axesParams.intervalStartSamples=axesParams.intervalStartSamples-axesParams.intervalLengthSamples;
% if the last sample of the new interval is beyond is the available data
% set start such that intserval is in a valid range
if axesParams.intervalStartSamples < 1;
    axesParams.intervalStartSamples=1;
end
setXAxisPositionSamples(hObject, eventdata, handles,axesParams);
refreshScreen(hObject, eventdata, handles);


% --- Executes on button press in scroll_back.
function scroll_back_Callback(hObject, eventdata, handles)
[m,n]=size(handles.ecog.data);
[axesParams]=getCurXAxisPosition(hObject, eventdata, handles);
%new interval start
axesParams.intervalStartSamples=axesParams.intervalStartSamples-axesParams.intervalLengthSamples/3;
% if the last sample of the new interval is beyond is the available data
% set start such that intserval is in a valid range
if axesParams.intervalStartSamples < 1;
    axesParams.intervalStartSamples=1;
end
setXAxisPositionSamples(hObject, eventdata, handles,axesParams);
refreshScreen(hObject, eventdata, handles);


% --- Executes on button press in scroll_forward.
function scroll_forward_Callback(hObject, eventdata, handles)
% hObject    handle to scroll_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[m,n]=size(handles.ecog.data);
[axesParams]=getCurXAxisPosition(hObject, eventdata, handles);
% check if inteval length is appropriate
if axesParams.intervalLengthSamples>n
    % set interval length to available data
    axesParams.intervalLengthSamples=n;
end
%new interval start
axesParams.intervalStartSamples=axesParams.intervalStartSamples+axesParams.intervalLengthSamples/3;
% if the last sample of the new interval is beyond is the available data
% set start such that intserval is in a valid range
if axesParams.intervalStartSamples+axesParams.intervalLengthSamples > n
    axesParams.intervalStartSamples=n-axesParams.intervalLengthSamples+1;
end
setXAxisPositionSamples(hObject, eventdata, handles,axesParams);
refreshScreen(hObject, eventdata, handles);


% --- Executes on button press in page_forward.
function page_forward_Callback(hObject, eventdata, handles)
% hObject    handle to scroll_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[m,n]=size(handles.ecog.data);
[axesParams]=getCurXAxisPosition(hObject, eventdata, handles);
% check if inteval length is appropriate
if axesParams.intervalLengthSamples>n
    % set interval length to available data
    axesParams.intervalLengthSamples=n;
end
%new interval start
axesParams.intervalStartSamples=axesParams.intervalStartSamples+axesParams.intervalLengthSamples;
% if the last sample of the new interval is beyond is the available data
% set start such that intserval is in a valid range
if axesParams.intervalStartSamples+axesParams.intervalLengthSamples > n
    axesParams.intervalStartSamples=n-axesParams.intervalLengthSamples+1;
end
setXAxisPositionSamples(hObject, eventdata, handles,axesParams);
refreshScreen(hObject, eventdata, handles);

% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update(handles)



% --- Executes when axesFig is resized.
function axesFig_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to axesFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fpos = get(handles.axesFig,'Position');

set(handles.controlPanel,'Position',...
    [(fpos(3)/2) 1 (fpos(3)/2)-10  3.85])
set(handles.ecg_axes,'Position',...
    [13 7 fpos(3)*140/155 fpos(4)*32/40])
set(handles.uipanel4,'Units','characters','Position',[10 1 80  5])



function editVerticalScale_Callback(hObject, eventdata, handles)
%NO CALLBACK REQUIRED. ITS TEXT
% hObject    handle to editVerticalScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVerticalScale as text
%        str2double(get(hObject,'String')) returns contents of editVerticalScale as a double



% --- Executes during object creation, after setting all properties.
function editVerticalScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVerticalScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in verticalScaleDecrease.
function verticalScaleDecrease_Callback(hObject, eventdata, handles)
% hObject    handle to verticalScaleDecrease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scaleFac=str2double(get(handles.editVerticalScale,'String'));
set(handles.editVerticalScale,'String',num2str(scaleFac/2));
refreshScreen(hObject, eventdata, handles)

% --- Executes on button press in verticalScaleIncrease.
function verticalScaleIncrease_Callback(hObject, eventdata, handles)
% hObject    handle to verticalScaleIncrease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scaleFac=str2double(get(handles.editVerticalScale,'String'));
set(handles.editVerticalScale,'String',num2str(scaleFac*2));
refreshScreen(hObject, eventdata, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [axesParams]=getCurAxisParameters(hObject, eventdata, handles);
% PURPOSE:
% Get all axes parameters defining the appearance of the plot
% INPUT:
% hObject:  handle to the object calling this function
% eventdata:Mtalab reserved GUI parameter, Not in use yet.
% handles:  A structure of handles to the GUI elements
% OUTPUT:
% axesParamsStructure with fields:
% axesParams.intervalStartGuiUnits
% axesParams.intervalLengthGuiUnits
% axesParams.intervalStartSamples
% axesParams.intervalLengthSamples
% axesParams.verticalScaleFactor
% the conversion from GUI units to samples is done by multiplying GUI units
% with handles.ecog.sampDur

[axesParams]=getCurXAxisPosition(hObject, eventdata, handles);
axesParams.verticalScaleFactor=str2double(get(handles.editVerticalScale,'String'));


function [axesParams]=getCurXAxisPosition(hObject, eventdata, handles)
% PURPOSE:
% Get the parameters defining the x-axis location currently on display
% INPUT:
% hObject:  handle to the object calling this function
% eventdata:Mtalab reserved GUI parameter, Not in use yet.
% handles:  A structure of handles to the GUI elements
% OUTPUT:
% axesParamsStructure with fields:
% axesParams.intervalStartGuiUnits
% axesParams.intervalLengthGuiUnits
% axesParams.intervalStartSamples:  The first sample in the current interval
% axesParams.intervalEndSamples:    The last sample in the current interval
% axesParams.intervalLengthSamples
% the conversion from GUI units to samples is done by multiplying GUI units
% with handles.ecog.sampDur

axesParams.intervalStartGuiUnits=str2double(get(handles.start_location,'String'));
axesParams.intervalLengthGuiUnits=str2double(get(handles.plot_interval,'String'));
axesParams.intervalLengthSamples=axesParams.intervalLengthGuiUnits*(1000/handles.ecog.sampDur);
axesParams.intervalStartSamples=axesParams.intervalStartGuiUnits*(1000/handles.ecog.sampDur); % assumes seconds in GUI and milliseconds in  ecog.sampDur
axesParams.intervalEndSamples=axesParams.intervalStartSamples+axesParams.intervalLengthSamples-1; %We assume that the intervall length is specified in samples
axesParams.selectedChannels=str2num(get(handles.channelSelector,'String')); %should always work because plausibility has been checked when channels were entered (
axesParams.indexToSelectedChannels=get(handles.channelScrollDown,'userData');
%axesParams.intervalTimebaseGUIUnits=axesParams.intervalStartSamples:axesParams.intervalEndSamples]/(1000/handles.ecog.sampDur);
return;

function setXAxisPositionSamples(hObject, eventdata, handles,axesParams)
% PURPOSE:
% Set the parameters defining the x-axis location currently on display
% from the samples fields in axesParams
% INPUT:
% hObject:  handle to the object calling this function
% eventdata:Mtalab reserved GUI parameter, Not in use yet.
% handles:  A structure of handles to the GUI elements
% axesParams: Structure with fields:
% axesParams.intervalStartSamples
% axesParams.intervalLengthSamples
% the conversion from samples to GUI units to is done by dividing samples
% by handles.ecog.sampDur

%set the parameters defining the x-axis location currently on display
set(handles.start_location,'String',num2str(axesParams.intervalStartSamples/(1000/handles.ecog.sampDur)));  % assumes seconds in GUI and milliseconds in  ecog.sampDur
set(handles.plot_interval,'String',num2str(axesParams.intervalLengthSamples/(1000/handles.ecog.sampDur)));


function refreshScreen(hObject, eventdata, handles)
% PURPOSE: force a refresh of the plot
AR_plotter(hObject, eventdata, handles)

% ecog=handles.ecog;
% [m,n]=size(ecog.data);
% [axesParams]=updateAxesParams(handles);
% s_l=axesParams.start_location;
% p_i=axesParams.plot_interval/3;
% AR_plotter(handles.ecg_axes,handles.ecog,[axesParams.start_location,axesParams.plot_interval]);

function AR_plotter(hObject, eventdata, handles)
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
% 100717 JR modified it for compliance with new data structures and calling
% convention


[axesParams]=getCurAxisParameters(hObject, eventdata, handles);
startSamp=ceil(axesParams.intervalStartSamples);
endSamp=floor(axesParams.intervalEndSamples);
channelsToShow=axesParams.selectedChannels(axesParams.indexToSelectedChannels);
scaleFac=var(handles.ecog.data(:,1:endSamp-startSamp),0,2)/axesParams.verticalScaleFactor; %We use on fixed interval for the scaling factor to keep things comparable
scaleVec = [1:length(channelsToShow)]'*max(scaleFac)*1/50; %The multiplier is arbitrary. Find a better solution
timebaseGuiUnits=[startSamp:endSamp]'*(axesParams.intervalStartGuiUnits/axesParams.intervalStartSamples);
plotData=handles.ecog.data(channelsToShow,startSamp:endSamp)+repmat(scaleVec,1,endSamp-startSamp+1); %data + offset

axes(handles.timeline_axes)

hold on
x = str2double(get(handles.start_location,'String'));
w = str2double(get(handles.plot_interval,'String'));
set(handles.current_rect,'XData',[x,x,x+w,x+w]);
    

axes(handles.ecg_axes)

%bad_t=handles.ecog.bad_t;
%A line indicating zero for every channel
x=repmat([timebaseGuiUnits(1) timebaseGuiUnits(end)]',1,length(scaleVec));
y=[scaleVec';scaleVec'];
plot(handles.ecg_axes,x,y,'color','k');

hold(handles.ecg_axes,'on');
c=get(handles.ecg_axes,'colororder');
set(handles.ecg_axes,'colororder',c(1:2,:));
xlabel(handles.ecg_axes,'Time(Seconds)');
ylabel(handles.ecg_axes,'Channel #');
set(handles.ecg_axes,'ytick',y(1,:),'yticklabel',strvcat(num2str(channelsToShow')));



%{
idx=zeros(32,2000);
for i=1:size(plotData,1)
    idx=find(bad_t(i,1:size(plotData,2))>0);
    plot(timebaseGuiUnits(idx),plotData(i,idx'),'.r')
end
%}



badch=find(ismember(channelsToShow,handles.ecog.badChannels));
if ~isempty(badch)
    if ~length(find(handles.ecog.badChannels==999))
        ph=plot(handles.ecg_axes,timebaseGuiUnits,plotData);
        plot(handles.ecg_axes,timebaseGuiUnits,plotData(badch,:),'r');
    else
        plotData(badch,:)=NaN;
        ph=plot(handles.ecg_axes,timebaseGuiUnits,plotData);
        
    end
    
else
    %PLOT CHANNELS
    ph=plot(handles.ecg_axes,timebaseGuiUnits,plotData);
end

%MAKE TRANSPARENT BOX AROUND BAD TIME SEGMENTS

handles.plotData=[];
handles.plotData=plotData;
handles.showChan=channelsToShow;

axis(handles.ecg_axes,'tight');

yl = ylim;
ymin = yl(1);
ymax = yl(2);

% plot segment rectangles
for i=1:size(handles.badIntervals,1)
    BI = handles.badIntervals(i,:);
    h=patch([BI(1),BI(1),BI(2),BI(2)],[ymin, ymax, ymax, ymin],'y');
    set(h,'FaceAlpha',.2,'EdgeColor','none')
    text(BI(1),ymin,num2str(BI(1)),'Color','r');
    text(BI(2),ymin,num2str(BI(2)),'Color','r');
    
    x =ymin;
    y = 0;
    w = ymax;
    h = 1;
    

   handles.BIRects(i) = rectangle('Position',[x,y,w,h],'FaceColor','r');
end

% PLOT EVENTS
if isfield(handles,'eventmarkers')
    events = handles.eventmarkers;
    for i=1:length(events)
        condition = events(i).condition;
        c = handles.colorvec(condition,:);
        x = events(i).time;
        line('XData',[x x],'YData',[ymin ymax],'LineStyle','--','Color',c);
        text(x,ymin,events(i).name,'Color',c);
    end
end

hold(handles.ecg_axes,'off');
guidata(hObject, handles);


function []=update(handles)
[axesParams]=updateAxesParams(handles);
s_l=axesParams.start_location;
p_i=axesParams.plot_interval;
AR_plotter(handles.ecg_axes,handles.ecog,[s_l,s_l+p_i]);


% --- Executes during object creation, after setting all properties.
function ecg_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecg_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ecg_axes


% --- Executes on button press in pushbutton10.
function BadInterval=pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RECT=getrect;

BadInterval=[RECT(1) RECT(1)+RECT(3)];
BadInterval(1,5) = 0;
%make red rect on timeline
axes(handles.timeline_axes);
x = RECT(1);
y = 0;
w = RECT(3);
h = 1;
if isfield(handles,'BIRects')
    handles.BIRects(end+1) = rectangle('Position',[x,y,w,h],'FaceColor','r');
else
    handles.BIRects = rectangle('Position',[x,y,w,h],'FaceColor','r');
end


%BadInterval(1,5) = handles.showChan;
yLimits=get(gca,'YLim');
ymax=yLimits(2);
ymin=yLimits(1);




h=patch([BadInterval(1,1),BadInterval(1,1),BadInterval(1,2),BadInterval(1,2)],[ymin, ymax, ymax, ymin],'y');
set(h,'FaceAlpha',.5);
set(h,'EdgeColor','none');
handles.badIntervals=[handles.badIntervals; BadInterval];
b=handles.badIntervals;
%assignin('base','badIntervals',b)
refreshScreen(hObject, eventdata, handles);
guidata(hObject, handles);



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


% --- Executes on key press with focus on axesFig and none of its controls.
function axesFig_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to axesFig (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on scroll wheel click while the figure is in focus.
function axesFig_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to axesFig (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
if eventdata.VerticalScrollCount==1
    channelScrollDown_Callback(hObject, eventdata, handles)
elseif eventdata.VerticalScrollCount==-1
    channelScrollUp_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in datacursoron.
function datacursoron_Callback(hObject, eventdata, handles)
% hObject    handle to datacursoron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%datacursormode on;
datacursormode toggle
if strcmp('Data Cursor On',get(handles.datacursoron,'String'))
    set(handles.datacursoron,'String','Data Cursor Off')
else
    set(handles.datacursoron,'String','Data Cursor On')
end


% --- Executes on button press in getch.
function getch_Callback(hObject, eventdata, handles)
% hObject    handle to getch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dcm_obj = datacursormode(gcf);
inf=getCursorInfo(dcm_obj);
idx=find(handles.plotData(:,inf.DataIndex)==inf.Position(2));
ch=handles.showChan(idx);
title(['Selected Channel: ' num2str(ch)])
datacursormode off


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%global BAD_INTERVALS
BAD_INTERVALS=handles.badIntervals;
if isempty(BAD_INTERVALS)
    display('No bad intervals selected')
    beep;
    return;
end
cd('Artifacts')
BadTimesConverterGUI(BAD_INTERVALS,'bad_time_segments.lab')
badTimeSegments=BAD_INTERVALS;
save('badTimeSegments','badTimeSegments')
fprintf('%d Bad time segments saved\n',size(badTimeSegments,1));
cd ..




% --- Executes on button press in deleteInterval.
function deleteInterval_Callback(hObject, eventdata, handles)
% hObject    handle to deleteInterval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.deleteInterval,'String','Select Interval');
x = getrect(handles.ecg_axes);
x = x(1);
BIs = handles.badIntervals;
di = x >= BIs(:,1) & x <= BIs(:,2); %badInterval selected
%delete(handles.BIRects(di)); %remove red rect on timeline

try
    handles.BIRects(di) = []; %delete handle of red rect
end
handles.badIntervals(di,:) = [];

set(handles.deleteInterval,'String','Delete Interval');

refreshScreen(hObject, eventdata, handles);

guidata(hObject, handles);


% --- Executes on button press in closeFigure.
function closeFigure_Callback(hObject, eventdata, handles)
% hObject    handle to closeFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close force %Added by Ben as a hack to fix error where figure does not close
uiresume
%close force

% function scaleFac = getScaleFac(handles,channelsToShow,startSamp,endSamp)
% %Finds the greatest scale factor such that the scale factor of each channel
% % is equal and nonoverlapping with other bands.
%
% ecog = handles.ecog.data(channelsToShow,startSamp:endSamp);
%
% ecogmax = max(ecog,[],2);
% ecogmin = min(ecog,[],2);
% ecogmin(1) = [];
% ecogmin(end+1) = 0;
% gap = ecogmax - ecogmin;
% scaleFac = 200/max(gap);


