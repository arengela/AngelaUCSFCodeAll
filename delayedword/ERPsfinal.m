p=5
display(p).ch{1}=[2 3 19 37 51 65 66 67 52]
display(p).ch{2}=[85 86 69 68 101]
display(p).ch{3}=[166 150 134 119 135 164 182 180]
display(p).ch{4}=[245 229 244 229 226 214 213 198 197 181 180]
display(p).ch{5}=[188 172]
display(p).ch{6}=[95 112 96 109 125 ]
display(p).ch{7}=[155]
display(p).ch{8}=[184 183 159 158 153 152 151 137 136 135 108 107]
display(p).ch{9}=[77 61 60 59 76 75 74 73 72 91 90 89 88 106 105 120]
display(p).ch{10}=[11]

p=3
display(p).ch{1}=[98 130 146 98 115]
display(p).ch{2}=[181 180 179 165 164 163 149 148 17 132 131]
display(p).ch{3}=[]
display(p).ch{4}=[230 214]
display(p).ch{5}=[239 237 222 221]
display(p).ch{6}=[29 28 27 13 12 11 ]
display(p).ch{7}=[140 139 138 105]
display(p).ch{8}=[]
display(p).ch{9}=[15 57 41 40 24 ]
display(p).ch{10}=[84]

p=1
display(p).ch{1}=[102 119 103 86 87 85 69 53 113]
display(p).ch{2}=[104 88 105 71 135 162 169 170 185 184 ]
display(p).ch{3}=[]
display(p).ch{4}=[250 249 248 233 232 234 216 231 200 201 199 229]
display(p).ch{5}=[]
display(p).ch{6}=[]
display(p).ch{7}=[256 255 239 223 238 254 253 237 236 235 252 251]
display(p).ch{8}=[60]
display(p).ch{9}=[111 110 109 125 126 141 140 155 112 111 110 109 105]
display(p).ch{10}=[84]

p=2
display(p).ch{1}=[95 88 87 96]
display(p).ch{2}=[32 24 81 89 90 91 92 93 94 86 ]
display(p).ch{3}=[36 33 27]
display(p).ch{4}=[]
display(p).ch{5}=[]
display(p).ch{6}=[]
display(p).ch{7}=[63 64]
display(p).ch{8}=[62 55 48 105 52 38 40]
display(p).ch{9}=[]
display(p).ch{10}=[106 107 108 116 123]

p=4
display(p).ch{1}=[]
display(p).ch{2}=[167 166 151 150 149 133 134 135 119 118 117 101 102 103 85 86 87]
display(p).ch{3}=[]
display(p).ch{4}=[214 215]
display(p).ch{5}=[]
display(p).ch{6}=[62 63 64]
display(p).ch{7}=[]
display(p).ch{8}=[156 155 171 154 170 169 61 60 76 77 78 93 92 75 91]
display(p).ch{9}=[]
display(p).ch{10}=[]
display(p).ch{11}=[ 21 66 50 31 18 82 81 97 113 ]

p=6
display(p).ch{1}=[52 53 34]
display(p).ch{2}=[57 103 102 101 85 133 134 151 167 183 182 198 199 150]
display(p).ch{3}=[]
display(p).ch{4}=[214 230 246 197 181]
display(p).ch{5}=[]
display(p).ch{6}=[]
display(p).ch{7}=[251 235 234 233 217 ]
display(p).ch{8}=[112 86 95 84 111 110 109 93 109 108 107 123 125 126 106 90 77 93 78]
display(p).ch{9}=[]
display(p).ch{10}=[]
display(p).ch{11}=[22 67 100 ]

p=7
display(p).ch{1}=[119 37 20]
display(p).ch{2}=[102 118 159 149 148 181 180 197 213 ]
display(p).ch{3}=[]
display(p).ch{4}=[228 244 229]
display(p).ch{5}=[222]
display(p).ch{6}=[112 160 144 111 159 175 174 176]
display(p).ch{7}=[247 248]
display(p).ch{8}=[112 95 110 126 109 124 140 141 139 155 172 173 187 186 ]
display(p).ch{9}=[]
display(p).ch{10}=[40 39]
display(p).ch{11}=[184 168 185]

p=8
display(p).ch{1}=[36 37 34 70 87 103 102 71]
display(p).ch{2}=[136 135 168 169 186 170 138 137 169 186 187 185 ]
display(p).ch{3}=[]
display(p).ch{4}=[251 235 252 219 218 203]
display(p).ch{5}=[]
display(p).ch{6}=[]
display(p).ch{7}=[191 175]
display(p).ch{8}=[]
display(p).ch{9}=[192 175 160 ]
display(p).ch{10}=[40 140 124]
display(p).ch{11}=[33]
%%
allD.q=[]
for p=1:8
    q=getBrainQuadrant(BrainCoord(p).xySF,BrainCoord(p).xyCS,BrainCoord(p).xy)';
    allD.q=vertcat(allD.q,q);
end
%%


for kIdx=1:length(kGroups)
    k=kGroups(kIdx,1);
    for p=1:8
        idx= vertcat(qIdxHold{k,p,:});
        try
            R=corr(allD.data(idx,:)',(mean(allD.data(idx,:))'))
            [~,tmp]=sort(R,'descend');
            idx=idx(tmp);
        end
        display(p).ch{kIdx}=allD.ch(idx);
    end
end

%% ALIGNED BY PERC AND PROD
load E:\DelayWord\CompareEvsH\holdPval_SL.mat
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\basic\blueblackwhite')

clf
set(gcf,'Color','w')
samps=1:900;
eventSamp=200;
colorcell={'red','blue','green'};
eventSamp=200;
set(gcf,'Color','w')
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
eventSamp=200
sigPos=[-.6 -.9]
fontsize=8;
rows=length(kGroups);
for p=1:8
    clf
    for i=1:rows
        for eidx=2
            e=find([2 5]==eidx);
            AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
            %%
            for j=1:3%length(display(p).ch{i}):-1:1
                if j>length(display(p).ch{i})
                    continue
                end
                ch=display(p).ch{i}(j);
                
                %SHOW BRAIN
                pos=subplotMinGray(rows,9,i,0);
                pos(1)=pos(1)-.02
                pos(3)=pos(3)*1;
                pos(4)=pos(4)*1;
                subplot('Position',pos);
                if j==1%length(display(p).ch{i})
                    flag=1;
                else
                    flag=0;
                end
                try
                    if j==1
                        a=imread(['E:\DelayWord\allBrainPics\' 'EC16' 'scaled.jpg']);
                        imshow(a)
                        hold on
                    end
                    scatter(BrainCoord(p).newXY(1,ch),BrainCoord(p).newXY(2,ch),25,rgb(colorcell{j}),'fill')
                    
                catch
                    colorcell{j}='black';
                end
                axis([0 1000 10 620])
                set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
                
                
                %GET DATA
                badtr=unique([find(cellfun(@isnan,AllP{p}.Tall{2}.Data.segmentedEcog(1).event(:,15)))']);
                usetrials1=setdiff(1:size(AllP{p}.Tall{2}.Data.segmentedEcog.event,1),[AllP{p}.Tall{2}.Data.Artifacts.badTrials badtr]);%AllP{p}.Tall{eidx}.Data.Params.usetr;
                [s,sidx]=sort(cell2mat(AllP{p}.Tall{2}.Data.segmentedEcog(1).event(usetrials1,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials1,7)));
                usetrials1=usetrials1(sidx);
                %usetrials1=fliplr(usetrials1);
                data=squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,:,:,usetrials1));
                data1=data(1:400,:);
                
                badtr=unique([find(cellfun(@isnan,AllP{p}.Tall{5}.Data.segmentedEcog(1).event(:,15)))'])
                usetrials2=setdiff(1:size(AllP{p}.Tall{5}.Data.segmentedEcog.event,1),[AllP{p}.Tall{5}.Data.Artifacts.badTrials badtr]);%AllP{p}.Tall{eidx}.Data.Params.usetr;                [s,sidx]=sort(cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog(1).event(usetrials,7)));
                [s,sidx]=sort(cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog(1).event(usetrials2,9))...
                    - cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog(1).event(usetrials2,7)));
                usetrials2=usetrials2(sidx);
                %usetrials2=fliplr(usetrials2);
                data2=squeeze(AllP{p}.Tall{5}.Data.segmentedEcog(1).smoothed100(ch,1:400,:,usetrials2));
                
                
                %PLOT AVE PRES
                pos=subplotMinGray(rows,9,i,e);
                pos(3)=pos(3)*2;
                pos(4)=pos(4)*.9;
                pos(1)=pos(1)-.025;
                subplot('position',pos);
                try
                    plot(mean(data1,2),'Color',rgb(colorcell{j}),'LineWidth',2)
                catch
                    plot(mean(data1,2),'Color','k','LineWidth',2)
                end

                hold on
                [~,pval]=ttest2(data1',repmat(reshape(data1(70:150,:),[],1),[1,size(data1,1)]'),0.01,'Right');
                [pval,sig]=MT_FDR_PRDS(pval,0.01);
                try
                    plot(find(sig),6+j*.5,'.','Color',rgb(colorcell{j}),'LineWidth',3,'MarkerSize',3)
                end
                
                
                res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials1,col{2}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials1,col{2}(1)));
                res(find(res<=0))=NaN;
                
                hold on
                plot(repmat(eventSamp+nanmean(res)*100,[1 10]) ,[-1:8],'k','LineWidth',2)
                
                
                
                axis([0 400 -1 8])
                hl=line([eventSamp eventSamp],[-1 8]);
                set(hl,'Color','k','LineWidth',2,'LineStyle','--')
                set(gca,'XTick',0:100:400,'XTickLabel',-2:1:2,'FontSize',fontsize)
                ylabel('Zscore')
                if i==9
                    xlabel('Time (s) around Presentation Onset')
                end
                set(gca,'XGrid','on','YGrid','on')
                
                
                %PLOT STACK PRES
                pos=subplotMinGray(rows,18,i,j*2+6)
                pos(4)=pos(4)*.9;
                pos(3)=pos(3)*1.3;
                pos(1)=pos(1)-.04;
                subplot('position',pos);

                %pcolor((data1'));
                %shading interp
                imagesc(data1')
                set(gca,'clim',[0 3])
                hl=line([eventSamp eventSamp],[1 length(usetrials1)]);
                set(hl,'Color','k','LineWidth',2,'LineStyle','--')
                res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials1,col{2}(2)))...
                    -cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials1,col{2}(1)));
                res(find(res<=0))=NaN;
                hold on
                plot(eventSamp+(res)*100,1:length(usetrials1),'k','LineWidth',2)
                set(gca,'XTick',0:100:400,'XTickLabel',-2:1:2,'FontSize',fontsize)
                if i~=rows
                    set(gca,'XTickLabel',[]);
                end
                set(gca,'YTickLabel',[])
                if j==1
                    ylabel('Sorted Trials')
                end
                
                
                %PLOT AVE PROD
                pos=subplotMinGray(rows,9,i,3);
                pos(1)=pos(1)-.02;
                pos(3)=pos(3)*2;
                pos(4)=pos(4)*.9;
                pos(1)=pos(1)-.040;

                subplot('position',pos);
                %%[hl,hp]=errorarea(mean(data2,2),nansem(data2,2))
                %set(hl,'Color',colorcell{j})
                %set(hp,'FaceColor',colorcell{j})
                try
                    plot(mean(data2,2),'Color',rgb(colorcell{j}),'LineWidth',2,'LineWidth',2)
                catch
                    plot(mean(data2,2),'Color','k','LineWidth',2)
                end

                hold on
                
                [~,pval]=ttest2(data2',repmat(reshape(data1(70:150,:),[],1),[1,size(data2,1)]'),0.01,'Right');
                [pval,sig]=MT_FDR_PRDS(pval,0.01);
                try
                    plot(find(sig),6+j*.5,'.','Color',rgb(colorcell{j}),'LineWidth',3,'MarkerSize',3)
                    hold on
                    hl=line([eventSamp eventSamp],[-1 8]);
                end
                res=cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog.event(usetrials2,col{5}(2)-2))...
                    -cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog.event(usetrials2,col{5}(1)-2));
                res(find(res<=0))=NaN;
                hold on
                plot(repmat(eventSamp-nanmean(res)*100,[1 10]) ,[-1:8],'k','LineWidth',2)
                
                
                res=cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog.event(usetrials2,col{5}(2)))...
                    -cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog.event(usetrials2,col{5}(1)));
                res(find(res<=0))=NaN;
                hold on
                plot(repmat(eventSamp+nanmean(res)*100,[1 10]) ,[-1:8],'k','LineWidth',2)
                
                set(hl,'Color','k','LineWidth',2,'LineWidth',2,'LineStyle','--')
                axis([0 400 -1 8])
                set(gca,'XTick',0:100:400,'XTickLabel',-2:1:2,'FontSize',fontsize)
                set(gca,'YTickLabel',[])
                if i==9
                    xlabel('Time (s) around Production Onset')
                end
                set(gca,'XGrid','on','YGrid','on')
                
                
                
                
                
                %PLOT STACK PROD
                pos=subplotMinGray(rows,18,i,j*2+7)
                pos(1)=pos(1)-.017;
                pos(4)=pos(4)*.9;
                pos(1)=pos(1)-.025;
                pos(3)=pos(3)*1.25;

                subplot('position',pos);
                %pcolor((data2'))
                %shading interp
                imagesc(data2')
                
                set(gca,'clim',[0 3])
                hl=line([eventSamp eventSamp],[1 length(usetrials2)]);
                set(hl,'Color','k','LineWidth',2,'LineStyle','--')
                res=cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog.event(usetrials2,col{5}(2)))...
                    -cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog.event(usetrials2,col{5}(1)));
                res(find(res<=0))=NaN;
                hold on
                plot(eventSamp+(res)*100,1:length(usetrials2),'k','LineWidth',2)
                
                res=cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog.event(usetrials2,col{5}(2)-2))...
                    -cell2mat(AllP{p}.Tall{5}.Data.segmentedEcog.event(usetrials2,col{5}(1)-2));
                res(find(res<=0))=NaN;
                hold on
                plot(eventSamp-(res)*100,1:length(usetrials2),'k','LineWidth',1,'Color','k','LineStyle','-')
                
                set(gca,'XTick',0:100:400,'XTickLabel',-2:1:2,'FontSize',fontsize)
                set(gca,'YTickLabel',[])
                if i~=rows
                    set(gca,'XTickLabel',[]);
                end
                
                if eidx==2
                    colormap(redblackwhite)
                else
                    colormap(blueblackwhite)
                end
                freezeColors
            end
            
        end
    end
    %%
    set(gcf,'Renderer','painters','PaperPositionMode','auto','PaperUnits','default')
    %set(gcf,'handlevisibility','off')
    filename=['C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\ERPs\Figv3_s' int2str(p)]
    
    exportfig(gcf,filename,'Color','rgb','FontMode','scaled','preview','tiff','SeparateText',1,'height',8);
    %print([filename],'-depsc')
    %eval(['export_fig ' [filename '.pdf'] ' -opengl'])
    %input('n')
end
