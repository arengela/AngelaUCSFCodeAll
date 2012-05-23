sampling_rate = 500;
number_of_channels = 16;
ANnumber_of_channels = 4;
number_of_sec2read = 2; %******Does this need to change?
dANproj_name =  {'motormap.danin'};
sANproj_name =  {'motormap.sanin'};
integration_time = .1;
avgEvent_freqs2plot = 1:7;
singleEvent_freqs2plot = 1:7;
num_freq_bands = 7;
window_before_event=250;
if number_of_analog==2
    window_after_event=window_before_event+2.5*500;
else
    window_after_event=window_before_event;
end
gdat = Envelope(:,:,start_ind:end);
analog_dat = AnalogData(:,start_ind:end);
window_around_event=window_before_event+window_after_event;
    
    

% Flags
event_flag = 1;  % Average plot
calculated_baseline_flag = get(handles.calculated_baseline_flag,'Value');



% Retrieve from GUI
time2collectBaseline = str2num(get(handles.time2collectBaseline,'String'));
desired_freq_plot = str2num(get(handles.desired_freq_plot,'String'));
freq_band_singlestacked = str2num(get(handles.freq_band_singlestacked,'String'));
desired_ANchan = str2num(get(handles.desired_ANchan,'String'));
threshold = str2num(get(handles.threshold,'String'));
subj_id = get(handles.subj_id,'String');
elec_tmp = get(handles.get_total_electrodes,'String');
number_of_electrodes_total=str2num(elec_tmp{get(handles.get_total_electrodes,'Value')});
number_of_analog=str2num(elec_tmp{get(handles.get_num_analog,'Value')});
%allStacked=zeros(number_of_electrodes_total,num_freq_bands,window_around_event+1,50);
allStacked=zeros(number_of_electrodes_total,50,window_around_event+1);


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

if number_of_analog==2
    desired_ANchan2 = str2num(get(handles.desired_ANchan2,'String'));
    threshold2 = str2num(get(handles.threshold2,'String'));
else
    desired_ANchan2 = [];
    threshold2 = [];
end



% Calculate
points_needed4baseline = sampling_rate*time2collectBaseline*number_of_channels *num_freq_bands;
number_of_points2read = sampling_rate*number_of_sec2read*number_of_channels*num_freq_bands;
ANnumber_of_points2read = sampling_rate*number_of_sec2read*ANnumber_of_channels;
num_avgEvent_freqs2plot = length(avgEvent_freqs2plot);
num_singleEvent_freqs2plot = length(singleEvent_freqs2plot);

%%
%setPlots;
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
set(fh,'DefaultAxesxtick',[0.5: (window_before_event*2+1):to_plot_grid*(window_before_event*2+1)])
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
%Make figure for average spectrogram of 2nd event
if analoginput==2
    fh_event2=figure(7);clf;      
    z=axes('Position',[.1 .1 .85 .85],'visible','off');
    set(fh_event2,'DefaultAxesxtick',[0.5: (window_before_event*2+1):to_plot_grid*(window_before_event*2+1)])
    set(fh_event2,'DefaultAxesytick',[0.5: num_avgEvent_freqs2plot:to_plot_grid*num_avgEvent_freqs2plot])
    set(fh_event2,'DefaultAxesyticklabel','')
    set(fh_event2,'DefaultAxesxticklabel','')
    set(fh_event2,'DefaultAxeslinewidth',1)
    set(fh_event2,'DefaultAxesgridlinestyle','-')
    set(fh_event2, 'Name','Average Event Time Frequency Plot','NumberTitle','off')
    set(fh_event2,'CurrentAxes',z);
end

%%
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
