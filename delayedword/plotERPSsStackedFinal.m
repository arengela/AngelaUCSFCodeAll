%PLOT ERPS FINAL
%% PLOT ERPS FINAL
load E:\DelayWord\ERPPlots\ERpSites.mat
samps=1:400;
colorcell={'k','k','b'};
eventSamp=200;
set(gcf,'Color','w')
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
eventSamp=200
for p=1:8
    clf
    idx=find([erpSites{:,1}]==p);
    for i=1:length(idx)
        for eidx=[2 5]
            AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
            usetrials=AllP{p}.Tall{eidx}.Data.Params.usetr;
            r=erpSites{idx(i),2};  
            e=find([2 5]==eidx);
            pos=subplotMinGray(10,6,i,e);
            subplot('Position',pos);
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(r,samps,usetrials),3),...
                nansem(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(r,samps,usetrials),3));
            hold on
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});
            
            try                  
%                 [hl,hp]=errorarea(mean(AllP_P{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(r,samps,:),3),...
%                 ste(AllP_P{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(r,samps,:),3));
%                 %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
%                 set(hl,'Color','b');
%                 set(hp,'FaceColor','b');
            end

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(r).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(r).TTest)+eventSamp,-2+(.3*e),'.','Color','r','MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color',rgb('lightgray'),'LineStyle',':')

            axis([0 400 -1 6])
            set(gca,'xcolor',rgb('lightgray'),'ycolor',rgb('lightgray'),'Box','off','XTickLabel',[],'YTickLabel',[])

            if i==length(idx) & eidx==2
                set(gca,'xcolor',rgb('gray'),'ycolor',rgb('gray'),'Box','off','XTickLabel',[],'YTickLabel',[])
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTick',-2:2:10,'YTickLabel',-2:2:10,'box','off')
                xlabel('Time (s)')
                ylabel('zscore')
            elseif i==length(idx) & eidx==5
                set(gca,'xcolor',rgb('gray'),'ycolor',rgb('gray'),'Box','off','XTickLabel',[],'YTickLabel',[])
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTickLabel',[],'box','off')
            else
                %set(gca,'Box','off','XTickLabel',[],'YTickLabel',[])
                set(gca,'xcolor',rgb('lightgray'),'ycolor',rgb('lightgray'),'Box','off','XTickLabel',[],'YTickLabel',[])
            end
            
            
            
            pos=subplotMinGray(10,6,i,e+2);
             ca=subplot('Position',pos);
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            pcolor(flipud(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(r,samps,usetrials))'));
            shading interp
            set(gca,'clim',[0 5])
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle',':')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+flipud(res)*100,1:length(usetrials),'k') 

            set(gca,'xcolor',rgb('gray'),'ycolor',rgb('gray'),'Box','off','XTickLabel',[],'YTickLabel',[])

            if i==length(idx) & eidx==2
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTickLabel',[],'box','off')                
                xlabel('Time (s)')
                %ylabel('Trial Num')
            elseif i==length(idx) & eidx==5
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTickLabel',[],'box','off')                
            else
                set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            end
        end
        pos=subplotMinGray(10,6,i,5);
        subplot('Position',pos)
        visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain5.jpg'],r);
        freezeColors
        set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
        text(50,20,int2str(r),'Color',rgb('gray'),'FontSize',8)
    end
    colormap(redblackwhite)
    %print(gcf,'-r1200', '-dpdf', ['E:\DelayWord\ERPPlots\s' int2str(p) '.pdf']);
    input('n')
    clf
end
%% PLOT ERPS BY WORDTYPE


%% PLOT ERPS FINAL WITH SIG 
load E:\DelayWord\ERPPlots\ERpSites.mat
load E:\DelayWord\CompareEvsH\holdPval_SL.mat
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\basic\redblackwhite')
samps=1:400;
colorcell={'k','r','g'};
eventSamp=200;
set(gcf,'Color','w')
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
eventSamp=200
sigPos=[-.6 -.9]
%sigPos=[6.5 6.9]
for p=1:8
    clf
    idx=find([erpSites{:,1}]==p);
    for i=1:length(idx)
        %%
        for eidx=[2 5]
            AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
            usetrials=AllP{p}.Tall{eidx}.Data.Params.usetr;
            r=erpSites{idx(i),2};  
            e=find([2 5]==eidx);
            pos=subplotMinGray(10,6,i,e);
            subplot('Position',pos);
            gGrouped={[1 2],[3:6]}; %Short vs Long
             %gGrouped={[3 4],[5 6]};%Easy vs diff Long words
             %gGrouped={[3 5],[4 5]}% freq vs infreq
             %gGrouped={[3 4],[5 6],[1 2]}
             %% PLOT SIG VALUES
             for g1=1:length(gGrouped)
                hold on
                g=gGrouped{g1};
                dHold{g1}=cat(4,wordTypeResponse(p,eidx).group(g).data);
             end 
             try
                sigSamp=find(holdPval{p,eidx,r,3}<=.05);
                 hl=line([sigSamp ;sigSamp],...
                     [nanmean(dHold{1}(r,sigSamp,:,:),4); nanmean(dHold{2}(r,sigSamp,:,:),4)]);
                 set(hl,'Color',rgb('yellow'))
             end
             for g1=1:length(gGrouped)
                 g=gGrouped{g1};
                 [hl,hp]=errorarea(nanmean(dHold{g1}(r,:,:,:),4),nansem(dHold{g1}(r,:,:,:),4));
                 set(hl,'Color',colorcell{g1});
                 set(hp,'FaceColor',colorcell{g1});
                 try
                     plot(find(holdPval{p,eidx,r,g1}<=0.05),sigPos(g1),'.','Color',colorcell{g1},'MarkerSize',3)
                 end
                 
                 %Plot end of word time
%                  if eidx==2
%                      hl=line([200+mean(cat(1,wordTypeResponse(p,eidx).group(g).wordLengthPerc))/10 ,200+mean(cat(1,wordTypeResponse(p,eidx).group(g).wordLengthPerc))/10],...
%                          [-1 10]);
%                      set(hl,'Color',colorcell{g1},'LineStyle',:)
%                  end
             end
             %% PLOT STACKED
            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(r).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(r).TTest)+eventSamp,-2+(.3*e),'.','Color','r','MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 10]);
            set(hl,'Color',rgb('lightgray'),'LineStyle',':')

            axis([0 400 -1 8])
            set(gca,'xcolor',rgb('lightgray'),'ycolor',rgb('lightgray'),'Box','off','XTickLabel',[],'YTickLabel',[])

            if i==length(idx) & eidx==2
                set(gca,'xcolor',rgb('gray'),'ycolor',rgb('gray'),'Box','off','XTickLabel',[],'YTickLabel',[])
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTick',-2:2:10,'YTickLabel',-2:2:10,'box','off')
                xlabel('Time (s)')
                ylabel('zscore')
            elseif i==length(idx) & eidx==5
                set(gca,'xcolor',rgb('gray'),'ycolor',rgb('gray'),'Box','off','XTickLabel',[],'YTickLabel',[])
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTickLabel',[],'box','off')
            else
                %set(gca,'Box','off','XTickLabel',[],'YTickLabel',[])
                set(gca,'xcolor',rgb('lightgray'),'ycolor',rgb('lightgray'),'Box','off','XTickLabel',[],'YTickLabel',[])
            end
            
            pos=subplotMinGray(10,6,i,e+2);
             ca=subplot('Position',pos);
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            pcolor(flipud(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(r,samps,usetrials))'));
            shading interp
            set(gca,'clim',[0 5])
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle',':')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+flipud(res)*100,1:length(usetrials),'k') 

            set(gca,'xcolor',rgb('gray'),'ycolor',rgb('gray'),'Box','off','XTickLabel',[],'YTickLabel',[])

            if i==length(idx) & eidx==2
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTickLabel',[],'box','off')                
                xlabel('Time (s)')
                %ylabel('Trial Num')
            elseif i==length(idx) & eidx==5
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTickLabel',[],'box','off')                
            else
                set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            end
        end
        pos=subplotMinGray(10,6,i,5);
        subplot('Position',pos)
        visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain5.jpg'],r);
        freezeColors
        set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
        text(50,20,int2str(r),'Color',rgb('gray'),'FontSize',8)
    end
    colormap(redblackwhite)
    %print(gcf,'-r1200', '-dpdf', ['E:\DelayWord\ERPPlots\SLwSig_s' int2str(p) '.pdf']);
    

set(gcf,'Renderer','opengl','PaperPositionMode','default')
    filename=['E:\DelayWord\ERPPlots\SLwSig_s' int2str(p) '.pdf']
    eval(['export_fig ' filename ' -opengl'])
    input('n')
    clf
end


set(gcf,'Renderer','opengl','PaperPositionMode','default')
    filename=['E:\DelayWord\ERPPlots\SLwSig_s' int2str(p) '.pdf']
    eval(['export_fig ' filename ' -opengl'])
   