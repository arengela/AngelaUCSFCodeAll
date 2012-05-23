% Bradley Voytek
% Copyright (c) 2010
% University of California, Berkeley
% Helen Wills Neuroscience Institute

% GET PAC
load('raw_data.mat'); % Data is 2D array with each row containing the raw timeseries for each channel

%raw_data=ecogNormalized.data;

% Put data in common average reference

ref = mean(raw_data, 1);
for x = 1:size(raw_data, 1)
    raw_data(x, :) = raw_data(x, :) - ref;
end
clear x ref


low_frequency = [4 8; 8 12]; % define theta and alpha bands
high_frequency = [80 150]; % define gamma band
sampling_rate = 400; % define sampling rate


%%
function pac=calculatePAC(raw_data,sampling_frequency,low_frequency,high_frequency)

% Initialize PAC variable
pac = zeros([size(raw_data, 1) size(low_frequency, 1) size(high_frequency, 1)]);

% Calculate PAC
for chanIt = 1:size(raw_data, 1)
    signal = raw_data(chanIt, :);
 
    for lowIt = 1:size(low_frequency, 1)
        disp(['Channel ' num2str(chanIt) ' Low Frequency ' num2str(lowIt)]);
        
        % Extract low frequency analytic phase
        low_frequency_phase = eegfilt(signal, sampling_rate, low_frequency(lowIt, 1), []);
        low_frequency_phase = eegfilt(low_frequency_phase, sampling_rate, [], low_frequency(lowIt, 2));
        low_frequency_phase = angle(hilbert(low_frequency_phase));
 
        for highIt = 1:size(high_frequency, 1)
            % Extract low frequency analytic phase of high frequency analytic amplitude
            high_frequency_phase = eegfilt(signal, sampling_rate, high_frequency(highIt, 1), []);
            high_frequency_phase = eegfilt(high_frequency_phase, sampling_rate, [], high_frequency(highIt, 2));
            high_frequency_phase = abs(hilbert(high_frequency_phase));
            high_frequency_phase = eegfilt(high_frequency_phase, sampling_rate, low_frequency(lowIt, 1), []);
            high_frequency_phase = eegfilt(high_frequency_phase, sampling_rate, [], low_frequency(lowIt, 2));
            high_frequency_phase = angle(hilbert(high_frequency_phase));
 
            % Calculate PAC
            pac(chanIt, lowIt, highIt) =...
                abs(sum(exp(1i * (low_frequency_phase - high_frequency_phase)), 'double'))...
                / length(high_frequency_phase);
                
            clear high_frequency_phase
        end
        clear highIt low_frequency_phase
    end
    clear signal lowIt
end
clear chanIt

%%
%Plot Theta PAC on grid
figure
imagesc(reshape(pac(:,1),16,16)')%theta PAC
set(gca,'XGrid','on')
set(gca,'YGrid','on')
set(gca,'XTick',[1.5:16.5])
set(gca,'YTick',[1.5:16.5])
%set(gca,'XTickLabel',[1:16])
%set(gca,'YTickLabel',[1:16])

set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
for c=1:16
    for r=1:16
        text(c,r,num2str((r-1)*16+c))
       
    end
end
colorbar
title('Theta/HG PAC')
%%
%Plot alpha PAC on grid
figure
imagesc(reshape(pac(:,2),16,16)')%alpha PAC


set(gca,'XGrid','on')
set(gca,'YGrid','on')
set(gca,'XTick',[1.5:16.5])
set(gca,'YTick',[1.5:16.5])
%set(gca,'XTickLabel',[1:16])
%set(gca,'YTickLabel',[1:16])

set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
for c=1:16
    for r=1:16
        text(c,r,num2str((r-1)*16+c))
       
    end
end

 colorbar
title('Alpha/HG PAC')
%%
% GET PEAK/TROUGH
function [peakPower, troughPower]=getPeakTrough(raw_data,sampling_rate)
% Define window around peaks and troughs to average gamma power
percent_window_size = 0.05; % +/- 5 percent window around peaks and troughs
window_size(1) = round(sampling_rate / ((low_frequency(1, 1) + low_frequency(1, 2)) / 2) .* percent_window_size);
window_size(2) = round(sampling_rate / ((low_frequency(2, 1) + low_frequency(2, 2)) / 2) .* percent_window_size);



clear percent_window_size

for x = 1:size(raw_data, 1)
    % Extract high frequency analytic amplitude
    high_frequency_amplitude = eegfilt(raw_data(x, :), sampling_rate, high_frequency(1), []);
    high_frequency_amplitude = eegfilt(high_frequency_amplitude, sampling_rate, [], high_frequency(2));
    high_frequency_amplitude = abs(hilbert(high_frequency_amplitude));

    % Extract low frequency analytic phase
    low_frequency_phase = eegfilt(raw_data(x, :), sampling_rate, low_frequency(1, 1), []);
    low_frequency_phase = eegfilt(low_frequency_phase, sampling_rate, [], low_frequency(1, 2));
    low_frequency_phase = angle(hilbert(low_frequency_phase));

    % Find peaks and troughs
    thetaTroughEvents = find(low_frequency_phase < -(pi - 0.01));
    thetaPeakEvents = find((low_frequency_phase < (0 + 0.005)) & (low_frequency_phase > (0 - 0.005)));
    thetaTroughEvents = thetaTroughEvents(thetaTroughEvents > 20);
    thetaTroughEvents = thetaTroughEvents(thetaTroughEvents < (length(low_frequency_phase)-20));
    thetaPeakEvents = thetaPeakEvents(thetaPeakEvents > 20);
    thetaPeakEvents = thetaPeakEvents(thetaPeakEvents < (length(low_frequency_phase)-20));
    %clear low_frequency_phase

    % Extract low frequency analytic phase
    low_frequency_phase = eegfilt(raw_data(x, :), sampling_rate, low_frequency(2, 1), []);
    low_frequency_phase = eegfilt(low_frequency_phase, sampling_rate, [], low_frequency(2, 2));
    low_frequency_phase = angle(hilbert(low_frequency_phase));

    % Find peaks and troughs
    alphaTroughEvents = find(low_frequency_phase < -(pi - 0.01));
    alphaPeakEvents = find((low_frequency_phase < (0 + 0.005)) & (low_frequency_phase > (0 - 0.005)));
    alphaTroughEvents = alphaTroughEvents(alphaTroughEvents > 20);
    alphaTroughEvents = alphaTroughEvents(alphaTroughEvents < (length(low_frequency_phase)-20));
    alphaPeakEvents = alphaPeakEvents(alphaPeakEvents > 20);
    alphaPeakEvents = alphaPeakEvents(alphaPeakEvents < (length(low_frequency_phase)-20));
    %clear low_frequency_phase
    
    % Calculate power around peaks/troughs
    troughPower(x, 1) = mean(ERP(high_frequency_amplitude, sampling_rate, thetaTroughEvents, window_size(1), window_size(1)));
    troughPower(x, 2) = mean(ERP(high_frequency_amplitude, sampling_rate, alphaTroughEvents, window_size(2), window_size(2)));
    peakPower(x, 1) = mean(ERP(high_frequency_amplitude, sampling_rate, thetaPeakEvents, window_size(1), window_size(1)));
    peakPower(x, 2) = mean(ERP(high_frequency_amplitude, sampling_rate, alphaPeakEvents, window_size(2), window_size(2)));
    %clear high_frequency_amplitude *Events
end
%%

% GET PEAK/TROUGH FOR 40band Hilbert
sampling_rate=400;
low_frequency = [4 8; 8 12]; % define theta and alpha bands
high_frequency = [80 150]; % define gamma band
sampling_rate = 400; % define sampling rate




% Define window around peaks and troughs to average gamma power
percent_window_size = 3 % +/- 5 percent window around peaks and troughs
window_size(1) = round(sampling_rate / ((low_frequency(1, 1) + low_frequency(1, 2)) / 2) .* percent_window_size);
window_size(2) = round(sampling_rate / ((low_frequency(2, 1) + low_frequency(2, 2)) / 2) .* percent_window_size);
clear percent_window_size

window_size=[1000 1000];


raw_data=ecogDS.data;
%high_frequency_amplitude=env.data;


thetaPower=zeros(256,2,2*window_size(1)/1000*400+1);
alphaPower=zeros(256,2,2*window_size(2)/1000*400+1);

for x = 1:size(raw_data, 1)
    % Extract high frequency analytic amplitude
    high_frequency_amplitude = eegfilt(raw_data(x, :), sampling_rate, high_frequency(1), []);
    high_frequency_amplitude = eegfilt(high_frequency_amplitude, sampling_rate, [], high_frequency(2));
    high_frequency_amplitude = abs(hilbert(high_frequency_amplitude));

    % Extract low frequency analytic phase
    low_frequency_phase = eegfilt(raw_data(x, :), sampling_rate, low_frequency(1, 1), []);
    low_frequency_phase = eegfilt(low_frequency_phase, sampling_rate, [], low_frequency(1, 2));
    low_frequency_phase = angle(hilbert(low_frequency_phase));

    % Find peaks and troughs
    thetaTroughEvents = find(low_frequency_phase < -(pi - 0.01));
    thetaPeakEvents = find((low_frequency_phase < (0 + 0.005)) & (low_frequency_phase > (0 - 0.005)));
    thetaTroughEvents = thetaTroughEvents(thetaTroughEvents > 20);
    thetaTroughEvents = thetaTroughEvents(thetaTroughEvents < (length(low_frequency_phase)-20));
    thetaPeakEvents = thetaPeakEvents(thetaPeakEvents > 20);
    thetaPeakEvents = thetaPeakEvents(thetaPeakEvents < (length(low_frequency_phase)-20));
    %clear low_frequency_phase

    % Extract low frequency analytic phase
    low_frequency_phase = eegfilt(raw_data(x, :), sampling_rate, low_frequency(2, 1), []);
    low_frequency_phase = eegfilt(low_frequency_phase, sampling_rate, [], low_frequency(2, 2));
    low_frequency_phase = angle(hilbert(low_frequency_phase));

    % Find peaks and troughs
    alphaTroughEvents = find(low_frequency_phase < -(pi - 0.01));
    alphaPeakEvents = find((low_frequency_phase < (0 + 0.005)) & (low_frequency_phase > (0 - 0.005)));
    alphaTroughEvents = alphaTroughEvents(alphaTroughEvents > 20);
    alphaTroughEvents = alphaTroughEvents(alphaTroughEvents < (length(low_frequency_phase)-20));
    alphaPeakEvents = alphaPeakEvents(alphaPeakEvents > 20);
    alphaPeakEvents = alphaPeakEvents(alphaPeakEvents < (length(low_frequency_phase)-20));
    %clear low_frequency_phase
    x
    % Calculate power around peaks/troughs

        thetaPower(x,1, :) =ERP(high_frequency_amplitude, sampling_rate, thetaTroughEvents, window_size(1), window_size(1));
        alphaPower(x,1, :) = ERP(high_frequency_amplitude, sampling_rate, alphaTroughEvents, window_size(2), window_size(2));
        thetaPower(x,2,:) = ERP(high_frequency_amplitude, sampling_rate, thetaPeakEvents, window_size(1), window_size(1));
        alphaPower(x,2,:) = ERP(high_frequency_amplitude, sampling_rate, alphaPeakEvents, window_size(2), window_size(2));
    %clear high_frequency_amplitude *Events
end
%%
%get ERP whole matrix

%allocate space--window size next odd number?
thetaPower=zeros(256,2,window_size(1));
alphaPower=zeros(256,2,window_size(2));

for x = 1:size(raw_data, 1)
    % Extract high frequency analytic amplitude
    high_frequency_amplitude = eegfilt(raw_data(x, :), sampling_rate, high_frequency(1), []);
    high_frequency_amplitude = eegfilt(high_frequency_amplitude, sampling_rate, [], high_frequency(2));
    high_frequency_amplitude = abs(hilbert(high_frequency_amplitude));

    % Extract low frequency analytic phase
    low_frequency_phase = eegfilt(raw_data(x, :), sampling_rate, low_frequency(1, 1), []);
    low_frequency_phase = eegfilt(low_frequency_phase, sampling_rate, [], low_frequency(1, 2));
    low_frequency_phase = angle(hilbert(low_frequency_phase));

    % Find peaks and troughs
    thetaTroughEvents = find(low_frequency_phase < -(pi - 0.01));
    thetaPeakEvents = find((low_frequency_phase < (0 + 0.005)) & (low_frequency_phase > (0 - 0.005)));
    thetaTroughEvents = thetaTroughEvents(thetaTroughEvents > 20);
    thetaTroughEvents = thetaTroughEvents(thetaTroughEvents < (length(low_frequency_phase)-20));
    thetaPeakEvents = thetaPeakEvents(thetaPeakEvents > 20);
    thetaPeakEvents = thetaPeakEvents(thetaPeakEvents < (length(low_frequency_phase)-20));
    %clear low_frequency_phase

    % Extract low frequency analytic phase
    low_frequency_phase = eegfilt(raw_data(x, :), sampling_rate, low_frequency(2, 1), []);
    low_frequency_phase = eegfilt(low_frequency_phase, sampling_rate, [], low_frequency(2, 2));
    low_frequency_phase = angle(hilbert(low_frequency_phase));

    % Find peaks and troughs
    alphaTroughEvents = find(low_frequency_phase < -(pi - 0.01));
    alphaPeakEvents = find((low_frequency_phase < (0 + 0.005)) & (low_frequency_phase > (0 - 0.005)));
    alphaTroughEvents = alphaTroughEvents(alphaTroughEvents > 20);
    alphaTroughEvents = alphaTroughEvents(alphaTroughEvents < (length(low_frequency_phase)-20));
    alphaPeakEvents = alphaPeakEvents(alphaPeakEvents > 20);
    alphaPeakEvents = alphaPeakEvents(alphaPeakEvents < (length(low_frequency_phase)-20));
    %clear low_frequency_phase
    x
    % Calculate power around peaks/troughs

        [thetaPower(x,1, :),th_tr{x}] =ERP(high_frequency_amplitude, sampling_rate, thetaTroughEvents, window_size(1), window_size(1),1);
        [alphaPower(x,1, :),al_tr{x}] = ERP(high_frequency_amplitude, sampling_rate, alphaTroughEvents, window_size(2), window_size(2),1);
        [thetaPower(x,2,:),th_pk{x}] = ERP(high_frequency_amplitude, sampling_rate, thetaPeakEvents, window_size(1), window_size(1),1);
        [alphaPower(x,2,:),al_pk{x}] = ERP(high_frequency_amplitude, sampling_rate, alphaPeakEvents, window_size(2), window_size(2),1);
    %clear high_frequency_amplitude *Events
end

%get std of all mean ERP's for each channel
for x=1:256
    std_th_tr(x)=std(mean(th_tr{x},2));
end
imagesc(reshape((std_th_tr),16,16)')




%%
zScore=squeeze(zscore(thetaPower(:,1,:),[],3));
zScore=squeeze(zscore(thetaPower(:,2,:),[],3));
zScore=squeeze(zscore(alphaPower(:,1,:),[],3));
zScore=squeeze(zscore(alphaPower(:,2,:),[],3));





usechans=[1:256];
figure

%PLOT ALL CHANNELS
for n=1:length(usechans)
    subplot(16,16,usechans(n));
    %p=get(h,'pos');
    %p(4)=p(4)+0.005;
    %p(3)=p(3)+0.008;
    %set(h,'pos',p);
    tmp=squeeze(zScore(usechans(n),:,:));
    %imagesc(tmp)
    plot(tmp)
    axis tight
    %text(1,maxZ-0.1,num2str(usechans(n)))
    %plot(meanOfBaseline(usechans(n),:),'c');
    %plot(meandata(usechans(n),:),'m')
end

%%
p=linspace(-pi,pi,20)
for i=1:19
    idx{i}=find(low_frequency_phase>p(i) & low_frequency_phase<p(i+1));;
    ave(i)=mean(high_frequency_amplitude(idx{i});
end
%%
%%make density plot
pac = zeros([size(raw_data, 1) size(low_frequency, 1) size(high_frequency, 1)]);
f=linspace(2,180,50);

high_frequency=[f(1:end-1)' f(2:end)']
low_frequency = [4 8; 8 12]

% Calculate PAC
for chanIt = 1:54%size(raw_data, 1)
    signal = raw_data(chanIt, :);
 
    for lowIt = 1:size(low_frequency, 1)
        
        disp(['Channel ' num2str(chanIt) ' Low Frequency ' num2str(lowIt)]);
        
        % Extract low frequency analytic phase
        low_frequency_phase = eegfilt(signal, sampling_rate, low_frequency(lowIt, 1), []);
        low_frequency_phase = eegfilt(low_frequency_phase, sampling_rate, [], low_frequency(lowIt, 2));
        low_frequency_phase = angle(hilbert(low_frequency_phase));
 
        for highIt = 1:47
            % Extract low frequency analytic phase of high frequency analytic amplitude
             tmp = eegfilt(signal, sampling_rate, high_frequency(highIt,1), []);
             tmp= eegfilt(tmp, sampling_rate, [], high_frequency(highIt,2));
             %high_frequency_amplitude{chanIt}(highIt,:) = abs(hilbert(tmp));
             high_frequency_amplitude_z{chanIt}(highIt,:) = zscore(abs(hilbert(tmp)),[],2);

        end
    end
end
%%
%Plot radial coupling
c=chanIt;
p=linspace(-pi,pi,100)
for c=1:29
    high_frequency_amplitude_z{c}=zscore(high_frequency_amplitude{c},[],2);
end



for c=[1,35,80]
    for j=1:size(high_frequency_amplitude_z{c},1);
        for i=1:length(p)-1
            idx{i}=find(low_frequency_phase>p(i) & low_frequency_phase<p(i+1));;
            ave{c}(j,i)=mean(high_frequency_amplitude_z{c}(j,idx{i}));
            %s{c}(j,i)=std(high_frequency_amplitude_z{c}(j,idx{i}));

        end
        clear idx
    end
end

[X,Y]=cylinder(1:size(high_frequency_amplitude_z{c},1),98);
figure

surf(X,Y,ave{c});
view(2)
shading interp

tmp=[p(2:end) p(1)];
p2=(tmp+p)/2;



[X2,Y2]=pol2cart(repmat(p2(1:end-1),[47,1]),repmat(high_frequency(1:47,2),[1,99]));
figure
surf(X2,Y2,zscore(ave{c},[],2));
view(2)
shading interp

figure;pcolor(zscore(ave{c},[],2));shading interp



shading interp

%%
%Phase Amp images improved
%Plot radial coupling
raw_data=detrend(ecogNormalized.data')';

sampling_rate = 400; % define sampling rate
f=linspace(2,170,50);
high_frequency=[f(1:end-1)' f(2:end)']
low_frequency = [4 8]
p=linspace(-pi,pi,100)

%low_frequency = [4 8; 8 12]

% Calculate PAC
channels=95
channels=[1 95]
channels=[1,38, 55, 95]
channels=1:256;
figure
for chanIt = channels %size(raw_data, 1)
    signal = raw_data(chanIt, :); 
    for lowIt = 1:size(low_frequency, 1)        
        disp(['Channel ' num2str(chanIt) ' Low Frequency ' num2str(lowIt)]);        
        % Extract low frequency analytic phase
        low_frequency_phase{chanIt}(lowIt,:) = eegfilt(signal, sampling_rate, low_frequency(lowIt, 1), []);
        low_frequency_phase{chanIt}(lowIt,:) = eegfilt(low_frequency_phase{chanIt}(lowIt,:), sampling_rate, [], low_frequency(lowIt, 2));
        low_frequency_phase{chanIt}(lowIt,:) = angle(hilbert(low_frequency_phase{chanIt}(lowIt,:)));
         for highIt = 1:47
            % Extract low frequency analytic phase of high frequency analytic amplitude
             tmp = eegfilt(signal, sampling_rate, high_frequency(highIt,1), []);
             tmp= eegfilt(tmp, sampling_rate, [], high_frequency(highIt,2));
             %high_frequency_amplitude{chanIt}(highIt,:) = abs(hilbert(tmp));
             high_frequency_amplitude_z{chanIt}(highIt,:) = zscore(abs(hilbert(tmp)),[],2);
         end
    end
     for j=1:size(high_frequency_amplitude_z{chanIt},1);
        for i=1:length(p)-1
            idx{i}=find(low_frequency_phase{chanIt}(lowIt,:)>p(i) & low_frequency_phase{chanIt}(lowIt,:)<p(i+1));;
            ave{chanIt}(j,i)=mean(high_frequency_amplitude_z{chanIt}(j,idx{i}));
            %s{chanIt}(j,i)=std(high_frequency_amplitude_z{chanIt}(j,idx{i}));
        end
        %clear idx
     end
     m=floor(chanIt/16);
     n=rem(chanIt,16);

     if n==0
         n=16;
         m=m-1;
     end

     po(1)=6*(n-1)/100+.03;
     po(2)=6.2*(15-m)/100+0.01;

     po(3)=.055;
     po(4)=.055; 
     h=subplot('Position',po);
     
    pcolor(ave{chanIt});shading interp
    text(1,0,num2str(chanIt))
    set(gca,'xtick',[],'ytick',[])  
    keep raw_data sampling_rate f high_frequency low_frequency p channel

end

p=linspace(-pi,pi,100)

for chanIt=channels
    for j=1:size(high_frequency_amplitude_z{chanIt},1);
        for i=1:length(p)-1
            idx{i}=find(low_frequency_phase{chanIt}(lowIt,:)>p(i) & low_frequency_phase{chanIt}(lowIt,:)<p(i+1));;
            ave{chanIt}(j,i)=mean(high_frequency_amplitude_z{chanIt}(j,idx{i}));
            %s{chanIt}(j,i)=std(high_frequency_amplitude_z{chanIt}(j,idx{i}));
        end
        %clear idx
    end
end

for chanIt=channels
    figure;pcolor(ave{chanIt});shading interp
    title(num2str(chanIt))
end

%{
[X,Y]=cylinder(1:size(high_frequency_amplitude_z{c},1),98);
figure

surf(X,Y,ave{c});
view(2)
shading interp

tmp=[p(2:end) p(1)];
p2=(tmp+p)/2;



[X2,Y2]=pol2cart(repmat(p2(1:end-1),[47,1]),repmat(high_frequency(1:47,2),[1,99]));
figure
surf(X2,Y2,zscore(ave{c},[],2));
view(2)
shading interp
%}










