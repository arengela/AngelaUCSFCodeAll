function varargout = Preprocessing_GUI(varargin)
%{
PURPOSE: THIS GUI DOES INITIAL PREPROCESSING. VISUALIZES DATA IN IN TIME
AND FREQUENCY DOMAINS TO DETERMINE DATA QUALITY, BAD CHANNELS, AND
ARTIFACTS. THE FINAL OUTPUT ARE BAD CHANNEL AND BAD TIME SEGMENT FILES HELD
IN "ARTIFACTS" DIRECTORY.

STEPS INCLUDE:
-LOADING RAW FILES AND DOWNSAMPLING
-SCROLL THROUGH ECOG DATA
-MARK BAD TIME SEGMENTS AND BAD CHANNELS
-LOOK AT PERIODOGRAM, SPECTROGRAM, AND STANDARD DEVIATION BEFORE COMMON
AVERAGE REFERENCE
-SUBTRACT COMMON AVERAGE REFERENCE
-LOOK AT PERIODOGRAM, SPECTROGRAM, AND STANDARD DEVIATION BEFORE COMMON
AVERAGE REFERENCE AFTER CAR TO SEE IF QUALITY IMPROVES

WHEN DONE, RUN SEPARATE PREPROCESSING SCRIPT TO CALCULATE AND SAVE HILBERT
TRANSFORM.
%}
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Preprocessing_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @Preprocessing_GUI_OutputFcn, ...
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

% --- Executes just before Preprocessing_GUI is made visible.
function Preprocessing_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
if length(varargin)>=1
    if ~isempty(varargin{1})
        set(handles.datatype,'Value',1);
        set(handles.inputFileLocation,'String',varargin{1})
        if length(varargin)>=2
            set(handles.datatype,'Value',varargin{2})        
        end

        inputFileLocation_Callback(handles.output, eventdata, handles)

        handles=guidata(handles.output);
        
        
        loadBadTimeSegments_Callback(handles.output, eventdata, guidata(handles.output))
        
        loadBadCh_Callback(handles.output, handles.inputFileLocation, guidata(handles.output))
        spectrogramAllChan_DS_Callback(handles.output, eventdata, guidata(handles.output))
        std_dev_Callback(handles.output, eventdata, guidata(handles.output))
        allPeriodograms_Callback(handles.output, eventdata, guidata(handles.output))
        
        handles=guidata(handles.output);
    end
end




if length(varargin)>=3
    handles.type=varargin{2};
end

%guidata(handles.output,x);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Preprocessing_GUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function inputFileLocation_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function inputFileLocation_Callback(hObject, eventdata, handles)
% PURPOSE: GET LOCATION OF DATA
handles.pathName=get(handles.inputFileLocation,'String');
[~,s,b]=fileparts(handles.pathName);
handles.blockName=b;
cd(handles.pathName);

if isempty(strmatch('Artifacts',ls))
    mkdir('Artifacts')
end

cd('Artifacts')
if isempty(strmatch('badTimeSegments',ls)) & isempty(strmatch('badChannels',ls))
    badTimeSegments=[];
    save('badTimeSegments','badTimeSegments')
    BadTimesConverterGUI(badTimeSegments,'bad_time_segments.lab');
    fid = fopen('badChannels.txt', 'w');
    fprintf(fid, '%6.0f', []);
    handles.badChannel=fid
    fclose(fid);
    handles.badChannels=[];
    handles.suspiciousChannels=[];
    handles.badTimeSegments=[];

else
    load 'badTimeSegments.mat';
    handles.badTimeSegments=badTimeSegments;
    guidata(hObject, handles);
    fprintf('%d bad time segments loaded\n',size(handles.badTimeSegments,1));

    fid = fopen('badChannels.txt');
    tmp = fscanf(fid, '%d');
    handles.badChannels=tmp';
    fclose(fid);
    set(handles.inputBadChannels,'String',int2str(handles.badChannels));
    fprintf('Bad Channels: %s',int2str(handles.badChannels));
    cd(handles.pathName)
    guidata(hObject, handles);
end
cd(handles.pathName)

if isempty(strmatch('Figures',ls))
    mkdir('Figures')
end

fprintf('File opened: %s\n',handles.pathName);
fprintf('Block: %s',handles.blockName);
handles=loadMatlabVar_Callback(hObject, eventdata, handles)
%handles.ecogDS.data=detrend(handles.ecogDS.data','constant')';
guidata(hObject, handles);


% --- Executes automatically when file location is entered
function handles=loadMatlabVar_Callback(hObject, eventdata, handles)
% PURPOSE: READ RAW HTK FILES AND ASSEMBLE IN MATLAB MATRIX WHERE
% M=CHANNELS, N=SAMPLES
%Set default Values
handles.sampFreq=400;
handles.freqRange=[70 150];
handles.filterOption='Build Filter Bank';
handles.individualPer='y';

contents = cellstr(get(handles.datatype,'String'));

 handles.type=[contents{get(handles.datatype,'Value')}];



flag=1;
switch handles.type
    case 'Human'
        channelsTot=256;
        timeInt=[];
        handles.ecog=loadHTKtoEcog_CT(sprintf('%s/%s',handles.pathName,'RawHTK'),channelsTot,timeInt);
    case 'RatDS'
        channelsTot=96;
        timeInt=[];
        %handles.ecog=loadHTKtoEcog_rat_CT(sprintf('%s/%s',handles.pathName,'AfterCARandNotch'),channelsTot,timeInt,'rat');
        handles.ecog=loadHTKtoEcog_rat_CT(sprintf('%s/%s',handles.pathName,'downsampled400'),channelsTot,timeInt,'rat');
        
        handles.ecogDS=handles.ecog;
        baselineDurMs=0;
        sampDur=1000/handles.ecogDS.sampFreq;
        flag=0;
    case 'Rat'
        channelsTot=96;
        timeInt=[];
        handles.ecog=loadHTKtoEcog_rat_CT(sprintf('%s/%s',handles.pathName,'RawHTK'),channelsTot,timeInt,'rat');
    case 'DS'
        %channelsTot=128;
        channelsTot=256;
        
        timeInt=[];
        handles.ecog=loadHTKtoEcog_CT(sprintf('%s/%s',handles.pathName,'Downsampled400'),channelsTot,timeInt)
        handles.ecogDS=handles.ecog;
        baselineDurMs=0;
        sampDur=1000/handles.ecog.sampFreq;
        flag=0;
        handles.ecogDS=handles.ecog;
end
%fprintf('Loading complete. Matlab variable is %d x %d matrix.\n',size(handles.ecogDS.data,1),size(handles.ecogDS.data,2));
if flag==1
    %Downsample to 400
    baselineDurMs=0;
    sampDur=1000/handles.ecog.sampFreq;
    handles.ecog=ecogRaw2EcogGUI(handles.ecog.data,baselineDurMs,sampDur,[],handles.ecog.sampFreq);
    handles.ecogDS=downsampleEcog(handles.ecog,400);
    fprintf('Downsampled Frequency: %d Hz\n',handles.sampFreq);
end

handles.ecogDS.selectedChannels=1:size(handles.ecogDS.data,1);
handles.ecogDS.sampDur=1000/400;
handles.ecogDS.sampFreq=400;
handles.ecogDS.timebase=[0:(size(handles.ecogDS.data,2)-1)]*handles.ecogDS.sampDur;
handles.badChannels=[];
handles.badTimeSegments=[];
handles.ecogDS.badChannels=[];
handles.ecogDS.badTimeSegments=[];
rmfield(handles,'ecog');
guidata(hObject, handles);

% --- Executes on button press in lookAtTimeSeries.
function lookAtTimeSeries_Callback(hObject, eventdata, handles)
% PURPOSE: CALL ECOGTSGUI TO VIEW TIMESERIES. MAKES BAD TIME SEGMENTS
% VARIABLE.
% If bad segments already selected or pre-loaded, additional ones will be
% appended.
dcshifted=handles.ecogDS;
dcshifted.badChannels=handles.badChannels;
dcshifted.data=handles.ecogDS.data-repmat(mean(handles.ecogDS.data,2),[1 size(handles.ecogDS.data,2)]);
dcshifted.badIntervals=handles.badTimeSegments;
[~,handles.badTimeSegments]=ecogTSGUI(dcshifted);
handles.badTimeSegments(find(handles.badTimeSegments(:,2)<0),:)=[];

handles.badTimeSegments(find(handles.badTimeSegments(:,1)<0),1)=0;
maxTime=size(handles.ecogDS.data,2)/handles.ecogDS.sampFreq;
handles.badTimeSegments(find(handles.badTimeSegments(:,1)>maxTime),:)=[];
handles.badTimeSegments(find(handles.badTimeSegments(:,2)>maxTime),2)=maxTime;

guidata(hObject, handles);

% --- Executes on button press in allPeriodograms.
function allPeriodograms_Callback(hObject, eventdata, handles)
% PURPOSE: VIEWS ALL PERIODOGRAMS OF DOWNSAMPLED DATA TOGETHER IN 3D PLOT, AND PLOTS
% PERIODOGRAM OF EACH CHANNEL INDIVIDUALLY, WHICH YOU CAN LOOK THROUGH ONE
% BY ONE. USES MULTI-TAPER METHOD TO CALCULATE PERIODOGRAM. SAVES THE 3D
% FIGURE IN BLOCK FOLDER ON DISK
badTimeSegments=handles.badTimeSegments;
ecogTmp=handles.ecogDS;
b=[];
for i=1:size(badTimeSegments,1)
    b=[b round(badTimeSegments(i,1)*400):round(badTimeSegments(i,2)*400)];
end

if ~isempty(b)
    ecogTmp.data(:,b)=[];%temporarily delete all bad time points from ecog matrix
end

if ~isempty(handles.badChannels)
    ecogTmp.badChannels=handles.badChannels;
else
    ecogTmp.badChannels=[];
end

if size(handles.ecogDS.data,2)>30000
    ecogTmp.data=ecogTmp.data(:,1:30000);
    checkPeriodogramGUI_figName(ecogTmp,handles.individualPer,'FIG_periodogramDS');    
else
    checkPeriodogramGUI_figName(ecogTmp,handles.individualPer,'FIG_periodogramDS');
end
handles.badChannels=unique(handles.ecogDS.badChannels);

guidata(hObject, handles);





% --- Executes on button press in commandLine.
function commandLine_Callback(hObject, eventdata, handles)
%PURPOSE: GIVE USER CONTROL OF COMMAND LINE WHILE IN GUI FUNCTION
%TYPE 'RETURN' TO EXIT MODE
keyboard

function inputBadChannels_Callback(hObject, eventdata, handles)
% PURPOSE: GETS CONTENTS ENTERED INTO 'BAD CHANNELS' BOX IN GUI.
handles.badChannels=str2num(get(hObject,'String'));
handles.ecog.badChannels=handles.badChannels;
handles.ecogDS.badChannels=handles.badChannels;
fprintf('Bad Channels: %s \n',int2str(handles.badChannels));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputBadChannels_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in saveBadTimeSegments.
function saveBadTimeSegments_Callback(hObject, eventdata, handles)
% SAVES BAD TIME SEGMENTS AS BOTH A MATLAB FUNCTION AND A .LAB FILE ON DISK
cd('Artifacts')
BadTimesConverterGUI(handles.badTimeSegments,'bad_time_segments.lab');
save('badTimeSegments','-struct','handles','badTimeSegments');
fprintf('%d Bad time segments saved\n',size(handles.badTimeSegments,1));
cd(handles.pathName)


% --- Executes on button press in saveBadCh.
function saveBadCh_Callback(hObject, eventdata, handles)
% SAVES BAD CHANNELS AS TEXT FILE ON DISK
cd('Artifacts')
fid = fopen('badChannels.txt', 'w');
fprintf(fid, '%6.0f', handles.badChannels);
fclose(fid);
fprintf('Bad channels saved\n');
cd(handles.pathName)

% --- Executes on button press in loadBadTimeSegments.
function loadBadTimeSegments_Callback(hObject, eventdata, handles)
% PURPOSE: LOAD BAD TIME SEGMENTS SAVED ON DISK INTO GUI
cd('Artifacts')
load 'badTimeSegments.mat';
handles.badTimeSegments=badTimeSegments;
guidata(hObject, handles);
fprintf('%d bad time segments loaded\n',size(handles.badTimeSegments,1));
cd(handles.pathName)


% --- Executes on button press in loadBadCh.
function loadBadCh_Callback(hObject, eventdata, handles)
% PURPOSE: LOAD BAD CHANNELS SAVED ON DISK INTO GUI
cd('Artifacts')
fid = fopen('badChannels.txt');
tmp = fscanf(fid, '%d');
handles.badChannels=tmp';
fclose(fid);
set(handles.inputBadChannels,'String',int2str(handles.badChannels));
fprintf('Bad Channels: %s',int2str(handles.badChannels));
cd(handles.pathName)
guidata(hObject, handles);


% --- Executes on button press in subtractCARonly.
function subtractCARonly_Callback(hObject, eventdata, handles)
% PURPOSE: SUBTRACT COMMON AVERAGE REFERENCE FROM SIGNAL
% CAR CALCULATED ACROSS 16 CHANNEL BLOCKS
% BAD CHANNELS ARE EXCLUDED FROM CAR CALCULATION
filtered=ecogFilterTemporal(handles.ecogDS,[1 200],3);%1 Hz high pass filter
ignoreChans=[handles.badChannels];
usechans= setdiff(1:size(handles.ecogDS.data,1),ignoreChans);
c=1;
CAR=[];
switch handles.type
    case 'rat'
        %if rat ecog, use entire grid as CAR
        CAR=[CAR;repmat(mean(filtered.data(usechans,:),1),size(filtered.data,1),1)];
    case 'RatDS'
        %if rat ecog, use entire grid as CAR
        CAR=[CAR;repmat(mean(filtered.data(usechans,:),1),size(filtered.data,1),1)];
    otherwise
        %calculate common average reference by 16-channel blocks
        while c<=size(handles.ecogDS.data,1)
            CAR=[CAR;repmat(mean(filtered.data(intersect((c:c+15),usechans),:),1),16,1)];
            c=c+16;
        end
end

handles.ecogNormalized.data=handles.ecogDS.data-CAR;
handles.ecogNormalized.timebase=handles.ecogDS.timebase;
handles.ecogNormalized.sampDur=handles.ecogDS.sampDur;
handles.ecogNormalized.sampFreq=handles.ecogDS.sampFreq;
handles.ecogNormalized.selectedChannels=handles.ecogDS.selectedChannels;
fprintf('CAR subtraction complete\n');
guidata(hObject, handles);



% --- Executes on button press in spectrogramAllChan_DS.
function spectrogramAllChan_DS_Callback(hObject, eventdata, handles)

fprintf('Calculating Spectrograms...')
plotSpectrogramDS_AllChan_AllTS_GUI(handles.ecogDS,handles.blockName, handles.badChannels)
%{
cd('Figures')
saveas(gcf,'FIG_spectrogramDS','fig')
cd(handles.pathName)
%}
fprintf('\nDone!\n')


% --- Executes on button press in spectrogramAllCh_afterCAR.
function spectrogramAllCh_afterCAR_Callback(hObject, eventdata, handles)

fprintf('Calculating Spectrograms...')
badTimeSegments=handles.badTimeSegments;
ecogTmp=handles.ecogNormalized;
b=[];
for i=1:size(badTimeSegments,1)
    b=[b round(badTimeSegments(i,1)*400):round(badTimeSegments(i,2)*400)];
end
plotSpectrogramDS_AllChan_AllTS_GUI(ecogTmp,handles.blockName, handles.badChannels)
%{
cd('Figures')
saveas(gcf,'FIG_spectrogramAfterCAR','fig')
cd(handles.pathName)
%}
fprintf('\nDone!\n')


% --- Executes on button press in periodogram_badSegmentsChansDeleted.
function periodogram_badSegmentsChansDeleted_Callback(hObject, eventdata, handles)
% PURPOSE: LOOK AT PERIODOGRAMS AFTER CAR, WITH BAD CHANNELS AND BAD TIME
% SEGMENTS DELETED

%Remove bad time segments
badTimeSegments=handles.badTimeSegments;
ecogTmp=handles.ecogNormalized;

%get sample points for all bad time segments
b=[];
for i=1:size(badTimeSegments,1)
    b=[b ceil(badTimeSegments(i,1)*400):floor(badTimeSegments(i,2)*400)];
end
ecogTmp.data(handles.badChannels,:)=[];%temporarily delete all bad channels from ecog matrix
if ~isempty(b)
    ecogTmp.data(:,b)=[];%temporarily delete all bad time points from ecog matrix
end
ecogTmp.selectedChannels=1:size(ecogTmp.data,1);

if size(handles.ecogNormalized.data,2)>30000
    %tmp=handles.ecogDS;
    ecogTmp.data=ecogTmp.data(:,1:30000);
    checkPeriodogramGUI_figName(ecogTmp,handles.individualPer,'FIG_periodogramDS');
else
    checkPeriodogramGUI_figName(ecogTmp,handles.individualPer,'FIG_periodogramAfterCAR');
end
guidata(hObject, handles);


% --- Executes on button press in std_dev.
function std_dev_Callback(hObject, eventdata, handles)

fprintf('Calculating Standard Deviation...\n')
s=std(handles.ecogDS.data');
%assignin('base','s',s);
upperbound=90; %max standard deviation you're looking for. this can be customized

high_std=find(s>upperbound);
%assignin('base','high_std',high_std)

fprintf('Channels with standard dev above %d: %s\n',upperbound,int2str(find(s>upperbound)));

figure
plot(s); axis tight
hold on;
plot(handles.badChannels,s(handles.badChannels),'r.')
legend({'standard deviation', 'currently marked bad channels'})

if length(s)>64
    %map stanndard deviation onto grid layout
    r=ceil(length(s)/16);
    extra=r*16-length(s);
    s2=reshape([s zeros(1,extra)],16,r);
    
    
    a=fileparts(handles.pathName);
    [~,b,~]=fileparts(a);
    
    try
        s3=s-mean(s);
        %s3(find(s3>50))=50;
        %s3(find(s3<-10))=-50;
        visualizeGrid(1,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\',b,'\brain_3Drecon.jpg'],1:256,s3,[])
    catch
        printf('no image\n')
    end
    %assignin('base','s2',s2);
    figure
    imagesc(s2',[0 100])
    set(gca,'XGrid','on')
    set(gca,'YGrid','on')
    set(gca,'XTick',[1.5:16.5])
    set(gca,'YTick',[1.5:(r+.5)])
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    for c=1:16
        for r=1:r
            text(c,r,num2str((r-1)*16+c))
            if ismember((r-1)*16+c,handles.badChannels)
                text(c,r,num2str((r-1)*16+c),'Background','y')
            end
        end
    end
elseif s==64
    figure
    s2=reshape(s,8,8);
    
    imagesc(s2',[0 100])
    set(gca,'XGrid','on')
    set(gca,'YGrid','on')
    %set(gca,'XTick',[1.5:16.5])
    %set(gca,'YTick',[1.5:(r+.5)])
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    for c=1:8
        for r=1:8
            text(c,r,num2str((r-1)*16+c))
            if ismember((r-1)*16+c,handles.badChannels)
                text(c,r,num2str((r-1)*16+c),'Background','y')
            end
        end
    end
end
colorbar
cd(handles.pathName)

% --- Executes on button press in LookatsignalafterCAR.
function TSafterCAR_Callback(hObject, eventdata, handles)
%PURPOSE: Looks at time series after CAR
dcshifted=handles.ecogNormalized;
dcshifted.badChannels=handles.badChannels;
dcshifted.data=handles.ecogNormalized.data-repmat(mean(handles.ecogNormalized.data,2),[1 size(handles.ecogNormalized.data,2)]);


dcshifted.data(handles.badChannels,:)=zeros(length(handles.badChannels),size(dcshifted.data,2));

if ~isempty(handles.badTimeSegments)
    tmpseg=floor(handles.badTimeSegments*handles.sampFreq);
    tmpseg(find(tmpseg(:,1:2))<0)=1;
    tmpseg(find(tmpseg>size(dcshifted.data,2)))=size(dcshifted.data,2);
    
    for i=1:size(tmpseg,1)
        dcshifted.data(:,tmpseg(i,1):tmpseg(i,2))=0;
    end
end

dcshifted.badIntervals=handles.badTimeSegments;
[~,handles.badTimeSegments]=ecogTSGUI(dcshifted);


handles.badTimeSegments(find(handles.badTimeSegments(:,2)<0),:)=[];

handles.badTimeSegments(find(handles.badTimeSegments(:,1)<0),1)=0;
maxTime=size(handles.ecogDS.data,2)/handles.ecogDS.sampFreq;
handles.badTimeSegments(find(handles.badTimeSegments(:,1)>maxTime),:)=[];
handles.badTimeSegments(find(handles.badTimeSegments(:,2)>maxTime),2)=maxTime;


guidata(hObject, handles);


% --- Executes on selection change in datatype.
function datatype_Callback(hObject, eventdata, handles)
% hObject    handle to datatype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns datatype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from datatype
%{
contents = cellstr(get(hObject,'String'));
handles.datatype=contents{get(hObject,'Value')};
guidata(hObject, handles);
%}

% --- Executes during object creation, after setting all properties.
function datatype_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton71.
function pushbutton71_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[a,b,c]=fileparts(handles.pathName);
x=find(ismember(handles.donelog(:,2), b)==1);
handles.donelog{x,6}=date;
assignin('base','DoneLog',handles.donelog)



