function pointVox=ecogVisOnBrainMM2Vox(brainAnat,pointMM);
%pointVox=ecogVisOnBrainMM2Vox(brainAnat,pointMM); Convert points given in mm to voxel space indices  
%
%PURPOSE:       Transforms points given in mm space of a brain anatomy to 
%               voxel space of the anatomy. This is used e.g. to transform
%               MNI-coordinate points for rendering them mapping onto an 
%               MNI brain or to find the closet point on a brain surface.
%
%INPUT:
%brainAnat:     A brainAnat structure with field brainAnat.brainVol.mm2Vox
%pointMM:       A n by 3 matrix of points in mm. Order of coordinates must 
%               conform with the coordinate system defined in mm2Vox.
%               (e.g. X Y Z)
%
%OUTPUT:
%pointVox:      A n by 3 matrix of points in voxel indices
%
%REQUIREMENTS:
%
%ISSUES/Restrictions:
%

% JR wrote it 2010/05/02

pointVox=brainAnat.brainVol.mm2Vox*[pointMM ones(size(pointMM,1),1)]';
