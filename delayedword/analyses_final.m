filename='E:\DelayWord\segmentedDataAllEvents'
for p=[ 2 3 4 5 6  8]
     n=numSet(p);
     ch=1:256
     if p==2
         ch=1:128
     end
     for eidx=2:6
        D=PLVTests(n,eidx,ch,'aa');
        %data=D.Data;
        %mkdir([filename filesep D.Data.patientID])
        %save([filename filesep D.Data.patientID filesep 'D_e' int2str(eidx)],'D','-v7.3');
        %load([filename filesep patients{p} filesep 'D_e' int2str(eidx)])
        D.Data.calcZscore;
        for c=1:D.Data.channelsTot
            for t=1:size(D.Data.segmentedEcog.zscore_separate,4)
                D.Data.segmentedEcog.smoothed100(c,:,:,t)=smooth(resample(D.Data.segmentedEcog.zscore_separate(c,:,:,t),1,4));
            end
        end
         D.Data.segmentedEcog.data=[];
         D.Data.segmentedEcog.zscore_separate=[];
         AllP{p}.Tall{eidx}=D;
     end
 end
%%
%%LOAD AND SAVE ALL BLOCKS
patients={'EC18','EC16','EC22','EC23','EC24','EC29','EC30','EC31','EC28'}
brainFile='E:\General Patient Info\'

n=0
p=0
numSet=[1 17 9 10 11 43 45 47 35];
for p=1:8%1:length(patients)-1%p=1:length(patients)-1
    if n~=17 & p~=2
        ch=1:256;
        events=[2 3 4 5 6]        
    else
        ch=1:128;
    end
    %filename='E:\DelayWord\segmentedDataAllEvents'
    filename='E:\DelayWord\Figure1_withCAR_slideBaseline_ev2'
    load([filename '\Tall_3000_3000_' patients{p} '_B1'])
    %load([filename '\Tall_2000_10000_' patients{p} '_B1'])
    %load([filename '\E_' patients{p} '_B1'])
    events=[2 4 5]%[1 2 3 4 5 6]
    %[Tall]=analyzeData(n,ch,[],events)
    p=find(strcmp(Tall{2}.Data.patientID,patients))
    [~,r]=fileparts(Tall{2}.Data.MainPath)
    s=regexp(r,'_','split')
    blocknum=regexp(s{2},'[123456789]','match')
%     if str2num(blocknum{1})~=1
%         continue
%     end
    AllP{p}.Tall=Tall;
    for eidx=events
        AllP{p}.Tall{eidx}.Data.segmentedEcog.data=[];
        AllP{p}.Tall{eidx}.Data.segmentedEcog.zscore_separate=[];
    end

   % AllP{p}.E=E;
    
    %% GET CS AND SF ELECTRODES
    load(['E:\DelayWord\Figure1_withCAR\BrainCoord2'])   
end
%%
%%LOAD AND SAVE ALL BLOCKS FOR PASSIVE LISTENING
patients={'EC18','EC16','EC22','EC23','EC24','EC29','EC30','EC31','EC28'}
brainFile='E:\General Patient Info\'
n=0
p=0
numSet=[1 17 9 10 11 43 ]
for p=[1 6]%1:length(patients)-1%p=1:length(patients)-1
    if n~=17 & p~=2
        ch=1:256;
        events=[2 4 5]
        
    else
        ch=1:128;
        events=[2 4 5];
    end
    load(['E:\DelayWord\Figure1_withCAR_slideBaseline\Tall_' patients{p} '_B2'])
    load(['E:\DelayWord\Figure1_withCAR_slideBaseline\E_' patients{p} '_B2'])
    %events=[2 4 5]
    %[Tall,E]=analyzeData(n,ch,[],events)
    p=find(strcmp(Tall{2}.Data.patientID,patients))
    [~,r]=fileparts(Tall{2}.Data.MainPath)
    s=regexp(r,'_','split')
    blocknum=regexp(s{2},'[123456789]','match')
%     if str2num(blocknum{1})~=1
%         continue
%     end
    %AllP_P{p}.Tall=Tall;
    %AllP_P{p}.E=E;
    
    %% GET CS AND SF ELECTRODES
    load(['E:\DelayWord\Figure1_withCAR\BrainCoord'])   
end
%% GET STIM POINTS LOCATION
for p=1:length(patients)-1
    visualizeGrid(2,['E:\General Patient Info\' patients{p} '\brain5.jpg'],[]);
    %[x,y]=ginput;
    %BrainCoord(p).stimLoc=[x';y'];
    scatter(BrainCoord(p).stimLoc(1,:),BrainCoord(p).stimLoc(2,:),'fill','r')
    input('n')
end


%% VIEW CS AND SF POINTS
opengl software
for p=1:length(patients)-1
    % GET CS AND SF ELECTRODES
    %load(['E:\DelayWord\Figure1_withCAR\BrainCoord'])
%     load(['E:\DelayWord\Figure1_withCAR\E_' patients{p} '_B1'])
%     AllP{p}.E=E;
    %visualizeGrid(4,['E:\General Patient Info\' AllP{p}.Tall{5}.Data.patientID '\brain4.jpg']);

    load(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\regdata.mat'])
    visualizeGrid(2,['E:\General Patient Info\' AllP{p}.Tall{5}.Data.patientID '\brain5.jpg'],1:length(xy));
    hold on
    %[BrainCoord(p).xySF,BrainCoord(p).xyCS]=getLandMarks(['E:\General Patient Info\' AllP{p}.Tall{5}.Data.patientID '\brain5.jpg'])
    
    scatter(BrainCoord(p).xySF(1,:),BrainCoord(p).xySF(2,:),'fill')
    scatter(BrainCoord(p).xyCS(1,:),BrainCoord(p).xyCS(2,:),'fill')
    q=getBrainQuadrant(BrainCoord(p).xySF,BrainCoord(p).xyCS,xy);
    BrainCoord(p).xy=xy;
    BrainCoord(p).quad=q;
    for qf=1:4
        scatter(BrainCoord(p).xy(1,find(BrainCoord(p).quad==qf)),BrainCoord(p).xy(2,find(BrainCoord(p).quad==qf)),'fill')
         input('n')
    end
end
%% RECORD ELECTRODE POSITION
for p=1:length(patients)-1
    %visualizeGrid(4,['E:\General Patient Info\' AllP{p}.Tall{5}.Data.patientID '\brain4.jpg']);
    load(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\regdata.mat'])
    BrainCoord(p).xy=xy;
    %input('n')
end
%% GET RID OF PEAK DUE TO BEEP
for p=1:length(patients)-1
    usesamps=[1:400]
    %     for x=5
    %         AllP{p}.Tall{x}.Data.segmentedEcog.smoothed100=[]
    %         for c=1:AllP{p}.Tall{x}.Data.channelsTot
    %             for tr=1:size( AllP{p}.Tall{x}.Data.segmentedEcog.zscore_separate,4)
    %                 AllP{p}.Tall{x}.Data.segmentedEcog.smoothed100(c,:,:,tr)=smooth(resample(squeeze(AllP{p}.Tall{x}.Data.segmentedEcog.zscore_separate(c,:,:,tr)),1,4),20);
    %             end
    %         end
    %     end
    AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100Hold=AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100;
    usetr=AllP{p}.Tall{5}.Data.Params.usetr;
    idx=find(cellfun(@isempty,AllP{p}.Tall{5}.Data.segmentedEcog.event(:,[13])))
    for i=1:length(idx)
        AllP{p}.Tall{5}.Data.segmentedEcog.event{idx(i),15}=0
    end
    idx=find(cellfun(@isempty,AllP{p}.Tall{5}.Data.segmentedEcog.event(:,[11])))
    for i=1:length(idx)
        AllP{p}.Tall{5}.Data.segmentedEcog.event{idx(i),13}=0
    end
    beepsamp=(vertcat(AllP{p}.Tall{5}.Data.segmentedEcog.event{:,[13]})-vertcat(AllP{p}.Tall{5}.Data.segmentedEcog.event{:,[11]}))*100
    for tr=usetr
        if abs(beepsamp(tr))>199
            samps=1:200;
        else
            samps=round(200-beepsamp(tr)):round(200-beepsamp(tr)+130);
        end
        AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(AllP{p}.Tall{2}.Data.Params.activeCh,samps,:,tr)=NaN;
    end
end
%%
%powerpoint_object=SAVEPPT2('test2','init')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
for p=1:length(patients)-1
    for eidx=[2 4 5]
        AllP{p}.Tall{eidx}.Data.plotData('stacked',1,'1','n','n')
        colormap(redblackwhite)
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveppt2('ppt',powerpoint_object,'scale','on','stretch','off');
        close all
    end
end
%% SHOW GRID POSITION ON BRAIN
for p=1:8
    visualizeGrid(2,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'], 1:AllP{p}.Tall{eidx}.Data.channelsTot);
    input('n')
end

%% CHANGE CONFIGURATION OF USECHAN FOR PLOTTING
for p=[1 3 5 6 7 8]    
    AllP{p}.Tall{2}.Data.gridlayout.usechans=AllP{6}.Tall{2}.Data.gridlayout.usechans;
    Tall=AllP{p}.Tall
    [a,b,c]=fileparts( Tall{2}.Data.MainPath)
    %save(['Tall_' b],'Tall','-v7.3')  
end

tmp=reshape(AllP{2}.Tall{2}.Data.gridlayout.usechans,16,16)
tmp=flipud(tmp)
AllP{2}.Tall{2}.Data.gridlayout.usechans=reshape(tmp',1,[])
%% PLOT STACKED PRESENTATION AND PRODUCTION IN GRID FORM WITH SULCUS IN BACKGROUND
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')

%figure
clf
set(gcf,'Color','w')
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
eventSamp=200
for p=1:length(patients)-1
    %%
    clf
    b=imread(['E:\DelayWord\ERP_allactivech_sulciDrawn\sulcus_s' int2str(p) '.jpg']);
    ha=axes('Position',[0 0 1 1],'Units','normalize')
    imshow(b)
    set(gca,'handlevisibility','off','visible','off')
    activeCh=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh'])
    activeCh=AllP{p}.Tall{2}.Data.gridlayout.usechans(find(ismember(AllP{p}.Tall{2}.Data.gridlayout.usechans,activeCh)));
    for eidx=[2 5]
        AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
        for c=activeCh
            cidx=find(AllP{p}.Tall{2}.Data.gridlayout.usechans==c);
            [h,pos]=plotGridPosition2(cidx);
            if eidx==2
               subplot('Position',[pos(1) pos(2)+pos(4)/2 pos(3) pos(4)/2])
            else
               subplot('Position',[pos(1) pos(2) pos(3) pos(4)/2])
            end
            [~,sortidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,9))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,7)));
            usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            usetr=sortidx(find(ismember(sortidx,usetr)));
            %        plot(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100Hold(c,:,:,usetr),4),'r','LineWidth',2)
            %        plot(nanmean(AllP{p}.Tall{4}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),'Color',rgb('green'),'LineWidth',2)

            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr))',[0 5])
            hold on
            axis tight            
            hl=line([eventSamp eventSamp],[1 length(usetr)]);
            set(hl,'Color','k','LineStyle',':')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event((usetr),col{eidx}(2)))...
                -cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event((usetr),col{eidx}(1)));
            hold on
            plot(eventSamp+res*100,1:length(usetr),'k')               
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            
            if eidx==2
                text(5,5,int2str(c),'Background','w','FontSize',7)
            end
           % plot(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr)))%
            %[hl,hp]=errorarea(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),sqrt(nanstd(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr),[],4)./length(~isnan(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,1,1,usetr)))))
            %set(hl,'LineWidth',2)
            %line([200 200],[-2 5])
            if eidx==2
                colormap(redblackwhite)
            else
                colormap(blueblackwhite)
            end
            freezeColors     
        end
    end
    %input('n')       
    set(gcf,'Renderer','painters','PaperPositionMode','default')
    filename=['E:\DelayWord\ERP_allactivech_sulciDrawn\stacked_s' int2str(p) '_e',int2str(eidx) '.pdf']
    eval(['export_fig ' filename ' -painters'])
   
end
%%
%% PLOT STACKED PRESENTATION AND PRODUCTION IN GRID FORM WITH BRAIN IN BACKGROUND
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')
opengl software
samps=[1:400];
%figure
clf
set(gcf,'Color','w')
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
eventSamp=200
for p=1:length(patients)-1
    %%
    a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
    %figure('Position',[0 0 size(a,2) size(a,1)])
    %screenSize=get(0,'ScreenSize')

    %figure('Position',screenSize,'Units','normalized')
    brainGridxy=[min(BrainCoord(p).xy(1,:))-80 max(BrainCoord(p).xy(1,:))+80 ...
        min(BrainCoord(p).xy(2,:))-10 max(BrainCoord(p).xy(2,:))+10];
    figure('Position',[0 0 diff(brainGridxy([1,2]))*2 diff(brainGridxy([3,4]))*2],'Units','pixels')
    opengl software
    ha=axes('Position',[0 0 1 1 ],'Units','pixels');
    %imshow(a)
    imshow(repmat(a,[1 1 3]))
    axis(brainGridxy)
    hold on
    
    %scatter(BrainCoord(p).xy(1,:),BrainCoord(p).xy(2,:),'fill','r');
    %freezeColors;
    set(gca,'handlevisibility','off','visible','off')
    activeCh=1:AllP{p}.Tall{2}.Data.channelsTot;
    %activeCh=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh'])
    activeCh=AllP{p}.Tall{2}.Data.gridlayout.usechans(find(ismember(AllP{p}.Tall{2}.Data.gridlayout.usechans,activeCh)));
    %%
    for eidx=[2 5]
        %%
        clf
        AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
        for c=activeCh
            cidx=find(AllP{p}.Tall{2}.Data.gridlayout.usechans==c);
            %[h,pos]=plotGridPosition2(cidx);
            pos(1)=(BrainCoord(p).xy(1,c)-brainGridxy(1))/diff(brainGridxy([1,2]));
            pos(2)=(BrainCoord(p).xy(2,c)-brainGridxy(3))/diff(brainGridxy([3,4]));
            %pos(1)=BrainCoord(p).xy(1,c)/size(a,2);
            %pos(2)=size(a,1)-BrainCoord(p).xy(2,c)/size(a,1);
            pos(3)=.06;
            pos(4)=.03;
           
            [~,sortidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,9))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,7)));
            usetr=1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.event,1)
            %usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            usetr=sortidx(find(ismember(sortidx,usetr)));
            %        plot(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100Hold(c,:,:,usetr),4),'r','LineWidth',2)
            %        plot(nanmean(AllP{p}.Tall{4}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),'Color',rgb('green'),'LineWidth',2)
            d=flipud(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,samps,:,usetr))');            
            axes('Position',[pos(1) 1-pos(2) pos(3) pos(4)])
            set(gca,'Units','pixel');
            posP=get(gca,'Position');
            %imLarge=imresize(d,'scale',[round(posP(4))/size(d,1) round(posP(3))/size(d,2) ]);
            %imshow(imLarge)
            %imshow(d)
            %axis fill
            pcolor(d)
            d_alpha=d/3;            
            d_alpha(find(d_alpha<0))=.7;
            d_alpha(find(d_alpha>1))=1;
            alpha(.7)
            shading interp
            %alpha(d_alpha)            
            set(gca,'Clim',[0 5])
            hold on
            %axis tight            
            hl=line([eventSamp eventSamp],[1 length(usetr)]);
            set(hl,'Color','k','LineStyle',':')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event((usetr),col{eidx}(2)))...
                -cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event((usetr),col{eidx}(1)));
            res=flipud(res);
            hold on
            plot(eventSamp+res*100,1:length(usetr),'k')               
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])    
            text(5,5,int2str(c),'FontSize',7,'BackgroundColor','w')
            
           % plot(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr)))%
            %[hl,hp]=errorarea(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),sqrt(nanstd(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr),[],4)./length(~isnan(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,1,1,usetr)))))
            %set(hl,'LineWidth',2)
            %line([200 200],[-2 5])
            if eidx==2
                colormap(redblackwhite)
            else
                colormap(blueblackwhite)
            end
            %set(gca,'handlevisibility','off','visible','off')

            %freezeColors   
        end
        %%
        %input('n')
        set(gcf,'Renderer','openGL','PaperPositionMode','default')
        filename=['E:\DelayWord\ERP_allactivech_onBrain\stackedAlpha7_s' int2str(p) '_e',int2str(eidx) '.pdf']
        eval(['export_fig ' filename ' -opengl'])
        %print('-dpdf',filename)
   
    end
end
%%
%% PLOT AVERAGED PRESENTATION AND PRODUCTION IN GRID FORM WITH BRAIN IN BACKGROUND
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')
samps=[1:400];
colormat{2}='r';
colormat{5}='b';
%figure
clf
set(gcf,'Color','w')
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
eventSamp=200
for p=1:length(patients)-1
    %%
    %clf
    a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
    %figure('Position',[0 0 size(a,2) size(a,1)])
    %screenSize=get(0,'ScreenSize')

    %figure('Position',screenSize,'Units','normalized')
    brainGridxy=[min(BrainCoord(p).xy(1,:))-80 max(BrainCoord(p).xy(1,:))+80 ...
        min(BrainCoord(p).xy(2,:))-10 max(BrainCoord(p).xy(2,:))+10];
    figure('Position',[0 0 diff(brainGridxy([1,2]))*2 diff(brainGridxy([3,4]))*2],'Units','pixels')
    opengl software
    ha=axes('Position',[0 0 1 1 ],'Units','pixels');
    %imshow(a)
    imagesc(a); colormap('gray'); freezeColors;
    axis(brainGridxy)
    hold on
    scatter(BrainCoord(p).xy(1,:),BrainCoord(p).xy(2,:),'fill','r');
    freezeColors;
    set(gca,'handlevisibility','off','visible','off')
    %ha=axes('Position',[0 0  1 1],'Units','normalize');
    activeCh=1:AllP{p}.Tall{2}.Data.channelsTot;

    %activeCh=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh'])
    activeCh=AllP{p}.Tall{2}.Data.gridlayout.usechans(find(ismember(AllP{p}.Tall{2}.Data.gridlayout.usechans,activeCh)));
    for eidx=[2 5]
        AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
        for c=activeCh
            cidx=find(AllP{p}.Tall{2}.Data.gridlayout.usechans==c);
            %[h,pos]=plotGridPosition2(cidx);
            pos(1)=(BrainCoord(p).xy(1,c)-brainGridxy(1))/diff(brainGridxy([1,2]));
            pos(2)=(BrainCoord(p).xy(2,c)-brainGridxy(3))/diff(brainGridxy([3,4]));
            %pos(1)=BrainCoord(p).xy(1,c)/size(a,2);
            %pos(2)=size(a,1)-BrainCoord(p).xy(2,c)/size(a,1);
            pos(3)=.06;
            pos(4)=.03;
               axes('Position',[pos(1) 1-pos(2) pos(3) pos(4)])
           
            [~,sortidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,9))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,7)));
            %usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            usetr=1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.event,1)
            usetr=sortidx(find(ismember(sortidx,usetr)));
            %        plot(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100Hold(c,:,:,usetr),4),'r','LineWidth',2)
            %        plot(nanmean(AllP{p}.Tall{4}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),'Color',rgb('green'),'LineWidth',2)
            d=flipud(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,samps,:,usetr))');
            %pcolor(d);
            alpha(d./(max(max(d))))

            shading interp
            set(gca,'Clim',[0 5])
            hold on
            axis tight            
            %hl=line([eventSamp eventSamp],[1 length(usetr)]);
            %set(hl,'Color','k','LineStyle',':')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event((usetr),col{eidx}(2)))...
                -cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event((usetr),col{eidx}(1)));
            res=flipud(res);
            hold on
            %plot(eventSamp+res*100,1:length(usetr),'k')               
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])                
            
           % plot(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr)))%
            [hl,hp]=errorarea(nanmean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),sqrt(nanstd(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4)./length(~isnan(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,1,1,usetr)))));
            hold on
            set(hp,'FaceColor',colormat{eidx})
            set(hl,'LineWidth',2,'Color',colormat{eidx})
            line([eventSamp eventSamp],[-2 5])
            if eidx==2
                colormap(redblackwhite)
                text(0,-2,int2str(c),'FontSize',7,'BackgroundColor','w','Color','k')
            else
                colormap(blueblackwhite)
            end
            axis tight
            freezeColors   
        end
    end
    %input('b')
    set(gcf,'Renderer','opengl','PaperPositionMode','default')
    filename=['E:\DelayWord\ERP_allactivech_onBrain\Ave_s' int2str(p) '_e',int2str(eidx) '.pdf']
    eval(['export_fig ' filename ' -opengl'])
    %print(gcf,'-r300', '-dpdf', ['E:\DelayWord\S_ERP_allactivech\Ave_s' int2str(p) '_e',int2str(eidx) '.pdf']);
end
%% GET PEAK TIME FOR EACH TRIAL
for p=1:length(patients)-1
    %%
    for eidx=events
        clf
        usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
        usech=find(cell2mat(cellfun(@length,{AllP{p}.E{eidx}.electrodes.TTest},'UniformOutput',0))>1);
        usech=intersect(usech,AllP{p}.Tall{eidx}.Data.Params.activeCh);
        for c=usech
            plotGridPosition(c);
            plot(squeeze(nanmean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4)));          
            if ismember(c,AllP{p}.Tall{eidx}.Data.Params.activeCh)
                hold on
                sigSamps=find([AllP{p}.E{eidx}.electrodes(c).TTest])+199;
                try
                    plot(sigSamps,0,'r.')
                catch
                    AllP{p}.Tall{eidx}.Data.Params.activeCh=setdiff(AllP{p}.Tall{eidx}.Data.Params.activeCh,c)
                     AllP{p}.E{eidx}.electrodes(c).maxAmpTr=NaN;
                    AllP{p}.E{eidx}.electrodes(c).maxIdxTr=NaN;
                    continue
                end
                [maxAmp,tmp]=max(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,sigSamps,1,:)),[],1);
                maxIdx=sigSamps(tmp);
                maxIdx(find(isnan(maxAmp)))=NaN;
                AllP{p}.E{eidx}.electrodes(c).maxAmpTr=maxAmp(usetr);
                AllP{p}.E{eidx}.electrodes(c).maxIdxTr=maxIdx(usetr);
                if mean(squeeze(nanmean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,200:300,:,usetr),4)))<.3 | ...
                         std(squeeze(nanmean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4)))<.2
                    AllP{p}.E{eidx}.electrodes(c).maxAmpTr=NaN;
                    AllP{p}.E{eidx}.electrodes(c).maxIdxTr=NaN;
                else
                    plot(nanmedian(maxIdx(usetr)),2,'*')
                    set(gca,'Color','y')
                    hold on
                end        
            else
            
            end
            axis([0 400 -1 5])
            if sum(isnan(AllP{p}.E{eidx}.electrodes(c).maxAmpTr))
                AllP{p}.Tall{eidx}.Data.Params.activeCh=setdiff(AllP{p}.Tall{eidx}.Data.Params.activeCh,c);
            end
        end      
    end
end


%% PLOT PEAK
clf
e=1;
for eidx=[2 5]
    subplot(1,2,e)
    scatterAllPatientsPeak
    input('n')
    
    e=e+1;
end
%% INTERPOLATED PEAK MAP
try
    load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblack')
end
eidx=5
colorjet=redblack
colorjet=flipud(hot)
for p=1:6
    %%
    a=imread(['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg']);
    limx=size(a,2);
    limy=size(a,1);
    grain=21;
    gx=1:grain:limx;
    gy=1:grain:limy;
    [X,Y] = MESHGRID(gx,gy);
    Z=zeros(size(X));
     usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
    pkTime=cell2mat(cellfun(@nanmedian,{AllP{p}.E{eidx}.electrodes(:).maxIdxTr},'UniformOutput',0))*10;
    pkTime=max(pkTime)+1-pkTime;
    g=gridfit([BrainCoord(p).xy(1,:) reshape(X,1,[])],[BrainCoord(p).xy(2,:) reshape(Y,1,[])],[pkTime reshape(Z,1,[])],gx,gy);
     t = maketform('affine',[length(g2) length(g2) 1;length(g2) 1 length(g2)]',[length(g2)*grain length(g2)*grain;length(g2)*grain 0;0 length(g2)*grain]);
    g2=g;
    R = makeresampler('cubic','fill');
    tmp2 = imtransform(g2,t,R,'XYScale',1);    
    ha = axes('units','normalized', ...
        'position',[0 0 1 1]);
    imagesc(a)
    hold on
    set(ha,'handlevisibility','off', ...
    'visible','off')
    axes('position',[0 0 1 1])    
    tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
    imshow(tmp3,[0 max(max(tmp3))])
    tmp4=tmp3./(max(max(tmp3)));
    tmp4(find(tmp4<0))=0;
    tmp4(find(tmp4>.2))=.7;
    tmp4=smooth2(tmp4,10);
    alpha(tmp4);
    colormap(hot)
    input('n')    
    clf
end
%%



%% INTERPOLATED PEAK MAP
try
    load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblack')
end
eidx=2
colorjet=redblack
colorjet=flipud(hot)
maxTime=max(mxV(:,eidx))
minPeak=2110
maxPeak=2830
for p=1:6
    %%
    try
        a=imread(['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain2.jpg']);
    catch
        a=imread(['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg']);
    end
    limx=size(a,2);
    limy=size(a,1);
    grain=5;
    gx=1:grain:limx;
    gy=1:grain:limy;
    [X,Y] = MESHGRID(gx,gy);
    Z=zeros(length(X),size(Y));
    usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
    pkTime=cell2mat(cellfun(@nanmedian,{AllP{p}.E{eidx}.electrodes(:).maxIdxTr},'UniformOutput',0))*10;
    g2(p).pkTime=pkTime;
    pkTime=maxPeak-pkTime+1;
    [Xq,Yq,Vq]=griddata([BrainCoord(p).xy(1,:)],[BrainCoord(p).xy(2,:)],[pkTime],X,Y);
    g2(p).Vq=Vq;

    grain=1
    %t = maketform('affine',[length(g2) length(g2) 1;length(g2) 1 length(g2)]',[length(g2)*grain length(g2)*grain;length(g2)*grain 0;0 length(g2)*grain]);
    minColor=min(mn)./maxTime;
    maxColor=max(mx)./maxTime;
    
    Vq(find(isnan(Vq)))=0;  
    %R = makeresampler('line','fill');
    %tmp2 = imtransform(g2,t,R,'XYScale',1);  
    %tmp3=imresize(tmp2,[size(a,1) size(a,2)]);

    tmp2=imresize(Vq,[size(a,1)*10 size(a,2)*10]);
    tmp2(isnan(tmp2))=0;
    tmp3=imresize(tmp2,[size(a,1) size(a,2)]);
    tmp1=tmp3;
    tmp3(find(isnan(tmp3)))=0;
    tmp3(find(tmp3<0))=0;
    tmp4=tmp3./maxTime;
    tmp4=smooth2(tmp4,10);   

    ha = axes('units','normalized', ...
        'position',[0 0 1 1]);
    imagesc(repmat(a,[1 1 3]))
    colormap(gray)
    hold on
    set(ha,'handlevisibility','off', ...
    'visible','off')
     ha = axes('units','normalized', ...
        'position',[0 0 1 1]);  
    imshow(tmp4,[minColor maxColor])
    
    tmp4=tmp4*2;
    tmp4(find(tmp4>1))=1;
    %alpha(smooth2(tmp5,1));
    alpha(tmp4)
    %colormap(flipud(redblack))
    
   colormap(flipud(hot))

    input('n')    
    clf
end
%%
for p=1:6 
    mxV(p,eidx)=max(max(g2(p).Vq))
    mnV(p,eidx)=min(min(g2(p).Vq))
    mxP(p,eidx)=max(max(g2(p).pkTime))
    mnP(p,eidx)=min(min(g2(p).pkTime))    
end




%% PARTIAL CORR TO WL AND WF
eidx=2
%close all
extremeRange=linspace(-1,1,64);
usesamp=100:400
for p=1:length(patients)-1
    clf
    Labels=AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,8);
    getWordProp;
    ct1=cell2mat(wordProp.f(:));
    tmp=ones(length(wordProp.ed),1);
    tmp(find(strcmp(wordProp.ed,'easy')))=2;
    ct2=tmp;
    v=cell2mat(wordProp.l(:))
    usech=AllP{p}.Tall{eidx}.Data.usechans
    usetr=setdiff(1:length(ct1),[find(strcmp('n',wordProp.ed)) reshape(AllP{p}.Tall{eidx}.Data.Artifacts.badtr,1,[])]);
    dat=squeeze(prctile(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),99,2));
    %dat=squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,usetr),2));
    %[dat,midx]=max(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),[],2);
    dat=squeeze(dat);
    midx=squeeze(midx);
    %dat=midx;
    [R,pval]=partialcorr(dat', v(usetr),[ct1(usetr)],'type','Spearman');
    %[R,pval]=corr(dat', v(usetr),'type','Spearman');
    [pval,h_fdr]=MT_FDR_PRDS(pval,.05);
    chidx=find(pval<=.05 & R>0);
    ch=usech(chidx)
    idx=findNearest(R(chidx),extremeRange);
    figure(1)
    %getChLocations
    d=R(chidx);
    visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain5.jpg'],ch,R(chidx)');
    %figure(2)
    %plotDataOnBrain
    input('n')
    clf
end
set(gcf,'Color','w')
%%
%% PARTIAL CORR TO WL AND WF: GRAND MEAN AVE
eidx=4
close all
usesamp=1:400;
for p=1:length(patients)-1
    Labels=AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,8);
    getWordProp;
    ct1=cell2mat(wordProp.f(:));
    tmp=ones(length(wordProp.ed),1);
    tmp(find(strcmp(wordProp.ed,'easy')))=2;
    ct2=tmp;
    v=cell2mat(wordProp.l(:))
    usech=AllP{p}.Tall{eidx}.Data.Params.activeCh;
    usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
    %usetr=setdiff(1:length(ct1),[find(strcmp('n',wordProp.ed)) reshape(AllP{p}.Tall{eidx}.Data.Artifacts.badtr,1,[])]);
    %dat=squeeze(prctile(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),99,2));
    %dat=squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,:,:,usetr),2));
    [dat,midx]=max(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),[],2);
    dat=squeeze(dat);
    midx=squeeze(midx);
    dat=midx;
    %[R,pval]=partialcorr(mean(dat,1)', v(usetr),[ ct1(usetr)],'type','Spearman');
    [R,pval]=corr(mean(dat,1)', v(usetr),'type','Spearman');
    [pval,h_fdr]=MT_FDR_PRDS(pval,.05);
    RAll(p)=R;
    pvalAll(p)=pval;
    %visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain5.jpg'],ch,R(chidx)');
    %figure(2)
    %plotDataOnBrain
end
bar(RAll);
hold on
plot(find(pvalAll<=0.05),0,'r*','LineWidth',20)
set(gcf,'Color','w')
%% mds ALL
clf
dat=[];
colormat=vertcat(rgb('blue'),rgb('red'))
sidx=1;
usesamp=100:300
for s=50:5:250-5
    usesamp=s:s+5
    %%
    for p=1:length(patients)-1
        try
            usech=AllP{p}.Tall{eidx}.Data.Params.activeCh;
            usetr=setdiff(1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100,4),[AllP{p}.Tall{eidx}.Data.Artifacts.badtr]);
            %tmpdat=permute(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100z(usech,usesamp,:,usetr),[2 1 4 3]);
            d=squeeze(prctile(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(usech,usesamp,:,usetr),99,2))';
            badtr=find(zscore(mean(d'))>2);
            usetr2=setdiff(1:length(usetr),badtr);
            pMat(p).d=pdist(d(usetr2,:));
            pMat(p).d=pMat(p).d./max(pMat(p).d);
            %figure;imagesc(squareform(pMat(p).d))
            sqD=squareform(pMat(p).d);
            usetr3=setdiff(1:length(usetr2),find(zscore(mean(sqD,2))>2));
            mdXY=mdscale(sqD(usetr3,usetr3),3);
            Labels=AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,8);
            getWordProp;
            grpidx=ones(length(wordProp.ed),1);
            grpidx(find(strcmp(wordProp.ed,'easy')))=2;
            %grpidx=round(cell2mat(wordProp.l))+1;
            
            AllP{p}.Tall{eidx}.Data.Artifacts.badtr=setdiff(1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100,4),usetr(usetr2(usetr3)));
            grpidx=grpidx(usetr(usetr2(usetr3)));
            %scatter3(mdXY(:,1),mdXY(:,2),mdXY(:,3),100,colormat(grpidx,:),markershape{p},'fill')
            %h=gscatter(mdXY(:,1),mdXY(:,2),grpidx(usetr(usetr2(usetr3))),colorjet([1 50],:),markershape{p},5)
            hold on          
            d=d(usetr2(usetr3),:);
            %[kgroup,centroid,sumd,dos] = kmeans(d, 2);
            %sil=silhouette(d,kgroup);
            [stats(p).savg(sidx,:),stats(p).se(sidx,:)] = grpstats(sil,kgroup,{'mean','ste'});
            
            imagesc([kgroup grpidx])
            input('m')
        end
    end
    sidx=sidx+1;
    title(usesamp)
    %input('m')
    clf
end

%%
for p=1:5
    errorarea(stats(p).savg,stats(p).se)
    hold on
end
tmp=cat(3,stats.savg)
plot(mean(tmp,3))

%%
colorcell{2}='red'
colorcell{4}='black'
colorcell{5}='blue'
colorjet=flipud(redblue)
eset=[2 5]
for p=1:length(patients)-1
    %%
    chTot=AllP{p}.Tall{eidx}.Data.channelsTot;
    allCh=zeros(1,chTot);
    figure(p)
    visualizeGrid(2,['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain3.jpg'],[]);
    hold on    
    %PLOT ELECTRODES ACTIVE ONLY DURING EVENT
    for eidx=[2 5]
        usech=reshape(AllP{p}.Tall{eidx}.Data.Params.activeCh,1,[]);
        usech=setdiff(usech,AllP{p}.Tall{setdiff(eset,eidx)}.Data.Params.activeCh);       
        d=repmat(1,1,length(usech));
        if eidx==2
            idx=round((eidx-2)*length(colorjet)/3)+1
        else
            idx=round((eidx-2)*length(colorjet)/3)-1
        end
        %visualizeGrid(5,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],usech,d,[],[],[],colorjet(idx,:),0,1);
        allCh(usech)=eidx


    end
    
    %PLOT ELECTRODES GREAT PROD
    usech=intersect(reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]),reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[]));
    usetr=AllP{p}.Tall{2}.Data.Params.usetr;
    d1=squeeze(max(squeeze(AllP{p}.Tall{2}.Data.segmentedEcog.smoothed100(usech,150:300,:,usetr)),[],2));
    usetr=AllP{p}.Tall{5}.Data.Params.usetr;
    d2=squeeze(max(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(usech,150:300,:,usetr)),[],2));
    
    [t,pval]=ttest2(d2',d1',0.05,'right','unequal');
    [ps_fdr,h_fdr]=MT_FDR_PRDS(pval,.05);
    ch1=usech(find(h_fdr));
    %visualizeGrid(5,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(1,length(ch)),[],[],[],colorjet(round(2*length(colorjet)/3),:),0,1);
    allCh(ch1)=4;
%     if ~isempty(ch)
%         [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,ch)
%     end
%      plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',i+2,rgb('dodgerblue'),.7,3)

    %PLOT ELECTRODES GREAT PERC    
    [t,pval]=ttest2(d2',d1',0.05,'left','unequal');
    [ps_fdr,h_fdr]=MT_FDR_PRDS(pval,.05);
    ch2=usech(find(h_fdr));    
    %visualizeGrid(5,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(1,length(ch)),[],[],[],colorjet(round(1*length(colorjet)/3),:),0,1);
    allCh(ch2)=3;
%     if ~isempty(ch)
%         [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,ch)
%     end
%     plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',i+2,rgb('pink'),.7,3)
        
    %EQUAL PROD AND PERC
    ch=setdiff(usech,[ch1 ch2]);
    
    %visualizeGrid(5,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(1,length(ch)),[],[],[],colorjet(round(1.5*length(colorjet)/3),:),0,1);
    % visualizeGrid(5,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],ch,ones(1,length(ch)),[],[],[],rgb('black'),0,1);
    allCh(ch)=3.5;
%     if ~isempty(ch)
%         [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,ch)
%     end
%     plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',i+2,rgb('white'),.7,3)
    set(gca,'Color','k')
    %visualizeGrid(5,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain.jpg'],1:chTot,allCh,[],[],[],[],1,1); 
    
    allCh2{p}=allCh;
    try
        figure(p)
        clf
        visualizeGrid(2,['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain3.jpg'],[]);
        colorjet=flipud(redblue)
        allChHold=allCh;
        for i=[2 3 4 5]%[.1 1  3 3.9]
            allCh=allChHold
            allCh(find(allCh~=i))=0
            allCh(find(allCh==i))=i-1.5;
            visualizeGrid(51,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],1:AllP{p}.Tall{eidx}.Data.channelsTot,allCh,5,[],[],colorjet(round((i-1.9)*length(colorjet)/4),:),0,.6);
            freezeColors
            hold on
        end

        i=3.5
        allCh=allChHold
        allCh(find(allCh~=i))=0
        visualizeGrid(51,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],1:256,allCh,5,[],[],rgb('white'),0,.9);
    end
end





%% PLOT ALL EVENTS ON ONE PLOT
colorcell{2}='r'
colorcell{4}='k'
colorcell{5}='b'
for p=7:length(patients)-1
    %%
    figure(p)    
    for eidx=[2 5 4]
        for c=1:AllP{p}.Tall{eidx}.Data.channelsTot
            plotGridPosition(c);
            if ismember(c,AllP{p}.Tall{eidx}.Data.Artifacts.badChannels)
                set(gca,'Color','k')
                continue
            end   
            usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            if eidx==5
                plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),colorcell{eidx},'LineWidth',2)
            else
                plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),colorcell{eidx},'LineWidth',2)
            end
            hold on
            if ismember(c,AllP{p}.Tall{eidx}.Data.Params.activeCh)
                scatter(1,eidx,50,colorcell{eidx},'fill')
            end
            line([200 200],[-1 5])
            axis tight      
%              if ismember(c,find(allCh2{p}~=0))
%                 resp=allCh2{p}(c)
%                 switch resp
%                     case 3
%                        set(gca,'Color',rgb('yellow'))
%                     case 2
%                         set(gca,'Color',rgb('pink'))
%                     case 3.5
%                         set(gca,'Color',rgb('gray'))
%                     case 4
%                         set(gca,'Color',rgb('lightcyan'))
%                     case 5
%                         set(gca,'Color',rgb('dodgerblue'))
%                 end
%              end      
        end
    end  
end
%%
for i=1:p
    figure(i)
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveppt2('ppt',powerpoint_object,'stretch','off','d','meta');
end
%% SET EMPTY EVENTS TO NAN
for p=1:8
    for eidx=[2 4 5]
        AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
    end
end




%% GET WORD GROUPS and PLOT BAR BLOTS for quadrants
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\brocawords')
wordGroups={'sef','sei','lef','lei','lhf','lhi'};
timeIdx=1;
calcType='max'
for p=1:8
    for eidx=[2 5]
        clear LabelsGroups
        %usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]) reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);

        usetr=setdiff(1:size(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100,4),AllP{p}.Tall{eidx}.Data.Artifacts.badTrials)        if 1%eidx==2
        if 1    
            usesamps=[201:350];
        else
            usesamps=50:350;
        end
        
        
        Labels=AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetr,8);
        wordLengthPerc=diff(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetr,[7 9])),[],2)
        wordLengthProd=diff(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetr,[13 15])),[],2)

        switch calcType
            case 'max'
                [Data,midx]=max(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),[],2);
        
            case 'mean'
                Data=squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),2));
        end
        if timeIdx==1
            Data=midx;
        end
        %Data=squeeze(prctile(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),99,2));

        for i=1:length(Labels)
            idx=find(strcmp(Labels{i},{brocawords.names}))
            if isempty(idx)
                continue;
            else
                if brocawords(idx).logfreq_HAL>8.75
                    f='f';
                else
                    f='i'
                end
                LabelsGroups{i}=strcat(brocawords(idx).lengthtype(1),brocawords(idx).difficulty(1),f);                

            end
        end
            
        for g=1:length(wordGroups)
            trNum=find(strcmp(wordGroups{g},LabelsGroups))
            wordTypeResponse(p,eidx).group(g).data=Data(:,trNum);
            wordTypeResponse(p,eidx).group(g).wordLengthPerc=wordLengthPerc(trNum)*1000;
            wordTypeResponse(p,eidx).group(g).wordLengthProd=wordLengthProd(trNum)*1000;

        end       
    end
end

% PLOT GRAND MEAN PER WG
clf
%qfGrouped={[1 2],[3 4]};

qfGrouped={1,2,3,4}
clear qmAll
for p=1:8
    clear s m 
    usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]) reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);
    m=NaN(length(usech),length(g));

    for cidx=1:length(usech)
        c=usech(cidx);
        for g=1:length(wordGroups)
            eidx=2;
            m(cidx,g,1)=mean(wordTypeResponse(p,eidx).group(g).data(c,:),2);
            %s(cidx,g,1)=ste(wordTypeResponse(p,eidx).group(g).data(c,:),2);
            
            eidx=5;
            m(cidx,g,2)=mean(wordTypeResponse(p,eidx).group(g).data(c,:),2);
            %s(cidx,g,2)=ste(wordTypeResponse(p,eidx).group(g).data(c,:),2);
        end
    end
    
    for q=1:length(qfGrouped)
        qf=qfGrouped{q};
        qmAll{q}(:,:,p)=mean(m(find(ismember(usech,find(ismember(BrainCoord(p).quad,qf)))),:,:),1);
    end
end


% PLOT WG PER QUAD 
clf
plotIdx=[2 1 3 4];
for qf=1:length(qfGrouped)
    subplot(2,2,find(plotIdx==qf))
    if timeIdx==1
        %qmAll{qf}(:,2,:)=qmAll{qf}(:,2,:)-150;
        qmAll{qf}=qmAll{qf}*10;
        ylabel('Mean Peak Time (ms)')

    else
        switch calcType
            case 'max'
                ylabel('Mean of Max of all Channels')
            case 'mean'
                ylabel('Mean of Mean of all Channels')
        end

    end
        
    
     errorbar(nanmean(qmAll{qf}(:,1,:),3),nansem(qmAll{qf}(:,1,:),3),'r')
     hold on
     errorbar(nanmean(qmAll{qf}(:,2,:),3),nansem(qmAll{qf}(:,2,:),3),'b')
    errorbar(cellfun(@nanmean,{wordTypeResponse(p,eidx).group.wordLengthPerc}),cellfun(@nansem,{wordTypeResponse(p,eidx).group.wordLengthPerc}),'Color',rgb('pink'))
     hold on
     errorbar(cellfun(@nanmean,{wordTypeResponse(p,eidx).group.wordLengthProd}),cellfun(@nansem,{wordTypeResponse(p,eidx).group.wordLengthProd}),'Color',rgb('lightblue'))

    axis tight
    %h=barwitherr(ste(mAll(:,:,:),3),mean(mAll(:,:,:),3))
    set(gca,'XTick',1:6,'XTickLabel',wordGroups)
    xlabel('Word Groups')
    
    
    if timeIdx==1
        ylabel('Mean Peak Time (ms)')
    else
        ylabel('Mean of Max of all Channels')
    end
    
    if qf==1
        legend('perc','prod','acoustic Perc','acoutistic Prod')
    end
    %input('b')
end
set(gcf,'Color','w')


%% GET WORD GROUPS and PLOT GRAND MEAN AVE WAVEFORM
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\brocawords')
wordGroups={'sef','sei','lef','lei','lhf','lhi'};
timeIdx=0;
for p=1:8
    for eidx=[2 4 5]
        clear LabelsGroups
        %usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]) reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);
        usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
        usesamps=1:400
        Labels=AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetr,8);
        %[Data,midx]=max(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),[],2);
        %Data=squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),2));
        Data=AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr);

        if timeIdx==1
            Data=midx;
        end
        %Data=squeeze(prctile(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(:,usesamps,:,usetr),99,2));

        for i=1:length(Labels)
            idx=find(strcmp(Labels{i},{brocawords.names}))
            if isempty(idx)
                continue;
            else
                if brocawords(idx).logfreq_HAL>8.75
                    f='f';
                else
                    f='i'
                end
                LabelsGroups{i}=strcat(brocawords(idx).lengthtype(1),brocawords(idx).difficulty(1),f);
            end
        end
            
        for g=1:length(wordGroups)
            trNum=find(strcmp(wordGroups{g},LabelsGroups))
            wordTypeResponse(p,eidx).group(g).data=Data(:,:,1,trNum);
        end       
    end
end
%%
% PLOT MEAN WAVEFORM
clf
colormat=jet
qfGrouped={1,2,3,4}
qfGrouped={[1 2],[3 4]}
for q=1:length(qfGrouped)
    qf=qfGrouped{q};
    for eidx=[2 4 5]
        clear dHold
        for g=1:length(wordGroups)
            for p=1:length(patients)-1
                usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]) reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);
                usech=usech(find(ismember(usech,find(ismember(BrainCoord(p).quad,qf)))));    
                e=find([2 4 5]==eidx);
                subplot(3,1,e)
                dHold(p,:,:)=squeeze(mean(mean(wordTypeResponse(p,eidx).group(g).data(usech,:,:,:),4),1));
                hold on
            end
            [hl]=plot(squeeze(nanmean(dHold,1)));

            [hl,hp]=errorarea(mean(dHold,1),nansem(dHold,1));
            set(hl,'Color',colormat(ceil(64/6*g),:,:));
            set(hp,'FaceColor',colormat(ceil(64/6*g),:,:));
            axis([0 400 -1 2])
            if g==6
                line([200 200],[-1 5])
            end
            xlabel('Time (ms)')
            ylabel('Zscore')
            set(gca,'XTick',0:100:400,'XTickLabel',-2:2)
            %legend(wordGroups)
            
        end
        %%
    end
    %%
    %
    set(gcf,'Renderer','painters','PaperPositionMode','default')

    %saveas(gcf,['E:\DelayWord\WordLengthEffects\q' int2str(qf)],'jpg')
    input('n')
    clf
end
%% PLOT WG PER CHANNEL ON BRAIN
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')
samps=[1:400];
%figure
clf
set(gcf,'Color','w')
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
eventSamp=200

for p=1:length(patients)-1
        %%
        a=imread(['E:\General Patient Info\' AllP{p}.Tall{2}.Data.patientID '\brain5.jpg']);
        %figure('Position',[0 0 size(a,2) size(a,1)])
        %screenSize=get(0,'ScreenSize')

        %figure('Position',screenSize,'Units','normalized')
        brainGridxy=[min(BrainCoord(p).xy(1,:))-80 max(BrainCoord(p).xy(1,:))+80 ...
            min(BrainCoord(p).xy(2,:))-10 max(BrainCoord(p).xy(2,:))+10];
        figure('Position',[0 0 diff(brainGridxy([1,2]))*2 diff(brainGridxy([3,4]))*2],'Units','pixels')
        opengl software
        ha=axes('Position',[0 0 1 1 ],'Units','pixels');
        %imshow(repmat(a,[1 1 3]))
        imagesc(repmat(a,[1 1 3]))
        axis(brainGridxy)
        %hold on
        %scatter(BrainCoord(p).xy(1,:),BrainCoord(p).xy(2,:),'fill','r');
        set(gca,'handlevisibility','off','visible','off')
        %ha=axes('Position',[0 0  1 1],'Units','normalize');

        activeCh=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh'])
        activeCh=AllP{p}.Tall{2}.Data.gridlayout.usechans(find(ismember(AllP{p}.Tall{2}.Data.gridlayout.usechans,activeCh)));
    for eidx=[2 5]       
        for c=activeCh
            AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
            pos(1)=(BrainCoord(p).xy(1,c)-brainGridxy(1))/diff(brainGridxy([1,2]));
            pos(2)=(BrainCoord(p).xy(2,c)-brainGridxy(3))/diff(brainGridxy([3,4]));
            pos(3)=.06;
            pos(4)=.03;
            axes('Position',[pos(1) 1-pos(2) pos(3) pos(4)])
            gGrouped={[3 4],[5 6],[1 2]}

            for gidx=1:length(gGrouped);
                g=gGrouped{gidx};
                dHold=cat(4,wordTypeResponse(p,eidx).group(g).data);
                hold on
                [hl,hp]=errorarea(mean(dHold(c,:,:,:),4),nansem(dHold(c,:,:,:),4));
                set(hl,'Color',colorcell{gidx});
                set(hp,'FaceColor',colorcell{gidx});
                axis([0 400 -1 2])
                set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[]);
                line([eventSamp eventSamp],[-2 5])
                if 1%eidx==2
                    colormap(redblackwhite)
                    text(0,5,int2str(c),'FontSize',7,'Color','k')
                else
                    colormap(blueblackwhite)
                end
                axis tight
                freezeColors
                
                %gHoldm(g)=mean(max(dHold,[],2));
                %gHolds(g)=nansem(max(dHold,[],2));

            end
%             if eidx==2
%                 errorbar(gHoldm,gHolds,'r')
%                 hold on
%                 text(1,max(gHoldm),int2str(c),'FontSize',7,'Color','k')
%             else
%                 errorbar(gHoldm,gHolds,'b')
%             end

            %barwitherr(gHolds,gHoldm);
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[]);
            axis([1 5 0 2])
            axis tight

            %plot(gHoldm)
        end
       %input('b')
        set(gcf,'Renderer','painters','PaperPositionMode','default')
        filename=['E:\DelayWord\WordLengthEffects\WG_Wave' int2str(p) '_e' int2str(eidx) '.pdf']
        eval(['export_fig ' filename ' -painters'])
        clf
    end    
end




%%
% PLOT WORDGROUP WAVEFORM PER CHANNEL
clf
colormat=jet
figure
set(gcf,'Color','w')
for eidx=[2 4 5]
    close all
    clear dHold
    for p=1:length(patients)-1
        for g=1:6
            usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]) reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);
            for c=usech
                cidx=find(AllP{p}.Tall{2}.Data.gridlayout.usechans==c);
                [h,pos]=plotGridPosition2(cidx);
                subplot('Position',pos)
                dHold(p,:,:)=squeeze(mean(mean(wordTypeResponse(p,eidx).group(g).data(c,:,:,:),4),1));
%                 [hl,hp]=errorarea(squeeze(mean(mean(wordTypeResponse(p,eidx).group(g).data,4),1)),squeeze(mean(nansem(wordTypeResponse(p,eidx).group(g).data,4),1)))
%                 set(hl,'Color',colormat(ceil(64/6*g),:,:));
%                 set(hp,'FaceColor',colormat(ceil(64/6*g),:,:));
                hold on
                [hl,hp]=errorarea(nanmean(dHold,1),nansem(dHold,1));
                set(hl,'Color',colormat(ceil(64/6*g),:,:));
                set(hp,'FaceColor',colormat(ceil(64/6*g),:,:));
                axis([0 400 -1 5])
                set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[]);
                text(5,5,int2str(c),'Background','w','FontSize',7)
            end
        end
        input('nn')
        clf
    end
end
    

%%
eidx=2
colorjet=jet
for p=1:6
    %figure(p);
    usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
    usesamps=200:300;
    usech=unique([reshape(AllP{p}.Tall{2}.Data.Params.activeCh,1,[]) reshape(AllP{p}.Tall{5}.Data.Params.activeCh,1,[])]);
    %tmp=cellfun(@(x) mean(x,2),{wordTypeResponse(p,eidx).group.data},'UniformOutput',0)
    d=[wordTypeResponse(p,eidx).group.data];
    s=cellfun(@(x) size(x,2),{wordTypeResponse(p,eidx).group.data},'UniformOutput',0)
    wordGrp=[];
    for i=1:6
        wordGrp=[wordGrp ones(1,s{i})*i];
    end
    [R,pval]=corr(d',wordGrp');
    usech=usech(pval(usech)<.05 & R(usech)>.4);
    %visualizeGrid(1,['E:\General Patient Info\' AllP{p}.Tall{5}.Data.patientID '\brain.jpg'],usech,R(usech));  
    try
    [devSF,devCS,gridDist]=getDevLandmarks(BrainCoord,p,usech)
    idx=1
     plotManyPolygons([(devCS./gridDist)*64;(devSF./gridDist)*64]',p+2,colorjet(idx,:),.7,1)
    end
    hold on
    axis tight
    input('n')
end
%% FORM CLUSTER VARIABLES
allD.data=[];
allD.p=[];
allD.ch=[];
clear d
for p=1:8
    ch=1:AllP{p}.Tall{2}.Data.channelsTot;
    %ch=unique([AllP{p}.Tall{2}.Data.Params.activeCh ;AllP{p}.Tall{4}.Data.Params.activeCh ;AllP{p}.Tall{5}.Data.Params.activeCh]);
    for eidx=[2 4 5]
        d{eidx}=mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(ch,1:400,:,:),4);
    end
    dcat=horzcat(d{2},d{4},d{5});
    allD.data=vertcat(allD.data,dcat);
    allD.p=vertcat(allD.p,repmat(p,size(dcat,1),1));
    allD.ch=vertcat(allD.ch,ch');
end
%% CLUSTER
knum=10
idx=find(allD.p==5);
[kgroup,centroid1]=kmeans(allD.data(idx,[1:400 401:650 901:1100]),knum,'Distance','correlation','EmptyAction','drop','Replicates',10);
figure
silhouette(allD.data(idx,:),kgroup,'correlation')

%% CLUSTER
knum=30
[kgroup,centroid]=kmeans(allD.data(:,[1:400 401:700 901:1100]),knum,'Distance','correlation','EmptyAction','drop','Replicates',20);
figure
silhouette(allD.data,kgroup,'correlation')
allD.kgroup=kgroup;


%% RECLUSTER BASED ON CENTROIDS


knum=length(kGroups(:,1))
[kgroup2,centroid2]=kmeans(allD.data(:,[1:400 401:700 901:1100]),knum,'Distance','correlation','EmptyAction','drop','start',...
    centroid(kGroups(:,1),:));
figure
silhouette(allD.data,kgroup,'correlation')
allD.kgroup=kgroup2;

%%
figure
clf
eidx=2
knum=10
for k=1:knum,
    %%
    pos=subplotMinGray(9,knum+1,1,k-1);
    subplot('Position',pos)
    idx=find(kgroup==k);
    plot(reshape(mean(allD.data(idx,:)),400,3));
    axis([1 400 -1 8])
    pCur=unique(allD.p(idx,:))';
    for p=pCur
         chCur=allD.ch(idx);
         ch=chCur(find(allD.p(idx)==p));
         pos=subplotMinGray(9,knum+1,p+1,k-1);
         subplot('Position',pos)
         visualizeGrid(0,[brainPath patients{p} '\brain3.jpg'],ch);
    end
end
%%
knum=10
%clear dHold
for k=1:knum
    %%
    figure(1)
    clf
    idx=find(allD.kgroup==k);   
    pCur=unique(allD.p(idx,:))';
    for p=pCur
         chCur=allD.ch(idx);
         ch=chCur(find(allD.p(idx)==p));
         q=getBrainQuadrant(BrainCoord(p).xySF,BrainCoord(p).xyCS,BrainCoord(p).xy(:,ch))
         for qIdx=1:4
             pos=subplotMinGray(9,4,p+1,qIdx-1);
             subplot('Position',pos)
             try
                visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],ch(find(q==qIdx)));
             catch
                visualizeGrid(0,['D:\Angela\General Patient Info\' patients{p} '\brain3.jpg'],ch(find(q==qIdx)));
             end
                dHold{k,p,qIdx}=nanmean(allD.data(idx(find(q==qIdx)),:),1);
         end
    end
    
    
    for qIdx=1:4
         pos=subplotMinGray(9,4,1,qIdx-1);
         subplot('Position',pos)
         plot(vertcat(dHold{k,:,qIdx})')
         axis([0 1200 -1 8])
    end
    
    figure(2)
    clf
     for qIdx=1:4
        %plot(nanmean(vertcat(dHold{k,:,qIdx})))
        [hl,hp]=errorarea(nanmean(vertcat(dHold{k,:,qIdx})),...
            nanstd(vertcat(dHold{k,:,qIdx}))./length(find(~isnan(mean(vertcat(dHold{k,:,qIdx}),2)))));
        set(hl,'Color',colorcell{qIdx});
        set(hp,'FaceColor',colorcell{qIdx});
        hold on
     end
    
    input('n')
    clf
end
%%
colorcell={'r','k','b','g'}
for k=1:knum
    for qIdx=1:4
        subplot(3,2,qIdx)
        plot(vertcat(dHold{k,:,qIdx})')
        axis([0 1200 -1 8])

        subplot(3,2,5)
        plot(mean(vertcat(dHold{k,:,qIdx})),colorcell{qIdx})
        hold on
        axis([0 1200 -1 8])
    end
    
    input('n')
    clf
end
    


%%
%figure
clf
set(gcf,'Color','w')
for k=1:knum,
    idx=find(kgroup==k);
    pCur=allD.p(idx,:);
    chCur=allD.ch(idx);
    for i=1:length(idx)
        c=i
        p=pCur(i);
        plotCh{p}(c)=chCur(i);
        for eidx=[2 4 5]
            e=find([2 4 5]==eidx);
            usetrials=AllP{p}.Tall{eidx}.Data.Params.usetr;
            r=rem(i,13);
            if r==0
                r=13;
            end
            
            pos=subplotMinGray(13,4,r,0);
            subplot('Position',pos);
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3),...
                ste(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3));
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest)+eventSamp,-2+(.3*e),'.','Color',colorcell{e},'MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color','k','LineStyle','--')

            axis tight
            text(50,4,int2str(plotCh{p}(c)))
            set(gca,'Visible','off')

            pos=subplotMinGray(13,4,r,e);
            ca=subplot('Position',pos);
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials))',[0 5]);
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle','--')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+res*100,1:length(usetrials),'k')   
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])


            pos=subplotMinGray(13,4,r,4);
            subplot('Position',pos)        
            visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],plotCh{p}(c));
            freezeColors
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            text(50,4,int2str(p))

        end
        
        if r==13 | i==length(idx)
            colormap(redblackwhite)
            input('n')
            clf
        end
    end
end
%%
figure
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
clf
set(gcf,'Color','w')
samps=100:300;
colorcell={'r','k','b'}
eventSamp=100
col={[],[7 9],[],[11 13],[13 15]}
for c=1:length(plotCh{5})
    p=5
    keyboard
    idx=find(allD.ch==plotCh{5}(c) & allD.p==5);
    knum=kgroup(idx);
    for eidx=[2 4 5]
            e=find([2 4 5]==eidx);
            [a,b]=find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,1:15)));
            usetrials=setdiff(AllP{p}.Tall{eidx}.Data.Params.usetr,unique(a));
            r=knum;
            pos=subplotMinGray(10,5,r,0);
            subplot('Position',pos);
            if eidx==2
                cla
            end
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3),...
                ste(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3));
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest)+eventSamp,-2+(.3*e),'.','Color',colorcell{e},'MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color','k','LineStyle','--')

            axis tight
            text(50,4,int2str(plotCh{p}(c)))
            set(gca,'Visible','off')

            pos=subplotMinGray(10,5,r,e);
            ca=subplot('Position',pos);cla
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials))',[0 5]);
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle','--')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+res*100,1:length(usetrials),'k')   
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])


            pos=subplotMinGray(10,5,r,4);
            subplot('Position',pos);cla        
            visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],plotCh{p}(c));
            freezeColors
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            text(50,4,int2str(p))

    end
end
        colormap(redblackwhite)

%%
%figure
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
clf
set(gcf,'Color','w')
samps=100:300;
colorcell={'r','k','b'}
eventSamp=100
col={[],[7 9],[],[11 13],[13 15]}
knum=10
for k=8:knum,
    idx=find(kgroup==k);
    pCur=allD.p(idx,:);
    chCur=allD.ch(idx);
    i=1;
    %%
    while i<=length(idx)
        c=i
        p=pCur(i);
        plotCh{p}(c)=chCur(i);
        for eidx=[2 4 5]
            e=find([2 4 5]==eidx);
            [a,b]=find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,1:15)));
            usetrials=setdiff(AllP{p}.Tall{eidx}.Data.Params.usetr,unique(a));
            r=p;
            pos=subplotMinGray(8,5,r,0);
            subplot('Position',pos);
            if eidx==2
                cla
            end
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3),...
                ste(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3));
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest)+eventSamp,-2+(.3*e),'.','Color',colorcell{e},'MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color','k','LineStyle','--')

            axis tight
            text(50,4,int2str(plotCh{p}(c)))
            set(gca,'Visible','off')

            pos=subplotMinGray(8,5,r,e);
            ca=subplot('Position',pos);cla
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials))',[0 5]);
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle','--')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+res*100,1:length(usetrials),'k')   
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])


            pos=subplotMinGray(8,5,r,4);
            subplot('Position',pos);cla        
            visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],plotCh{p}(c));
            freezeColors
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            text(50,4,int2str(p))

        end
        colormap(redblackwhite)

        resp=input('n','s');
        if strcmp(resp,'y')
           keep(p,k)=chCur(i);
           i=find(pCur==p+1,1,'first');
        elseif strcmp(resp,'b')
            i=i-1;
        else
            i=i+1;
            try
                if pCur(i)~=p 
                     i=find(pCur==p,1,'first');
                end
            catch
                 i=find(pCur==p,1,'first');
            end
        end
    end
    clf
end
%%
clf
c=1
samps=1:400
eventSamp=200
colorcell={'r','r'}
for k=[1:4 6 8]
    clf
    for p=1:8
        plotCh{p}(1)=keep(p,k);
        for eidx=[2 5]
            e=find([2 5]==eidx);
            [a,b]=find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,1:15)));
            usetrials=setdiff(AllP{p}.Tall{eidx}.Data.Params.usetr,unique(a));
            r=p;
            pos=subplotMinGray(8,7,r,e-1);
            subplot('Position',pos);
            if eidx==2
                cla
            end
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3),...
                ste(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3));
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest)+eventSamp,-2+(.3*e),'.','Color',colorcell{e},'MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color','k','LineStyle','--')

            axis tight
            %text(50,4,int2str(plotCh{p}(c)))
            set(gca,'Visible','off')

            pos=subplotMinGray(8,7,r,e+1);
            ca=subplot('Position',pos);cla
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials))',[0 5]);
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle','--')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+res*100,1:length(usetrials),'k')   
            
            if eidx==5
                res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)-2))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)-2));
                hold on
                plot(eventSamp-res*100,1:length(usetrials),'k') 
            end            
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])


            
            pos=subplotMinGray(8,7,r,4);
            subplot('Position',pos);cla        
            visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],plotCh{p}(c));
            freezeColors
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            %text(50,4,int2str(p))

        end
        colormap(redblackwhite)
    end
    input('n')
end
%%
clf
c=1
samps=1:400
eventSamp=200
colorcell={'r','r'}
for k=[1:4 6 8]
    %clf
    for p=5
        plotCh{p}(1)=keep(p,k);
        for eidx=[2 5]
            e=find([2 5]==eidx);
            [a,b]=find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,1:15)));
            usetrials=setdiff(AllP{p}.Tall{eidx}.Data.Params.usetr,unique(a));
            r=find([1:4 6 8]==k);
            pos=subplotMinGray(8,7,r,e-1);
            subplot('Position',pos);
            if eidx==2
                cla
            end
            [hl,hp]=errorarea(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3),...
                ste(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials),3));
            %hl=plot(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{5}(c),:,usetrials),3));
            set(hl,'Color',colorcell{e});
            set(hp,'FaceColor',colorcell{e});

            hold on
            if ~isempty(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest))
                plot(find(AllP{p}.E{eidx}.electrodes(plotCh{p}(c)).TTest)+eventSamp,-2+(.3*e),'.','Color',colorcell{e},'MarkerSize',.5)
            end
            hl=line([eventSamp eventSamp],[-2 5]);
            set(hl,'Color','k','LineStyle','--')

            axis tight
            %text(50,4,int2str(plotCh{p}(c)))
            set(gca,'Visible','off')

            pos=subplotMinGray(8,7,r,e+1);
            ca=subplot('Position',pos);cla
            [s,sidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,9))- cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog(1).event(usetrials,7)));
            usetrials=usetrials(sidx);
            imagesc(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(plotCh{p}(c),samps,usetrials))',[0 5]);
            hl=line([eventSamp eventSamp],[1 length(usetrials)]);
            set(hl,'Color','k','LineStyle','--')
            res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)));
            hold on
            plot(eventSamp+res*100,1:length(usetrials),'k')   
            
            if eidx==5
                res=cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(2)-2))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(usetrials,col{eidx}(1)-2));
                hold on
                plot(eventSamp-res*100,1:length(usetrials),'k') 
            end            
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])


            
            pos=subplotMinGray(8,7,r,4);
            subplot('Position',pos);cla        
            visualizeGrid(0,['E:\General Patient Info\' AllP{p}.Tall{eidx}.Data.patientID '\brain3.jpg'],plotCh{p}(c));
            freezeColors
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            %text(50,4,int2str(p))

        end
        colormap(redblackwhite)
    end
    input('n')
end
%% PLOT PASSIVE VS ACTIVE
%% PLOT STACKED PRESENTATION AND PRODUCTION IN GRID FORM
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\redblackwhite')
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\Basic\blueblackwhite')

%figure
clf
set(gcf,'Color','w')
col{2}=[7 9]
col{4}=[11 13]
col{5}=[13 15]
eventSamp=200
for p=[1 6]
    %%
    activeCh=unique([AllP{p}.Tall{2}.Data.Params.activeCh' AllP{p}.Tall{5}.Data.Params.activeCh'])
    activeCh=AllP{p}.Tall{2}.Data.gridlayout.usechans(find(ismember(AllP{p}.Tall{2}.Data.gridlayout.usechans,activeCh)));
    clf
    for eidx=[2 4]
        AllP{p}.Tall{eidx}.Data.segmentedEcog.event(find(cellfun(@isempty,AllP{p}.Tall{eidx}.Data.segmentedEcog.event)))={NaN}
        for c=activeCh
            cidx=find(AllP{p}.Tall{2}.Data.gridlayout.usechans==c);
            [h,pos]=plotGridPosition2(cidx);
            if eidx==2
               subplot('Position',[pos(1) pos(2)+pos(4)/2 pos(3) pos(4)/2])
            else
               subplot('Position',[pos(1) pos(2) pos(3) pos(4)/2])
            end
            [~,sortidx]=sort(cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,9))-cell2mat(AllP{p}.Tall{eidx}.Data.segmentedEcog.event(:,7)));
            usetr=AllP{p}.Tall{eidx}.Data.Params.usetr;
            usetr=sortidx(find(ismember(sortidx,usetr)));
            %        plot(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100Hold(c,:,:,usetr),4),'r','LineWidth',2)
            %        plot(nanmean(AllP{p}.Tall{4}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),'Color',rgb('green'),'LineWidth',2)

            errorarea(mean(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr))',1),ste(squeeze(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr))',1))
            hold on
            usetr=AllP_P{p}.Tall{eidx}.Data.Params.usetr;
            [hl,hp]=errorarea(mean(squeeze(AllP_P{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr))',1),...
                ste(squeeze(AllP_P{p}.Tall{eidx}.Data.segmentedEcog.smoothed100(c,:,:,usetr))',1));

            if eidx==2
                set(hp,'FaceColor','r')
                set(hl,'Color','r')
            else
                set(hp,'FaceColor','g')
                set(hl,'Color','g')
            end

            axis([0 400 -.5 7])            
            hl=line([eventSamp eventSamp],[-1 10]);
            set(hl,'Color','k','LineStyle',':')
                     
            set(gca,'Visible','off','XTickLabel',[],'YTickLabel',[])
            
            if eidx==2
                text(5,5,int2str(c),'Background','w','FontSize',7)
            end
           % plot(squeeze(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr)))%
            %[hl,hp]=errorarea(nanmean(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr),4),sqrt(nanstd(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,:,:,usetr),[],4)./length(~isnan(AllP{p}.Tall{5}.Data.segmentedEcog.smoothed100(c,1,1,usetr)))))
            %set(hl,'LineWidth',2)
            %line([200 200],[-2 5])
            if eidx==2
                colormap(redblackwhite)
            else
                colormap(blueblackwhite)
            end
            freezeColors     
        end
    end
    input('n')
end
%% CLUSTER AVE
alld=[]
for p=1:8
    for eidx=[2 4 5]
        tmp{eidx}=squeeze(mean(AllP{p}.Tall{eidx}.Data.segmentedEcog.smoothed100,4));
    end
    d=cat(2,tmp{:});
    alld=vertcat(alld,d);
end
