%Who to blame: Nikolai Kalnin
function [isGood]=ecogArtifactRejAbnormalTrends_rev2(data,isGood,params)
% params=struct('maxSlope',.005,...
%             'interval',.05,...
%             'shift',.025);
maxSlope=params.maxSlope;
interval=params.interval;
shift=params.shift;

[m,n]=size(data);
ind=1;
x=pinv([1:interval;ones(1,interval)]');

for j=1:ceil(n/shift+1)
    if ind+interval>n+1
        interval=n-ind+1;
        x=pinv([1:interval;ones(1,interval)]');
    end
    tmp=x*(data(:,ind:(ind+interval-1))');
    isGood(:,ind:(ind+interval-1))=logical(double(isGood(:,ind:(ind+interval-1))).*((double(abs(tmp(1,:))<=maxSlope)')*ones(1,interval)));
    if ind+interval>=n+1
        break;
    end
    ind=ind+shift;
end