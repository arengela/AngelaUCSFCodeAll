%% GET CHANNELS WITHIN RADIUS OF STIM SITE
for p=1:length(patients)-1
    d=squareform(pdist([BrainCoord(p).xy,BrainCoord(p).stimLoc]'));
    d2=d(size(BrainCoord(p).xy,2)+1:end,1:size(BrainCoord(p).xy,2));
    for i=1:size(BrainCoord(p).stimLoc,2)
        BrainCoord(p).stimCh{i}=find(d2(i,:)<30)
    end
end
%% LOOK AT STIM SITE CHANNELS
for p=1:length(patients)-1
    for i=1:size(BrainCoord(p).stimLoc,2)
        visualizeGrid(2,['E:\General Patient Info\' patients{p} '\brain5.jpg'],[]);
        scatter(BrainCoord(p).stimLoc(1,i),BrainCoord(p).stimLoc(2,i),'fill','r')
        scatter(BrainCoord(p).xy(1,BrainCoord(p).stimCh{i}),BrainCoord(p).xy(2,BrainCoord(p).stimCh{i}))
        input('n')
        clf
    end
end
%% PLOT ECOG SIGNAL FOR CHANNELS AROUND STIM SITE
figure
for p=1:length(patients)-1
    for i=1:size(BrainCoord(p).stimLoc,2)
        subplot(1,4,1)
        visualizeGrid(2,['E:\General Patient Info\' patients{p} '\brain5.jpg'],[]);
        scatter(BrainCoord(p).stimLoc(1,i),BrainCoord(p).stimLoc(2,i),'fill','r');
        for eidx=[2 4 5]
            e=find([2 4 5]==eidx);
            subplot(1,4,e+1)
            usech=setdiff(BrainCoord(p).stimCh{i},AllP{p}.Tall{eidx}.Data.Artifacts.badChannels);
            usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),4)');
            line([200 200],[-1 10])
            axis([0 400 -.5 6])
        end
        input('n')
        clf
    end
end
%% PLOT STIM SITES BY QUAD
clear stimQuad
for p=1:length(patients)-1
    for i=1:size(BrainCoord(p).stimLoc,2)
        q=getBrainQuadrant(BrainCoord(p).xySF,BrainCoord(p).xyCS,BrainCoord(p).stimLoc(:,i));
        try
            stimQuad(q).stimLoc=vertcat(stimQuad(q).stimLoc,[BrainCoord(p).stimLoc(:,i)' p]);
        catch
            stimQuad(q).stimLoc=[BrainCoord(p).stimLoc(:,i)' p];
        end
        stimQuad(q).stimCh{size(stimQuad(q).stimLoc,1)}=BrainCoord(p).stimCh{i};
    end
end
%%
for q=1:4
    %%
    rows=size(stimQuad(q).stimLoc,1)
    for pages=1:floor(rows/10);
        clf
        %figure('Position',[0 0 .5 1],'Units','Normalized')
        channelsPage=10;
        if pages==floor(rows/10)
            channelsPage=rem(rows,10);
            if channelsPage==0
                channelsPage=10;
            end
        end
        for row=1:channelsPage
            r=(pages-1)*10+row;
            
            p=stimQuad(q).stimLoc(r,3);
            pos=subplotMinGray(10,5,row,0);
            subplot('position',pos);
            visualizeGrid(2,['E:\General Patient Info\' patients{p} '\brain5.jpg'],[]);
            set(gca,'visible','off')
            scatter(stimQuad(q).stimLoc(r,1),stimQuad(q).stimLoc(r,2),'fill','r');
            for eidx=[2 4 5]
                e=find([2 4 5]==eidx);
                pos=subplotMinGray(10,4,row,e);
                subplot('position',pos);
                usech=setdiff(stimQuad(q).stimCh{r},AllP{p}.Tall{eidx}.Data.Artifacts.badChannels);
                usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
                plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),4)');
                line([200 200],[-1 10])
                axis([0 400 -.5 6])
            end
        end
        filename=['E:\DelayWord\ECSandECOG\q' int2str(q) '_page' int2str(pages) '.pdf']
        eval(['export_fig ' filename ' -painters'])
    end
    %input('n')
end
%% GET STIM SITES WITH ECOG SUBJS
figure
for p=[2 3 6 7]
    visualizeGrid(2,['E:\General Patient Info\' patients{p} '\brain6.jpg'],[]);
    [x,y]=ginput;
    BrainCoord(p).stimLoc2=[x';y'];
    BrainCoord(p).stimName=input('Enter stim name','s');
end

%% GET CHANNELS WITHIN RADIUS OF STIM SITE
for p=[ 2 3 6 7]
    d=squareform(pdist([BrainCoord(p).xy,BrainCoord(p).stimLoc2]'));
    d2=d(size(BrainCoord(p).xy,2)+1:end,1:size(BrainCoord(p).xy,2));
    for i=1:size(BrainCoord(p).stimLoc2,2)
        BrainCoord(p).stimCh2{i}=find(d2(i,:)<30)
    end
end
%% PLOT BY TASK TYPE
load('E:\DelayWord\StimData\stimsites')
load('E:\DelayWord\StimData\siteCoord')
load('E:\DelayWord\StimData\stimTask')
set(gcf,'Color','w')

task={'A','R','N','R/N'}
for t=1:length(task)
    %%
    idx=find(~cellfun(@isempty,strfind(stimTask(:,4),task{t})) & ~cellfun(@isempty,stimTask(:,2)) );
    for row=1:length(idx);
        try
            p=find(strcmp(patients',stimTask{idx(row),2}))
            tmp=regexp(BrainCoord(p).stimName,' ','split');
            
            site=[];
            for i=1:length(tmp)
                tmp2=strfind(stimTask{idx(row),5},tmp{i});
                if ~isempty(tmp2)
                    site=[site i];
                end
            end
            pos=subplotMinGray(length(idx),5,row,0)
            subplot('Position',pos)
            visualizeGrid(2,['E:\General Patient Info\' patients{p} '\brain6.jpg'],[]);
            set(gca,'visible','off')
            l=length(BrainCoord(p).stimLoc2);
            scatter(BrainCoord(p).stimLoc2(1,site),BrainCoord(p).stimLoc2(2,site),'fill','r');
            if isempty(site)
                continue
            end
            for eidx=[2 4 5]
                e=find([2 4 5]==eidx);
                pos=subplotMinGray(length(idx),5,row,e)
                subplot('Position',pos)
                usech=[BrainCoord(p).stimCh2{site}];
                usech=setdiff(usech,AllP{p}.Tall{eidx}.Data.Artifacts.badChannels);
                usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
                plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),4)','Color',rgb('lightgray'));
                hold on
                d=[];
                for i=1:length(usech)
                    d=cat(4,d,AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech(i),:,:,:));
                end
                [hl,hp]=errorarea(mean(d,4),nansem(d,4));
                set(hp,'FaceColor',rgb('black'))
                set(hl,'Color',rgb('black'))
                %errorarea(mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),4)',2),nansem(reshape(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),1,400,1,[]),4))
                hl=line([200 200],[-1 10]);
                set(hl,'Color','k','LineStyle',:)
                axis([0 400 -.5 6])
                displayLabelsPlot
                
                try
                    %% PLOT ERROR TYPES
                    p2=patientSummary(strcmp(patientSummary(:,2),stimTask{idx(row),2}),1);
                    %                     tmp=stimsites(:,2)
                    %                     site=[];
                    %                     for i=1:length(tmp)
                    %                         tmp2=strfind(stimTask{idx(row),5},tmp{i});
                    %                         if ~isempty(tmp2)
                    %                            site=[site i];
                    %                         end
                    %                     end
                    
                    
                    idx2=find(strcmp(stimsites(:,1),p2) & strcmp(stimsites(:,2),stimTask{idx(row),5}))
                    err=stimsites(idx2,9);
                    clear errCount
                    for i=1:5
                        errCount(i)=length(find(strcmp(errors{i},err)))
                    end
                    errCount(6)=length(err)-sum(errCount);
                    pos=subplotMinGray(length(idx),5,row,4)
                    subplot('Position',pos)
                    b=bar(errCount);
                    set(b,'FaceColor',rgb('gray'),'EdgeColor',rgb('gray'))
                    %pie(errCount)
                    axis([0 7 0 4])
                    set(gca,'XTickLabel',[errors;'ne'])
                    set(gca,'Box','off')
                end
                
            end
        end
    end
    input('n')
    clf
end
%%
%% GET TASK POINTS ON NORMALIZED BRAIN
load('E:\DelayWord\StimData\sulciCoord')
load('E:\DelayWord\StimData\stimTaskCoord')
a=imread('E:\DelayWord\StimData\brain2.jpg');
imshow(repmat(a,[1 1 3]))
hold on
origin=[368.6203  452.8957]
xySF=sulciCoord.xySF;
xyCS=sulciCoord.xyCS;
for i=1:length(stimTaskCoord)
    xysites(i,:)=plotPointsBrainNormalized2(stimTaskCoord{i,5},stimTaskCoord{i,4},xySF,xyCS,origin);
    %text(xy(i,1),xy(i,2),siteCoord(i,1))
end
scatter(xysites(:,1),xysites(:,2))
stimTaskCoord(:,6)=num2cell(double(xysites(:,1)))
stimTaskCoord(:,7)=num2cell(double(xysites(:,2)))
%% PLOT BY TASK TYPE AND PLOT SITES ON NORMALIZED BRAIN
load('E:\DelayWord\StimData\stimsites')
load('E:\DelayWord\StimData\siteCoord')
load('E:\DelayWord\StimData\stimTask')
load('E:\DelayWord\StimData\patientSummary')
a=imread('E:\DelayWord\StimData\brain2.jpg');

%errors=unique(cellstr(char(stimsites{:,9})));
%errors=errors([5 6 2 4 3])
errors={'per','ph','ms','off','nr'}
set(gcf,'Color','w')
clf

task={'A','R','N','R/N'}
pos=subplotMinGray(3,5,3,0)
subplot('Position',pos)
imagesc(repmat(a,[1 1 3]))
imshow(a)
hold on
set(gca,'visible','off')

plotSite=1;
d=cell(5,3);
devent=cell(5,3);

for t=1:2
    %%
    pos=subplotMinGray(3,5,t,0)
    subplot('Position',pos)
    imagesc(repmat(a,[1 1 3]))
    imshow(a)
    hold on
    set(gca,'visible','off')
    
    idx=find(~cellfun(@isempty,strfind(stimTask(:,4),task{t})) & ~cellfun(@isempty,stimTask(:,2)) );
    %%
    for row=1:length(idx);
        %% PLOT ERROR TYPES
        if t==2
            p2=patientSummary(strcmp(patientSummary(:,2),stimTask{idx(row),2}),1);
            idx2=find(strcmp(stimsites(:,1),p2) & strcmp(stimsites(:,2),stimTask{idx(row),5}))
            err=stimsites(idx2,9);
            errWordType=cat(1,errWordType,stimsites(idx2,6));
            clear errCount
            for i=1:5
                errCount(i)=length(find(strcmp(errors{i},err)))
            end
            errCount(6)=length(err)-sum(errCount);
            percErr=errCount./sum(errCount)
            [~,errNum]=max(percErr);
            if errNum==1
                plotSite=2;
            elseif errNum==4
                plotSite=3;
            end
        end
        
        if 1%plotSite==1
            try
                p=find(strcmp(patients',stimTask{idx(row),2}))
                tmp=regexp(BrainCoord(p).stimName,' ','split');
                site=[];
                for i=1:length(tmp)
                    tmp2=strfind(stimTask{idx(row),5},tmp{i});
                    if ~isempty(tmp2)
                        site=[site i];
                    end
                end
                if isempty(site)
                    continue
                end                
                l=length(BrainCoord(p).stimLoc2);
                pos=subplotMinGray(3,5,plotSite,0)
                subplot('Position',pos)
                scatter(stimTaskCoord{idx(row),6},stimTaskCoord{idx(row),7},'fill','r');
                 hold on
     set(gca,'handlevisibility','off', ...
                'visible','off')
                for eidx=[2 5]
                    e=find([2 5]==eidx);
                    %pos=subplotMinGray(3,4,plotSite,e,.05)
                    %subplot('Position',pos)
                    usech=[BrainCoord(p).stimCh2{site}];
                    usech=setdiff(usech,AllP{p}.Tall{eidx}.Data.Artifacts.badChannels);
                    usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
                    
                    if t==1
                        tmp3=max(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,usetr)),[],2)
                        [r,c]=find(squeeze(tmp3)>3);
                        usetr=usetr(setdiff(1:length(usetr),unique(c)));
                    end
                    %plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,usetr),4)','Color',rgb('lightgray'));
                    %hold on
                    for i=1:length(usech)
                        d{eidx,plotSite}=cat(4,d{eidx,plotSite},AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech(i),:,:,usetr));
                        devent{eidx,plotSite}=cat(1,devent{eidx,plotSite},AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetr,8))
                    end
                end
            end
        end
    end
   
            
end

%% PLOT BY WG (PLOT PERC AND PROD ONLY)
%gGrouped={[1 2],[3:6]}%short vs long
%gGrouped={[ 3 5],[ 4 6]}%F vs I
gGrouped={[3 4],[5 6],[1,2]}%E vs H
%gGrouped={1,2,3,4,5,6}
colorcell={'r','b','g','m','k','y'}
clf
opengl software
for plotSite=1:3
    for eidx=[2 5]
        
        
        
        e=find([2 5]==eidx);
        pos=subplotMinGray(3,5,plotSite,e,.02)
        subplot('Position',pos)
        cla
        
        Labels=devent{eidx,plotSite}
        clear LabelsGroups
        for i=1:length(Labels)
            idx=find(strcmp(Labels{i},{brocawords.names}))
            if isempty(idx)
                continue;
            else
                if brocawords(idx).logfreq_HAL>8.75
                    f='f';
                else
                    f='i'
                end
                LabelsGroups{i}=strcat(brocawords(idx).lengthtype(1),brocawords(idx).difficulty(1),f);                
            end
        end
        
        clear wordGroupArray
        for g=1:length(wordGroups)
            trNum=find(strcmp(wordGroups{g},LabelsGroups));
            wordGroupArray(trNum)=g;
        end 
        
        if plotSite==1 & eidx==5
            for gidx=1:length(gGrouped)
                g=gGrouped{gidx};
                usetr=find(ismember(wordGroupArray,g))
                [hl]=plot(mean(d{eidx,plotSite}(:,:,:,usetr),4));
                %set(hp,'FaceColor',colorcell{gidx},'FaceAlpha',.7)
                set(hl,'Color',colorcell{gidx},'LineWidth',2)
                %errorarea(mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),4)',2),nansem(reshape(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),1,400,1,[]),4))
                %hl=line([200 200],[-1 10]);
                %set(hl,'Color',rgb('darkred'),'LineStyle',:)
                hold on
            end
            legend({'SE','LE','LH'})
        end
        
        
        for gidx=1:length(gGrouped)
            g=gGrouped{gidx};
            usetr=find(ismember(wordGroupArray,g))
            [hl,hp]=errorarea(mean(d{eidx,plotSite}(:,:,:,usetr),4),nansem(d{eidx,plotSite}(:,:,:,usetr),4));
            set(hp,'FaceColor',colorcell{gidx},'FaceAlpha',.5)
            set(hl,'Color',colorcell{gidx},'LineWidth',2)
            %errorarea(mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),4)',2),nansem(reshape(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,:),1,400,1,[]),4))
            hl=line([200 200],[-1 3]);
            set(hl,'Color',rgb('darkred'),'LineStyle',:)
            hold on
        end
        axis([0 400 -.5 3])
        displayLabelsPlot
        set(gca,'YTick',0:2,'YTickLabel',0:4)
        if plotSite==3
            xlabel('Time (s)')
        end
        if e==1
            ylabel('zscore')
        else
            set(gca,'YColor','w')
        end
    end
end



%legend('SE','LE','LH')
%% STIM RESULTS BY WORD TYPE


allStimSites(find(strcmp(allStimSites(:,9),'per')),6)
allStimSites(find(strcmp(allStimSites(:,9),'ph')),6)
hist(grp2idx(allStimSites(find(strcmp(allStimSites(:,9),'ph')),6)))