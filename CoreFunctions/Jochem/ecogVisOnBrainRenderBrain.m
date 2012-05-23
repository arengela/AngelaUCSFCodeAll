function [pH,cL]=ecogVisOnBrainRenderBrain(brainAnat,cMap);
%[pH,lH]=ecogVisOnBrainRenderBrain(brainAnat, cMap); Render a brain surface
%
%PURPOSE: Render a brain surface.
%
%INPUT:
%brainAnat: A brain anatomy structure
%cMap:  An OPTIONAL colormap
%       For use with the default colormap vertices belonging to the brain 
%       the brain should have the lowest entry in to the colormap. 
%       
%OUTPUT
%pH:    Handle to the patch object
%lH:    Handles to
%
%ISSUES: 
%Lights are currently optimized to render a lateral surface
%Color mapping may require work. Currently color data mapping is set to
%direct. Leaves the work of mapping the data to the user

% JR wrote it 2010/05/02

if nargin<2 || isempty(cMap) 
    c=colormap;
    c(5,:)=[0.2 0.2 0.78];
    c(4,:)=[0.3 0.3 0.75];
    c(3,:)=[0.5 0.5 0.75];
    c(2,:)=[0.7 0.7 0.75];
    c(1,:)=[0.8 0.8 0.8];
else
    c=cMap;
end 
colormap(c);

if isfield(brainAnat,'brainVol')
    brainAnat=rmfield(brainAnat,'brainVol');
end 
if isfield(brainAnat,'thresh')
    brainAnat=rmfield(brainAnat,'thresh');
end

pH=patch(brainAnat);
set(pH,'EdgeColor','none','diffusestrength',1,'specularstrength',.8,'CDataMapping','scaled');
shading interp
view([0 0])
cL(1)=light('position',[0 -1000 -1000],'color',[.3 .3 .3]);
cL(2)=light('position',[0 -1000 1000],'color',[.3 .3 .3]);
cL(3)=light('position',[1000 100 100],'color',[.3 .3 .3]);
cL(4)=light('position',[0 1000 1000],'color',[.3 .3 .3]);

%alpha(0.5)
hold on
colorbar
axis equal
axis off
set(gcf,'color',[0 0 0])

