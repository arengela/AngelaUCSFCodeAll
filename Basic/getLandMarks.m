function [xySF,xyCS]=getLandMarks(dpath)

figure
img=imread(dpath);
imshow(img);
display('Get Points for SF')
[xSF,ySF]=ginput;
xySF=horzcat(xSF,ySF)';
display('Get Points for CS')
[xCS,yCS]=ginput;
xyCS=horzcat(xCS,yCS)';
