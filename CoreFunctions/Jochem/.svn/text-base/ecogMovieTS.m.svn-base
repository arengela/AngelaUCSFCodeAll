function [mov,ecog]=ecogMovieTS(ecog, timepoints,colorLim, nColumns)
% [mov,ecog]=ecogMovieTS(ecog, timepoint,colorLim, nColumns) make a movie of the amplitude distribution on the grid by calling ecogImagesc repeadetly
%
% Purpose:  Make a movie of the time series amplitudes on the grid.
%           Calls ecogImagescTS repeadetly 
%           Channel positions:
%           Electrode positions are expected in ecog.channelPosition. in
%           the order x,y)
%           If this field does not exist the field channel2GridMatrixIdx is
%           used to construct the layout of the electrode grid.
%           If channel2GridMatrixIdx does not exist the variable nColumns
%           must be passed and grid positions for a rectangular grid are
%           constructed. 
% INPUT:
% ecog:      an ecog structure
% timepoints: The sequence of timepoints the movie shows(same unit as in ecog.timebase)
% colorLim:  OPTIONAL: Limits of the colormap. Each plot will be scaled
%            individually if not passed or empty.
% nColumns:  OPTIONAL: The number of columns in the plot matrix.
%            used MANDATORY if neither of the fields channelPosition
%            or channel2GridMatrixIdx exist.
%
% OUTPUT:
% mov:      The matlab movie created.
% ecog:     Returns the ecog structure.
%           If nColumns was provided the fields channelPosition and
%           channel2GridMatrixIdx are updated
% TODO:
%

% 091106 JR wrote it

count=1;
for k=timepoints
    if nargin<3
        ecog=ecogImagescTS(ecog, timepoints(count));
    elseif nargin==3
        ecog=ecogImagescTS(ecog, timepoints(count),colorLim);
    elseif nargin==5
        ecog=ecogImagescTS(ecog, timepoints(count),colorLim, nColumns);
    end
    drawnow;
    pos=get(gcf,'position');
    pos(1:2)=0;
    mov(count)=getframe(gcf,pos);
    count=count+1;
end
