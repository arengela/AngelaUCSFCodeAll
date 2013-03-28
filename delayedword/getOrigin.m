function Data=getOrigin(Data)
figure
visualizeGrid(2,['E:\General Patient Info\' Data.patientID '\brain.jpg'],[])
display('Origin')
[xO,yO]=ginput(1);
xyO=horzcat(xO,yO)';
display('Get Axis')
[xCS,yCS]=ginput(1);
xyCS=horzcat(xCS,yCS)';

Data.Params.xyO=xyO
Data.Params.xAxis=xyCS;
close

