eidx=5;
electrodes=E{2}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)
ch1=find(pkTime~=100000 & pkTime>700 & pkTime<2000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels) & [electrodes.startTime]<1500 & ...
    sum(vertcat(electrodes.TTest),2)'>30)
electrodes=E{5}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)
ch2=find(pkTime~=100000 & pkTime>700 & pkTime<2000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels) & [electrodes.startTime]<1500 & ...
    sum(vertcat(electrodes.TTest),2)'>30)
ch=[ch1 ch2];
[~,s]=sort(pkTime(ch));
electrodes=E{eidx}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)