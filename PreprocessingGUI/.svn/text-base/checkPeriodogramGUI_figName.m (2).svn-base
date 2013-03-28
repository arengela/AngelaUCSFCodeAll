function [ecogDS,badFreqs]=checkPeriodogramGUI_figName(ecogDS,showIndividual,figName)
printf('Calculating Periodogram...')
periodogramFrequencyband=[0 200]; % the frequency band to look at
badChannels=[]; % Enter bad channels from periodogram here*****CHANGE THIS!!
showInGuiOrSingleChannel=showIndividual; % 'g' for GUI 's'for a sequence of single channel plots
%showFrequencyBandInSingleChannelDisplay=periodogramFrequencyband; % [1 20];% if you want to focuson a certain frequency band to detect bad channels in the single channel display
showFrequencyBandInSingleChannelDisplay=[1 200];% if you want to focuson a certain frequency band to detect bad channels in the single channel display

%RUN THIS TO LOOK AT THE DATA.
params.Fs=ecogDS.sampFreq; 
params.fpass=periodogramFrequencyband;
params.tapers=[2*(size(ecogDS.data,2)/400)/1000/10 5];
ecogDS=ecogMkPeriodogramMultitaper(ecogDS,1,params);
%fStepsPerHz=1/(ecogDS.periodogram.centerFrequency(2)-ecogDS.periodogram.centerFrequency(1));
p=[];
count=1;
ecogDS.periodogram.periodogram=ecogDS.periodogram.periodogram';
figure
set(gcf,'Color','w')
set(gcf,'Name','Periodogram')

for k=periodogramFrequencyband(1):periodogramFrequencyband(2)-1 % New periodogram has 1HZ resolution
    p=[p mean(ecogDS.periodogram.periodogram(:,nearly(k,ecogDS.periodogram.centerFrequency):nearly(k+1,ecogDS.periodogram.centerFrequency)),2)];
end

f=[periodogramFrequencyband(1):periodogramFrequencyband(2)-1];
logPeriodogram=log10(p);
surf(logPeriodogram)
currentFolder=pwd;
cd('Figures')
saveas(gcf,figName,'fig')
cd(currentFolder);

if ~exist('showInGuiOrSingleChannel')
    showInSingleChannel=input('Show in single channel? (y/n):','s');
end

if ~strcmp(showInGuiOrSingleChannel,'n')
    idx=nearly(showFrequencyBandInSingleChannelDisplay,f);
    f=f(idx(1):idx(2));
    s=std(log10(p(ecogDS.selectedChannels,idx(1):idx(2))));
    m=mean(log10(p(ecogDS.selectedChannels,idx(1):idx(2))));
    
    %{
    for k=1:256
        subplot(16,16,k);
        plot(f,log10(p(k,idx(1):idx(2))),'r');
        text(0,1,num2str(k))
    end
    %}
    
    
    badFreqs=[];
    figure
    k=1;
    
    badauto=[];
    while k<=size(ecogDS.periodogram.periodogram,1)
        plot(f, m-s,'k-');
        hold on
        plot(f, m+s,'k-');
        %[mintab,maxtab]=peakdet(ecogDS.periodogram.periodogram(k,:),0.3);
        plot(f,log10(p(k,idx(1):idx(2))),'r');
        %plot(mintab(:,1), mintab(:,2), 'g*');
        %plot(maxtab(:,1), maxtab(:,2), 'c*');
        title(['Channel #: ' num2str(k)]);
        legend('mean +- 1 std','','current channel')
        xlabel('frequency [Hz]');
        ylabel('log energy [log10 uV]')
        hold off;
        %{
        
        r=input('good channel? Enter "f" to get bad freq. [y]/f/n/b ','s');
        if isempty(r) || strcmpi('y',r)
            % skip this channel
        elseif strcmpi('n',r)
            badChannels=[badChannels k];
        elseif strcmpi('f',r)
            r=input('same as previous? [y]/n ','s');
            if isempty(r) || strcmpi('y',r)
                badFreqs=[badFreqs; [1 1 k]];
            end
            while strcmpi('n',r)
                RECT=getrect;
                badFreqs=[badFreqs; RECT(1) RECT(1)+RECT(3) k];
                r=input('go to next channel? [y]/n ','s');
            end
        
        elseif strcmpi('b',r)
            k=k-2;
        else
            disp('Inavlid answer. Keeping channels marked good')
            % skip this channel
        end
        k=k+1;
        %}
        
        
        %% Calculate deviation from average
        dev=abs(log10(p(k,idx(1):idx(2)))-m);
        
        dev2=mean(abs(s)-abs(dev))<0.01;
        hold on
        ht=text(5,0,num2str(mean(abs(s)-abs(dev))));
        if dev2==1
            set(ht,'Color','g')
            badauto=[badauto k];
            assignin('base','badauto',badauto)
        end
        
        hold off

        r=input('Press ENTER for next channel, b for back, n for bad Channel','s');
        if isempty(r) || strcmpi('y',r)
            % skip this channel
        elseif strcmpi('n',r)
            ecogDS.badChannels=[ecogDS.badChannels k];
        elseif strcmpi('f',r)
            r=input('same as previous? [y]/n ','s');
            if isempty(r) || strcmpi('y',r)
                badFreqs=[badFreqs; [1 1 k]];
            end
            while strcmpi('n',r)
                RECT=getrect;
                badFreqs=[badFreqs; RECT(1) RECT(1)+RECT(3) k];
                r=input('go to next channel? [y]/n ','s');
            end
        
        elseif strcmpi('b',r)
            k=k-2;
        elseif strcmpi('q',r)
            k=size(ecogDS.periodogram.periodogram,1)+1;
        else
            disp('Inavlid answer. Keeping channels marked good')
            % skip this channel
        end
        k=k+1;
        
        
    end
    
    
end

if isfield(ecogDS, 'badChannels')
    ecogDS.badChannels=unique([ecogDS.badChannels badChannels]);
end
%{
%Set bad channels and make sure there are no copies
ecogDS.badChannels=unique([ecogDS.badChannels badChannels]);
handles.badChannels=ecogDS.badChannels;
%}
if ~exist('badFreqs')
    badFreqs=[];
end
