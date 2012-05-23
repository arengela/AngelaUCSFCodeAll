%load HTK files
filename='E:\PreprocessedFiles\EC8\EC8_B46';
handles.ecog=loadHTKtoEcog_CT([filename filesep 'RawHTK'],256,[])
baselineDurMs=0;
sampDur=1000/handles.ecog.sampFreq;
handles.ecog=ecogRaw2EcogGUI(handles.ecog.data,baselineDurMs,sampDur,[],handles.ecog.sampFreq);
sprintf('Length of Recording: %i\n',size(handles.ecog.data,2)/handles.ecog.sampFreq);

handles.ecogDS.sampFreq=1200;
handles.ecogDS=downsampleEcog(handles.ecog,handles.ecogDS.sampFreq);
handles.ecogDS.sampFreq=1200;

handles.ecogDS.sampDur=1000/handles.ecogDS.sampFreq;
%%

[b,a]=fir2(9000,[0 70 80 140 150 600]/600,[0 0 1 1 0 0]);
%figure
%freqz(b,a,[],1200)
ecogLow.data=filtfilt(b,a,handles.ecogDS.data')';

%HFO(200-500 Hz)
[b,a]=fir2(9000,[0 200 210 490 500 600]/600,[0 0 1 1 0 0]);
%figure
%freqz(b,a,[],1200)
ecogHigh.data=filtfilt(b,a,handles.ecogDS.data')';
%%
handles.ecogDS.selectedChannels=1:size(handles.ecogDS.data,1);
handles.ecogDS.sampDur=1000/1200;
handles.ecogDS.sampFreq=1200;
handles.ecogDS.timebase=[0:(size(handles.ecogDS.data,2)-1)]*handles.ecogDS.sampDur;
handles.ecogDS.badChannels=[];
%handles.ecogDS.badTimeSegments=[];
%handles.ecogDS.badIntervals=[]
try
    cd([filename filesep 'Artifacts'])
    load 'badTimeSegments.mat';
    handles.ecogDS.badIntervals=badTimeSegments;

    fid = fopen('badChannels.txt');
    tmp = fscanf(fid, '%d');
    handles.ecogDS.badChannels=tmp';
    fclose(fid);
catch
    handles.ecogDS.badChannels=[];
    handles.ecogDS.badIntervals=[];
end

%%
[~, handles.ecogDS.badIntervals]=ecogTSGUI(handles.ecogDS)
%%
for i=1:size(handles.ecogDS.badIntervals,2)
    seg=round(handles.ecogDS.badIntervals(i,1:2)*handles.ecogDS.sampFreq);
    ecogLow.data(:,seg(1):seg(2))=0;
    ecogHigh.data(:,seg(1):seg(2))=0;
end

ecogLow.data(handles.ecogDS.badChannels,:)=0;
ecogHigh.data(handles.ecogDS.badChannels,:)=0;


%%
%get HFOs
ecogLow=HFODetectionFunction(ecogLow);

ecogHigh=HFODetectionFunction(ecogHigh);

%%
%visualize
ecogH=ecogHigh;
%%
ecogH=ecogLow;
%%
ecogH.data=handles.ecogDS.data;
%%
figure;plot(ecogHigh.x,ecogHigh.y,'r.');
hold on
plot(ecogLow.x,ecogLow.y,'.');
%%
figure
patient='EC8'
N2=[ecogHigh.hfoCounts ecogLow.hfoCounts]';
visualizeGrid(5,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patient '\brain_3Drecon.jpg'],1:256,N2)
%%
N2=[ecogHigh.hfoCounts ecogLow.hfoCounts]';
%%
figure
subplot(1,2,2)
imagesc(reshape(N2(1,:),16,16)')

r=16; c=16;
set(gca,'XGrid','on')
set(gca,'YGrid','on')
set(gca,'XTick',[1.5:16.5])
set(gca,'YTick',[1.5:(r+.5)])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
for c=1:16
    for r=1:r
        text(c,r,num2str((r-1)*16+c))
        if ismember((r-1)*16+c,handles.ecogDS.badChannels)
            text(c,r,num2str((r-1)*16+c),'Background','y')        
        end
    end
end
colorbar
title('High')



subplot(1,2,1)
imagesc(reshape(N2(2,:),16,16)')

r=16; c=16;
set(gca,'XGrid','on')
set(gca,'YGrid','on')
set(gca,'XTick',[1.5:16.5])
set(gca,'YTick',[1.5:(r+.5)])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
for c=1:16
    for r=1:r
        text(c,r,num2str((r-1)*16+c))
        if ismember((r-1)*16+c,handles.ecogDS.badChannels)
            text(c,r,num2str((r-1)*16+c),'Background','y')        
        end
    end
end


colorbar
title('Low')




%%
figure
patient='EC8'
visualizeGrid(1,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patient '\brain_3Drecon.jpg'],1:256,ecogH.hfoCounts)
%%
ecogTSGUI(ecogH)
%%

%%
%%
S=ecogH.samps;
u=length(ecogH.samps);
%%
clear e z zs bp e o
count=1;
buffer=500;

for i=1:u
    for j=1:size(S(i).samps,1)
        z(count,:)=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);   
        zs(count,:)=smooth(ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer),20);  
        bp(count,:)=ecogH.bandpassed(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        e(count,:)=ecogH.env(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        o(count,:)=handles.ecogDS.data(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        count=count+1;
     end
end
%%
w=2
keep(w).o=o;
keep(w).bp=bp;
keep(w).z=z;
keep(w).e=e;

%%
figure
 set(gcf,'Name','Mean')

subplot(2,2,1)
 plot(mean(o,1))
 title('mean original')
 
 subplot(2,2,2)
 plot(mean(z,1)) 
  title('mean zscore')

 subplot(2,2,3)
 plot(mean(bp,1)) 
  title('mean bandpassed')

 subplot(2,2,4)
 plot(mean(e,1)) 
 title('mean envelop')
 %%
 figure
 set(gcf,'Name','Stacked')
 
subplot(2,2,1)
 imagesc(o)
 title('original')
 colorbar
 
 subplot(2,2,2)
 imagesc(z)
  title('zscore')
 colorbar

 subplot(2,2,3)
 imagesc(bp)
  title('bandpassed')
 colorbar

 subplot(2,2,4)
 imagesc(e)
 title('envelop')
 colorbar

%%
%Look at individual HFOs as bandpassed envelop, bandpassed signal
%(smoothed?), unfiltered downsampled signal, and spectrogram
%*****TO DO: option to accept or reject each HFO****
%%
S=ecogH.samps;
u=length(ecogH.samps);
loadload;close;
figure
buffer=500;
f=1200;
k=1;
for i=1:u
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
clear Skeep
S=ecogH.samps;
u=length(ecogH.samps);
loadload;close;
figure
buffer=500;
f=1200;
k=1;
for i=1:u
    jk=1;
    for j=1:size(S(i).samps,1)
        d=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        if length(find(d>5))>20 & std(d)>1.5
            Skeep(i).examples=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
            Skeep(i).samps(jk,:)=S(i).samps(j,:);
            Skeep(i).ch=S(i).ch;            
            jk=jk+1;
        end
    end
end
%%
for i=1:length(Skeep)
    c=Skeep(i).ch;
    tmp(c)=size(Skeep(i).samps,1);
end
visualizeGrid(1,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patient '\brain_3Drecon.jpg'],1:256,tmp)

%%





%%
figure
buffer=500
set(gcf,'Color',[1 1 1])

for i=1:size(S,2)
   set(gcf,'Name',['Ch ' int2str(i)])
    for j=1:size(S(i).samps,1)
        subplot(5,8,j*2-1)
        d=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        h=plot(d)
        hold on
        plot(500,5,'*r')
        plot([500 501],[min(d),max(d)],'r')
        axis tight
        %set(gca,'visible','off')
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])

        hold off
        
        subplot(5,8,j*2)
        d=handles.ecogDS.data(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        plot(500,max(d),'*r')
        hold on

        plot([500 501],[min(d)-abs(min(d)*.4),max(d)+abs(max(d)*.4)],'r')
        h=plot(d)
        axis tight
        %set(gca,'visible','off')
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])

        set(gca,'Color','y')
        
        hold off
        
        
    end        

    r=input('Next\n','s')
    clf
end


%%

figure
buffer=500
set(gcf,'Color',[1 1 1])
collect=[];
for i=1:size(S,2)
   set(gcf,'Name',['Ch ' int2str(i)])
    for j=1:size(S(i).samps,1)
        subplot(5,8,j*2-1)
        d=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        
        h=plot(d)
        hold on
        plot(500,5,'*r')
        plot([500 501],[min(d),max(d)],'r')
        axis tight
        %set(gca,'visible','off')
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])

        hold off
        
        subplot(5,8,j*2)
        %{
        %Plot downsampled data
        d=handles.ecogDS.data(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        plot(500,max(d),'*r')
        hold on

        plot([500 501],[min(d)-abs(min(d)*.4),max(d)+abs(max(d)*.4)],'r')
        h=plot(d)
        axis tight
        %set(gca,'visible','off')
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])

        set(gca,'Color','y')
        
        hold off
        %}
        
        %Plot image of filtered bands
        d=handles.ecogFiltered.data(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer,:);
        
        collect=[collect;d];
        imagesc(zscore(squeeze(d)',[],2))        
        %set(gca,'visible','off')
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])

        set(gca,'Color','y')
        
        hold off
        
    end        

    r=input('Next\n','s')
    clf
end

%%
SS=[];
for i=1:size(S,2)
    new=[];
    new=S(i).samps(:,3);
    new(:,2)=repmat(S(i).ch,[size(new,1),1]);
    SS=vertcat(SS,new);
end

SS(:,1)=SS(:,1)/1200;

%%
filename='E:\PreprocessedFiles\EC8\EC8_B38'
buffer=[1000 1000]
time=(SS(:,1)*1000);
for i=1:10%size(SS,1)
    cd([ filename '\HilbReal_4to500_45band_1200Hz'])
    timeInt=[time(i)-buffer(1),time(i)+buffer(2)];
    chanNum=SS(i,2);
    r=loadHTKtoEcog_CT(pwd,256,timeInt)';

    cd([ filename '\HilbImag_4to500_45band_1200Hz'])
    im=loadHTKtoEcog_CT(pwd,256,timeInt)';
    tmp=complex(r.data(:,:,:),im.data(:,:,:));
    %tmp=squeeze(tmp)';
    HFO(i).env=abs(tmp);
    HFO(i).phase=angle(tmp);
    HFO(i).timeInt=timeInt;
    HFO(i).ch=chanNum;
end
%%
for i=1:10
        timeInt=[time(i)-buffer(1),time(i)+buffer(2)];
        chanNum=SS(i,2);
        
        ecog=loadHTKtoEcog_CT([filename filesep 'RawHTK'],256,timeInt)
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
        sprintf('Length of Recording: %i\n',size(ecog.data,2)/ecog.sampFreq);
        tmp=downsampleEcog(ecog,1200);
        HFO(i).ds=tmp.data;
                
end
    
%%

figure
imagesc(zscore(squeeze(H(1).env(H(1).ch,:,:))',[],2))
    
plot(squeeze(H(1).data(H(1).ch+1,:)))
hold on
plot(squeeze(H(1).env(H(1).ch+1,:,41))*600,'r')


low_frequency_phase=H(1).phase(1,:,low_freq_band);



 pac=abs(sum(exp(1i * (low_frequency_phase - high_frequency_phase)), 'double'))/ length(high_frequency_phase);
 
 %%
 %Calculate PAC
 low_freq_band=[1:30];
 high_freq_band=[30:45];
 pac = zeros([256 size(low_freq_band, 2) size(high_freq_band, 2)]);
 pac2 = zeros([256 size(low_freq_band, 2) size(high_freq_band, 2)]);

% Calculate PAC
for chanIt = 1:256
    
    for lowIt = low_freq_band
        %disp(['Channel ' num2str(chanIt) ' Low Frequency ' num2str(lowIt)]);
        
        % Extract low frequency analytic phase
        low_frequency_phase{chanIt}(lowIt,:)=HFO(1).phase(chanIt,:,lowIt);
        
        for highIt = lowIt:high_freq_band(end)
            % Extract low frequency analytic phase of high frequency analytic amplitude
            high_frequency_amplitude{chanIt}(highIt,:)=HFO(1).phase(chanIt,:,highIt);
            tmp=fft(high_frequency_amplitude{chanIt}(highIt,:));
            T=size(tmp,2);
            [H,h]=makeHilbWindow(T,lowIt);
            high_frequency_phase{chanIt}(lowIt,:)=angle(ifft(tmp.*(H.*h),T));
            
            % Calculate PAC
            pac2(chanIt, lowIt, highIt) =...
                abs(sum(exp(1i * (low_frequency_phase{chanIt}(lowIt,:) - high_frequency_phase{chanIt}(lowIt,:))), 'double'))...
                / length(high_frequency_phase{chanIt}(lowIt,:));
        end
    end
end
%%
%%
 %Calculate PAC
 low_freq_band=[2,8,15];
 high_freq_band=[1:45];
 pac = zeros([256 size(low_freq_band, 2) size(high_freq_band, 2)]);
 pac2 = zeros([256 size(low_freq_band, 2) size(high_freq_band, 2)]);

% Calculate PAC
for chanIt = 1:256
    
    for lowIt =1:length(low_freq_band)%low_freq_band
        %disp(['Channel ' num2str(chanIt) ' Low Frequency ' num2str(lowIt)]);
        
        % Extract low frequency analytic phase
        low_frequency_phase{chanIt}(lowIt,:)=angle(complex_data(chanIt,:,low_freq_band(lowIt)));
        
        for highIt = 1%lowIt:high_freq_band(end)
            % Extract low frequency analytic phase of high frequency analytic amplitude
            high_frequency_amplitude{chanIt}(highIt,:)=abs(complex_data(chanIt,:,high_freq_band(highIt)));
            tmp=fft(high_frequency_amplitude{chanIt}(highIt,:));
            T=size(tmp,2);
            [H,h]=makeHilbWindow(T,low_freq_bad(lowIt));
            high_frequency_phase{chanIt}(lowIt,:)=angle(ifft(tmp.*(H.*h),T));
            
            % Calculate PAC
            pac3(chanIt, lowIt, highIt) =...
                abs(sum(exp(1i * (low_frequency_phase{chanIt}(lowIt,:) - high_frequency_phase{chanIt}(lowIt,:))), 'double'))...
                / length(high_frequency_phase{chanIt}(lowIt,:));
        end
    end
end
%%


figure
for chanIt=1:256
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
    %plot(squeeze(sum(pac2(c,:,30:45),3)))
    imagesc(squeeze(pac2(chanIt,:,:)));
end
    
%%
figure;hold on;
for c=40:45
    plot(squeeze(pac2(1,:,c)));
end


plot(squeeze(sum(pac2(1,:,30:45),3)))

%%
%phase coupling
cd('C:\Users\Angela_2\Dropbox\ChangLab\Users\Angela\koepsell-phase-coupling-estimation-271441c\matlab')
mex -largeArrayDims fill_matrix.c


%%

for f=40:45
    data=phase(:,:,i);
    L=size(data_all,2);    

    K_fit = fit_model(single(abs(data)));
end

