powerpoint_object=SAVEPPT2('test.ppt','init')
%%
for n=[12 13 17]
    for e=[2 3 4 5]
        close all
        clear T
        T=PLVTests(n,e,1:256,'aa40')
        T.Data.BaselineChoice='rest'
        T.Data.calcZscore_onechan;
        %%
        T.Data.plotData('spectrogram')
        figure(1)
        set(gcf,'Position',[1,1,2000,1000])
        saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        figure(2)
        set(gcf,'Position',[1,1,2000,1000])
        saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off'); 
        
        dos('cmd /c "echo off | clip"')
        done(e,n)=1;
        [a,b]= fileparts(T.Data.Filepath);
        [~,block]=fileparts(a);
        figure(1)
        saveas(gcf,['E:\DelayWord\spec_'  block '_e' int2str(e) 'real'],'fig')
        figure(2)
        saveas(gcf,['E:\DelayWord\spec_'  block '_e' int2str(e) 'psuedo'],'fig')
        %save(['E:\DelayWord\Data_' block '_e' int2str(e)],'T','-v7.3')
    end
end
%% plot ave amp against word length
load('E:\DelayWord\brocawords.mat');
load('E:\DelayWord\frequencybands');
Labels=T_ro.Data.segmentedEcog.event(:,8);
%%
%Labels=Labels(usetrials,:)
clear wordLength wordFreq
for i=1:length(Labels)
    idx=find(strcmp(Labels(i), {brocawords.names}'))
    if isempty(idx)
        wordLength(i,1)=0;
        wordFreq(i,1)=0;
    else
        wordLength(i,1)=brocawords(idx).lengthval;
        wordFreq(i,1)=brocawords(idx).logfreq_HAL;
    end
end
%wordLength(find(wordLength==0))=[];
%wordFreq(find(wordFreq==0))=[];
usetrials=find(wordLength~=0);
%%
figure
jetcolor=colormap(jet)
colors=jetcolor(round(linspace(1,length(jetcolor),5)),:)
bands=fields(frequencybands)
for epos=1:256
    for fidx=2%2:6      
        %f=frequencybands.(bands{fidx});
        f=1;
        samps=800:1600
        y=squeeze(mean(max(T.Data.segmentedEcog.zscore_separate(epos,samps:end,f,usetrials),[],2),3));
        [p,s] = polyfit(wordLength(usetrials),y,1);
        G.rsquare=1 - s.normr^2 / norm(y-mean(y))^2
        tmp=p;        
%         [c,G]=fit(wordLength(usetrials),y,'poly1');
%         tmp= coeffvalues(c);
        Params(fidx).wordLength(1).slope(epos)=tmp(1);
        Params(fidx).wordLength(1).R2(epos)=G.rsquare;       
        
        y=squeeze(mean(max(T.Data.segmentedEcog.zscore_separate(epos,samps:end,f,usetrials),[],2),3));    
        [p,s] = polyfit(wordFreq(usetrials),y,1);
        G.rsquare=1 - s.normr^2 / norm(y-mean(y))^2
        tmp=p;
        %[c,G]=fit(wordFreq(usetrials),y,'poly1');
        %tmp= coeffvalues(c);
        Params(fidx).wordFreq(1).slope(epos)=tmp(1);
        Params(fidx).wordFreq(1).R2(epos)=G.rsquare;       
        
        plotGridPosition(epos);
        y=squeeze(mean(max(T.Data.segmentedEcog.zscore_separate(epos,samps:end,f,usetrials),[],2),3));
        [p,s] = polyfit(wordLength(usetrials),y,1);
        G.rsquare=1 - s.normr^2 / norm(y-mean(y))^2
        tmp=p;        
        %[c,G]=fit(wordFreq(usetrials),y,'poly1');
        %tmp= coeffvalues(c);
        plot(wordLength(usetrials),y,'.','Color','k')
        hold on
        plot(polyval(tmp,1:13),'k')
        legend off
        %axis tight
        axis([4 13 -1 5])
        figure(fidx)
        if ismember(epos,T.Data.Artifacts.badChannels)
            set(gca,'Color','g')
        end
        text(5,0,[num2str(epos) 'R= ' num2str( G.rsquare)])
    end
end
%%
for fidx=2:6
    addLabels(figure(fidx))
end

%% plot slope for all chan
figure(1)
figure(2)
t=1
for i=1%1:5
    badch=find(Params(i+1).wordLength(t).R2>.1)
    badch=[]    
    badch=unique([badch,T.Data.Artifacts.badChannels]);

    slope=Params(i+1).wordLength(t).slope;
    slope(badch)=0;    
    figure(1)
    subplot(1,5,i)
    
    imagesc(reshape(slope,16,16)',[-.3 .3])
    colorbar('SouthOutside')
    labelGridOnMatix
    title(['Slope ' bands{i+1}])
    figure(2)
    subplot(1,5,i)
    imagesc(reshape(Params(i+1).wordLength(t).R2,16,16)',[-.1 .1])        
    labelGridOnMatix
    title(['R2 '  bands{i+1}])
    colorbar('SouthOutside')    
end
%% plot word length vs amplitude for freq bands
[~,sortidx]=sort(wordLength);
for l=4:13
    widx{l}=find(wordLength==l);
end
%widx{5}=widx{4}

%%
figure
for epos=1:256
    for fidx=1%2:6
        plotGridPosition(epos);
        f=1;%frequencybands.(bands{fidx});
        samps=800:1600;
        y=squeeze(mean(max(T.Data.segmentedEcog.zscore_separate(epos,samps,f,:),[],2),3));
        for l=5:13
            y2(l-3)=nanmean(y(widx{l}));
            s2(l-3)=nanstd(y(widx{l}),[],1)/sqrt(length(widx{l}));
        end
        %hl=errorbar(y2,s2,'LineWidth',2);
        barwitherr(s2,y2);
        %[hl,hp]=errorarea(y2,s2);
        %set(hp,'FaceColor',colors(fidx-1,:));
        %set(hl,'Color',colors(fidx-1,:));
        hold on
        text(0,3,int2str(epos))
        
        
        [p,s] = polyfit(wordLength(usetrials),y,1);
        G.rsquare=1 - s.normr^2 / norm(y-mean(y))^2;
        tmp=p;  
        plot(polyval(tmp,1:13),'k')
        aveslope(epos)=tmp(1);
        
    end
    %axis([2 10 -1 3])
end
%addLabels(gcf)
%% plot hg amplitude vs low freq amplitude
figure
for epos=1:256
    plotGridPosition(epos)
    plot(squeeze(mean(mean(T.Data.segmentedEcog.zscore_separate(epos,:,frequencybands.hg,:),3),4)),...
        squeeze(mean(mean(T.Data.segmentedEcog.zscore_separate(epos,:,frequencybands.beta,:),3),4)),'b.')
%     plot(squeeze(mean(mean(T.Data.segmentedEcog.zscore_separate(epos,:,frequencybands.beta,:),3),4)),...
%         squeeze(mean(mean(T.Data.segmentedEcog.zscore_separate(epos,:,frequencybands.hg,:),3),4)),'b.')
    axis([0 3 -1 1])
end
%% PCA
frequencybands=T.Data.FrequencyBands;
usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
%D=squeeze(mean(T.Data.segmentedEcog.zscore_separate(:,:,frequencybands.hg,:),3));
usesamp=800:1400
D=squeeze(T.Data.segmentedEcog.zscore_separate(usechan,usesamp,:,:));
L=1:size(D,3);

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


pc.short=eigvec'*mean(D(:,:,indices.cond1),3);
pc.long=eigvec'*mean(D(:,:,indices.cond2),3);
figure
for i=1:pcnum
    subplot(2,pcnum/2,i)
    plot(pc.short(i,:))
    hold on
    plot(pc.long(i,:),'r')
end

%% visualize weights
figure
ii=1
for i=1:pcnum
    subplot(2,1,1)
    plot(pc.short(i,:))
    hold on
    plot(pc.long(i,:),'r')
    subplot(2,1,2)
    visualizeGrid(5,['E:\General Patient Info\' T.Data.patientID '\brain.jpg'],usechan,eigvec(:,i));
    if pcnum==10
        ii=1
        figure
    else
        i=i+1;
    end
    input('n')
end
%% LDA
frequencybands=T.Data.FrequencyBands;
usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
%D=squeeze(mean(T.Data.segmentedEcog.zscore_separate(:,:,frequencybands.hg,:),3));
D=T.Data.segmentedEcog.zscore_separate(usechan,:,:,:);
L=1:size(D,3)

ldaData{1} = [];
for i = 1:length(indices.cond1)
    ldaData{1} = [ldaData{1}; D(:,:,indices.cond1(i))'];
end

ldaData{2} = [];
for i = 1:length(indices.cond2)
    ldaData{2} = [ldaData{1}; D(:,:,indices.cond2(i))'];
end


[eigcoeff, eigvec] = lda(ldaData);
pc.short=eigvec(:,1)'*mean(D(:,:,indices.cond1),3);
pc.long=eigvec(:,1)'*mean(D(:,:,indices.cond2),3);
figure
i=1
plot(pc.short(i,:))
hold on
plot(pc.long(i,:),'r')
%% LDA
%% LDA
frequencybands=T.Data.FrequencyBands;
usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
%D=squeeze(mean(T.Data.segmentedEcog.zscore_separate(:,:,frequencybands.hg,:),3));
D=T.Data.segmentedEcog.zscore_separate(usechan,:,:,:);
L=1:size(D,3)

ldaData{1} = [];
for i = 1:length(indices.cond1)
    ldaData{1} = [ldaData{1}; D(:,:,indices.cond1(i))'];
end

ldaData{2} = [];
for i = 1:length(indices.cond2)
    ldaData{2} = [ldaData{1}; D(:,:,indices.cond2(i))'];
end


[eigcoeff, eigvec] = lda(ldaData);
pc.short=eigvec(:,1)'*mean(D(:,:,indices.cond1),3);
pc.long=eigvec(:,1)'*mean(D(:,:,indices.cond2),3);
figure
i=1
plot(pc.short(i,:))
hold on
plot(pc.long(i,:),'r')


%% WARP TIME
newD=zeros(256,131*4,40,52);
for w=1:51
    %idx=find(strcmp(Labels{w},{evnt.name}'));
    try
        [a,fs]=wavread(['C:\Users\Angela_2\Dropbox\ChangLab\Users\Matt\tasks\wordlearning\stimuli_norm_db' filesep Labels{w}]);    
    catch
        continue
    end
    tmp=find(a(:,1)>.01); 
    start=tmp(1)/fs; 
    stop=tmp(end)/fs;
    soundLength=round(stop*400)-round(start*400);
    idx=1;
    sounds(w).name=Labels{w};
    sounds(w).length=soundLength;
end
%%
    for s=.01:.01/4:1.3
        getSamp=round(s*soundLength);
        newD(:,idx,:,w)=T.Data.segmentedEcog.zscore_separate(:,800+getSamp,:,w);
        idx=idx+1;
    end
end
%% plot stacked
figure
for epos=1:256
    plotGridPosition(epos);
    imagesc(squeeze(mean(newD(epos,:,frequencybands.hg,:),3))',[-1 3])
end
%% plot ave
figure
for epos=1:256
    plotGridPosition(epos);
    errorbar(squeeze(nanmean(nanmean(newD(epos,:,frequencybands.theta,indices.cond1),3),4)),...
        squeeze( ste(nanmean(newD(epos,:,frequencybands.hg,indices.cond1),3),4)))    
    hold on
    hl=errorbar(squeeze(nanmean(nanmean(newD(epos,:,frequencybands.theta,indices.cond2),3),4)),...
       squeeze( ste(nanmean(newD(epos,:,frequencybands.hg,indices.cond2),3),4)));
    set(hl,'Color','r');
    line([400 400],[-1 3])
    text(0,1,int2str(epos));
    axis([0 size(newD,2) -1 3])
end
%%
figure
for epos=1:256
    plotGridPosition(epos);
    plot(mean(T_16CAR.Data.segmentedEcog.zscore_separate(epos,:,:,:),4))
    hold on
    plot(mean(T.Data.segmentedEcog.zscore_separate(epos,:,:,:),4),'r')
end
%%

h=patch(surf2patch(reshape(xy(1,:),16,16),reshape(xy(2,:),16,16),reshape(slope,16 ,16),reshape(slope,16 ,16)))
 set(h,'AlphaDataMapping','scaled')
set(h,'FaceAlpha',.1)
shading interp;
%%

%% Corr sound env to HG
numTrials=size(T.Data.segmentedEcog.zscore_separate,4);
for i=1:numTrials
    soundEnv(i,:)=abs(hilbert(squeeze(T.Data.segmentedEcog.analog(2,:,:,i))'));
end
%%
for c=1:256
    for i=1:numTrials
        tmp=corrcoef(soundEnv(i,800:end),squeeze(T.Data.segmentedEcog.zscore_separate(c,800:end,:,i))');
        R(i,:)=tmp(1,2);
    end
    %plotGridPosition(c);
    %plot(R(sortidx))
    corrSoundHG(1).mean(c)=mean(R(indices.cond1));
    corrSoundHG(2).mean(c)=mean(R(indices.cond2));
end

corrSoundHG(1).mean(T.Data.Artifacts.badChannels)=0
corrSoundHG(2).mean(T.Data.Artifacts.badChannels)=0
imagesc(reshape(corrSoundHG(1).mean-corrSoundHG(2).mean,16,16)')
%%
diffCorr=corrSoundHG(1).mean-corrSoundHG(2).mean;
diffCorr(diffCorr>-.09)=0;
visualizeGrid(5,['E:\General Patient Info\' test.patientID '\brain.jpg'],1:256,diffCorr);
%% Compare response to word presentation and production

%%

%%
tmp=PLVtests(10,2,1:256,'aa')
T(2).Data=tmp.Data;
tmp=PLVtests(10,5,1:256,'aa')
T(5).Data=tmp.Data;
%Labels=Labels(usetrials,:)
for e=[2 5]
    clear wordLength wordFreq
    Labels=T(e).Data.segmentedEcog.event(:,8);

    for i=1:length(Labels)
        idx=find(strcmp(Labels(i), {brocawords.names}'))
        if isempty(idx)
            
            wordLength(i,1)=0;
            wordFreq(i,1)=0;
        else
            if ~isempty(brocawords(idx).lengthval)
                wordLength(i,1)=brocawords(idx).lengthval;
                wordFreq(i,1)=brocawords(idx).logfreq_HAL;
            else
                 wordLength(i,1)=0;
                 wordFreq(i,1)=0;
            end
        end
    end
    wordProperties(e).length=wordLength;
     wordProperties(e).freq=wordFreq;
    usetrials=find(wordLength~=0);
end
%%
figure
indices_wo=T(2).Data.findTrials('1','n','n')
[~,sortidx]=sort(wordProperties(2).length);
indices_wo.cond2=sortidx(end-16:end)
indices_ro=T(5).Data.findTrials('1','n','n')
[~,sortidx]=sort(wordProperties(5).length);
indices_ro.cond2=sortidx(end-16:end)
for epos=1:256
    plotGridPosition(epos);
    plot(squeeze(mean(T(2).Data.segmentedEcog.zscore_separate(epos,:,:,indices_wo.cond1),4)),'Linewidth',2);    
    hold on
    plot(squeeze(mean(T(2).Data.segmentedEcog.zscore_separate(epos,:,:,indices_wo.cond2),4)),'g','Linewidth',2);
    plot(squeeze(mean(T(5).Data.segmentedEcog.zscore_separate(epos,:,:,indices_ro.cond1),4)),'r','Linewidth',2);
    plot(squeeze(mean(T(5).Data.segmentedEcog.zscore_separate(epos,:,:,indices_ro.cond2),4)),'k','Linewidth',2);

    line([800 800],[ -1 5])
    axis tight
    text(0,0,int2str(epos))
end
   

%% CORR of PERCEPTION AND PRODUCTION





