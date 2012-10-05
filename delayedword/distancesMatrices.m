%Assign difficult and length value for pseudowords
for i=1:length(Labels)
    idx=find(strcmp(Labels(i), {brocawords.names}'))
    if isempty(idx)
        continue
    end
    if isempty(brocawords(idx).lengthval)
          idx2=find(strcmp(Labels(i), wordpairs(:,2)))
          idx3=find(strcmp( wordpairs(idx2,1), {brocawords.names}'))
          brocawords(idx).lengthval=brocawords(idx3).lengthval;
          brocawords(idx).lengthtype=brocawords(idx3).lengthtype;
          brocawords(idx).difficulty='pseudo';
          brocawords(idx).freq_HAL=0;
          brocawords(idx).logfreq_HAL=0;
    end
end
%%




badtr=[27 29  39 41 45]
badtr=[];
usetr=setdiff(1:size(T.Data.segmentedEcog.zscore_separate,4),badtr)
% usetr2=([realIdx psIdx])
%usetr=1:size(T.Data.segmentedEcog.zscore_separate,4);
%%

%Labels=Labels(usetrials,:)
load('E:\DelayWord\brocawords.mat');
load('E:\DelayWord\frequencybands');
%%
Labels=T.Data.segmentedEcog.event(usetr,8);

clear wordLength wordFreq wordProp
for i=1:length(Labels)
    idx=find(strcmp(Labels(i), {brocawords.names}'))
    if isempty(idx)
        wordProp.l{i}=0;
        wordProp.f{i}=0;
        wordProp.rp{i}=0;
        wordProp.ed{i}=0;
        wordProp.sl{i}=0;
    else
        wordProp.l{i}=brocawords(idx).lengthval;
        wordProp.f{i}=brocawords(idx).logfreq_HAL;
        wordProp.rp{i}=brocawords(idx).realpseudo;
        wordProp.ed{i}=brocawords(idx).difficulty;
        wordProp.sl{i}=brocawords(idx).lengthtype;
    end
    wordProp.name{i}=Labels{i};
end
wordLength=cell2mat(wordProp.l);
wordFreq=cell2mat(wordProp.f);

%% plot data

imagesc(reshape(permute(T.Data.segmentedEcog.zscore_separate(:,usesamp,1,usetr),[4 1 2 3]),length(usetr),[]))



%% PCA
clear D pc dat D_sm
usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
usesamp=400:1400
D=squeeze(T.Data.segmentedEcog.zscore_separate(usechan,usesamp,:,:));
L=1:length(usetr);

D_sm=zeros(length(usechan),length(usesamp),length(L));
for ch=1:length(usechan)
    for tr=1:length(L)
        D_sm(ch,:,tr)=smooth(D(ch,:,tr),10);
    end
end
D=D_sm;
D=permute(D_sm,[3,2,1])
avgData = D(:,:,ch);

[eigcoeff, eigvec] = pca(dat);
pcnum=20
[eigcoeff, eigvec] = pca(dat,pcnum);

for i=1:length(L)
    pc.data(:,:,i)=eigvec'*mean(D(:,:,i),3);
end

%% PCA
clear D pc dat D_sm
usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
usesamp=400:1400
D=squeeze(T.Data.segmentedEcog.zscore_separate(usechan,usesamp,:,:));
L=1:length(usetr);

D_sm=zeros(length(usechan),length(usesamp),length(L));
for ch=1:length(usechan)
    for tr=1:length(L)
        D_sm(ch,:,tr)=smooth(D(ch,:,tr),10);
    end
end
D=D_sm;
avgData = zeros(size(D,1),size(D,2),length(unique(L)));
for i = 1:size(avgData,3)
    avgData(:,:,i) = mean(D(:,:,L==i),3);    
end
dat = [];
for i = 1:size(avgData,3)
    dat = [dat; avgData(:,:,i)'];
end
[eigcoeff, eigvec] = pca(dat);
pcnum=20
[eigcoeff, eigvec] = pca(dat,pcnum);

for i=1:length(L)
    pc.data(:,:,i)=eigvec'*mean(D(:,:,i),3);
end
%%

%% LDA
frequencybands=T.Data.FrequencyBands;
usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
usesamp=800:1400
D=squeeze(T.Data.segmentedEcog.zscore_separate(usechan,usesamp,:,usetr(usetr)));
L=1:length(usetr);

ldaData{1} = [];
for i = 1:length(indices.cond1)
    ldaData{1} = [ldaData{1}; D(:,:,indices.cond1(i))'];
end

ldaData{2} = [];
for i = 1:length(indices.cond2)
    ldaData{2} = [ldaData{1}; D(:,:,indices.cond2(i))'];
end


[eigcoeff, eigvec] = lda(ldaData);
pc.real=eigvec(:,1)'*mean(D(:,:,indices.cond1),3);
pc.ps=eigvec(:,1)'*mean(D(:,:,indices.cond2),3);
figure
i=1
plot(pc.real(i,:))
hold on
plot(pc.ps(i,:),'r')


%% PLOT PCS 
indices=T.Data.findTrials('6','y','n')
idx1=find(ismember(usetr,indices.cond1));
idx2=find(ismember(usetr,indices.cond2));
figure
for i=1:pcnum
    subplot(4,5,i)
    [hl,hp]=errorarea(mean(pc.data(i,:,idx1),3),ste(pc.data(i,:,idx1),3))
    hold on    
    [hl,hp]=errorarea(mean(pc.data(i,:,idx2),3),ste(pc.data(i,:,idx2),3))
    set(hl,'Color','r');
    set(hp,'FaceColor','r');
end
%% PLOT ANALOG
load('E:\DelayWord\wordPairs')
%%
for i=1:length(usetr)
    anEnv(i,:)=abs(hilbert(squeeze(T.Data.segmentedEcog.analog(1,1,:,i))));
end

%idx are indices to real words
ii=1
clear realIdx psIdx
for i=1:length(idx1)
    realW=Labels(idx1(i))
    idx=find(strcmp(realW,wordpairs(:,1)))
    psW=wordpairs(idx,2)
    if ~isempty(psW{1}) & find(strcmp(psW,Labels))
        realIdx(ii)=idx1(i);
        psIdx(ii)=find(strcmp(psW,Labels))
        ii=ii+1;
    end
end

figure
plot(mean(anEnv(realIdx,:),1),'b')
hold on
plot(mean(anEnv(psIdx,:),1),'r')

imagesc(vertcat(anEnv(realIdx,:),anEnv(psIdx,:)))

figure
plot((anEnv(realIdx,:))','b')
hold on
plot((anEnv(psIdx,:))','r')

plot(anEnv(realIdx,:)'-anEnv(psIdx,:)')
%% PLOT ACOUSTICALLY MATCHED WORDS
figure
for i=1:length(realIdx)
    for p=1:20
        subplot(4,5,p)
        plot(mean(pc.data(p,:,realIdx(i)),1))
        hold on
        %plot(zscore(anEnv(realIdx(i),800:end))')
        plot(mean(pc.data(p,:,psIdx(i)),1),'r')
        %plot(zscore(anEnv(psIdx(i),800:end))','r')
        hold off
    end
    input('n')
end
%% PLOT PCS of real vs pseudo matched
figure
for i=1:pcnum
    subplot(4,5,i)
    plot(squeeze(pc.data(i,:,realIdx)),'b')
    hold on    
    plot(squeeze(pc.data(i,:,psIdx)),'r')
    plot(squeeze(pc.data(i,:,realIdx)),'b')
end
%% PLOT DATA of real vs pseudo matched
figure
for i=1:256
    plotGridPosition(i);
    plot(squeeze(T.Data.segmentedEcog.zscore_separate(i,:,1,realIdx)),'b')
    hold on    
    plot(squeeze(T.Data.segmentedEcog.zscore_separate(i,:,1,psIdx)),'r')
    plot(squeeze(T.Data.segmentedEcog.zscore_separate(i,:,1,realIdx)),'b')

end
%%
figure
for i=1:pcnum
    subplot(4,5,i)
    [hl,hp]=errorarea(mean(pc.data(i,:,idx1),3),ste(pc.data(i,:,realIdx),3))
    hold on    
    [hl,hp]=errorarea(mean(pc.data(i,:,idx2),3),ste(pc.data(i,:,psIdx),3))
    plot(zscore(anEnv(realIdx,usesamp),[],2)')
    plot(zscore(anEnv(psIdx,usesamp),[],2)','r')   
    set(hl,'Color','r');
    set(hp,'FaceColor','r');
end
%%
figure
for i=1:pcnum
    subplot(4,5,i)
    plot(squeeze(pc.data(i,:,realIdx)),'b')
    hold on    
    plot(squeeze(pc.data(i,:,psIdx)),'r')
end
%% plot 2 PCs by time

hold off
plot3(repmat(1:601,[length(realIdx) 1])',squeeze(pc.data(1,:,realIdx)),squeeze(pc.data(10,:,realIdx)),'b')
hold on
plot3(repmat(1:601,[length(psIdx) 1])',squeeze(pc.data(1,:,psIdx)),squeeze(pc.data(10,:,psIdx)),'r')




%% plot weights
figure
for i=1:pcnum
   subplot(4,5,i)
   try
        visualizeGrid(5,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan,eigvec(:,i));
   catch
       weights=zeros(1,256);
       weights(usechan)=eigvec(:,i)';
       imagesc(reshape(weights,16,16)')
   end
end
%% plot mean per trial vs freq and length
scatter(wordLength,12-wordFreq,300,median(mean(pc.data(:,:,:),1),2),'filled')
text(wordLength,12-wordFreq,T.Data.segmentedEcog.event(usetr,8))
%% distance PC
figure

p=pdist(squeeze(mean(pc.data(:,:,:),2))')
imagesc(squareform(p),[0 10])
set(gca,'YTick',1:length(usetr))
%% DISTANCE CHANNELS
p=pdist(squeeze(mean(T.Data.segmentedEcog.zscore_separate,2))')
imagesc(squareform(p),[0 10])
set(gca,'YTick',1:length(usetr))
set(gca,'YTickLabel',Labels)
%% mds
figure
x=mdscale(squareform(p),3);
scatter3(x(:,1),x(:,2),x(:,3),'filled')
text(x(:,1),x(:,2),x(:,3),T.Data.segmentedEcog.event(usetr,8))
%% decorrelated frequency and length
w=[wordLength wordFreq]'
[~,eigvec]=pca(w')
w_pc=eigvec(:,1)'*w
plot(1,w_pc,'.')
text(repmat(1,1,51)',w_pc,T.Data.segmentedEcog.event(:,8))
%% PARTIAL CORRELATION: Length and Freq
for pcidx=1:20
    ecog=squeeze(mean(max(pc.data(pcidx,:,:),[],2),1));
    R=partialcorr([ecog cell2mat(wordProp.l)'],cell2mat(wordProp.f)','type','Spearman');

    Rall(pcidx)=R(1,2);
end
figure
plot(Rall)
%%
%% PARTIAL CORRELATION CHANNELS: Length and Freq
for c=1:256
    ecog=squeeze(mean(max(T.Data.segmentedEcog.zscore_separate(c,400:1400,:),[],2),1));
    %R=partialcorr([ecog cell2mat(wordProp.l)'],cell2mat(wordProp.f)','type','Spearman');
    R=corrcoef([ecog cell2mat(wordProp.f)']);
    Rall(c)=R(1,2);
end
figure
plot(Rall)
%%
Rall2=Rall;
Rall2(find(Rall<.4))=0
visualizeGrid(5,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' T.Data.patientID '\brain.jpg'],1:256,Rall2);
%%
ecog=squeeze(mean(max(pc.data([ 4],:,:),[],2),1));
R=partialcorr([ecog cell2mat(wordProp.l)'],cell2mat(wordProp.f)','type','Spearman')

%%
    %%
R=corr(ecog ,cell2mat(wordProp.l)','type','Spearman')

%% CLASSIFY
try
    group=grp2idx(wordProp.rp(usetr2));
catch
    group=grp2idx(cell2mat(wordProp.l));
end
g1=find(group(1:length(usetr))==1);
g2=find(group(1:length(usetr))==2);
%%
usetr2=([g1(1:16); g2(1:15)])'
%usetr=usetr(1:28)
Labels=T.Data.segmentedEcog.event(usetr2,8);
usetr=usetr2
%%
for i=1:20
    %%
    clear tmp2
    testIdx=ceil(rand(1,round(length(usetr)*.8))*length(usetr));
    trainIdx=setdiff(1:length(usetr),testIdx);
    tmp=permute(pc.data(:,:,usetr),[3 1 2]);
    for j=1:length(usetr)
       tmp3=dct(squeeze(tmp(j,:,:)));
       tmp2(j,:,:)=tmp3(:,1:3);
    end
    tmp2=max(tmp,[],3);
    D=reshape(tmp2,length(usetr),[]);

    [bestc, bestg, bestcv, model, predicted_label, accuracy, decision_values] =...
        svm(D(trainIdx,:), group(trainIdx),D(testIdx,:),group(testIdx));
    
    svmOut(i).bestc=bestc;
    svmOut(i).bestg=bestg;
    svmOut(i).bestcv=bestcv;
    svmOut(i).model=model;
    svmOut(i).predicted_label=predicted_label;
    svmOut(i).accuracy=accuracy(1);
    svmOut(i).decision_values=decision_values;
    svmOut(i).testIdx=testIdx;
    svmOut(i).actual_label=group(testIdx);
end
figure
plot([svmOut.accuracy])
hist([svmOut.accuracy])
title(mean([svmOut.accuracy]))
%%
gscatter3(x(testIdx,1),x(testIdx,2),x(testIdx,3),predicted_label,{'b','r'})
%%
gscatter(wordLength(testIdx)',wordFreq(testIdx)',predicted_label,[rgb('blue');rgb('red')])
%%
clear predLabels
for i=1:length(usetr)
    [a,b]=find(vertcat(svmOut.testIdx)==i)
    p=horzcat(svmOut.predicted_label)'
    tmp=[]
    for ii=1:length(a)
        tmp(ii)=p(a(ii),b(ii))
    end
    try
        predLabels(i,1)=length(find(tmp==1))/length(tmp);
    catch
        predLabels(i,1)=0
    end
    
    try
        predLabels(i,2)=length(find(tmp==2))/length(tmp);
    catch
        predLabels(i,2)=0;
    end
end

imagesc(predLabels(:,1))
set(gca,'YTick',1:length(Labels),'YTickLabel',Labels)

