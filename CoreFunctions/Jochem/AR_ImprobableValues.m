%Who to blame: Nikolai Kalnin
function [isGood]=AR_ImprobableValues(data,isGood,max_stdDev)

[m,n]=size(data);

for j=1:m
    isGood(j,:)=logical(double(isGood(j,:)).*double(abs(data(j,:)-mean(data(j,:)))<=max_stdDev*std(data(j,:))));
end;
return;
