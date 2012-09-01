

eidx=1
for t=1:size(test.segmentedEcog(eidx).zscore_separate,4)
    d=squeeze(mean(test.segmentedEcog(eidx).zscore_separate(:,800:end,:,t),3));  
    [a,b]=max(d');
    [~,chorder]=sort(a);
    ERP(t).maxidx=a;
    ERP(t).sortidx=chorder;
end
%%
for ii=1:4
    test=eval([subj{ii} '.Data']);
   %%
    close all
    eidx=1
    clear channelorder
    startsamp=500
    endsamp=1600
    badtrials=[]
    %badtrials=[29 47 ]
    usetrials=setdiff(1:size(test.segmentedEcog(eidx).data,4),badtrials);
    for c=1:size(test.segmentedEcog(eidx).zscore_separate(:,startsamp:endsamp,:,usetrials),1)
        d=squeeze(mean(test.segmentedEcog(eidx).zscore_separate(c,startsamp:endsamp,:,usetrials),3));  
        figure(1)
        imagesc(d')
        title(int2str(test.usechans(c)))
        %input('n')
        clear d2
    %     for t=1:size(d,2)
    %         d2(:,t)=smooth(d(:,t),10);
    %     end
        d2=d;
        imagesc(d2')

        mD=smooth(mean(d2,2),50);
        [a,b]=max(mD);
        maxd=a;
        [mind,~]=min(mD);
        diffd=maxd-mind;


        a=.95*diffd+mind;
    %     for i=1:size(d2,1)
    %         b(i)=find(d2(i,:)>=a,1);
    %     end
        b =find(mD>=a,1);

        if b>400
            start=b-400;
        else 
            start=1;
        end
        slopeidx=find(diff(mD(start:b))>.003,1)+start;
        %slopeidx=b-find(fliplr(diff(mD(start:b)))<0,1);

        %p=mean(prctile(d,90))
        [maxorder,trorder]=sort(a);
        if prctile(mD,95)>.7 & std(b/max(b))<.3
            channelorder(c).maxidx=b;
            channelorder(c).slopeidx=slopeidx;

            channelorder(c).meanamp=median(mean(d));
            channelorder(c).meanamp=median(mean(d,1));

            channelorder(c).maxamp=median(a);

        else
            channelorder(c).slopeidx=NaN%repmat(NaN,[1 length(mean(d,1))]);

            channelorder(c).maxidx=NaN%repmat(NaN,[1 length(mean(d,1))]);
            channelorder(c).meanamp=NaN%repmat(NaN,[1 length(mean(d,1))]);
             channelorder(c).maxamp=NaN%repmat(NaN,[1 length(mean(d,1))]);
        end

        plot(mD)
        hold on
        plot([mean(channelorder(c).maxidx) mean(channelorder(c).maxidx)],[-1 5],'r')
        plot(diff(mD))
        try
            plot([slopeidx slopeidx],[-1 5],'g')
        end
        hold off
        r='y'
        %r=input('n','s')
        if strcmp(r,'n')
            channelorder(c).slopeidx=NaN%repmat(NaN,[1 length(mean(d,1))]);
            channelorder(c).maxidx=NaN%repmat(NaN,[1 length(mean(d,1))]);
            channelorder(c).meanamp=NaN%repmat(NaN,[1 length(mean(d,1))]);
            channelorder(c).maxamp=NaN%repmat(NaN,[1 length(mean(d,1))]);
            keyboard
        end
    end
    CM=vertcat(channelorder.maxidx)
    m=median(CM,2)
    [m1,m2]=sort(m)
%     boxplot(CM(m2,:)')
%     set(gca,'XTickLabelMode','auto')
%     set(gca,'XTick',1:length(ch2))
%     set(gca,'XTickLabel',ch2(m2))
%     set(gca,'Fontsize',8) 
    holdData(ii).m=m;
    holdData(ii).CM=CM;
end
%%
for i=1:length(m2)
    hist(CM(m2(i),:),50)
    title(ch2(m2(i)))
    input('n')
    
end
%%
for i=1:size(CM,2)
    tmp=CM(:,1);
    plot(tmp'.')
end
%%
load('E:\DelayWord\modhot.mat')
%visualizeGrid(7,['E:\General Patient Info\EC22' '\brain.jpg'],ch2,[channelorder.meanamp]')
%idx=find((m'/400)*1000>400)
%m(idx)=NaN;
idx=1:length(test.usechans)
ch2=test.usechans
%%
figure
visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2(idx),(m(idx)'/400)*1000,[],ones(1,length(ch2(idx)))*76,[])
visualizeGrid(9,['E:\General Patient Info\EC22' '\brain.jpg'],ch2(idx),(m(idx)'/400)*1000,[],ones(1,length(ch2(idx)))*76,[])
visualizeGrid(9,['E:\General Patient Info\EC18' '\brain_3Drecon.jpg'],ch2(idx),(m(idx)'/400)*1000,[],ones(1,length(ch2(idx)))*76,[])
visualizeGrid(9,['E:\General Patient Info\EC24' '\brain.jpg'],ch2(idx),(m(idx)'/400)*1000,[],ones(1,length(ch2(idx)))*76,[])
axis([200 1400 20 1000])
colormap(modhot)
set(gcf,'Color','w')
%%
n=4

load('E:\DelayWord\areamap.mat')
fields=fieldnames(areamap(n).kclusters2)
m_ms=(m'/400)*1000
clear M
for i=1:length(fields)
    ch=getfield(areamap(n).kclusters2,fields{i});
    if isempty(ch)
        M{i}=NaN;
    else
    M{i}=[];
        for c=1:length(ch)        
             cidx=find(ch2==ch(c));
             M{i}=[M{i} m_ms(cidx)];
        end
    end
    %areaname(i)=str2num(fields{i}(regexp(fields{i},'[1234567890]')))
    areaname{i}=fields{i}

end
figure
M1=cellfun(@nanmean,M);
%M1(isnan(M1))=99999
idx=find(~isnan(M1))
[M2,order]=sort(M1(idx))
S=cellfun(@ste,M(idx(order)));
%%
clear usek usekstring
figure
%usek=1:50
usek=[21 4 19 26 32 36 40]
for i=1:length(usek)
    usekstring{i}=num2str(usek(i));
end
hold off
clear groupData M2all Sall mD
for i=usek  
    ii=find(usek==i)
    for s=1:length(subj)
        
            idx1=find(strcmp(subj{s},channels(:,2)))
            kset=find(kgroup(idx1)==i)
            groupData(i).m{s}=holdData(s).m(kset);
            groupData(i).CM{s}=holdData(s).CM(kset);
            holdData(s).chan{i}=cell2mat(channels(idx1(kset),1))';
            M2all(s,i)=nanmean(groupData(i).m{s});
            Sall(s,i)=nanstd(groupData(i).m{s});
            subsetD=D(idx1(kset),:);     
            mD(s,:)=mean(subsetD,1);  
            subsetall(s).subset=subsetD;
            %keyboard
    end
    %colors=colormap(autumn).*gray;
    %colormat=colors(round(size(colors,1)/length(usek)*ii),:);
    %colormat([3])=.5;
    colormat='k'
    errorarea(nanmean(mD,1),nanstd(vertcat(subsetall.subset),[],1)/sqrt(size(vertcat(subsetall.subset),1)))

    %plot(nanmean(mD,1),'Color',colormat,'LineWidth',3)
    %hold on
    hl=line([800 800],[ -1 3]);
    set(hl,'Color','k')
    set(hl,'LineStyle','--')
    set(gca,'XTick',0:400:1600)

    set(gca,'XTickLabel',-2:1:2)
    axis tight
    %legend(usekstring)
    %input('n')
    SAVEPPT2('ppt',powerpoint_object,'stretch','off');
    
end

%%
save_file='C:\Users\Angela_2\Documents\Presentations\DelayWordAutoImages4.ppt'
for u=usek
    for s=1:4
        subplot(1,4,s)
        %colors=colormap(autumn).*gray
        %colormat=colors(round(256/length(usek))*find(usek==u),:);
        
        %colormat([3])=.5;
        visualizeGrid(11,['E:\General Patient Info\' subj{s} '\brain.jpg'],holdData(s).chan(u),[],[],[],[],'r');
        if ismember(s,[1 2])
            axis([200 1400 20 1000])
        end
        %legend(usekstring)
    end
       SAVEPPT2('ppt',powerpoint_object,'stretch','off');

    %input('n')

end
% axis([200 1400 20 1000])
%%

figure
for s=1:4
    visualizeGrid(11,['E:\General Patient Info\' subj{s} '\brain.jpg'],holdData(s).chan(usek));
    %legend(usekstring)
    keyboard
end
axis([200 1400 20 1000])

%%

%h=barwitherr(Sall(:,:)',M2all(:,:)')
figure
h=barwitherr(Sall(:,usek)',M2all(:,usek)')
set(gca,'YTickLabel',([0:50:250]/400)*1000)
set(gca,'XTickLabel',usek)
xlabel('Cluster Area','Fontsize',14)
ylabel('Latency (ms)','Fontsize',14)
%set(h.bar,'FaceColor',rgb('maroon'))
title('Latency of peak after word presentation onset','Fontsize',14)
set(gca,'FontSize',12)
legend(subj)
colormap(colors)

%%
figure
for i=1:length(fields)
    ch=getfield(eval(['areamap.EC' int2str(23)]),fields{i});
    chold=[]
    for c=1:length(ch)        
         cidx=find(ch2==ch(c));
         plot(mean(mean(test.segmentedEcog(eidx).zscore_separate(cidx,:,:,:),3),4));
         chold=[chold cidx];
         %input('n')
    end
    plot(mean(mean(test.segmentedEcog(eidx).zscore_separate(chold,:,:,:),3),4)');
    title(fields{i})
    input('n')

    areaname(i)=str2num(fields{i}(regexp(fields{i},'[1234567890]')))
end
%%
