function collectECoGdata_motormapping_GUI_artifactrejection
%last modified:
%   Connie Cheung, Nov 23, 2010 (updated with artifact rejection)
%
% function collectECoGdata_motormapping_GUI(sampling_rate, number_of_channels, ...
%     ANnumber_of_channels, number_of_sec2read,dproj_name, sproj_name, dANproj_name, ...
%     sANproj_name, integration_time, desired_freq_plot, desired_ANchan, freq_bands, ...
%     event_flag, single_event_flag, elecs2plot, avgEvent_freqs2plot, singleEvent_freqs2plot)
%
% 1) plots continual 64 electrodes (last mean(integration time)) in frequency
% indicated by variable desired_freq plot
% 2) plots single event power/time plot
% 3) plots average event power/time plot
% 4) plots stacked single trials
%
% (lavi2009)this code extracts tdt buffer to matlab buffer DataAfterCAR; matlab
% buffer needs to be longer than tdt.
close all
start_flag = 0;
f = figure('Visible','on','Position',[150,100,620,634],'Color',[1 1 1]);
htitle =  uicontrol('Style', 'text', 'String', 'S.M.A.R.T.','FontSize', 16, 'Position',...
    [200 568 250 35]);

hsamplingrate = uicontrol('Style','edit', 'String', '500', ...
    'Position',[60 484 58 24],'BackgroundColor', [1 1 1 ]);
hsr = uicontrol('Style', 'text', 'String', 'Sampling Rate','Position',...
    [61 530 60 29]);
hnum_channels = uicontrol('Style','edit', 'String', '16', ...
    'Position',[145 484 58 24],'BackgroundColor', [1 1 1 ]);
hnc = uicontrol('Style', 'text', 'String', 'Channels per Buffer','Position',...
    [134 529 80 30]);
hANnum_channels = uicontrol('Style','edit', 'String', '4', ...
    'Position',[230 484 58 24],'BackgroundColor', [1 1 1 ]);
hANnc = uicontrol('Style', 'text', 'String', 'Analog Channels','Position',...
    [224 530 70 29]);
hnumber_of_sec2read = uicontrol('Style','edit', 'String', '2', ...
    'Position',[315 484 58 24],'BackgroundColor', [1 1 1 ]);
hs2r = uicontrol('Style', 'text', 'String', '#seconds to read','Position',...
    [316 524 57 36]);
hdesired_ANchan = uicontrol('Style','edit', 'String', '1', ...
    'Position',[404 484 58 24],'BackgroundColor', [1 1 1 ]);
hdANc = uicontrol('Style', 'text', 'String', 'Event Analog Channel','Position',...
    [405 520 57 39]);
hintegration_time = uicontrol('Style','edit', 'String', '0.1', ...
    'Position',[492 484 58 24],'BackgroundColor', [1 1 1 ]);
hit = uicontrol('Style', 'text', 'String', 'Integration Time','Position',...
    [493 524 57 36]);
hproj_name = uitable('ColumnName', {'Dproj_name', 'Sproj_name'}, ...
    'Position', [313 379 234 89], 'columnWidth', {100 100},...
    'Data', {'motormap.dwav1', 'motormap.swav1'; 'motormap.dwav2' 'motormap.swav2'; 'motormap.dwav3' 'motormap.swav3'; 'motormap.dwav4' 'motormap.swav4'}, ...
    'ColumnEditable',[true true]);
hANproj_name = uitable('ColumnName', {'DANproj_name', 'SANproj_name'}, ...
    'Position', [313 337 234 41], 'columnWidth', {100 100},...
    'Data', {'motormap.danin', 'motormap.sanin'}, ...
    'ColumnEditable',[true true]);
hfreq_bands = uitable('ColumnName', {'Low Freq', 'High Freq'}, ...
    'Position', [70 334 182 134], ...
    'Data', [4 7; 8 12; 12 30; 31 59; 61 110; 110 179;181 260], ...
    'ColumnEditable',[true true]);
hdesired_freq_plot = uicontrol('Style','edit','String','5',...
    'Position',[66 227 58 24],'BackgroundColor', [1 1 1 ]);
hdfp = uicontrol('Style','text','String','Which 1 frequency to plot',...
    'Position',[29 254 141 21]);
hcontplot = uicontrol('Style','text','String','Continual Plot',...
    'Position',[60 283 79 24],'FontWeight','bold');

havgEvent_freqs2plot = uicontrol('Style','edit','String','[1:7]',...
    'Position',[222 225 128 24],'BackgroundColor', [1 1 1 ]);
haef2p = uicontrol('Style','text','String','Which frequencies [ARRAY] minimum length 2',...
    'Position',[208 250 150 30]);
havgEventplot = uicontrol('Style','text','String','Average Event Plot',...
    'Position',[225 283 102 22],'FontWeight','bold');

hsingleEvent_freqs2plot = uicontrol('Style','edit','String','[1:7]',...
    'Position',[400 223 128 24],'BackgroundColor', [1 1 1 ]);
hsef2p = uicontrol('Style','text','String','Which frequencies [ARRAY] minimum length 2',...
    'Position',[391 251 150 30]);
hsingleEventplot = uicontrol('Style','text','String','Single Event Plot',...
    'Position',[413 283 96 22],'FontWeight','bold');
he2p = uicontrol('Style','text','String','Which channels to plot [ARRAY]',...
    'Position',[80 156 130 29.9]);
helecs2plot = uicontrol('Style','edit','String','[1:64]',...
    'Position',[80 134 128 24],'BackgroundColor', [1 1 1 ]);
ht2cb = uicontrol('Style','text','String','Baseline time (sec)',...
    'Position',[235 156 130 29.9]);
htime2collectBaseline = uicontrol('Style','edit','String','30',...
    'Position',[250 134 100 24],'BackgroundColor', [1 1 1 ]);
hthresh = uicontrol('Style','text','String','Event Threshold',...
    'Position',[400 156 130 29.9]);
hthreshold = uicontrol('Style','edit','String','0.5',...
    'Position',[420 134 100 24],'BackgroundColor', [1 1 1 ]);

hevent_flag= uicontrol('Style','checkbox', 'String', 'Do Average Event Analysis', ...
    'Position',[50 70 162 35],'Value', 0);
hsingle_event_flag= uicontrol('Style','checkbox', 'String', 'Do Single Event Analysis', ...
    'Position',[250 70 162 33],'Value', 0);
hcalculated_baseline_flag= uicontrol('Style','checkbox', 'String', 'Load old Baseline Stats', ...
    'Position',[450,70 162 35],'Value', 0);

hstart =  uicontrol('Style','pushbutton','String','Start Real Time Analysis',...
    'Position',[207 14 147 23], 'Callback', {@start_Callback});

hupdate = uicontrol('Style','pushbutton', 'String', 'Update Variables',...
    'Position', [207 40 147 23], 'Callback', {@update_Callback, f, hsamplingrate,...
    hnum_channels, hANnum_channels, hnumber_of_sec2read, hdesired_ANchan, ...
    hintegration_time, hproj_name, hANproj_name, hfreq_bands, hdesired_freq_plot,...
    havgEvent_freqs2plot, hsingleEvent_freqs2plot, helecs2plot, htime2collectBaseline,...
    hevent_flag, hsingle_event_flag, hcalculated_baseline_flag,hthreshold });


set([f, htitle,hsamplingrate, hsr,hnum_channels,hnc, hANnum_channels,hANnc,...
    hnumber_of_sec2read,hs2r,hdesired_ANchan, hdANc, hintegration_time, hit,hproj_name,...
    hANproj_name, hfreq_bands, hdesired_freq_plot, hdfp, hcontplot, havgEvent_freqs2plot,...
    haef2p, havgEventplot, hsingleEvent_freqs2plot, hsef2p, hsingleEventplot, he2p,...
    helecs2plot,ht2cb,htime2collectBaseline,hevent_flag,hsingle_event_flag,hcalculated_baseline_flag,...
    hstart,hupdate, hthresh, hthreshold],...
    'Units','normalized');
%%
%wait until initial variables are set
while start_flag==0
    if ~ishandle(f)
        error('figure closed')
    end
    pause(.03)
end
set(hstart,'Visible','off')
pause(.1)

%%
single_stacked_flag = 1;
freq_band_singlestacked = input('Which frequency band to use for single stacked trials plot: ');

subj_id = input('Subject id: ', 's');
task = input('Task type: ', 's');

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


%buffer of 5 minutes
if event_flag ==1 || single_event_flag==1
    DataAfterCAR=zeros(number_of_electrodes_total, num_freq_bands, 5*60*sampling_rate);
    ANNewData_finalMAT=zeros(ANnumber_of_channels, 5*60*sampling_rate);
end

DA = actxcontrol('TDevAcc.X');% Loads ActiveX methods
if DA.ConnectServer('Local')>0 %Checks to see if there is an OpenProject and Workbench load
    if DA.SetSysMode(2)==1%Starts OpenEx project running and acquiring data. 1 = Standby, 2 = Preview, !!MUST CHANGE TO 3 WHEN RECORDING
         if DA.GetSysMode>1 % Checks to see if the Project is running
            if not(isnan(DA.ReadTargetVEX(dproj_name{1},0,10,'F32','F64'))) %checks to see if it loaded the correct project
                for i=1:length(dproj_name)
                    BufferSize(i)=DA.GetTargetSize(dproj_name{i});% returns the Buffer size (bookkeeping)
                end
                if event_flag ==1 || single_event_flag==1
                    ANBufferSize=DA.GetTargetSize(dANproj_name{1});% returns the Analog Buffer size (bookkeeping)
                    ANoldAcqPos=ANBufferSize;
                end
                oldAcqPos=BufferSize;

                %if DA.GetSysMode=0, then means tdt is not recording or prj not working
                while DA.GetSysMode>1
                    if calculated_baseline_flag==0
                        [averages, stdevs, medians]=calculate_baseline(time2collectBaseline, ...
                            sproj_name,dproj_name, points_needed4baseline, BufferSize, DA, number_of_channels, ...
                            num_freq_bands, sampling_rate,number_of_sec2read);
                        set(hcalculated_baseline_flag,'value',1)
                       % save baseline_stats averages stdevs medians
                       
                        uisave({'averages' 'stdevs' 'medians'}, ['baseline_stats_' subj_id])
                        calculated_baseline_flag=1;
                    end


                    % resets and ensures timing of matlab and tdt buffers
                    AcqPos=AcquirePosition(sproj_name, number_of_points2read, BufferSize, DA);
                    if event_flag ==1 || single_event_flag==1
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

                    if event_flag ==1 || single_event_flag==1
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
                    NewDataMAT=[];
                    for i = 1:size(NewData,1)
                        NewDataMAT= [NewDataMAT; shiftdim(reshape(reshape(NewData(i,:),num_freq_bands*number_of_channels, sampling_rate*number_of_sec2read)',...
                            sampling_rate*number_of_sec2read,number_of_channels,num_freq_bands),1)];
                    end

                    %Take log(power+medians)
                    LogNewData =log(abs(NewDataMAT)+medians+eps);
                    if event_flag ==1 || single_event_flag==1
                        ANNewData = DA.ReadTargetVEX(dANproj_name{1},ANAcqPos, ANnumber_of_points2read,'F32','F64');
                    end

                    %continual plotting
                    set(0,'currentfigure',fh2);
                    runningAverage = squeeze(mean(LogNewData(:, desired_freq_plot, (end-integration_time*sampling_rate):end),3));
                    ZscoreNewData=(runningAverage-averages(:,desired_freq_plot,1))./stdevs(:,desired_freq_plot,1);
                    imagesc(real(reshape(ZscoreNewData,8,8))', [-7 7]);
                    colorbar('yticklabel',[-7:7],'ytick',[-7:7]);
                    cbar_handle=colorbar;
                    set(get(cbar_handle,'ylabel'),'string','z-score','fontsize',11)
                    drawnow;

                    if event_flag ==1 || single_event_flag==1
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
                        
                        set(0,'currentfigure',fh5);
                        hold on
                        plot(matlab_loopCounter,detected_num_events,'*');
                        grid on;


                        if detected_num_events>0 && event_flag == 1
                            ind = find(trigger,detected_num_events);
                            ind(find([0 diff(ind)<(sampling_rate*1)]))=[]; %no events within 1 sec...
                            %of each other will be acknowledged
                            num_events = length(ind);

                            set(0,'currentfigure',fh5);
                            hold on
                            plot(matlab_loopCounter,num_events,'r*');
                            
                            
                            [eventRelatedAvg,num_samples,last_used_ind] = average_event_window(num_events, ind, window_around_event,...
                                DataAfterCAR,finalPos(1),number_of_electrodes_total,...
                                num_avgEvent_freqs2plot, avgEvent_freqs2plot,...
                                 eventRelatedAvg, num_samples, last_used_ind);

                            ZscoreEventRelatedAvg=(eventRelatedAvg-averages)./stdevs;
                            to_plot=  reshape_3Ddata(ZscoreEventRelatedAvg, window_around_event,...
                                num_avgEvent_freqs2plot, number_of_electrodes_total);
                            
                            to_plot = artifactrejection(to_plot, window_around_event,-1.5, 1.5, .5, .8);
            
                            
                            set(0,'currentfigure',fh);
                            imagesc(real(to_plot),[-3 3]); colorbar('yticklabel',[-3 0 -3],'ytick',[-3 0 3]);
                            cbar_handle=colorbar;
                            set(get(cbar_handle,'ylabel'),'string','z-score','fontsize',11)
                            text(fig_num_x, fig_num_y, fig_nums)
                            line(fig_dash_x,avgfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);
                            grid on;
                            drawnow;
                            
                            
                        end
                        if detected_num_events>0 && single_event_flag == 1
                            ind = find(trigger,detected_num_events);
                            ind(find([0 diff(ind)<(sampling_rate*1)]))=[]; %no events within 1 sec...
                            %of each other will be acknowledged
                            num_events = length(ind);
    
                            lastEvent = single_event_window(ind, window_around_event,...
                                DataAfterCAR,finalPos(1),number_of_electrodes_total,...
                                num_singleEvent_freqs2plot, singleEvent_freqs2plot);
                            ZscoreLastEvent=(lastEvent-averages)./stdevs;
                            to_plot = reshape_3Ddata(ZscoreLastEvent, window_around_event,...
                                num_singleEvent_freqs2plot, number_of_electrodes_total);
                            set(0,'currentfigure',fh4)
                            imagesc(real(to_plot),[-7 7]);colorbar('yticklabel',[-7:7],'ytick',[-7:7]);
                            cbar_handle=colorbar;
                            set(get(cbar_handle,'ylabel'),'string','z-score','fontsize',11)
                            text(fig_num_x, fig_num_y, fig_nums)
                            line(fig_dash_x,sigfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);

                            grid on;
                            drawnow;
                        end

                        if detected_num_events>0 && single_stacked_flag ==1
                            ind = find(trigger,detected_num_events);
                            ind(find([0 diff(ind)<(sampling_rate*1)]))=[]; %no events within 1 sec...
                            %of each other will be acknowledged
                            num_events = length(ind);
                            to_plot= SingleStackedTrials(DataAfterCAR, ind, num_events,...
                                averages, stdevs, freq_band_singlestacked, window_around_event);
                            num_events = size(to_plot,2);

                            if num_events ==0
                                continue
                            end

                            set(fh6,'DefaultAxesytick',[0.5: num_events:8*num_events])
                            set(0,'currentfigure',fh6);

                            flattened = reshape_3Ddata(to_plot, window_around_event,num_events, 64);
                            
                            to_plot = artifactrejection(flattened, window_around_event,-5.5, 5.5, .5, .8);
                            
                            imagesc(real(to_plot),[-7 7]);
                            colorbar('yticklabel',[-7:7],'ytick',[-7:7]);
                            cbar_handle=colorbar;
                            set(get(cbar_handle,'ylabel'),'string','z-score','fontsize',11)
                            
                            if num_events >1
                                fig_num_y_stacked = [1.1:num_events:8*num_events];
                                fig_num_y_stacked = reshape(repmat(fig_num_y_stacked, [8 1]), 64, 1);
                                text(fig_num_x, fig_num_y_stacked, fig_nums)
                                stackedfig_dash_y = repmat([0 num_events*8],8,1)';
                                line(fig_dash_x,stackedfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);
                            end
                            grid on

                        end
                        ANoldAcqPos=ANAcqPos;
                    end
                    matlab_loopCounter=matlab_loopCounter+1;
                    oldAcqPos=AcqPos;

                    % pause(.02)
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
saveas(fh,[subj_id '_' task '_avg.jpg'],'jpg')
saveas(fh6,[subj_id '_' task '_stacked.jpg'],'jpg')

disp('Save data?')
uisave({'DataAfterCAR' 'ANNewData_finalMAT'}, ['data_' subj_id])

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
    NewData(i,:)=DA.ReadTargetVEX(dproj_name{i},AcqPos(i), number_of_points2read,'F32','F64');
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
    num_freq_bands, number_electrodes)
%to_reshape = chan x freq x timepts
flatten = [];
to_plot = zeros(num_freq_bands*8, 8*(window_around_event+1));

for i =1:number_electrodes
    if num_freq_bands==1
        flatten=[flatten squeeze(to_reshape(i,:,:))'];
    else
        flatten=[flatten squeeze(to_reshape(i,:,:))]; %size freq x (chan*time)
    end
end
beginning = 0;
for i = 0:7  %ASSUMES 64 CHANNELS
    last =  beginning+8*(window_around_event+1);
    to_plot(i*num_freq_bands+1:i*num_freq_bands+num_freq_bands,:) = ...
        flatten(:,beginning+1 : last);
    beginning = last;
    %Grab every eight channels and form 8 x 8 square
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
    min_zscore, max_zscore, percentage_min, percentage_max)
%reshaped data = freqs2plot*8 x window_around_event+1*8
%
%  if more than percentage_min% of the data is below min_zscore, reject
%  if more than percentage_max%of the data is above max_zscore, reject

rows = size(reshaped_data,1);
cols = 1:window_around_event+1:8*window_around_event;
to_plot = reshaped_data;
for i = 1:rows
    for j = 1:8
        k = cols(j):cols(j)+(window_around_event+1)-1;
        if (sum(reshaped_data(i,k)<min_zscore)>=percentage_min*(window_around_event+1) ||...
            sum(reshaped_data(i,k)>max_zscore)>=percentage_max*(window_around_event+1))
            to_plot(i,k)=zeros(1,window_around_event+1);
        end
    end
end

            



function start_Callback(source, eventdata)
start_flag = get(source,'value');
assignin('caller','start_flag', start_flag);
pause(.01)




function update_Callback(source, eventdata, f, hsamplingrate,...
    hnum_channels, hANnum_channels, hnumber_of_sec2read, hdesired_ANchan, ...
    hintegration_time, hproj_name, hANproj_name, hfreq_bands, hdesired_freq_plot,...
    havgEvent_freqs2plot, hsingleEvent_freqs2plot, helecs2plot, htime2collectBaseline,...
    hevent_flag, hsingle_event_flag, hcalculated_baseline_flag,hthreshold )
sampling_rate=str2num(get(hsamplingrate,'String'));
number_of_channels=str2num(get(hnum_channels,'String'));
ANnumber_of_channels=str2num(get(hANnum_channels,'String'));
number_of_sec2read=str2num(get(hnumber_of_sec2read,'String'));
desired_ANchan=str2num(get(hdesired_ANchan,'String'));
freq_bands=get(hfreq_bands,'Data');
while( isnan(freq_bands(end,1)) || isnan(freq_bands(end,2)))
    freq_bands(end,:) = [];
end
num_freq_bands=size(freq_bands,1);
event_flag=get(hevent_flag,'Value');
single_event_flag=get(hsingle_event_flag,'Value');
time2collectBaseline=str2num(get(htime2collectBaseline,'String'));
integration_time=str2num(get(hintegration_time,'String'));
calculated_baseline_flag=get(hcalculated_baseline_flag,'Value');
threshold = str2num(get(hthreshold,'String'));

pn = get(hproj_name,'Data');
dproj_name = pn(:,1);
sproj_name = pn(:,2);
while(isempty(sproj_name{end}))
    sproj_name = sproj_name(1:end-1);
end
while(isempty(dproj_name{end}))
    dproj_name = dproj_name(1:end-1);
end

ANpn = get(hANproj_name,'Data');
dANproj_name = ANpn(:,1);
sANproj_name = ANpn(:,2);

desired_freq_plot=get(hdesired_freq_plot,'String');
eval(['desired_freq_plot=' desired_freq_plot ';']);

elecs2plot=get(helecs2plot,'String');
eval(['elecs2plot=' elecs2plot ';']);
avgEvent_freqs2plot=get(havgEvent_freqs2plot,'String');
eval(['avgEvent_freqs2plot=' avgEvent_freqs2plot ';']);
singleEvent_freqs2plot=get(hsingleEvent_freqs2plot,'String');
eval(['singleEvent_freqs2plot=' singleEvent_freqs2plot ';']);

window_around_event = 1*sampling_rate; %must be even number

points_needed4baseline = sampling_rate*time2collectBaseline*number_of_channels *num_freq_bands;
number_of_points2read = sampling_rate*number_of_sec2read*number_of_channels*num_freq_bands;
ANnumber_of_points2read = sampling_rate*number_of_sec2read*ANnumber_of_channels;
number_of_electrodes_total = size(dproj_name,1)*number_of_channels;
num_avgEvent_freqs2plot = length(avgEvent_freqs2plot);
num_singleEvent_freqs2plot = length(singleEvent_freqs2plot);

assignin('caller','sampling_rate',sampling_rate);
assignin('caller','number_of_channels',number_of_channels);
assignin('caller','ANnumber_of_channels',ANnumber_of_channels);
assignin('caller','number_of_sec2read',number_of_sec2read);
assignin('caller','time2collectBaseline',time2collectBaseline);
assignin('caller','calculated_baseline_flag',calculated_baseline_flag);
assignin('caller','dproj_name',dproj_name);
assignin('caller','sproj_name',sproj_name);
assignin('caller','dANproj_name',dANproj_name);
assignin('caller','sANproj_name',sANproj_name);
assignin('caller','integration_time',integration_time);
assignin('caller','desired_freq_plot',desired_freq_plot);
assignin('caller','desired_ANchan',desired_ANchan);
assignin('caller','freq_bands',freq_bands);
assignin('caller','num_freq_bands',num_freq_bands);
assignin('caller','event_flag',event_flag);
assignin('caller','single_event_flag',single_event_flag);
assignin('caller','elecs2plot',elecs2plot);
assignin('caller','avgEvent_freqs2plot',avgEvent_freqs2plot);
assignin('caller','singleEvent_freqs2plot',singleEvent_freqs2plot);
assignin('caller','threshold',threshold);
assignin('caller','window_around_event',window_around_event);
assignin('caller','points_needed4baseline',points_needed4baseline);
assignin('caller','number_of_points2read',number_of_points2read);
assignin('caller','ANnumber_of_points2read',ANnumber_of_points2read);
assignin('caller','number_of_electrodes_total',number_of_electrodes_total);
assignin('caller','num_avgEvent_freqs2plot',num_avgEvent_freqs2plot);
assignin('caller','num_singleEvent_freqs2plot',num_singleEvent_freqs2plot);
assignin('caller','threshold',threshold);




fh2 = figure(3);
set(fh2, 'Name', 'Continual Plot','NumberTitle','off')

fh=figure(2); % figure for average event trigger analysis
axes('Position',[0 0 1 1],'visible','off') %Labeling of graph with second axes
%x labels
y=.08*ones(1,17);
text([.1077,.1457,.1684,.2363,.2590,.3270,.3497,.4176,.4405,.5090,.5316,.5996,.6222,.6902,.7129,.7809,.8189] ,y,{'-.5',...
    '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5'},...
    'fontsize',7);
x=.07*ones(1,16);
%ylabels
text(x,[.154,.182,.259,.290,.365,.395,.471,.501,.578,.607,.684,.713,.790,.820,.896,.926],{'45','10',...
    '45','10','45','10','45','10','45','10','45','10','45','10','45','10'},'fontsize',7)
x2=.065*ones(1,8);
text(x2,[.122,.229,.336,.442,.548,.654,.760,.866],{'145','145',...
    '145','145','145','145','145','145'},'fontsize',7)

z=axes('Position',[.1 .1 .85 .85],'visible','off');
set(fh,'DefaultAxesxtick',[0.5: (window_around_event+1):8*(window_around_event+1)])
set(fh,'DefaultAxesytick',[0.5: num_avgEvent_freqs2plot:8*num_avgEvent_freqs2plot])
set(fh,'DefaultAxesyticklabel','')
set(fh,'DefaultAxesxticklabel','')
set(fh,'DefaultAxeslinewidth',1)
set(fh,'DefaultAxesgridlinestyle','-')
set(fh, 'Name','Average Event Time Frequency Plot','NumberTitle','off')
set(fh,'CurrentAxes',z)


fh4=figure(4); % figure for single event trigger analysis
axes('Position',[0 0 1 1],'visible','off') %Labeling of graph with second axes
%x labels
y=.08*ones(1,17);
text([.1077,.1457,.1684,.2363,.2590,.3270,.3497,.4176,.4405,.5090,.5316,.5996,.6222,.6902,.7129,.7809,.8189] ,y,{'-.5',...
    '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5'},...
    'fontsize',7)
x=.07*ones(1,16);
%ylabels
text(x,[.154,.182,.259,.290,.365,.395,.471,.501,.578,.607,.684,.713,.790,.820,.896,.926],{'45','10',...
    '45','10','45','10','45','10','45','10','45','10','45','10','45','10'},'fontsize',7)
x2=.065*ones(1,8);
text(x2,[.122,.229,.336,.442,.548,.654,.760,.866],{'145','145',...
    '145','145','145','145','145','145'},'fontsize',7)
h=axes('Position',[.1 .1 .85 .85],'visible','off');
set(fh4,'DefaultAxesxtick',[0.5: (window_around_event+1):8*(window_around_event+1)])
set(fh4,'DefaultAxesytick',[0.5: num_singleEvent_freqs2plot:8*num_singleEvent_freqs2plot])
set(fh4,'DefaultAxesyticklabel','')
set(fh4,'DefaultAxesxticklabel','')
set(fh4,'DefaultAxeslinewidth',1)
set(fh4,'DefaultAxesgridlinestyle','-')
set(fh4, 'Name','Single Event Time Frequency Plot','NumberTitle','off')
set(fh4,'CurrentAxes',h)

fh5 = figure(5);
set(fh5, 'Name','Number of events vs matlab loop counter','NumberTitle','off')
set(fh5,'DefaultAxesxtick',[0:100])
set(fh5,'DefaultAxesytick',[0:100])

fh6 = figure(6);
axes('Position',[0 0 1 1],'visible','off') %Labeling of graph with second axes
%x labels
y=.08*ones(1,17);
text([.1077,.1457,.1684,.2363,.2590,.3270,.3497,.4176,.4405,.5090,.5316,.5996,.6222,.6902,.7129,.7809,.8189] ,y,{'-.5',...
'0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5'},...
    'fontsize',7);
z=axes('Position',[.1 .1 .85 .85],'visible','off');
set(fh6,'DefaultAxesxtick',[0.5: (window_around_event+1):8*(window_around_event+1)])
set(fh6,'DefaultAxeslinewidth',1)
set(fh6,'DefaultAxesyticklabel','')
set(fh6,'DefaultAxesxticklabel','')
set(fh6,'DefaultAxesgridlinestyle','-')
set(fh6, 'Name','Single Stacked','NumberTitle','off')
set(fh6,'CurrentAxes',z)



assignin('caller','fh',fh);
assignin('caller','fh2',fh2);
assignin('caller','fh4',fh4);
assignin('caller','fh5',fh5);
assignin('caller','fh6',fh6);

fig_num_y = [1.1:num_avgEvent_freqs2plot:8*num_avgEvent_freqs2plot];
fig_num_y = reshape(repmat(fig_num_y,[8 1]),64,1);
fig_num_x = [.5:(window_around_event+1):8*(window_around_event+1)];
fig_num_x = reshape(repmat(fig_num_x,[1 8]),64,1);
fig_nums = {};
for i = 1:64
    fig_nums = [fig_nums {num2str(i)}];
end
assignin('caller', 'fig_num_x', fig_num_x)
assignin('caller', 'fig_num_y', fig_num_y)
assignin('caller', 'fig_nums', fig_nums)

avgfig_dash_y = repmat([0 num_avgEvent_freqs2plot*8],8,1)';
sigfig_dash_y = repmat([0 num_singleEvent_freqs2plot*8],8,1)';
fig_dash_x = repmat([round((window_around_event+1)/2):window_around_event+1:8*window_around_event],2,1);
assignin('caller', 'avgfig_dash_y', avgfig_dash_y);
assignin('caller', 'sigfig_dash_y', sigfig_dash_y);
assignin('caller', 'fig_dash_x', fig_dash_x);
