%% LOAD FILES
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\brocawords.mat')
D=SegmentedData('E:\BrocaRepeatKJ\EC2_B47\HilbAA_70to150_8band','E:\BrocaRepeatKJ\EC2_B47\HilbAA_70to150_8band',1:256)
D=SegmentedData('E:\DelayWord\EC18\EC18_B1\HilbAA_70to150_8band','E:\DelayWord\EC18\EC18_B1\HilbAA_70to150_8band',1:256)

%% SEGMENT BY WORDS ONSET
D.segmentedDataEvents40band({{brocawords.names}},{[2000 2000]},[],'aa',1:40,0,'Default','EC2_B47.words.lab')
D.calcZscore
D.plotData('line')
%%
trNum=size(D.segmentedEcog.zscore_separate,4);
c=69
samps=800:1200;

%% INPUT
%X is time
T=repmat(eye(length(samps),length(samps)),[1,1,trNum]);
T2=repmat(eye(length(samps),length(samps)),[trNum,1]);

%% MAKE DESIGN MATRIX
X=cat(2,T,A3);
Xtrain=reshape(permute(X,[1,3,2]),[],size(X,2));

%% plot regression
figure
plot(Ypred)
hold on
plot(Y(:,1),'r')
%% DECODE AUDIO ENV FROM ALL NEURAL CHAN

%Xis ecog data
X=squeeze(D.segmentedEcog.zscore_separate(:,samps,:,:));
X=permute(X,[2 1 3]);
X=cat(2,X);

%Y is analog
A=squeeze(D.segmentedEcog.analog400Env(2,samps,:,:));
A=smoothdim(A,1,10)';

RegOut=calcRegression(X,A);

%% FIND NEURAL ENCODING OF ANALOG
%Y is ecog data
Y=squeeze(D.segmentedEcog.zscore_separate(c,samps,:,:));

%X is analog
A=squeeze(D.segmentedEcog.analog400Env(2,samps,:,:));
A=smoothdim(A,1,10)';
A3(:,1,:)=A;

RegOut=calcRegression(A3,Y);

%% REGRESSION WITH SYLLABLES AS DESIGN MATRIX
Y=squeeze(D.segmentedEcog.zscore_separate(c,samps,:,:));

X=zeros(length(samps),12,trNum);
for i=1:trNum
    for j=1:size(X,2)-1
        segTimes=[segmentedWord(tr).segTimes(j) segmentedWord(tr).segTimes(j+1)];
        segSamps=floor(segTimes(1)*400)+1:round(segTimes(2)*400);
        X(segSamps,j,i)=1;
    end
end
%%
RegOut=calcANOVA(X,Y)
%%
RegOut=calcRegression(X,Y);
%% Look at RegOut (Predicted Y values)
figure
for tr=1:trNum
    plot(RegOut(tr).Ypred)
    hold on
    plot(RegOut(tr).Ytest,'r')
    R=corrcoef(RegOut(tr).Ypred',RegOut(tr).Ytest');
    title(num2str(R(1,2)))
    input('n')
    clf
end
%%
for i=1:trNum
    AllP{p}.Tall{eidx}.Data.segmentedEcog.analog100Env(1,:,1,usetr(i))=resample(AllP{p}.Tall{eidx}.Data.segmentedEcog.analog400Env(1,:,:,usetr(i)),1,4); 
    AllP{p}.Tall{eidx}.Data.segmentedEcog.analog100Env(2,:,1,usetr(i))=resample(AllP{p}.Tall{eidx}.Data.segmentedEcog.analog400Env(2,:,:,usetr(i)),1,4);
end

%%
eidx=2
try 
    AllP{p}.Tall{eidx}.Data.Params.usetr=setdiff(1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.data,4),AllP{p}.Tall{eidx}.Data.Artifacts.badtr)
catch
    AllP{p}.Tall{eidx}.Data.Params.usetr=1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.data,4)
end
    usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
trNum=length(usetr);
usech=1:256;%AllP{p}.Tall{eidx}.Data.Params.activeCh
chNum=length(usech);
sampNum=400;
usesamp=200:250;
D=diff(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),[],2);
X=permute(squeeze(D),[2 1 3]);
Yall=permute(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.formant100Hz(:,:,1,usetr)),[2,1,3]);

%% DECODING
for lag=1:2:50
    Y=zeros(length(usesamp)-1,trNum);
    Y(1+lag,:)=1;
    usesamp=(200:250)+lag;
    D=diff(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),[],2);
    X=permute(squeeze(D),[2 1 3]);
    %Y=Yall(usesamp+lag,:);
    %out(lag).RegOut=calcRegression(X,Y,0);
    out(lag).RegOut=calcANOVA(X,Y);
end
%% PLOT WEIGHTS AND R2
figure
for lag=5:2:50
    beta=mean([out(lag).RegOut.stats.beta(usech)],2);
    beta=beta./prctile(beta,99);
    beta(find(beta>1))=1;
    beta(find(beta<-1))=-1;
    beta(find(out(lag).RegOut.stats.p(usech)>.05))=0
    imagesc(reshape(beta,16,16)')
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,beta);
    input('n')
    R2(lag)= out(lag).RegOut.R2
end
%% ENCODING PER CHANNEL
for ch=1:256
    for lag=1:2:50
        clear Yin
        %Y=zeros(length(usesamp)-1,trNum);
        %Y(1,:)=1;        
        Y=Yall(usesamp,:,:);
        %out(lag).RegOut=calcRegression(X,Y,0);
        Yin(:,:,:)=Y;        
        usesamp=(200:300)+lag;
        D=AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr);
        X=permute(squeeze(D),[2 1 3]);        
        
        out(ch,lag).RegOut=calcANOVA(Yin,X(:,ch,:));
    end
end
%%
figure
for ch=1:256
    for lag=1:2:50 
        R2(ch,lag)= out(ch,lag).RegOut.R2;
        dev(ch,lag)=out(ch,lag).RegOut.dev;
    end
    plotGridPosition(ch)
    bar(R2(ch,5:2:50 ))
    hold on
    axis([0 10 0 .5])
end
%%
imagesc(reshape(R2(:,1),16,16)')
%% DOWNSAMPLE CONTINUOUS ECOG DATA

for c=1:256
    d.dataDS(c,:)=resample(d.data(c,:),1,4);
end
%% ENCODING CONTINUOUS ECOG WITH FORMANTS
for ch=1:256
    for lag=1%:2:50
        clear Yin       
        Y=formants;       
        Yin=Y;
        X=d.dataDS(:,usesamps+lag)';
        out(ch,lag).RegOut=calcANOVA(Yin,X(:,ch,:));
    end
end
%%
figure
for ch=1:256
    for lag=1%:2:50 
        R2(ch,lag)= out(ch,lag).RegOut.R2;
        dev(ch,lag)=out(ch,lag).RegOut.dev;
        betaAll(ch,lag,:)= out(ch,lag).RegOut.stats.beta
    end
%     plotGridPosition(ch)
%     bar(R2(ch,5:2:50 ))
%     hold on
%     axis([0 10 0 .5])
end
%%
imagesc(reshape(R2(:,1),16,16)')
