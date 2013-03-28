p=8
plotCh{1}=[52 104 118 152 169 185 201]
plotCh{2}=[86 24 89 91 107 115 36]
plotCh{3}=[115 65 130 147 164 181 198 237 29 45 139]
plotCh{4}=[103 135 35 82 69 51 151 214 53 37 84]
plotCh{5}=[2 69 51 35 117 165 197 244 188 155 95 125 112]
plotCh{6}=[52 53 150 167 102 151 199 198 233 251 112]
colorcell={'r','k','b'}

%%
plotCh{1}=63
plotCh{2}=64
plotCh{3}=84
plotCh{4}=87
plotCh{5}=[166 183]
plotCh{6}=[101 70 152]
plotCh{7}=[151 65 148]
plotCh{8}=[72 124]
%%
%figure
[s,sidx1]=sort([AllP{p}.E{eidx}.electrodes(plotCh{p}).peakTime])


eventSamp=100
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
colorcell={'r','k','b'}
clf
set(gcf,'Color','w')
samps=100:350;
clf
for s=1:ceil(256/13)
    sidx1=(s-1)*13+1:s*13;
    plotCh{p}=1:256;
    clf
    for c=sidx1
        for eidx=[2 4 5]
            e=find([2 4 5]==eidx);
            usetrials=AllP{p}.Tall{eidx}.Data.Params.usetr;
            r=rem(c,13);
            if r==0
                r=13;
            end
            
            pos=subplotMinGray(13,4,r,0);
            subplot('Position',pos);
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3),...
                ste(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3));
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest)+eventSamp,-2+(.3*e),'.','Color',colorcell{e},'MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color','k','LineStyle','--')

            axis tight
            text(50,4,int2str(plotCh{p}(c)))
            set(gca,'Visible','off')

            pos=subplotMinGray(13,4,r,e);
            ca=subplot('Position',pos);
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials))',[0 5]);
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle','--')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+res*100,1:length(usetrials),'k')   
            
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])


            pos=subplotMinGray(13,4,r,4);
            subplot('Position',pos)        
            visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],plotCh{p}(c));
            freezeColors
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
        end
    end
    colormap(redblackwhite)
    input('n')
end
  %%
  %figure
  clf
  set(gcf,'Color','w')
  pat=[1 2 3 4 5 6 7 8]
  eventSamp=100
  samps=100:300
for pp=1:6
    p=pat(pp);
    for c=1:size(plotCh{p},2)%size(orderedCh,1)
        for eidx=[2 4 5]
            e=find([2 4 5]==eidx);
            usetrials=AllP{p}.Tall{eidx}.Data.Params.usetr;
            r=c;
            %plotCh{p}(c)=orderedCh(c,pp);
            if plotCh{p}(c)==0
                continue
            end
            
            pos=subplotMinGray(10,5,r,0);
            subplot('Position',pos);
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3),...
                ste(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3));
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest)+eventSamp,-2+(.3*e),'.','Color',colorcell{e},'MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color','k','LineStyle','--')

            axis tight
            text(50,4,int2str(plotCh{p}(c)))
            if c==10
                set(gca,'XTickLabel',[-.5 0 .5 1.0 1.5 2.0],'YTickLabel',-2:4,'box','off')
                xlabel('Time (s)')
                ylabel('zscore')
            else
                set(gca,'Visible','off')
            end
            

            pos=subplotMinGray(10,5,r,e);
            ca=subplot('Position',pos);
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials))',[0 5]);
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle','--')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+res*100,1:length(usetrials),'k') 
            if c==10
                set(gca,'XTickLabel',[-.5 0 .5 1.0 1.5 2.0],'YTickLabel',[],'box','off')                
                xlabel('Time (s)')
                %ylabel('Trial Num')
            else
                set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            end


            pos=subplotMinGray(10,5,r,4);
            subplot('Position',pos)        
            visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],plotCh{p}(c));
            freezeColors
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
        end
     end
     colormap(redblackwhite)
     input('n')
     clf
end
  %% PLOT STACKED NOT SMOOTHED
  %figure
  clf
  set(gcf,'Color','w')
  pat=[1 2 3 4 5 6 7 8]
  eventSamp=400
  samps=400:1200
for pp=1:6
    p=pat(pp);
    for c=1:size(plotCh{p},2)%size(orderedCh,1)
        for eidx=[2 4 5]
            e=find([2 4 5]==eidx);
            usetrials=AllP{p}.Tall{eidx}.Data.Params.usetr;
            r=c;
            %plotCh{p}(c)=orderedCh(c,pp);
            if plotCh{p}(c)==0
                continue
            end
            
            pos=subplotMinGray(10,5,r,0);
            subplot('Position',pos);
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.zscore_separate(plotCh{p}(c),samps,usetrials),3),...
                ste(AllP{p}.Tall{eidx}.Data.segmentedEcog.zscore_separate(plotCh{p}(c),samps,usetrials),3));
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest)+eventSamp,-2+(.3*e),'.','Color',colorcell{e},'MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color','k','LineStyle','--')

            axis tight
            text(50,4,int2str(plotCh{p}(c)))
            if c==10
                set(gca,'XTickLabel',[-.5 0 .5 1.0 1.5 2.0],'YTickLabel',-2:4,'box','off')
                xlabel('Time (s)')
                ylabel('zscore')
            else
                set(gca,'Visible','off')
            end
            

            pos=subplotMinGray(10,5,r,e);
            ca=subplot('Position',pos);
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.zscore_separate(plotCh{p}(c),samps,usetrials))',[0 5]);
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle','--')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+res*400,1:length(usetrials),'k') 
            if c==10
                set(gca,'XTickLabel',[-.5 0 .5 1.0 1.5 2.0],'YTickLabel',[],'box','off')                
                xlabel('Time (s)')
                %ylabel('Trial Num')
            else
                set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            end


            pos=subplotMinGray(10,5,r,4);
            subplot('Position',pos)        
            visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],plotCh{p}(c));
            freezeColors
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
        end
     end
     colormap(redblackwhite)
     input('n')
     clf
end
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
                set(gca,'XTick',0:100:400,'XTickLabel',[-2 -1 0 1 2],'YTick',-2:2:5,'YTickLabel',-2:2:5,'box','off')
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