%%LOAD VARIABLES
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\errorrates')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\stimsites')
%%
n=11
T{1}=PLVTests(n,2,1:256,'aa');T{2}=PLVTests(n,4,1:256,'aa');T{3}=PLVTests(n,5,1:256,'aa')
%%

for site=1:5
    for t=1:3
        subplot(5,3,(site-1)*3+t)
        bar(errorrates(site,1:3,t))
    end
end
%%
regions{1}=[1 2 4]
regions{2}=[3 5]
for r=1:2
    for t=1:3
        subplot(2,3,(r-1)*3+t)
        bar(sum(errorrates(regions{r},1:3,t),1))
    end
end
%%
subplot(2,1,1)
bar(squeeze(sum(errorrates(regions{1},1:3,:),1))','stacked')
ylim([0 3])
set(gca,'XTickLabel',{'Pres','Delay','Prod'})
set(gca,'Box','off')
%rotateticklabel(gca,40)

title('mSTG')

subplot(2,1,2)
bar(squeeze(sum(errorrates(regions{2},1:3,:),1))','stacked')
ylim([0 3])
colormap(pink)
legend({'perc','phon','none'})
set(gca,'XTickLabel',{'Pres','Delay','Prod'})
%rotateticklabel(gca,40)
title('pSTG')

set(gca,'Box','off')

%% PLOT STIMULATION ERROR SITES AND ECOG DATA
%powerpoint_object=SAVEPPT2('test2.ppt','init')
titlelabel={'Presentation','Delay','Production'}
%figure
for site=[4 5]%:5
    for c=1:length(stimsites{site})
        for t=1:3
            set(gcf,'Name',int2str([stimsites{site}(c) site]))
            subplot(2,3,t)
            indices=T{t}.Data.findTrials('1','n','n')
            [hl,hp]=errorarea(mean(T{t}.Data.segmentedEcog.zscore_separate(stimsites{site}(c),:,:,indices.cond1),4),ste(T{t}.Data.segmentedEcog.zscore_separate(stimsites{site}(c),:,:,indices.cond1),4)*2)
            hold on
            [hl,hp]=errorarea(mean(T{t}.Data.segmentedEcog.zscore_separate(stimsites{site}(c),:,:,indices.cond2),4),ste(T{t}.Data.segmentedEcog.zscore_separate(stimsites{site}(c),:,:,indices.cond2),4)*2)
            set(hl,'Color','r');set(hp,'FaceColor','r');
            axis([0 1600 -1 5])
            h=line([800 800],[-1 5])
            set(h,'Color',rgb('rosybrown'))
            set(gca,'Box','off')
            if ismember(t,[2,3])
                setAxisLook(gca)
            end
            title(titlelabel{t})

            subplot(2,3,t+3)
            h=bar(errorrates(site,1:3,t))
            for i=1:length(h)
                set(h(i),'FaceColor',rgb('rosybrown'))
                set(h(i),'EdgeColor','none')
            end
            set(gca,'XTickLabel',{'Perc','Phon','None'})   
            set(gca,'Box','off')
            axis([.5 3.5 0 8])
             if ismember(t,[2,3])
                setAxisLook(gca)
             end
        end
        saveppt2('ppt',powerpoint_object,'scale','off','stretch','off','Title',int2str([stimsites{site}(c) site]));
        n=input('n')
        clf
    end
end
%% PLOT LOCATION
for site=[4 5]%:5
    for c=1:length(stimsites{site})
        for t=1:3
            visualizeGrid(2,['E:\General Patient Info\' T{1}.Data.patientID '\brain.jpg'],stimsites{site}(c),1,1,1);
        end
        
        saveppt2('ppt',powerpoint_object,'scale','off','stretch','off','Title',int2str([stimsites{site}(c) site]));
        n=input('n')
    end
end
%%
figure
c=subset2(find(kgroup==3))
usechan(c)
visualizeGrid(5,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan(c),repmat(1,1,length(c)));
visualizeGrid(2,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan(c));

figure
for i=1:length(c)
    plotGridPosition(usechan(c(i)))
    plot(squeeze(mean(T.Data.segmentedEcog.zscore_separate(usechan(c(i)),:,:,:),4))')
    axis tight
end
%%
%figure
c=189
clf
subplot(1,4,1)
visualizeGrid(2,['E:\General Patient Info\' T{1}.Data.patientID '\brain.jpg'],c);   
for t=1:3
    subplot(1,4,t+1)
    indices=T{t}.Data.findTrials('1','n','n')
    [hl,hp]=errorarea(mean(T{t}.Data.segmentedEcog.zscore_separate(c,:,:,indices.cond1),4),ste(T{t}.Data.segmentedEcog.zscore_separate(c,:,:,indices.cond1),4)*2)
    hold on
    [hl,hp]=errorarea(mean(T{t}.Data.segmentedEcog.zscore_separate(c,:,:,indices.cond2),4),ste(T{t}.Data.segmentedEcog.zscore_separate(c,:,:,indices.cond2),4)*2)
    set(hl,'Color','r');set(hp,'FaceColor','r');
    axis([0 1600 -1 5])
    h=line([800 800],[-1 5])
    set(h,'Color',rgb('rosybrown'))
    set(gca,'Box','off')
    if ismember(t,[2,3])
        setAxisLook(gca)
    end
    title(titlelabel{t})
end
saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');

%%
seg=[2 5]
for s=1:length(Tall{2}.Data.Params.stimSites)
    sites=Tall{2}.Data.Params.stimSites(s).ch;
    for ch=sites
        for e=1:2
            indices=Tall{seg(e)}.Data.findTrials('1','n','n')
            subplot(1,2,e)
            errorarea(mean(Tall{seg(e)}.Data.segmentedEcog.smoothed100(ch,:,indices.cond1),3),2*ste(Tall{seg(e)}.Data.segmentedEcog.smoothed100(ch,:,indices.cond1),3))
            hold on
           [hl,hp]=errorarea(mean(Tall{seg(e)}.Data.segmentedEcog.smoothed100(ch,:,indices.cond2),3),2*ste(Tall{seg(e)}.Data.segmentedEcog.smoothed100(ch,:,indices.cond2),3))
             set(hl,'Color','r');set(hp,'FaceColor','r');

            hl=line([200 200],[-1 5])
            set(hl,'Color',rgb('gray'),'LineStyle','--')
            axis tight
            set(gca,'XTickLabel',[-1:2],'Box','off')
            if e==1
                ylabel(['ch ' int2str(ch)])
            end
            
            hold off
        end
        input('m')
        %saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    end
end
%% 
seg=[2 5]
for s=1:length(Tall{2}.Data.Params.stimSites)
    sites=Tall{2}.Data.Params.stimSites(s).ch;
    for ch=sites
        for e=1:2
            indices=Tall{seg(e)}.Data.findTrials('1','n','n')
            subplot(length(sites),1,find(sites==ch))
           [hl,hp]=errorarea(mean(Tall{seg(e)}.Data.segmentedEcog.smoothed100(ch,:,indices.cond2),3),2*ste(Tall{seg(e)}.Data.segmentedEcog.smoothed100(ch,:,indices.cond2),3))         
            if e==1
                ylabel(['ch ' int2str(ch)])
            elseif e==2
                set(hl,'Color','r');set(hp,'FaceColor','r');
            end
             hl=line([200 200],[-1 5])
            set(hl,'Color',rgb('gray'),'LineStyle','--')
            axis tight
            set(gca,'XTickLabel',[-1:2],'Box','off')
            hold on
        end
        hold off
    end
    input('m')
    saveppt2('ppt',powerpoint_object,'scale','off','stretch','off');
    clf
end