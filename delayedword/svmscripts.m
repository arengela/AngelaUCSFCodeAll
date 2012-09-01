n=12
event=5;
T=PLVtests(n,event,[])
test=T.Data

load('E:\DelayWord\wordgroups')
load('E:\DelayWord\brocawords')
%% Make data matrix
%clear accall
for cidx=1:test.channelsTot
    %%
    %cidx=2:test.channelsTot    
    for eidx=1%:3    
        usesets={800:1400 600:650 650:700 700:750 750:800 800:850 850:900 900:950 950:1000 1050:1100 1150:1200 1200:1250 1250:1300 1300:1350 1350:1400 1400:1450 1450:1500}
        %usesets={1300:1400  1300:1350 1350:1400}
        for u=1:length(usesets)
            %%
            clear all_data all_data1 d d2 d3 d4
            usesamps=usesets{u};
            for t=1:size(test.segmentedEcog(eidx).data,4)
                d0=mean(test.segmentedEcog(eidx).zscore_separate(:,usesamps,:,t),3);
                %d0=mean(test.segmentedEcog(eidx).analog(1,usesamps,:,t),3);
                %dataA=squeeze(test.segmentedEcog(eidx).analog24Hz(2,usesamps,:,t));
                %dataA=resample(dataA,16000,round(fs));
                %tmp= wav2aud6oct(dataA)';
                %d=mean(d,2);
                %imagesc(d)
                %input('n')
                %d=mean(d,1);
                for didx=1:size(d0,1)
                    d3(didx,:)=smooth(d0(didx,:));
                    %d3(didx,:)=d0(didx,:);

                    %d3(didx,:)=smooth(abs(hilbert(d0(didx,:))));
                    %tmp=dct(d3(didx,:));
                    %d2(didx,1:3)=tmp(1:3);
                end
                %d4=(d3(areamap(2).event(event).allactive,:));
                %[PC,S,L]=princomp(d3');

                %d4(:,:,t)=d3;
                %d=reshape(S(:,1:50)',1,[]);
                %diffD=reshape(diff(S(:,1:50)'),1,[]);
                d=reshape(d3,1,[]);
                all_data(t,:)=[d];
            end
            % Select labels
            clear all_label1 all_label2 all_label
            Labels=test.segmentedEcog(eidx).event(:,8)

            all_label=zeros(length(Labels),1);
            for i=1:length(Labels)
                try
                    wordidx=find(strcmp(Labels{i},{brocawords.names}));
                    all_label1(i)=find(strcmp({'','','','short','long'},brocawords(wordidx).lengthtype));
                    all_label2(i)=find(strcmp({'easy','','hard'},brocawords(wordidx).difficulty));
                    all_label3(i)=brocawords(wordidx).logfreq_HAL;
                    %all_label(i)=wordidx;
                catch
                    wordidx=NaN
                    all_label(i)=wordidx;
                end
            end
            %select only long words
            %useidx=find(all_label1==5)%only long words
            useidx=1:length(all_label1);%all words
            all_label1=all_label1(useidx);
            all_label2=all_label2(useidx);
            all_label3=all_label3(useidx);
            all_label=all_label1;
            all_data=all_data(useidx,:);

%             all_label(find(all_label3<8))=1;%frequent vs less frequent
%             all_label(find(all_label3>9))=2;

            count=20
            cont=0
            conditions=[4 5];
            while cont==0
                useidx=[find(all_label==conditions(1),count)  find(all_label==conditions(2),count)]%get 50/50 in training/test sets
                if length(find(all_label(useidx)==conditions(1)))==count & length(find(all_label(useidx)==conditions(2)))==count
                    cont=1;
                else 
                    count=count-1;
                end
            end
            all_label=all_label(useidx);
            all_data=all_data(useidx,:);

            %all_label=all_label1+all_label2
            % labels== freq

            %subplot(2,8,u)
            %imagesc(all_data)

            %imagesc(squareform(pdist(all_data)))
            %title(sprintf('ch %i time %i %i event %i',ch2(cidx),usesets{u}([1,end]),eidx))
            
            
            % Randomly select trials to test and perform SVM
            clear acc
            for n=1:10
                permute_trials=randperm(length(all_label));
                usepart=round(.75*length(all_label));
                testpart=length(all_label)-usepart;
                train_trials=permute_trials(1:usepart);
                test_trials=permute_trials(usepart+1:end);
                train_data=all_data(train_trials,:);
                train_label=all_label(train_trials)';
                test_data=all_data(test_trials,:);
                test_label=all_label(test_trials)';
                [bestc, bestg, bestcv, model, predicted_label, accuracy, decision_values] = svm(train_data, train_label,test_data, test_label);
                acc(n)=accuracy(1)
            end
            accall(eidx).(['s' int2str(usesets{u}(1)) 'to' int2str(usesets{u}(end))])=acc;
            svmOut(cidx).accall=accall;
            %hist(acc)
            %xlabel([int2str(mean(acc)) '+/-' int2str(std(acc))])
        end
        %input('n')
    end    
end
% dest=(['E:\DelayWord\EC23\EC23_B1\SVMout\event' ])
% mkdir(dest)
% cd(dest)
% save('accall_motor_aud_shortlong','accall')
%%

for c=70:test.channelsTot
    
    figure(1)
    clf
    accall=svmOut(c).accall;
    for eidx=1:3
        fieldname=fieldnames(accall)
        for u=1:length(usesets)
            a=getfield(accall(eidx),['s' int2str(usesets{u}(1)) 'to' int2str(usesets{u}(end))]);
            subplot(3,length(fieldname),(eidx-1)*length(fieldname)+u)
            if mean(a)>60
                hist(a)
                if eidx==1
                    title(int2str([usesets{u}(1) usesets{u}(end)]))
                end
                xlabel([int2str(mean(a)) '+/-' int2str(std(a))])
            end
        end
    end
    set(gcf,'Name',['ch' int2str(test.usechans(c))])
    figure(2)
    visualizeGrid(2,['E:\General Patient Info\EC24' '\brain.jpg'],ch2(c))
    input('n')
    clf
end


%%



%%

%make mtching word pairs to test and train
idx=1
train_trials=[];
test_trials=[]
train_label=[]
test_label=[]
for i=1:length(all_label)
    curlabel=all_label(i);
    if ~isempty(find(ismember(train_label,curlabel)))
        continue
    else
        matchlabel=find(all_label==curlabel);
        if length(matchlabel)==2
            test_trials(idx)=matchlabel(1);
            train_trials(idx)=matchlabel(2);
            test_label(idx)=curlabel;
            train_label(idx)=curlabel;
            idx=idx+1;
        end
    end
end

train_label=train_label'
test_label=test_label'
train_data=all_data(train_trials,:);
test_data=all_data(test_trials,:);