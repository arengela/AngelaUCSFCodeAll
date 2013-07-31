function [newXY,BrainCoord]=gridToNormalizedBrain2(BrainCoord,patients)
for p1=[1:8]
    [distSF,distCS,qHold,extra,newSFHold]=gridCoodinates(BrainCoord(p1).xySF',BrainCoord(p1).xyCS',BrainCoord(p1).xy');
    
    clf
    p2=2
    [newXY]=coordinatesToBrain(BrainCoord(p2).xySF',BrainCoord(p2).xyCS',BrainCoord(p2).xy',distSF,distCS,qHold,[],BrainCoord,p1,p2,extra,newSFHold)
    BrainCoord(p1).newXY=newXY';
    BrainCoord(p1).qHold=qHold;
    %input('n')
end

end

function [distSFHold,distCSHold,qHold,extra,newSFHold]=gridCoodinates(SF,CS,XY)

[~,sortidx]=sort(SF(:,1));
SF=SF(sortidx,:);
%XY=BrainCoord(p).xy'
[~,sortidx]=sort(CS(:,2));
CS=CS(sortidx,:);
for i=1
    %SF(:,1)=smooth(SF(:,1),300);
    %SF(:,2)=smooth(SF(:,2),300);
    CS(:,1)=smooth(CS(:,1),300);
    CS(:,2)=smooth(CS(:,2),300);
end
clf
hold on
scatter(SF(:,1),SF(:,2),'fill');
scatter(CS(:,1),CS(:,2),'fill');

dist=squareform(pdist([SF' CS']'));
dist=dist(length(SF)+1:end,1:length(SF));

[dist2,idx1]=min(dist);
[dist2,idx2]=min(dist2);
idx1=idx1(idx2);
scatter(CS(idx1,1),CS(idx1,2));
scatter(SF(idx2,1),SF(idx2,2));

if CS(idx1,2)> SF(idx2,1)
    idx3=idx1-1;
else
    idx3=idx1+1;
end

scatter(CS(idx3,1),CS(idx3,2),'fill');
%%
for i=1:1:length(XY)
    %%
    xyDot=XY(i,:);
    scatter(xyDot(1),xyDot(2),'fill')
    q=getBrainQuadrant(SF',CS',xyDot');
    
    if q==3
        q=4;
    elseif q==4
        q=3;
    end
    qHold(i)=q;
    
    
    if ismember(q,[3 4])
        steps=idx1:length(CS);
    else
        steps=idx1:-1:1;
    end
    distMat=zeros(length(steps),length(SF))+1000;
    c=polyfit(CS(idx1-2:idx1+2,1),CS(idx1-2:idx1+2,2),1);
    p0=polyval(c,CS(idx1-2:idx1+2,1));
    %theta0=atan((p-CS(idx1,2))/(CS(idx1-2,1)-CS(idx1,1)));
        clear t

    t=zeros(length(steps),length(SF)-1);
    for sidx=1:1:length(steps)
        %%
        s=steps(sidx);
        yDis=CS(s,2)-CS(idx1,2);
        xDis=CS(s,1)-CS(idx1,1);
        newSF=SF+repmat([xDis yDis],length(SF),1);
        
        try
            c=polyfit(CS(s-2:s+2,1),CS(s-2:s+2,2),1);
            p=polyval(c,CS(s-2:s+2,1));
            va=diff([CS([idx1-2,idx1+2],1) p0([1,end])],[],1)';
            vb=diff([CS([s-2,s+2],1) p([1,end])],[],1)';
            theta =- mod( atan2( det([va,vb]) , dot(va,vb) ) , 2*pi);
            %theta=abs(atan((p-CS(s,2))/(CS(s-2,1)-CS(s,1))))-abs(theta0);%-theta0;
            center=repmat(newSF(idx2,:),size(newSF,1),1);
            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            newSFo = (newSF - center)*R + center;

            tmp=squareform(pdist([newSFo;xyDot]));
            distMat(sidx,:)=tmp(1:end-1,end);     
            
            
            idxOrdered=[steps(1:sidx)];
            dist=(squareform(pdist([CS(idxOrdered,:),CS(idxOrdered,:)])));
            zMat=zeros(length(idxOrdered));
            zMat(1:end-1,2:end)=eye(length(idxOrdered)-1);
            distCS=sum(dist.*zMat); distCS=distCS(2:end);
            distCS=sum(distCS);
            
            idxOrdered=1:length(newSFo);
            dist=(squareform(pdist([newSFo(idxOrdered,:),newSFo(idxOrdered,:)])));
            zMat=zeros(length(idxOrdered));
            zMat(1:end-1,2:end)=eye(length(idxOrdered)-1);
            distSF=sum(dist.*zMat); distSF=distSF(2:end);
            distSF=cumsum(distSF);
            
            t(sidx,:)=repmat(distCS,1,length(distSF));%distSF+distCS;
            
%             xvec =1:length(distCS);
%             yvec = 1:length(distSF);
%             [x y] = meshgrid(xvec,yvec);
%             t = (x+y)';
            %scatter(newSFo(:,1),newSFo(:,2),'fill');
        catch
            distMat(sidx,:)=1000;
             t(sidx,:)=1000;
        end
        %input('b')
    end
    t=t(1:end-1,:);
    [~,minidx]=min(distMat(:));
    [c,minSFidx]=ind2sub(size(distMat),minidx);
    minCSidx=steps(c);
    
    distMat2=distMat(2:end,2:end);
    l=prctile(distMat2(:),1)
    distMat2(find(distMat2>l))=1000;
    distMat3=distMat2+t;
    %imagesc(distMat3)
    [~,b]=min(distMat3(:));
    [c,minSFidx]=ind2sub(size(distMat3),b)
    minCSidx=steps(c);

    
    
    s=minCSidx;
    yDis=CS(s,2)-CS(idx1,2);
    xDis=CS(s,1)-CS(idx1,1);
    newSF=SF+repmat([xDis yDis],length(SF),1);
    
    try
         c=polyfit(CS(s-2:s+2,1),CS(s-2:s+2,2),1);
            p=polyval(c,CS(s-2:s+2,1));
            va=diff([CS([idx1-2,idx1+2],1) p0([1,end])],[],1)';
            vb=diff([CS([s-2,s+2],1) p([1,end])],[],1)';
            theta =- mod( atan2( det([va,vb]) , dot(va,vb) ) , 2*pi);
        center=repmat(newSF(idx2,:),size(newSF,1),1);
        R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
        newSFo = (newSF - center)*R + center;
        newSF=newSFo;
        %newSFo=newSF;
        tmp=squareform(pdist([newSFo;xyDot]));
        distMat(sidx,:)=tmp(1:end-1,end);
        scatter(newSFo(:,1),newSFo(:,2),'fill');
    end
    
    
    idxOrdered=sort([idx1,minCSidx]);
    dist=(squareform(pdist([CS(idxOrdered(1):idxOrdered(2),:),CS(idxOrdered(1):idxOrdered(2),:)])));
    zMat=zeros(length(idxOrdered(1):idxOrdered(2)));
    zMat(1:end-1,2:end)=eye(length(idxOrdered(1):idxOrdered(2))-1);
    distCS=sum(dist.*zMat); distCS=distCS(2:end);
    distCSHold(i)=sum(distCS);
    if ismember(q,[1 2])
        extra(i,2)=-(xyDot(2)-newSF(minSFidx,2));
        %distCSHold(i)=sum(distCS)-(xyDot(2)-newSF(minSFidx,2));
    else
        extra(i,2)=(xyDot(2)-newSF(minSFidx,2));
        %distCSHold(i)=sum(distCS)+(xyDot(2)-newSF(minSFidx,2));
    end
    idxOrdered=sort([idx2,minSFidx]);
    dist=(squareform(pdist([SF(idxOrdered(1):idxOrdered(2),:),SF(idxOrdered(1):idxOrdered(2),:)])))    ;
    zMat=zeros(length(idxOrdered(1):idxOrdered(2)));
    zMat(1:end-1,2:end)=eye(length(idxOrdered(1):idxOrdered(2))-1);
    distSF=sum(dist.*zMat);
    distSF=distSF(2:end);
    distSFHold(i)=sum(distSF);
    
     if ismember(q,[2 4])
        extra(i,1)=-(xyDot(1)-newSF(minSFidx,1));
        %distSFHold(i)=distSFHold(i)-(xyDot(1)-newSF(minSFidx,1));  
     else
        extra(i,1)=(xyDot(1)-newSF(minSFidx,1));
        %distSFHold(i)=distSFHold(i)+(xyDot(1)-newSF(minSFidx,1));     
     end
     newSFHold(i,:,:)=newSFo;
    
    %input('n')
end
end



function     [newXY]=coordinatesToBrain(SF,CS,XY,distSFHold,distCSHold,qHold,patients,BrainCoord,p1,p2,extra,newSFHold)
%%
clf
colorcell={'r','g','b','k'};
p=p2
for i=1
    CS(:,1)=smooth(CS(:,1),200);
    CS(:,2)=smooth(CS(:,2),200);
    %SF(:,1)=smooth(SF(:,1),200);
    %SF(:,2)=smooth(SF(:,2),200);
end
%     SF=BrainCoord(p).xySF'
%     CS=BrainCoord(p).xyCS'
subplot(1,2,1)
%visualizeGrid(0,['E:\DelayWord\allBrainPics\' patients{p} 'scaled.jpg'],[],[],[],[],[],[],1);
hold on
scatter(SF(:,1),SF(:,2),'fill')
scatter(CS(:,1),CS(:,2),'fill')

subplot(1,2,2)
p=p1
%visualizeGrid(0,['E:\DelayWord\allBrainPics\' patients{p}  'scaled.jpg'],[],[],[],[],[],[],1);
hold on
scatter(smooth(BrainCoord(p).xySF(1,:),200),smooth(BrainCoord(p).xySF(2,:),200),'fill')
scatter(smooth(BrainCoord(p).xyCS(1,:),200),smooth(BrainCoord(p).xyCS(2,:),200),'fill')

hold on

[~,sortidx]=sort(SF(:,1));
SF=SF(sortidx,:);


[~,sortidx]=sort(CS(:,2));
CS=CS(sortidx,:);

dist=squareform(pdist([SF' CS']'));
dist=dist(length(SF)+1:end,1:length(SF));

[dist2,idx1]=min(dist);
[dist2,idx2]=min(dist2);
idx1=idx1(idx2);
subplot(1,2,1);

scatter(CS(idx1,1),CS(idx1,2));
scatter(SF(idx2,1),SF(idx2,2));

if CS(idx1,2)> SF(idx2,1)
    idx3=idx1-1;
else
    idx3=idx1+1;
end
scatter(CS(idx3,1),CS(idx3,2),'fill');
%%
for i=1:1:length(distCSHold)
    %%
    subplot(1,2,2);
    p=p1;
    
    
    scatter(BrainCoord(p).xy(1,i),BrainCoord(p).xy(2,i),'fill',colorcell{qHold(i)});
    

    
    if ismember(qHold(i),[3 4])
        steps=idx1:length(CS);
    else
        steps=1:idx1;
    end
    
    %scatter(CS(steps,1),CS(steps,2));
    dist=(squareform(pdist([CS(steps,:),CS(steps,:)])));
    zMat=zeros(length(steps));
    zMat(1:end-1,2:end)=eye(length(steps)-1);
    distCS=sum(dist.*zMat);
    distCS=distCS(2:end);
    if ismember(qHold(i),[1 2])
        distCS=fliplr(distCS);
        steps=fliplr(steps);
    end
        
    aggregateSum=cumsum(distCS);
    idxtmp1=findNearest(distCSHold(i),aggregateSum);
    
    CSidx=steps(idxtmp1);
    
    if ismember(qHold(i),[1 3])
        steps=idx2:length(SF);
    else
        steps=1:idx2;
    end

    
    yDis=CS(CSidx,2)-CS(idx1,2);
    xDis=CS(CSidx,1)-CS(idx1,1);
    
    newSF=SF+repmat([xDis yDis],length(SF),1);
    %SF=newSF;
    %scatter(SF(steps,1),SF(steps,2));
    dist=(squareform(pdist([newSF(steps,:),newSF(steps,:)])));
    zMat=zeros(length(steps));
    zMat(1:end-1,2:end)=eye(length(steps)-1);
    distSF=sum(dist.*zMat);
    distSF=distSF(2:end);
    if ismember(qHold(i),[2 4])
        distSF=fliplr(distSF);
        steps=fliplr(steps);
    end
    
    aggregateSum=cumsum(distSF);
    idxtmp=findNearest(distSFHold(i),aggregateSum);
    
    SFidx=steps(idxtmp);
    s=CSidx;
   
     c=polyfit(CS(idx1-2:idx1+2,1),CS(idx1-2:idx1+2,2),1);
    p0=polyval(c,CS(idx1-2:idx1+2,1));
    
    
    try
         c=polyfit(CS(s-2:s+2,1),CS(s-2:s+2,2),1);
            p=polyval(c,CS(s-2:s+2,1));
            va=diff([CS([idx1-2,idx1+2],1) p0([1,end])],[],1)';
            vb=diff([CS([s-2,s+2],1) p([1,end])],[],1)';
            theta =- mod( atan2( det([va,vb]) , dot(va,vb) ) , 2*pi);
        center=repmat(newSF(idx2,:),size(newSF,1),1);
        R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
        newSFo = (newSF - center)*R + center;   
        %newSFo=newSF;


        subplot(1,2,2)
        scatter(squeeze(newSFHold(i,:,1)),squeeze(newSFHold(i,:,2)),'fill');


        subplot(1,2,1)
        hold on
       %scatter((newSFo(:,1)),newSFo(:,2),'fill');

        newXY(i,:)=newSFo(SFidx,:);
        if ismember(qHold(i),[2 4])
            newXY(i,1)=newXY(i,1)-extra(i,1)-(distSFHold(i)-sum(distSF(1:idxtmp)));
        else
            newXY(i,1)=newXY(i,1)+extra(i,1)+(distSFHold(i)-sum(distSF(1:idxtmp)));
        end

        if ismember(qHold(i),[3 4])
            newXY(i,2)=newXY(i,2)+extra(i,2)-(distCSHold(i)-sum(distCS(1:idxtmp1)));
        else
            newXY(i,2)=newXY(i,2)-extra(i,2)+(distCSHold(i)-sum(distCS(1:idxtmp1)));
        end
        scatter(newXY(i,1),newXY(i,2),'fill',colorcell{qHold(i)})
    end
    %input('b')
end
%%
%input('n')
clf
end

