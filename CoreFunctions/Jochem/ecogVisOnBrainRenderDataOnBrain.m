function [pH,cL,brainAnatColored]=ecogVisOnBrainRenderDataOnBrain(brainAnat,pointsVox,pointsValue,smoothParms,cMap);
%[pH,cL,brainAnatColored]=ecogVisOnBrainRenderDataOnBrain(brainAnat,pointsVox,pointsValue,smoothParms,cMap); Render data on a brain surface
%
%PURPOSE: Render data on a brain surface.
%
%INPUT:
%brainAnat:   A brain anatomy structure including a brain volume and a brain
%             surface. If no brain volume is available, the points are
%             directly mapped onto the surface, currently without smoothing  
%pointsVox:   A n by 3 matrix of points in voxel space. Swap colums 2 and 1
%             if coordinates from brainAnat.vertices are used
%pointsValue: The values for each point.              
%smoothParms: Parameters for an isotropic Gaussian smoothing kernel
%             smoothParms(1): kernel size in voxels. Default: 15
%             smoothParms(2): kernel standard deviation in voxels.
%             Default:0
%cMap:        An OPTIONAL colormap
%             For use with the default colormap vertices belonging to the brain 
%             the brain should have the lowest entry in to the colormap. 
%brainAnatColored: The new brain anatomy structure with colors on the 
%             vertices of the brain surface. This can be directly passed to
%             ecogVisOnBrainRenderBrain
%
%OUTPUT
%pH:    Handle to the patch object
%cL:    Handles to the light sources
%
%ISSUES: 
%Color mapping may require work. Currently color data mapping is set to
%direct. This leaves the work of mapping the data to the user
%Smoothing is currently only done in the volume. Add smoothing on the
%surface
% Field brainVol is required DIRECT MAPPING OF THE POINTS IS NOT
% IMPLEMENTED YET

% JR wrote it 2010/05/02

if ~isfield(brainAnat,'brainVol')
    directMapping=1;
else
    directMapping=0;
end 
if ~exist('smoothParms','var') || isempty(smoothParms)
    kernelSize=[1 1 1];
    kernelStd=0;
else
    kernelSize=repmat(smoothParms(1),1,3); % This equal mm since we downsampled by a factor of 2 
    kernelStd=smoothParms(2);
end

%make the gauss kernel
if kernelSize(1)<=1 % all kernels of size 1 or less will have size 1 
    gaussK=1;
elseif kernelSize(1)>1
    if mod(kernelSize(1),2)==1; % Kernel size is even, we add one 
        kernelSize(:)=kernelSize(:)+1;
    end
    if kernelStd<=0
        kernelStd=1e-15; %good enough
    end
    
    [kMeshX,kMeshY,kMeshZ]=meshgrid(-floor(kernelSize(1)/2):1:ceil(kernelSize(1)/2),...
        -floor(kernelSize(2)/2):1:ceil(kernelSize(2)/2),...
        -floor(kernelSize(3)/2):1:ceil(kernelSize(3)/2));
    gaussK=exp(-( (kMeshX.^2)./(2*kernelStd^2) + (kMeshY.^2)./(2*kernelStd^2) + (kMeshZ.^2)./(2*kernelStd^2)));
end 
%the max of this kernel should be one but to be shure:
gaussK=gaussK./max(max(max(gaussK)));

% now we fill the volume used for coloring the mesh
%positive sites
YC=zeros(size(brainAnat.brainVol.brainVol)); % This volume will hold the colors for mesh rendering
dimYC=size(YC);
gaussKCenter=ceil(size(gaussK,1)/2);
for k=1:size(pointsVox,1)
    for x=1:size(gaussK,1)
        xIdx=round(pointsVox(k,1)-gaussKCenter+x); % swap dims x and y
        if xIdx>0 & xIdx<dimYC(1) % if x index into volume is within the allowed bounds
            for y=1:size(gaussK,2)
                yIdx=round(pointsVox(k,2)-gaussKCenter+y); 
                if yIdx>0 & yIdx<dimYC(2)
                    for z=1:size(gaussK,3)
                        zIdx=round(pointsVox(k,3)-gaussKCenter+z); 
                        if zIdx>0 & zIdx<dimYC(3) 
                            YC(xIdx,yIdx,zIdx)=YC(xIdx,yIdx,zIdx)+pointsValue(k)*gaussK(x,y,z);
                        end %if zIdx  
                    end
                end %if yIdx
            end
        end % if xIdx
    end
end
% here we should hev a volume with smoothed data values
% And render them here
%YC=YC./max(max(max(YC)))*64; % direct color mapping in the rendering function 
brainAnatColored=isosurface(brainAnat.brainVol.brainVol,brainAnat.thresh,YC); %THIS IS EXTREMELY INEFFICIENT
[pH,cL]=ecogVisOnBrainRenderBrain(brainAnatColored);
if nargout>2
    brainAnatColored.brainVol=brainAnat.brainVol;
    brainAnatColored.thresh=brainAnat.thresh;
end
