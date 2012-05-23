function ecogH=HFODetectionFunction_AAinput(ecogH)


ecogH.selectedChannels=1:size(ecogH.data,1);
ecogH.sampDur=1000/1200;
ecogH.sampFreq=1200;
ecogH.timebase=[0:(size(ecogH.data,2)-1)]*ecogH.sampDur;
ecogH.badChannels=[];
ecogH.badTimeSegments=[];
ecogH.badIntervals=[];

ecogH.env=ecogH.data;
ecogH.bandpassed=ecogH.data;

%ecogH.env=abs(hilbert(ecogH.data')');
%ecogH.bandpassed=ecogH.data;
tmp=[];
s=ecogH.env;
if ~isempty(ecogH.badIntervals)
    for i=1:size(ecogH.badIntervals,1)
        tmp=[tmp round(ecogH.badIntervals(i,1)*ecogH.sampFreq:ecogH.badIntervals(i,2)*ecogH.sampFreq)];
    end
    s(:,seg)=[];
    ecogH.data(:,seg)=0;
end



%%
L=size(ecogH.data,2);
%{
for i=1:256
   s(i,:)=smooth(s(i,:),20)';
end
%}
med=median(s,2);
sdev=std(s,[],2);
ecogH.zscore=(s-repmat(med,[1,L]))./repmat(sdev,[1,L]);
%tmp=find(nansum(ecogH.zscore,1)>400);
s=ecogH.zscore;
%s(:,tmp)=0;
%Find indices where zscore is above 5



[y,x]=find(s>5);

%Discard beginning and end of signal
%plot(x,y,'.')
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
for i=1:length(u)
    tmp=x(find(y==u(i)));
    discon=find(diff(tmp)>40);
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
%%
padding=500;
r=1;badIntervals=[];
icount=1; 

for i=1:length(u)
    next=0;
    jcount=1;
    for j=1:size(S(i).samps,1)
        [~,idx]=max(ecogH.zscore(S(i).ch,S(i).samps(j,1):S(i).samps(j,2)));
        d=ecogH.zscore(S(i).ch,ceil(S(i).samps(j,1)+idx-padding):floor(S(i).samps(j,1)+idx+padding));
        if kurtosis(d)>10
            S(i).samps(j,3)=S(i).samps(j,1)+idx;
            Skeep(icount).samps(jcount,1)=S(icount).samps(jcount,3);
            Skeep(icount).ch=S(i).ch;
            %[y,x]=extrema(d);
            %x2=x(max(y));
            %badTimeIntervals(r,1:2)=[(
            badIntervals(r,1:2)=[(S(i).samps(j,1)+idx-padding)/1200 (S(i).samps(j,1)+idx+padding)/1200];
            badIntervals(r,3)=u(i);
            r=r+1;
            jcount=jcount+1;
        end
        next=1;
    end
    if next==1
        icount=icount+1;
    end
end

rmfield(ecogH,'samps');
try 
    ecogH=setfield(ecogH,'samps',Skeep.samps);
catch
    ecogH.samps=[];
end

N2=zeros(256,1);  
try
    for i=1:length(Skeep)
        N2(Skeep(i).ch)=size(Skeep(i).samps,1);
    end
end
    ecogH.hfoCounts=N2;

%{
padding=500;
r=1;badIntervals=[];
icount=1; 
for i=1:length(u)
    next=0;
    jcount=1;
    badj=[];
    for j=1:size(S(i).samps,1)
        
        [~,idx]=max(ecogH.zscore(S(i).ch,S(i).samps(j,1):S(i).samps(j,2)));
        d=ecogH.zscore(S(i).ch,ceil(S(i).samps(j,1)+idx-padding):floor(S(i).samps(j,1)+idx+padding));
        if kurtosis(d)>5
            S(i).samps(j,3)=S(i).samps(j,1)+idx;
            %Skeep(icount).samps(jcount)=S(icount).samps(jcount);
            %Skeep(icount).ch=S(i).ch;
            %[y,x]=extrema(d);
            %x2=x(max(y));
            %badTimeIntervals(r,1:2)=[(
            badIntervals(r,1:2)=[(S(i).samps(j,1)+idx-padding)/1200 (S(i).samps(j,1)+idx+padding)/1200];
            badIntervals(r,3)=u(i);
            r=r+1;
            %jcount=jcount+1;
        else
            
        %next=1;
        badj=[badj j];
        end
    end
    S(i).samps(badj,:)=[]; 
    

end
%%
goodS=[];
for i=1:size(S,2)
    if ~isempty(S(i).samps)
        goodS=[goodS i]
    end
end
        
ecogH.samps=S(goodS);

N2=zeros(256,1);  
try
    for i=1:length(Skeep)
        N2(Skeep(i).ch)=size(Skeep(i).samps,1);
    end
end

    ecogH.hfoCounts=N2;
%}
%%
ecogH.badIntervals=badIntervals;
ecogH.hfo=1;%This flag tells function ecogTSGUI to mark segments only for specified channel
