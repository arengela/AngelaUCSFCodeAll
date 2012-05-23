

trialslog{1}=[]
i=1;
w=1;
while i+2<=168
    trialslog{i}='slide';
    
    
    trialslog{i+1}='word'%wordlist{w,3};
    trialslog{i+2}='beep';
    
    i=i+3;
    w=w+1;
end
save('trialslog_sounds','trialslog')
%%
i=1;
i2=1;
allEventTimes2=cell(1,2);
while i<=length(allEventTimes)
    allEventTimes2(i2,:)=allEventTimes(i,:);
    
    if strcmp(allEventTimes(i,2),'slide') || strcmp(allEventTimes(i,2),'beep')
        %{
        j=1;
        while strmatch(allEventTimes(i+j,2),'slide') || strmatch(allEventTimes(i+j,2),'beep')
            j=j+1;
        end
        i=i+j;
        %}
        i=i+4;
        i2=i2+1;
        continue
    end
    i=i+1;
    i2=i2+1;
end
%%

t1=regexp(allEventTimes(:,2),'slide')
t2=regexp(allEventTimes(:,2),'word')
t3=regexp(allEventTimes(:,2),'we')
t4=regexp(allEventTimes(:,2),'beep')
t5=regexp(allEventTimes(:,2),'r\>')
t6=regexp(allEventTimes(:,2),'re')



p1=find(~cellfun(@isempty,t1))
p2=find(~cellfun(@isempty,t2))
p3=find(~cellfun(@isempty,t3))
p4=find(~cellfun(@isempty,t4))
p5=find(~cellfun(@isempty,t5))
p6=find(~cellfun(@isempty,t6))
%%
figure
plot([allEventTimes{p1,1}],1,'go')
hold on
plot([allEventTimes{p2,1}],1,'ro')
plot([allEventTimes{p3,1}],1,'b.')
plot([allEventTimes{p4,1}],1,'k.')
plot([allEventTimes{p5,1}],1,'m*')

%%

figure
hist([allEventTimes{p2,1}]-[allEventTimes{p1,1}],100)
plot(1:28,[allEventTimes{p2,1}]-[allEventTimes{p1,1}])
[allEventTimes{p2,1}]-[allEventTimes{p1,1}]
[allEventTimes{p3,1}]-[allEventTimes{p2,1}]
[allEventTimes{p4,1}]-[allEventTimes{p3,1}]
plot(ans)


%
rep=1;
i=1;
while i<=size(allEventTimes,1)
    if strmatch(allEventTimes(i,2),'slide') & strmatch(allEventTimes(i+1,2),'word') & strmatch(allEventTimes(i+2,2),'we') ...
            & strmatch(allEventTimes(i+3,2),'beep') & strmatch(allEventTimes(i+4,2),'r') & strmatch(allEventTimes(i+5,2),'re')
        diffT(rep,1)=allEventTimes(i,1);
        diffT(rep,2)=allEventTimes(i+1,1);
        diffT(rep,3)=allEventTimes(i+2,1);
        diffT(rep,4)=allEventTimes(i+3,1);
        diffT(rep,5)=allEventTimes(i+4,1);
        diffT(rep,6)=allEventTimes(i+5,1);
        rep=rep+1;
        i=i+6;
    else
        i=i+1;
    end
end

StoW=cell2mat(diffT(:,2))-cell2mat(diffT(:,1));
WL=cell2mat(diffT(:,3))-cell2mat(diffT(:,2));
WEtoB=cell2mat(diffT(:,4))-cell2mat(diffT(:,3));
RT=cell2mat(diffT(:,5))-cell2mat(diffT(:,4));
RL=cell2mat(diffT(:,6))-cell2mat(diffT(:,5));


m1=mean(StoW)
m2=mean(WL)
m3=mean(WEtoB)
m4=mean(RT)
m5=mean(RL)


figure
hist(mean(WL))
hist(mean(WL),100)
hist(WL,100)
hist(RT,100)
hist(StoW,100)
subplot(5,1,1)
hist(StoW,100)
subplot(5,1,2)
hist(WL,100)
subplot(5,1,3)
hist(WEtoB,100)
subplot(5,1,4)
hist(RT,100)
subplot(5,1,5)
hist(RL,100)
%%
maxch=find(max(mean(zscore_seg{3}(:,200:300,:,:),3),[],2)>.5)
ECogDataVis ('E:\General Patient Info - Copy (2)\EC16','EC16',maxch,[],2,[],[]);
colormap('gray')

maxch=find(max(mean(zscore_seg{1}(:,200:300,:,:),3),[],2)>.3)
ECogDataVis ('E:\General Patient Info - Copy (2)\EC16','EC16',maxch,[],2,[],[]);

maxch=find(max(mean(zscore_seg{2}(:,200:400,:,:),3),[],2)>.5)
ECogDataVis ('E:\General Patient Info - Copy (2)\EC16','EC16',maxch,[],2,[],[]);

maxch=find(max(mean(zscore_seg{4}(:,1:190,:,:),3),[],2)>.3)
ECogDataVis ('E:\General Patient Info - Copy (2)\EC16','EC16',maxch,[],2,[],[]);

maxch=find(max(mean(zscore_seg{3}(:,200:600,:,:),3),[],2)>.5)
ECogDataVis ('E:\General Patient Info - Copy (2)\EC16','EC16',maxch,[],2,[],[]);

dpath='E:\General Patient Info - Copy (2)\EC16';
subject='EC16'
data = rand(256,10)-.5;
ECogDataVis (dpath,subject,1:256,data,3);
for c = 1:100, lab{c}=c;end
F = ECogDataMovie(dpath,subject,1:128,data2,lab);

for i=0:99
    data2(:,i+1)=mean(data(:,i*44+1:i*44+44,100),2);
end
%%
%stats
zscore_baseline=handles.ecogFiltered.data(36,[1040*400:	1080*400]);

zscore_stack1=squeeze(zscore_seg{1}(36,:,:,:))';
zscore_stack2=squeeze(zscore_seg{2}(36,:,:,:))';

ps_raw1=singleConditionStats(zscore_stack1,zscore_baseline,test_samp)
ps_raw2=singleConditionStats(zscore_stack2,zscore_baseline,test_samp)

ps_2cond_raw=twoConditionStats(zscore_stack1,zscore_stack2,test_samp,ps_raw1,ps_raw2,zscore_baseline1,zscore_baseline2)

ps_2cond_raw_P=twoConditionStats_permute(zscore_stack1,zscore_stack2,test_samp,ps_raw1,ps_raw2,zscore_baseline1,zscore_baseline2)



%%


figure
subplot(1,5,1)
plot(zscore_seg_slide{1}(36,:))
hold on
plot(zscore_seg_slide{2}(36,:),'r')
subplot(1,5,2)
plot(zscore_seg_word{2}(36,:),'r')
plot(zscore_seg_word{1}(36,:),'b')
hold on
plot(zscore_seg_word{2}(36,:),'r')
subplot(1,5,3)
plot(zscore_seg_we{2}(36,:),'r')
hold on
plot(zscore_seg_we{1}(36,:),'b')
subplot(1,5,4)
plot(zscore_seg_beep{1}(36,:),'b')
hold on
plot(zscore_seg_beep{2}(36,:),'r')
subplot(1,5,5)
plot(zscore_seg_r{2}(36,:),'r')
hold on
plot(zscore_seg_r{2}(36,:),'b')
plot(zscore_seg_r{2}(36,:),'r')
hold on

%%

realword{1}=zscore_seg_slide{1}(:,1:2.5*400);
realword{2}=zscore_seg_word{1}(:,1:1.7*400);
realword{3}=zscore_seg_we{1}(:,1:3*400);
realword{4}=zscore_seg_beep{1}(:,1600:2400);
realword{5}=zscore_seg_r{1}(:,1600:end);

pseudo{1}=zscore_seg_slide{2}(:,1:2.5*400);
pseudo{2}=zscore_seg_word{2}(:,1:1.7*400);
pseudo{3}=zscore_seg_we{2}(:,1:3*400);
pseudo{4}=zscore_seg_beep{2}(:,1600:2400);
pseudo{5}=zscore_seg_r{2}(:,1600:end);

%%

for w=1:2
    for seg=[1,3,4,5,6]
        [r,c]=find(allE{w}==seg)
        z{w,seg,:}=zscore_all{w}(:,c-399:c+400,r);
    end
end
[r,c]=find(allE{1}==9)
z{1,2,:}=zscore_all{w}(:,c-399:c+400,r);

[r,c]=find(allE{2}==10)
z{2,2,:}=zscore_all{w}(:,c-399:c+400,r);

%%
for w=1:2
    z2{w}=[];
    for seg=1:5
        tmp=mean(z{w,seg},3);
        z2{w}=cat(2,z2{w},tmp);
    end
end
%%
figure
%%
for c=1:256
    subplot(1,5,1)
    axis([0 1000 -1 2])
    plot(realword{1}(c,:),'k')
    
    subplot(1,5,2)
    axis([0 1000 -1 2])
    plot(realword{2}(c,:),'k')
    
    subplot(1,5,3)
    axis([0 1000 -1 2])
    
    plot(realword{3}(c,:),'k')
    
    subplot(1,5,4)
    axis([0 1000 -1 2])
    
    plot(realword{4}(c,:),'k')
    subplot(1,5,5)
    plot(realword{5}(c,:),'k')
    
    
    subplot(1,5,1)
    axis([0 1000 -1 2])
    
    hold on
    title(int2str(c))
    
    plot(pseudo{1}(c,:),'r')
    line([400 400],[-1 2])
    hold off
    
    subplot(1,5,2)
    hold on
    plot(pseudo{2}(c,:),'r')
    line([400 400],[-1 2])
    hold off
    
    subplot(1,5,3)
    hold on
    plot(pseudo{3}(c,:),'r')
    line([400 400],[-1 2])
    hold off
    
    subplot(1,5,4)
    hold on
    plot(pseudo{4}(c,:),'r')
    line([400 400],[-1 2])
    hold off
    
    subplot(1,5,5)
    hold on
    plot(pseudo{5}(c,:),'r')
    line([400 400],[-1 2])
    hold off
    
    r=input('next')
end


%%
%Match words with repetition and listening tasks


zScore_comb=squeeze(EC18_seg(2).zscore{1};
zScore_comb(:,:,:,2)=squeeze(EC18_seg(1).zscore{1}(:,:,1:28);
zScore_comb(:,:,1:24,3)=squeeze(EC18_seg(1).zscore{1}(:,:,29:52));
zScore_comb(:,:,26:28,3)=squeeze(EC18_seg(1).zscore{1}(:,:,53:55));
%%
figure
plot(squeeze(zScore_comb(122,:,1,1)))
hold on
plot(squeeze(zScore_comb(122,:,1,2)),'r')
plot(squeeze(zScore_comb(122,:,1,3)),'g')
%%
figure
plot(squeeze(mean(zScore_comb(103,:,:,1),3)),'k')
hold on
plot(squeeze(mean(zScore_comb(103,:,:,3),3)),'g')

%%
figure
plot(squeeze(zScore_comb(103,:,:,1)),'k')
hold on
plot(squeeze(mean(zScore_comb(103,:,1,2:3),4)),'g')

%%
%Standard error shading
figure
Y=squeeze(zScore_comb(103,:,:,1),'k');
plot(mean(Y,2));
hold on
E = std(Y,[],2)'/sqrt(28);
X=1:size(Y,1);
hp=patch([X, fliplr(X)], [mean(Y,2)'+E,fliplr(mean(Y,2)'-E)],'m')
set(hp,'FaceAlpha',.5)
set(hp,'EdgeColor','none')

%%
%Pick trial numbers
usetrials=trials(:,1);
usetrialsP=usetrials(usetrials~=0);
usetrials=trials(:,2);
usetrialsA=usetrials(usetrials~=0);

%%
%Plot zscores of active vs passive (with STE)
aligned=5000
colors={'k','g','c','r'};
figure
%set(gcf,'Name',handles.patientID);
i=2;
for n=[1]
    Y=zScoreall(n).data{i}(:,:,usetrials{n});
    
    zScore{i}=mean(Y,3);
    E = std(Y,[],3)/sqrt(size(Y,3));
    processingPlotAllChannels_inputZscoreGUI(zScore{i},colors{n},aligned*400/1000,handles.badChannels,[],E,handles.gridlayout);
    hold on
end

%%
close all
figure
subplot(1,2,2)
%ch=254


set(gcf,'Color','w')

i=1
usetrials=trials(:,1);
usetrials1=usetrials(usetrials~=0);
Y=zScore2{i}(:,:,usetrials1);
zScore{i}=mean(Y,3);
E = std(Y,[],3)/sqrt(size(Y,3));
plot(zScore{i}(ch,:),'g')
hold on

X=1:size(Y,2);
hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'y');
set(hp,'FaceAlpha',.5)
set(hp,'EdgeColor','none')


i=2
usetrials=cat(1,trials(:,2),trials(:,3));
usetrials2=usetrials(usetrials~=0);

Y=zScore2{i}(:,:,usetrials2);
zScore{i}=mean(Y,3);
E = std(Y,[],3)/sqrt(size(Y,3));
plot(zScore{i}(ch,:),'k')
hold on

X=1:size(Y,2);
hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'m');
set(hp,'FaceAlpha',.5)
set(hp,'EdgeColor','none')

%axis([0 4000 -1 1])
set(gca,'XTick',[0:400:4000])
set(gca,'XTickLabel',[-3:1:7])
hl=line([1200 1200],[-1 5])
%set(hl,'Color','r')
set(gca,'XTickLabel',[-3:1:7])
hl=line([1200+2.4*400 1200+2.4*400],[-1 5]);
set(hl,'Color','r')
title(['electrode ' num2str(ch)])
axis([0 4000 -1 4])
freezeColors;
hold off
colormap('gray');


subplot(1,2,1)
usesamps=[1:6*400];
i=3
Y=zScore2{i}(:,usesamps,usetrials1);
zScore{i}=mean(Y,3);
E = std(Y,[],3)/sqrt(size(Y,3));
plot(zScore{i}(ch,:),'g')
hold on

X=1:size(Y,2);
hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'y');
set(hp,'FaceAlpha',.5)
set(hp,'EdgeColor','none')


i=4
Y=zScore2{i}(:,usesamps,usetrials2);
zScore{i}=mean(Y,3);
E = std(Y,[],3)/sqrt(size(Y,3));
plot(zScore{i}(ch,:),'k')
hold on

X=1:size(Y,2);
hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'m');
set(hp,'FaceAlpha',.5)
set(hp,'EdgeColor','none')




%axis([0 4000 -1 1])
set(gca,'XTick',[0:400:usesamps(end)])
set(gca,'XTickLabel',[-3:1:7])
hl=line([1200 1200],[-1 5])
set(hl,'Color','c')
set(gca,'XTickLabel',[-3:1:7])
%hl=line([1200+2.4*400 1200+2.4*400],[-1 5])
%set(hl,'Color','r')
%title(['electrode ' num2str(ch)])
axis([0 usesamps(end) -1 4])
freezeColors;
hold off
%%
ch=35
%%
figure
set(gcf,'Color','w')

%subplot(2,1,2)
patientID='EC18'
ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,ch,[],2,[],[]);
colormap('gray');

%%

figure
set(gcf,'Color','w')
ch=[19 35 5]
%subplot(2,1,2)
patientID='EC18'
ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,ch,[],2,[],[]);
colormap('gray');
%%
% %%
%
% subplot(1,2,2)
%
% i=3
% Y=zScore2{i};
% zScore{i}=mean(Y,3);
% E = std(Y,[],3)/sqrt(size(Y,3));
% plot(zScore{i}(39,:),'g')
% hold on
%
% X=1:size(Y,2);
% hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'y')
% set(hp,'FaceAlpha',.5)
% set(hp,'EdgeColor','none')
%
%
% i=4
% Y=zScore2{i};
% zScore{i}=mean(Y,3);
% E = std(Y,[],3)/sqrt(size(Y,3));
% plot(zScore{i}(39,:),'k')
% hold on
%
% X=1:size(Y,2);
% hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'m')
% set(hp,'FaceAlpha',.5)
% set(hp,'EdgeColor','none')
%
% axis([0 4000 -1 1])
% set(gca,'XTick',[0:400:4000])
%
% set(gca,'XTickLabel',[-3:1:7])
% hl=line([1200 1200],[-1 1])
% %set(hl,'Color','r')
%%
figure

for r=[800:1:1800]
    data=mean(zScoreall(1).data{1}(:,r:r+50,:),3);
    data=mean(data,2);
    %figure
    
    ECogDataVis(dpath,subject,1:256,data+.2,1,[],[]);
    printf(int2str(r))
    %input('next')
end

F = ECogDataMovie(dpath,subject,1:256,D;


%%
figure
Y=squeeze(zScore{1}(35,:,usetrials));
imagesc(Y)
colormap(flipud('gray'))

%%
for w=1:size(trials,1)
    if trials(w,2)==0
        trials(w,2)=trials(w,3);
    elseif trials(w,3)==0
        trials(w,3)=trials(w,2);
    end
end

%%
figure
keep=[]
idx=[]
for w=1:size(trials,1)
    
    A=mean(zScore2{2}(:,:,trials(w,2:3)),3);
    L=zScore2{1}(:,:,trials(w,1));
    zScore{2}(:,:,w)=A-L;
    
    %     plot(A(35,:),'k')
    %     hold on
    %     plot(L(35,:),'g')
    %      plot(A(35,:)-L(35,:),'r')
    %     %r=input(int2str(w))
    %     if r==1
    %         keep=vertcat(keep,A(35,:)-L(35,:));
    %         idx=[idx w];
    %     end
    %     %r=0;
    %     hold off
end


%%

event_seg_TS(find(event_seg_TS==2))=1;
event_seg_TS(find(event_seg_TS==4))=1;

%%

for m=1:size(tmp,2)
    idx{1}(m)=find(event_seg_TS(:,m)==5,1,'first');
end

for m=1:size(tmp,2)
    idx{2}(m)=find(event_seg_TS(:,m)==6,1,'first');
end

for m=1:size(tmp,2)
    idx{3}(m)=find(event_seg_TS(:,m)==7,1,'first');
end

for m=1:size(tmp,2)
    idx{4}(m)=find(event_seg_TS(:,m)==3,1,'last');
end

for m=1:size(tmp,2)
    idx{5}(m)=find(event_seg_TS(:,m)==1,1,'last');
end




%%

D=squeeze(data_seg);
%%
n=1
for i=1:55
    newstackE{n}(i,:)=event_seg_TS(idx{n}(i)-400:idx{n}(i)+1000,i);
    newstack{n}=D(:,idx{n}(i)-1000:idx{n}(i)+1000,:);
    newstack{n}=(newstack{n}-baseline3)./stdbaseline;
    
end

n=2
for i=1:55
    newstackE{n}(i,:)=event_seg_TS(idx{n}(i)-1000:idx{n}(i)+1000,i);
    newstack{n}=D(:,idx{n}(i)-1000:idx{n}(i)+1000,:);
    newstack{n}=(newstack{n}-baseline3)./stdbaseline;
    
end


n=3
for i=1:55
    newstackE{n}(i,:)=event_seg_TS(idx{n}(i)-1000:idx{n}(i)+1000,i);
    newstack{n}=D(:,idx{n}(i)-1000:idx{n}(i)+1000,:);
    newstack{n}=(newstack{n}-baseline3)./stdbaseline;
    
end

n=4
for i=1:55
    newstackE{n}(i,:)=event_seg_TS(idx{n}(i)-1000:idx{n}(i)+1000,i);
    newstack{n}=D(:,idx{n}(i)-1000:idx{n}(i)+1000,:);
    newstack{n}=(newstack{n}-baseline3)./stdbaseline;
    
end
%%
n=5
for i=42:55
    newstackE{n}(i,:)=event_seg_TS(idx{n}(i)-1000:idx{n}(i)+800,i);
    newstack{n}=D(:,idx{n}(i)-1000:idx{n}(i)+1000,:);
    newstack{n}=(newstack{n}-baseline3)./stdbaseline;
    
end
%%


figure
i=4
processingPlotSingleStacked_inputZscoreGUI(newstack{i},1000,[],gridlayout);

%% select data section to look at
%% Usetrials_A, usetrials_P selected from behavioral data on excel
event=2;
type=1;
samps=2000:size(zScoreall(type).data{event},2);
d=mean(zScoreall(type).data{event}(:,samps,usetrials_A),3);


%% Find peak timing from event
pki=zeros(1,256);
pk=zeros(1,256);
for n=1:256
    [tmp,tmpi]=max(d(n,:),[],2);
    if tmp>.5
        pki(n)=tmpi;
        pk(n)=tmp;
    end
end

[a,b]=sort(pki);
x=find(a>0,1,'first')
256-x
%% Plot latency of peak from event time
figure
pki(find(pki==0))=-10
imagesc(reshape(pki,[16 16])')
colormap(hot)

% Plot gridlines and electrode numbers
set(gcf,'Color','w')
set(gca,'XGrid','on')
set(gca,'YGrid','on')
set(gca,'XTick',[1.5:16.5])
set(gca,'YTick',[1.5:(16+.5)])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
for c=1:16
    for r=1:16
        if pki((r-1)*16+c)>0
            text(c-.4,r-.2,num2str((r-1)*16+c))
        end
    end
end
colorbar

%% Plot max peak aplitude
figure
pk(find(pk==0))=4

imagesc(reshape(pk,[16 16])')
colormap(flipud(hot))

% Plot gridlines and electrode numbers
set(gcf,'Color','w')
set(gca,'XGrid','on')
set(gca,'YGrid','on')
set(gca,'XTick',[1.5:16.5])
set(gca,'YTick',[1.5:(16+.5)])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
for c=1:16
    for r=1:16
        if pki((r-1)*16+c)>0
            text(c-.4,r-.2,num2str((r-1)*16+c))
        end
    end
end
colorbar
%% Sort electrodes by peak time
%% Plot zscores of only picked electrodes (zscore above threshold), in order of peak timing
figure

for i=x:256
    subplot(5,8,i-x+1)
    %subplot(2,1,1)
    ch=b(i)
    set(gcf,'Color','w');
    
    
    % plot mean and ste for Passive trials
    Y=zScoreall(2).data{event}(ch,:,usetrials_P);
    mean_Z=mean(Y,3);
    E = std(Y,[],3)/sqrt(size(Y,3));
    plot(mean_Z,'g')
    hold on
    
    X=1:size(Y,2);
    hp=patch([X, fliplr(X)], [mean_Z+E,fliplr(mean_Z)-E],'y');
    set(hp,'FaceAlpha',.5)
    set(hp,'EdgeColor','none')
    
    %plot mean zscore and ste for Active trials
    Y=zScoreall(1).data{event}(ch,:,usetrials_A);
    
    mean_Z=mean(Y,3);
    E = std(Y,[],3)/sqrt(size(Y,3));
    plot(mean_Z,'k');
    hold on
    
    X=1:size(Y,2);
    hp=patch([X, fliplr(X)], [mean_Z+E,fliplr(mean_Z-E)],'m');
    set(hp,'FaceAlpha',.5)
    set(hp,'EdgeColor','none')
    
    %axis([0 4000 -1 1])
    set(gca,'XTick',[0:400:2400])
    set(gca,'XTickLabel',[-3:1:3])
    hl=line([1200 1200],[-1 5])
    %set(hl,'Color','r')
    set(hl,'Color','r')
    title([num2str(ch)])
    axis([0 2400 -1 4])
    %hold off
    %         subplot(2,1,2)
    %
    %         ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC18'],'EC18',ch,[],2,[],[]);
    %         colormap(gray)
    %r=input('next')
    
end



%% select data section to look at
%% Usetrials_A, usetrials_P selected from behavioral data on excel
event=5;
type=1;
samps=1000:size(zScoreall(type).data{event},2);
d=mean(zScoreall(type).data{event}(:,samps,usetrials_A),3);

%Find peak timing from event
pki=zeros(1,256);
pk=zeros(1,256);
for n=1:256
    [tmp,tmpi]=max(d(n,:),[],2);
    if tmp>.5
        pki(n)=tmpi;
        pk(n)=tmp;
    end
end

[a,b]=sort(pki);
x=find(a>0,1,'first')
256-x



%% Plot zScores on brain image
%% Set cropped brain image as background

dpath='E:\General Patient Info\EC22'
imname=[dpath filesep 'brain+grid_3Drecon_cropped.jpg']
coltot=16;
event=1

figure
set(gcf,'Color','w')
ha = axes('units','normalized','position',[0 0 1 1]);
cd(dpath)
[xy_org,img] = eCogImageRegister(imname,0);
hi=imagesc(img);
colormap(gray)
set(ha,'handlevisibility','off')
imgsize=size(img);
xy(1,:)=xy_org(1,:)/imgsize(2);
xy(2,:)=1-xy_org(2,:)/imgsize(1);
%%

% Plot individual selected zscores on brain image

for i=x:256
    ch=b(i);
    
    if ismember(ch,badChannels)
        continue;
    end
    m=floor(ch/coltot);
    n=rem(ch,coltot);
    
    if n==0
        n=coltot;
        m=m-1;
    end
    
    
    
    
    
    
    
    xy_coord=xy(:,ch);
    axes('position',[xy_coord(1),xy_coord(2),.04,.04]);
    %%if plotting subplots
    %     p(1)=6*(n-1)/100+.03;
    %     p(2)=6.2*(15-m)/100+0.01;
    %
    %     p(3)=.055;
    %     p(4)=.055;
    %     h=subplot('Position',p);
    
    
    
    
    
    %hl=line([1200 1200],[-1 3]);
    hl=line([1200 1200],[-1 3]);
    
    %set(hl,'Color','r')
    set(hl,'Color','k');
    %title([num2str(ch)])
    hold on
    
    
    %subplot('Position',[xy_coord(1) xy_coord(2) xy_coord(1)+10 xy_coord(2)+1]);
    
    %     Y=zScoreall(2).data{event};
    %     zScore{i}=mean(Y,3);
    %     E = std(Y,[],3)/sqrt(size(Y,3));
    %     plot(zScore{i}(ch,:),'g')
    %     hold on
    %
    %     X=1:size(Y,2);
    %     hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'y');
    %     set(hp,'FaceAlpha',.5)
    %     set(hp,'EdgeColor','none')
    
    
    Y=zScoreall(1).data{event}(ch,:,:,:);
    [~,badtr]=find(squeeze(Y)>30);
    usetr=setdiff(1:size(Y,3),badtr);
    zScore=mean(Y(:,:,usetr),3);
    E = std(Y,[],3)/sqrt(size(Y,3));
    plot(zScore,'b','LineWidth',.7);
    set(gca,'Color','none');
    miny=min(zScore);
    
    
    %text(p(1),p(2),int2str(ch))
    hold off
    
    %     X=1:size(Y,2);
    %     hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'m');
    %     set(hp,'FaceAlpha',.5)
    %     set(hp,'EdgeColor','none')
    
    %axis([0 4000 -1 1])
    %set(gca,'XTick',[0:400:2400]);
    %set(gca,'XTickLabel',[-3:1:3])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'Box','off');
    set(gca,'visible','off');
    
    
    try
        %axis([0 2400 miny 3]);
        
    end
    %hold off
    %         subplot(2,1,2)
    %
    %         ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC18'],'EC18',ch,[],2,[],[]);
    %         colormap(gray)
    %r=input('next')
    
end
%% Plot selected channel numbers on brain image
figure
ECogDataVis (dpath,'EC18',b(1:254),[],2,[],[]);
ECogDataVis (['E:\General Patient Info\EC18_v2'],'EC18',b(x:254),[],2,[],[]); %Cropped brain
%
colormap(gray)
%% Plot amplitudes as disks on figure
d=mean(zScoreall(1).data{event}(:,1200:1800,:),3);
%d=mean(zScoreall(1).data{event}(:,1600:2800,:),3);

%d=mean(zScoreall(2).data{2}(:,1000:end,:),3);

figure
p=1
for n=1:40:1000
    subplot(5,5,p)
    data=mean(d(:,n:n+39),2);
    %data=mean(d1(:,n:n+39),2)-mean(d(:,n:n+39),2);
    ECogDataVis(dpath,subject,1:256,data,1,[],[]);
    p=p+1;
    printf(int2str(n))
    %r=input('next')
end



%%
%Plot electrode location, zscore score time series, and single stacked
figure
cond=2;
type=1;
type2=1;
type3=1;

usetrials_P=[];


usetrials_ALE=usetrials(find(usetrials(:,3)),3);
usetrials_ALH=usetrials(find(usetrials(:,2)),2);
usetrials_AS=usetrials(find(usetrials(:,4)),4);

usetrials_PLE=usetrials(find(usetrials(:,6)),6);
usetrials_PLH=usetrials(find(usetrials(:,7)),7);
usetrials_PS=usetrials(find(usetrials(:,8)),8);

set(gcf,'Color','w')

plotcount=1;
for i=x:256
    
    ch=b(i)
    
    e=squeeze(zScoreall(1).eventTS{event});
    e=e(samps,usetrials_A);
    for t=1:size(e,2)
        try
            rt(t)=find(e(:,t)==cond,1,'first');
        catch
            rt(t)=NaN;
        end
    end
    Y1=zScoreall(type).data{event}(ch,:,usetrials_A);
    
    
    rt=rt(abs(zscore(rt))<4)
    [idx,v]=sort(rt);
    Y_A=Y1(1,:,v(find(~isnan(idx))));
    
    if isempty(Y_A)
        Y_A=Y1;
    end
    yheight=(plotcount-1)*.25;
    
    
    %Plot electrode location on brain image
    %subplot(4,3,plotcount)
    subplot('Position',[.05 .05+yheight .2 .17])
    ECogDataVis (['E:\General Patient Info\EC18_v2'],'EC18',ch,[],2,[],[]); %Cropped brain
    colormap(gray)
    freezeColors
    set(gca,'Visible','off')
    hold off
    
    %Plot zscore and stats
    %subplot(4,3,plotcount+1)
    subplot('Position',[.3 .05+yheight .35 .17])
    set(gca,'FontSize',7)
    ylabel('z-score')
    xlabel('time (sec)')
    
    try
        
        Y=zScoreall(type2).data{event}(ch,:,usetrials_P);
        mean_Z=mean(Y,3);
        E = std(Y,[],3)/sqrt(size(Y,3));
        plot(mean_Z,'g')
        hold on
        
        X=1:size(Y,2);
        hp=patch([X, fliplr(X)], [mean_Z+E,fliplr(mean_Z)-E],'y');
        set(hp,'FaceAlpha',.5)
        set(hp,'EdgeColor','none')
    end
    %plot mean zscore and ste for Active trials
    Y=Y_A;
    mean_Z=mean(Y,3);
    E = std(Y,[],3)/sqrt(size(Y,3));
    plot(mean_Z,'k');
    hold on
    
    X=1:size(Y,2);
    hp=patch([X, fliplr(X)], [mean_Z+E,fliplr(mean_Z-E)],'m');
    set(hp,'FaceAlpha',.5)
    set(hp,'EdgeColor','none')
    
    %axis([0 4000 -1 1])
    set(gca,'XTick',[0:400:2400])
    set(gca,'XTickLabel',[-3:1:3])
    hl=line([1200 1200],[-1 5])
    %set(hl,'Color','r')
    set(hl,'Color','r')
    title(['electrode ' num2str(ch)])
    axis([0 2400 -1 4])
    xlabel('time (sec)')
    ylabel('zscore')
    hold off
    
    
    %Plot stacked plots
    %subplot(4,3,plotcount+2)
    subplot('Position',[.7 .05+yheight .25 .17])
    set(gca,'FontSize',7)
    ylabel('Trial # (sorted)')
    xlabel('time (sec)')
    
    imagesc(squeeze(Y)',[-0 2])
    hold on
    colormap(flipud(gray))
    hl=line([1200 1200],[0 size(Y,3)])
    set(hl,'Color','r')
    set(gca,'XTick',[0:400:2400])
    set(gca,'XTickLabel',[-3:1:3])
    try
        plot(1000+idx(~isnan(idx)),1:size(Y,3),'r');
    end
    plotcount=plotcount+1;
    hold off
    
    if plotcount>4
        plotcount=1;
        input('next ')
        %figure
    end
    
end



%%
%Plot electrode location, zscore score time series, and single stacked
figure
cond=2;
type=1;
type2=1;
type3=1;

usetrials_P=[];


usetrials_ALE=usetrials(find(usetrials(:,3)),3);
usetrials_ALH=usetrials(find(usetrials(:,2)),2);
usetrials_AS=usetrials(find(usetrials(:,4)),4);

usetrials_PLE=usetrials(find(usetrials(:,6)),6);
usetrials_PLH=usetrials(find(usetrials(:,7)),7);
usetrials_PS=usetrials(find(usetrials(:,8)),8);

usetrialsall(1).name=usetrials_AS;
usetrialsall(2).name=usetrials_ALE;
usetrialsall(3).name=usetrials_ALH;

cond=4

set(gcf,'Color','w')
usetrials_A=[usetrials_AS;usetrials_ALE; usetrials_ALH];
plotcount=1;
%%
for i=x:256
    Y_A2=[];
    idx2=[];
    ch=b(i)
    
    
    for count=1:3
        e=squeeze(zScoreall(1).eventTS{event});
        
        usetrials_A=usetrialsall(count).name;
        e=e(samps,usetrials_A);
        for t=1:size(e,2)
            try
                rt(t)=find(e(:,t)==cond,1,'first');
            catch
                rt(t)=NaN;
            end
        end
        Y1=zScoreall(type).data{event}(ch,:,usetrials_A);
        
        
        rt=rt(abs(zscore(rt))<4);
        [idx,v]=sort(rt);
        Y_A=Y1(1,:,v(find(~isnan(idx))));
        
        if isempty(Y_A)
            Y1=zScoreall(type).data{event}(ch,:,usetrials_A);
            Y_A=Y1;
        end
        Y_A2=cat(3,Y_A2,Y_A);
        idx2=[idx2 idx];
    end
    Y_A=Y_A2;
    idx=idx2;
    yheight=(plotcount-1)*.25;
    
    
    %Plot electrode location on brain image
    %subplot(4,3,plotcount)
    subplot('Position',[.05 .05+yheight .2 .17])
    ECogDataVis (['E:\General Patient Info\EC18_v2'],'EC18',ch,[],2,[],[]); %Cropped brain
    colormap(gray)
    freezeColors
    set(gca,'Visible','off')
    hold off
    
    %Plot zscore and stats
    %subplot(4,3,plotcount+1)
    subplot('Position',[.3 .05+yheight .35 .17])
    set(gca,'FontSize',7)
    ylabel('z-score')
    xlabel('time (sec)')
    hold off
    
    
    
    
    %     Y=zScoreall(2).data{event}(ch,:,usetrials_PS);
    %     mean_Z=mean(Y,3);
    %     plot(mean_Z,'r')
    %         hold on
    %
    %
    %     Y=zScoreall(2).data{event}(ch,:,usetrials_PLE);
    %     mean_Z=mean(Y,3);
    %     plot(mean_Z,'g')
    %
    %      Y=zScoreall(2).data{event}(ch,:,usetrials_PLH);
    %     mean_Z=mean(Y,3);
    %     plot(mean_Z,'k')
    %
    %     usetrials_wordlength= [usetrials_PS; usetrials_PLE; usetrials_PLH]
    %     type=2;
    
    
    
    Y=zScoreall(1).data{event}(ch,:,usetrials_AS);
    mean_Z=mean(Y,3);
    plot(mean_Z,'r')
    hold on
    
    Y=zScoreall(1).data{event}(ch,:,usetrials_ALE);
    mean_Z=mean(Y,3);
    plot(mean_Z,'b')
    hold on
    
    Y=zScoreall(1).data{event}(ch,:,usetrials_ALH);
    mean_Z=mean(Y,3);
    plot(mean_Z,'k')
    %usetrials_wordlength=[usetrials_AS; usetrials_ALE; usetrials_ALH];
    
    %
    
    
    %axis([0 4000 -1 1])
    set(gca,'XTick',[0:400:2400])
    set(gca,'XTickLabel',[-3:1:3])
    hl=line([1200 1200],[-1 5])
    set(hl,'Color','r');
    title(['electrode ' num2str(ch)]);
    axis([0 2400 -1 4]);
    xlabel('time (sec)');
    ylabel('zscore');
    hold off
    
    
    %Plot stacked plots
    %subplot(4,3,plotcount+2)
    subplot('Position',[.7 .05+yheight .25 .17]);
    set(gca,'FontSize',7);
    ylabel('Trial # (sorted)');
    xlabel('time (sec)')   ;
    
    
    %     Y=events{event}(2,:,usetrials_AS);
    %     mean_Z=mean(Y,3);
    %     plot(mean_Z,'r');
    %     hold on
    %
    %     Y=events{event}(2,:,usetrials_ALE);
    %     mean_Z=mean(Y,3);
    %     plot(mean_Z+.1,'b');
    %
    %     Y=events{event}(2,:,usetrials_ALE);
    %     mean_Z=mean(Y,3);
    %     plot(mean_Z+.2,'k');
    %
    %     hl=line([3*fs 3*fs],[0 .4]);
    %     set(hl,'Color','r');
    %     axis tight
    %     hold off
    
    %Y=zScoreall(type).data{event}(ch,:,usetrials_wordlength);
    Y=Y_A2;
    imagesc(squeeze(Y)',[-0 2])
    hold on
    colormap(flipud(gray))
    hl=line([1200 1200],[0 size(Y,3)])
    set(hl,'Color','r')
    set(gca,'XTick',[0:400:2400])
    set(gca,'XTickLabel',[-3:1:3])
    
    try
        plot(1000+idx(~isnan(idx)),1:size(Y,3),'r');
    end
    plotcount=plotcount+1;
    
    if plotcount>4
        plotcount=1;
        input('next ')
        %figure
    end
    
end

%% Check analog segmentation
figure
for i=1:55
    subplot(2,1,1)
    plot(a(2,:,i))
    hold on
    hl=line([3*fs 3*fs ],[-1 1]);
    set(hl,'Color','r')
    title(int2str(i))
    
    hold off
    
    subplot(2,1,2)
    specgram(a(2,:,i))
    hold on
    hl=line([3*fs/2  3*fs/2 ],[0 1]);
    set(hl,'Color','r')
    hold off
    input('n')
end

%% Plot zscore by all segments
figure
set(gcf,'Color','w')
aligned=5000
alignedfs=(aligned/1000)*400;
keep=[];
maxY=9;
minY=-4
%%
for i=x:length(b)
    
    ch=b(i)
    type=1;
    event=1;
    subplot(1,5,event)
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,:));
    E=std(Y,[],2)/sqrt(size(Y,2));
    subplot(1,5,1)
    errorarea(mean(Y,2),E);
    hp=line([800 800],[ minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY,'slide')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600])
    set(gca,'XTickLabel',[-2 -1 0 1 2])
    title(int2str(ch))
    %hold on
    
    event=2;
    subplot(1,5,event)
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,:));
    E=std(Y,[],2)/sqrt(size(Y,2));
    errorarea(mean(Y,2),E);
    hp=line([800 800],[minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY,'word start')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600])
    set(gca,'XTickLabel',[-2 -1 0 1 2])
    %hold on
    
    event=3;
    subplot(1,5,event)
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,:));
    E=std(Y,[],2)/sqrt(size(Y,2));
    errorarea(mean(Y,2),E);
    hp=line([800 800],[minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY,'word end')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600])
    set(gca,'XTickLabel',[-2 -1 0 1 2])
    % hold on
    
    event=4;
    subplot(1,5,event)
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,:));
    E=std(Y,[],2)/sqrt(size(Y,2));
    errorarea(mean(Y,2),E);
    hp=line([800 800],[minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY,'beep')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600])
    set(gca,'XTickLabel',[-2 -1 0 1 2])
    %hold on
    
    try
        event=5;
        subplot(1,5,event)
        Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+4*400,:));
        E=std(Y,[],2)/sqrt(size(Y,2));
        errorarea(mean(Y,2),E);
        hp=line([800 800],[ minY maxY]);
        set(hp,'Color','r')
        ht=text(805, maxY,'response')
        set(ht,'Color','r')
        axis([0 2400 minY maxY])
        set(gca,'XTick',[0:400:2400])
        set(gca,'XTickLabel',[-2 -1 0 1 2 3 4])
        %hold on
        
    end
    
    %     type=2;
    %     event=1;
    %     subplot(1,5,event)
    %     Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,:));
    %     E=std(Y,[],2)/sqrt(size(Y,2));
    %     subplot(1,5,1)
    %     [hpl,hpp]=errorarea(mean(Y,2),E);
    %     set(hpl,'Color','r')
    %     set(hpp,'FaceColor','m')
    %
    %     hp=line([800 800],[ 0 3]);
    %     set(hp,'Color','r')
    %     ht=text(805, 2.5,'slide')
    %     set(ht,'Color','r')
    %     axis([0 1600 0 3])
    %     set(gca,'XTick',[0:400:1600])
    %     set(gca,'XTickLabel',[-2 -1 0 1 2])
    %     title(int2str(ch))
    %     hold off
    %
    %
    %         event=2;
    %     subplot(1,5,event)
    %     Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,:));
    %     E=std(Y,[],2)/sqrt(size(Y,2));
    %   [hpl,hpp]=errorarea(mean(Y,2),E);
    %     set(hpl,'Color','r')
    %     set(hpp,'FaceColor','m')
    %     hp=line([800 800],[ 0 3]);
    %     set(hp,'Color','r')
    %         ht=text(805, 2.5,'word start')
    %     set(ht,'Color','r')
    %     axis([0 1600 0 3])
    %        set(gca,'XTick',[0:400:1600])
    %     set(gca,'XTickLabel',[-2 -1 0 1 2])
    %         hold off
    %
    %         event=3;
    %     subplot(1,5,event)
    %      Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,:));
    %     E=std(Y,[],2)/sqrt(size(Y,2));
    %   [hpl,hpp]=errorarea(mean(Y,2),E);
    %     set(hpl,'Color','r')
    %     set(hpp,'FaceColor','m')
    %     hp=line([800 800],[ 0 3]);
    %     set(hp,'Color','r')
    %         ht=text(805, 2.5,'word end')
    %     set(ht,'Color','r')
    %     axis([0 1600 0 3])
    %        set(gca,'XTick',[0:400:1600])
    %     set(gca,'XTickLabel',[-2 -1 0 1 2])
    %         hold off
    %
    %         event=4;
    %     subplot(1,5,event)
    %      Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,:));
    %     E=std(Y,[],2)/sqrt(size(Y,2));
    %   [hpl,hpp]=errorarea(mean(Y,2),E);
    %     set(hpl,'Color','r')
    %     set(hpp,'FaceColor','m')
    %     hp=line([800 800],[ 0 3]);
    %     set(hp,'Color','r')
    %         ht=text(805, 2.5,'beep')
    %     set(ht,'Color','r')
    %     axis([0 1600 0 3])
    %        set(gca,'XTick',[0:400:1600])
    %     set(gca,'XTickLabel',[-2 -1 0 1 2])
    %     hold off
    %     try
    %             event=5;
    %         subplot(1,5,event)
    %          Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+4*400,:));
    %         E=std(Y,[],2)/sqrt(size(Y,2));
    %         errorarea(mean(Y,2),E);
    %         hp=line([800 800],[ 0 3]);
    %         set(hp,'Color','r')
    %             ht=text(805, 2.5,'response')
    %         set(ht,'Color','r')
    %         axis([0 2400 0 3])
    %            set(gca,'XTick',[0:400:2400])
    %         set(gca,'XTickLabel',[-2 -1 0 1 2 3 4])
    %     end
    %             hold off
    
    r=input('Next\n','s')
    if strmatch(r,'y')
        keep=[keep ch];
    elseif strmatch(r,'b')
        i=i-2;
    end
end

%% PLot segments zScore, reject bad trials try median

figure
set(gcf,'Color','w')
aligned=3000
alignedfs=(aligned/1000)*400;
keep=0;
maxY=9;
minY=-4


buffer=3;

set(gca,'XTick',[0:400:2400]);
set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
plotrows=1
hFigure=figure
hFigure1=figure
hFigure2=figure

eventtext={'slide','word onset','word offset','beep','response onset'}
%%
i=keep(end)
while i<=256
    
    ch=b(i)
    type=1;
    event=1;
    for event=1:5
        set(0,'CurrentFigure',hFigure1)


        subplot(plotrows,5,event)

        [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);

        usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
        Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-buffer*400+1:alignedfs+buffer*400,usetrials));
        E=std(Y,[],2)/sqrt(size(Y,2));
        errorarea(mean(Y,2),E);
        hp=line([alignedfs alignedfs],[ minY maxY]);
        set(hp,'Color','r')
        ht=text(alignedfs+5, maxY-2,eventtext{event})
        set(ht,'Color','r')
        axis([0 2400 minY maxY])
        set(gca,'XTick',[0:400:2400]);
        set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
        %title(int2str(ch))
        %set(gcf,'Name',int2str(ch))
        title(['N=' int2str(length(usetrials))])



        set(0,'CurrentFigure',hFigure2)

        subplot(plotrows,5,event)

        imagesc(Y',[0 5])
        %pcolor(tmp);
        colormap(flipud(pink))
             hold on
             plot([alignedfs alignedfs+.001],[0 length(usetrials)],'r')
               plot(alignedfs+zScoreall(type).rt{event}(usetrials),1:length(usetrials),'r')
            hold off
      %axis([0 1600 minY maxY])
        set(gca,'XTick',[0:400:2400]);
        set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
    
    
    end
    
    
    set(0,'CurrentFigure',hFigure)
    %figure(hFigure)
    %subplot(2,5,6)
    visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',ch)
    colormap gray
    
    
    
    r=input('Next\n','s')
    if strcmp('y',r)
        
        keep=[keep ch];
    elseif strcmp('b',r)
       i=i-2;
    end
    i=i+1;
end



%%

for i=x:length(b)
    ch=b(i)
    type=1;
    event=1;
    set(0,'CurrentFigure',hFigure1)
    
    
    subplot(plotrows,5,event)
    
    [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);
    
    usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,usetrials));
    E=std(Y,[],2)/sqrt(size(Y,2));
    errorarea(mean(Y,2),E);
    hp=line([800 800],[ minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY-2,'slide')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:2400]);
    set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
    %title(int2str(ch))
    %set(gcf,'Name',int2str(ch))
    title(['N=' int2str(length(usetrials))])
    
    
     
    set(0,'CurrentFigure',hFigure2)
    
    subplot(plotrows,5,event)
    
    imagesc(Y',[0 5])
    %pcolor(tmp);
    colormap(flipud(pink))
         hold on
         plot([800 800+.001],[0 length(usetrials)],'r')
           plot(800+zScoreall(type).rt{event},1:length(usetrials),'r')
        hold off
  %axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600]);
    set(gca,'XTickLabel',[-2 -1 0 1 2 ])
    
    
    %     hold on
    %     plot(median(Y,2),'r')
    %     hold off
    %hold on
    
        set(0,'CurrentFigure',hFigure1)

    event=2;
    [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);
    
    usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
    subplot(plotrows,5,event)
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,usetrials));
    E=std(Y,[],2)/sqrt(size(Y,2));
    errorarea(mean(Y,2),E);
    hp=line([800 800],[minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY-2,'word start')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:2400]);
    set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
    %hold on
    %          hold on
    %     plot(median(Y,2),'r')
    %     hold off
    title(['N=' int2str(length(usetrials))])
    
    
    
    set(0,'CurrentFigure',hFigure2)
    
    subplot(plotrows,5,event)
    
    imagesc(Y',[0 5])
    %pcolor(tmp);
    colormap(flipud(pink))
         hold on
         plot([800 800+.001],[0 length(usetrials)],'r')
           plot(800+zScoreall(type).rt{event},1:length(usetrials),'r')
        hold off
  %axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600]);
    set(gca,'XTickLabel',[-2 -1 0 1 2 ])
    
    
    
        set(0,'CurrentFigure',hFigure1)

    event=3;
    [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);
    
    usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
    subplot(plotrows,5,event)
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,usetrials));
    E=std(Y,[],2)/sqrt(size(Y,2));
    errorarea(mean(Y,2),E);
    hp=line([800 800],[minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY-2,'word end')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600]);
    set(gca,'XTickLabel',[-2 -1 0 1 2 ])
    % hold on
    %         hold on
    %     plot(median(Y,2),'r')
    %     hold off
    title(['N=' int2str(length(usetrials))])
    
    
    set(0,'CurrentFigure',hFigure2)
    
    subplot(plotrows,5,event)
    
    imagesc(Y',[0 5])
    %pcolor(tmp);
    colormap(flipud(pink))
         hold on
         plot([800 800+.001],[0 length(usetrials)],'r')
           plot(800+zScoreall(type).rt{event},1:length(usetrials),'r')
        hold off
  %axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600]);
    set(gca,'XTickLabel',[-2 -1 0 1 2 ])
    
        set(0,'CurrentFigure',hFigure1)

    
    event=4;
    [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);
    
    usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
    subplot(plotrows,5,event)
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,usetrials));
    E=std(Y,[],2)/sqrt(size(Y,2));
    errorarea(mean(Y,2),E);
    hp=line([800 800],[minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY-2,'beep')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600]);
    set(gca,'XTickLabel',[-2 -1 0 1 2 ])
    %hold on
    %        hold on
    %     plot(median(Y,2),'r')
    %     hold off
    title(['N=' int2str(length(usetrials))])
     title(['N=' int2str(length(usetrials))])
    
    
    set(0,'CurrentFigure',hFigure2)
    
    subplot(plotrows,5,event)
    
    imagesc(Y',[0 5])
    %pcolor(tmp);
    colormap(flipud(pink))
         hold on
         plot([800 800+.001],[0 length(usetrials)],'r')
           plot(800+zScoreall(type).rt{event},1:length(usetrials),'r')
        hold off
  %axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600]);
    set(gca,'XTickLabel',[-2 -1 0 1 2 ])    
    
    
    try
            set(0,'CurrentFigure',hFigure1)

         event=5;
    [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);
    
    usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
    subplot(plotrows,5,event)
    Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-2*400:alignedfs+2*400,usetrials));
    E=std(Y,[],2)/sqrt(size(Y,2));
    errorarea(mean(Y,2),E);
    hp=line([800 800],[minY maxY]);
    set(hp,'Color','r')
    ht=text(805, maxY-2,'beep')
    set(ht,'Color','r')
    axis([0 1600 minY maxY])
axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600]);
    set(gca,'XTickLabel',[-2 -1 0 1 2 ])
    %hold on
    %        hold on
    %     plot(median(Y,2),'r')
    %     hold off
    title(['N=' int2str(length(usetrials))])
     title(['N=' int2str(length(usetrials))])
    
    set(0,'CurrentFigure',hFigure2)
    
    subplot(plotrows,5,event)
    
    imagesc(Y',[0 5])
    %pcolor(tmp);
    colormap(flipud(pink))
         hold on
         plot([800 800+.001],[0 length(usetrials)],'r')
           plot(800+zScoreall(type).rt{event},1:length(usetrials),'r')
        hold off
  %axis([0 1600 minY maxY])
    set(gca,'XTick',[0:400:1600]);
    set(gca,'XTickLabel',[-2 -1 0 1 2 ])
    
    
    
    catch
        
    end
    
    
    %     set(0,'CurrentFigure',hFigure2)
    %
    %     event=1;
    %         subplot(plotrows,5,event)
    %
    %      tmp=squeeze(zScoreall(1).data{event}(ch,:,:))';
    %      imagesc(tmp,[0 5])
    %     %pcolor(tmp);
    %       colormap(flipud(pink))
    %     hold on
    %      plot([2000 2000+.001],[0 size(zScoreall(type).data{event}(ch,:,:),3)],'r')
    %     hold off
    %     set(gca,'XTick',[0:400:4000]);
    %     set(gca,'XTickLabel',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
    %
    %     event=2;
    %         subplot(plotrows,5,event)
    %
    %      tmp=squeeze(zScoreall(1).data{event}(ch,:,:))';
    %      imagesc(tmp,[0 5])
    %     %pcolor(tmp);
    %          colormap(flipud(pink))
    %
    %     hold on
    %      plot([2000 2000+.001],[0 size(zScoreall(type).data{event}(ch,:,:),3)],'r')
    %     hold off
    %     set(gca,'XTick',[0:400:4000]);
    %     set(gca,'XTickLabel',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
    %
    %     event=3;
    %         subplot(plotrows,5,event)
    %
    %      tmp=squeeze(zScoreall(1).data{event}(ch,:,:))';
    %      imagesc(tmp,[0 5])
    %     %pcolor(tmp);
    %      caxis([0 10])
    %       colormap(flipud(pink))
    %       shading interp
    %     hold on
    %      plot([2000 2000+.001],[0 size(zScoreall(type).data{event}(ch,:,:),3)],'r')
    %     hold off
    %     set(gca,'XTick',[0:400:4000]);
    %     set(gca,'XTickLabel',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
    %
    %
    %
    %         event=4;
    %         subplot(plotrows,5,event)
    %
    %      tmp=squeeze(zScore_sorted{1}(ch,:,:))';
    %      imagesc(tmp,[0 5])
    %     %pcolor(tmp);
    %            colormap(flipud(pink))
    %
    %     hold on
    %      plot([2000 2000+.001],[0 size(zScoreall(type).data{event}(ch,:,:),3)],'r')
    %        plot([2000+rt],[1:size(zScoreall(type).data{event}(ch,:,:),3)],'r')
    %     hold off
    %     set(gca,'XTick',[0:400:4000]);
    %     set(gca,'XTickLabel',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
    %
    %     event=5;
    %         subplot(plotrows,5,event)
    %
    %      tmp=squeeze(zScoreall(1).data{event}(ch,:,:))';
    %      imagesc(tmp,[0 5])
    %     %pcolor(tmp);
    %            colormap(flipud(pink))
    %
    %     hold on
    %      plot([2000 2000+.001],[0 size(zScoreall(type).data{event}(ch,:,:),3)],'r')
    %     hold off
    %     set(gca,'XTick',[0:400:4000]);
    %     set(gca,'XTickLabel',[-5 -4 -3 -2 -1 0 1 2 3 4 5])
    
    
    set(0,'CurrentFigure',hFigure)
    %figure(hFigure)
    %subplot(2,5,6)
    visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',ch)
    colormap gray
    
    
    
    r=input('Next\n','s')
    if strmatch(r,'y')
        
        keep=[keep ch];
    elseif strmatch(r,'b')
        i=i-2;
    end
    
end
%%

%%
%Reconstruction

%Downsample to 100
for t=1:2
    for e=1:size(zScoreall(t).data,2)
        for c=1:size(zScoreall(t).data{e},1)
            for r=1:size(zScoreall(t).data{e},3)
                zScoreall100(t).data{e}(c,:,r)=resample(zScoreall(t).data{e}(c,:,r),1,4);
            end
        end
    end
end

figure



TestResp=zScoreall100(2).data{2}(:,:,2)';
TrainResp=zScoreall100(2).data{2}(:,:,1)';
StimTrain=squeeze(aud{1}(:,:,1))';
[g,rstim] = StimuliReconstruction (StimTrain, TrainResp, TestResp);

%%


for c=1:256
    [a,badtrials]=find(squeeze(zScore_11s{1}(c,:,:))>30);
    badtrialsperchan{c}=unique(badtrials);
end
