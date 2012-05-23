%Who to blame: Nikolai Kalnin
function [isGood]=ecogArtifactRejExtremeValues(data,isGood,max_dev)

[m,n]=size(data);
for j=1:m
    isGood(j,:)=logical(double(isGood(j,:)).*double((abs(data(j,:)-mean(data(j,:)))<=max_dev)));
end;