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



    %% PCA of time
    clear D pc dat D_sm
    usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
    usesamp=800:1400
    D=squeeze(T.Data.segmentedEcog.zscore_separate(usechan,usesamp,:,:));
    L=1:length(usetr);

    D_sm=zeros(length(usechan),length(usesamp),length(L));
    for ch=1:length(usechan)
        for tr=1:length(L)
            D_sm(ch,:,tr)=smooth(D(ch,:,tr),10);
        end
    end
D=D_sm;
D=permute(D_sm,[3,2,1]);
dat = D(:,:,ch);

%[eigcoeff, eigvec] = pca(dat);
pcnum=20
[eigcoeff, eigvec] = pca(dat,pcnum);

%% plot PC
indices=T.Data.findTrials('6','n','n')
idx1=find(ismember(usetr,indices.cond1));
idx2=find(ismember(usetr,indices.cond2));
for c=1:length(usechan)
    for i=1:pcnum
        pc.data(c,:,:)=(eigvec'*mean(D(:,:,c),3)')';
        pc.data1(c,:,:)=(eigvec'*mean(D(idx1,:,c),3)')';
        pc.data2(c,:,:)=(eigvec'*mean(D(idx2,:,c),3)')';
    end
end
%% plot PC
indices=T.Data.findTrials('6','y','n')
idx1=find(ismember(usetr,indices.cond1));
idx2=find(ismember(usetr,indices.cond2));
figure
meanDiff=zeros(1,256)
for s=1:10:length(usesamp)
    samp=usesamp(s);
    for c=1:length(usechan)
        %plotGridPosition(usechan(c));
        for i=1%:pcnum
              %barwitherr([ste(pc.data(c,idx1,i),2);ste(pc.data(c,idx2,i),2)],[mean(pc.data(c,idx1,i),2);mean(pc.data(c,idx2,i),2)]);

              tmp1=squeeze(mean(T.Data.segmentedEcog.zscore_separate(c,samp+10,:,idx1),2))';
              tmp2=squeeze(mean(T.Data.segmentedEcog.zscore_separate(c,samp+10,:,idx2),2))';
              %barwitherr([ste(tmp1,2);ste(tmp2,2)],[mean(tmp1,2);mean(tmp2,2)]);
              meanDiff(usechan(c),s)=mean(tmp1,2)-mean(tmp2,2);
        end
    end
    imagesc(reshape(meanDiff(:,s)',16,16)')
    title(samp)
    input('n')
end
%%
figure
for c=usechan
    plotGridPosition(c);
    plot(meanDiff(c,:))
end
%% TTEST
for c=1:length(usechan)
    for s=1:10:length(usesamp)-10
        %samp=usesamp(s);
        samp=s;
        [h(c,s),p(c,s)]=ttest(mean(D_sm(c,samp+10,realIdx),2),mean(D_sm(c,samp+10,psIdx),2),0.05);
    end
end
dd=cumsum(h,2);
d=zeros(1,256);
d(usechan)=dd(:,end);
imagesc(reshape(d,16,16))
visualizeGrid(1,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan,dd(:,end)');
%%
idx=1
figure
for  s=1:25:length(usesamp)
    %samp=usesamp(s);
    %imagesc(reshape(meanDiff(:,s)',16,16)')    
%     d=meanDiff(:,s)';
%     d(find(meanDiff(:,s)<.5))=0;
    subplot(5,8,idx)
    hold on
    d=sum(h(:,s:s+25),2)';
    d2=zeros(1,256);
    d2(usechan)=d;
    dz=d2;
    %dz(find(d2<2))=0
    imagesc(flipud(reshape(dz,16,16)'),[0 5])
    axis tight
    %visualizeGrid(1,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan,dz);
    %axis([200 1300 100 1000])
    title(usesamp(s))
    %input('n')
    %clf
    idx=idx+1;
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
indices=T.Data.findTrials('6','n','n')

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
    for p=usechan%1:20
        %subplot(4,5,p)
        plotGridPosition(p);
        %plot(mean(pc.data(p,:,realIdx(i)),1))
        plot(T.Data.segmentedEcog.zscore_separate(p,:,1,realIdx(i)))
        hold on
        plot(T.Data.segmentedEcog.zscore_separate(p,:,1,psIdx(i)),'Color','r')

        
        %plot(zscore(anEnv(realIdx(i),800:end))')
        %plot(mean(pc.data(p,:,psIdx(i)),1),'r')
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
    hold on
    errorarea(squeeze(mean(T.Data.segmentedEcog.zscore_separate(i,:,1,realIdx),4)),squeeze(ste(T.Data.segmentedEcog.zscore_separate(i,:,1,realIdx),4)))
    hold on    
    [hl,hp]=errorarea(squeeze(mean(T.Data.segmentedEcog.zscore_separate(i,:,1,psIdx),4)),squeeze(ste(T.Data.segmentedEcog.zscore_separate(i,:,1,psIdx),4)))
    set(hl,'Color','r')
    set(hp,'FaceColor','r')
    axis([0 1600 -3 5])
   % plot(squeeze(mean(T.Data.segmentedEcog.zscore_separate(i,:,1,realIdx),4))-squeeze(mean(T.Data.segmentedEcog.zscore_separate(i,:,1,psIdx),4)))
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
sidx=1
for s=1:25:length(usesamp)-25
    for c=1:length(usechan)
        ecog=squeeze(mean(mean(D_sm(c,s+25,idx1),2),1));
        [R,p]=partialcorr([ecog cell2mat(wordProp.l(idx1))'],cell2mat(wordProp.f(idx1))','type','Spearman');
        %[R,p]=corrcoef([ecog cell2mat(wordProp.f(idx1))']);
        Rall.R(c,sidx)=R(1,2);
        Rall.p(c,sidx)=p(1,2);
    end
    sidx=sidx+1;
end
figure
plot(Rall.R)
imagesc(Rall.R)
%% plot significant correlation
figure
sidx=1
for s=1:25:length(usesamp)-25
    subplot(5,8,sidx)
    idx=find(Rall.p(:,sidx)<=0.05);
    d=zeros(1,256);
    d(usechan(idx'))=Rall.R(idx,sidx);
    imagesc(flipud(reshape(d',16,16)),[-1 1])
    %visualizeGrid(1,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan,d);
    title(usesamp(s))
    sidx=sidx+1;
end
%% PLOT R OVER TIME
figure
for c=1:length(usechan)
    plotGridPosition(usechan(c))
    errorarea(Rall.R(c,:),Rall.p(c,:))
end
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
usetr2=[realIdx psIdx]
try
    group=grp2idx(wordProp.rp(usetr2));
catch
    group=grp2idx(cell2mat(wordProp.l));
end
%g1=find(group(1:length(usetr))==1);
%g2=find(group(1:length(usetr))==2);
%%
%usetr2=([g1(1:16); g2(1:15)])'
%usetr=usetr(1:28)
Labels=T.Data.segmentedEcog.event(usetr2,8);
usetr=usetr2
%%
figure
sidx=1
for s=1:50:length(usesamp)-100
    for i=1:20
        %%
        clear tmp2
        testIdx=ceil(rand(1,round(length(usetr)*.8))*length(usetr));
        trainIdx=setdiff(1:length(usetr),testIdx);
        %tmp=permute(pc.data(:,:,usetr),[3 1 2]);
        tmp=permute(D_sm(:,s:s+100,usetr),[3 1 2]);
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
    subplot(4,5,sidx)
    plot([svmOut.accuracy])
    hist([svmOut.accuracy])
    title([usesamp(s)  mean([svmOut.accuracy])])
    sidx=sidx+1;
end
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

