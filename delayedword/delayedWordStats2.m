load E:\DelayWord\CompareEvsH\wordTypeResponse
load E:\DelayWord\ERPPlots\ERpSites.mat
gGrouped={[3 4],[5 6]}
gGrouped={[1 2],[3:6]};
for p=1:8
    %figure(p)
    clf
    idx=find([erpSites{:,1}]==p);
    for i=1:length(idx)
        for eidx=[2 5]
            r=erpSites{idx(i),2};  
            e=find([2 5]==eidx);            
            pos=subplotMinGray(10,6,i,e);
            subplot('Position',pos);
            for g1=1:length(gGrouped)
                g=gGrouped{g1};
                dHold2{g1}=cat(4,wordTypeResponse(p,eidx).group(g).data);  
                baseline{g1}=cat(4,wordTypeResponse(p,2).group(g).data);
                [ps_raw{g1},bse{g1},base_boot_means{g1}]=singleConditionStats(squeeze(dHold2{g1}(r,:,:,:))',...
                    reshape(squeeze(baseline{g1}(r,50:150,:,:))',1,[]),1:400)
                try
                    %plot(mean(squeeze(dHold2{g1}(r,:,:,:))'),'Color',colormat(ceil(64/6*g(1)),:,:))
                end
                hold on
                ps_raw{g1}=MT_FDR_PRDS(ps_raw{g1},.05);
                try
                    %plot(find(ps_raw{g1}<.05),-.5+g1/5,'.','Color',colormat(ceil(64/6*g(1)),:,:))
                end
                holdPval{p,eidx,r,g1}=ps_raw{g1};
            end
            [psCompare]=twoConditionStats(squeeze(dHold2{1}(r,:,:,:))',squeeze(dHold2{2}(r,:,:,:))',1:400,ps_raw{1},ps_raw{2},200,200)
             psCompare=MT_FDR_PRDS(psCompare,.05);
             holdPval{p,eidx,r,3}=psCompare;

             try
                %plot(find(psCompare<.05 & ~isnan(psCompare)),-1,'k.')
             end
        end
    end
    %input('n')
    %clc
end
%% PLOT PVAL

for p=p:8
    %figure(p)
    clf
    idx=find([erpSites{:,1}]==p);
    for i=1:length(idx)
        for eidx=[2 5]
            r=erpSites{idx(i),2};  
            e=find([2 5]==eidx);            
            pos=subplotMinGray(10,6,i,e);
            subplot('Position',pos);
            for g1=1:length(gGrouped)
                g=gGrouped{g1};
                dHold2{g1}=cat(4,wordTypeResponse(p,eidx).group(g).data);  
                baseline{g1}=cat(4,wordTypeResponse(p,2).group(g).data);               
                try
                    plot(mean(squeeze(dHold2{g1}(r,:,:,:))'),'Color',colormat(ceil(64/6*g(1)),:,:))
                end
                hold on
                ps_raw{g1}=holdPval{p,eidx,r,g1};
                try
                    plot(find(ps_raw{g1}<.05),-.5+g1/5,'.','Color',colormat(ceil(64/6*g(1)),:,:))
                end
                holdPval{p,eidx,r,g1}=ps_raw{g1};
            end           
             psCompare=holdPval{p,eidx,r,3};
             try
                plot(find(psCompare<.05 & ~isnan(psCompare)),-1,'k.')
                
             end
        end
    end
    input('n')
    clc
end