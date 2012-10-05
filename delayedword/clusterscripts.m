n=12
T=PLVtests(n)
test=T.Data
ch2=test.usechans
%%
knum=2
D=squeeze(test.segmentedEcog(1).zscore_separate(ch,:,:,[indices.cond1 indices.cond2]));
D=permute(D,[3,1,2]);
D2=reshape(D,size(D,1),[]);
[kgroup,c]=kmeans(D2,knum,'Distance','distance');

group=zeros(size(test.segmentedEcog(1).zscore_separate,1),1);
group(indices.cond1)=1;
group(indices.cond2)=2;
group=group(group~=0)
C=confusionmat(group,kgroup)


%% cluster data
knum=10
%D=mean(mean(test.segmentedEcog(1).zscore_separate,3),4);
usechans=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
D=mean(test.segmentedEcog(1).zscore_separate(usechans,:,:,:),4);
for i=1:size(D,1)
    Dds(i,:)=resample(D(i,:),1,4);
    Dsmooth(i,:)=smooth(Dds(i,:));
end


D2=reshape(D,length(usechans),[]);
[kgroup,c]=kmeans(D2,knum,'Distance','correlation');
subset1=1:length(usechans);
kgroup1=kgroup;

%% cluster data round 2
knum=5
kidx=[2 4]
kgroup1=kgroup;
subset2=find(ismember(kgroup1,kidx));
D2=D(subset2,:,:);
D2=reshape(D2,length(subset2),[]);
[kgroup,c]=kmeans(D2,knum,'Distance','correlation');

%% view centroids
figure
for i=1:knum
    subplot(1,knum,i)
    imagesc(flipud(reshape(c(i,:),1600,40)'))
end

figure
for i=1:knum
    subplot(1,knum,i)
    plot(c(i,:))
end

%% plot all groups and locations
figure
for k=1:knum,
    subplot(3,knum,k);
    idx=find(kgroup==k);

    plot(D(idx,:)');
    %imagesc(flipud(squeeze(mean(D(subset(idx),:,:),1))'))
    colormap(jet)
    line([800 800],[ -1 3]);
    freezeColors
    axis tight;
    subplot(3,knum,k+knum);
    visualizeGrid(0,['E:\General Patient Info\' test.patientID '\brain.jpg'],usechans(subset1(idx)));

    Rmat(k).mat=zeros(length(idx));
    for i=1:length(idx)
        for j=i:length(idx)
            a=squeeze(D(subset1(idx(i)),:,:));
            b=squeeze(D(subset1(idx(j)),:,:));
            tmp=corrcoef(a,b);
            Rmat(k).mat(i,j)=tmp(1,2);
        end
    end
    subplot(3,knum,k+knum*2)
    imagesc(Rmat(k).mat)
    colormap(jet);freezeColors;
end

%%

%% plot all groups and locations: ROUND 2
figure
for k=1:knum,
    subplot(3,knum,k);
    idx=find(kgroup==k);
    plot(D2(idx,:)');
    %imagesc(flipud(squeeze(mean(D(subset(idx),:,:),1))'))
    colormap(jet)
    line([800 800],[ -1 3]);
    freezeColors
    axis tight;
    subplot(3,knum,k+knum);
    visualizeGrid(0,['E:\General Patient Info\' test.patientID '\brain.jpg'],usechans(subset1(subset2(idx))));

    Rmat(k).mat=zeros(length(idx));
    for i=1:length(idx)
        for j=i:length(idx)
            a=squeeze(D(subset2(idx(i)),:,:));
            b=squeeze(D(subset2(idx(j)),:,:));
            tmp=corrcoef(a,b);
            Rmat(k).mat(i,j)=tmp(1,2);
        end
    end
    subplot(3,knum,k+knum*2)
    imagesc(Rmat(k).mat)
    colormap(jet);freezeColors;
end
%% plot groups and locations one at a time
powerpoint_object=SAVEPPT2('test','init')
figure
for i=1:knum,
    subplot(2,1,1);
    %plot(D(find(kgroup==i),:)');
    imagesc(flipud(squeeze(mean(D(find(kgroup==i),:,:),1))'))
    colormap(jet)
    axis tight
    freezeColors
    line([800 800],[ -1 3]);
    title(int2str(i))
    axis tight; subplot(2,1,2);   
    visualizeGrid(0,['E:\General Patient Info\' test.patientID '\brain.jpg'],test.usechans(find(kgroup==i)));

    %visualizeGrid(2,['E:\General Patient Info\' test.patientID '\brain.jpg'],ch2(find(kgroup==i)));
    %SAVEPPT2('ppt',powerpoint_object,'stretch','off');
    input('n'),
end
%%
figure
colorlist=jet

colorstep=round(linspace(1,length(colorlist),knum));

for i=1:knum,        
    plot(mean(D(find(kgroup==i),:),1)','Color',colorlist(colorstep(i),:));
    hold on
    name{i}=num2str(i);
end
legend(name)
line([800 800],[ -1 3]);
%%
n=1
areamap(n).kclusters.onset=test.usechans([find(kgroup==4)' find(kgroup==8)'])
areamap(n).kclusters.language1=test.usechans(find(kgroup==1))
areamap(n).kclusters.allsounds=test.usechans(find(kgroup==10))
areamap(n).kclusters.language2=test.usechans(find(kgroup==5))
areamap(n).kclusters.slidesound=[]
areamap(n).kclusters.delayedsound=test.usechans(kgroup==9)
%%

n=4
areamap(n).kclusters2.onset=test.usechans(find(kgroup==3))
areamap(n).kclusters2.onset2=test.usechans(find(kgroup==9))
areamap(n).kclusters2.onset3=test.usechans(find(kgroup==6))
areamap(n).kclusters2.onset4=test.usechans(find(kgroup==10))
areamap(n).kclusters2.onset5=ch2(find(kgroup==7))

%%
fieldName=fieldnames(areamap(n).kclusters2)
colorlist=jet

colorstep=round(linspace(1,length(colorlist),length(fieldName)));
clear channelHold
figure
for i=1:length(fieldName)
    ch=getfield(areamap(n).kclusters2,fieldName{i});
    chidx=find(ismember(test.usechans,ch));
    d=mean(mean(D(chidx,:,:,:),3),4);
    plot(mean(d,1),'Color',colorlist(colorstep(i),:),'LineWidth',2.5)'
    %[hl,hp]=errorarea(mean(d,1),std(d,[],1))
    %set(hl,'Color',colorlist(colorstep(i),:))
    %set(hp,'FaceColor',colorlist(colorstep(i),:))
    %set(hp,'FaceAlpha',.5)
    channelHold{i}=ch;
    hold on
end
hl=line([800 800],[-1 3]);
set(hl,'Color','k')
set(hl,'LineStyle','--')
set(hl,'LineStyle','--')

legend(fieldName)
hold off
areamap(n).kclusters2.active=unique(vertcat(channelHold{:}))'

areamap(n).kclusters2.active=unique(horzcat(channelHold{:}))
%%
%areamap(n).kclusters.active=unique(find(ismember(kgroup,[2 9 10])))

save('E:\DelayWord\areamap','areamap')
    

%%
event=4
EC24=PLVtests(12,event)
EC23=PLVtests(10,event)
EC18=PLVtests(1,event)
EC22=PLVtests(9,event)


D=cat(1,mean(EC24.Data.segmentedEcog(1).zscore_separate,4),...
    mean(EC23.Data.segmentedEcog(1).zscore_separate,4),...
      mean(EC18.Data.segmentedEcog(1).zscore_separate,4),...
      mean(EC22.Data.segmentedEcog(1).zscore_separate,4));

%%
channels=num2cell(horzcat(EC24.Data.usechans,EC23.Data.usechans,EC18.Data.usechans,EC22.Data.usechans));
idx=1;
subj={'EC24','EC23','EC18','EC22'}

for i=1:length(subj)   
    test=eval([subj{i} '.Data']);
    for j=1:test.channelsTot        
        channels{2,idx}=test.patientID;
        idx=idx+1;
    end
end

channels=channels'
%%
data=zscore(D(:,1:1600),[],2);
%data=D(:,800:1600);

%%
knum=50
%'emptyaction','drop'
[kgroup,C,sumd,Dout] = kmeans(data,knum,'emptyaction','drop','dist','sqEuclidean',...
                       'display','final','replicates',5);
figure
subplot(1,3,1)
[silh5,h] = silhouette(data,kgroup,'correlation');
subplot(1,3,2)
[sortedGroups,idx]=sort(kgroup);

imagesc(Dout(idx,:)')

sep=find(diff(sortedGroups))
hl=line([sep sep]',repmat([0 knum+1],knum-1,1)')
set(hl,'LineWidth',3,'Color','k','LineStyle','-')

subplot(1,3,3)
bh=barh(flipud(sumd))
set(gca,'YTick',1:knum,'YTickLabel',knum:-1:1)
axis tight
%imagesc(sortedGroups')
% %% plot centroids
% 
% for i=1:knum
%     plot(cent4(i,:))
%     title(int2str(i))
%     input('n')
% end

% plot groups
figure
for i=1:knum,
     subplot(2,knum,i);
     title(int2str(i))

    subsetD=D(find(kgroup==i),:);
    plot(subsetD');
    line([800 800],[ -1 3]);
    hold on
    plot(mean(D(find(kgroup==i),:),1),'LineWidth',3)    
    %plot(800:1600,C(i,:),'LineWidth',2,'Color','r');

    line([800 800],[ -1 3]);
    axis tight; 
    title(int2str(i))
    hold off
     subplot(2,knum,i+knum);
    groups{i}=channels(find(kgroup==i),:);
    %subplot(2,knum,i+knum);
    
    %subj=unique(groups{2}(2,:))
    for s=1:length(subj)
        idx=find(strcmp(subj{s},groups{i}(:,2)));        
        dHold(s,:)=mean(subsetD(idx,:),1);        
        subjidx=find(strcmp(subj{s},channels(:,2)));
    end
    plot(dHold','LineWidth',2)
    axis tight
    line([800 800],[ -1 3]);
    %SAVEPPT2('ppt',powerpoint_object,'stretch','off');
    %input('n'),
end
%%
% plot all groups and locations
save_file='C:\Users\Angela_2\Documents\Presentations\DelayWordAutoImages4.ppt'
powerpoint_object=SAVEPPT2(save_file,'init')
load('E:\DelayWord\areamap')
%figure
for i=1:knum,
    %subplot(2,knum,i);
    subplot(2,5,1)
    subsetD=D(find(kgroup==i),:);
    plot(subsetD');
    line([800 800],[ -1 3]);
    hold on
    plot(mean(D(find(kgroup==i),:),1),'LineWidth',3)
    title(int2str(i))
    hold off
    axis tight; 
    groups{i}=channels(find(kgroup==i),:)
    %subplot(2,knum,i+knum);
    
    %subj=unique(groups{2}(2,:))
    for s=1:length(subj)
        idx=find(strcmp(subj{s},groups{i}(:,2)))
        subplot(2,5,1+s+5)
        visualizeGrid(0,['E:\General Patient Info\' subj{s} '\brain.jpg'],cell2mat(groups{i}(idx,1)));   
        title(subj{s},'FontSize',15)
        subplot(2,5,s+1)

        plot(subsetD(idx,:)')
        line([800 800],[ -1 3]);
        axis tight
        dHold(s,:)=mean(subsetD(idx,:),1);
        
        subjidx=find(strcmp(subj{s},channels(:,2)));
        areamap(s).event(event).cluster(i).ch=cell2mat(groups{i}(idx,1))';
        
        
    end
    subplot(2,5,1+5)
    plot(dHold','LineWidth',2)
    axis tight
    line([800 800],[ -1 3]);
    legend(subj,'Location','SouthOutside','Orientation','horizontal')
    SAVEPPT2('ppt',powerpoint_object,'stretch','off');
    %input('n')
    
    clf
    %visualizeGrid(0,['E:\General Patient Info\' test.patientID '\brain.jpg'],test.usechans(find(kgroup==i)));,
end
%%

for s=1:4
    keep=[ 18 16 15 14 12 11 2 1]
    areamap(s).subj=subj{s};
    areamap(s).event(event).allactive=[ areamap(s).event(event).cluster(keep).ch]
end
save('E:\DelayWord\areamap','areamap')

%% get pk times for each cluster
figure
usek=[3 5]
for k1=1:length(usek)
    %%
    figure(5)
    k=usek(k1)
    idx=find(kgroup==k);
    ch=usechans(subset1(subset2(idx)))
    %pkidx=zeros(length(ch),size(T.Data.segmentedEcog.zscore_separate,4));
     pkidx=zeros(length(ch),51);
   
    for c=1:length(ch)
        D3=squeeze(T.Data.segmentedEcog.zscore_separate(ch(c),:,:,:))';
        for r=1:size(D3,1)
            pr=prctile(reshape(D3(r,800:end),1,[]),95,2);
            %kGroup(k).pkidx(c,r)=pr;%max amp
            [~,kGroup(k).pkidx(c,r)]=find(D3(r,800:end)>=pr,1,'first');%max pk time
            kGroup(k).percWord(c,r)=kGroup(k).pkidx(c,r)/sounds(r).length;
        end
    end
    subplot(2,3,[1 2]+(k1-1)*3)
    %boxplot(kGroup(k).pkidx)
    stmp1=[ste(kGroup(k).pkidx(:,[indices.cond1]),2)';ste(kGroup(k).pkidx(:,[indices.cond2]),2)']
    mtmp1=[median(kGroup(k).pkidx(:,indices.cond1),2)';median(kGroup(k).pkidx(:,indices.cond2),2)'];
    
    stmp=[ste(kGroup(k).percWord(:,[indices.cond1]),2)';ste(kGroup(k).percWord(:,[indices.cond2]),2)']
    mtmp=[median(kGroup(k).percWord(:,indices.cond1),2)';median(kGroup(k).percWord(:,indices.cond2),2)'];
    [~,sortidx]=sort(mean(diff(mtmp,1),1));
    %barwitherr(stmp(:,sortidx)',mtmp(:,sortidx)')
    errorarea(mtmp(:,sortidx)',stmp(:,sortidx)')
    colormap(summer)
    axis tight
    axis([1 40 0 1])
    set(gca,'XTick',1:size(D3,1),'XTickLabel',usechans(subset1(subset2((idx(sortidx))))))
    %set(gca,'YTickLabel',(0:50:400)/.4)
   
    figure(k1)
    %subplot(2,1,k1)
    %subplot(2,3,3+(k1-1)*3)
    visualizeGrid(9,['E:\General Patient Info\' test.patientID '\brain.jpg'],usechans(subset1(subset2((idx)))),mean(mtmp(:,sortidx),1),[],mean(mtmp(:,sortidx),1));
    %visualizeGrid(5,['E:\General Patient Info\' test.patientID '\brain.jpg'],usechans(subset1(subset2((idx)))),mean(mtmp(:,sortidx),1));
end
%%
thidx=find(mean(diff(mtmp,1),1)>40)

visualizeGrid(5,['E:\General Patient Info\' test.patientID '\brain.jpg'],usechans(subset1(subset2(idx(thidx)))),ones(1,length(thidx)));
%%
figure
for k=usek
    kGroup(k).meanIdx1=mean(kGroup(k).pkidx(:,indices.cond1),2)
    kGroup(k).meanIdx2=mean(kGroup(k).pkidx(:,indices.cond2),2)

    kGroup(k).tag=repmat(k,size(kGroup(k).meanIdx,1),1);
    stmp(:,k)=[ste([ kGroup(k).meanIdx1],1); ste([ kGroup(k).meanIdx2],1)];
    mtmp(:,k)=[mean([ kGroup(k).meanIdx1],1); mean([ kGroup(k).meanIdx2],1)];
end
%boxplot(vertcat(kGroup(usek).meanIdx),vertcat(kGroup(usek).tag))
barwitherr(stmp(:,usek)',mtmp(:,usek)')
colormap(summer)