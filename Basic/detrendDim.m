function Xdetrend=detrendDim(X,dim)

allDim=size(X);
oDim=setdiff(1:length(allDim),dim);
X=permute(X,[oDim dim]);
for a=1:size(X,oDim(1))
    if length(oDim)==3
        Xdetrend(a,:,1,:)=detrend(squeeze(X(a,:,1,:)));
    end
end
    