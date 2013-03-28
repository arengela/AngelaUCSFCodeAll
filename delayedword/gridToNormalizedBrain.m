function [newXY,BrainCoord]=gridToNormalizedBrain(BrainCoord,patients)
%     for p=[1 3:8]
%         BrainCoord=getSFCSpoints(BrainCoord,p,patients);
%     end

    for p1=[1:8]    
        [distSF,distCS,qHold]=gridCoodinates(BrainCoord(p1).xySF',BrainCoord(p1).xyCS',BrainCoord(p1).xy')

        p2=2
        [newXY]=coordinatesToBrain(BrainCoord(p2).xySF',BrainCoord(p2).xyCS',BrainCoord(p2).xy',distSF,distCS,qHold,patients,BrainCoord,p1,p2)
        BrainCoord(p1).newXY=newXY';
       %input('n')
    end

end


function BrainCoord=getSFCSpoints(BrainCoord,p,patients)
    visualizeGrid(0,['E:\DelayWord\allBrainPics\' patients{p} 'scaled.jpg'],[],[],[],[],[],[],1);
    BrainCoord(p).xySF=ginput;
    BrainCoord(p).xyCS=ginput;
end


function [distSFHold,distCSHold,qHold]=gridCoodinates(SF,CS,XY)
%%
   %p=8
%     SF=BrainCoord(p).xySF
%     CS=BrainCoord(p).xyCS
      [~,sortidx]=sort(SF(:,1));
    SF=SF(sortidx,:);
    %XY=BrainCoord(p).xy'
    [~,sortidx]=sort(CS(:,2));
    CS=CS(sortidx,:);


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
    

    for i=1:length(XY)
        xyDot=XY(i,:);
        scatter(xyDot(1),xyDot(2),'fill')
        q=getBrainQuadrant(SF',CS',xyDot');
        
        if q==3
            q=4;
        elseif q==4
            q=3;
        end
        qHold(i)=q;
        
        
        idx=findNearest(xyDot(1),SF(:,1));
        idxSF=idx;
        idxOrdered=sort([idx2,idx]);
        scatter(SF(idxOrdered(1):idxOrdered(2)),SF(idxOrdered(1):idxOrdered(2),2));
        dist=(squareform(pdist([SF(idxOrdered(1):idxOrdered(2),:),SF(idxOrdered(1):idxOrdered(2),:)])))    ;
        zMat=zeros(length(idxOrdered(1):idxOrdered(2)));
        zMat(1:end-1,2:end)=eye(length(idxOrdered(1):idxOrdered(2))-1);
        distSF=sum(dist.*zMat);
        distSF=distSF(2:end);       
        if ismember(q,[1 3])
            distSFHold(i)=sum(distSF)-(SF(idx,1)-xyDot(1));
        else
            distSFHold(i)=sum(distSF)+(SF(idx,1)-xyDot(1));
        end

        distCSHold(i)=abs(xyDot(2)-SF(idx,2));
        
        
        
%         idx=findNearest(xyDot(2),CS(:,2)); idxOrdered=sort([idx1,idx]);
%         scatter(CS(idxOrdered(1):idxOrdered(2),1),CS(idxOrdered(1):idxOrdered(2),2));
%         dist=(squareform(pdist([CS(idxOrdered(1):idxOrdered(2),:),CS(idxOrdered(1):idxOrdered(2),:)])));
%         zMat=zeros(length(idxOrdered(1):idxOrdered(2)));
%         zMat(1:end-1,2:end)=eye(length(idxOrdered(1):idxOrdered(2))-1);
%         distCS=sum(dist.*zMat); distCS=distCS(2:end);
%         
%         
%         if ismember(q,[1 2])
%             distCSHold(i)=sum(distCS)+(CS(idx,2)-xyDot(2))-(SF(idx2,2)-SF(idxSF,2));
%         else
%             distCSHold(i)=sum(distCS)-(CS(idx,2)-xyDot(2))-(SF(idx2,2)-SF(idxSF,2));
%         end


    end
end


function     [newXY]=coordinatesToBrain(SF,CS,XY,distSFHold,distCSHold,qHold,patients,BrainCoord,p1,p2)
%%
    colorcell={'r','g','b','k'};
    p=p2
%     SF=BrainCoord(p).xySF'
%     CS=BrainCoord(p).xyCS'
    subplot(1,2,1)    
    visualizeGrid(0,['E:\DelayWord\allBrainPics\' patients{p} 'scaled.jpg'],[],[],[],[],[],[],1);
    hold on
    scatter(SF(:,1),SF(:,2),'fill')
    scatter(CS(:,1),CS(:,2),'fill')
    
    subplot(1,2,2)
    p=p1
    visualizeGrid(0,['E:\DelayWord\allBrainPics\' patients{p}  'scaled.jpg'],[],[],[],[],[],[],1);
    hold on
    scatter(BrainCoord(p).xySF(1,:),BrainCoord(p).xySF(2,:),'fill')
    scatter(BrainCoord(p).xyCS(1,:),BrainCoord(p).xyCS(2,:),'fill')
    
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
    
    for i=1:length(distCSHold)
       
        %%
        subplot(1,2,2);
        p=p1;
        
        
        scatter(BrainCoord(p).xy(1,i),BrainCoord(p).xy(2,i),'fill',colorcell{qHold(i)});
       
        if ismember(qHold(i),[1 3])
            idxOrdered=[idx2  length(SF)];
        else
            idxOrdered=[1 idx2];
        end       
        
        subplot(1,2,1);
        scatter(SF(idxOrdered(1):idxOrdered(2)),SF(idxOrdered(1):idxOrdered(2),2));
        dist=(squareform(pdist([SF(idxOrdered(1):idxOrdered(2),:),SF(idxOrdered(1):idxOrdered(2),:)])))    ;
        zMat=zeros(length(idxOrdered(1):idxOrdered(2)));
        zMat(1:end-1,2:end)=eye(length(idxOrdered(1):idxOrdered(2))-1);
        distSF=sum(dist.*zMat);
        distSF=distSF(2:end);   
        
        if ismember(qHold(i),[2 4])
            distSF=fliplr(distSF);
        end
        
        
        aggregateSum=cumsum(distSF);
        idxtmp=findNearest(distSFHold(i),aggregateSum);
        if ismember(qHold(i),[1 3])
            idx=idx2+idxtmp;
            newX(i)=SF(idx,1)-(aggregateSum(idxtmp)-distSFHold(i));
        else
            idx=idx2-idxtmp;
            newX(i)=SF(idx,1)+(aggregateSum(idxtmp)-distSFHold(i));
        end
        idxSF=idx;
        if ismember(qHold(i),[1 2])
            newY(i)=SF(idx,2)-distCSHold(i);
        elseif ismember(qHold(i),[3 4])
            newY(i)=SF(idx,2)+distCSHold(i);
        end
         
        
%         if ismember(qHold(i),[3 4])
%             idxOrdered=[idx1 length(CS)];
%         else
%             idxOrdered=sort([1 idx1]);
%         end             
%         scatter(CS(idxOrdered(1):idxOrdered(2),1),CS(idxOrdered(1):idxOrdered(2),2));
%         dist=(squareform(pdist([CS(idxOrdered(1):idxOrdered(2),:),CS(idxOrdered(1):idxOrdered(2),:)])));    
%         zMat=zeros(length(idxOrdered(1):idxOrdered(2)));
%         zMat(1:end-1,2:end)=eye(length(idxOrdered(1):idxOrdered(2))-1);
%         distCS=sum(dist.*zMat);
%         distCS=distCS(2:end);
%         
%         if ismember(qHold(i),[1 2])
%             distCS=fliplr(distCS);
%         end
%         
%         aggregateSum=cumsum(distCS);
% 
%         idxtmp=findNearest(distCSHold(i)-(SF(idx2,2)-SF(idxSF,2)),aggregateSum);
%         
%         if ismember(qHold(i),[1 2])
%             idx=idx1-idxtmp;
%             newY(i)=CS(idx,2)+(aggregateSum(idxtmp)-distCSHold(i));%-(SF(idx2,2)-SF(idxSF,2));
%         else
%             idx=idx1+idxtmp;
%             newY(i)=CS(idx,2)-(aggregateSum(idxtmp)-distCSHold(i));%+(SF(idx2,2)-SF(idxSF,2));
%         end       
        
        subplot(1,2,1)
        hold on
        
        
        scatter(newX(i),newY(i),'fill',colorcell{qHold(i)})
    end
    newXY=[newX',newY'];
    input('n')

end


