function varargout = analysis_GUI(varargin)
% ANALYSIS_GUI M-file for analysis_GUI.fig
%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analysis_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @analysis_GUI_OutputFcn, ...
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

function analysis_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for analysis_GUI
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = analysis_GUI_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


function getFolder_Callback(hObject, eventdata, handles)

handles.file=get(hObject,'String');
[handles.pathName,b,c]=fileparts(handles.file);
guidata(hObject, handles);
fprintf('File opened: %s\n',handles.file);

%LOAD FILTERED DATA
channelsTot=256;
if strmatch(b,'HilbReal_4to200_40band')
    cd([handles.pathName '\HilbReal_4to200_40band'])
    blockNum=floor(channelsTot/64);
    elecNum=rem(channelsTot,64);
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
    handles.sampFreq=sampFreq;
    handles.ecogFiltered.sampFreq=sampFreq;
    handles.ecogFiltered.data=zeros(channelsTot,size(data,2),size(data,1));    
    for chanNum=1:channelsTot
            data=loadHTKtoEcog_onechan_complex(handles.pathName,chanNum,[]);
            handles.ecogFiltered.data(chanNum,:,:)=data';
            fprintf([int2str(chanNum) '.'])
    end
    
    
elseif ~isempty(strfind(handles.pathName,'Rat'))
    handles.ecogFiltered=loadHTKtoEcog_rat_CT(handles.file,96,[])
elseif strmatch(b,'Analog')
    handles.ecogFiltered=loadAnalogtoEcog_CT(handles.file,4,[]);
    handles.baselineChoice='None';
else
    handles.ecogFiltered=loadHTKtoEcog_CT(handles.file,channelsTot,[]);
    handles.ecogFiltered.data=mean(handles.ecogFiltered.data,3);
end
handles.sampFreq=handles.ecogFiltered.sampFreq;
sampFreq=handles.ecogFiltered.sampFreq;
baselineDurMs=0;
sampDur=1000/handles.sampFreq;

cd(sprintf('%s/Artifacts',handles.pathName))
load 'badTimeSegments.mat'
handles.badTimeSegments=badTimeSegments;
fprintf('%d bad time segments loaded',size(handles.badTimeSegments,1));
fid = fopen('badChannels.txt');
tmp = fscanf(fid, '%d');
handles.badChannels=tmp';
fclose(fid);
fprintf('Bad Channels: %s',int2str(handles.badChannels));
cd(handles.pathName)

tmp=regexp(handles.pathName,'_','split');
names=regexp(tmp{1},'\','split');
handles.patientID=names{end};

try 
    load('gridlayout');
    usechans=reshape(gridlayout',1, size(gridlayout,1)*size(gridlayout,2));
    handles.gridlayout.dim=[size(gridlayout,1) size(gridlayout,2)];

catch
    usechans=[1:size(handles.ecogFiltered.data,1)];
    handles.gridlayout.dim=[16 16];
end

extra=0;

if length(usechans)>256
    extra=usechans([256:length(usechans)]);
    usechans=usechans(1:256);
    extra=size(zScore,1)-256;
end
handles.gridlayout.usechans=usechans;
handles.gridlayout.extra=extra;
guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function getFolder_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in segmentData.
function segmentData_Callback(hObject, eventdata, handles)

%sort=input('Sort Events? (y/n)','s');
%checkEvents=input('Check Events Visually? (y/n)','s');
sortstacked='n';
if strcmp(sortstacked,'n')
    handles.sortstacked=0;
else
    handles.sortstacked=1;
end
checkEvents='n';
cd(sprintf('%s/Analog',handles.pathName))
if strmatch(handles.segmentType,'Prelim')
    [handles.segmentedEcog, handles.eventTS]=segmentingEcogGUI(handles.pathName, handles.ecogFiltered,{[1]},handles.segmentTimeWindow, handles.badTimeSegments,0,handles.sampFreq, 1,handles.segmentType);
    handles.segmentedEcogGrouped=handles.segmentedEcog.data;
    guidata(hObject, handles);

else
    handles.segmentedEcog=segmentingEcogGUI_2events(handles.pathName, handles.ecogFiltered,handles.subsetLabel,handles.segmentTimeWindow, handles.badTimeSegments,handles.sampFreq, 0);
    if strmatch('y',checkEvents)
        handles.segmentedEcog.badTrials=checkEventSegmentationVisually(handles.segmentedEcog.eventTS)
        for i=1:size(handles.segmentedEcog.eventTS)
            goodtrials{i}=setdiff(1:size(handles.segmentedEcog.eventTS{i},4),handles.segmentedEcog.badTrials{i})
        end
    elseif strmatch('y',sortstacked)
        for i=1:size(handles.segmentedEcog.eventTS,2)
            e=squeeze(handles.segmentedEcog.eventTS{i});
            goodtrials{i}=[];
            for j=1:size(e,2)
                if size(handles.segmentedEcog.desiredSubsets{i},1)==4
                    s=find(ismember(e(handles.segmentTimeWindow{i}(1)/1000*handles.sampFreq+1:end,j),handles.segmentedEcog.desiredSubsets{i}(4,:)));
                else
                    s=find(ismember(e(handles.segmentTimeWindow{i}(1)/1000*handles.sampFreq+1:end,j),handles.segmentedEcog.desiredSubsets{i}(2,:)));
                    handles.segmentedEcog.desiredSubsets{i}(4,:)=handles.segmentedEcog.desiredSubsets{i}(2,:);
                end
                if ~isempty(s)
                    goodtrials{i}=[goodtrials{i} j];
                end
            end
            handles.segmentedEcog.badTrials{i}=setdiff(1:size(handles.segmentedEcog.eventTS{i},4),goodtrials{i})
        end
    end            
    %sort responsetimes

    if strmatch('y',sortstacked)
        for i=1:length(handles.segmentedEcog.data)
            for j=1:length(goodtrials{i})
                e=squeeze(handles.segmentedEcog.eventTS{i});
                r(j)=find(ismember(e(handles.segmentTimeWindow{i}(1)/1000*handles.sampFreq+1:end,goodtrials{i}(j)),handles.segmentedEcog.desiredSubsets{i}(4,:)));

            end
            
            if exist('r')
                [r2,idx]=sort(r);
                t=1:length(goodtrials{i});
                handles.segmentedEcog.data{i}=handles.segmentedEcog.data{i}(:,:,:,goodtrials{i}(idx));
                handles.segmentedEcog.rt{i}=r2;  
                handles.segmentedEcog.trialidx{i}=idx;
                clear r
            else
                handles.segmentedEcog.rt{i}=zeros(1,j);
            end
        end
        %handles.sortstacked=1;
    end
     
    for i=1:length(handles.segmentedEcog)
         handles.segmentedEcogGrouped{i}=handles.segmentedEcog(i).data;
    end
    guidata(hObject, handles);
end
cd(handles.pathName)

function segmentationWindow_Callback(hObject, eventdata, handles)

a=get(hObject,'String');
eval(sprintf('handles.segmentTimeWindow={%s}',a));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function segmentationWindow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pickSegmentationType.
function pickSegmentationType_Callback(hObject, eventdata, handles)

contents=cellstr(get(hObject,'String'))
handles.segmentType = contents{get(hObject,'Value')}
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pickSegmentationType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function desiredSubsets_Callback(hObject, eventdata, handles)

tmp = get(hObject,'String');
eval(sprintf('handles.subsetLabel={%s}',tmp));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function desiredSubsets_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkSegmentationEvents.
function checkSegmentationEvents_Callback(hObject, eventdata, handles)

handles.segmentedEcog.badTrials=checkEventSegmentationVisually(handles.segmentedEcog.eventTS)
guidata(hObject, handles);


% --- Executes on button press in plotZscore.
function plotZscore_Callback(hObject, eventdata, handles)


for i=1:length(handles.segmentedEcogGrouped)
       datalength=size(handles.segmentedEcogGrouped{i},2);        
        if strmatch('PreEvent',handles.baselineChoice)
            %Use 300 ms before each event for baseline
            samples=[ceil(handles.baselineMS(1)*4/10):floor(handles.baselineMS(2)*4/10)];%This can be changed to adjust time used for baseline
            Baseline=handles.segmentedEcogGrouped{i}(:,samples,:,:);
            meanOfBaseline=repmat(mean(Baseline,2),[1, datalength,1,1]);
            stdOfBaseline=repmat(std(Baseline,0,2),[1,datalength,1, 1]);
        
        elseif strmatch('RestEnd',handles.baselineChoice)
            %Use resting at end for baseline
            handles.baselineFiltered.data=handles.ecogFiltered.data(:,round(handles.baselineMS(1)*handles.sampFreq/1000:handles.baselineMS(2)*handles.sampFreq/1000),:,:);
            meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);

        elseif strmatch('RestBlock',handles.baselineChoice)
        %use rest block for baseline
            handles.baselineFiltered.data=handles.ecogBaseline.data;
            meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
       
        end
        
        zscore_separate=(handles.segmentedEcogGrouped{i}-meanOfBaseline)./stdOfBaseline;
        zScore{i}=mean(mean(zscore_separate,3),4);
        zScore{i}(handles.badChannels,:)=NaN;
          
end

%Plot zScores
colors={'k','r','m','b','c','g'};
%comparePlots=input('Compare Plots? (y/n)','s');
comparePlots='y';
if strmatch('y',comparePlots)    
    figure
    set(gcf,'Name',handles.patientID);
	for i=1:length(zScore) 
        Y=zScore{i};
         E = std(Y,[],3)/sqrt(size(Y,3));
        %processingPlotAllChannels_inputZscoreGUI(zScore{i},colors{i},handles.segmentTimeWindow{i}(1)*handles.sampFreq/1000,handles.badChannels,[],E,handles.gridlayout);

	    processingPlotAllChannels_inputZscoreGUI(mean(handles.segmentedEcogGrouped{i},4),colors{i},handles.segmentTimeWindow{i}(1)*handles.sampFreq/1000,handles.badChannels,[],E,handles.gridlayout);
        hold on		
    end	
else
	for i=1:length(zScore)
        figure
        set(gcf,'Name',handles.patientID);
        Y=zScore{i};
         E = std(Y,[],3)/sqrt(size(Y,3));
        processingPlotAllChannels_inputZscoreGUI(zScore{i},colors{1},handles.segmentTimeWindow{i}(1)*handles.sampFreq/1000,handles.badChannels,[],E,handles.gridlayout);
	end
end



% --- Executes oon button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

keyboard


% --- Executes on button press in makeSpectrograms.
function makeSpectrograms_Callback(hObject, eventdata, handles)

for i=1:length(handles.segmentedEcogGrouped)
       datalength=size(handles.segmentedEcogGrouped{i},2);      
        if strmatch('PreEvent',handles.baselineChoice)
            %Use 300 ms before each event for baseline
            samples=[handles.baselineMS*4/10:handles.segmentTimeWindow{i}(1)*handles.sampFreq/1000];%This can be changed to adjust time used for baseline
            Baseline=handles.segmentedEcogGrouped{i}(:,samples,:,:);
            meanOfBaseline=repmat(mean(Baseline,2),[1, datalength,1,1]);
            stdOfBaseline=repmat(std(Baseline,0,2),[1,datalength,1, 1]);
        
       elseif strmatch('RestEnd',handles.baselineChoice)
            %Use resting at end for baseline
            handles.baselineFiltered.data=handles.ecogFiltered.data(:,handles.baselineMS(1)*handles.sampFreq:handles.baselineMS(2)*handles.sampFreq,:,:);
            meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            
       elseif strmatch('RestBlock',handles.baselineChoice)
            %use rest block for baseline
            handles.baselineFiltered.data=handles.ecogBaseline.data;
            meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
       end
        
        zscore_separate=(handles.segmentedEcogGrouped{i}-meanOfBaseline)./stdOfBaseline;
        zScore_separate_ave{i}=mean(zscore_separate,4);        
        zScore_separate_ave{i}(handles.badChannels,:,:)=NaN;         
end

for i=1:length(zScore_separate_ave)
    figure;
        set(gcf,'Name',handles.patientID);

    processingPlotAllSpectrograms_inputZscoreGUI(zScore_separate_ave{i},handles.segmentTimeWindow{i}(1)*handles.sampFreq/1000,handles.badChannels,handles.gridlayout)
end


% --- Executes on button press in makeSingleStacked.
function makeSingleStacked_Callback(hObject, eventdata, handles)

if  strmatch('None',handles.baselineChoice)
    for i=1:length(handles.segmentedEcogGrouped)
    %use rest block for baseline
        zScore{i}=squeeze(handles.segmentedEcogGrouped{i});
        figure
        set(gcf,'Name',handles.patientID);
        handles.gridlayout.dim=[2 2];
        handles.gridlayout.usechans=1:4;
        processingPlotSingleStacked_inputZscoreGUI_sorted(zScore{i},handles.segmentTimeWindow{i}(1)*handles.sampFreq/1000,[],handles.segmentedEcog.rt{i},handles.gridlayout);
    end
    return;
end

for i=1:length(handles.segmentedEcogGrouped)
        datalength=size(handles.segmentedEcogGrouped{i},2);        
       if strmatch('PreEvent',handles.baselineChoice)
            %Use 300 ms before each event for baseline
            samples=[handles.baselineMS(1)*4/10:handles.baselineMS(2)*4/10];%This can be changed to adjust time used for baseline
            Baseline=handles.segmentedEcogGrouped{i}(:,samples,:,:);
            meanOfBaseline=repmat(mean(Baseline,2),[1, datalength,1,1]);
            stdOfBaseline=repmat(std(Baseline,0,2),[1,datalength,1, 1]);
        
       elseif strmatch('RestEnd',handles.baselineChoice)
            %Use resting at end for baseline
            handles.baselineFiltered.data=handles.ecogFiltered.data(:,handles.baselineMS(1)*4/10:handles.baselineMS(2)*4/10,:,:);
            meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);

       elseif strmatch('RestBlock',handles.baselineChoice)
            %use rest block for baseline
            handles.baselineFiltered.data=handles.ecogBaseline.data;
            meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);

       end        
        zscore_separate=(handles.segmentedEcogGrouped{i}-meanOfBaseline)./stdOfBaseline;
        zScore{i}=squeeze(mean(zscore_separate,3));
        zScore{i}(handles.badChannels,:,:)=NaN;

end

if handles.sortstacked==1
    for i=1:length(zScore)
        figure
        set(gcf,'Name',handles.patientID);
        processingPlotSingleStacked_inputZscoreGUI_sorted(zScore{i},handles.segmentTimeWindow{i}(1)*handles.sampFreq/1000,handles.badChannels,handles.segmentedEcog.rt{i},handles.gridlayout);
    end
else
    for i=1:length(zScore)
         figure
        set(gcf,'Name',handles.patientID);
        processingPlotSingleStacked_inputZscoreGUI(zScore{i},handles.segmentTimeWindow{i}(1)*handles.sampFreq/1000,handles.badChannels,handles.gridlayout);
    end
end


function getBaselineFolder_Callback(hObject, eventdata, handles)

baselinefile=get(hObject,'String');
[pathName,b,c]=fileparts(handles.file);
fprintf('Baseline File opened: %s\n',baselinefile);
[a,b]=fileparts(baselinefile);

if strmatch(b,'HilbReal_4to200_40band')
    cd([ pathName '\HilbReal_4to200_40band'])
    [r, sampFreq, tmp, chanNum] = readhtk ('Wav11.htk');
    %handles.ecogBaseline.data=zeros(256,size(r,2),size(r,1));

    for nBlocks=1:4
        for k=1:64
            cd([ handles.pathName '\HilbReal_4to200_40band'])
            varName1=['Wav' num2str(nBlocks) num2str(k)]
            [r, sampFreq, tmp, chanNum] = readhtk (sprintf('%s.htk',varName1));
            fprintf('%i.',chanNum)
            %ecog.data((nBlocks-1)*64+k,:)=data;             
            cd([ pathName '\HilbImag_4to200_40band'])
            im = readhtk (sprintf('%s.htk',varName1));            
            %handles.ecogBaseline.data(chanNum,:,:)=abs(complex(r,im))';  
            handles.ecogBaseline.mean(chanNum,1,:)=mean(abs(complex(r,im))',1);
            handles.ecogBaseline.std(chanNum,1,:)=std(abs(complex(r,im))',[],1);

        end
    end    
    handles.ecogBaseline.sampFreq=sampFreq;

else
    cd(baselinefile);
    [data, sampFreq, chanNum] = readhtk ( 'Wav11.htk' );
    handles.ecogBaseline.data=zeros(256,length(data),size(data,1));
    for nBlocks=1:4
        for k=1:64
            varName1=['Wav' num2str(nBlocks) num2str(k)]
            [data, sampFreq, tmp, chanNum] = readhtk (sprintf('%s.htk',varName1));
            chanNum
            handles.ecogBaseline.data(chanNum,:,:)=mean(data',3);

        end
    end
    handles.ecogBaseline.data=mean(handles.ecogBaseline.data,3);

    handles.ecogBaseline.sampFreq=sampFreq;
end

guidata(hObject, handles);
cd(handles.pathName)



% --- Executes during object creation, after setting all properties.
function getBaselineFolder_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in getBaselineChoice.
function getBaselineChoice_Callback(hObject, eventdata, handles)

contents=cellstr(get(hObject,'String'))
handles.baselineChoice = contents{get(hObject,'Value')}
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function getBaselineChoice_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function baselinePreEvent_Callback(hObject, eventdata, handles)

%handles.baselineMS=str2double(get(hObject,'String'));
a=get(hObject,'String');
eval(sprintf('handles.baselineMS=[%s]',a));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function baselinePreEvent_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)

a=get(hObject,'String');
eval(sprintf('handles.baselineMS=[%s]',a));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function loadsegmentedEcog40band(hObject, eventdata, handles)

for event=1:5
    buffer=[3000 3000];
    dest=sprintf('E:/DelayWord/EC22/EC22_B1/segmented_40band/event%i_%i_%i',event,buffer(1),buffer(2))
    
    for chanNum= 1:256
        cd([dest filesep 'Chan' int2str(chanNum)])
        for i=1:length(ls)-2

            cd([dest filesep 'Chan' int2str(chanNum)])
            tmp=readhtk(['t' int2str(i) '.htk']);
            
            if i==1 & chanNum==1
                handles.segmentedEcog.data{event}=zeros(256,size(tmp,1),size(tmp,2),length(ls)-2);
            end
            handles.segmentedEcog.data{event}(chanNum,:,:,i)=tmp;
        end
    end    
end
guidata(hObject, handles);


