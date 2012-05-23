function ecogGridPlotTS(ecog,timepoint,trialNum)
% ecogGridPlotTS(ecog,timePoint) plot the spatial distribution of the electric potential as a map
%
% PURPOSE: plot the spatial distribution of the electric potential as a map 
% on a grid. Uses only the selected channels.
% 
% INPUT:
% ecog:         an ecog input structure with fields 'data',
%               'selectedChannels', and 'channel2GridMatrixIdx'
%
% timepoint:    OPTIONAL: The point in time (in ms) relative to the zero in 
%               timebase to plot.  
%               For a scalar value only one timepoint is plotted. For a 2 
%               element vector a time range is averaged before plotting. If
%               omitted plots the first timepoint. The last option can be
%               used to plot arbitray data stored in the data field.
% trialNum:     OPTIONAL: The trial to plot. If omitted plots trial 1.
%               
% OUTPUT:       
%

% 090202 JR wrote it

if nargin<3
    trialNum=1;
end

%get the data to be plotted
if nargin<2 %We use only the first timepoint
    tpSamp=1;
else
    tpSamp=ecog.nBaselineSamp+round(timepoint/ecog.sampDur);
end

if size(tpSamp,2)==2 %We have to average first
    dat=mean(ecog.data(ecog.selectedChannels,tpSamp(1):tpSamp(2),trialNum),2);
else                    % no averaging
    dat=ecog.data(ecog.selectedChannels,tpSamp,trialNum);
end

% plot it
plotGrid(dat,ecog.selectedChannels,ecog.channel2GridMatrixIdx)

return


function plotGrid(dat,selectedChannels,channel2GridMatrixIdx)

%Make a meshgrid for plotting
x=sort(unique(channel2GridMatrixIdx(selectedChannels,1)));
y=sort(unique(channel2GridMatrixIdx(selectedChannels,2)));
[X,Y]=meshgrid(x,y);
% fill the data to plot with NaNs
Z=zeros(size(X));%*NaN; 
%fill the Z-matrix with data 
xIdx=channel2GridMatrixIdx(selectedChannels,1);
yIdx=channel2GridMatrixIdx(selectedChannels,2);
for k=1:length(dat)
    Z(yIdx(k),xIdx(k))=dat(k);
end

surf(X,Y,Z);
view([90,90])
axis image
colorbar
