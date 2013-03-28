function q=getBrainQuadrant(xySF,xyCS,xy)

for i=1:size(xy,2)
    idx=findNearest(xy(1,i),xySF(1,:));
    if xy(2,i)<xySF(2,idx)
        aboveSF=1;
    else
        aboveSF=0;
    end
    
    idx=findNearest(xy(2,i),xyCS(2,:));
    if xy(1,i)>xyCS(1,idx)
        beforeCS=1;
    else
        beforeCS=0;
    end
    
    if beforeCS==1 & aboveSF==1
        q(i)=1;
    elseif beforeCS==0 & aboveSF==1
        q(i)=2;
    elseif beforeCS==0 & aboveSF==0
        q(i)=3;
    elseif beforeCS==1 & aboveSF==0
        q(i)=4;
    end
end