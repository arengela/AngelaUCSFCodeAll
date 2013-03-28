function visualizeGrid(flag,dpath,ch,data,maxsc,data2,impch,colormat,showImFlag)
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

if nargin<5
    maxsc=[];
end

if nargin<8
    colormat=[];
end

if nargin<9
    showImFlag=1;
end
% 
% if nargin<6
%     data2=repmat(70,[1 size(data,2)]);
% elseif isempty(data2)
%     data2=repmat(70,[1 size(70,2)]);
% end

if nargin<7
    impch=[];
end
switch flag
    case 4 %Register electrode positions
        eCogImageRegister(dpath,1);
    case 0
        ECogDataVis (dpath2,subject,ch,[],0,dpath);
    case  1
         ECogDataVis (dpath2,subject,ch,data,1,dpath,maxsc,[],[],colormat,showImFlag);
    case  5
         ECogDataVis (dpath2,subject,ch,data,5,dpath,[],[],[],colormat,showImFlag);
    case  7
         ECogDataVis (dpath2,subject,ch,data,7,dpath,maxsc);
    case  8 %Dots and text on brain
         ECogDataVis (dpath2,subject,ch,data,8,dpath,maxsc);
    case  9 %Scatterplot on brain, colormapped
         ECogDataVis (dpath2,subject,ch,data,9,dpath,maxsc,data2,impch);
   
    case  10 %Scatterplot on brain, colormapped
         ECogDataVis (dpath2,subject,ch,data,10,dpath,maxsc,data2,impch);
    case  11 %Scatterplot on brain, colormapped
         ECogDataVis (dpath2,subject,ch,[],11,dpath,maxsc,data2,impch,colormat,showImFlag);
    case 2 %Show numbers on brains
        ECogDataVis (dpath2,subject,ch,[],2,dpath,[],[],[],colormat,showImFlag);
    case 3
        ECogDataVis (dpath2,subject,ch,data,3,dpath,maxsc);
    case 5 %Show pos and neg electrodes
        ECogDataVis (dpath2,subject,ch,data,5,dpath,maxsc);
end
%set(gca,'visible','off')
%set(gca,'box','off')