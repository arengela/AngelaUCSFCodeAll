function AR_plotter(h,ecog,show)
%pH=ecogStackedTSPlot(ecog,trialNum) plot time series stacked in one column
%
% INPUT:
% ecog:     An ecog structure
% trialNum: The number of the trial to plot
% 
% OUTPUT:
% pH:       An array of plot handles
%

% 090109 JR wrote it
% 090713 NK stole it

timeBase_sec=ecog.timebase/1000;
scaleFac=var(ecog.data(:,show(1):show(2)),0,2);
scaleVec=[1:length(ecog.selectedChannels)]'*max(scaleFac)*1/50; %The multiplier is arbitrary. Find a better solution
tmp=ecog.data(ecog.selectedChannels,show(1):show(2))+repmat(scaleVec,1,show(2)-show(1)+1);

%A line indicating zero for every channel
x=repmat([timeBase_sec(show(1));timeBase_sec(show(2))],1,length(scaleVec));
y=[scaleVec';scaleVec'];
plot(h,x,y,'color','k');

hold(h,'on');
c=get(h,'colororder');
set(h,'colororder',c(1:2,:));
x=timeBase_sec(show(1):show(2));
plot(h,x,tmp);
xlabel(h,'Time(Seconds)');
ylabel(h,'Mircovolts');
axis(h,'tight');
hold(h,'off');
