load('E:\DelayWord\StimData\stimsites')
load('E:\DelayWord\StimData\siteCoord')
load('E:\DelayWord\StimData\stimTaskCoord.mat')

%% READ FROM CELL ARRAY INTO STRUCTURE
subj=unique(cellstr(char(stimsites{:,1})));
sites=unique(cellstr(char(stimsites{:,3})));
sites=sites([3 4 5 2]);
errors={'per','ph','ms','off','nr'}
%%
for i=1:length(subj)
    for j=1:length(sites)
        stimResults(i).subj=subj{i}
        stimIdx=intersect(find(strcmp(stimsites(:,1),subj{i})),find(strcmp(stimsites(:,3),sites{j})));
        if ~isempty(stimIdx)        
            stimResults(i).(sites{j}).total=length(stimIdx);
            stimResults(i).(sites{j}).allError=length(find(~cell2mat(stimsites(stimIdx,7))))
            for k=1:length(errors)
                if ~isempty(errors{k})
                    stimResults(i).(sites{j}).(errors{k})=length(find(strcmp(stimsites(stimIdx,9),errors{k})));
                end
            end
        end        
    end
end
%%
for i=1:length(stimTaskCoord)
    if isnumeric(stimTaskCoord{i,4})
        idx=intersect(find(strcmp(stimsites(:,1),stimTaskCoord{i,1})),...
            find(strcmp(stimsites(:,2),int2str(stimTaskCoord{i,4}))))
    else
        idx=intersect(find(strcmp(stimsites(:,1),stimTaskCoord{i,1})),...
            find(strcmp(stimsites(:,2),stimTaskCoord{i,4})))'
    end
    stimTaskCoord{i,18}=length(idx);
    stimNum=stimsites(idx,9);
    for k=1:length(errors)
        stimTaskCoord{i,18+k}=length(find(strcmp(stimsites(idx,9),errors{k})))/length(stimNum);
    end
end
% %%
%     
%     
%     
%     
%     for j=1:length(sites)
%         stimResults(i).subj=subj{i}
%         stimIdx=intersect(find(strcmp(stimsites(:,1),subj{i})),find(strcmp(stimsites(:,3),sites{j})));
%         if ~isempty(stimIdx)        
%             stimResults(i).(sites{j}).total=length(stimIdx);
%             stimResults(i).(sites{j}).allError=length(find(~cell2mat(stimsites(stimIdx,7))))
%             for k=1:length(errors)
%                 if ~isempty(errors{k})
%                     stimResults(i).(sites{j}).(errors{k})=length(find(strcmp(stimsites(stimIdx,9),errors{k})));
%                 end
%             end
%         end        
%     end
% end

% %% COLLAPSE ALL PATIENTS
% figure
% for j=1:length(sites)
%     rates2=[]
%     for i=1:length(subj)
%         if ~isempty(stimResults(i).(sites{j}))
%             rates2=[rates2 cell2mat(struct2cell(stimResults(i).(sites{j})))];
%         end
%         set(gca,'Visible','off')
%     end
%     rates3{j}=[rates2(3:end,:)./repmat(rates2(1,:),5,1); (rates2(1,:)-rates2(2,:))./rates2(1,:)];       
% end
% 
% tmp=cell2mat(cellfun(@(x) mean(x,2),rates3,'UniformOutput',0));
% bar(tmp','stacked')
%% CONVERT NUMBERS TO STRINGS
idx=find(cellfun(@isnumeric,siteCoord(:,5)))
siteCoord(idx,5)=cellfun(@int2str,siteCoord(idx,5),'UniformOutput',0)

idx=find(cellfun(@isnumeric,stimsites(:,2)))
stimsites(idx,2)=cellfun(@int2str,stimsites(idx,2),'UniformOutput',0)

%% GET ERROR POINTS ON NORMALIZED BRAIN
load('E:\DelayWord\StimData\sulciCoord')
clf
brainfile='E:\DelayWord\StimData\brain_3Drecon_coordinates2.jpg'
a=imread(brainfile);
imshow(a)
hold on
origin=[368.6203  452.8957]
xySF=sulciCoord.xySF;
xyCS=sulciCoord.xyCS;
clear xysites
xysites=plotPointsBrainNormalized3([stimTaskCoord{:,14}],[stimTaskCoord{:,15}],xySF,xyCS,a);

scatter(xysites(:,1),xysites(:,2))
stimTaskCoord(:,16)=num2cell(double(xysites(:,1)))
stimTaskCoord(:,17)=num2cell(double(xysites(:,2)))

%% GET TASK POINTS ON NORMALIZED BRAIN
clf
brainfile='E:\DelayWord\StimData\brain_3Drecon_coordinates2.jpg'

a=imread(brainfile);
imshow(a)
hold on
xysites=plotPointsBrainNormalized3([stimTaskCoord{:,14}],[stimTaskCoord{:,15}],xySF,xyCS,a);

scatter(xysites(:,1),xysites(:,2))
stimTaskCoord(:,16)=num2cell(double(xysites(:,1)))
stimTaskCoord(:,17)=num2cell(double(xysites(:,2)))

% %% PLOT ERRORS BASED ON COORDINATES
% siteCoord=stimTaskCoord
% subj=unique(cellstr(char(siteCoord{:,1})));
% siteIdx=1;
% for i=1:length(subj)
%     sidx=find(strcmp(siteCoord(:,1),subj{i}))
%     for j=1:length(sidx)
%         siteName=siteCoord(sidx(j),4);
%         stimIdx=intersect(find(strcmp(stimsites(:,1),subj{i})),find(strcmp(stimsites(:,2),siteName)));
%         if ~isempty(stimIdx)
%             inc=find(~cell2mat(stimsites(stimIdx,7)));
%             fields=unique(cellstr(char(stimsites(stimIdx(inc),9))))
%             for f=1:length(fields)
%                 stimCoord(siteIdx).(fields{f})=length(find(strcmp(stimsites(stimIdx,9),fields{f})))/length(stimIdx);
%             end
%         end        
%         stimCoord(siteIdx).coord=cell2mat(siteCoord(intersect(find(strcmp(siteCoord(:,1),subj{i})),find(strcmp(siteCoord(:,4),siteName))),[14 15]));        
%         stimCoord(siteIdx).braincoord=cell2mat(siteCoord(intersect(find(strcmp(siteCoord(:,1),subj{i})),find(strcmp(siteCoord(:,4),siteName))),[16 17]));        
%         siteIdx=siteIdx+1;
%     end
% end
%% PLOT GRIDDATA POINTS ON BRAIN: ERROR TYPE
colorjet=(flipud(hot))
lim=300
figure
for k=1:length(errors)
    G(k).points=[];
    G(k).points2=[];
    G(k).val=[];
    idx=find(~cellfun(@isempty,{stimCoord.(errors{k})}));
    subplot(1,5,k)
    %imagesc(repmat(a,[1 1 3]))
    imshow(a)
    hold on
    for x=1:length(idx)
        xy=stimCoord(idx(x)).braincoord;
        %plotManyPolygons(xy,5,colorjet(ceil(k/5*64),:),stimCoord(idx(x)).(errors{k}),5)    
        hold on
        G(k).points=[G(k).points;xy];
        G(k).points2=[G(k).points2;stimCoord(idx(x)).braincoord]
        G(k).val=[G(k).val stimCoord(idx(x)).(errors{k})];
        scatter(xy(1),xy(2),100,colorjet(ceil(stimCoord(idx(x)).(errors{k})*64),:),'fill')

    end
    axis tight
end
%%
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\hot_adjusted')
a=imread('E:\DelayWord\StimData\brain2.jpg');
limx=size(a,2);
limy=size(a,1);
grain=1;
gx=1:grain:limx;
gy=1:grain:limy;
[X,Y] = MESHGRID(gx,gy);
Z=zeros(size(X));

grain2=10;
gx2=1:grain2:limx;
gy2=1:grain2:limy;
[X2,Y2] = MESHGRID(gx2,gy2);
Z2=zeros(size(X2));

clf
%figure
maxVq=.7;
colorjet=flipud(hot);
%idx=ceil(rand(1,500)*size(X2,1)*size(X2,2));
idx=1:size(X2,1)*size(X2,2);
X3=reshape(X2,1,[]);
Y3=reshape(Y2,1,[]);

XY2=vertcat(X3,Y3);
set(gcf,'Color','w')
useidx=[]
for k=1:length(errors) 
    try
        nidx=[];
        useidx=[];
        useidx=find([stimTaskCoord{:,18}]~=0);

        for i=useidx
            d=squareform(pdist([cell2mat(stimTaskCoord(i,[16,17]))' XY2]'));
            d2=d(1,2:end);
            if (stimTaskCoord{i,18})~=0
                [aidx,bidx]=find(d2<30);
                nidx=[nidx bidx];
            end
        end
        idx=setdiff(1:length(X3),unique(nidx));

        [Xq,Yq,Vq]=griddata([X3(idx) cell2mat(stimTaskCoord(useidx,16))'],[ Y3(idx) cell2mat(stimTaskCoord(useidx,17))'],[reshape(Z2(idx),1,[]) cell2mat(stimTaskCoord(useidx,k+18))'],X,Y);

        
        grain=1
        Vq(find(isnan(Vq)))=0;     
        tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
        tmp2(isnan(tmp2))=0;
        tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
        tmp1=tmp3;
        tmp3(find(isnan(tmp3)))=0;
        tmp3(find(tmp3<0))=0;
        %tmp4=tmp3./maxVq;
        tmp4=smooth2(tmp3,10);   
        tmp4=tmp4./maxVq;
        pos=subplotMinGray(1,1,1,0)
        ha = axes('units','normalized', ...
            'position',pos);
        imagesc(repmat(a,[1 1 3]))
        %imshow(a)   
        hold on
        set(ha,'handlevisibility','off', ...
        'visible','off')
        ha = axes('units','normalized', ...
            'position',pos);  
        imshow(tmp4)   
        set(gcf,'position',[0 0 limx limy])

       [Xq,Yq,Vq]=griddata([X3(idx) cell2mat(stimTaskCoord(useidx,16))'],[ Y3(idx) cell2mat(stimTaskCoord(useidx,17))'],[reshape(Z2(idx),1,[]) cell2mat(stimTaskCoord(useidx,k+18))'+1],X,Y);

        %tmp4=tmp4;
        %tmp4(find(tmp4>.8))=.8;
        Vq(find(Vq>.4))=1;
        tmp6=smooth2(Vq,5)./(max(max(smooth2(Vq,5))));
        tmp6(find(tmp6>.8))=.8;
        alpha(tmp6)
        colormap(flipud(hot_adjusted))
        hold on
        %scatter(cell2mat(stimTaskCoord(useidx,16))',cell2mat(stimTaskCoord(useidx,17))',100,colorjet(findNearest(cell2mat(stimTaskCoord(useidx,k+18))'*length(colorjet),1:64)',:,:),'fill')
        %scatter(G(k).points2(:,1),G(k).points2(:,2),100,'b','fill')
        %input('n')  
        set(gcf,'PaperPositionMode','auto')
        print(['C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\StimData\g',int2str(k)],'-depsc')

        clf
    end
end
%print(gcf,'-r900', '-dpdf', ['E:\DelayWord\StimData\errType_gridData.pdf']);
%print(gcf,'-r900', '-djpeg', ['E:\DelayWord\StimData\errType_gridData.jpg']);
%export_fig 'E:\DelayWord\StimData\errType_gridData.jpg' -opengl

%%
% %% PLOT GRIDDATA POINTS ON BRAIN: TASK TYPE
% taskType=unique(stimTaskCoord(:,3))
% for k=1:length(taskType)
%     idx=find(strcmp(stimTaskCoord(:,3),taskType{k}))
%     G(k+length(errors)).points2=[cell2mat(stimTaskCoord(idx,6)) cell2mat(stimTaskCoord(idx,7))];
%     G(k+length(errors)).val=ones(1,length(idx))*k;
% end
% load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\hot_adjusted')
% a=imread('E:\DelayWord\StimData\brain2.jpg');
% limx=size(a,2);
% limy=size(a,1);
% grain=1;
% gx=1:grain:limx;
% gy=1:grain:limy;
% [X,Y] = MESHGRID(gx,gy);
% Z=zeros(size(X));
% 
% grain2=30;
% gx2=1:grain2:limx;
% gy2=1:grain2:limy;
% [X2,Y2] = MESHGRID(gx2,gy2);
% Z2=zeros(size(X2));
% 
% clf
% %figure
% maxVq=0.8;
% colorjet=flipud(hot);
% %idx=ceil(rand(1,500)*size(X2,1)*size(X2,2));
% idx=1:size(X2,1)*size(X2,2);
% X3=reshape(X2,1,[]);
% Y3=reshape(Y2,1,[]);
% XY2=vertcat(X3,Y3);
% 
% for k=(1:length(taskType))+length(errors)
%     try
%         nidx=[];
%         for i=1:size(G(k).points2,1)
%             d=squareform(pdist([ G(k).points2(i,:)' XY2]'));
%             d2=d(1,2:end);
%             [aidx,bidx]=find(d2<30);
%             nidx=[nidx bidx];
%         end
%         idx=setdiff(1:length(X3),unique(nidx));        
%         [Xq,Yq,Vq]=griddata([X3(idx) G(k).points2(:,1)'],[ Y3(idx) G(k).points2(:,2)'],[reshape(Z2(idx),1,[]) G(k).val],X,Y,'v4');
%        %[Xq,Yq,Vq]=griddata([G(k).points2(:,1)'],[G(k).points2(:,2)'],[ G(k).val],X,Y);
%         
%         %imagesc(Vq)
%         %keyboard
%                
%         grain=1
%         Vq(find(isnan(Vq)))=0;     
%         tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
%         tmp2(isnan(tmp2))=0;
%         tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
%         tmp1=tmp3;
%         tmp3(find(isnan(tmp3)))=0;
%         tmp3(find(tmp3<0))=0;
%         tmp4=tmp3./maxVq;
%         tmp4=smooth2(tmp4,10);   
%         ha = axes('units','normalized', ...
%             'position',[0 0 1 1]);
%         imagesc(repmat(a,[1 1 3]))
%         %imshow(a)   
%         hold on
%         set(ha,'handlevisibility','off', ...
%         'visible','off')
%         ha = axes('units','normalized', ...
%             'position',[0 0 1 1]);  
%         imshow(tmp4,[0 1])   
%         imagesc(tmp4)
%         set(gcf,'position',[0 0 limx limy])
% 
%         tmp4=tmp4;
%         tmp4(find(tmp4>.8))=.8;
%         tmp4(find(tmp4<.5))=0;
%         %alpha(smooth2(tmp5,1));
%         alpha(tmp4)
%         colormap(flipud(hot_adjusted))
%         hold on
%         %scatter(G(k).points2(:,1),G(k).points2(:,2),100,colorjet(round(G(k).val./max(G(k).val)*length(colorjet))',:,:),'fill')
%         %scatter(G(k).points2(:,
1),G(k).points2(:,2),100,'b','fill')
%         input('n')    
%         clf
%     end
% end
%% PLOT TASK POINTS ON BRAIN
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\hot_adjusted')
a=imread('E:\DelayWord\StimData\brain2.jpg');
colorjet=flipud(hot);
taskType=unique(stimTaskCoord(:,3))
for k=1:length(taskType)
    idx=find(strcmp(stimTaskCoord(:,3),taskType{k}))
    G(k+length(errors)).points2=[cell2mat(stimTaskCoord(idx,16)) cell2mat(stimTaskCoord(idx,17))];
    G(k+length(errors)).val=ones(1,length(idx))*k;
end
clf
opengl software
ha = axes('units','normalized', ...
            'position',[0 0 1 1]);
%imagesc(repmat(a,[1 1 3]))
imshow(a)
hold on
strings={'S','N','R','C'}
for k=(1:length(taskType))+length(errors)
%      ha = axes('units','normalized', ...
%             'position',[0 0 1 1]);

    %imagesc(repmat(a,[1 1 3]))
    %imshow(a)
    hold on    
    text(G(k).points2(:,1), G(k).points2(:,2),strings{k-5},'Color',colorjet(ceil((k-5)*(length(colorjet)/4)),:,:),'FontWeight','bold','FontSize',12)
    %plotManyPolygons([G(k).points2(:,1) G(k).points2(:,2)],100,colorjet(ceil((k-5)*(64/4)),:,:),.7,8)
    
    %scatter(G(k).points2(:,1),G(k).points2(:,2),100,colorjet(ceil((k-5)*(64/4)),:,:),'fill')
    %input('n')
end
%%
set(gcf,'Renderer','opengl','PaperPositionMode','default')
print(gcf,'-r900', '-dpdf', ['E:\DelayWord\StimData\taskType_TransparentDots.pdf']);
