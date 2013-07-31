wpath=[mainPath filesep 'brocaSoundFiles\'];
load([wpath filesep 'BrocaWords.mat'])
clear samps
samps{2}=[300:400];
fs =2.441406250000000e+004
%%
for n=1:length(names)
    for p=1%:8;
        curWord=names{n}; 
        eventIdx=find(strcmp(curWord,AllP{p}.Tall{2}.Data.segmentedEcog.event(:,2)));
        if ~isempty(eventIdx)
            wordLength(n)=AllP{p}.Tall{2}.Data.segmentedEcog.event{eventIdx(1),3}-AllP{p}.Tall{2}.Data.segmentedEcog.event{eventIdx(1),1};
        end
    end
end
            
         


%%
loadload
trainHold=cell(length(names),8);
%analogHold=cell(length(names),1);
%%
clear R
R=NaN(length(kGroups),length(names),8);

eidx=2
%%
%p=find(~cellfun(@isempty,{trainHold{n,:}}),1,'first');
analogHold=cell(length(names),8);
for n=1:length(names)
    for p=1%:8;
        curWord=names{n};
        if ~isempty(p)
            eventIdx=find(strcmp(curWord,AllP{p}.Tall{2}.Data.segmentedEcog.event(:,2)));
            if ~isempty(eventIdx)
                dataA=reshape(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.analog24Hz(2,round([3*fs:(4)*fs]),eventIdx(1))),1,[]);
                dataA=resample(dataA,16000,round(fs));
                tmp= wav2aud6oct(dataA);
                try
                    analogHold{n,p}=tmp(1:round(wordLength(n)*100),:);
                end
            end
        end
    end
end
    %%
for lidx=2%1:10
    lagMat=0:10:100;    
    lag=lagMat(lidx);
    for k=kGroups(:,1)'
         trainHold=cell(length(names),8);

        for n=1:length(names)
            curWord=names{n};
            for p=1:8
                eventIdx=find(strcmp(curWord,AllP{p}.Tall{2}.Data.segmentedEcog.event(:,2)));
                ch=allD.ch(vertcat(qIdxHold{k,p,:}))';
                if isempty(ch) | isempty(eventIdx)
                    continue
                end
                try
                    trainHold{n,p}=squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,[round(3*100)+1:round((3+wordLength(n))*100)]+lag,1,eventIdx(1)));
                end
             end
        end        
        %%
        clear tmp
        for n=1:length(names)-1
            useP=find(sum(~cellfun(@isempty,trainHold),1));
            useN=find(sum(~cellfun(@isempty,trainHold(:,useP)),2)==length(useP));
            %for p=useP
                p=useP;
                p1=p(1)
                if ~isempty(analogHold{n,p1}) & length(find(~cellfun(@isempty,trainHold(n,p))))==length(p)
                    testEcog=vertcat(trainHold{n,p});
                    useidx=setdiff(useN,n);
                    useidx=useidx(find(cell2mat(cellfun(@length,trainHold(setdiff(useN,n),1),'UniformOutput',0))==cell2mat(cellfun(@(x) size(x,1),analogHold(setdiff(useN,n),1),'UniformOutput',0))));
                    for p2=p
                       tmp{p2}=horzcat(trainHold{useidx,p2});
                    end
                    trainEcog=vertcat(tmp{p});
                    testAnalog=analogHold{n,p1};
                    trainAnalog=vertcat(analogHold{setdiff(useN,n),p1});
                    [g,rstim{n}] = StimuliReconstruction (trainAnalog',trainEcog',testEcog');
                    for n2=n%1:length(names)
                        try
                            R(k,n,1,n2,lidx)=corr2(rstim{n},analogHold{n2,p1}');
                        end
                    end
                end
            %end
        end
    end
end
%save('R','R','-v7.3')
%%
Rhold=R;
Rhold(find(Rhold==0))=NaN;
%%
figure(3)
clf
colormat=jet
for lidx=1:10
    for p=1
        for kIdx=1:7
            tmp2=squeeze(Rhold(kGroups(kIdx,1)',:,p,:,lidx));
            he=errorbar(kIdx,nanmean(tmp2(find(deye)),1),nansem(tmp2(find(deye)),1));
            set(he,'Color',colormat(ceil(lidx/10*length(colormat)),:))
            hold on
        end
    end
end
set(gca,'YLim',[ 0 1])
%%
prcRank=NaN(8,length(kGroups),length(names),10);
deye=eye(47,46)
for lidx=1:10
    %%
    figure(1)
    for p=1%:8
        %%
        for kIdx=1:length(kGroups)
            pos=subplotMinGray(length(kGroups),8,kIdx,p);
            subplot('position',pos)
            tmp2=squeeze(Rhold(kGroups(kIdx,1)',:,p,:,lidx));
            imagesc(tmp2,[0 1])
            Rratio(p,kIdx)=nanmean(tmp2(find(deye==1)))/nanmean(tmp2(find(deye==0)));
            for n=1:length(names)-1
                trank=tiedrank(horzcat(tmp2(n,find(deye(n,:)==1 & ~isnan(tmp2(n,:)))),tmp2(n,find(deye(n,:)==0 & ~isnan(tmp2(n,:))))));
                if ~isempty(trank)
                    prcRank(p,kIdx,n,lidx)=trank(1)/length(trank);
                end
            end        
            title(num2str( Rratio(p,kIdx)))
        end
    end
    figure(2)
    he=errorbar(1:7,squeeze(nanmean(prcRank(p,:,:,lidx),3)),squeeze(nansem(prcRank(p,:,:,lidx),3)))
    set(he,'Color',colormat(ceil(lidx/10*length(colormat)),:),'LineWidth',2)

    hold on
    %input('n')
end
%%
errorbar(1:7,squeeze(nanmean(prcRank(p,:,:),3)),squeeze(nansem(prcRank(p,:,:),3)))
hold on
errorbar(1:length(kGroups),mean(Rratio,1),nansem(Rratio,1))

