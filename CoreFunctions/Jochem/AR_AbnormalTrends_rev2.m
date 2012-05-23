%Who to blame: Nikolai Kalnin
function [isGood]=AR_AbnormalTrends_rev2(data,isGood,handles)
axesParams=updateAxesParams(guidata(handles.axesFig));
controlParams = updateControlParams(handles);
% (data,badEpoch,maxSlope,interval,shift)
% ecog.data = must be a 2-d vector
interval=controlParams.AT_interval;
shift=controlParams.AT_shift;
maxSlope=controlParams.AT_maxSlope;
% show=[axesParams.start_location,axesParams.start_location+axesParams.plot_interval];

[m,n]=size(data);
ind=axesParams.start_location;  %current index
x=pinv([1:interval;ones(1,interval)]');
if controlParams.AT_absolute_slope==1
    for j=1:ceil(n/shift+1)
        if (ind+interval>n+1)||(ind+interval>axesParams.start_location+axesParams.plot_interval+1)
            interval=n-ind+1;
            x=pinv([1:interval;ones(1,interval)]');
        end
        tmp=x*(data(:,ind:(ind+interval-1))');
        isGood(:,ind:(ind+interval-1))=logical(double(isGood(:,ind:(ind+interval-1))).*((double(abs(tmp(1,:))<=maxSlope)')*ones(1,interval)));
        if (ind+interval>=n+1)||(ind+interval>axesParams.start_location+axesParams.plot_interval+1)
            break;
        end
        ind=ind+shift;
    end
else
    if ~exist(globalMeanSlope)
        tmp=[];
        for j=1:(ceil(n/shift+1))
            if ind+interval>n+1
                interval=n-ind+1;
                x=pinv([1:interval;ones(1,interval)]');
            end
            tmp=[tmp,mean(abs(x*(data(:,ind:(ind+interval-1))')))];
            if ind+interval>=n+1;
                break;
            end
            ind=ind+shift;
        end
        globalMeanSlope=mean(tmp);
    end
end
% [m,n]=size(data);
% ind=1;  %current index
% x=pinv([1:interval;ones(1,interval)]');
% for j=1:(ceil(n/shift+1))
%     if ind+interval>n+1
%         interval=n-ind+1;
%         x=pinv([1:interval;ones(1,interval)]');
%     end;
%     tmp2=x*(data(:,ind:(ind+interval-1))');
%     isGood(:,ind:(ind+interval-1))=isGood(:,ind:(ind+interval-1)).*((logical(double(abs(tmp2(1,:))<=maxSlope)')*ones(1,interval)));
%     if ind+interval>=n+1;
%         break;
%     end;
%     ind=ind+shift;
% end;
% return;

