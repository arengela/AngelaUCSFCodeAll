clear d
clf
for eidx=[2 4]
    for k=kGroups(:,1)'
        kIdx=find(kGroups(:,1)'==k);

        for p=[1 5 6]
            if p==1
                p2=9
            elseif p==5
                p2=10
            elseif p==6
                p2=11;
            end
            
            tmp=squeeze(qIdxHold(k,p,[1:4]));
            ch=allD.ch(vertcat(tmp{:})');
            ind=AllP{p}.Tall{eidx}.Data.findTrials('1','n','n');
            ind2=AllP{p}.Tall{eidx}.Data.findTrials('2','y','n');
            ind.cond2=setdiff(ind.cond2,ind2.cond2);
                
            ind(2)=AllP{p2}.Tall{eidx}.Data.findTrials('1','n','n');
             ind2=AllP{p2}.Tall{eidx}.Data.findTrials('2','y','n');
            ind(2).cond2=setdiff(ind(2).cond2,ind2.cond2);
            
            d(p,1).cond1=squeeze(mean(nanmean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,:,:,ind(1).cond1),4),1));
            d(p,1).cond2=squeeze(mean(nanmean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,:,:,ind(1).cond2),4),1));
            d(p,2).cond1=squeeze(mean(nanmean(AllP{p2}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,:,:,ind(2).cond1),4),1));
            d(p,2).cond2=squeeze(mean(nanmean(AllP{p2}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,:,:,ind(2).cond2),4),1));
            
            if eidx==2 & p==1
                  pos=subplotMinGray(size(kGroups,1) ,2,kIdx,1);
    pos(1)=pos(1)+.25;
    pos(2)=pos(2)+.01
    pos(3)=pos(3)*.7
                
                 
                 ha=axes('Position',pos)
                a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
                imshow(repmat(a,[1 1 3]))
                hold on
                
            end
           color=colorjet(findNearest(floor((p-1)*length(colorjet)/(8-1)),1:length(colorjet)),:);

            plotManyPolygons(BrainCoord(p).newXY(:,ch)',100,color,.7,12)


        end
        e=find([2 4]==eidx);
        
          pos=subplotMinGray(size(kGroups,1) ,4,kIdx,e-1);
       % pos(4)=pos(4)*.2;
        pos(2)=pos(2)+.02;
        pos(1)=pos(1)*1.55+.03
        pos(3)=pos(3)*1.5;
        
                axes('Position',pos)

        %subplot('Position',pos)
        dMat=vertcat(d([1 5 6],1).cond1);
        
        [hl,hp]=errorarea(smooth(median(dMat,1),15),smooth(nansem(dMat,1),15))
        set(hl,'Color',rgb('darkred'),'LineWidth',2)
        set(hp,'FaceColor',rgb('darkred'))
        
        hold on
                dMat=vertcat(d([1 5 6],1).cond2);

         [hl,hp]=errorarea(smooth(median(dMat,1),15),smooth(nansem(dMat,1),15))
        set(hl,'Color',rgb('darkblue'),'LineWidth',2)
        set(hp,'FaceColor',rgb('darkblue'))
        
                dMat=vertcat(d([1 5 6],2).cond1);

         [hl,hp]=errorarea(smooth(median(dMat,1),15),smooth(nansem(dMat,1),15))
        set(hl,'Color',rgb('magenta'),'LineWidth',2)
        set(hp,'FaceColor',rgb('magenta'))
        
                dMat=vertcat(d([1 5 6],2).cond2);

         [hl,hp]=errorarea(smooth(median(dMat,1),15),smooth(nansem(dMat,1),15))
        set(hl,'Color',rgb('blue'),'LineWidth',2)
        set(hp,'FaceColor',rgb('blue'))
        title(num2str([eidx find(kGroups(:,1)==k)]))
        set(gca,'YLim',[-1 3],'XTickLabel',[-3 -2 -1 0 1 2 3])
        
        
        hl=line([100 100],[-1 5]);
        set(hl,'Color','k','LineStyle','--')

        hl=line([300 300],[-1 5]);
        set(hl,'Color','k','LineStyle','--')
        
        if eidx==2
            axis([90 600 -1 3])
        else
            axis([1 500 -1 3])
        end

        
       
    end    
end
