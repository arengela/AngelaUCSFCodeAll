% first time:
eCogImageRegister('E:\General Patient Info - Copy (2)\EC2\brain+grid_3Drecon.jpg',1);
eCogImageRegister_2('E:\General Patient Info - Copy (2)\E16\brain+grid_3Drecon.jpg',1);
eCogImageRegister_2('E:\General Patient Info - Copy (2)\E1\brain+grid_3Drecon.jpg',1);


eCogImageRegister('E:\General Patient Info\EC18\brain+grid_3Drecon.jpg',1);

eCogImageRegister('E:\General Patient Info\EC18_v2\brain+grid_3Drecon_cropped.jpg',1);

%% then
dpath = 'C:\Users\Angela\Documents\ECOGdataprocessing\PatientData\EC\EC2 General Info';
dpath='C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC18'
dpath='E:\General Patient Info\EC18_v2'
dpath='C:\Users\ego\Dropbox\ChangLab\General Patient Info\EC18'
subject = 'EC18';
subject = 'EC18_v2';

ECogDataVis (dpath,subject,1:256,[],0,[],[]);

ECogDataVis (dpath,subject,1:256,[],2,[],[]);

figure
data = rand(256,1)-.5;
ECogDataVis (dpath,subject,1:256,data,1,[],[]);

data = rand(256,10)-.5;
ECogDataVis (dpath,subject,1:256,data,3);
for c = 1:10, lab{c}=c-5;end
F = ECogDataMovie(dpath,subject,1:256,data,lab);
%%
a=find(maxZallchan>1)
ECogDataVis (dpath,subject,a,[],2);

figure
ECogDataVis (dpath,subject,find(data>.2),[],2,[]);
%%
%if electrodes are out of order
load('gridlayout')
g=reshape(gridlayout',[1 128])
load('regdata');

xy2=xy(:,g)
xy=xy2
save ('regdata','xy');
ECogDataVis (dpath,subject,1:128,[],2,[],[]);




