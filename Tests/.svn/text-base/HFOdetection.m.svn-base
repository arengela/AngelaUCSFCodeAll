%load HTK files
filename='E:\PreprocessedFiles\EC8\EC8_B37\RawHTK';
handles.ecog=loadHTKtoEcog_CT(filename,256,[])
baselineDurMs=0;
sampDur=1000/handles.ecog.sampFreq;
handles.ecog=ecogRaw2EcogGUI(handles.ecog.data,baselineDurMs,sampDur,[],handles.ecog.sampFreq);
sprintf('Length of Recording: %i\n',size(handles.ecog.data,2)/handles.ecog.sampFreq);
%%
%DOWNSAMPLE TO 1200 Hz
handles.ecogDS=downsampleEcog(handles.ecog,1200);
handles.ecogDS.selectedChannels=1:size(handles.ecogDS.data,1);


handles.ecogDS.sampDur=1000/1200
handles.ecogDS.sampFreq=1200
handles.ecogDS.timebase=[0:(size(handles.ecogDS.data,2)-1)]*handles.ecogDS.sampDur;
handles.badChannels=[];
handles.badTimeSegments=[];
handles.ecogDS.badChannels=[];
handles.ecogDS.badTimeSegments=[];
%handles.ecogDS.data=detrend(handles.ecogDS.data);
%guidata(hObject, handles);
%%
%HF bandpass 180-400 Hz

[b,a]=fir2(9000,[0 70 80 140 150 600]/600,[0 0 1 1 0 0]);
[b,a]=fir2(9000,[0 200 210 490 500 600]/600,[0 0 1 1 0 0]);
figure
freqz(b,a,[],1200)
ecog.data=filtfilt(b,a,handles.ecogDS.data')';


handles.ecogNormalized=handles.ecogDS;
handles.ecogNormalized.data=ecog.data;
ecogN=handles.ecogNormalized;
ecogO=handles.ecogDS;
%assignin('base','ecogN',handles.ecogNormalized);
%assignin('base','ecogO',handles.ecogDS);

%guidata(hObject, handles);
%%
%AUTOMATIC DETECTION OF HFO's

%Take envelope of bandpassed signal
ecog2.data=abs(hilbert(ecogN.data')');

%Smooth signal to reduce noise and extraneous peaks
s=[]
for i=1:256
   s(i,:)=smooth(ecog2.data(i,:),50)';
end

%Calculate zscore for each channel over entire recording
z=zscore(s,[],2);

%Find indices where zscore is above 5
[y,x]=find(z>5);

%Discard beginning and end of signal
tmp=find(x<2000);
x(tmp)=[];
y(tmp)=[];

l=size(z,2)
tmp2=find(x>(l-5000));
x(tmp2)=[];
y(tmp2)=[];

%plot indices above 5
figure
plot(x,y,'.')

%%
%count number of indices above 5 (N) are in each channel
[N,b]=histc(y,1:256);
figure;
bar(N);
%discard channels where N is less than 20 (assume those were anomolies)
N(find(N<20))=0;

%Visualize on brain image where electrodes with most N are located
figure
patient='EC8'
visualizeGrid(1,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patient '\brain_3Drecon.jpg'],1:256,N)

%Get the beginning and end index of each segment of N
%Assume large discontinuities mean separation of segments
u=find(N>1);
clear S
S.samps=[]
for i=1:length(u)
    tmp=x(find(y==u(i)));
    discon=find(diff(tmp)>20);
    start=1;
    for j=1:length(discon)+1
        S(i).samps(j,1)=tmp(start);
        try
            S(i).samps(j,2)=tmp(discon(j)-1);
            start=discon(j)+1;
        catch 
            S(i).samps(j,2)=tmp(end);
            S(i).ch=u(i);
        end
    end
end
%%
%Plot segments (just to double check)
%{
figure
hold on
for i=1:length(u)
    for j=1:size(S(i).samps,1)
        plot([S(i).samps(j,1) S(i).samps(j,2)],[u(i),u(i)],'*')
    end
end
%}
%%
%Make badTimeIntervals variable that specifies beginning, end, and channel
%of each HFO segment
%Padding widens the segment
padding=500;
r=1;badTimeIntervals=[];
for i=1:length(u)
    for j=1:size(S(i).samps,1)
        %d=z(S(i).ch,S(i).samps(j,1):S(i).samps(j,2));
        %[y,x]=extrema(d);
        %x2=x(max(y));
        %badTimeIntervals(r,1:2)=[(
        badTimeIntervals(r,1:2)=[(S(i).samps(j,1)-padding)/1200 (S(i).samps(j,2)+padding)/1200];
        badTimeIntervals(r,3)=u(i);
        r=r+1;
    end
end

%%

%Plot segments
figure
subplot(2,1,1)
hold on
for i=1:size(badTimeIntervals,1)
    plot([badTimeIntervals(i,1),badTimeIntervals(i,2)],[badTimeIntervals(i,3),badTimeIntervals(i,3)],'*')
end

title(['Total HFO segments found: ' int2str(size(badTimeIntervals,1))])

subplot(2,1,2)
hist(badTimeIntervals(:,3),256)
title('HFO count per channel')

%%
ecogN.hfo=1;%This flag tells function ecogTSGUI to mark segments only for specified channel
ecogN.badIntervals=badTimeIntervals

%Scroll through data with HFO segments marked
ecogTSGUI(ecogN)

%%
%Look at individual HFOs as bandpassed envelop, bandpassed signal
%(smoothed?), unfiltered downsampled signal, and spectrogram
%*****TO DO: option to accept or reject each HFO****
figure
buffer=200;
for i=1:length(u)
    for j=1:size(S(i).samps,1)
        subplot(2,2,1)
        L=S(i).samps(j,2)-S(i).samps(j,1)+2*buffer;
        d=z(S(i).ch,S(i).samps(j,1)-buffer:S(i).samps(j,2)+buffer);
        plot(d)        
        hold on
        hl=line([0 L],[5 5]);
        set(hl,'Color','r')
        L=S(i).samps(j,2)-S(i).samps(j,1);
        mx=max(d);
        mn=min(d);
        h=patch([buffer,buffer+L,buffer+L,buffer], [mn mn mx mx],'y');
        set(h,'FaceAlpha',.5)
        set(h,'EdgeColor','none')
        title('Envelope Zscore')
        hold off
        
        
        subplot(2,2,2)
        title('Bandpassed, Envelop, smoothed Envelop (200-400 Hz)')
       
        d=ecogN.data(S(i).ch,S(i).samps(j,1)-buffer:S(i).samps(j,2)+buffer);
        plot(d)
        hold on
        s=abs(hilbert(d));
        plot(s,'r')
        plot(smooth(s,50),'g')
        mx=max(d);
        mn=min(d);
        h=patch([buffer,buffer+L,buffer+L,buffer],[mn mn mx mx],'y');
        set(h,'FaceAlpha',.5)
        set(h,'EdgeColor','none')
        title('Bandpassed')

        hold off
        
        subplot(2,2,3)
        d=ecogO.data(S(i).ch,S(i).samps(j,1)-buffer:S(i).samps(j,2)+buffer);
        plot(d)
        hold on
        mx=max(d);
        mn=min(d);
        h=patch([buffer,buffer+L,buffer+L,buffer],[mn mn mx mx],'y');
        set(h,'FaceAlpha',.5)
        set(h,'EdgeColor','none')
        title('Original Signal (1200 Hz)')
        hold off
        
        subplot(2,2,4)
        specgram(d,70,1200)
        title('spectrogram')
  
        set(gcf,'Name',sprintf('Channel: %i, Time: %0.2f sec',S(i).ch,S(i).samps(j,1)/1200));
        r=input('Next','s');
        switch r
            case 'b'
                j=j-2;
            case 'n'
            otherwise
                examples{i}=z(S(i).ch,S(i).samps(j,1)-buffer:S(i).samps(j,2)+buffer);
                Skeep(i).samps(j,:)=S(i).samps(j,:);
                Skeep(i).ch=S(i).ch;
        end
        end
    end
    end

    %%
figure
for i=1:256
    v5 = wav2aud(ecogO.data(i,:),[10 200 -2 log2(f/16000)]);
    aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(f/16000)]);
    title(int2str(i))
    r=input('Next');
end
%%
figure
%ch=zeros(1,256);
for i=1:29
    %x=S(i).ch;
    %ch(x)=ch(x)+1;
    %env{i}=abs(hilbert(examples{i}));
    
    
    plot(examplesZ{i})
    hold on

end
