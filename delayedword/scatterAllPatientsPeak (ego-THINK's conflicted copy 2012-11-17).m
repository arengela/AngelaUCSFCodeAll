usesamps=200:5:300
try
    load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblack')
end
colorjet=redblack
step=100
s=3000
ch=1
for p=1%:length(patients)-1 
    all(p).peak=[AllP{p}.E{eidx}.electrodes.maxIdxTr];
    all(p).peakAmp=[AllP{p}.E{eidx}.electrodes.maxAmpTr];
end
tmp=[all.peak]
minRange=min(tmp(find(tmp~=100000)))
if eidx==2
    minRange=min(tmp(find(tmp~=100000)))
end
maxRange=prctile(tmp(find(tmp~=100000)),99)


%s=1

if eidx==2
    stop=2000;
    minRange=2000
    maxRange=2500

else
    minRange=1500
    maxRange=2500
    stop=1000;
    %colorjet=summer
end
extremeRange=round(linspace(minRange,maxRange,length(colorjet)));

while s>stop%<(200/step)
    startTime=s;    
    stopTime=(s+step);
    idx=findNearest(startTime,extremeRange);     
    for i=1:length(patients)-1 
        usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
        pkTime=cell2mat(cellfun(@nanmedian,{AllP{i}.E{eidx}.electrodes(:).maxIdxTr},'UniformOutput',0))*10;
        maxAmp=cell2mat(cellfun(@nanmedian,{AllP{i}.E{eidx}.electrodes.maxAmpTr},'UniformOutput',0));
        ch=find(pkTime<=stopTime & pkTime>=startTime & pkTime>1000 )
        ch=ch(ismember(ch,[AllP{i}.Tall{eidx}.Data.Params.activeCh]))
        idx=findNearest(startTime,extremeRange);
        %load([brainFile filesep AllP{i}.Tall{eidx}.Data.patientID filesep 'regdata'])
        xySF=BrainCoord(i).xySF
        xyCS=BrainCoord(i).xyCS
        xy=BrainCoord(i).xy
        gridDist=BrainCoord(i).gridDist
        clear devCS devSF xyCur
        for c=1:length(ch)
            xyCur(:,c)=xy(:,ch(c));
            [devCS(c),devSF(c)]=getSulcusDev(xyCur(:,c),xySF,xyCS);       
        end 
            figure(i+6)
            %subplot(1,5,i)           
            maxAmp(find(maxAmp>5))=5; 
            maxAmp(find(maxAmp<0))=0;            

            try
                %plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',i+2,colorjet(idx,:),.7,3)

                %plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',i+2,colorjet(idx,:),maxAmp(ch)./5,3)
                if s==3000
                    visualizeGrid(2,['E:\General Patient Info\' AllP{i}.Tall{2}.Data.patientID '\brain.jpg'],[]);
                    hold on
                end
                scatter(xyCur(1,:),xyCur(2,:),50,colorjet(idx,:),'fill')
                text(xyCur(1,:),xyCur(2,:),cellfun(@num2str,num2cell(ch),'UniformOutput',0))
                
             end
            %visualizeGrid(1,['E:\General Patient Info\' AllP{i}.Tall{2}.Data.patientID '\brain.jpg'],ch,maxAmp(ch),[],[],[],colorjet(idx,:),0);    
        hold on
        hl=line([-1000 1000],[0 0])
        set(hl,'Color','k','LineStyle','--')
        hl=line([0 0],[-1000 1000])
        set(hl,'Color','k','LineStyle','--')

        xlabel('distance from CS')
        ylabel('distance from SF')
        
        
        lim=80
        %axis([-lim lim -lim lim])
        title(num2str(s))
    end      
    s=s-step;
end
colormap(colorjet)
h=colorbar
ylabel(h,'Time Around Onset(ms)')
set(h,'YTick',linspace(0,1,10),'YTickLabel',linspace(minRange-2000,maxRange-2000,10))
ylabel(colorbar,'test')
set(gcf,'Color','w')