figure
set(gcf,'Color','w')
maxZ=.7
for p=1:length(patients)-1
        %%
        for eidx=[2 4 5]
        %%
        e=find([2 4 5]==eidx);
        pos=subplotMinGray(3,9,e,p-1);
        %pos=subplotMinGray(3,1,e,0);
        %pos=subplotMinGray(1,1,1,0);
        usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
        d=cell2mat(cellfun(@nanmedian,{AllP{p}.E{eidx}.electrodes(:).maxIdxTr},'UniformOutput',0))*10;
        usech=find(~isnan(d));
        %d=d(usech);
        d=2700-d;
        d(isnan(d))=0;
        a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain3.jpg']);
        
        limx=size(a,2);
        limy=size(a,1);
        grain=1;
        gx=1:grain:limx;
        gy=1:grain:limy;
        [X,Y] = MESHGRID(gx,gy);
        Z=zeros(size(X));

        grain2=30;
        gx2=1:grain2:limx;
        gy2=1:grain2:limy;
        [X2,Y2] = MESHGRID(gx2,gy2);
        Z2=zeros(size(X2));

        clf
        %figure
        maxVq=0.8;
        colorjet=flipud(hot);
        %idx=ceil(rand(1,500)*size(X2,1)*size(X2,2));
        idx=1:size(X2,1)*size(X2,2);
        X3=reshape(X2,1,[]);
        Y3=reshape(Y2,1,[]);

        XY2=vertcat(X3,Y3);

%         limx=size(a,2);
%         limy=size(a,1);
%         grain=1;
%         gx=1:grain:limx;
%         gy=1:grain:limy;
%         [X,Y] = MESHGRID(gx,gy);
%         Z=zeros(size(X));
% 
%         grain2=10;
%         gx2=1:grain2:limx;
%         gy2=1:grain2:limy;
%         [X2,Y2] = MESHGRID(gx2,gy2);
%         Z2=zeros(size(X2));
% 
%         clf
%         %figure
%         maxVq=0.8;
%         colorjet=flipud(hot);
%         %idx=ceil(rand(1,500)*size(X2,1)*size(X2,2));
%         idx=1:size(X2,1)*size(X2,2);
%         X3=reshape(X2,1,[]);
%         Y3=reshape(Y2,1,[]);
% 
%         XY2=vertcat(X3,Y3);
%         
%         limx=size(a,2);
%         limy=size(a,1);
%         grain=20;
%         gx=1:grain:limx;
%         gy=1:grain:limy;
%         [X,Y] = MESHGRID(gx,gy);
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
        [Xq,Yq,Vq]=griddata([X3(idx) BrainCoord(p).xy(1,usech)],[ Y3(idx) BrainCoord(p).xy(2,usech)],[reshape(Z2(idx),1,[]) d(usech)],X,Y,'v4');

        
        limx=size(a,2);
        limy=size(a,1);
        grain=1;
        gx=1:grain:limx;
        gy=1:grain:limy;
        [X,Y] = MESHGRID(gx,gy);
        Z=zeros(size(X));  
        %[Xq2,Yq2,Vq2]=griddata([X3(idx3) X3(idx2) ],[Y3(idx3)  Y3(idx2)],[reshape(Z2(idx3),1,[]) reshape(Z2(idx2),1,[])+1],X,Y,'v4');
        [Xq2,Yq2,Vq2]=griddata([X3(idx3) BrainCoord(p).xy(1,usech) ],[Y3(idx3)  BrainCoord(p).xy(2,usech)],[reshape(Z2(idx3),1,[]) ones(1,length(usech))],X,Y,'v4');
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
        imshow(tmp3,[100 500])
        tmp4=tmp4./max(max(tmp4));
        tmp4=tmp4*2;
        tmp4(find(tmp4>.9))=.9;
        %alpha(smooth2(tmp5,1));
        alpha(tmp4)
        colormap(flipud(hot))

        alpha(smooth2(double(Vq2./1.5>.6),6)./max(max(smooth2(double(Vq2./1.5>.6),6))))

%         d=cell2mat(cellfun(@nanmedian,{AllP{p}.E{eidx}.electrodes.maxAmpTr},'UniformOutput',0));
%         usech=1:length(d);%find(~isnan(d));
%         %d=d(usech);
%         %d=3000-d;
%         d(isnan(d))=0;
%         a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain3.jpg']);
%         limx=size(a,2);
%         limy=size(a,1);
%         grain=20;
%         gx=1:grain:limx;
%         gy=1:grain:limy;
%         [X,Y] = MESHGRID(gx,gy);
%         [Xq,Yq,Vq]=griddata(BrainCoord(p).xy(1,usech),BrainCoord(p).xy(2,usech),d,X,Y);
%         Vq(find(isnan(Vq)))=0;
% 
%         tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
%         tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
%         tmp3(find(tmp3<0))=0;
%         tmp4=tmp3./maxZ;
%         tmp4=smooth2(tmp4,10);
% 
%         ha=axes('position',pos);
%         %imagesc(repmat(a,[1 1 3]))
%         imshow(repmat(a,[1 1 3]))
%         hold on
%         set(ha,'handlevisibility','off', ...
%             'visible','off')
%         ha=axes('position',pos);
%         imshow(tmp3,[0 1000])
%          tmp4=tmp4./max(max(tmp4));
%          tmp4=tmp4*2;
%          tmp4(find(tmp4>.9))=.9;
%         %alpha(smooth2(tmp5,1));
%         alpha(tmp4)
%         colormap(flipud(hot))  
%         
%         plotCh{p}=find(d~=0);
%         xy=BrainCoord(p).xy(:,plotCh{p})
%         hold on
%         t=text(xy(1,:),xy(2,:),cellfun(@num2str,num2cell(plotCh{p}),'UniformOutput',0));
%         set(t,'FontSize',8,'Color','b')
        %hold on
        %scatter(BrainCoord(p).xy(1,usech),BrainCoord(p).xy(2,usech),100,d(usech),'fill')
        %keyboard
    end
end
%% GET MAX TIME %% SCATTER ON BRAIN
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\hot_adjusted')
clear tmp
for p=1:length(patients)-1
    for eidx=[2 4 5]
        tmpmax(p,eidx)=prctile(cell2mat(cellfun(@nanmedian,{AllP{p}.E{eidx}.electrodes(:).maxIdxTr},'UniformOutput',0))*10,90);
        tmpmin(p,eidx)=prctile(cell2mat(cellfun(@nanmedian,{AllP{p}.E{eidx}.electrodes(:).maxIdxTr},'UniformOutput',0))*10,10);
    end
end
clf
set(gcf,'Color','w')
maxZ=.7
colorjet=colormap(flipud(hot_adjusted))
maxTime=max(tmpmax)
minTime=min(tmpmin)
rangeTime=maxTime-minTime
for p=1:length(patients)-1
        %%
        for eidx=[2 5]
        %%
        if eidx==2
            colorjet=colormap(yellowredblack);
        else
            colorjet=colormap(yellowblueblack);
        end

        e=find([2 5]==eidx);
        pos=subplotMinGray(2,10,e,p-1);
        %pos=subplotMinGray(3,1,e,0);
        pos=subplotMinGray(1,1,1,0);
        usetr=AllP{p}.Tdall{eidx}.Data.Params.usetr;
        d=cell2mat(cellfun(@nanmedian,{AllP{p}.E{eidx}.electrodes(:).maxIdxTr},'UniformOutput',0))*10;
        usech=find(~isnan(d));
        %d=d(usech);
        d=maxTime(eidx)-d;
        d(find(d<=0))=1;
        d(find(d>rangeTime(eidx)))=rangeTime(eidx);
        d(isnan(d))=0;
        a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain3.jpg']);
        
        limx=size(a,2);
        limy=size(a,1);
        grain=1;
        gx=1:grain:limx;
        gy=1:grain:limy;
        [X,Y] = MESHGRID(gx,gy);
        Z=zeros(size(X));

        grain2=30;
        gx2=1:grain2:limx;
        gy2=1:grain2:limy;
        [X2,Y2] = MESHGRID(gx2,gy2);
        Z2=zeros(size(X2));

        maxVq=0.8;

        ha=axes('position',pos);
        %imagesc(repmat(a,[1 1 3]))
        imshow(repmat(a,[1 1 3]))  
        hold on
        %scatter(BrainCoord(p).xy(1,usech),BrainCoord(p).xy(2,usech),21,d(usech),'fill')
        plotManyPolygons([(BrainCoord(p).xy(1,usech));(BrainCoord(p).xy(2,usech))]',30,...
            colorjet(ceil((d(usech))./(maxTime(eidx)-minTime(eidx))*64),:),.8,10)
        
        colormap(colorjet) 
        c=colorbar;
        set(c,'YTickLabel',floor(linspace(minTime(eidx)-2000,maxTime(eidx)-2000,8)))
    end
end


%%
plotCh{1}=[70 119 52  118 151 105 71  39  239 NaN 237 216 203 NaN 111 125 138 187]
plotCh{2}=[93 NaN 24  82  NaN 65  93  84  31  NaN 36  3   86  64  55  NaN NaN NaN]
plotCh{3}=[97 114 141 147 149 NaN 165 NaN 237 148 139 221 45  29  25  220 37]
plotCh{4}=[68 NaN 103 151 103 104 68  32  NaN 149 NaN 5   63  62 76 154]
plotCh{5}=[3  19  59  197 101 NaN NaN NaN 51  NaN 188 248 125 155 92 106 151 183]
plotCh{6}=[52 53  151 214 102 NaN 118 67  235 198 251 199 233 NaN 112 110 96 139 249]
%%
for plotNum=1:20
    for p=1:length(patients)-1
        for eidx=[2 4 5]
            %%
                r=rem(s,10);
                if r==0
                    r=10;
                end
                e=find([2 4 5]==eidx);
                pos=subplotMinGray(3,6,e,p-1);
                pos=subplotMinGray(1,1,1,0);
                subplot('Position',pos)
                if ~isnan(plotCh{p}(plotNum))
                    xy=BrainCoord(p).xy(:,plotCh{p}(plotNum))
                    hold on
                    if plotNum==1
                        t{p,eidx}=text(xy(1,:),xy(2,:),['. ' num2str(plotCh{p}(plotNum))]);
                    end
                    set(t{p,eidx},'FontSize',12,'Color','b','Position',xy,'String',['.' num2str(plotCh{p}(plotNum))],'FontWeight','bold')
                else
                    set(t{p,eidx},'Color','w')
                end
            end
    end
    input('n')
end
        
        