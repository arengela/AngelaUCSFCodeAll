clf
line([-100 100],[0 0])
line([0 0],[-100 100])
colorjet=flipud(redblack)
eset=[2 5]
for eidx=eset
    for p=1:length(patients)-1
        %%
        figure(1)
        %subplot(1,5,find(sets==eidx))
        %visualizeGrid(2,['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain.jpg'],[]);
        hold on
        %PLOT ELECTRODES ACTIVE ONLY DURING EVENT
        usech=reshape(AllP{p}.Tall{eidx}.Data.Params.activeCh,1,[]);
        usech=setdiff(usech,AllP{p}.Tall{setdiff(eset,eidx)}.Data.Params.activeCh);
        d=repmat(1,1,length(usech));
        %visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d,[],[],[],rgb(colorcell{eidx}),0,1);    
        ch=usech
        if ~isempty(ch)
            [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,1:AllP{p}.Tall{eidx}.Data.channelsTot)
            holdDev(p,eidx).x=devCS./gridDist;
            holdDev(p,eidx).y=devSF./gridDist;
            holdDev(p,eidx).v=zeros(1,length(holdDev(p).x));
            holdDev(p,eidx).v(ch)=1;
            holdDev(p,eidx).ch=ch;
            [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,ch)
        end
        if eidx==2
            idx=round((eidx-2)*length(colorjet)/3)+1
        else
            idx=round((eidx-2)*length(colorjet)/3)-1
        end
        plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',p+2,colorjet(idx,:),.7,1)
    end
    line([-100 100],[0 0])
    line([0 0 ],[-100 100])
end
%%
eidx=4
for p=1:length(patients)-1
    %PLOT ELECTRODES GREAT PROD
    %subplot(1,5,find(sets==eidx))
    
    usech=intersect(reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]),reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[]));
    usetr=AllP{p}.Tall{2}.Data.Params.usetr;
    d1=squeeze(max(squeeze(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(usech,150:300,:,usetr)),[],2));
    usetr=AllP{p}.Tall{5}.Data.Params.usetr;
    d2=squeeze(max(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(usech,150:300,:,usetr)),[],2));
    [t,pval]=ttest2(d2',d1',0.05,'right','unequal');
    [ps_fdr,h_fdr]=MT_FDR_PRDS(pval,.05);
    ch1=usech(find(h_fdr));
    ch=ch1;
    %visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(length(ch)),[],[],[],rgb('dodgerblue'),0,1);
    if ~isempty(ch)
        [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,1:AllP{p}.Tall{eidx}.Data.channelsTot)
        holdDev(p,eidx).x=devCS./gridDist;
        holdDev(p,eidx).y=devSF./gridDist;
        holdDev(p,eidx).v=zeros(1,length(holdDev(p).x));
        holdDev(p,eidx).v(ch)=pval(find(h_fdr));
        [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,ch)
        holdDev(p,eidx).ch=ch;

    end
    plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',p+2,colorjet(round(2*length(colorjet)/3),:),.7,1)
end
line([-100 100],[0 0])
line([0 0 ],[-100 100])
%%
eidx=3
for p=1:length(patients)-1
    %PLOT ELECTRODES GREAT PROD
    %subplot(1,5,find(sets==eidx))
    usech=intersect(reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]),reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[]));
    usetr=AllP{p}.Tall{2}.Data.Params.usetr;
    d1=squeeze(max(squeeze(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(usech,150:300,:,usetr)),[],2));
    usetr=AllP{p}.Tall{5}.Data.Params.usetr;
    d2=squeeze(max(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(usech,150:300,:,usetr)),[],2));
    [t,pval]=ttest2(d2',d1',0.05,'left','unequal');
    [ps_fdr,h_fdr]=MT_FDR_PRDS(pval,.05);
    ch2=usech(find(h_fdr));
    ch=ch2
    %visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(length(ch)),[],[],[],rgb('pink'),0,1);
    if ~isempty(ch)
        [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,1:AllP{p}.Tall{2}.Data.channelsTot)
        holdDev(p,eidx).x=devCS./gridDist;
        holdDev(p,eidx).y=devSF./gridDist;
        holdDev(p,eidx).v=zeros(1,length(holdDev(p).x));
        holdDev(p,eidx).v(ch)=pval(find(h_fdr));
        holdDev(p,eidx).ch=ch;
      
        [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,ch)
    end
    
    plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',p+2,colorjet(round(1*length(colorjet)/3),:),.7,1)
end
line([-100 100],[0 0])
line([0 0 ],[-100 100])
%%
eidx=1
for p=1:length(patients)-1
    %PLOT ELECTRODES GREAT PROD
    %subplot(1,5,find(sets==eidx))
    
    usech=intersect(reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]),reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[]));
    usetr=AllP{p}.Tall{2}.Data.Params.usetr;
    d1=squeeze(max(squeeze(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(usech,150:300,:,usetr)),[],2));
    usetr=AllP{p}.Tall{5}.Data.Params.usetr;
    d2=squeeze(max(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(usech,150:300,:,usetr)),[],2));
    
    [t,pval]=ttest2(d2',d1',0.05,'right','unequal');
    [ps_fdr,h_fdr]=MT_FDR_PRDS(pval,.05);
    ch1=usech(find(h_fdr));
    %visualizeGrid(5,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(1,length(ch)),[],[],[],colorjet(round(2*length(colorjet)/3),:),0,1);
    allCh(ch1)=4;
%     if ~isempty(ch)
%         [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,ch)
%     end
%      plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',i+2,rgb('dodgerblue'),.7,3)

    %PLOT ELECTRODES GREAT PERC    
    [t,pval]=ttest2(d2',d1',0.05,'left','unequal');
    [ps_fdr,h_fdr]=MT_FDR_PRDS(pval,.05);
    ch2=usech(find(h_fdr));    
    %visualizeGrid(5,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(1,length(ch)),[],[],[],colorjet(round(1*length(colorjet)/3),:),0,1);
    ch=setdiff(usech,[ch1 ch2]);
    %EQUAL PROD AND PERC
    %visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(length(ch)),[],[],[],rgb('white'),0,1);
    if ~isempty(ch)
        [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,1:AllP{p}.Tall{2}.Data.channelsTot)
        holdDev(p,eidx).x=devCS./gridDist;
        holdDev(p,eidx).y=devSF./gridDist;
        holdDev(p,eidx).v=zeros(1,length(holdDev(p).x));
        holdDev(p,eidx).v(ch)=pval(find(h_fdr));
        holdDev(p,eidx).ch=ch;
        [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,ch)
    end    
    %plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',p+2,colorjet(round(1.5*length(colorjet)/3),:),.7,1)
    plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',p+2,rgb('white'),.7,1)
    %set(gca,'Color','k')
end
line([-100 100],[0 0])
line([0 0 ],[-100 100])
%% PLOT GRIDDATA ON BRAIN
figure

load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblue_adjusted')
lim=100
sets=[2 3 1 4 5]
colorcell{1}='red'
colorcell{2}='pink'
colorcell{3}='yellow'
colorcell{4}='lightblue'
colorcell{5}='dodgerblue'
minC=rgb('black')
clf
colormat=flipud(redblue_adjusted)
try
    load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblack')
end
colorjet=redblack
for p=1:6
    %%
    for e=sets
        e1=find(sets==e);
        figure(e1)
        maxC=colormat(round((e1-1)*63/4+1),:)
        a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain2.jpg']);
        limx=size(a,2);
        limy=size(a,1);        
        grain=10;
        gx=1:grain:limx;
        gy=1:grain:limy;
        [X,Y] = MESHGRID(gx,gy);
        [Xq,Yq,Vq]=griddata(BrainCoord(p).xy(1,holdDev(p,e).ch),BrainCoord(p).xy(2,holdDev(p,e).ch),holdDev(p,e).v(holdDev(p,e).ch),X,Y);
        g2(p).Vq=Vq;

        grain=1
        Vq(find(isnan(Vq)))=0;  
 
        tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
        tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
        tmp3(find(tmp3<0))=0;
        tmp4=tmp3./max(max(tmp3));
        tmp4=smooth2(tmp4,10);   

        ha = axes('units','normalized', ...
            'position',[0 0 1 1]);
        imagesc(repmat(a,[1 1 3]))
        colormap(gray)
        hold on
        set(ha,'handlevisibility','off', ...
        'visible','off')
         ha = axes('units','normalized', ...
            'position',[0 0 1 1]);  
        imshow(tmp3)

        tmp4=tmp4*2;
        tmp4(find(tmp4>1))=1;
        %alpha(smooth2(tmp5,1));
        alpha(tmp4)
        %colormap(flipud(redblack))
       colormap(autumn)
%         for c=1:3
%             newcolormap(:,c)=linspace(minC(c),maxC(c),64)
%         end
         hold on
%         colormap(newcolormap)
%         freezeColors;
        scatter(BrainCoord(p).xy(1,holdDev(p,e).ch),BrainCoord(p).xy(2,holdDev(p,e).ch),100,'r','fill')

        input('n')    

    end
    input('n')    
    close all
end

%%
lim=1*1.5;
gx=-lim:.05:lim;
gy=-lim:.05:lim;
[X,Y] = MESHGRID(gx,gy);
Z=zeros(size(X));
%%
for p=1:6
    for e=1:5
        %figure(e)
        holdDev(p,e).g=gridfit([holdDev(p,e).x reshape(X,1,[])],[holdDev(p,e).y reshape(Y,1,[])],[holdDev(p,e).v reshape(Z,1,[])],gx,gy);
        subplot(5,6,(e-1)*6+p)
        pcolor(holdDev(p,e).g)
        shading interp
        colormap(flipud(hot))
        axis tight    
        line([0 62],[31 31])
        line([31 31],[0 62])
        set(gca,'visible','off')
        input('n')
        hold on
    end
end
%%
figure

load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblue_adjusted')
lim=100
sets=[2 3 1 4 5]
colorcell{1}='red'
colorcell{2}='pink'
colorcell{3}='yellow'
colorcell{4}='lightblue'
colorcell{5}='dodgerblue'
minC=rgb('black')
%%
clf
colormat=flipud(redblue_adjusted)
alphaHold=1;
for e=sets
    e1=find(sets==e);
    %maxC=rgb(colorcell{e1})
    maxC=colormat(round((e1-1)*63/4+1),:)
    holdDev(7,e).g=gridfit([[holdDev(:,e).x]*1.5 reshape(X,1,[])],[[holdDev(:,e).y]*1.5 reshape(Y,1,[]) ],[holdDev(:,e).v reshape(Z,1,[])],gx,gy);
    %subplot(1,6,e1)
    %     surf(gy,gy,holdDev(7,e).g);
    %     shading interp
    %     view(2)
    %     line([-lim lim],[0 0],[1,1])
    %     line([0 0],[-lim lim],[1 1])
    axis tight
    hold on
    g2=holdDev(7,e).g;
    grain=10;
    t = maketform('affine',[length(g2) length(g2) 1;length(g2) 1 length(g2)]',[length(g2)*grain length(g2)*grain;length(g2)*grain 0;0 length(g2)*grain]);
    R = makeresampler('cubic','fill');
    tmp2 = imtransform(g2,t,R,'XYScale',1);
    tmp2=(tmp2./max(max(tmp2)));
    tmp2(find(tmp2<.3))=0;
    surf(1:size(tmp2,1),1:size(tmp2,2),tmp2);
    shading interp
    view(2)
    
    set(gca,'CLim',[0 .6])
    %tmp2(find(tmp2>.1))=1;
    %tmp2=(tmp2./max(max(tmp2))).^.5;
    
    %tmp2(find(tmp2>prctile(reshape(tmp2,1,[]),90)))=1;
    %alpha(tmp2+alphaHold)
    %alphaHold=tmp2+alphaHold;
    alpha(.9)
    
    hl=line([1 length(tmp2)],[length(tmp2)/2 length(tmp2)/2],[1,1])
    set(hl,'Color','w','LineStyle','--')
    hl=line([length(tmp2)/2 length(tmp2)/2],[1 length(tmp2)],[1,1])
    set(hl,'Color','w','LineStyle','--')
    axis tight
    %set(gca,'Visible','off')
    for c=1:3
        newcolormap(:,c)=linspace(minC(c),maxC(c),64)
    end
    
    x=(([holdDev(:,e).x])+1)
    y=(([holdDev(:,e).y])+1)
    idx=find([holdDev(:,e).v])
    
    %p=plot3(x(idx)*310,y(idx)*310,ones(1,length(x(idx))),'.');
    %p=text(x(idx)*310,y(idx)*310,ones(1,length(x(idx))),int2str(e))
    
    %set(p,'Color',maxC.*rgb('gray'))
    
    colormap(newcolormap)
    freezeColors;
    hold on
    set(gca,'Color','k')
    set(gcf,'Color','k')
    input('n')
end

%%
figure
for e=sets
    e1=find(sets==e);
    g2=holdDev(7,e).g;
    colormap(gray)
    %imagesc(g2)
    hold on
    %maxC=rgb(colorcell{e1})
    maxC=colormat(round((e1-1)*63/4+1),:)
    x=(([holdDev(:,e).x])+1)
    y=(([holdDev(:,e).y])+1)
    idx=find([holdDev(:,e).v])
    %text(x,y,int2str(e1))
    p=plot(x(idx)*31,y(idx)*31,'.')
    set(p,'Color',maxC)
    hold on
    input('n')
end
%%
figure

imagesc(g2)
hold on
ha = axes('units','normalized', ...
    'position',[0 0 2 2]);
plot(x,y,'r.')

set(ha,'handlevisibility','off', ...
    'visible','off','xlim',[0 2],'ylim',[0 2])

%%
figure
for e=1:5
    subplot(1,5,e)
    g=sum(cat(3,holdDev(1:6,e).g),3);
    g=g+abs(min(min(g)));
    g=(g./max(max(g)));
    surf(gy,gy,g);
    shading interp
    view(2)
    %g2=zeros(size(g))
    %g2(find(g.^3>.5))=1
    g2=g
    %g2(find(g2>.05))=1;
    %alpha(g2)
    colormap(flipud(hot))
    line([-300 300],[0 0],[1,1])
    line([0 0],[-300 300],[1 1])
    axis([-300 300 -300 300])
    
    t = maketform('affine',[600 600 1;600 1 600]',[1200 1200;1200 0;0 1200]);
    R = makeresampler('cubic','fill');
    tmp2 = imtransform(g,t,R,'XYScale',1);
    %imagesc(tmp2)
    
    
    alpha(tmp2)
    
    
end

%%
t = maketform('affine',[600 600 1;600 1 600]',[1200 1200;1200 0;0 1200]);
R = makeresampler('cubic','fill');
tmp2 = imtransform(g,t,R,'XYScale',1);
imagesc(tmp2)
