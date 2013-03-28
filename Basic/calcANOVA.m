function RegOut=calcANOVA(X,Y)
%% X = observation (ex time) x variable x trial
%% Y = observation x trial
trTot=size(X,3);
Xtrain=reshape(permute(X(:,:,:),[1,3,2]),[],size(X,2));
Ytrain=reshape(Y(:,:),[],1);
%mdl = LinearModel.fit(Xtrain,Ytrain)
[b,dev,stats]=glmfit(Xtrain,Ytrain,'normal');
for tr=1:trTot
	yfit=glmval(b,X(:,:,tr),'identity');
    RegOut.yfit(tr).YPred=yfit;
    RegOut.yfit(tr).Yreal=Y(:,tr);
end

RegOut.b=b;
RegOut.dev=dev;
RegOut.stats=stats;
SStotal=(length(Ytrain)-1)*var(Ytrain);
R2=1-dev/SStotal;
RegOut.R2=R2;

