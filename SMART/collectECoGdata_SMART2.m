function collectECoGdata_SMART
%last modified:
%   Connie Cheung, Jan 17, 2011
%
%function collectECoGdata_SMART
%
% faster average, arifact rejection, GUIde, 64 or 256 channels
%
% 1) plots continual to_plot_grid electrodes (last mean(integration time)) in frequency
% indicated by variable desired_freq plot
% 2) plots single event power/time plot
% 3) plots average event power/time plot
% 4) plots stacked single trials
%
pth = pwd;
%addpath([pth filesep 'movie']);
%rehash path;

close all
delete variables.mat
delete start.mat

%f = smartGUI;
start_flag = 0;
while start_flag == 0
    if ~ishandle(f)
        error('figure closed')
    end
    try
        load variables.mat
        pause(.5)
        load start.mat
    end
    pause(.5)
end



%%
if calculated_baseline_flag==1
    %load baseline_stats
    uiopen('load')
end

bufferCounter = zeros(1,size(dproj_name,1));
ANbufferCounter = 0;
matlab_loopCounter = 0;
num_samples=0; %used to calculate faster average
last_used_ind=0;  %used to calculate faster average
eventRelatedAvg=[];
imagecount=ones(1,3);
DETECTED=1;
plotted=0;
%creates buffer of 5 minutes
if event_flag ==1 || single_event_flag==1
    DataAfterCAR=zeros(number_of_electrodes_total, num_freq_bands, 4*60*sampling_rate);%electrode# by freqband# by samples
    ANNewData_finalMAT=zeros(ANnumber_of_channels, 4*60*sampling_rate); %analog buffer 
end

DA = actxcontrol('TDevAcc.X');% Loads ActiveX methods
if DA.ConnectServer('Local')>0 %Checks to see if there is an OpenProject and Workbench load
    if DA.SetSysMode(3)==1%Starts OpenEx project running and acquiring data. 1 = Standby, 2 = Preview, !!MUST CHANGE TO 3 WHEN RECORDING
        if DA.GetSysMode>1 % Checks to see if the Project is running
            if not(isnan(DA.ReadTargetVEX(dproj_name{1},0,10,'F32','F64'))) %checks to see if it loaded the correct project
                for i=1:length(dproj_name)
                    BufferSize(i)=DA.GetTargetSize(dproj_name{i});% returns the Buffer size (bookkeeping)
                end
                if event_flag==1 || single_event_flag==1
                    ANBufferSize=DA.GetTargetSize(dANproj_name{1});% returns the Analog Buffer size (bookkeeping)
                    ANoldAcqPos=ANBufferSize;
                end
                oldAcqPos=BufferSize;
                
                %%
                %Main Loop Extracting and Plotting Data
                %if DA.GetSysMode==0, then means tdt is not recording or prj not working
                while DA.GetSysMode>1
                    loop=tic%**************
                    begin=tic
                    if calculated_baseline_flag==0
                        %collects baseline block
                        [averages, stdevs, medians]=calculate_baseline(time2collectBaseline, ...
                            sproj_name,dproj_name, points_needed4baseline, BufferSize, DA, number_of_channels, ...
                            num_freq_bands, sampling_rate,number_of_sec2read);
                        %                         set(hcalculated_baseline_flag,'value',1)
                        % save baseline_stats averages stdevs medians
                        pause(1)
                        uisave({'averages' 'stdevs' 'medians'}, ['baseline_stats_' subj_id])
                        calculated_baseline_flag=1;
                    end
                    
                    % resets and ensures timing of matlab and tdt buffers
                    AcqPos=AcquirePosition(sproj_name, number_of_points2read, BufferSize, DA);
                    if event_flag==1 || single_event_flag==1
                        ANAcqPos=AcquirePosition(sANproj_name, ANnumber_of_points2read, ANBufferSize, DA);
                        ANbufferCounter = updateCounter(ANbufferCounter, ANAcqPos, ANoldAcqPos);
                    end
                    bufferCounter=updateCounter(bufferCounter, AcqPos, oldAcqPos);
                    posInNewData_AfterCAR=findPosition(bufferCounter,BufferSize, AcqPos, number_of_channels*num_freq_bands);
                    
                    if matlab_loopCounter==0
                        % first position may be late in the buffer, ...
                        %this sets intial matlab buffer index to one
                        constant = posInNewData_AfterCAR-1;
                        posInNewData_AfterCAR = ones(size(posInNewData_AfterCAR));
                    else
                        posInNewData_AfterCAR=posInNewData_AfterCAR-constant;
                    end
                    
                    if event_flag==1 || single_event_flag==1
                        ANposInNewData=findPosition(ANbufferCounter, ANBufferSize, ANAcqPos, ANnumber_of_channels);
                        if matlab_loopCounter==0
                            ANconstant = ANposInNewData-1;
                            ANposInNewData = ones(size(ANposInNewData));
                        else
                            ANposInNewData=ANposInNewData-ANconstant;
                        end
                        
                    end
                    
                    
                    % converts to matrix
                    % reshape to chan x freq bands x time
                    NewData=readTarget(dproj_name,AcqPos, number_of_points2read, DA);
                    NewDataMAT=[];%#channels by #freqband by #samps
                    for i = 1:size(NewData,1)
                        NewDataMAT= [NewDataMAT; shiftdim(reshape(reshape(NewData(i,:),num_freq_bands*number_of_channels, sampling_rate*number_of_sec2read)',...
                            sampling_rate*number_of_sec2read,number_of_channels,num_freq_bands),1)];
                    end
                    
                    %Take log(power+medians)
                    LogNewData =log(abs(NewDataMAT)+medians+eps);
                    if event_flag ==1 || single_event_flag==1
                        ANNewData = DA.ReadTargetVEX(dANproj_name{1},ANAcqPos, ANnumber_of_points2read,'F32','F64');
                    end
                    
                    beginC(matlab_loopCounter+1)=toc(begin);%**************
                    %%
                    %continual plotting
                    cont=tic
                    set(0,'currentfigure',fh);
                    subplot(2,2,1)
                    runningAverage = squeeze(mean(LogNewData(:, desired_freq_plot, (end-integration_time*sampling_rate):end),3));
                    ZscoreNewData=(runningAverage-averages(:,desired_freq_plot,1))./stdevs(:,desired_freq_plot,1);
                    imagesc(real(reshape(ZscoreNewData,to_plot_grid,to_plot_grid))', [-7 7]);
                    imagecount(1)=imagecount(1)+1;
                    colorbar('yticklabel',[-7:7],'ytick',[-7:7]);
                    cbar_handle=colorbar;
                    set(get(cbar_handle,'ylabel'),'string','z-score','fontsize',11)
                    drawnow;
                    plotContC(matlab_loopCounter+1)=toc(cont)

                    %%
                    
                    if event_flag ==1 || single_event_flag==1
                        eventTime=tic
                        % reshape ANdata by chan x time
                        ANNewDataMAT=reshape(ANNewData,ANnumber_of_channels,sampling_rate*number_of_sec2read);
                        %  generates matlab buffer (everything previous is for
                        %  positioning timing of buffer), now matlab buffer is true
                        %  aggregate of tdt buffer
                        finalPos = posInNewData_AfterCAR+sampling_rate*number_of_sec2read-1;
                        DataAfterCAR(:,:,posInNewData_AfterCAR:finalPos)=LogNewData;
                        ANNewData_finalMAT(:,ANposInNewData:ANposInNewData+sampling_rate*number_of_sec2read-1)=ANNewDataMAT;
                        
                        %event average plot
                        %find events
                        event=(ANNewData_finalMAT(desired_ANchan,:)>threshold);
                        trigger=(diff(event)>0);
                        detected_num_events = sum(trigger);
                        set(0,'currentfigure',fh);
                        subplot(2,2,2)
                        hold on
                        plot(matlab_loopCounter,detected_num_events,'*');
                        grid on;
                        foundevent(detected_num_events+1)=matlab_loopCounter;
                        assignin('base','foundevent',foundevent)
                        
                        if detected_num_events>0 && event_flag == 1
                            %get event indices                            
                            ind = find(trigger,detected_num_events);
                            ind(find([0 diff(ind)<(sampling_rate*1)]))=[]; %no events within 1 sec...
                            %of each other will be acknowledged
                            num_events = length(ind);
                            
                            set(0,'currentfigure',fh);
                            subplot(2,2,2)
                            hold on
                            plot(matlab_loopCounter,num_events,'r*');
                            
                            %event related calculations
                            cc=tic;
                            [eventRelatedAvg,num_samples,last_used_ind] = average_event_window(num_events, ind, window_around_event,...
                                DataAfterCAR,finalPos(1),number_of_electrodes_total,...
                                num_avgEvent_freqs2plot, avgEvent_freqs2plot,...
                                eventRelatedAvg, num_samples, last_used_ind);
                            
                            ZscoreEventRelatedAvg=(eventRelatedAvg-averages)./stdevs;
                            to_plot=  reshape_3Ddata(ZscoreEventRelatedAvg, window_around_event,...
                                num_avgEvent_freqs2plot, to_plot_grid);
                            
                            to_plot = artifactrejection(to_plot, window_around_event,-1.5, 1.5, .5, .8, to_plot_grid);
                            calcave=toc(cc);
                            assignin('base','calcave',calcave)
                            plotted=plotted+1;
                            assignin('base','plotted',plotted)
                            set(0,'currentfigure',fh);
                            subplot(2,2,3)
                            imagesc(real(to_plot),[-3 3]); colorbar('yticklabel',[-3 0 -3],'ytick',[-3 0 3]);

                            cbar_handle=colorbar;
                            set(get(cbar_handle,'ylabel'),'string','z-score','fontsize',11)
                            text(fig_num_x, fig_num_y, fig_nums)
                            line(fig_dash_x,avgfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);
                            grid on;
                            drawnow;                            
                        end
                        eventC(matlab_loopCounter+1)=toc(eventTime)
                        ANoldAcqPos=ANAcqPos;
                    end
                    %%
                    t(matlab_loopCounter+1)=toc(loop);
                    matlab_loopCounter=matlab_loopCounter+1;
                    oldAcqPos=AcqPos;
                    
                end            
            else
                msgbox('Incorrect OpenEx Project')
            end
        else
            msgbox('OpenEx project Failed To Run')
        end
    end
else
    msgbox('OpenEx project not loaded reload OpenEx project and restart MATLAB script')
end
DA.CloseConnection


disp('Saving figures...')
saveas(fh,[subj_id '_avg.jpg'],'jpg')
saveas(fh6,[subj_id '_stacked.jpg'],'jpg')

play_movie = input('Play movie (1/0): ');
while play_movie
    save_movie = 0;
    makeMovie(subj_id, ZscoreEventRelatedAvg,to_plot_grid, number_of_electrodes_total, save_movie);
    play_movie = input('Play movie (1/0): ');
end

uisave({'ZscoreEventRelatedAvg' }, ['ZscoreEventRelatedAvg' subj_id])
% disp('Save data?')
% uisave({'DataAfterCAR' 'ANNewData_finalMAT'}, ['data_' subj_id])
assignin('base','time',t)
assignin('base','event',eventC)

assignin('base','plotcont',plotContC)

assignin('base','beginning',beginC)


disp('Done')

%%%%%%
function AcqPos = AcquirePosition(sproj_name, number_of_points2read, BufferSize, DA)

for i = 1:length(sproj_name)
    AcqPos(i)=DA.GetTargetVal(sproj_name{i})-number_of_points2read+BufferSize(i);
    AcqPos(i) = mod(AcqPos(i),BufferSize(i)); %%
    % + BufferSize takes care of circular buffer, prevents tdt from getting
    % confused over a negative position ( -number_of_points2read)
end

%%%%%%
function newbufferCounter = updateCounter(bufferCounter, AcqPos, oldAcqPos)
for i=1:length(AcqPos)
    newbufferCounter(i)=bufferCounter(i)+(AcqPos(i)<oldAcqPos(i));
end


%%%%%%
function [posInNewData] = findPosition(bufferCounter, BufferSize, AcqPos, number_of_channels)

for i=1:length(BufferSize)
    posInNewData(i) = (bufferCounter(i)*BufferSize(i)+AcqPos(i)-BufferSize(i))/number_of_channels;
end

%%%%%%
function  NewData=readTarget(dproj_name,AcqPos, number_of_points2read, DA)
for i = 1:length(AcqPos)
    NewData(i,:)=DA.ReadTargetVEX(dproj_name{i},AcqPos(1), number_of_points2read,'F32','F64');
end

%%%%%%
% function NewData_AfterCAR = commonAveraging(NewDataMAT, good_channels4CAR, number_of_channels)
% %common averaging of EEG
% CAR=mean(NewDataMAT(good_channels4CAR,:),1);
% CAR_Mat=repmat(CAR,number_of_channels,1);
% NewDataMAT_AfterCAR=NewDataMAT-CAR_Mat;
%
% %increase precision, decrease bit
% NewData_AfterCAR=1000*NewDataMAT_AfterCAR;

%%%%%%




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
%loop over each event starting from one after the last index, grab corresponding window
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




function single_window = single_event_window(ind, window_around_event,...
    DataAfterCAR,AmountOfData,number_electrodes,num_freq_bands, freqs2plot)

single_window=zeros(number_electrodes,num_freq_bands, window_around_event+1);
if length(ind)>1
    for i=0:1
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
for i = 0:(to_plot_grid-1)  %ASSUMES to_plot_grid x to_plot_grid CHANNELS
    last =  beginning+to_plot_grid*(window_around_event+1);
    data = to_reshape(i*to_plot_grid+1:i*to_plot_grid+to_plot_grid,:,:);
    to_plot(i*num_freq_bands+1:i*num_freq_bands+num_freq_bands,:) = ...
        flipud(reshape(shiftdim(data,1),num_freq_bands, to_plot_grid*(window_around_event+1)));
    beginning = last;
    %Grab every eight channels and form to_plot_grid x to_plot_grid square
end



function [averages, stdevs, medians]=calculate_baseline(time2collectBaseline, ...
    sproj_name,dproj_name, points_needed4baseline, BufferSize, DA, num_channels, num_freq_bands,...
    sampling_rate, number_of_sec2read)

h = waitbar(0,'Calculating Baseline...');
for i = 1:time2collectBaseline
    pause(1);
    waitbar(i/(time2collectBaseline+1),h)
end
pause(1);
AcqPos=AcquirePosition(sproj_name, points_needed4baseline, BufferSize, DA);

BaselineData =readTarget(dproj_name,AcqPos, points_needed4baseline, DA);
% converts to matrix
% reshape to chan x freq x time
BaselineDataMAT=[];
for i = 1:size(BaselineData,1)
    BaselineDataMAT= [BaselineDataMAT; shiftdim(reshape(reshape(BaselineData(i,:),...
        num_freq_bands*num_channels, sampling_rate*time2collectBaseline)',...
        sampling_rate*time2collectBaseline,num_channels,num_freq_bands),1)];
end

medians = median(BaselineDataMAT,3);
logBaselineDataMAT = log(BaselineDataMAT+repmat(medians,[1 1 size(BaselineDataMAT,3)])+eps);

medians=repmat(medians,[1 1 (sampling_rate*number_of_sec2read)]);
% averages = repmat(mean(logBaselineDataMAT,3),[1 1 (sampling_rate*number_of_sec2read+1)]);
% stdevs = repmat(std(logBaselineDataMAT,0,3),[1 1 (sampling_rate*number_of_sec2read+1)]);
averages = repmat(mean(logBaselineDataMAT,3),[1 1 (sampling_rate*1+1)]);
stdevs = repmat(std(logBaselineDataMAT,0,3),[1 1 (sampling_rate*1+1)]);
waitbar(1,h,'Baseline Statistics Gathered!')
pause(1)
close(h)


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



