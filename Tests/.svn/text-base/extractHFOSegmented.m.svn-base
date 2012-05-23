SStmp=ecogH.badIntervals;
%%
%SS=Skeep;
%%
%SS=SS(find(diff(SS(:,2))>1),:);

buffer=round([250 250].*1200/1000); %in ms
figure
f=1200;
Skeep=[];
for i=1:size(SStmp,1)
    d=ecogH.zscore(SStmp(i,3),SStmp(i,1)*1200:SStmp(i,2)*1200);
    SS(i,2)=(find(d==max(d))+SStmp(i,1)*1200)/1200;
    SS(i,1)=SStmp(i,3);
    indices=round([ SS(i,2)*1200-buffer(1):SS(i,2)*1200+buffer(2)]);
    try
        d=ecogH.zscore(SS(i,1),indices);
         if 1%kurtosis(d)>5
                    d=ecogH.bandpassed(SS(i,1),indices);
                    subplot(2,2,1)
                    L=buffer*2;
                    plot(d)        
                    %hold on
                    %hl=line([0 L],[5 5]);
                    %set(hl,'Color','r')
                    %L=S(i).samps(j,2)-S(i).samps(j,1);
                    axis tight;
                    %mx=max(d);
                    %mn=min(d);
                    %h=patch([buffer,buffer+L,buffer+L,buffer], [mn mn mx mx],'y');
                    %set(h,'FaceAlpha',.5)
                    %set(h,'EdgeColor','none')
                    title('Envelope Zscore')
                    title(int2str(kurtosis(d)))
                    hold off


                    subplot(2,2,2)
                    
                    %{
                    title('Bandpassed, Envelop, smoothed Envelop (200-400 Hz)')
    
                    d=ecogH.bandpassed(SS(i,1),indices);
                    plot(d)
                    hold on
                    s=ecogH.env(SS(i,1),indices);
                    plot(s,'r')
                    plot(smooth(s,50),'g')
                    axis tight
                    mx=max(d);
                    mn=min(d);
                    %h=patch([buffer,buffer+L,buffer+L,buffer],[mn mn mx mx],'y');
                    %set(h,'FaceAlpha',.5)
                    %set(h,'EdgeColor','none')
                    title('Bandpassed')
                 
                    %imagesc(squeeze(zscore(handles.ecogFiltered.data(SS(i,1),indices,:),[],2))')
                    %visualizeGrid(2,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' 'EC8' '\brain_3Drecon.jpg'],SS(i,1))
%}
                    
                    
                    
                    
                    %RUN THIS TO LOOK AT THE DATA.
                    %{
                    d=handles.ecogDS.data(SS(i,1),indices);
                    [s,cf]=mtspectrumc(d',ecog.periodogram.params);
                    p=[]
                    s=s'
                    for k=periodogramFrequencyband(1):periodogramFrequencyband(2)-1 % New periodogram has 1HZ resolution
                        p=[p mean(s(:,nearly(k,cf):nearly(k+1,cf)),2)];
                    end
                    
                    
                    
                    plot(log10(p));
                    
                    hold off
%}
                    subplot(2,2,3)
                    d=handles.ecogDS.data(SS(i,1),indices);
                    plot(d)
                    hold on
                    axis tight
                    mx=max(d);
                    mn=min(d);
                    %h=patch([buffer,buffer+L,buffer+L,buffer],[mn mn mx mx],'y');
                    %set(h,'FaceAlpha',.5)
                    %set(h,'EdgeColor','none')
                    title('Original Signal (1200 Hz)')
                    hold off

                    subplot(2,2,4)

                    v5 = wav2aud(d,[10 200 -2 log2(1200/16000)]);
                    aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(1200/16000)]);
                    %aud_plot((v5'.^.5)',[10 10 -2 log2(f/16000)]);
                    title('spectrogram')



                    set(gcf,'Name',sprintf('Channel: %i, Time: %0.2f sec',SS(i,1),SS(i,2)));
                    r=input('Next','s');
                    switch r
                        case 'b'
                            i=i-2;
                        case 'l'
                        otherwise                
                           Skeep=[Skeep; SS(i,:)];
                    end
         end
    end
end

%%


%%
%%
ecogDS=handles.ecogDS;
printf('Calculating Periodogram...')
periodogramFrequencyband=[0 600]; % the frequency band to look at
badChannels=[]; % Enter bad channels from periodogram here*****CHANGE THIS!!
showInGuiOrSingleChannel=showIndividual; % 'g' for GUI 's'for a sequence of single channel plots
%showFrequencyBandInSingleChannelDisplay=periodogramFrequencyband; % [1 20];% if you want to focuson a certain frequency band to detect bad channels in the single channel display
showFrequencyBandInSingleChannelDisplay=[1 600];% if you want to focuson a certain frequency band to detect bad channels in the single channel display

%RUN THIS TO LOOK AT THE DATA.
params.Fs=ecogDS.sampFreq; 
params.fpass=periodogramFrequencyband;
params.tapers=[2*(size(ecogDS.data,2)/1200)/1000/10 5];
ecogDS=ecogMkPeriodogramMultitaper(ecogDS,1,params)
%fStepsPerHz=1/(ecogDS.periodogram.centerFrequency(2)-ecogDS.periodogram.centerFrequency(1));
p=[];
count=1;
ecogDS.periodogram.periodogram=ecogDS.periodogram.periodogram';
figure
for k=periodogramFrequencyband(1):periodogramFrequencyband(2)-1 % New periodogram has 1HZ resolution
    p=[p mean(ecogDS.periodogram.periodogram(:,nearly(k,ecogDS.periodogram.centerFrequency):nearly(k+1,ecogDS.periodogram.centerFrequency)),2)];
end
f=[periodogramFrequencyband(1):periodogramFrequencyband(2)-1];
logPeriodogram=log10(p);
surf(logPeriodogram)

%%
figure
for i=1:size(Skeep,1)
     indices=round([ Skeep(i,2)*1200-buffer:Skeep(i,2)*1200+buffer]);
     s(i,:)=ecogH.data(Skeep(i,1),indices);
     d(i,:)=handles.ecogDS.data(Skeep(i,1),indices);
     %m=mean(cat(4,HFO.env));
     %s=std(cat(4,HFO.env),[],4);
     %subplot(3,7,i)
     %d=s(i,:);
     subplot(2,1,1)
     plot(d(i,:))
          subplot(2,1,2)

          plot(s(i,:))

     %specgram(d,100,1200)
    %v5 = wav2aud(d,[10 200 -2 log2(f/16000)]);
    %aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(f/16000)]);     
    r=input('next')
end
%%



processingPlotAllChannels_inputZscoreGUI(d,'k',1,[],[],s)
%%
for i=1:size(SS,1)
    subplot(2,2,1)
                d=handles.ecogDS.data(SS(i,1),indices);
                plot(d)
                hold on
                axis tight
                mx=max(d);
                mn=min(d);
                %h=patch([buffer,buffer+L,buffer+L,buffer],[mn mn mx mx],'y');
                %set(h,'FaceAlpha',.5)
                %set(h,'EdgeColor','none')
                title('Original Signal (1200 Hz)')
                hold off

                subplot(2,2,4)

                v5 = wav2aud(d,[10 200 -2 log2(f/16000)]);
                aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(f/16000)]);
                %aud_plot((v5'.^.5)',[10 10 -2 log2(f/16000)]);
                title('spectrogram')

                subplot(2,2,3)
                d2=handles.ecogFiltered.data(SS(i,1),indices,:);
                imagesc(squeeze(zscore(d2,[],2))'); 
                hold off

                set(gcf,'Name',sprintf('Channel: %i, Time: %0.2f sec',SS(i,1),SS(i,2)));
                r=input('Next','s');
                switch r
                    case 'b'
                        j=j-2;
                    case 'n'
                    otherwise                
                       Skeep=[Skeep; SS(i,:)];
                end



            
end
    
%%
subj='EC2'
subj='EC8'
subj='GP31'
try
    N2=histc(Skeep(:,1),1:256);
catch
    N2=zeros(256,1);
endfigure
flag=5;
visualizeGrid(flag,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' subj '\brain_3Drecon.jpg'],1:256,repmat(N2,[1,2])')


%%
for i=1:size(SS,1)
    jk=1;
    for j=1:size(S(i).samps,1)
        %d=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        if 1%length(find(d>5))>25 & kurtosis(d)>10
            d=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);

            subplot(2,2,1)
            L=buffer*2;
            plot(d)        
            hold on
            hl=line([0 L],[5 5]);
            set(hl,'Color','r')
            %L=S(i).samps(j,2)-S(i).samps(j,1);
            axis tight;
            mx=max(d);
            mn=min(d);
            %h=patch([buffer,buffer+L,buffer+L,buffer], [mn mn mx mx],'y');
            %set(h,'FaceAlpha',.5)
            %set(h,'EdgeColor','none')
            title('Envelope Zscore')
            hold off


            subplot(2,2,2)
            title('Bandpassed, Envelop, smoothed Envelop (200-400 Hz)')

            d=ecogH.bandpassed(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
            plot(d)
            hold on
            s=ecogH.env(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
            plot(s,'r')
            plot(smooth(s,50),'g')
            axis tight
            mx=max(d);
            mn=min(d);
            %h=patch([buffer,buffer+L,buffer+L,buffer],[mn mn mx mx],'y');
            %set(h,'FaceAlpha',.5)
            %set(h,'EdgeColor','none')
            title('Bandpassed')

            hold off

            subplot(2,2,3)
            d=handles.ecogDS.data(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
            plot(d)
            hold on
            axis tight
            mx=max(d);
            mn=min(d);
            %h=patch([buffer,buffer+L,buffer+L,buffer],[mn mn mx mx],'y');
            %set(h,'FaceAlpha',.5)
            %set(h,'EdgeColor','none')
            title('Original Signal (1200 Hz)')
            hold off

            subplot(2,2,4)
            v5 = wav2aud(d,[10 200 -2 log2(f/16000)]);
            aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(f/16000)]);
            %aud_plot((v5'.^.5)',[10 10 -2 log2(f/16000)]);
            title('spectrogram')



            set(gcf,'Name',sprintf('Channel: %i, Time: %0.2f sec',S(i).ch,S(i).samps(j,1)/1200));
            r=input('Next','s');
            switch r
                case 'b'
                    j=j-2;
                case 'n'
                otherwise                
                    Skeep(k).examples=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
                    Skeep(k).samps(jk,:)=S(i).samps(j,:);
                    Skeep(k).ch=S(i).ch;
                    k=k+1;
                    jk=jk+1;

            end
        end
    end
end
    

%%
%SS is 2 column matrix, 1st column is time in seconds of detected event,
%and 2nd column is channel number

%GET HFO ENV, PHASE,DOWNSAMPLED, CHANNEL,SUBJECTID, BlockID FOR DETECTED EVENTS
load('C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\HFO\Files\EC8_B38_HFO20secidx.mat');
filename='E:\PreprocessedFiles\EC8\EC8_B38'
filename='E:\PreprocessedFiles\GP31\GP31_B73'
filename='E:\PreprocessedFiles\EC2\EC2_B97'


%%
SS=Skeep;
%%
buffer=[1000 1000]; %ms before and after event
time=(SS(:,2)*1000); %time of event in ms

for i=1:size(SS,1)
    
    cd([ filename '\HilbReal_4to500_45band_1200Hz'])
    timeInt=[time(i)-buffer(1),time(i)+buffer(2)];
    chanNum=SS(i,1);
    r=loadHTKtoEcog_CT(pwd,256,timeInt)';    
    cd([ filename '\HilbImag_4to500_45band_1200Hz'])
    im=loadHTKtoEcog_CT(pwd,256,timeInt)';
    tmp=complex(r.data(:,:,:),im.data(:,:,:));
    HFO(i).complex_data=tmp;

    %tmp=squeeze(tmp)';
    
    %HFO(i).env=abs( HFO(i).complex_data);
    %HFO(i).phase=angle( HFO(i).complex_data);
    HFO(i).timeInt=timeInt;
    HFO(i).ch=chanNum;
   
    ecog=loadHTKtoEcog_CT([filename filesep 'RawHTK'],256,timeInt)
    baselineDurMs=0;
    sampDur=1000/ecog.sampFreq;
    ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
    sprintf('Length of Recording: %i\n',size(ecog.data,2)/ecog.sampFreq);
    tmp=downsampleEcog(ecog,1200);
    HFO(i).ds=tmp.data;
   
    HFO(i).subject='EC8';
    HFO(i).block='EC8_B38';
    
    
end

%%
 %Calculate phase of low frequency vs amp of high frequency for multiple
 %low frequency bands
 low_freq_band=[1:30];
 high_freq_band=41;%[1:45];
 chanTot=256;
 p=linspace(-pi,pi,100);

 
 for ec=1:2%length(HFO)
    for c=1:chanTot
        for lc=1:length(low_freq_band)
            low_frequency_phase{c}(lc,:)=HFO(ec).phase(c,:,low_freq_band(lc));
            for hc=1:length(high_freq_band)
                high_frequency_amplitude_z{c}(hc,:)=zscore(HFO(ec).env(c,:,high_freq_band(hc)));
            end
        end
         for lc=1:size(low_frequency_phase{c},1);
            for i=1:length(p)-1
                %get analytic amplitude of high frequency signal at every phase
                %of low frequency
                idx{i}=find(low_frequency_phase{c}(lc,:)>p(i) & low_frequency_phase{c}(lc,:)<p(i+1));
                ave_amp_phase(ec).matrix(c,lc,i)=mean(high_frequency_amplitude_z{c}(1,idx{i}));
            end
        end
    end
 end
 
 %%
 %CALCULATE PAC
  low_freq_band=[1:30];
 high_freq_band=41;%[1:45];
 pac = zeros([256 size(low_freq_band, 2) size(high_freq_band, 2)]);
 chanTot=256;
 p=linspace(-pi,pi,100);
 
  for ec=1:length(HFO)
    for c=1:chanTot
        for lc=1:length(low_freq_band)
            low_frequency_phase{c}(lc,:)=HFO(ec).phase(c,:,low_freq_band(lc));
            for hc=1:length(high_freq_band)
                high_frequency_amplitude{c}(hc,:)=zscore(HFO(ec).env(c,:,high_freq_band(hc)));
                tmp=fft(high_frequency_amplitude{c}(hc,:));
                T=size(tmp,2);
                [H,h]=makeHilbWindow_1200(T,low_freq_band(lc));
                high_frequency_phase{c}(lc,:)=angle(ifft(tmp.*(H.*h),T));

                % Calculate PAC
               pac(c,lc,hc) =...
                    abs(sum(exp(1i * (low_frequency_phase{c}(lc,:) - high_frequency_phase{c}(lc,:))), 'double'))...
                    / length(high_frequency_phase{c}(lc,:));
            end
        end
    end
    ave_amp_phase(ec).pac=pac;
  end
%%  
plotAmpPhasePolar256(ave_amp_phase(1).matrix)
plotAmpPhaseCart256(ave_amp_phase(1).matrix)

 %%
 %PLOT PACS
 figure
 pac=mean(cat(4,ave_amp_phase.pac),4);
 x=zscore(pac,[],1);
 patient='EC8';
for i=1:30
    h=subplot(5,6,i);
    p=get(h,'Position');
    visualizeGrid(1,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patient '\brain_3Drecon.jpg'],1:256,x(:,i))

    %imagesc(reshape(pac(:,i),16,16)')
    set(h,'Position',[p(1),p(2),p(3)+.03,p(4)+.03]);
end
%%
%plot PAC across LF
 figure
  processingPlotAllChannels_inputZscoreGUI(pac,'k',1,[])
  %%
  %plot PAC normalized by average AA of each band
figure
 ave_AA=squeeze(mean(HFO(1).env(:,:,1:30),2));
 processingPlotAllChannels_inputZscoreGUI(pac./ave_AA,'k',1,[])

 %%
 %Plot the amplitude/phase plot for 1 low frequency band
 lf=[5,10,15]%frequency band number
 
 z=squeeze(zscore(ave_amp_phase(1).matrix(:,lf,:),[],3));

%%
 figure
 processingPlotAllChannels_inputZscoreGUI(smooth(squeeze(z(:,1,:))),'k',50,[])
 
 %%
deg=[1 25 50 75]; %get power at different phases (-pi, -pi/2, 0, pi/2)

z2=z(:,deg);

patient='EC2'
p=linspace(-pi,pi,99);
for c = 1:99, lab{99}=p(c);end
 
 F = ECogDataMovie(['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patient],patient,1:256,z,linspace(-pi,pi,99));
 
 
 %%
lf=5
AV=mean(cat(4,ave_amp_phase.matrix),4);

s=1;
for i=1:10
    try
        w(:,i)=mean(AV(:,lf,s:s+9),3)';
    catch
        w(:,i)=mean(AV(:,lf,s:end),3)';
    end
    s=s+10;
end
w=zscore(w,[],2);

figure
for i=1:10
    h=subplot(2,5,i)
    p=get(h,'Position')

    %x=squeeze(mean(m_norm(i,:,:),3));
    x=squeeze(w(:,i));
    visualizeGrid(1,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patient '\brain_3Drecon.jpg'],1:256,x)
    set(h,'Position',[p(1),p(2),p(3)+.03,p(4)+.03])

end

 
 %%
 %MODULATION INDEX WITH HILBERT OUTPUT
 
 low_freqs=1:30;
 high_freqs=41;
 hf=41;
 for lf=low_freqs
     for jj=1:10 
        for c=1:256
            x=HFO(jj).ds(c,:);
            srate=400;    %% sampling rate used in this study, in Hz 
            numpoints=length(x);   %% number of sample points in raw signal 
            numsurrogate=200;   %% number of surrogate values to compare to actual value 
            minskip=srate;   %% time lag must be at least this big 
            maxskip=numpoints-srate; %% time lag must be smaller than this 
            skip=ceil(numpoints.*rand(numsurrogate*2,1)); 
            skip(find(skip>maxskip))=[]; 
            skip(find(skip<minskip))=[]; 
            skip=skip(1:numsurrogate,1); 
            surrogate_m=zeros(numsurrogate,1);  


            %% HG analytic amplitude time series, uses eegfilt.m from EEGLAB toolbox  
            %% (http://www.sccn.ucsd.edu/eeglab/) 
            %amplitude=abs(hilbert(eegfilt(x,srate,80,150))); 
            amplitude=HFO(jj).env(c,:,hf);
            %% theta analytic phase time series, uses EEGLAB toolbox 
            phase=HFO(jj).phase(c,:,lf);
            %% complex-valued composite signal 
            z=amplitude.*exp(i*phase); 
            %% mean of z over time, prenormalized value 
            m_raw=mean(z);  
            %% compute surrogate values 
               for s=1:numsurrogate 
                  surrogate_amplitude=[amplitude(skip(s):end) amplitude(1:skip(s)-1)]; 
                  surrogate_m(s)=abs(mean(surrogate_amplitude.*exp(i*phase))); 
                  disp(numsurrogate-s); 
               end 
            %% fit gaussian to surrogate data, uses normfit.m from MATLAB Statistics toolbox 
            [surrogate_mean,surrogate_std]=normfit(surrogate_m); 
            %% normalize length using surrogate data (z-score) 
            m_norm_length=(abs(m_raw)-surrogate_mean)/surrogate_std; 
            m_norm_phase=angle(m_raw); 
            m_norm(lf,c,jj)=m_norm_length*exp(i*m_norm_phase); 
        end
     end
 end
%%
figure
for i=1:30
    subplot(5,6,i)


imagesc(reshape(squeeze(mean(m_norm(i,:,:),3)),16,16)')
end

%%
%Amplitude/Amplitude Correlation

%Ampltitude correlation between frequencies
for seg=1:16
    for i=1:256
        X=squeeze(zscore(abs(HFO(seg).complex_data(i,:,35:45)),[],2));
        r=corrcoef(X);
        %X2(seg,i,:,:)=r;
        X3(seg,i,:,:)=r;

    end
end
X_all=X2;
X2=squeeze(mean(X_all,1));
processingPlotAllSpectrograms_inputZscoreGUI(X2,50,[],[-1,1]);
%%
env_all=abs(cat(4,HFO.complex_data));
processingPlotSingleStacked_inputZscoreGUI(env_all(:,:,41,:),50,[]);

ds_all=cat(3,HFO.ds);
figure
processingPlotAllChannels_inputZscoreGUI(mean(ds_all,3),'k',300,[],[-1 1]);


%%
processingPlotAllSpectrograms_inputZscoreGUI(zscore(mean(abs(cat(4,HFO.complex_data)),4),[],1),50,[]);
%%
figure;hold on;
for i=1:10
    plot(abs(HFO(i).complex_data(95,:,41)))
end
for i=1:10
    plot(abs(HFO(i).complex_data(1,:,2)))
end

%%
figure
tmp=squeeze(X2(:,41,:));
processingPlotAllChannels_inputZscoreGUI(tmp,'k',300,[],[-1 1]);

    
    

%%
figure;
processingPlotAllChannels_inputZscoreGUI(HFO(1).ds,'k',300,[])
%%
figure;
processingPlotAllChannels_inputZscoreGUI(abs(HFO(1).complex_data(:,:,41)),'k',300,[])

%%
processingPlotAllSpectrograms_inputZscoreGUI(zscore(abs(HFO(5).complex_data),[],2),50,[]);
%%
figure
processingPlotAllChannels_inputZscoreGUI(squeeze(X2(:,41,:)),'k',300,[])
%%
%Amp/Amp corr across Channels
r=corrcoef(HFO(1).ds');
imagesc(r)




for i=1:256
    reshaped_r(i,:,:)=reshape(r(i,:),[16,16])';
end
processingPlotAllSpectrograms_inputZscoreGUI(reshaped_r,50,[],[-1 1]);

%%
%Take a look at basic time/frequency characteristics of FRs and Ripples
f=1200;
figure
for i=1:16
    
    %j=r(i)
    subplot(4,4,i)
    d=squeeze(HFO(i).ds(SS(i,1),:,:));
    %periodogram(d,[],[],1200);
    %specgram(d,100,1200);
    %plot(d)
    %axis tight
    %imagesc(flipud(squeeze(zscore(abs(HFO(i).complex_data(SS(i,1),:,:)),[],2))'))
    v5 = wav2aud(d,[10 200 -2 log2(f/16000)]);
    aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(f/16000)]);
end


%%
for i=1:18
    env=HFO(i).env(:,:,:),[],2)');
end
%%
buffer=[1000 1000];
figure
for i=1:16
    %d1(i,:)=handles.ecogDS.data(SS(i,1),ceil(SS(i,2)*1200-300:SS(i,2)*1200+300));
    
    d3(i,:)=handles.ecogDS.data(SS(i,1),ceil(SS(i,2)*1200-2400:SS(i,2)*1200+2400));
    subplot(4,4,i)
    %specgram(d3(i,:),[],1200)
   v5 = wav2aud(d3(i,:),[10 200 -2 log2(f/16000)]);
   aud_plot(mapstd(v5'.^.5)',[10 200 -2 log2(f/16000)]);
   hold on
   
   plot(resample(d3(i,:)/15,5,6),'r');axis tight

end


%%
for i=1:16
    subplot(4,4,i)
    imagesc(corrcoef(squeeze(abs(HFO(i).complex_data(SS(i,1),:,:)))),[-1 1])
end

%%
processingPlotAllChannels_inputZscoreGUI(mean(cat(3,HFO.ds)),'k',300,[],[],std(cat(3,HFO.ds),[],3))

%%
figure
for i=1:size(Skeep,1)
    d=handles.ecogDS.data(Skeep(i,1),indices);
    plot(d);
    hold on
    axis tight
    plot([1200,1200],[-100 100],'r')
    r=input('s','s');
    hold off
    if ~strmatch('l',r)
        Skeep2(i,:)=Skeep(i,:);
    end
end