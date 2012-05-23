% Selectplots
% 
% Allows user to use the mouse to select (and visibly toggle the state of)
% multiple subplots, while their indices are recorded for further use.
% 
% To use, call selectplots(axs) where axs is an array of subplot axes.
% After the user has interacted with the plots, 
% the indices of the selected plots are returned.
%
% for use in interactive applications, the global variable goodplots will 
% contain a logical array of plots, where 0 = plot not selected and 
% 1 = plot is selected.
%
% Version history:
% 0.10: Written by Matthew Caywood, <caywood@phy.ucsf.edu>, 2009.11
% 0.11: fixed misleading comment, 2011.10

function gp = selectplots(axisarray)
%
% axisarray is the array of handles of subplots which will be selected
% they are numbered 1...numplots 

global goodplots; 

set(gcf,'Renderer','OpenGL');
% MSC necessary to avoid an OpenGL renderer bug where axes are flipped

% If you're having rendering problems, comment out the following line:
opengl('OpenGLBitmapZbufferBug',0)

% If you still have trouble with Matlab's OpenGL graphics on some graphics cards, 
% try the command: 
% opengl software;

numplots = length(axisarray);

goodplots = zeros(1,numplots); 

for i = 1:numplots
    layerplot(axisarray(i),i);
end

gp = goodplots;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function layerplot(ax,i)
%
% layer a (semi-)transparent patch over the axes to trap clicks 

% Note: OuterPosition creates a more visible toggled state than Position
invisax = axes('Position',get(ax,'OuterPosition'), ...
               'PlotBoxAspectRatioMode',get(ax,'PlotBoxAspectRatioMode'),...
               'DataAspectRatioMode',get(ax,'DataAspectRatioMode'),...
               'NextPlot','add'); %#ok
axis off;

p = patch([0 0 1 1],[0 1 1 0],[0 0 0 0],'w');
set(p,'FaceAlpha',0);
set(p,'EdgeAlpha',0);
set(p,'ButtonDownFcn',@toggleplot);

setappdata(p,'PlotNumber',i); % store plot number in axes 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function toggleplot(src,eventdata) %#ok

global goodplots; 

cellnum = getappdata(src,'PlotNumber'); 
goodplots(cellnum) = ~goodplots(cellnum); 

set(src,'FaceAlpha',0.25 - get(src,'FaceAlpha')); 
% set(src,'EdgeAlpha',0.25 - get(src,'EdgeAlpha'));
