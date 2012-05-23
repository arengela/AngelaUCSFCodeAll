%Who to blame: Nikolai Kalnin
function [badEpoch]=ecogArtifactRejAbnormalTrends(data,badEpoch,maxSlope,interval,shift)
% ecog.data = must be a 2-d vector
display_increment=10; %displays percentage complete every * percent


if nargin<5
    error('Too few arguments')
end

[m,n]=size(data);


fprintf('\n\nAbnormal Trend Artifact Rejection\n Percentage Completed')

overall_counter=0;
for k=1:m
    counter=0;
    tmp=0;
    ind=1;  %current index
    tmp=0;
    fprintf('\nOverall Progress: %2.f - Current Channel Progress:',overall_counter);
    for j=1:n
        if ind+interval>n+1
            interval=n-ind+1;
        end;
        [P]=polyfit(1:interval,data(k,ind:(ind+interval-1)),1);
        if abs(P(1))>maxSlope
            badEpoch(k,ind:(ind+interval-1))=false(1,interval);
        end;
        if ind+interval>=n+1;
            break;
        end;
        ind=ind+shift;
        tmp=round(ind/n*100);
        if tmp>=counter+display_increment
            fprintf('.');
            counter=tmp;
        end
    end;
    overall_counter=round(k/m*100);
end;
return;