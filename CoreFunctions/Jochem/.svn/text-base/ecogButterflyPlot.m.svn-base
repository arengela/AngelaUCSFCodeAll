function pH=ecogButterflyPlot(ecog, trialList)
%pH=ecogButterflyPlot(ecog, trialList) make a butterfly plot of the active channels in data time series
%
% INPUT:
% ecog:     an ecog structure
% trialList: A vector with trialnumbers to plot
%
% OUTPUT:
% pH:       Handles to the plot

% 090105 JR wrote it


colorOrder=[...
         0         0    1.0000;
         0    0.5000         0;
    1.0000         0         0;
         0    0.7500    0.7500;
    0.7500         0    0.7500;
    0.7500    0.7500         0;
    0.2500    0.2500    0.2500];

if ecog.excludeBad==1
    ecog=ecogDeselectBadChan(ecog);
end
tmp=repmat(ecog.timebase',1,length(ecog.selectedChannels));
if length(trialList)==1 % colors are cycled through by channel
    pH=plot(tmp,ecog.data(ecog.selectedChannels,:,trialList)');
else    
    for k=1:length(trialList) %colors are cycled through by trial
        pH=plot(tmp,ecog.data(ecog.selectedChannels,:,trialList(k))','color',colorOrder(mod(k,size(colorOrder,1))+1,:));
        if k==1; hold on; end
    end
end
axis tight
line([0 0],get(gca,'xlim'),'color','k')

