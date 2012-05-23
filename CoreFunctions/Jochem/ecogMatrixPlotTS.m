function ecog=ecogMatrixPlotTS(ecog, trialList, nColumns,color)
% ecogMatrixPlotTS(ecog, trialList) plot time series in single trials
%
% Purpose:  Plot the time series of the selected channels in the data field
%           of an ecog structure in a matrix like grid. The field
%           channel2GridMatrixIdx defines for each channel in the data
%           field the position on the grid (x , y positions see subplot).
%
% INPUT:
% ecog:      an ecog structure
% trialList: A vector with trialnumbers to plot
% nColumns:  OPTIONAL: The number of columns in the plot matrix. MANDATORY
%            if the ecog structure does not contain the field channel2GridMatrixIdx
% color:     OPTIONAL: The color used for plotting
%
% OUTPUT:
% ecog:     Returns the ecog structure. If nColumns was provided the field
%           channel2GridMatrixIdx is updated

% 090121 JR wrote it

if nargin>2 && ~isempty(nColumns)
    nRows=ceil(size(ecog.data,1)/nColumns);
    [channel2SubplotX, channel2SubplotY] = meshgrid([1:nColumns],[1:nRows]); % We work in cartesian coordinates on this
    %This is how we will index the subplots in the matrix of plots
    ecog.channel2GridMatrixIdx=[channel2SubplotX(1:size(ecog.data,1))' channel2SubplotY(1:size(ecog.data,1))'];
else
    %determine the plot matrix size
    nRows=max(ecog.channel2GridMatrixIdx(:,1));
    nColumns=max(ecog.channel2GridMatrixIdx(:,2));
end

titleFlag=1;
for k=1:length(trialList)
    for m=1:length(ecog.selectedChannels)
        curChan=ecog.selectedChannels(m);
        %We fill the plot matrix along the rows
        aH(m)=subplot(nRows,nColumns,...
            (ecog.channel2GridMatrixIdx(curChan,1)-1)*nColumns+ecog.channel2GridMatrixIdx(curChan,2));
        hold on;
        pH(m)=plot(ecog.timebase,ecog.data(curChan,:,trialList(k)),'color',color);
        if titleFlag==1
            title(['Channel: ' num2str(curChan)]);
        end
        drawnow
    end
    titleFlag=0;
end
%Formatting
for m=1:length(ecog.selectedChannels)
    curChan=ecog.selectedChannels(m);
    %We fill the plot matrix along the rows
    subplot(nRows,nColumns,...
        (ecog.channel2GridMatrixIdx(curChan,1)-1)*nColumns+ecog.channel2GridMatrixIdx(curChan,2));
    title(['Channel: ' num2str(curChan)]);
    axis tight;
    yL=get(gca,'ylim');
    xL=get(gca,'xlim');
    if yL(1)<0 && yL(2)>0 % we have zero on the y axis -> draw a line along x
        lH=line(get(gca,'xlim'),[0 0]);
        set(lH,'color','k');
    end
    if xL(1)<0 && yL(2)>0 % we have zero on the x axis -> draw a line along y
        lH=line([0 0],get(gca,'ylim'));
        set(lH,'color','k');
    end
end
%next set all to same ylims
yL=[];
for k=1:length(aH)
    yL=[yL;get(aH(k),'ylim')];
end
yL=[min(yL(:,1)) max(yL(:,2)) ];
for k=1:length(aH)
    set(aH(k),'ylim',yL);
end


hold off





