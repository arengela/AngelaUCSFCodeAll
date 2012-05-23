function [idx2Vertex, distances]=ecogVisOnBrainFindClosestVertex(brainAnat,pointsVox,checkMapping)
%[idx2Vertex,distances]=ecogVisOnBrainFindClosestVertex(brainAnat,pointsVox) For a set of points find the closest vertex on a brain surface.
%
%PURPOSE:       For a set of points find the closest vertex on a brain 
%               surface. This is used e.g. to map ECOG electrodes onto a
%               brain surface. 
%
%INPUT:
%brainAnat:     A brainAnat structure with field brainAnat.vertices
%pointsVox:     A n by 3 matrix of points in voxel space. 
%checkMapping:  Renders the points together with the closest vertices
%               (Currently 20) on the transparent brain surface. Shows two  
%               lateral views and one from anterior with the brain cut to 
%               better see points inside the brain.
%OUTPUT:
%idx2Vertex:    A set of indices to brainAnat.vertices corresponding to the
%               closest points
%distances:     The distances between the points in pointsVox and the
%               closest vertices. For 1 mm isovoxels this is in mm.
%
%REQUIREMENTS:
%
%ISSUES/Restrictions:
%The distance is calculated in voxel space and assumes isotropic voxels.
%Nonisotropic voxels may lead to errornous results.
%For 1 mm isotropic voxels distance is in mm
%Note that the order of coordinates in brainAnat.vertices is YXZ instead of XYZ
%as in brainVol 

% JR wrote it 2010/05/02

if nargin<3
    checkMapping=0;
end

% prep checking the mapping
if checkMapping==1
    c=colormap;
    c(1,:)=[0.8 0.8 0.8];
    c(end,:)=[1 0 0];
    YC=brainAnat.brainVol.brainVol;
end

% map the points
distancePos=zeros(size(pointsVox,1),1);
vertexIdxPos=distancePos;
for k=1:size(pointsVox,1)
    vertexDist=brainAnat.vertices-repmat(pointsVox(k,[2,1,3]),size(brainAnat.vertices,1),1); % careful: X and Y are swapped between the two coordinate systems 
    [tmp]=sqrt(sum(vertexDist'.^2))';
    [tmp tmpIdx]=sort(tmp);
    distances(k)=tmp(1); % the distance to the closest vertex on the surface
    idx2Vertex(k)=tmpIdx(1); % the index to the closest vertex
    % check the mapping
    if checkMapping==1
        fH=figure;
        %make a cube representing the original point    
        YC(:)=0;
        cubeSize=floor(3/2);
        currentPoint=round(pointsVox(k,:));
        YC(currentPoint(1)-cubeSize:currentPoint(1)+cubeSize,...
            currentPoint(2)-cubeSize:currentPoint(2)+cubeSize,...
            currentPoint(3)-cubeSize:currentPoint(3)+cubeSize)=...
            YC(currentPoint(1)-cubeSize:currentPoint(1)+cubeSize,...
            currentPoint(2)-cubeSize:currentPoint(2)+cubeSize,...
            currentPoint(3)-cubeSize:currentPoint(3)+cubeSize)+1;
        % make the original point
        fp=isosurface(YC,.1);
        hold on
        brainAnat.faceVertexCData(:)=0;
        %color the 20 closest  vertices
        brainAnat.faceVertexCData(tmpIdx(1:20))=1;
        %plot brain
        if isfield(brainAnat,'brainVol')
            brainAnat=rmfield(brainAnat,'brainVol');
        end 
        if isfield(brainAnat,'thresh')
            brainAnat=rmfield(brainAnat,'thresh');
        end
        p1=patch(brainAnat);
        %set(p1,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none');
        set(p1,'EdgeColor','none');
        shading interp
        view([0 0])
        camlight('headlight','infinite')
        alpha(0.5)
        colormap(c);
        hold on 
        %plot point
        p2=patch(fp);
        set(p2,'FaceColor','green','EdgeColor','none');
        disp([num2str(k) ': point: ' num2str(currentPoint) ' vertex: ' num2str(brainAnat.vertices(tmpIdx(k),[2 1 3])) ' distance: ' num2str(tmp(1))])
        title(num2str(k));
        drawnow
        t=input('Press return to continue.');
        view([180 0]);
        camlight('headlight','infinite')
        t=input('Press return to continue.');
        view([90 0]);
        camlight('headlight','infinite')
        xlim([0 currentPoint(2)+4])
        t=input('Press return to continue.');
        delete(fH);
    end
end
