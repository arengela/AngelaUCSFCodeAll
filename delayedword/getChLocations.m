load([brainFile filesep AllP{p}.Tall{2}.Data.patientID filesep 'regdata'])
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\jet_diverge')
markershape={'p','o','^','d','s','^'}
colorjet=jet_diverge
%subplot(1,7,1)
xySF=BrainCoord(p).xySF
xyCS=BrainCoord(p).xyCS
gridDist=BrainCoord(p).gridDist
clear devCS devSF
for c=1:length(ch)
    xyCur=xy(:,ch(c));
    [devCS(c),devSF(c)]=getSulcusDev(xyCur,xySF,xyCS);
end

try
    figure(1)
    %subplot(1,5,i)
    %idx=floor(sidx/11*length(colorjet));
    if 1%~ismember(i,[1 3 4])
        scatter(devCS./gridDist,devSF./gridDist,100,colorjet(idx,:),'fill',markershape{p})
    else
        scatter(devCS./gridDist,devSF./gridDist,100,colorjet(idx,:),markershape{p})
    end
    hold on
end
hold on
line([-1000 1000],[0 0])
line([0 0],[-1000 1000])
xlabel('distance from CS')
ylabel('distance from SF')
axis([-2 2 -2 2])
colormap(jet_diverge)