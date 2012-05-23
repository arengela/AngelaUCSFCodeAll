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

ecogO=handles.ecogDS;
clearvars -except ecogO

%handles.ecogDS.data=detrend(handles.ecogDS.data);
%guidata(hObject, handles);
%%
%ripples (80-150 Hz)
[b,a]=fir2(9000,[0 70 80 140 150 600]/600,[0 0 1 1 0 0]);
figure
freqz(b,a,[],1200)
ecog_L.data=filtfilt(b,a,handles.ecogDS.data')';

%HFO(200-500 Hz)
[b,a]=fir2(9000,[0 200 210 490 500 600]/600,[0 0 1 1 0 0]);
figure
freqz(b,a,[],1200)
ecogH.data=filtfilt(b,a,handles.ecogDS.data')';
%%
ecogH.selectedChannels=1:size(handles.ecogDS.data,1);
ecogH.sampDur=1000/1200;
ecogH.sampFreq=1200;
ecogH.timebase=[0:(size(handles.ecogDS.data,2)-1)]*handles.ecogDS.sampDur;
ecogH.badChannels=[];
ecogH.badTimeSegments=[];
ecogH.badIntervals=[];

ecogL.selectedChannels=1:size(handles.ecogDS.data,1);
ecogL.sampDur=1000/1200;
ecogL.sampFreq=1200;
ecogL.timebase=[0:(size(handles.ecogDS.data,2)-1)]*handles.ecogDS.sampDur;
ecogL.badChannels=[];
ecogL.badTimeSegments=[];
ecogL.badIntervals=[];
clear a b
%%
%AUTOMATIC DETECTION OF HFO's
L=size(ecogO.data,2);

%Take envelope of bandpassed signal
ecogH.env=abs(hilbert(ecogH.data')');
ecogH.bp=ecogH.data;

ecogL.env=abs(hilbert(ecogL.data')');
ecogL.bp=ecogL.data;

%%
%Smooth signal to reduce noise and extraneous peaks
s=[]
for i=1:256
   s(i,:)=smooth(ecogH.data(i,:),50)';
end
med=median(s,2);
sdev=std(s,[],2);
ecogH.zscore=(s-repmat(med,[1,L]))./repmat(sdev,[1,L]);

s=[]
for i=1:256
   s(i,:)=smooth(ecogL.data(i,:),50)';
end

%Calculate zscore for each channel over entire recording
%z=zscore(ecogH.env,[],2);
%OR calculate zscore w/ median
med=median(s,2);
sdev=std(s,[],2);
ecogL.zscore=(s-repmat(med,[1,L]))./repmat(sdev,[1,L]);
%{
med=median(ecogH.env,2);
sdev=std(ecogH.env,[],2);
ecogH.zscore=(ecogH.env-repmat(med,[1,L]))./repmat(sdev,[1,L]);
%}
%%
L=size(ecogH.zscore,2)
%Find indices where zscore is above 5
[yH,xH]=find(ecogH.zscore>5);
[yL,xL]=find(ecogL.zscore>5);

%Discard beginning and end of signal
tmp=find(xH<500);
xH(tmp)=[];
yH(tmp)=[];

tmp=find(xH>(L-500));
xH(tmp)=[];
yH(tmp)=[];

%Low
tmp=find(xL<500);
xL(tmp)=[];
yL(tmp)=[];

tmp=find(xL>(L-500));
xL(tmp)=[];
yL(tmp)=[];

%plot indices above 5
figure
plot(xL,yL,'.')
hold on
plot(xH,yH,'.r')
%%
ecogH.x=xH;
ecogH.y=yH;
ecogL.x=xL;
ecogL.y=yL;

ecog(1)=ecogH;
ecog(2)=ecogL;
clearvars -except ecogH ecogL ecogO
%%

[N,b]=histc(y,1:256);
figure;
bar(N);
%discard channels where N is less than 20 (assume those were anomolies)
%N(find(N<20))=0;

%Visualize on brain image where electrodes with most N are located
figure
patient='EC8'
visualizeGrid(1,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patient '\brain_3Drecon.jpg'],1:256,N)

%%

ecogTSGUI(ecogH)

%%
%%
%Look at individual HFOs as bandpassed envelop, bandpassed signal
%(smoothed?), unfiltered downsampled signal, and spectrogram
%*****TO DO: option to accept or reject each HFO****
loadload;close;
figure
buffer=500;
f=1200;
for i=1:length(u)
    for j=1:size(S(i).samps,1)
        subplot(2,2,1)
        L=S(i).samps(j,2)-S(i).samps(j,1)+2*buffer;
        d=ecogH.zscore(S(i).ch,S(i).samps(j,1)-buffer:S(i).samps(j,2)+buffer);
        plot(d)        
        hold on
        hl=line([0 L],[5 5]);
        set(hl,'Color','r')
        L=S(i).samps(j,2)-S(i).samps(j,1);
        axis tight;
        mx=max(d);
        mn=min(d);
        h=patch([buffer,buffer+L,buffer+L,buffer], [mn mn mx mx],'y');
        set(h,'FaceAlpha',.5)
        set(h,'EdgeColor','none')
        title('Envelope Zscore')
        hold off
        
        
        subplot(2,2,2)
        title('Bandpassed, Envelop, smoothed Envelop (200-400 Hz)')
       
        d=ecogH.bp(S(i).ch,S(i).samps(j,1)-buffer:S(i).samps(j,2)+buffer);
        plot(d)
        hold on
        s=ecogH.env(S(i).ch,S(i).samps(j,1)-buffer:S(i).samps(j,2)+buffer);
        plot(s,'r')
        plot(smooth(s,50),'g')
        axis tight
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
        axis tight
        mx=max(d);
        mn=min(d);
        h=patch([buffer,buffer+L,buffer+L,buffer],[mn mn mx mx],'y');
        set(h,'FaceAlpha',.5)
        set(h,'EdgeColor','none')
        title('Original Signal (1200 Hz)')
        hold off
        
         subplot(2,2,4)
        v5 = wav2aud(d,[10 200 -2 log2(f/16000)]);
        %aud_plot(mapstd(v5'.^.5)',[10 10 -2 log2(f/16000)]);
        aud_plot((v5'.^.5)',[10 10 -2 log2(f/16000)]);
        title('spectrogram')
        

  
        set(gcf,'Name',sprintf('Channel: %i, Time: %0.2f sec',S(i).ch,S(i).samps(j,1)/1200));
        r=input('Next','s');
        switch r
            case 'b'
                j=j-2;
            case 'n'
            otherwise
                %{
                examples{i}=ecogH.zscore(S(i).ch,S(i).samps(j,1)-buffer:S(i).samps(j,2)+buffer);
                Skeep(i).samps(j,:)=S(i).samps(j,:);
                Skeep(i).ch=S(i).ch;
                %}
        end
        end
end
%%
count=1;
for i=1:length(u)
    for j=1:size(S(i).samps,1)
        z(count,:)=ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);   
        zs(count,:)=smooth(ecogH.zscore(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer),20);  
        bp(count,:)=ecogH.bp(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        e(count,:)=ecogH.env(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        o(count,:)=ecogO.data(S(i).ch,S(i).samps(j,3)-buffer:S(i).samps(j,3)+buffer);
        count=count+1;
     end
end

