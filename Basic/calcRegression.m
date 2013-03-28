function RegOut=calcRegression(X,Y,xval)
%% X is observation x variable x trial
%% Y is observation x trial
trTot=size(X,3);
if xval==1
    N=size(X,3);
else 
    N=1;
end
for testTr=1:N
    tr=setdiff(1:trTot,testTr);
    Xtrain=reshape(permute(X(:,:,tr),[1,3,2]),[],size(X,2));
    Ytrain=reshape(Y(:,tr),[],1);
    Xtest=X(:,:,testTr);
    Ytest=Y(:,testTr);
    
    [beta,sigma,resid,vars,loglik]=mvregress(Xtrain,Ytrain);
    Ypred=bsxfun(@times,Ytest',beta);
    Ypred=sum(Ypred,1);
    RegOut(testTr).Ytest=Ytest';
    RegOut(testTr).Ypred=Ypred;
    RegOut(testTr).beta=beta;
    RegOut(testTr).sigma=sigma;
    RegOut(testTr).resid=resid;
    RegOut(testTr).vars=vars;
    RegOut(testTr).loglik=loglik;
end
