%figure
extremeRange=linspace(500,2000,64);
load([brainFile filesep Tall{2}.Data.patientID filesep 'regdata'])
%visualizeGrid(5,['E:\General Patient Info\' Tall{2}.Data.patientID '\brain.jpg'],[],[],[],[],[],colorjet(idx,:),1);
pkTime=[E{eidx}.electrodes.startTime]
ch=find(pkTime~=100000 & ~ismember(1:256,Tall{2}.Data.Artifacts.badChannels))
ch=Tall{eidx}.Data.Params.activeCh
pkTime=[E{eidx}.electrodes(ch).peakTime]
step=2
s=(200/step)
chidx=1
line([-1000 1000],[0 0])
line([0 0],[-1000 1000])
xlabel('distance from CS')
ylabel('distance from SF')
hold on
colorjet=jet
while ~isempty(chidx) | s==1
    startTime=((s-1)*step+1)*10;
    stopTime=((s)*step)*10;
    chidx=find(pkTime<=stopTime )
    idx=findNearest(startTime,extremeRange);
    clear devCS devSF
    for c=1:length(chidx)
        xyCur=xy(:,ch(chidx(c)));
        [devCS(c),devSF(c)]=getSulcusDev(xyCur,xySF,xyCS);       
    end
    try
        scatter(devCS./gridDist,devSF./gridDist,100,colorjet(idx,:),'fill')
        axis([-2 2 -2 2])
    end
    hold on
    %input('n')
    s=s-1;
end
    