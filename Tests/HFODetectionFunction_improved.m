function ecogH=HFODetectionFunction_improved(ecogH,datatype)
%datatype= 1: complex, 2: envelope
%better heuristics 
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
[tmpx,tmpy]=find(zscore(s,[],2)>20);
s(tmpx,tmpy)=0;



med=median(s,2);

sdev=std(s,[],2);
ecogH.zscore=(s-repmat(med,[1,L]))./repmat(sdev,[1,L]);
s=ecogH.zscore;

if datatype==1
    for i=1:256
       s(i,:)=smooth(s(i,:),20)';
    end
end

%%
%{
for i=1:256
    surrogate=zeros(1,size(s,2));
    above_th_idx=find(s(i,:)>5);
    surrogate(above_th_idx)=1;
    slope=diff(surrogate);
    start_idx=find(slope>0);
    end_idx=find(slope<0);
    first_start_idx=find(start,1,'first');
    end_idx(1:first_start_idx)=0;
    
%}
tmp_start=0;
tmp_end=0;
intervals=[];
for c=1:256
    idx=find(s(c,:)>5);
    if ~isempty(idx)
        tmp_start=idx(1);
        i=idx(1)+1;
        while i<=size(s,2)
            if s(c,i)>5
                if tmp_start==0
                    tmp_start=i;
                else
                    tmp_end=i;
                end
                i=i+1;
            else
                if tmp_end-tmp_start>60
                    intervals=[intervals; tmp_start tmp_end c];
                end
                tmp_start=0;
                tmp_end=0;
                idx_next=find(idx>i+1000);
                try
                    i=idx(idx_next(1));
                catch
                    i=size(s,2)+1;
            end
        end
    end
    end
end
   
                
                







try
    ecogH.badIntervals(:,1:2)=intervals(:,1:2)/1200;
    ecogH.badIntervals(:,3)=intervals(:,3);
    ecogH.hfoCounts=histc(intervals(:,3),1:256);

catch
    ecogH.hfoCounts=zeros(256,1);
end

%%

ecogH.hfo=1;%This flag tells function ecogTSGUI to mark segments only for specified channel
