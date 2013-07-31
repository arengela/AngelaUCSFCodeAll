for p=1:8
    for eidx=[2 4 5]
        usetr=setdiff(1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.event,1),AllP{p}.Tall{eidx}.Data.Artifacts.badTrials);
        trialHold(p,eidx,:)=ismember(names,AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetr,8));
    end
end
%%
for p=1:8
    for eidx=[2 4 5]
        useP=unique(allD.p(vertcat(qIdxHold{kGroups(:,1)',:,:})))'
        useNames=names(find(ismember(sum(squeeze(trialHold(useP,eidx,:)),1),length(useP))))
        badIdx=find(~ismember(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,8),useNames))    
        AllP{p}.Tall{eidx}.Data.segmentedEcog.event(badIdx,:)={NaN};
    end
end
%%
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\brocawords')
for n=1:length(names)
    idx=find(strcmp(names{n},{brocawords.names}))
    if isempty(idx)
        continue
    end
    if strmatch(brocawords(idx).lengthtype,'short') & strmatch(brocawords(idx).difficulty,'easy') ...
            & brocawords(idx).logfreq_HAL>9
        wordCond(n)=1;
    elseif strmatch(brocawords(idx).lengthtype,'short') & strmatch(brocawords(idx).difficulty,'easy') ...
            & brocawords(idx).logfreq_HAL<9
        wordCond(n)=2;
        
    elseif strmatch(brocawords(idx).lengthtype,'long') & strmatch(brocawords(idx).difficulty,'easy') ...
            & brocawords(idx).logfreq_HAL>9
        wordCond(n)=3;
        
    elseif strmatch(brocawords(idx).lengthtype,'long') & strmatch(brocawords(idx).difficulty,'easy') ...
            & brocawords(idx).logfreq_HAL<9
        wordCond(n)=4;
        
    elseif strmatch(brocawords(idx).lengthtype,'long') & strmatch(brocawords(idx).difficulty,'hard') ...
            & brocawords(idx).logfreq_HAL>9
        wordCond(n)=5;
        
    elseif strmatch(brocawords(idx).lengthtype,'long') & strmatch(brocawords(idx).difficulty,'hard') ...
            & brocawords(idx).logfreq_HAL<9
        wordCond(n)=6;
    end
end

%%
% sampCell{1}=[100:200]
% sampCell{2}=[200:300]
% sampCell{3}=[300:400]
% sampCell{4}=[400:500]
% sampCell{5}=[500:600]
% sampCell{6}=[500:600]
% sampCell{7}=[100:600]

clear sampCell
for i=1:10
    sampCell{i}=[(i-1)*50+100:(i)*50+100]
end
col{2}=2
col{4}=8
col{5}=8
for eidx=[2 4 5]
    %%
    e=find([2 4 5]==eidx);
    for s=1:length(sampCell)
        %%
        for kIdx=1:length(kGroups(:,1))
            %%
            k=kGroups(kIdx,1)
            clear X
            clear A
            clear trainHold
            for n=1:length(names)
                curWord=names{n};
                for p=1:8
                    eventIdx=find(strcmp(curWord,AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,col{eidx})));
                    eventIdx=setdiff(eventIdx,AllP{p}.Tall{eidx}.Data.Artifacts.badTrials)
                    ch=allD.ch(vertcat(qIdxHold{k,p,:}))';
                    if isempty(ch) | isempty(eventIdx)
                        continue
                    end
                    trainHold{n,p}=squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,sampCell{s},1,eventIdx),4));
                end
            end
            
            
            useP=find(sum(~cellfun(@isempty,trainHold),1));
            useN=find(sum(~cellfun(@isempty,trainHold(:,useP)),2)==length(useP))
            for n=useN'
                X{n}=reshape(mean(vertcat(trainHold{n,useP}),1),1,[]);
                A{n}=mean(horzcat(analogHold{n,useP}),2);

            end
            X2=vertcat(X{:});
            %A2=horzcat(A{:})';

            %[COEFF,SCORE,latent] = princomp(X2);
            clear condHold
            
            %close all
            for pc=1%:20
                condHold=[];
                clear projHold
                for i=1:6
                    cond{i}=find(wordCond(useN)==i);
                    %projHold{i}=mean(X2(cond{i},:),1).*COEFF(:,pc)';
                    %projHold{i}=X2(cond{i},:).*repmat(COEFF(:,pc)',length(cond{i}),1);
                    projHold{i}=X2(cond{i},:);
                    condHold=[condHold ones(length(cond{i}),1)'*i];
                    %plot(projHold{i})
                    hold on
                end
                try
                    for g=1%:3
                        switch g
                            case 1
                                cidx1=find(ismember(condHold,[1 2]));
                                cidx2=find(ismember(condHold,[3:4]));
                                
                            case 2
                                cidx1=find(ismember(condHold,[3 4]));
                                cidx2=find(ismember(condHold,[5 6]));
                            case 3
                                cidx1=find(ismember(condHold,[4 6]));
                                cidx2=find(ismember(condHold,[3 5]));
                        end
                        condHold1(cidx1)=1;
                        condHold1(cidx2)=2;


                        %condHold2(cidx1)=1
                        %condHold2(cidx2)=2
                        useidx=[cidx1 cidx2];
                        
                        %figure(g)
                        all_data=vertcat(projHold{:});
                        all_data2=all_data(useidx,:);
                        condHold2=condHold1(useidx);
                        %all_data=vertcat(projHold{unique(condHold([cidx1 cidx2]))});
                        %coord=mdscale(squareform(pdist(all_data2)),2);
                        %gscatter3(coord(:,1),coord(:,2),coord(:,3),condHold,[],[],20)
                        %subplot(4,5,pc)
                        %scatter(coord(:,1),coord(:,2),15,colormat(ceil((condHold2./2).*length(colormat)),:),'fill')
                        
                        figure(g)
                        pos=subPlotMinGray(7,3,kIdx,e-1);
                        subplot('Position',pos)
                        %subplot(2,1,1)
                        errorarea(mean(all_data2(condHold2==1,:),1),nansem(all_data2(condHold2==1,:),1))
                        hold on
                        [hl,hp]=errorarea(mean(all_data2(condHold2==2,:),1),nansem(all_data2(condHold2==2,:),1));
                        set(hl,'Color','r');set(hp,'FaceColor','r')
                         title(num2str([s kIdx g eidx]))
                         
                         %subplot(2,1,2)
                         %imagesc(all_data2)

                        
                         for rep=1:10
                             %rep=1
                             cidx1=cidx1(randperm(length(cidx1)));
                             cidx2=cidx2(randperm(length(cidx2)));
                             minCount=min([length(cidx1) length(cidx2)]);
                             useIdx=[cidx1(1:minCount) cidx2(1:minCount)];
                             all_label=condHold1(useIdx);
                             all_data2=all_data(useIdx,:);
                             
                             subplot(2,1,1)
                             errorarea(mean(all_data2(all_label==1,:),1),nansem(all_data2(all_label==1,:),1))
                             hold on
                             [hl,hp]=errorarea(mean(all_data2(all_label==2,:),1),nansem(all_data2(all_label==2,:),1));
                             set(hl,'Color','r');set(hp,'FaceColor','r')
                             
                             
                             
                             permute_trials=randperm(length(all_label));
                             usepart=round(.7*length(permute_trials));
                             testpart=length(permute_trials)-usepart;
                             train_trials=permute_trials(1:usepart);
                             test_trials=permute_trials(usepart+1:end);
                             train_data=all_data2(train_trials,:);
                             train_label=all_label(train_trials)';
                             test_data=all_data2(test_trials,:);
                             test_label=all_label(test_trials)';
                             for kernel=1%:4
                                 [bestc, bestg, bestcv, model, predicted_label, accuracy, decision_values] = svm(train_data, train_label,test_data, test_label,kernel-1);
                                 acc(kIdx,pc,g,rep,s,eidx,kernel)=accuracy(1);
                             end
                    
                             
                         end
                        %input('b')
                        %clf
                    end
                    
                end
                %input('b')
            end
            
            %input('b')
        end
    end
end
cd('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup')
save('acc_avech','acc')
%% SVM
a=1
colorcell={'r','b','g'}

for kIdx=1:7
    for eidx=[2 4 5 ]
        e=find([2 4 5]==eidx);
        subplot(3,1,e)
        for g=1:3
           tmp=squeeze(acc(kIdx,pc,g,1:10,1:10,eidx,a));
            he=errorbar(1:10,nanmean(tmp,1),nansem(tmp,1));
            set(he,'Color',colorcell{g},'LineWidth',3);
            hold on
            set(gca,'YLim',[0 100])
        end
        line([0 10],[50 50])
        line([4 4],[0 100])
        
        line([0 10],[80 80])
        
        title(num2str([eidx kIdx]))
        legend({'sl','ed','fi'})
    end
    input('v')
    clf
end
%%
a=1
colorcell={'r','b','g'}
for g=1:3
    for kIdx=1:7
        for eidx=[2 4 5]
            e=find([2 4 5]==eidx);
            subplot(3,1,e)
            tmp=squeeze(acc(kIdx,pc,g,1:10,1:10,eidx,a));
            he=errorbar(1:10,nanmean(tmp,1),nansem(tmp,1));
            set(he,'Color',colormat(ceil(kIdx/7*length(colormat)),:),'LineWidth',3);
            hold on
            set(gca,'YLim',[0 100])
            if kIdx==7
                line([0 10],[50 50])
                line([4 4],[0 100])
                  line([0 10],[80 80])
                
            end
      
        
        end
        legend({'1','2','3','4','5','6','7'})
        
        title(num2str([g eidx kIdx]))
    end
    input('v')
    clf
end