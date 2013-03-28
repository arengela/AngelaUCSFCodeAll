nohup taskset 00f00f matlab -nodesktop
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')
stepSize=5
renderImages=1

sampSet{2}=200:stepSize:350;
sampSet{5}=100:stepSize:350;

opengl software
figure
set(gcf,'Color','w')
colorjet=flipud(hot)
maxZ=5;
for p=1:8
    close all
    %%
    for renderImage=[1 ]
        figure('Position',fpos,'Color','w')
        for eidx=[2 5]
            %%
            for s=1:length(sampSet{eidx})-1
                %%
                r=rem(s,10);
                if r==0
                    r=10;
                end
                
                if eidx==2
                    pos=subplotMinGray(8,11,ceil(s/10),r-1,.0001);
                else
                    pos=subplotMinGray(8,11,ceil(s/10)+3,r-1,.0001);
                end
                %pos=subplotMinGray(1,1,1,0);
                
                %             pos(4)=pos(4)/2;
                %             if eidx==2
                %                 pos(2)=pos(2)+pos(4);
                %             end
                samps=sampSet{eidx}(s):sampSet{eidx}(s+1)-1;
                usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
                usech=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh']);
                skipch=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,usech);
                d=mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,samps,:,usetr),4),2);
                d(find(d<0))=0;
                a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
                
                if renderImage==1
                    limx=size(a,2);
                    limy=size(a,1);
                    grain=20;
                    gx=1:grain:limx;
                    gy=1:grain:limy;
                    [X,Y] = MESHGRID(gx,gy);
                    
                    grain2=100;
                    gx2=1:grain2:limx;
                    gy2=1:grain2:limy;
                    [X2,Y2] = MESHGRID(gx2,gy2);
                    Z2=zeros(size(X2));
                    
                    idx=1:size(X2,1)*size(X2,2);
                    X3=reshape(X2,1,[]);
                    Y3=reshape(Y2,1,[]);
                    XY2=vertcat(X3,Y3);
                    
                    nidx2=[];
                    nidx=[];
                    for i=1:length(usech)
                        d1=squareform(pdist([BrainCoord(p).xy(:,usech(i)) XY2]'));
                        d2=d1(1,2:end);
                        [aidx,bidx]=find(d2<20);
                        [aidx2,bidx2]=find(d2>0 & d2<10);
                        nidx=[nidx bidx];
                        nidx2=[nidx2 bidx2];
                    end
                    idx=setdiff(1:length(X3),unique(nidx));
                    idx2=unique(nidx2);
                    idx3=setdiff(1:length(X3),idx2);
                    %[Xq,Yq,Vq]=griddata([X3(idx) BrainCoord(p).xy(1,usech)],[ Y3(idx) BrainCoord(p).xy(2,usech)],[reshape(Z2(idx),1,[]) d'],X,Y,'v4');
                    [Xq,Yq,Vq]=griddata([ X3(idx) BrainCoord(p).xy(1,skipch) BrainCoord(p).xy(1,usech)],...
                        [Y3(idx)  BrainCoord(p).xy(2,skipch) BrainCoord(p).xy(2,usech)],...
                        [reshape(Z2(idx),1,[]) zeros(1,length(skipch)) d'],X,Y,'v4');
                    
                    %[Xq,Yq,Vq]=griddata(BrainCoord(p).xy(1,usech),BrainCoord(p).xy(2,usech),d,X,Y);
                    Vq(find(isnan(Vq)))=0;
                    
                    tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
                    tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
                    tmp3(find(tmp3<0))=0;
                    tmp4=tmp3./maxZ;
                    tmp4=smooth2(tmp4,10);
                    
                    
                    ha=axes('position',pos);
                    %imagesc(repmat(a,[1 1 3]))
                    imshow(repmat(a,[1 1 3]))
                    hold on
                    set(ha,'handlevisibility','off', ...
                        'visible','off')
                    ha=axes('position',pos);
                    imshow(tmp3,[0 4])
                    tmp4=tmp4./max(max(tmp4));
                    tmp4=tmp4*2;
                    tmp4(find(tmp4>1))=1;
                    %alpha(smooth2(tmp5,1));
                    alpha(tmp4)
                    if eidx==2
                        colormap(redblackwhite)
                        freezeColors
                    else
                        colormap(blueblackwhite)
                        freezeColors
                        
                    end
                    
                    %                 ha=axes('position',pos);
                    %                 %imagesc(repmat(a,[1 1 3]))
                    %                 imshow(repmat(a,[1 1 3]))
                    %                 hold on
                    %                 set(ha,'handlevisibility','off', ...
                    %                 'visible','off')
                    %                 ha=axes('position',pos);
                    %                 %ha=axes('position',pos);
                    %                 imshow(zeros(size(tmp3)),[0 4])
                    %                 colormap(flipud(gray))
                    if s>=200
                        stext=-(sampSet{eidx}(s)-200)*10;
                    else
                        stext=(sampSet{eidx}(s)-200)*10;
                    end
                    
                    if 1%eidx==2
                        text(pos(1),pos(2),num2str(stext),'Fontsize',6,'Color',rgb('gray'))
                    end
                end
                
                %hold on
                %scatter(BrainCoord(p).xy(1,usech)',BrainCoord(p).xy(2,usech)',100,colorjet(ceil((d./max(d))*(length(colorjet)-1))+1,:),'fill')
                %M(s+1)=getframe;
                %clf
            end
        end
        if renderImage==1
            %set(figure(1), 'PaperPosition', [0 0 11 8]);
            print(figure(1),'-r1200', '-dpdf', ['E:\DelayWord\ActivationPlots\p' int2str(p) '_images.pdf']);
        else
            print(figure(2),'-dpdf', ['E:\DelayWord\ActivationPlots\p' int2str(p) '_text.pdf']);
        end
        
    end
    %input('n')
end
%% MAKE MOVIE PERC AND PROD ON ONE PLOT
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')


opengl software
%figure
colorjet=flipud(hot)
stepSize=4
maxZ=3;
for p=8
    %%
    for flag=1
        close all
        figure('position',[ 100 31 800 800],'units','Normalize','Color','w')
        for s=1:400/stepSize
            %%
            clf
            for eidx=[2 5]
                %%
                r=rem(s,10);
                if r==0
                    r=10;
                end
                pos=subplotMinGray(1,1,1,0);
                pos(4)=pos(4)/2;
                if eidx==2
                    pos(2)=pos(2)+pos(4);
                end
                
                samps=[s*stepSize:(s+1)*stepSize];
                usetr=1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.event,1);
                %usech=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh']);
                usech=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,AllP{p}.Tall{2}.Data.Artifacts.badChannels);
                skipch=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,usech);
                d=mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,samps,:,usetr),4),2);
                d(find(d<0))=0;
                %a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
                
                if flag==1
                    a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
                else
                    a=imread(['E:\DelayWord\allBrainPics\' AllP{p}.Tall{5}.Data.patientID 'scaled.jpg']);
                end
                
                limx=size(a,2);
                limy=size(a,1);
                grain=20;
                gx=1:grain:limx;
                gy=1:grain:limy;
                [X,Y] = MESHGRID(gx,gy);
                
                grain2=30;
                gx2=1:grain2:limx;
                gy2=1:grain2:limy;
                [X2,Y2] = MESHGRID(gx2,gy2);
                Z2=zeros(size(X2));
                
                idx=1:size(X2,1)*size(X2,2);
                X3=reshape(X2,1,[]);
                Y3=reshape(Y2,1,[]);
                XY2=vertcat(X3,Y3);
                
                nidx2=[];
                nidx=[];
                for i=1:length(usech)
                    d1=squareform(pdist([BrainCoord(p).xy(:,usech(i)) XY2]'));
                    d2=d1(1,2:end);
                    [aidx,bidx]=find(d2<20);
                    [aidx2,bidx2]=find(d2>0 & d2<10);
                    nidx=[nidx bidx];
                    nidx2=[nidx2 bidx2];
                end
                idx=setdiff(1:length(X3),unique(nidx));
                idx2=unique(nidx2);
                idx3=setdiff(1:length(X3),idx2);
                [Xq,Yq,Vq]=griddata([X3(idx) BrainCoord(p).xy(1,usech)],[ Y3(idx) BrainCoord(p).xy(2,usech)],[reshape(Z2(idx),1,[]) d'],X,Y,'v4');
                
                %[Xq,Yq,Vq]=griddata(BrainCoord(p).xy(1,usech),BrainCoord(p).xy(2,usech),d,X,Y);
                Vq(find(isnan(Vq)))=0;
                
                tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
                tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
                tmp3(find(tmp3<0))=0;
                tmp4=tmp3./maxZ;
                tmp4=smooth2(tmp4,10);
                
                ha=axes('position',pos);
                %imagesc(repmat(a,[1 1 3]))
                try
                    imshow(repmat(a,[1 1 3]))
                catch
                    imshow(a)
                end
                set(ha,'handlevisibility','off', ...
                    'visible','off')
                ha=axes('position',pos);
                try
                    imshow(repmat(a,[1 1 3]))
                catch
                    imshow(a)
                end
                hold on
                scatter(BrainCoord(p).newXY(1,:),BrainCoord(p).newXY(2,:),30,rgb('gray'),'fill')
                hold on
                try
                    imshow(repmat(a,[1 1 3]))
                catch
                    imshow(a)
                end
                alpha(.5)
                
                
                set(ha,'handlevisibility','off', ...
                    'visible','off')
                ha=axes('position',pos);
                imshow(tmp3,[0 4])
                tmp4=tmp4./max(max(tmp4));
                tmp4=tmp4*2;
                tmp4(find(tmp4>.9))=.9;
                %alpha(smooth2(tmp5,1));
                alpha(tmp4)
                if eidx==2
                    colormap(flipud(hot))
                    freezeColors
                else
                    colormap(flipud(hot))
                    freezeColors
                end
                
                if s>200
                    stext=-(samps(1)-100)*10;
                else
                    stext=(samps(1)-200)*10;
                end
                
                if eidx==2
                    h=text(pos(1),pos(2)+50,[num2str(stext) ' ms'],'Fontsize',16)
                end
                if stext>=0
                    set(h,'BackgroundColor','y')
                end
                if eidx==2
                    text(-20,pos(2)+200,['Perception'],'Fontsize',12);
                else
                    text(-20,pos(2)+200,['Production'],'Fontsize',12);
                end
                %hcbar=colorbar;
                %set(get(hcbar,'ylabel'),'String', 'zscore');
                %set(hcbar,'Location','East','YAxisLocation','right')
                %hold on
                %scatter(BrainCoord(p).xy(1,usech)',BrainCoord(p).xy(2,usech)',100,colorjet(ceil((d./max(d))*(length(colorjet)-1))+1,:),'fill')
                %M(s+1)=getframe;
                %clf
                hpos=get(gcf,'Position')
                %M(s)=getframe(gca,pos.*[hpos(3) hpos(4) hpos(3) hpos(4)]);
            end
            M(s)=getframe(gcf);
        end
        input('n')
        MovieHold{p,flag,eidx}.M=M;
    end
end
%% MAKE MOVIE PERC AND PROD ON ONE PLOT; ALL PATIENTS SCATTERED
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')


opengl software
%figure
colorjet=flipud(jet)
stepSize=4
maxZ=4;
figure('position',[ 100 31 800 800],'units','Normalize','Color','w')
%%
for s=1:400/stepSize
    clf
    for eidx=[2 5]
        for flag=1
            r=rem(s,10);
            if r==0
                r=10;
            end
            pos=subplotMinGray(1,1,1,0);
            pos(4)=pos(4)/2;
            if eidx==2
                pos(2)=pos(2)+pos(4);
            end
            if flag==1
                a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
            else
                a=imread(['E:\DelayWord\allBrainPics\' AllP{p}.Tall{5}.Data.patientID 'scaled.jpg']);
            end
            
            ha=axes('position',pos);
            try
                imshow(repmat(a,[1 1 3]))
            catch
                imshow(a)
            end
            set(ha,'handlevisibility','off', ...
                'visible','off')
            ha=axes('position',pos);
            try
                imshow(repmat(a,[1 1 3]))
            catch
                imshow(a)
            end
            for p=1:8
                %%
                r=rem(s,10);
                if r==0
                    r=10;
                end
                pos=subplotMinGray(1,1,1,0);
                pos(4)=pos(4)/2;
                if eidx==2
                    pos(2)=pos(2)+pos(4);
                end
                
                samps=[s*stepSize:(s+1)*stepSize];
                usetr=1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.event,1);
                usech=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,AllP{p}.Tall{2}.Data.Artifacts.badChannels);
                skipch=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,usech);
                d=mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,samps,:,usetr),4),2);
                d(find(d<.5))=0;
                d(find(d>maxZ))=maxZ;
                
                hold on
                %color=colorjet(findNearest(floor((p-1)*length(colorjet)/(8-1)),1:length(colorjet)),:);
                color=rgb('red')
                plotManyPolygons(BrainCoord(p).newXY(:,usech)',100,color,d./maxZ,8)
                
                if s>200
                    stext=-(samps(1)-100)*10;
                else
                    stext=(samps(1)-200)*10;
                end
                
                if eidx==2
                    h=text(pos(1),pos(2)+50,[num2str(stext) ' ms'],'Fontsize',5)
                end
                if stext>=0
                    set(h,'BackgroundColor','y')
                end
%                 if eidx==2
%                     text(-20,pos(2)+200,['Perception'],'Fontsize',12);
%                 else
%                     text(-20,pos(2)+200,['Production'],'Fontsize',12);
%                 end
                
                hpos=get(gcf,'Position');
            end
            
        end
    end
    M(s)=getframe(gcf);    
    MovieHold{p,flag,eidx}.M=M;
    %input('n')
end

%% PLAY MOVIE
close all
figure('position',[ 100 31 800 800],'units','Normalize','Color','w')
ha=axes('position',[0 0 1 1]);
movie(MovieHold{p,eidx}.M,10,10)
%% GO THROUGH MOVIE FRAME BY FRAME
clf
for i=50:length(M)
    clf
    imshow(M(i).cdata)print -dmeta

    input('b')
end


%%
p=p
eidx=2
fps=3
movie2avi(MovieHold{p,flag,eidx}.M,['E:\DelayWord\ActivationMovie\' 's' int2str(p) '_e' int2str(eidx) '_-2000to2000' '_fps', int2str(fps)],'fps',fps)

%% MAKE MOVIE OF ONE TOKEN
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')


opengl software
%figure
colorjet=flipud(hot)
stepSize=4
maxZ=4;
for p=1
    for eidx=[2 5]
        %%
        close all
        figure('position',[ 100 31 800 800],'units','Normalize','Color','w')
        for s=1:400/stepSize-1
            %%
            clf
            r=rem(s,10);
            if r==0
                r=10;
            end
            pos=subplotMinGray(1,1,1,0);
            %             pos(4)=pos(4)/2;
            %             if eidx==2
            %                 pos(2)=pos(2)+pos(4);
            %             end
            
            samps=[s*stepSize:(s+1)*stepSize];
            usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            %usetr=usetr(1);
            
            if eidx==2
                auxch=2;
            else
                auxch=1;
            end
            sound=mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.analog24Hz(auxch,:,:,usetr),4);
            usech=setdiff(unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh']),AllP{p}.Tall{5}.Data.Artifacts.badChannels);
            skipch=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,usech);
            d=mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,samps,:,usetr),4),2);
            d(find(d<0))=0;
            a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
            limx=size(a,2);
            limy=size(a,1);
            grain=20;
            gx=1:grain:limx;
            gy=1:grain:limy;
            [X,Y] = MESHGRID(gx,gy);
            
            grain2=50;
            gx2=1:grain2:limx;
            gy2=1:grain2:limy;
            [X2,Y2] = MESHGRID(gx2,gy2);
            Z2=zeros(size(X2));
            
            idx=1:size(X2,1)*size(X2,2);
            X3=reshape(X2,1,[]);
            Y3=reshape(Y2,1,[]);
            XY2=vertcat(X3,Y3);
            
            nidx2=[];
            nidx=[];
            for i=1:length(usech)
                d1=squareform(pdist([BrainCoord(p).xy(:,usech(i)) XY2]'));
                d2=d1(1,2:end);
                [aidx,bidx]=find(d2<20);
                [aidx2,bidx2]=find(d2>0 & d2<10);
                nidx=[nidx bidx];
                nidx2=[nidx2 bidx2];
            end
            idx=setdiff(1:length(X3),unique(nidx));
            idx2=unique(nidx2);
            idx3=setdiff(1:length(X3),idx2);
            %[Xq,Yq,Vq]=griddata([X3(idx) BrainCoord(p).xy(1,usech)],[ Y3(idx) BrainCoord(p).xy(2,usech)],[reshape(Z2(idx),1,[]) d'],X,Y,'v4');
            [Xq,Yq,Vq]=griddata([ X3(idx) BrainCoord(p).xy(1,skipch) BrainCoord(p).xy(1,usech)],...
                [Y3(idx)  BrainCoord(p).xy(2,skipch) BrainCoord(p).xy(2,usech)],...
                [reshape(Z2(idx),1,[]) zeros(1,length(skipch)) d'],X,Y,'v4');
            
            
            %[Xq,Yq,Vq]=griddata(BrainCoord(p).xy(1,usech),BrainCoord(p).xy(2,usech),d,X,Y);
            Vq(find(isnan(Vq)))=0;
            
            tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
            tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
            tmp3(find(tmp3<0))=0;
            tmp4=tmp3./maxZ;
            tmp4=smooth2(tmp4,10);
            %%
            ha=axes('position',pos);
            %imagesc(repmat(a,[1 1 3]))
            imshow(repmat(a,[1 1 3]))
            set(ha,'handlevisibility','off', ...
                'visible','off')
            ha=axes('position',pos);
            imshow(repmat(a,[1 1 3]))
            hold on
            goodch=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,AllP{p}.Tall{2}.Data.Artifacts.badChannels);
            
            scatter(BrainCoord(p).xy(1,goodch),BrainCoord(p).xy(2,goodch),30,rgb('gray'),'fill')
            hold on
            imshow(repmat(a,[1 1 3]))
            alpha(.5)
            
            
            set(ha,'handlevisibility','off', ...
                'visible','off')
            ha=axes('position',pos);
            imshow(tmp3,[0 4])
            tmp4=tmp4./max(max(tmp4));
            tmp4=tmp4*2;
            tmp4(find(tmp4>.9))=.9;
            %alpha(smooth2(tmp5,1));
            alpha(tmp4)
            if eidx==2
                colormap(redblackwhite)
                freezeColors
            else
                colormap(blueblackwhite)
                freezeColors
            end
            
            if s>=200
                stext=-(samps(1)*10-2000);
            else
                stext=(samps(1)*10-2000);
            end
            
            if 1%eidx==2
                h=text(0,pos(2)-60,[num2str(stext) ' ms'],'Fontsize',16)
            end
            if stext>=0
                %set(h,'BackgroundColor','y')
                if eidx==2
                    set(h,'Color','r');
                else
                    set(h,'Color','b');
                end
            end
            if eidx==2
                text(0,pos(2)+200,['Perception'],'Fontsize',12);
            else
                text(0,pos(2)+200,['Production'],'Fontsize',12);
            end
            
            ha=axes('position',[.25,.85 .50 .100]);
            hp=patch([s*length(sound)/100 s*length(sound)/100 (s+.4)*length(sound)/100 (s+.4)*length(sound)/100],[-10 10 10 -10],'y');
            set(hp,'EdgeColor','none','FaceAlpha',1)
            hold on
            plot(sound,'k')
            set(gca,'Box','off','XTick',0:length(sound)/4:length(sound),'Visible','off')
            %set(gca,'XTickLabel',[-2000:1000:2000])
            axis([0 length(sound) min(sound) max(sound)])
            hl=line([length(sound)/2 length(sound)/2],[-10 10]);
            set(hl,'Color','k','LineStyle','--')
            %axis([0 length(sound) -1 1])
            %hcbar=colorbar;
            %set(get(hcbar,'ylabel'),'String', 'zscore');
            %set(hcbar,'Location','East','YAxisLocation','right')
            %hold on
            %scatter(BrainCoord(p).xy(1,usech)',BrainCoord(p).xy(2,usech)',100,colorjet(ceil((d./max(d))*(length(colorjet)-1))+1,:),'fill')
            %M(s+1)=getframe;
            %clf
            %M(s)=getframe(gca,pos.*[hpos(3) hpos(4) hpos(3) hpos(4)]);
            MovieHold{p,eidx}.M(s)=getframe(gcf);
        end
        fps=10
        movie2avi(MovieHold{p,eidx}.M,['E:\DelayWord\ActivationMovie\' 's' int2str(p) '_e' int2str(eidx) '_-2000to2000' '_fps', int2str(fps)],'fps',fps)
        %input('n')
    end
end










%%
opengl software
%figure
set(gcf,'Color','w')
colorjet=flipud(hot)
stepSize=2
maxZ=4;
for s=1:200/stepSize
    %%
    for p=1:8
        for eidx=[2 4 5]
            %%
            e=find([2 4 5]==eidx);
            r=rem(s,10);
            if r==0
                r=10;
            end
            %pos=subplotMinGray(10,10,ceil(s/10),r-1);
            pos=subplotMinGray(8,3,p,e-1);
            samps=[s*stepSize+100:(s+1)*stepSize+100];
            usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]),reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);
            d=mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,samps,:,usetr),4),2);
            d(find(d<0))=0;
            a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain3.jpg']);
            limx=size(a,2);
            limy=size(a,1);
            grain=20;
            gx=1:grain:limx;
            gy=1:grain:limy;
            [X,Y] = MESHGRID(gx,gy);
            [Xq,Yq,Vq]=griddata(BrainCoord(p).xy(1,usech),BrainCoord(p).xy(2,usech),d,X,Y);
            Vq(find(isnan(Vq)))=0;
            
            tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
            tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
            tmp3(find(tmp3<0))=0;
            tmp4=tmp3./maxZ;
            tmp4=smooth2(tmp4,10);
            
            ha=axes('position',pos);
            %imagesc(repmat(a,[1 1 3]))
            imshow(repmat(a,[1 1 3]))
            hold on
            set(ha,'handlevisibility','off', ...
                'visible','off')
            ha=axes('position',pos);
            imshow(tmp3,[0 4])
            tmp4=tmp4./max(max(tmp4));
            tmp4=tmp4*2;
            tmp4(find(tmp4>1))=1;
            %alpha(smooth2(tmp5,1));
            alpha(tmp4)
            colormap(flipud(hot))
            if s>200
                stext=-(samps(1)-100)*10;
            else
                stext=(samps(1)-200)*10;
            end
            text(pos(1),pos(2),num2str(stext),'Fontsize',10)
            %hold on
            %scatter(BrainCoord(p).xy(1,usech)',BrainCoord(p).xy(2,usech)',100,colorjet(ceil((d./max(d))*(length(colorjet)-1))+1,:),'fill')
            %M(s+1)=getframe;
            %clf
        end
    end
    %keyboard
    saveppt2('ppt',powerpoint_object,'stretch','off','d','meta');
    clf
end
%% ON COMMON BRAIN EC16


opengl software
%figure
colorjet=flipud(hot)
stepSize=4
maxZ=4;

for s=50:400/stepSize
    %%
    clf
    for eidx=[2 5]
        %%
        for p=1:8
            %%
            close all
            figure('position',[ 100 31 800 800],'units','Normalize','Color','w')
            
            r=rem(s,10);
            if r==0
                r=10;
            end
            pos=subplotMinGray(1,1,1,0);
            pos(4)=pos(4)/2;
            if eidx==2
                pos(2)=pos(2)+pos(4);
            end
            
            samps=[s*stepSize:(s+1)*stepSize];
            usetr=1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.event,1);
            %usech=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh']);
            usech=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,AllP{p}.Tall{2}.Data.Artifacts.badChannels);
            skipch=setdiff(1:AllP{p}.Tall{2}.Data.channelsTot,usech);
            d=mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,samps,:,usetr),4),2);
            d(find(d<0))=0;
            %a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
            
            if flag==1
                a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
            else
                a=imread(['E:\DelayWord\allBrainPics\' AllP{p}.Tall{5}.Data.patientID 'scaled.jpg']);
            end
            
            limx=size(a,2);
            limy=size(a,1);
            grain=20;
            gx=1:grain:limx;
            gy=1:grain:limy;
            [X,Y] = MESHGRID(gx,gy);
            
            grain2=30;
            gx2=1:grain2:limx;
            gy2=1:grain2:limy;
            [X2,Y2] = MESHGRID(gx2,gy2);
            Z2=zeros(size(X2));
            
            idx=1:size(X2,1)*size(X2,2);
            X3=reshape(X2,1,[]);
            Y3=reshape(Y2,1,[]);
            XY2=vertcat(X3,Y3);
            
            nidx2=[];
            nidx=[];
            for i=1:length(usech)
                d1=squareform(pdist([BrainCoord(p).newXY(:,usech(i)) XY2]'));
                d2=d1(1,2:end);
                [aidx,bidx]=find(d2<20);
                [aidx2,bidx2]=find(d2>0 & d2<10);
                nidx=[nidx bidx];
                nidx2=[nidx2 bidx2];
            end
            idx=setdiff(1:length(X3),unique(nidx));
            idx2=unique(nidx2);
            idx3=setdiff(1:length(X3),idx2);
            [Xq,Yq,Vq]=griddata([X3(idx) BrainCoord(p).newXY(1,usech)],[ Y3(idx) BrainCoord(p).newXY(2,usech)],[reshape(Z2(idx),1,[]) d'],X,Y,'v4');
            
            %[Xq,Yq,Vq]=griddata(BrainCoord(p).xy(1,usech),BrainCoord(p).xy(2,usech),d,X,Y);
            Vq(find(isnan(Vq)))=0;
            VqHold(p,eidx,s,:,:)=Vq;
        end
        %M(s)=getframe(gcf);
    end
    %input('n')
    %MovieHold{p,flag,eidx}.M=M;
end
end
%%
save('Vq3','Vq')
figure('position',[ 100 31 800 800],'units','Normalize','Color','w')
for p=1:8
    %%
    for s=1:400/stepSize
        clf
        for eidx=[2 5]
            r=rem(s,10);
            if r==0
                r=10;
            end
            pos=subplotMinGray(1,1,1,0);
            pos(4)=pos(4)/2;
            if eidx==2
                pos(2)=pos(2)+pos(4);
            end
            
            
            if flag==1
                a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
            else
                a=imread(['E:\DelayWord\allBrainPics\' AllP{p}.Tall{5}.Data.patientID 'scaled.jpg']);
            end
            
            samps=[s*stepSize:(s+1)*stepSize];
            Vq=squeeze(mean(VqHold(:,eidx,s,:,:),1));
            tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
            tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
            tmp3(find(tmp3<0))=0;
            tmp4=tmp3./maxZ;
            tmp4=smooth2(tmp4,10);
            
            ha=axes('position',pos);
            %imagesc(repmat(a,[1 1 3]))
            try
                imshow(repmat(a,[1 1 3]))
            catch
                imshow(a)
            end
            set(ha,'handlevisibility','off', ...
                'visible','off')
            ha=axes('position',pos);
            try
                imshow(repmat(a,[1 1 3]))
            catch
                imshow(a)
            end
            hold on
            scatter(BrainCoord(p).xy(1,:),BrainCoord(p).xy(2,:),30,rgb('gray'),'fill')
            hold on
            try
                imshow(repmat(a,[1 1 3]))
            catch
                imshow(a)
            end
            alpha(.5)
            
            
            set(ha,'handlevisibility','off', ...
                'visible','off')
            ha=axes('position',pos);
            imshow(tmp3,[0 4])
            tmp4=tmp4./max(max(tmp4));
            tmp4=tmp4*2;
            tmp4(find(tmp4>.9))=.9;
            %alpha(smooth2(tmp5,1));
            alpha(tmp4)
            if eidx==2
                colormap(redblackwhite)
                freezeColors
            else
                colormap(blueblackwhite)
                freezeColors
            end
            
            if s>200
                stext=-(samps(1)-100)*10;
            else
                stext=(samps(1)-200)*10;
            end
            
            if eidx==2
                h=text(pos(1),pos(2)+50,[num2str(stext) ' ms'],'Fontsize',16)
            end
            if stext>=0
                set(h,'BackgroundColor','y')
            end
            if eidx==2
                text(-20,pos(2)+200,['Perception'],'Fontsize',12);
            else
                text(-20,pos(2)+200,['Production'],'Fontsize',12);
            end
            
            hpos=get(gcf,'Position')
        end
        M(s)=getframe(gcf);
    end
    MovieHold{p}.M=M;
end
%%

for p=1:8
    subplot(1,8,p)
    imagesc(squeeze(VqHold(p,eidx,s,:,:)))
end
%% PLOT ACTIVATION DOTS ON REGULAR AND NORMAL BRAIN
set(gcf,'Color','w')
stepSize=10
colorjet=jet
for s=1:400/stepSize
    for eidx=[2 5]
        e=find([2 5]==eidx);
        subplot(2,9,(e-1)*9+9)
        a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
        imshow(a)
        hold on
        for p=1:8
            %get data
            samps=[s*stepSize:(s+1)*stepSize];
            d=squeeze(mean(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,samps,:,:),4),2));
            d(find(d<1))=0;
            
            %plot on patient brain
            subplot(2,9,(e-1)*9+p)
            a=imread(['E:\DelayWord\allBrainPics\' AllP{p}.Tall{5}.Data.patientID 'scaled.jpg']);
            imshow(a)
            hold on
            scatter(BrainCoord(p).xySF(1,:),BrainCoord(p).xySF(2,:),'fill','b')
            scatter(BrainCoord(p).xyCS(1,:),BrainCoord(p).xyCS(2,:),'fill','b')
            scatter(BrainCoord(p).xy(1,find(d))',BrainCoord(p).xy(2,find(d))',50,repmat(colorjet(round((length(colorjet)/8)*p),:),length(find(d)),1),'fill')
            
            %plot on normal brain
            subplot(2,9,(e-1)*9+9)
            scatter(BrainCoord(2).xySF(1,:),BrainCoord(2).xySF(2,:),'fill','b')
            scatter(BrainCoord(2).xyCS(1,:),BrainCoord(2).xyCS(2,:),'fill','b')
            scatter(BrainCoord(p).newXY(1,find(d))',BrainCoord(p).newXY(2,find(d))',50,repmat(colorjet(round((length(colorjet)/8)*p),:),length(find(d)),1),'fill')
            hold on
            if s>200
                stext=-(samps(1)-100)*10;
            else
                stext=(samps(1)-200)*10;
            end
            
            if eidx==2
                h=text(0,0+50,[num2str(stext) ' ms'],'Fontsize',16)
            end
        end
        
    end
    input('n')
    clf
end
%% CHECK QUADRANT OF NORMALIZED ELECTRODES


for p=1:8
    quad{p}=getBrainQuadrant(BrainCoord(p).xySF,BrainCoord(p).xyCS,BrainCoord(p).xy);
end

for q=1:4
    a=imread(['E:\General Patient Info\EC16\brain5.jpg']);
    imshow(a)
    hold on
    p=2
    scatter(BrainCoord(p).xySF(1,:),BrainCoord(p).xySF(2,:),'fill','b')
    scatter(BrainCoord(p).xyCS(1,:),BrainCoord(p).xyCS(2,:),'fill','b')
    
    
    for p=1:8
        hold on
        ch=find(quad{p}==q);
        scatter(BrainCoord(p).newXY(1,ch),BrainCoord(p).newXY(2,ch),50,'fill','r')
    end
    input('n')
    clc
end






