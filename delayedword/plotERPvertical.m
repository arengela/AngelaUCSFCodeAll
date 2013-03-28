%% PLOT PERC AND PRODUCTION DATA VERTICALLY
% SORTED BY PRODUCTION PEAK TIME
indices.cond2=AllP{p}.Tall{eidx}.Data.Params.usetr;
indicesB.cond2=AllP{p}.Tall{2}.Data.Params.usetr;

electrodes=AllP{p}.E{eidx}.electrodes
pkTime=[electrodes.peakTime];
[~,sortIdx]=sort(pkTime)
ch=AllP{p}.Tall{eidx}.Data.Params.activeCh
figure
colorjet=hot.*repmat(rgb('gold'),length(jet),1)
%colorjet=colormap(gray.*autumn)
%colorjet=flipud(jet)
%colorjet=(hot.*(copper))

[~,s]=sort(pkTime(ch));

% [angles,rho]=getRadialProjection(AllP{p}.Tall{2}.Data.Params.xyO,AllP{p}.Tall{2}.Data.Params.xAxis,...
%     AllP{p}.Tall{2}.Data.Params.xy(:,AllP{p}.Tall{2}.Data.Params.activeCh))
% [~,s]=sort(angles)
%extremeRange=linspace(min(pkTime(ch)),max(pkTime(ch)),64)
extremeRange=linspace(500,2000,64);
vertShift=fliplr((1:length(s))./2);
for i=1:length(s)
    subplot('Position',[.55 0 .45 .9])
    if ismember(ch(s(i)),AllP{p}.Tall{5}.Data.Params.activeCh)
        idx=findnearest(pkTime(ch(s(i))),extremeRange)
        data=mean([squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indices.cond2))],2);
        hold on
        hl=plot(data+vertShift(i),'Color',colorjet(idx,:),'LineWidth',2)
        set(gca,'Box','off')
        set(gca,'Visible','off')
        hl=line([200 200],[-1 max(vertShift)])
        set(hl,'Color',rgb('gray'),'LineStyle','--')
    else
        data=mean([squeeze(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
        hl=plot(data+vertShift(i),'Color',rgb('lightgray'),'LineWidth',2)
    end
    axis tight
    
    subplot('Position',[.05 0 .45 .9])
    if ismember(ch(s(i)),AllP{p}.Tall{2}.Data.Params.activeCh)
        idx=findnearest(AllP{p}.E{2}.electrodes(ch(s(i))).peakTime,extremeRange)
        data=mean([squeeze(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
        hl=plot(data+vertShift(i),'Color',colorjet(idx,:),'LineWidth',2)
        hold on
        hl=line([200 200],[-1 max(vertShift)])
        set(gca,'Box','off')
        set(gca,'Visible','off')
        set(hl,'Color',rgb('gray'),'LineStyle','--')
    else
        data=mean([squeeze(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(ch(s(i)),1:end,:,indicesB.cond2))],2);
        hl=plot(data+vertShift(i),'Color',rgb('lightgray'),'LineWidth',2)
    end
    text(-40,data(1)+vertShift(i),int2str(ch(s(i))),'FontSize',8','Color',rgb('gray'))
    axis tight
end
set(gcf,'Position',[1039 70 497 841],'Color','w')