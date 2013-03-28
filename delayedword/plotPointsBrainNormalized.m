function xy=plotPointsBrainNormalized(devSF,devCS,xySF,xyCS)

newCS(1,:)=devCS+xyCS(1,:);
newCS(2,:)=xyCS(2,:);


newSF(1,:)=xySF(1,:);
newSF(2,:)=xySF(2,:)-devSF;

%scatter(newCS(1,:),newCS(2,:),100,rgb('red'),'fill')
%scatter(newSF(1,:),newSF(2,:),100,rgb('blue'),'fill')

for i=1:length(newSF)
    for j=1:length(newCS)
        d(i,j)=pdist([newSF(:,i),newCS(:,j)]');
    end
end
[a,b]=min(d)   
[a2,b2]=min(a)
minM=b2;
minN=b(b2);
minSF=newSF(:,minN);
minCS=newCS(:,minM);

if minCS(1)>minSF(1)
    minN(2)=minN+1;
else
    minN(2)=minN-1;
end
   
if minCS(2)>minSF(2)
    minM(2)=minM-1;
else
    minM(2)=minM+1;
end
minN=sort(minN);
minM=sort(minM);



try
    p1=polyfit(newCS(1,minM),newCS(2,minM),1);
    p2=polyfit(newSF(1,minN),newSF(2,minN),1);

    btwCS{1}=[round(newCS(1,minM(1))):round(newCS(1,minM(2)))];
    btwCS{2}=[round(newCS(2,minM(1))):round(newCS(2,minM(2)))];

    btwSF{1}=[round(newSF(1,minN(1))):round(newSF(1,minN(2)))];
    btwSF{2}=[round(newSF(2,minN(2))):round(newSF(2,minN(1)))];
    xy(1)=intersect(btwCS{1},btwSF{1});
    xy(2)=polyval(p2,xy(1));
catch
    l1=[newCS(1,minM(1)) newCS(2,minM(1)) newCS(1,minM(2)) newCS(2,minM(2))];
    l2=[newSF(1,minN(1)) newSF(2,minN(1)) newSF(1,minN(2)) newSF(2,minN(2))];
    [xy(1),xy(2)]=lineintersect(l1,l2);
end
    
