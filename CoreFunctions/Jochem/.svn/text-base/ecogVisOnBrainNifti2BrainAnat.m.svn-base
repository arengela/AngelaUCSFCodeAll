function brainAnat=ecogVisOnBrainNifti2BrainAnat(fName,thresh)
% brainAnat=ecogVisOnBrainNifti2BrainAnat(fName,thresh) Creates a brainAnat structure and a brain surface from a nifti-volume  
%
%PURPOSE:       Extract a brain surface from a skull stripped brain in 
%               nifti or analyze image. Use e.g. "bet" to strip skull.
%INPUT:
%fName:         Filename of the nifti volume
%tresh:         Treshold to determine the brain surface 
%
%OUTPUT
%brainAnat:     A structure with fields:
%               brainVol: a structure with fields:
%                         brainVol: The brain volume in 1 mm voxels 
%                         mat: A matrix to convert position in mm to voxel index
%                         (the original nifti mat maps voxels to mm)
%               vertices: vertices returned by isosurface (live in voxel
%                         space)
%               faces: faces returned by isosurface
%               faceVertexCData: vertex colors (see e.g. patch for usage)
%                                DEFAULT: [0.7 0.7 0.7]
%               faceVertexAlphaData: vertex alpha (decrease for
%                                   transaparent brain surface)
%                                   DEFAULT: 1
%               tresh: the threshold 
%REQUIREMENTS:
%An SPM version capable of reading nifti files should be on the path
%The brain must be skull stripped
%
%ISSUES/Restrictions:
%There might be an left/right issue with the standard MNI brain.
%Might currently only work if voxel size is an integer divisor of 1 mm
%(e.g. 1mm 0.5mm etc)
%Matlab swaps the original coordinate order XYZ to YXZ in
%vertex coordinates

% JR wrote it 2010/05/02

DEBUG=0;
if DEBUG
    fName='ch2betterSmooth6.img';
    thresh=20;
end
brainAnat.brainVol.header=spm_vol_nifti(fName);
[brainAnat.brainVol.brainVol]=spm_read_vols(brainAnat.brainVol.header);
if isfield(brainAnat.brainVol.header,'private')
    brainAnat.brainVol.mat=brainAnat.brainVol.header.private.mat;
    tmp=diag(brainAnat.brainVol.mat); %check for isovoxels
    if any(diff(tmp(1:3)))
        error('Require isovoxels')
    else
        brainAnat.brainVol.mm2Vox=inv(brainAnat.brainVol.mat).*tmp(1); % the matrix to convert voxel coordinates to mm in brain space
    end
elseif isfield(brainAnat.brainVol.header,'mat')
    tmp=diag(brainAnat.brainVol.header.mat); %check for isovoxels
    if any(diff(tmp(1:3)))
        error('Require isovoxels')
    else
        brainAnat.brainVol.mm2Vox=inv(brainAnat.brainVol.header.mat).*tmp(1); % the matrix to convert voxel coordinates to mm in brain space
    end
else
    error('Shouldn''t get here')
end
% make 1 mm isovoxels
brainAnat.brainVol.brainVol=reducevolume(brainAnat.brainVol.brainVol,1/tmp(1));

%tesselate the brain 
[brainAnat.faces,brainAnat.vertices]=isosurface(brainAnat.brainVol.brainVol,thresh);
brainAnat.faceVertexCData=zeros(size(brainAnat.vertices,1),1);
brainAnat.FaceVertexAlphaData=brainAnat.faceVertexCData;
brainAnat.FaceVertexAlphaData(:)=0.1;
brainAnat.thresh=thresh;
