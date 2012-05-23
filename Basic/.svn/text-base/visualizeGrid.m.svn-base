function visualizeGrid(flag,dpath,ch,data,maxsc)
%INPUT dpath = C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\GP31\brain_3Drecon.jpg
%flag= 4: register points
% 0:show electrodes
% 1: show data
% 2: show electrode numbers

[dpath2,imageName]=fileparts(dpath);

[mainPath,subject]=fileparts(dpath2);


imageName=[imageName '.jpg'];
if nargin<3
    ch=1:256
end

switch flag
    case 4
        eCogImageRegister(dpath,1);
    case 0
        ECogDataVis (dpath2,subject,ch,[],0,dpath);
    case 1
        ECogDataVis (dpath2,subject,ch,data,1,dpath,[]);
    case 2
        ECogDataVis (dpath2,subject,ch,[],2,dpath);
    case 3
        ECogDataVis (dpath2,subject,ch,data,3,dpath,[]);
    case 5
        ECogDataVis (dpath2,subject,ch,data,5,dpath,[]);
end