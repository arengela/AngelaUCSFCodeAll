load C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\zScoreall2_EC18_Active_Passive_3000to3000.mat

load C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\baseline_EC18;
load C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\usetrials;
%% select data section to look at
%% Usetrials_A, usetrials_P selected from behavioral data on excel
event=3;
type=1;
samps=800:size(zScoreall(type).data{event},2);
samps=1200:2000
usetrials_A=usetrials(find(usetrials(:,1)),1);
d=mean(zScoreall(type).data{event}(:,samps,usetrials_A),3);


%% Find peak timing from event
pki=zeros(1,256);
pk=zeros(1,256);
for n=1:256
    [tmp,tmpi]=max(d(n,:),[],2);
    if tmp>.3
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
usetrials_P=usetrials(find(usetrials(:,5)),5);
for i=x:256
    subplot(6,10,i-x+1)
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
event=3;
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

figure
set(gcf,'Color','w')
ha = axes('units','normalized','position',[0 0 1 1]);
%cd('E:\General Patient Info\EC18_v3')
%imname='E:\General Patient Info\EC18_v3\brain+grid_3Drecon_cropped.jpg'
[xy_org,img] = eCogImageRegister(imname,0);
hi=imagesc(img);
colormap(gray)
set(ha,'handlevisibility','off')
imgsize=size(img);
xy(1,:)=xy_org(1,:)/imgsize(2);
xy(2,:)=1-xy_org(2,:)/imgsize(1);


% Plot individual selected zscores on brain image

for i=x:256
    %subplot(8,6,i-x+1-59)
    %subplot(2,1,1)
    ch=b(i);
    %ch=i;
    xy_coord=xy(:,ch);
    axes('position',[xy_coord(1),xy_coord(2),.05,.05]);
    hl=line([400 400],[-1 3]);
    set(hl,'Color','r')
    set(hl,'Color','w');
    %title([num2str(ch)])
    hold on
    %filledCircle([xy_coord(1),xy_coord(2)],.1,10,p(45,:))
%     Y=zScoreall(1).data{event}(ch,:,:);
%     Y2=zScoreall(2).data{event}(ch,:,:);
%     mean_Y=mean(Y,3)-mean(Y2,3);
%     E = std(Y,[],3)/sqrt(size(Y,3));
%     plot(mean_Y,'r','LineWidth',.7);
    try
        Y=zScoreall(2).data{event}(ch,800:end,:);    
        mean_Y=mean(Y,3);
        E = std(Y,[],3)/sqrt(size(Y,3));
        plot(mean_Y,'g','LineWidth',.7);

        hold on
    end

    Y=zScoreall(1).data{event}(ch,800:end,:);    
    mean_Y=mean(Y,3);
    E = std(Y,[],3)/sqrt(size(Y,3));
    plot(mean_Y,'k','LineWidth',1);
    hold on
    

    
    set(gca,'Color','none');
    miny=min(mean_Y);
    
    
    
    hold off
    
    %     X=1:size(Y,2);
    %     hp=patch([X, fliplr(X)], [zScore{i}(ch,:)+E(ch,:),fliplr(zScore{i}(ch,:)-E(ch,:))],'m');
    %     set(hp,'FaceAlpha',.5)
    %     set(hp,'EdgeColor','none')
    
    
    %axis([0 4000 -1 1])
    set(gca,'XTick',[0:400:2400]);
    %set(gca,'XTickLabel',[-3:1:3])
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(gca,'Box','off');
    set(gca,'visible','off');
    
    
    try
        axis([0 2400 miny 3]);
        
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
ECogDataVis (['E:\General Patient Info\EC18'],'EC18',b(x:254),[],2,[],[]); 
ECogDataVis (['E:\General Patient Info\EC18_v2'],'EC18',b(x:254),[],2,[],[]); %Cropped brain

ECogDataVis (['E:\General Patient Info\EC18_v2'],'EC18',find(pki),pki(find(pki)),1,[],10); %Cropped brain
%%
%Plot peak time on brain
dpath='E:\General Patient Info\EC18_v2'
subject='EC18'
figure
ECogDataVis (dpath,subject,b(x:256),150-a(find(a)),6,[],[]);
%
ECogDataVis (dpath,subject,b(x:256),[],2,[],[]);

ECogDataVis (dpath,subject,[35 35],[1 1],6,[],[]);
colormap(gray)
%% Plot amplitudes as disks on figure
d=mean(zScoreall(1).data{event}(:,1200:1800,:),3);

%d=mean(zScoreall(2).data{2}(:,1000:end,:),3);

figure
p=1
for n=1:40:1000
    subplot(5,5,p)
    data=mean(d(:,n:n+39),2);
    %data=mean(d1(:,n:n+39),2)-mean(d(:,n:n+39),2);
    ECogDataVis(dpath,subject,1:256,data,1,[],.0002);
    p=p+1;
    printf(int2str(n))
    %r=input('next')
end



%%
%Plot electrode location, zscore score time series, and single stacked
figure
cond=3;
type=1;
type2=2;
type3=1;
event=2

usetrials_A=usetrials(find(usetrials(:,1)),1);
usetrials_ALE=usetrials(find(usetrials(:,3)),3);
usetrials_ALH=usetrials(find(usetrials(:,2)),2);
usetrials_AS=usetrials(find(usetrials(:,4)),4);

usetrials_P=usetrials(find(usetrials(:,5)),5);
usetrials_PLE=usetrials(find(usetrials(:,6)),6);
usetrials_PLH=usetrials(find(usetrials(:,7)),7);
usetrials_PS=usetrials(find(usetrials(:,8)),8);

set(gcf,'Color','w')

plotcount=1;
for i=1%x:256
%% 
    ch=b(i)   
    ch=35
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
event=2;
usetrials_P=[];
%%
usetrials_ALH=usetrials(find(usetrials(:,2)),2);
usetrials_ALE=usetrials(find(usetrials(:,3)),3);
usetrials_AS=usetrials(find(usetrials(:,4)),4);

usetrials_PLH=usetrials(find(usetrials(:,6)),6);
usetrials_PLE=usetrials(find(usetrials(:,7)),7);
usetrials_PS=usetrials(find(usetrials(:,8)),8);

usetrials_MLH=usetrials(find(usetrials(:,11)),11);
usetrials_MLE=usetrials(find(usetrials(:,10)),10);
usetrials_MS=usetrials(find(usetrials(:,9)),9);





cond=4
figure
set(gcf,'Color','w')
usetrials_A=[usetrials_MS;usetrials_MLE; usetrials_MLH];


usetrialsall(1).name=usetrials_MS;
usetrialsall(2).name=usetrials_MLE;
usetrialsall(3).name=usetrials_MLH;


usetrialsall(1).name=usetrials_AS;
usetrialsall(2).name=usetrials_ALE;
usetrialsall(3).name=usetrials_ALH;
usetrialsall(4).name=usetrials_PS;
usetrialsall(5).name=usetrials_PLE;
usetrialsall(6).name=usetrials_PLH;

%%
plotcount=1;
for i=1%x:256%[255 254 39 38]%1:256%1:4%256
  Y_A2=[];
  idx2=[];
    ch=b(i)   
    ch=237
    %ch=i
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
    clear rt
 end
    Y_A=Y_A2;
    idx=idx2;
    yheight=(plotcount-1)*.25;

    
    %Plot electrode location on brain image
    %subplot(4,3,plotcount)
    subplot('Position',[.05 .05+yheight .2 .17])
    ECogDataVis (dpath,'EC18',ch,[],2,[],[]); %Cropped brain
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
           Y=zScoreall(2).data{event}(ch,:,usetrialsall(4).name);
    mean_Z=mean(Y,3);
    plot(mean_Z,'m','LineWidth',1.5)
    hold on
    
    
    Y=zScoreall(1).data{event}(ch,:,usetrialsall(1).name); 
    mean_Z=mean(Y,3);
    plot(mean_Z,'r','LineWidth',1.5)
    hold on
    
    Y=zScoreall(1).data{event}(ch,:,usetrialsall(2).name);
    mean_Z=mean(Y,3);
    plot(mean_Z,'b','LineWidth',1.5)
        hold on

     Y=zScoreall(1).data{event}(ch,:,usetrialsall(3).name);
    mean_Z=mean(Y,3);
    plot(mean_Z,'k','LineWidth',1.5)
    
     
    
        set(gca,'XTick',[0:400:2400])
    set(gca,'XTickLabel',[-3:1:3])
    hl=line([1200 1200],[-1 5])
    set(hl,'Color','r');
    title(['electrode ' num2str(ch)]);
    %axis([0 2400 -1 4]);
    axis tight
    xlabel('time (sec)');
    ylabel('zscore');
    hold off

    
    
    
        subplot('Position',[.7 .05+yheight .25 .17]);

     set(gca,'FontSize',7)
    ylabel('z-score')
    xlabel('time (sec)')
    hold off
    
        Y=zScoreall(2).data{event}(ch,:,usetrialsall(4).name);
    mean_Z=mean(Y,3);
    plot(mean_Z,'m','LineWidth',1.5)
    hold on
        Y=zScoreall(2).data{event}(ch,:,usetrialsall(5).name);
    mean_Z=mean(Y,3);
    plot(mean_Z,'b','LineWidth',1.5)
    
     Y=zScoreall(2).data{event}(ch,:,usetrialsall(6).name);
    mean_Z=mean(Y,3);
    plot(mean_Z,'k','LineWidth',1.5)
    
 
    %usetrials_wordlength=[usetrials_AS; usetrials_ALE; usetrials_ALH];
    
%     
    
    
    %axis([0 4000 -1 1])
    set(gca,'XTick',[0:400:2400])
    set(gca,'XTickLabel',[-3:1:3])
    hl=line([1200 1200],[-1 5])
    set(hl,'Color','r');
    title(['electrode ' num2str(ch)]);
    %axis([0 2400 -1 4]);
    axis tight
    xlabel('time (sec)');
    ylabel('zscore');
    hold off

    
    %Plot stacked plots
    subplot(4,3,plotcount+2)
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
%     Y=Y_A2;
%     imagesc(squeeze(Y)',[-0 2])
%     hold on
%     colormap(flipud(gray))
%     hl=line([1200 1200],[0 size(Y,3)])
%     set(hl,'Color','r')
%     set(gca,'XTick',[0:400:2400])
%     set(gca,'XTickLabel',[-3:1:3])
%     
%     try
%         plot(1000+idx(~isnan(idx)),1:size(Y,3),'r');
%     end
        plotcount=plotcount+1;

    if plotcount>4      
        plotcount=1;
        %input('next ')
         response=input('n')
        if strmatch('y',response)
            i=i-4;
        end
        
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

end




