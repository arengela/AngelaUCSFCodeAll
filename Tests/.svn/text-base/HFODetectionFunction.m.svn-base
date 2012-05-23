function ecogH=HFODetectionFunction(ecogH,datatype)
%datatype= 1: complex, 2: envelope

if datatype==1
    ecogH.selectedChannels=1:size(ecogH.data,1);
    ecogH.sampDur=1000/1200;
    ecogH.sampFreq=1200;
    ecogH.timebase=[0:(size(ecogH.data,2)-1)]*ecogH.sampDur;
    ecogH.badChannels=[];
    ecogH.badTimeSegments=[];
    ecogH.badIntervals=[];


    ecogH.env=abs(hilbert(ecogH.data')');
    ecogH.bandpassed=ecogH.data;
    tmp=[];
    s=ecogH.env;
    if ~isempty(ecogH.badIntervals)
        for i=1:size(ecogH.badIntervals,1)
            tmp=[tmp round(ecogH.badIntervals(i,1)*ecogH.sampFreq:ecogH.badIntervals(i,2)*ecogH.sampFreq)];
        end
        s(:,seg)=[];
        ecogH.data(:,seg)=0;
    end
else
    ecogH.selectedChannels=1:size(ecogH.data,1);
    ecogH.sampDur=1000/1200;
    ecogH.sampFreq=1200;
    ecogH.timebase=[0:(size(ecogH.data,2)-1)]*ecogH.sampDur;
    ecogH.badChannels=[];
    ecogH.badTimeSegments=[];
    ecogH.badIntervals=[];

    ecogH.env=ecogH.data;
    ecogH.bandpassed=ecogH.data;

    tmp=[];
    s=ecogH.env;
    if ~isempty(ecogH.badIntervals)
        for i=1:size(ecogH.badIntervals,1)
            tmp=[tmp round(ecogH.badIntervals(i,1)*ecogH.sampFreq:ecogH.badIntervals(i,2)*ecogH.sampFreq)];
        end
        s(:,seg)=[];
        ecogH.data(:,seg)=0;
    end
end




%%
L=size(ecogH.data,2);
%{
if datatype==1
    for i=1:256
       s(i,:)=smooth(s(i,:),20)';
    end
end
%}
%med=median(s(:,348000:end),2);
med=median(s,2);

sdev=std(s,[],2);
ecogH.zscore=(s-repmat(med,[1,L]))./repmat(sdev,[1,L]);
%ecogH.zscore=zscore(s,[],2);
%tmp=find(nansum(ecogH.zscore,1)>400);
s=ecogH.zscore;
s(:,tmp)=0;
%Find indices where zscore is above 5



[y,x]=find(s>5);

%Discard beginning and end of signal
tmp=find(x<1000);
x(tmp)=[];
y(tmp)=[];

tmp=find(x>(L-500));
x(tmp)=[];
y(tmp)=[];
ecogH.x=x;
ecogH.y=y;
%%
%[N1,b]=histc(x,1:size(s,2));

[N,b]=histc(y,1:256);
u=find(N>1);
clear S
S.samps=[];
%{
for i=1:length(u)
    tmp=x(find(y==u(i)));
    diffsamps=diff(tmp);    
    diff_keep=tmp(find(diffsamps<2 | diffsamps>1200));

    
    discon=find(diff(diff_keep)>2400);
    
    start=1;
    
    for j=1:length(discon)+1
        S(i).samps(j,1)=tmp(start);
        try
            S(i).samps(j,2)=tmp(discon(j)-1);
            start=discon(j);
        catch 
            S(i).samps(j,2)=tmp(end);
            S(i).ch=u(i);
        end
    end
end
%}
%%
%{
padding=500;

badIntervals=[];
 %figure
for i=1:length(u)
    for j=1:size(S(i).samps,1)
        [~,idx]=max(ecogH.zscore(S(i).ch,S(i).samps(j,1):S(i).samps(j,2)));
        try
         
  
                if 1%kurtosis(d)>1
                %keyboard
                printf(int2str([i j]))
                %Skeep(icount).samps(jcount,1)=S(i).samps(j,1)+idx;
                %Skeep(icount).ch(jcount,1)=S(i).ch;
                %[y,x]=extrema(d);
                %x2=x(max(y));
                %badTimeIntervals(r,1:2)=[(
                tmp=[(S(i).samps(j,1)+idx-padding)/1200 (S(i).samps(j,1)+idx+padding)/1200 S(i).ch (S(i).samps(j,1)+idx)/1200 ];
                badIntervals=[badIntervals;tmp];
                %r=r+1;
                %jcount=jcount+1;
                
            end
        end
        
    end
end
%}

minThresh=5; %An event is triggered when this value is exceeded. One entry for each analogue channel
minDurOfStimulusInSeconds=50/1000; % That is the duration of the event.This is a "dead time" after an event was detected. Other events happening during this interval are ignored.

dur=0.5; % displpay interval duration

for k=1:256
    %load stimulus logfile
    
    %cd(sprintf('%s/%s',handles.pathName,handles.folderName))
    
    
    %load analogue channel
    %[analog_data,analog_params.sampFreq]=readhtk(sprintf('%s.htk',analogueChannels2Use{k}));
    %intervalStartEndSample=nearly(intervalStartEndSeconds,(1:length(analog_data))/analog_params.sampFreq);
    %analog_data(1:intervalStartEndSample(1))=0;
    %analog_data(intervalStartEndSample(2):end)=0;
    %min trigger duration to samples
    minDurOfStimulusInSamples=round(minDurOfStimulusInSeconds*1200);
    % I) Stimulus order from trialslog

    %onsetSamp=round(onsetTime*analog_params.sampFreq);
    
    
    
    %II) Sound onsets from sound channel
    % differentiate the time series
    dData=[0 diff(s(k,:))];
    toneOnset=abs(dData>minThresh); %candidate onset
    toneOnset= [0 diff(toneOnset)>minThresh]; % correct offset introduced by diff
    for m=1:length(toneOnset) % find the first sample with a slope above threshold and then skip the samples within the rest of the tone
        if toneOnset(m)==1
            for n=1:minDurOfStimulusInSamples
                toneOnset(m+n)=0;
            end
            m=m+n;
        end
    end
    
    %toneOnset(1:intervalStartEndSample(1))=0;
    %toneOnset(intervalStartEndSample(2):end)=0;
    
    
    length(find(toneOnset))
    % III) Match stimulus order with sound onset to make trigger vector
    trigger_analogfreq=zeros(length(s(k,:)),2);
    tmp=find(toneOnset>0);
    
    trigger_analogfreq(tmp)=1; % This places the correct stimulus code at the correct temporal positionof the trigger vector. idx holds the index in the stimulus order for a specific stimulus type.
    
end
%%
%{
try 
   ecogH=setfield(ecogH,'samps',vertcat(Skeep.samps));
   ecogH.samps(:,2)=vertcat(Skeep.ch);
catch
    ecogH.samps=[];
end
%}


try
    ecogH.hfoCounts=histc(badIntervals(:,3),1:256);
catch
    ecogH.hfoCounts=zeros(256,1);
end

%%
ecogH.badIntervals=badIntervals;
ecogH.hfo=1;%This flag tells function ecogTSGUI to mark segments only for specified channel
