function h_singlestackedulator_motormapping_SMART(handles)
%   Connie Cheung, June, 2011
% simulator_motormapping_SMART
%
% capable of plotting 256
% Faster reshape, artifact rejection,faster average
%
%
% 1) plots continual 64/256 electrodes (last mean(integration time)) in frequency
% indicated by variable desired_freq plot
% 2) plots single event power/time plot
% 3) plots average event power/time plot
% 4) plots single stacked trials

%close all

%[filename, pth] = uigetfile('*', 'Load tdt data mat');
%load([pth filename])

a = pwd;

f=fields(handles);
for i=[24:32 34:length(fields(handles))]
    eval(sprintf('%s=deal(handles.(f{i}));',f{i}));
end

desired_ANchan = 1;
desired_ANchan2 = 2; % ADD TO GUI 


%[filename, pth] = uigetfile('*', 'Load start index and threshold');
%load([pth filename])
gdat = Envelope(:,:,start_ind:end);
analog_dat = AnalogData(:,start_ind:end);

% gdat = Envelope;
% analog_dat = AnalogData;
clear Envelope AnalogData RawData
%%


% Set variables
sampling_rate = 500;
number_of_channels = 16;
ANnumber_of_channels = 4;
number_of_sec2read = 2;
dANproj_name =  {'motormap.danin'};
sANproj_name =  {'motormap.sanin'};
integration_time = .1;
avgEvent_freqs2plot = 1:7;
singleEvent_freqs2plot = 1:7;
num_freq_bands = 7;
window_around_event = 500;
detected_num_events=0;
% Flags
event_flag = 1;  % Average plot
single_event_flag = 1;
single_stacked_flag = 1;
calculated_baseline_flag = 1;%get(handles.calculated_baseline_flag,'Value');
newEventFlag=0;
num_events=0;

% Retrieve from GUI
time2collectBaseline = str2num(get(handles.time2collectBaseline,'String'));
desired_freq_plot = str2num(get(handles.desired_freq_plot,'String'));
freq_band_singlestacked = str2num(get(handles.freq_band_singlestacked,'String'));
desired_ANchan = str2num(get(handles.desired_ANchan,'String'));
threshold = handles.threshold;
subj_id = get(handles.subj_id,'String');
number_of_electrodes_total=256;
%stackedEventsAll=zeros(number_of_electrodes_total,50,window_around_event+1);
%allStacked=zeros(number_of_electrodes_total,num_freq_bands,window_around_event+1,50);
allStacked=zeros(number_of_electrodes_total,50,window_around_event+1);
desired_ANchan = 1;
desired_ANchan2 = 2; % ADD TO GUI 
num_events = 1;
indLastEvent = 0;
eventIndices = zeros(2,50); % 50 = max number of events expected
numeventFLAG = 2; % 1 or 2  ADD TO GUI 

if  number_of_electrodes_total == 64%get(handles.get_total_electrodes,'Value')==1
    dproj_name = {'motormap.dwav1';'motormap.dwav2';'motormap.dwav3';'motormap.dwav4'};
    sproj_name = {'motormap.swav1';'motormap.swav2';'motormap.swav3';'motormap.swav4'};
    to_plot_grid=8;
elseif number_of_electrodes_total == 256;
    dproj_name = {'motormap.dwav1';'motormap.dwav2';'motormap.dwav3';'motormap.dwav4';...
        'motormap.dwav5';'motormap.dwav6';'motormap.dwav7';'motormap.dwav8';...
        'motormap.dwav9';'motormap.dwa10';'motormap.dwa11';'motormap.dwa12';...
        'motormap.dwa13';'motormap.dwa14';'motormap.dwa15';'motormap.dwa16'};
    sproj_name = {'motormap.swav1';'motormap.swav2';'motormap.swav3';'motormap.swav4';...
        'motormap.swav5';'motormap.swav6';'motormap.swav7';'motormap.swav8';...
        'motormap.swav9';'motormap.swa10';'motormap.swa11';'motormap.swa12';...
        'motormap.swa13';'motormap.swa14';'motormap.swa15';'motormap.swa16'};
    to_plot_grid=16;
end

% Calculate
points_needed4baseline = sampling_rate*time2collectBaseline*number_of_channels *num_freq_bands;
number_of_points2read = sampling_rate*number_of_sec2read*number_of_channels*num_freq_bands;
ANnumber_of_points2read = sampling_rate*number_of_sec2read*ANnumber_of_channels;
num_avgEvent_freqs2plot = length(avgEvent_freqs2plot);
num_singleEvent_freqs2plot = length(singleEvent_freqs2plot);
%%
fh=figure(2);
fh4=handles.lastSpectrogram;
fh5=handles.eventCounter;
fh2=handles.continualAverage;
fh6 = figure(6);
%setPlots;

%%
%CONTINUAL PLOT
set(0,'currentfigure',handles.figure1);
set(handles.figure1,'CurrentAxes',handles.continualAverage); cla
fh2=handles.continualAverage;
title('Continual Plot')
set(fh2,'XTickLabel',[]);
set(fh2,'YTickLabel',[]);

%%
%AVERAGE SPECTROGRAM PLOT
fh=figure(2); clf% figure for average event trigger analysis
z=axes('Position',[.1 .1 .85 .85],'visible','off');
set(fh,'DefaultAxesxtick',[0.5: (window_around_event+1):to_plot_grid*(window_around_event+1)])
set(fh,'DefaultAxesytick',[0.5: num_avgEvent_freqs2plot:to_plot_grid*num_avgEvent_freqs2plot])
set(fh,'DefaultAxesyticklabel','')
set(fh,'DefaultAxesxticklabel','')
set(fh,'DefaultAxeslinewidth',1)
set(fh,'DefaultAxesgridlinestyle','-')
set(fh, 'Name','Average Event Time Frequency Plot','NumberTitle','off')
set(fh,'CurrentAxes',z);


%%
%LAST SPECTROGRAM PLOT
%fh4=figure(4); % figure for single event trigger analysis
set(0,'currentfigure',handles.figure1);
set(handles.figure1,'CurrentAxes',handles.lastSpectrogram); cla
fh4=handles.lastSpectrogram;
%set(fh4,'Position',[.1 .1 .85 .85],'visible','off');
set(fh4,'Xtick',[0.5: (window_around_event+1):to_plot_grid*(window_around_event+1)])
set(fh4,'YTick',[0.5: num_singleEvent_freqs2plot:to_plot_grid*num_singleEvent_freqs2plot])
set(fh4,'YTickLabel','')
set(fh4,'XTickLabel','')
set(fh4,'LineWidth',1)
set(fh4,'GridLineStyle','-')
title('Single Event Time Frequency Plot')
%set(fh4,'CurrentAxes',z)
%%
%EVENT COUNTER PLOT
%fh5 = figure(5);
set(0,'currentfigure',handles.figure1);
set(handles.figure1,'CurrentAxes',handles.eventCounter); cla
fh5=handles.eventCounter;
title('Number of events vs matlab loop counter')
set(fh5,'XTick',[0:100])
set(fh5,'YTick',[0:100])
set(fh5,'XTickLabel',[])
set(fh5,'YTickLabel',[])
%%
%SINGLE STACKED PLOT
fh6 = figure(6); clf %single stacked plot
z=axes('Position',[.1 .1 .85 .85],'visible','off');
set(fh6,'DefaultAxesxtick',[0.5: (window_around_event+1):to_plot_grid*(window_around_event+1)])
set(fh6,'DefaultAxeslinewidth',1)
set(fh6,'DefaultAxesyticklabel','')
set(fh6,'DefaultAxesxticklabel','')
set(fh6,'DefaultAxesgridlinestyle','-')
set(fh6, 'Name','Single Stacked','NumberTitle','off')
set(fh6,'CurrentAxes',z);

%%
% coordinates for the electrode numbers
fig_num_y = [1.1:num_avgEvent_freqs2plot:to_plot_grid*num_avgEvent_freqs2plot];
fig_num_y = reshape(repmat(fig_num_y,[to_plot_grid 1]),number_of_electrodes_total,1);
fig_num_x = [.5:(window_around_event+1):to_plot_grid*(window_around_event+1)];
fig_num_x = reshape(repmat(fig_num_x,[1 to_plot_grid]),number_of_electrodes_total,1);
fig_nums = {};
for i = 1:number_of_electrodes_total
    fig_nums = [fig_nums {num2str(i)}];
end

% coordinates for the dash lines
avgfig_dash_y = repmat([0 num_avgEvent_freqs2plot*to_plot_grid],to_plot_grid,1)';
sigfig_dash_y = repmat([0 num_singleEvent_freqs2plot*to_plot_grid],to_plot_grid,1)';
fig_dash_x = repmat([round((window_around_event+1)/2):window_around_event+1:to_plot_grid*window_around_event],2,1);

%%

pth = pwd;
%addpath([pth filesep 'movie']);
%rehash path;


% Variables
calculated_baseline_flag = 1;
desired_ANchan=1;

event_flag =1;
single_event_flag=1;
single_stacked_flag=1;

sampling_rate = 500;
time2collectBaseline = 30;
number_of_sec2read = 1;
window_around_event = sampling_rate;
num_singleEvent_freqs2plot = 7;
singleEvent_freqs2plot = 1:7;
num_avgEvent_freqs2plot = 7;
avgEvent_freqs2plot= 1:7;
desired_freq_plot = 6; % normally set to 5
integration_time = .1;
number_of_electrodes_total = size(gdat,1);
freq_band_singlestacked = 6;
to_plot_grid = sqrt(size(gdat,1));  % if 256, will plot 16x16 grid

%%
points_needed4baseline = sampling_rate*time2collectBaseline;
number_of_points2read = sampling_rate*number_of_sec2read;

index = 1:number_of_points2read:length(gdat);


fig_num_x = [10:(window_around_event+1):to_plot_grid*(window_around_event+1)];
fig_num_x = reshape(repmat(fig_num_x,[1 to_plot_grid]),number_of_electrodes_total,1);
fig_nums = {};
for i = 1:number_of_electrodes_total
    fig_nums = [fig_nums {num2str(i)}];
end

fig_num_x_cont = [0:to_plot_grid-1]+.55;
fig_num_x_cont = reshape(repmat(fig_num_x_cont,[1 to_plot_grid]),number_of_electrodes_total,1);
fig_num_y_cont = [0:to_plot_grid-1]+.63;
fig_num_y_cont = reshape(repmat(fig_num_y_cont,[to_plot_grid 1]),number_of_electrodes_total,1);


fig_dash_x = repmat([round((window_around_event+1)/2):window_around_event+1:to_plot_grid*window_around_event],2,1);




if calculated_baseline_flag==0
    figure(6);
    subplot(2,1,1); plot(squeeze(gdat(1,1,:)));
    subplot(2,1,2); plot(analog_dat(desired_ANchan,:));
    disp(['Points needed for 1 sec of data: ' num2str(sampling_rate)])
    start = input('Start of baseline index: ');
    final = input('End of baseline index: ');
    BaselineDataMAT = gdat(:,:,start:final);
    [averages, stdevs, medians]=calculate_baseline(BaselineDataMAT, ...
        sampling_rate, number_of_sec2read);
end

m = medians(:,:,1);
m = repmat(m, [1 1 length(gdat)]);
logGdat = log(abs(gdat)+m+eps);

matlab_loopCounter = 0;
eventRelatedAvg=[];
num_samples=0;
last_used_ind=0;

%%
profile on;
good_event_count=0;
for i = 1:length(index)-1
    LogNewData = logGdat(:,:,index(i):index(i+1)-1);
    
    %continual plotting
    
    %%
    %Plot continual plot
    %continual plotting
    set(0,'currentfigure',handles.figure1);
    set(handles.figure1,'CurrentAxes',fh2)
    runningAverage = squeeze(mean(LogNewData(:, desired_freq_plot, (end-integration_time*sampling_rate):end),3));
    ZscoreNewData=(runningAverage-averages(:,desired_freq_plot,1))./stdevs(:,desired_freq_plot,1);
    imagesc(real(reshape(ZscoreNewData,to_plot_grid,to_plot_grid))', [-7 7]);
    drawnow;
    %%
    %Plot event counter
    if event_flag ==1
        % reshape ANdata by chan x time
        ANNewDataMAT=reshape(ANNewData,ANnumber_of_channels, ANnumber_of_points2read/ANnumber_of_channels);
        
        % Place data into MATLAB buffers
        % finalPos = posInNewData_AfterCAR+sampling_rate*number_of_sec2read-1;
        finalPos = posInNewData_AfterCAR + number_of_points2read/(num_freq_bands*number_of_channels) - 1;
        ANfinalPos = ANposInNewData + ANnumber_of_points2read/ANnumber_of_channels - 1;
        
        DataAfterCAR(:,:,posInNewData_AfterCAR:finalPos)=LogNewData;
        ANNewData_finalMAT(:,ANposInNewData:ANfinalPos)=ANNewDataMAT;
        %%
        %find events
        event=(ANNewData_finalMAT(desired_ANchan,:)>threshold);
        trigger=(diff(event)>0);
        detected_num_events = sum(trigger);
        
        
        set(0,'currentfigure',handles.figure1);
        set(handles.figure1,'CurrentAxes',fh5);
        hold on
        plot(matlab_loopCounter,detected_num_events,'*');
        grid on;
        
        
        %%
        %Plot average spectrogram
        if detected_num_events>0 && event_flag == 1
            
            %%% PARSE EVENTS HERE
            [num_events,indLastEvent,eventIndices] = ...
                parseEvents(ANNewData_finalMAT, ANfinalPos, desired_ANchan,...
                desired_ANchan2, threshold, threshold2, sampling_rate, prev_num_events,...
                indLastEvent, eventIndices, number_of_analog);
            
            if num_events>prev_num_events
                % num_events is #events after removing ones within 1 second, intialized to 0
                prev_num_events = num_events;
                newEventFlag=1;
            else
                newEventFlag=0;
            end
            
            if  newEventFlag==1 && number_of_analog ==1
                %%% RUN OLD AVERAGE CODE
                %{
                            Note: Can also get rid of num_samples,
                            old_num_samples like what I did with average_event_window_2_events
                            
                            PS Note: we should test this new implementation
                            in the simulator to make sure num_samples and old_num_samples
                            is really the same as good_event_count and current_num_events
                %}
                [eventRelatedAvg,num_samples,last_used_ind,allStacked,new_plot_flag,good_event_count] = average_event_window_angela(num_events, ind, window_around_event,...
                    DataAfterCAR,finalPos(1),number_of_electrodes_total,...
                    num_avgEvent_freqs2plot, avgEvent_freqs2plot,...
                    eventRelatedAvg, num_samples, last_used_ind,allStacked,good_event_count, averages, stdevs);
                
                
            elseif newEventFlag==1 && number_of_analog ==2
                
                
                [eventRelatedAvg,last_used_ind,allStacked,new_plot_flag,current_num_events,lastSpec,lastSpec_event2,eventRelatedAvg2] =...
                    average_event_window_2_events(num_events, event_indices, window_around_event,window_after_event,...
                    DataAfterCAR,finalPos(1),number_electrodes ,num_freq_bands, freqs2plot,...
                    old_average, last_used_ind,allStacked,good_event_count, averages, stdevs,old_average_event2,lastSpec_event2, freq_band_singlestacked)
            end
            
            if  new_plot_flag==1 & newEventFlag==1
                
                %Plot new event count in red
                set(0,'currentfigure',handles.figure1);
                set(handles.figure1,'CurrentAxes',fh5)
                hold on
                plot(matlab_loopCounter,good_event_count,'r*');
                
                %%
                %Plot average Spectrogram(s) around event(s)
                %always plot average spectrogram aligned
                %around event 1
                
                
                if number_of_analog ==2
                    ZscoreEventRelatedAvg=(eventRelatedAvg-averages)./stdevs;
                    to_plot=  reshape_3Ddata(ZscoreEventRelatedAvg, window_before_event*2,...
                        num_avgEvent_freqs2plot, to_plot_grid);
                    to_plot = artifactrejection(to_plot, window_before_event*2,-1.5, 1.5, .5, .8, to_plot_grid);
                    
                    set(0,'currentfigure',fh)
                    imagesc(real(to_plot),[-3 3]);
                    text(fig_num_x2, fig_num_y2, fig_nums)
                    line(fig_dash_x2,avgfig_dash_y2,'LineStyle','--','linewidth',1','color',[0 0 0]);
                    grid on;
                    drawnow;
                    
                    ZscoreEventRelatedAvg=(eventRelatedAvg2-averages)./stdevs;
                    to_plot=  reshape_3Ddata(ZscoreEventRelatedAvg, window_before_event*2,...
                        num_avgEvent_freqs2plot, to_plot_grid);
                    to_plot = artifactrejection(to_plot, window_before_event*2,-1.5, 1.5, .5, .8, to_plot_grid);
                    
                    %Plot average spectrogram aligned at
                    %event 2
                    set(0,'currentfigure',fh_event2)
                    imagesc(real(to_plot),[-3 3]);
                    text(fig_num_x2, fig_num_y2, fig_nums)
                    line(fig_dash_x2,avgfig_dash_y2,'LineStyle','--','linewidth',1','color',[0 0 0]);
                    grid on;
                    drawnow;
                else
                    ZscoreEventRelatedAvg=(eventRelatedAvg-averages)./stdevs;
                    
                    to_plot=  reshape_3Ddata(ZscoreEventRelatedAvg, window_around_event,...
                        num_avgEvent_freqs2plot, to_plot_grid);
                    to_plot = artifactrejection(to_plot, window_around_event,-1.5, 1.5, .5, .8, to_plot_grid);
                    
                    set(0,'currentfigure',fh)
                    imagesc(real(to_plot),[-3 3]);
                    text(fig_num_x, fig_num_y, fig_nums)
                    line(fig_dash_x,avgfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);
                    grid on;
                    drawnow;
                end
                
                
                %%
                %Plot last spectrogram
                ZscoreLastEvent=tmp;
                
                to_plot = reshape_3Ddata(ZscoreLastEvent, window_around_event,...
                    num_singleEvent_freqs2plot, to_plot_grid);
                
                set(0,'currentfigure',handles.figure1);
                set(handles.figure1,'CurrentAxes',fh4)
                imagesc(real(to_plot),[-7 7]);
                text(fig_num_x, fig_num_y, fig_nums)
                line(fig_dash_x,sigfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);
                set(fh4,'Xtick',[0.5: (window_around_event+1):to_plot_grid*(window_around_event+1)])
                set(fh4,'YTick',[0.5: num_singleEvent_freqs2plot:to_plot_grid*num_singleEvent_freqs2plot])
                set(fh4,'YTickLabel','')
                set(fh4,'XTickLabel','')
                set(fh4,'LineWidth',1)
                set(fh4,'GridLineStyle','-')
                grid on;
                drawnow;
                %%
                %plot single stacked
                
                to_plot=allStacked(:,1:good_event_count,:);
                
                set(fh6,'DefaultAxesytick',[0.5: good_event_count:to_plot_grid*good_event_count])
                set(0,'currentfigure',fh6);
                
                %Will reshape functions work with longer
                %window after first event?
                flattened = reshape_3Ddata(to_plot, window_around_event,good_event_count, to_plot_grid);
                
                to_plot = artifactrejection(flattened, window_around_event,-5.5, 5.5, .5, .8, to_plot_grid);
                imagesc(real(to_plot),[-7 7]);
                if good_event_count >1
                    fig_num_y_stacked = [1.1:good_event_count:to_plot_grid*good_event_count];
                    fig_num_y_stacked = reshape(repmat(fig_num_y_stacked, [to_plot_grid 1]), number_of_electrodes_total, 1);
                    text(fig_num_x, fig_num_y_stacked, fig_nums)
                    stackedfig_dash_y = repmat([0 good_event_count*to_plot_grid],to_plot_grid,1)';
                    line(fig_dash_x,stackedfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);
                end
                grid on
                
            end
            %end
        end
        
    end
    matlab_loopCounter=matlab_loopCounter+1;
end

profile off
keyboard
uisave({'avg_to_plot', 'finalstackeddata', 'sing_to_plot'}, 'to_plot')


function [average,num_samples,last_used_ind] = average_event_window(num_events, ind, window_around_event,...
    DataAfterCAR,AmountOfData,number_electrodes ,num_freq_bands, freqs2plot,...
    old_average, old_num_samples, last_used_ind)

%allocate memory, set up counter
average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
sum_windows = zeros(number_electrodes,num_freq_bands, window_around_event+1);
num_samples = 0;

if isempty(old_average)
    old_average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
end
if isempty(find(ind==last_used_ind))==1
    x=0;
else
    x=find(ind==last_used_ind);
end
%loop over each event, grab corresponding window
for i=(x+1):num_events
    beginning = ind(i) - window_around_event/2;
    last = ind(i)+ window_around_event/2;
    if beginning <1 || last>AmountOfData
        continue; %since can't add different sized window, just ignore
    end
    timepts = beginning:last;
    sum_windows = sum_windows + DataAfterCAR(:,freqs2plot, timepts);
    num_samples = num_samples + 1;
    last_used_ind = ind(i);
end;
if num_samples>0
    num_samples = num_samples+old_num_samples;
    average = (old_average*old_num_samples + sum_windows)/(num_samples);
else
    average = old_average;
    num_samples = old_num_samples;
end

%%%%

%%
function [average,num_samples,last_used_ind,allStacked,new_plot_flag,current_num_events] = average_event_window_angela(num_events, ind, window_around_event,...
    DataAfterCAR,AmountOfData,number_electrodes ,num_freq_bands, freqs2plot,...
    old_average, old_num_samples, last_used_ind,allStacked,prev_num_events, averages, stdevs)

%allocate memory, set up counter
current_num_events=prev_num_events;
average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
sum_windows = zeros(number_electrodes,num_freq_bands, window_around_event+1);
num_samples = 0;

if isempty(old_average)
    old_average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
end
if isempty(find(ind==last_used_ind))==1
    x=0;
else
    x=find(ind==last_used_ind);
end
%loop over each event, grab corresponding window
new_count=0;
for i=(x+1):num_events
    beginning = ind(i) - window_around_event/2;
    last = ind(i)+ window_around_event/2;
    if beginning <1 || last>AmountOfData
        continue; %since can't add different sized window, just ignore
    end
    new_count=new_count+1;
    timepts = beginning:last;
    lastSpec=DataAfterCAR(:,freqs2plot, timepts);
    sum_windows = sum_windows + DataAfterCAR(:,freqs2plot, timepts);
    num_samples = num_samples + 1;
    last_used_ind = ind(i);
    current_num_events=prev_num_events+new_count;
    tmp=(lastSpec-averages)./stdevs;
    allStacked(:,current_num_events,:)=(lastSpec(:,6,:)-averages(:,6))/stdevs(:,6);
    %allStacked(:,:,:,current_num_events)=tmp;
    new_plot_flag=1;
end;
if num_samples>0
    num_samples = num_samples+old_num_samples;
    average = (old_average*old_num_samples + sum_windows)/(num_samples);
else %if no new events
    average = old_average;
    num_samples = old_num_samples;
    new_plot_flag=0;
end

function [average,num_samples,last_used_ind,allStacked,new_plot_flag,current_num_events,tmp] = average_event_window_angela2(num_events, ind, window_around_event,...
    DataAfterCAR,AmountOfData,number_electrodes ,num_freq_bands, freqs2plot,...
    old_average, old_num_samples, last_used_ind,allStacked,prev_num_events, averages, stdevs)

%allocate memory, set up counter
tmp=[];
current_num_events=prev_num_events;
average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
sum_windows = zeros(number_electrodes,num_freq_bands, window_around_event+1);
num_samples = 0;

if isempty(old_average)
    old_average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
end
if isempty(find(ind==last_used_ind))==1
    x=0;
else
    x=find(ind==last_used_ind);
end
%loop over each event, grab corresponding window
new_count=0;
for i=(x+1):num_events
    beginning = ind(i) - window_around_event/2;
    last = ind(i)+ window_around_event/2;
    if beginning <1 || last>AmountOfData
        continue; %since can't add different sized window, just ignore
    end
    new_count=new_count+1;
    timepts = beginning:last;
    lastSpec=DataAfterCAR(:,freqs2plot, timepts);
    sum_windows = sum_windows + DataAfterCAR(:,freqs2plot, timepts);
    num_samples = num_samples + 1;
    last_used_ind = ind(i);
    current_num_events=prev_num_events+new_count;
    tmp=(lastSpec-averages)./stdevs;
    allStacked(:,current_num_events,:)=(lastSpec(:,6,:)-averages(:,6,:))./stdevs(:,6,:);
    %allStacked(:,:,:,current_num_events)=tmp;
    new_plot_flag=1;
end;
if num_samples>0
    num_samples = num_samples+old_num_samples;
    average = (old_average*old_num_samples + sum_windows)/(num_samples);
else %if no new events
    average = old_average;
    num_samples = old_num_samples;
    new_plot_flag=0;
end



% aviobj_sing = close(aviobj_sing);
% aviobj_avg = close(aviobj_avg);
% aviobj_Cont = close(aviobj_Cont);
% aviobj_stacked = close(aviobj_stacked);
%{
%**************
function [average,num_samples,last_used_ind,lastSpec,stackedAll, current_num_events] = average_event_window(num_events, ind, window_around_event,...
    DataAfterCAR,AmountOfData,number_electrodes ,num_freq_bands, freqs2plot,...
    old_average, old_num_samples, last_used_ind,stackedAll,prev_num_events, stacked_freq_band,stdevs,averages)

%allocate memory, set up counter
current_num_events=prev_num_events;
average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
sum_windows = zeros(number_electrodes,num_freq_bands, window_around_event+1);
num_samples = 0;

if isempty(old_average)
    old_average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
end
if isempty(find(ind==last_used_ind))==1
    x=0;
else
    x=find(ind==last_used_ind);
end
%loop over each event, grab corresponding window

for i=(x+1):num_events
    beginning = ind(i) - window_around_event/2;
    last = ind(i)+ window_around_event/2;
    if beginning <1 || last>AmountOfData
        continue; %since can't add different sized window, just ignore
    end
    timepts = beginning:last;
    lastSpec=DataAfterCAR(:,freqs2plot, timepts);
    sum_windows = sum_windows + DataAfterCAR(:,freqs2plot, timepts);
    num_samples = num_samples + 1;
    last_used_ind = ind(i);
    current_num_events=prev_num_events+i;
    stackedAll(:,num_events,:)=lastSpec(:,stacked_freq_band,:)-averages(:,stacked_freq_band,:)./stdevs(:,stacked_freq_band,:);
end;
if num_samples>0
    num_samples = num_samples+old_num_samples;
    average = (old_average*old_num_samples + sum_windows)/(num_samples);
else %if no new events
    average = old_average;
    num_samples = old_num_samples;
    lastSpec=0;
end
%}


%%%%
%{
function true_average = average_event_window2(num_events, ind, window_around_event,...
    DataAfterCAR,AmountOfData,number_electrodes ,num_freq_bands, freqs2plot)
%allocate memory, set up counter

true_average = zeros(number_electrodes,num_freq_bands, window_around_event+1);
sum_windows = zeros(number_electrodes,num_freq_bands, window_around_event+1);
num_samples = 0;

%loop over each event, grab corresponding window
for i=1:num_events
    beginning = ind(i) - window_around_event/2;
    last = ind(i)+ window_around_event/2;
    if beginning <1 || last>AmountOfData
        continue; %since can't add different sized window, just ignore
    end
    timepts = beginning:last;
    sum_windows = sum_windows + DataAfterCAR(:,freqs2plot, timepts);
    num_samples = num_samples + 1;
end;
if num_samples>0
    true_average = sum_windows/num_samples; %size chan x freq x time
end
%}


function single_window = single_event_window(ind, window_around_event,...
    DataAfterCAR,AmountOfData,number_electrodes,num_freq_bands, freqs2plot)

single_window=zeros(number_electrodes,num_freq_bands, window_around_event+1);
if length(ind)>1
    for i=0:1 %plot last one if most recent doesn't work
        beginning = ind(end-i)-window_around_event/2;
        last = ind(end-i)+window_around_event/2;
        if beginning <1 || last > AmountOfData
            continue %since can't add different sized window, just ignore
        else
            timepts = beginning:last;
            single_window=DataAfterCAR(:,freqs2plot,timepts);
            return
        end
    end
end





function to_plot = reshape_3Ddata(to_reshape, window_around_event,...
    num_freq_bands, to_plot_grid)
%to_reshape = chan x freq x timepts

to_plot = zeros(num_freq_bands*to_plot_grid, to_plot_grid*(window_around_event+1));
beginning = 0;

for i = 0:to_plot_grid-1
    last =  beginning+to_plot_grid*(window_around_event+1);
    data = to_reshape(i*to_plot_grid+1:i*to_plot_grid+to_plot_grid,:,:);
    to_plot(i*num_freq_bands+1:i*num_freq_bands+num_freq_bands,:) = ...
        flipud(reshape(shiftdim(data,1),num_freq_bands, to_plot_grid*(window_around_event+1)));
    beginning = last;
    %Grab every eight channels and form to_plot_grid x to_plot_grid square
end

function to_plot = reshape_3Ddata2(to_reshape, window_around_event,...
    num_freq_bands, to_plot_grid)
%to_reshape = chan x freq x timepts

to_plot = zeros(num_freq_bands*to_plot_grid, to_plot_grid*(window_around_event+1));
beginning = 0;

for i = 0:to_plot_grid-1
    last =  beginning+to_plot_grid*(window_around_event+1);
    data = to_reshape(i*to_plot_grid+1:i*to_plot_grid+to_plot_grid,:,:);
    to_plot(i*num_freq_bands+1:i*num_freq_bands+num_freq_bands,:) = ...
        flipud(reshape(shiftdim(data,1),to_plot_grid*(window_around_event+1),num_freq_bands)');
    beginning = last;
    %Grab every eight channels and form to_plot_grid x to_plot_grid square
end


% flatten = [];
% for i =1:number_electrodes
%     if num_freq_bands==1
%         flatten=[flatten squeeze(to_reshape(i,:,:))'];
%     else
%         flatten=[flatten squeeze(to_reshape(i,:,:))]; %size freq x (chan*time)
%     end
% end
% beginning = 0;
% for i = 0:7  %ASSUMES 64 CHANNELS
%     last =  beginning+8*(window_around_event+1);
%     to_plot(i*num_freq_bands+1:i*num_freq_bands+num_freq_bands,:) = ...
%         flatten(:,beginning+1 : last);
%     beginning = last;
%     %Grab every eight channels and form 8 x 8 square
% end






function [averages, stdevs, medians]=calculate_baseline(BaselineDataMAT, ...
    sampling_rate, number_of_sec2read)


medians = median(BaselineDataMAT,3);
logBaselineDataMAT = log(BaselineDataMAT+repmat(medians,[1 1 size(BaselineDataMAT,3)])+eps);

medians=repmat(medians,[1 1 (sampling_rate*number_of_sec2read)]);
averages = repmat(mean(logBaselineDataMAT,3),[1 1 (sampling_rate*number_of_sec2read+1)]);
stdevs = repmat(std(logBaselineDataMAT,0,3),[1 1 (sampling_rate*number_of_sec2read+1)]);


function to_plot = SingleStackedTrials(DataMat, ind, num_events,...
    averages, stdevs, freq_band, window_around_event)
% function to_plot = SingleStackedTrials(DataMat, ind, ...
%   averages, stdevs, freq_band, window_around_event)
% Creates z-scored matrix (num_events x time) for ONE channel. Each row
% represents zscore data for one event
%
% DataMat - Chan x freq x time (envelope of raw data)
% AnalogData - event data
% AnalogDataChan
% freq_band
% windowaroundevent
% averages, stdevs = baseline stats

% format data, take log of it, extract Chan, freq_band
Data = DataMat(:, freq_band,:);

% format statistics, extract Chan, freq_band
averages = squeeze(averages(:, freq_band, :));
stdevs = squeeze(stdevs(:, freq_band,:));


%allocate memory
AmountOfData = length(Data);
to_plot = zeros(size(Data,1),num_events,window_around_event+1);
empty_trials = [];

%loop through every event and extract data around event
for i=1:num_events
    beginning = ind(i) - window_around_event/2;
    last = ind(i)+ window_around_event/2;
    if beginning <1 || last>AmountOfData
        empty_trials = [empty_trials i];
        continue; %since can't use different sized window, just ignore
    end
    timepts = beginning:last;
    zscored_logGdat = (Data(:,timepts)-averages)./stdevs;
    to_plot(:,i,:) = zscored_logGdat;
    
end

to_plot(:,empty_trials, :) = [];

function to_plot = artifactrejection(reshaped_data, window_around_event,...
    min_zscore, max_zscore, percentage_min, percentage_max, to_plot_grid)
%reshaped data = freqs2plot*8 x window_around_event+1*8
%
%  if more than percentage_min% of the data is below min_zscore, reject
%  if more than percentage_max%of the data is above max_zscore, reject

rows = size(reshaped_data,1);
cols = 1:window_around_event+1:to_plot_grid*window_around_event;
to_plot = reshaped_data;
for i = 1:rows
    for j = 1:to_plot_grid
        k = cols(j):cols(j)+(window_around_event+1)-1;
        if (sum(reshaped_data(i,k)<min_zscore)>=percentage_min*(window_around_event+1) ||...
                sum(reshaped_data(i,k)>max_zscore)>=percentage_max*(window_around_event+1))
            to_plot(i,k)=zeros(1,window_around_event+1);
        end
    end
end




