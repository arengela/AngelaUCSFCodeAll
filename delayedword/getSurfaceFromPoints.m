function Vq=getSurfaceFromPoints(xy,ch,data,a)

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
for i=1:length(ch)
    d1=squareform(pdist([xy XY2]'));
    d2=d1(1,2:end);
    [aidx,bidx]=find(d2<20);
    [aidx2,bidx2]=find(d2>0 & d2<10);
    nidx=[nidx bidx];
    nidx2=[nidx2 bidx2];
end
idx=setdiff(1:length(X3),unique(nidx));
idx2=unique(nidx2);
idx3=setdiff(1:length(X3),idx2);
[Xq,Yq,Vq]=griddata([X3(idx) xy(1,ch)],[ Y3(idx) xy(2,ch)],[reshape(Z2(idx),1,[]) data'],X,Y,'v4');
Vq(find(isnan(Vq)))=0;
tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
Vq=imresize(tmp2,[size(a,1) size(a,2)]);
Vq(find(Vq<0))=0;
