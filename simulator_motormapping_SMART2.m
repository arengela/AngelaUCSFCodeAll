function simulator_motormapping_SMART
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

close all

[filename, pth] = uigetfile('*', 'Load tdt data mat');
load([pth filename])
a = pwd;
%load DataMAT

[filename, pth] = uigetfile('*', 'Load start index and threshold');
load([pth filename])
gdat = Envelope(:,:,start_ind:end);
analog_dat = AnalogData(:,start_ind:end);

% gdat = Envelope;
% analog_dat = AnalogData;
clear Envelope AnalogData RawData

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

if calculated_baseline_flag==1
    [filename, pth] = uigetfile('*', 'Load baseline');
    load([pth filename])
end
%  aviobj_Cont = avifile('GP25_B6_continual');
%  aviobj_sing = avifile('GP25_B6_singleEvent');
%  aviobj_avg = avifile('GP25_B6_avgEvent');
%  aviobj_stacked = avifile('GP25_B6_HAND_stacked6');

fh=figure(2);% figure for average event trigger analysis, 8x8
set(fh, 'Name','Average Event Time Frequency Plot','NumberTitle','off')


fh4=figure(4); % figure for single event trigger analysis, 8x8
set(fh4, 'Name','Single Event Time Frequency Plot','NumberTitle','off')


fh5 = figure(5);
set(fh5, 'Name','Number of events vs matlab loop counter','NumberTitle','off')


fh2 = figure(3);
set(fh2,'DefaultAxesxtick',[0.5:to_plot_grid])
set(fh2,'DefaultAxesytick',[0.5:to_plot_grid])
set(fh2,'DefaultAxeslinewidth',1)
set(fh2,'DefaultAxesgridlinestyle','-')
set(fh2,'DefaultAxesFontweight','bold')
set(fh2','DefaultAxesxticklabel',[])
set(fh2,'DefaultAxesyticklabel',[])
set(fh2, 'Name', 'Continual Plot','NumberTitle','off')

fh6=figure(6); %Stacked plot
axes('Position',[0 0 1 1],'visible','off') %Labeling of graph with second axes
%x labels
y=.08*ones(1,17);

text([.10,.1457,.1684,.2363,.2590,.3270,.3497,.4176,.4405,.5090,.5316,.5996,.6222,.6902,.7129,.7809,.8189] ,y,{'-.5',...
    '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5'},...
    'fontsize',8, 'fontweight', 'bold','fontname', 'gill sans')
z=axes('Position',[.1 .1 .85 .85]);
set(fh6,'DefaultAxesgridlinestyle','-')
set(fh6,'DefaultAxesFontweight','bold')
set(fh6, 'Name', 'Single Stacked Plot: 110-179 Hz','NumberTitle','off')
set(fh6,'DefaultAxeslinewidth',1)
set(fh6,'DefaultAxesgridlinestyle','-')
set(fh6,'DefaultAxesFontweight','bold')
set(fh6,'DefaultAxesxticklabel',[])
set(fh6,'DefaultAxesyticklabel',[])
set(fh6, 'currentaxes', z)


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


for i = 1:length(index)-1
    LogNewData = logGdat(:,:,index(i):index(i+1)-1);
    
    %continual plotting
    set(0,'currentfigure',fh2);
    runningAverage = squeeze(mean(LogNewData(:, desired_freq_plot, (end-integration_time*sampling_rate):end),3));
    ZscoreNewData=(runningAverage-averages(:,desired_freq_plot,1))./stdevs(:,desired_freq_plot,1);
    to_plot=real(reshape(ZscoreNewData,to_plot_grid,to_plot_grid))';
    imagesc(to_plot,[-4 4])
    grid on
    
    text(fig_num_x_cont, fig_num_y_cont, fig_nums)
    
    cbar_handle=colorbar('yticklabel',[-4 -2 0 2 4],'ytick',[-4 -2 0 2 4]);
    set(get(cbar_handle,'ylabel'),'string','z-score')
%     drawnow;
    set(gcf,'Color',[1,1,1])
    
    %F = getframe(fh2);
    %     aviobj_Cont = addframe(aviobj_Cont,F);
    
    if event_flag ==1 || single_event_flag==1 || single_stacked_flag==1
        ANNewData_finalMAT = analog_dat(:,1:index(i+1)-1);
        DataAfterCAR = logGdat(:,:,1:index(i+1)-1);
        %event average plot
        %find events
        event=(ANNewData_finalMAT(desired_ANchan,:)>threshold);
        trigger=(diff(event)>0);
        
        detected_num_events = sum(trigger);
        set(0,'currentfigure',fh5);
        plot(matlab_loopCounter,sum(trigger),'*');
        grid on;
        hold on;
        
       
        if detected_num_events>0 && event_flag == 1
            
            ind = find(trigger,detected_num_events);
            ind(find([0 diff(ind)<(sampling_rate*1)]))=[]; %no events within 1 sec...
            %of each other will be acknowledged
            num_events = length(ind);
            
            [eventRelatedAvg,num_samples,last_used_ind] = average_event_window(num_events, ind, window_around_event,...
                DataAfterCAR, length(DataAfterCAR),number_of_electrodes_total,...
                num_avgEvent_freqs2plot, avgEvent_freqs2plot,...
                eventRelatedAvg, num_samples, last_used_ind);
            
            ZscoreEventRelatedAvg=(eventRelatedAvg-averages)./stdevs;
            to_plot=  reshape_3Ddata(ZscoreEventRelatedAvg, window_around_event,...
                num_avgEvent_freqs2plot, to_plot_grid);
            
            
            to_plot = artifactrejection(to_plot, window_around_event,-1.5, 1.5, .5, .8, to_plot_grid);
            
            avg_to_plot(:,:,num_events) = to_plot;
            
            set(0,'currentfigure',fh);
            plot_8x8grid(to_plot, fh, num_avgEvent_freqs2plot, window_around_event, [-3 3], to_plot_grid)


            %             F = getframe(fh);
            %             aviobj_avg = addframe(aviobj_avg,F);
        end
        if detected_num_events>0 && single_event_flag == 1
            ind = find(trigger, detected_num_events);
            ind(find([0 diff(ind)<(sampling_rate*1)]))=[]; %no events within 1 sec...
            %of each other will be acknowledged
            num_events = length(ind);
            set(0,'currentfigure',fh5);
            plot(matlab_loopCounter,num_events,'r*');
            
            lastEvent = single_event_window(ind, window_around_event,...
                DataAfterCAR, length(DataAfterCAR),number_of_electrodes_total,...
                num_singleEvent_freqs2plot, singleEvent_freqs2plot);
            ZscoreLastEvent=(lastEvent-averages)./stdevs;
            to_plot = reshape_3Ddata(ZscoreLastEvent, window_around_event,...
                num_singleEvent_freqs2plot, to_plot_grid);
            
            
            sing_to_plot(:,:,num_events) = to_plot;
           
            set(0,'currentfigure',fh4)
            plot_8x8grid(to_plot, fh4, num_singleEvent_freqs2plot, window_around_event, [-7 7], to_plot_grid)

            
            %             F = getframe(fh4);
            %             aviobj_sing = addframe(aviobj_sing,fh4);
        end
        if detected_num_events>0 && single_stacked_flag ==1
            ind = find(trigger,detected_num_events);
            ind(find([0 diff(ind)<(sampling_rate*1)]))=[]; %no events within 1 sec...
            %of each other will be acknowledged
            num_events = length(ind);
            to_plot= SingleStackedTrials(DataAfterCAR, ind, num_events,...
                averages, stdevs, freq_band_singlestacked, window_around_event);
            num_events = size(to_plot,2);
            
            set(fh6,'DefaultAxesxtick',[0.5: (window_around_event+1):to_plot_grid*(window_around_event+1)])
            set(fh6,'DefaultAxesytick',[0.5: num_events:to_plot_grid*num_events])
            set(0,'currentfigure',fh6);
            
            flattened = reshape_3Ddata(to_plot, window_around_event,num_events, to_plot_grid);
            
            to_plot = artifactrejection(flattened, window_around_event,-5.5, 5.5, .5, .8, to_plot_grid);
            
            finalstackeddata = to_plot;
            
            imagesc(real(to_plot),[-7 7]);
            grid on
            
            %title('Single Stacked Trials: 110-179 Hz','fontweight','bold','fontsize',10)
            cbar_handle = colorbar('yticklabel',[-7 -3 0 3 7],'ytick',[-7 -3 0 3 7]);
            xlabel('Time (s)')
%             set(get(cbar_handle,'ylabel'))
            set(gcf,'Color',[1,1,1])
            
            if num_events >5 %1
                fig_num_y_stacked = [4.9:num_events:to_plot_grid*num_events];
                fig_num_y_stacked = reshape(repmat(fig_num_y_stacked, [to_plot_grid 1]), number_of_electrodes_total, 1);
                text(fig_num_x, fig_num_y_stacked, fig_nums)
                stackedfig_dash_y = repmat([0 num_events*to_plot_grid],to_plot_grid,1)';
                line(fig_dash_x,stackedfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);
            end
            %             F = getframe(fh6);
            %aviobj_stacked = addframe(aviobj_stacked,F);
        end
    end
    matlab_loopCounter = matlab_loopCounter+1;
    pause(.02)
end

cd(a);
uisave({'avg_to_plot', 'finalstackeddata', 'sing_to_plot'}, 'to_plot')



% aviobj_sing = close(aviobj_sing);
% aviobj_avg = close(aviobj_avg);
% aviobj_Cont = close(aviobj_Cont);
% aviobj_stacked = close(aviobj_stacked);
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




