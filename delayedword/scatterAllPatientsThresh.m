
eidx=2
usesamps=200:5:300
clf
colorjet=flipud(jet)
xySFStandard=AllP{1}.xySF
xyCSStandard=AllP{1}.xyCS
stGrid=AllP{1}.gridDist 
clf
markershape={'p','o','^','d','s','^'}
for sidx=10:-1:1
    s=usesamps(sidx)
    %%
    for i=1:length(patients)-1 
        load([brainFile filesep AllP{i}.Tall{2}.Data.patientID filesep 'regdata'])
        %subplot(1,7,1)
        xySF=AllP{i}.xySF
        xyCS=AllP{i}.xyCS
        ch=AllP{i}.activeCh;        
        gridDist=AllP{i}.gridDist        
        d=mean(mean(AllP{i}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,s:s+10,:,:),2),4);
        d(find(d<0))=0;
        d(find(d>=5))=4;
        ch=ch(find(d>.5));
        clear devCS devSF
        for c=1:length(ch)
            xyCur=xy(:,ch(c));
            [devCS(c),devSF(c)]=getSulcusDev(xyCur,xySF,xyCS);       
        end
    
        try
            figure(1)
            %subplot(1,5,i)
            idx=floor(sidx/11*length(colorjet));
            if 1%~ismember(i,[1 3 4])
                scatter(devCS./gridDist,devSF./gridDist,100,colorjet(idx,:),'fill',markershape{i})
                %patchline((devCS./gridDist),(devSF./gridDist),'edgecolor',colorjet(idx,:),'linewidth',2,'edgealpha',0.1,'Marker','^')

            else
                scatter(devCS./gridDist,devSF./gridDist,100,colorjet(idx,:),markershape{i})
            end

            hold on
        end
        try
        %     scatter(devCS./gridDist,devSF./gridDist,100,colorjet(ceil(i*length(colorjet)/5),:),'fill')
        end

        hold on
        line([-1000 1000],[0 0])
        line([0 0],[-1000 1000])
        xlabel('distance from CS')
        ylabel('distance from SF')
        axis([-2 2 -2 2])
        title(num2str(s))
        
%         figure(1)
%         
%         subplot(1,7,i+2)
%         try
%             visualizeGrid(1,['E:\General Patient Info\' AllP{i}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,d(find(d>0)),[],[],[],[],1);
%         end
    end
    %%
    
    %input('n')
    %clf
end