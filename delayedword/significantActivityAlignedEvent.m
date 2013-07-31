samps={[1:200],[201:400]}
for k=kGroups(:,1)'    
        for p=1:8
            ch=allD.ch(find(allD.kgroup==k & allD.p==p));
            for eidx=[2 4 5]
                ind=AllP{p}.Tall{eidx}.Data.findTrials('1','n','n');
                for cond=1:2
                    for s=1:2
                        usetr=ind.(['cond' int2str(cond)]);
                        tmp=zscore(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(ch,:,:,:),[],2);
                        baseline=tmp(:,[50:170],:,:);
                        tmp=zscore(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,:,:,:),[],2);
                        d=tmp(:,samps{s},:,usetr);
                        [H,psraw]=ttest2(squeeze(mean(d(:,:,:,:),1))',repmat(reshape(squeeze(mean(baseline(:,:,:,:),1)),1,[])',1,size(d,2)));
                        firstSig=find(H,1,'last');                       
                        holdLastSig{k,p,eidx,cond,s}=firstSig;
                        firstSig=find(H,1,'first');
                        holdSig{k,p,eidx,cond,s}=firstSig;
                        [~,maxIdx]=max(squeeze(mean(d(:,:,:,:),1)),[],1);
                        holdMax{k,p,eidx,cond,s}=maxIdx;
                        holdD{k,p,eidx,cond,s}=squeeze(mean(d(:,:,:,:),1));
                    end
                end
            end
        end
end
%% PLOT SIG VARIATION
colorcell={'r','b','g','m'}
for k=kGroups(:,1)'    
    clf
    for eidx=[2 4 5]
        e=find([2 4 5]==eidx);
        subplot(3,1,e)

        for cond=1:2
            for s=1:2
                tmp=[holdSig{k,:,eidx,cond,s}]
                h=herrorbar(mean(tmp)+samps{s}(1),cond,nansem(tmp),colorcell{s})  
                set(h,'LineWidth',3)
                hold on

                tmp=[holdMax{k,:,eidx,cond,s}]   
                h=herrorbar(median(tmp)+samps{s}(1),cond,nansem(tmp),colorcell{s+2})
                set(h,'LineWidth',3)

                tmp=[holdLastSig{k,:,eidx,cond,s}]
                h=herrorbar(mean(tmp)+samps{s}(1),cond,nansem(tmp),colorcell{s})
                set(h,'LineWidth',3)
                for p=1:8
                    plot(samps{s},mean(horzcat(holdD{k,p,eidx,cond,s}),2),'Color',colorcell{cond})
                end
                
                axis([1 400 -1 3])
            end
        end
    end
    input('b')
end
%%
clf
colorcell={'r','b','g','m'}
for k=kGroups(:,1)'    
    for eidx=[2 4 5]
        e=find([2 4 5]==eidx);
        subplot(3,1,e)

        for cond=1:2
            for s=1:2
                tmp=[holdSig{k,:,eidx,cond,s}]
                h=herrorbar(mean(tmp)+samps{s}(1),k*2+cond,nansem(tmp),colorcell{cond})  
                set(h,'LineWidth',3)
                hold on                
            end
        end
    end
    %input('b')
end
%%
clf
w=.2
colorcell={'r','b','g','m'}
for kIdx=1:length(kGroups(:,1))
    k=kGroups(kIdx,1);
    for eidx=[2 4 5]
        e=find([2 4 5]==eidx);   
        subplot(3,1,e)

        for cond=1:2
            for s=1:2
                tmp=[holdSig{k,:,eidx,cond,s}]
                %h=errorbar(kIdx*2+cond,mean(tmp)+samps{s}(1),nansem(tmp),colorcell{cond})  
                p=patch([mean(tmp)+samps{s}(1)-nansem(tmp) mean(tmp)+samps{s}(2)+nansem(tmp)...
                     mean(tmp)+samps{s}(2)+nansem(tmp) mean(tmp)+samps{s}(1)-nansem(tmp)],...
                    [ (length(kGroups)-kIdx)*2+cond/2+w (length(kGroups)-kIdx)*2+cond/2+w ...
                    (length(kGroups)-kIdx)*2+cond/2-w  (length(kGroups)-kIdx)*2+cond/2-w ],colorcell{cond})
                %set(h,'LineWidth',3)
                set(p,'EdgeColor','none')
                %set(p,'FaceAlpha',1-(nansem(tmp)./30))
                hold on         
                axis tight
                axis([1 300 0 14])
            end
        end
    end
    %input('b')
end
