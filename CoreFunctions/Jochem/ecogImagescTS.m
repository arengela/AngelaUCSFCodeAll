function ecog=ecogImagescTS(ecog, timepoint,colorLim, nColumns)
% ecog=ecogImagescTS(ecog, trialList) an image of the time series amplitudes on the grid
%
% Purpose:  Plot an image of the time series amplitudes on the grid.
%           Channel positions:
%           Electrode positions are expected in ecog.channelPosition. in
%           the order x,y)
%           If this field does not exist the field channel2GridMatrixIdx is
%           used to construct the layout of the electrode grid.
%           If channel2GridMatrixIdx does not exist the variable nColumns
%           must be passed and grid positions for a rectangular grid are
%           constructed. %
% INPUT:
% ecog:      an ecog structure
% timepoint: The timepoint to plot (same unit as in ecog.timebase)
% colorLim:  OPTIONAL: Limits of the colormap. Each plot will be scaled
%            individually if not passed or empty.
% nColumns:  OPTIONAL: The number of columns in the plot matrix.
%            used MANDATORY if neither of the fields channelPosition
%            or channel2GridMatrixIdx exist.
%
% OUTPUT:
% ecog:     Returns the ecog structure.
%           If nColumns was provided the fields channelPosition and
%           channel2GridMatrixIdx are updated
% TODO: extend to 3D,
%       delete triangles containing deselected channels instead of setting
%       them to zero
%       optional transparent figure background
%

% 091106 JR wrote it
% ecogMovieTS depends on this function

%this will override any previous position definitions
if nargin>3 && ~isempty(nColumns)
    nRows=ceil(size(ecog.data,1)/nColumns);
    [channel2SubplotX, channel2SubplotY] = meshgrid([1:nColumns],[1:nRows]); % We work in cartesian coordinates on this
    %This is how we will index the subplots in the matrix of plots
    ecog.channel2GridMatrixIdx=[channel2SubplotX(1:size(ecog.data,1))' channel2SubplotY(1:size(ecog.data,1))'];
    ecog.channelPosition=ecog.channel2GridMatrixIdx;
end
%If still no positions are available try those used for grid plots
if isfield(ecog,'channel2GridMatrixIdx') && ~isfield(ecog,'channelPosition')
    ecog.channelPosition=ecog.channel2GridMatrixIdx;
elseif ~isfield(ecog,'channelPosition')
    error('no channelPosition in ecog structure.')
end

timeIdx=nearly(timepoint,ecog.timebase);
% We use a Delaunay trangulation to construct the surface
tri = delaunay(ecog.channelPosition(:,2),ecog.channelPosition(:,1));
%and plot it
colorVals=zeros(size(ecog.channelPosition,1),1);
if exist('colorLim')
    clFixed=1;
    cl=colorLim;
else
    clFixed=0;
end
set(gcf,'color','w')
colorVals(ecog.selectedChannels)=ecog.data(ecog.selectedChannels,timeIdx);
if ~clFixed
    cl=max(abs(colorVals));
    cl=[-cl cl];
end
pH=trisurf(tri,ecog.channelPosition(:,2),ecog.channelPosition(:,1),colorVals);
set(gca,'clim',cl,'zlim',cl,'box','off','gridlinestyle','none','color','none','linewidth',1,'fontweight','bold');
%axis('tight','equal','off')
axis on
axis tight
alphamap('vdown')
set(pH,'FaceAlpha','interp','AlphaDataMapping','scaled','FaceVertexAlphaData',colorVals);
view([0 -90])
%view([114 60])
set(gca,'zlim',cl)

shading interp
colorVals(:)=0;
tmp=get(gca,'xlim');
textPos(1)=tmp(1);
tmp=get(gca,'ylim');
textPos(2)=tmp(2);
tH=text(textPos(1),textPos(1),0,[num2str(timepoint) ' ms'],'VerticalAlignment','top','fontweight','bold');
colorbar
