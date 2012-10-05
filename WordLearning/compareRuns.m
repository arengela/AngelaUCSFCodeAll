%powerpoint_object=SAVEPPT2('test.ppt','init')
load('E:\PreprocessedFiles\EC26\runtrials')
load('E:\PreprocessedFiles\EC26\EC26_B6\Analog\allConditions.mat')
load('E:\PreprocessedFiles\EC26\learnedwords.mat')
load('E:\PreprocessedFiles\EC26\missedwords.mat')
%%
for run=1:8%[4:6 8:13]
    clear T
        T=PLVtests(runtrials(3,run),find(ismember(allConditions,words))',1:256,'aa40');
        T.Data.BaselineChoice='PreEvent';
        T.Data.calcZscore_onechan;
        T.Data.segmentedEcog.data=[];
        %%
        specAll.real=NaN(256,1600,40);
        specAll.pseudo=NaN(256,1600,40);
        indices=T.Data.findTrials('4','n','n');
        usechans=T.Data.usechans;
        for c=1:256
            epos = find(T.Data.gridlayout.usechans == usechans(c));
            if isempty(epos)
                continue
            end
            specAll.real(epos,:,:)=mean(T.Data.segmentedEcog.zscore_separate(c,:,:,indices.cond1),4);
            specAll.pseudo(epos,:,:)=mean(T.Data.segmentedEcog.zscore_separate(c,:,:,indices.cond2),4);
        end
        save(['E:\PreprocessedFiles\EC26\specAll_learned_' int2str(run)],'specAll','-v7.3');
     
end
%% Look only at learned pseudowords and matches
 keep=find(ismember(T.Data.segmentedEcog.event(:,2),words))
T.Data.segmentedEcog(1).zscore_separate=T.Data.segmentedEcog(1).zscore_separate(:,:,:,keep);
T.Data.segmentedEcog(1).event=T.Data.segmentedEcog(1).event(keep,:);


%%
for n=1:8
    load(['E:\PreprocessedFiles\EC26\specAll_learned_' int2str(n)])
    specAll2(n).learned=specAll;
end
%% load not learned trials
for n=1:8
    load(['E:\PreprocessedFiles\EC26\specAll_notlearned_' int2str(n)])
    specAll2(n).notlearned=specAll;
end
%%
load('E:\PreprocessedFiles\EC26\EC26_B6\gridlayout')
usechans=reshape(gridlayout',[1 256]);
figure
for epos=1:256
    if usechans(epos)==0
        continue;
    end
    for run=1:12
        tmp1(run,:)=nanmean(specAll2(run).real(epos,800:end,:,1),2);
        tmp2(run,:)=nanmean(specAll2(run).pseudo(epos,800:end,:,1),2);
        figure(run)
        h=plotGridPosition(epos);
        imagesc(flipud(squeeze(specAll2(run).real(epos,:,:))'),[-3 3])
        
        
        
        
        
        figure(run+12)
        h=plotGridPosition(epos);
        imagesc(flipud(squeeze(specAll2(run).pseudo(epos,:,:))'),[-3 3])

    end
%     tmp=tmp1-tmp2;
%     h=plotGridPosition(epos);
% %     figure(1)
% %     imagesc(flipud(squeeze(specAll2(run).real(epos,:,:))'))
% %     
% %     h=plotGridPosition(epos);
% %     figure(2)
% %     imagesc(flipud(squeeze(specAll2(run).pseudo(epos,:,:))'))
% % 
% %     h=plotGridPosition(epos);
% %     figure(3)
% %     imagesc(flipud(squeeze(specAll2(run).pseudo(epos,:,:))')-flipud(squeeze(specAll2(run).real(epos,:,:))'))
%         figure(10)
%              h=plotGridPosition(epos);
% 
%         imagesc(flipud(tmp1'),[-2 2])
%         figure(11)
%         h=plotGridPosition(epos);
% 
%         imagesc(flipud(tmp2'),[-2 2])

end
    
%% Copy to ppt
for run=2:12
    figure(run)
    try
        T.Data.resetCLimPlot;
    end
    set(gcf,'Position',[1,1,2000,1000])
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');    
    figure(run+12)  
    try
        T.Data.resetCLimPlot;
    end
    set(gcf,'Position',[1,1,2000,1000])
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
    
end
%% plot freq ranges over runs

load('E:\DelayWord\frequencybands');
load('E:\PreprocessedFiles\EC26\EC26_B6\gridlayout')
usechans=reshape(gridlayout',[1 256]);
figure
colors=jet
L= length(colors)/4;
for epos=1:256
    if usechans(epos)==0
        continue;
    end
    for run=1:8
        meanAmp{1}(run,:)=nanmean(specAll2(run).real(epos,800:end,:,1),2);
        meanAmp{2}(run,:)=nanmean(specAll2(run).pseudo(epos,800:end,:,1),2);      
    end
    for type=1:2
        figure(type)
        h=plotGridPosition(epos);
        plot(nanmean( meanAmp{type}(:,frequencybands.theta),2),'Color',colors(1,:),'LineWidth',2)
        hold on
        plot(nanmean(meanAmp{type}(:,frequencybands.alpha),2),'Color',colors(L,:),'LineWidth',2)
        plot(nanmean(meanAmp{type}(:,frequencybands.beta),2),'Color',colors(L*2,:),'LineWidth',2)
        plot(nanmean(meanAmp{type}(:,frequencybands.gamma),2),'Color',colors(L*3,:),'LineWidth',2)
        plot(nanmean(meanAmp{type}(:,frequencybands.hg),2),'Color',colors(L*4,:),'LineWidth',2)
    end
end
%%
%% plot freq ranges over runs
load('E:\DelayWord\frequencybands');
load('E:\PreprocessedFiles\EC26\EC26_B6\gridlayout')
usechans=reshape(gridlayout',[1 256]);
figure
colors=jet
L= length(colors)/4;

for epos=1:256
    if usechans(epos)==0
        continue;
    end
    for run=1:8
%         ave.learned.pseudo(run)=mean(mean(specAll2(run).learned.pseudo(epos,800:end,frequencybands.theta),[],2),3);
%         ave.notlearned.pseudo(run)=mean(mean(specAll2(run).notlearned.pseudo(epos,800:end,frequencybands.theta),[],2),3);       
%         ave.learned.real(run)=mean(mean(specAll2(run).learned.real(epos,800:end,frequencybands.theta),[],2),3);
%         ave.notlearned.real(run)=mean(mean(specAll2(run).notlearned.real(epos,800:end,frequencybands.theta),[],2),3);     
    
        ave.learned.pseudo(run)=mean(mean(specAll2(run).learned.pseudo(epos,800:1200,frequencybands.theta),2),3);
        ave.notlearned.pseudo(run)=mean(mean(specAll2(run).notlearned.pseudo(epos,800:1200,frequencybands.theta),2),3);       
        ave.learned.real(run)=mean(mean(specAll2(run).learned.real(epos,800:1200,frequencybands.theta),2),3);
        ave.notlearned.real(run)=mean(mean(specAll2(run).notlearned.real(epos,800:1200,frequencybands.theta),2),3);  
    end
        h=plotGridPosition(epos);     
        plot(ave.learned.real,'b','LineWidth',1)
        hold on
        plot(ave.notlearned.real,'g','LineWidth',1)        
        plot(ave.notlearned.pseudo,'r','LineWidth',2)
        plot(ave.learned.pseudo,'k','LineWidth',2)
        axis([1 8 -5 7])
end
addLabels(gcf)
%% fit line
figure
for epos=1:256
    if usechans(epos)==0
        continue;
    end
    
     for run=1:8
%         ave.learned.pseudo(run)=mean(mean(specAll2(run).learned.pseudo(epos,800:end,frequencybands.theta),[],2),3);
%         ave.notlearned.pseudo(run)=mean(mean(specAll2(run).notlearned.pseudo(epos,800:end,frequencybands.theta),[],2),3);       
%         ave.learned.real(run)=mean(mean(specAll2(run).learned.real(epos,800:end,frequencybands.theta),[],2),3);
%         ave.notlearned.real(run)=mean(mean(specAll2(run).notlearned.real(epos,800:end,frequencybands.theta),[],2),3);     
    
        ave.learned.pseudo(run)=mean(mean(specAll2(run).learned.pseudo(epos,800:1200,frequencybands.theta),2),3);
        ave.notlearned.pseudo(run)=mean(mean(specAll2(run).notlearned.pseudo(epos,800:1200,frequencybands.theta),2),3);       
        ave.learned.real(run)=mean(mean(specAll2(run).learned.real(epos,800:1200,frequencybands.theta),2),3);
        ave.notlearned.real(run)=mean(mean(specAll2(run).notlearned.real(epos,800:1200,frequencybands.theta),2),3);  
    end
    y1=ave.learned.real;
    [p,S]=polyfit(1:8,y1,1);
    [y,e]=polyval(p,1:8,S);
    M(2)=p(1);
    E(2)=mean(e);
    
    y1=ave.notlearned.real;
    [p,S]=polyfit(1:8,y1,1);
    [y,e]=polyval(p,1:8,S);
    M(1)=p(1);
    E(1)=mean(e); 
    
    y1=ave.learned.pseudo;
    [p,S]=polyfit(1:8,y1,1);
    [y,e]=polyval(p,1:8,S);
    M(4)=p(1);
    E(4)=mean(e);          
    
    y1=ave.notlearned.pseudo;
    [p,S]=polyfit(1:8,y1,1);
    [y,e]=polyval(p,1:8,S);
    M(3)=p(1);
    E(3)=mean(e);
    h=plotGridPosition(epos);
    barwitherr(M,E);
end
    addLabels(gcf)

%% plot real and pseudo per run for 1 chan
for idx=1:length(x)
    epos=x(idx)    
    %%
    epos=227
    for i=1:8
        subplot(5,8,i)
        imagesc(flipud(squeeze(specAll2(i).real(epos,:,:))'),[-3 3])
        
        line([800 800],[0 40])
        subplot(5,8,i+8)
        imagesc(flipud(squeeze(specAll2(i).pseudo(epos,:,:))'),[-3 3])
        line([800 800],[0 40])
        
        subplot(5,8,i+16)
        bar(mean(max(specAll2(i).real(epos,800:end,frequencybands.theta),[],2),3))     
        axis([0 2 -5 5])
        subplot(5,8,i+24)
        bar(mean(max(specAll2(i).pseudo(epos,800:end,frequencybands.theta),[],2),3))
        axis([0 2 -5 5])
        subplot(5,8,i+32)
%         bar(mean(max(specAll2(i).real(epos,800:end,frequencybands.theta),[],2),3)...
%             -mean(max(specAll2(i).pseudo(epos,800:end,frequencybands.theta),[],2),3))
        bar(mean(max(specAll2(i).real(epos,800:end,frequencybands.theta),[],2),3)...
            -mean(max(specAll2(i).pseudo(epos,800:end,frequencybands.theta),[],2),3))
        axis([0 2 -5 5])

        
        if i==1
            title(int2str(epos))
        end
    end
    %%
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
end
%%
for idx=1:length(x)
    epos=x(idx)    
    %%
    epos=130
    for i=1:8
        subplot(3,8,i)
        bar(mean(mean(specAll2(i).real(epos,800:end,frequencybands.theta),2),3))     
        axis([0 2 -5 5])
        subplot(3,8,i+8)
        bar(mean(mean(specAll2(i).pseudo(epos,800:end,frequencybands.theta),2),3))
        axis([0 2 -5 5])
        subplot(3,8,i+16)
%         bar(mean(max(specAll2(i).real(epos,800:end,frequencybands.theta),[],2),3)...
%             -mean(max(specAll2(i).pseudo(epos,800:end,frequencybands.theta),[],2),3))
%         bar(mean(mean(specAll2(i).real(epos,800:end,frequencybands.theta),2),3)...
%             -mean(mean(specAll2(i).pseudo(epos,800:end,frequencybands.theta),2),3))
        ave.learned(i)=mean(mean(specAll2(i).learned.real(epos,800:end,frequencybands.theta),2),3);
        ave.notlearned(i)=mean(mean(specAll2(i).notlearned.real(epos,800:end,frequencybands.theta),2),3);
        axis([0 2 -3 3])
        if i==1
            title(int2str(epos))
        end
    end
    %%
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
end
%% Load all HG
load('E:\PreprocessedFiles\EC26\runtrials')
for n=[1:6 8:13]
    clear D
    try
        %D=PLVtests_HG(runtrials(3,n),1,1:256);
        %eval(['D' int2str(runtrials(1,n)) '=D']);     
        %eval(['D' int2str(runtrials(1,n)) '.Data.segmentedEcog.data=[]']);  
        save(['D' int2str(runtrials(1,n))],['D' int2str(runtrials(1,n))],'-v7.3')
     end
end

%% Plot all HG

for n=1:13
    try
         eval(['D=D' int2str(runtrials(1,n))]);
         D.Data.plotData('line');
         set(gcf,'Name',int2str(n))
         D.Data.resetCLimPlot;
         set(gcf,'Position',[0 0 1200 700])
         saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        close all
    end
end
    
%%
mP=NaN(256,1600,13);
mR=NaN(256,1600,13);
%%
mInc=NaN(256,1600,13);
mCor=NaN(256,1600,13);
%%
figure
for run=[1:13]
    set(gcf,'Name',int2str(run))
    colorset=jet;
    curcolor=colorset(round(run*64/13),:);
    try
        %%
        handles=eval(['D' int2str(run) '.Data']);
        gridlayout=handles.gridlayout.usechans;
        usechans=reshape(gridlayout',[1 size(gridlayout,1)*size(gridlayout,2)]);
        [indices]=handles.findTrials('4','n','n');
        eventSamp=800;        
        for i=1:256  
            if usechans(i)==0
                continue;
            end
                epos=find(handles.gridlayout.usechans==usechans(i));
                h=plotGridPosition(epos);
                u=find(handles.usechans==usechans(i));               
               
                %trial=strcmp('jatoremee',handles.segmentedEcog.event{2});
                %wdata(epos,:,run)=mean(handles.segmentedEcog.zscore_separate(epos,:,:,trial),3);
                
                %PLOT INCORRECT VS CORRECT TRIALS GRAND AVE
                mCor(epos,:,run)=mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond1),3),4);
                mInc(epos,:,run)=mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),3),4);
%                 
%                  [hl,hp]=errorarea(squeeze(nanmean(mCor(epos,1:end,1:end),3)),squeeze(ste(mInc(epos,1:end,1:end),3)));
%                  hold on
%                  [hl,hp]=errorarea(squeeze(nanmean(mInc(epos,1:end,1:end),3)),squeeze(ste(mCor(epos,1:end,1:end),3)));
%                  set(hl,'Color','r')
%                  set(hp,'FaceColor','r')


%                 meanCor=squeeze(mean(mean(mCor(epos,800:1200,:,:),4),2));
%                 meanInc=squeeze(mean(mean(mInc(epos,800:1200,:,:),4),2));
%                 plot(meanCor)
%                 hold on
%                 plot(meanInc,'r')

%                 h=bar((meanInc-meanCor)');
%                 s=sign(meanInc-meanCor)';
%                 ch=get(h,'children');
%                 set(ch,'FaceVertexCData',(s)');
%                 caxis([-1 1]);
                %                 
                
                %PLOT REAL VS PSEUDO TRIALS GRAND AVE               
                
                %mR(epos,:,run)=mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond1),3),4);
                %mP(epos,:,run)=mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),3),4);

%                 [hl,hp]=errorarea(squeeze(nanmean(mR(epos,1:end,:),3)),squeeze(ste(mInc(epos,1:end,find(~isnan(mR(1,1,:)))),3)));
%                 hold on
%                 [hl,hp]=errorarea(squeeze(nanmean(mP(epos,1:end,:),3)),squeeze(ste(mCor(epos,1:end,find(~isnan(mP(1,1,:)))),3)));
%                 set(hl,'Color','r')
%                 set(hp,'FaceColor','r')
                 
%                 plot(mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),3),4),'Color',curcolor)
%                  [hl,hp]=errorarea(mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond1),3),4),...
%                       ste(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond1),3),4));
%                  
%                 set(hl,'Color',curcolor)
%                     set(hp,'FaceColor',curcolor)  
%              
                Data(epos,:,run)=mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond1),3),4);
                
               %imagesc(flipud(squeeze(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),4))'),[-1.2 3]) 
               %imagesc(flipud(squeeze(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond1),4))')-flipud(squeeze(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),4))'),[-1 1])
               hold on
                try
                    %imagesc(flipud(squeeze(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),4))'),[-1.2 3])
%                      [hl,hp]=errorarea(mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),3),4),...
%                         ste(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),3),4));      
%                      set(hl,'Color',curcolor)
%                      set(hp,'FaceColor',curcolor)                    
%                      hold on

                end               

                hl=line([eventSamp,eventSamp],[0 5]);
                
                %set(hl,'Color','k')
                axis tight
                ht=text(1,0,num2str(usechans(i)));
                set(h, 'ButtonDownFcn', @popupImage4)
                hold on               
        end                        
        handles.resetCLimPlot;
        set(gcf,'Color','w')        
    end
end
%%
figure
for i=1:256
    if usechans(i)==0
        continue;
    end
    epos=find(handles.gridlayout.usechans==usechans(i));
    h=plotGridPosition(epos);
    u=find(handles.usechans==usechans(i));
    %imagesc(squeeze(Data(epos,:,[1:6 8:13]))')
    bar(squeeze(max(mean(mInc(epos,800:1200,:,:),4),[],2))-squeeze(max(mean(mCor(epos,800:1200,:,:),4))));
    axis tight
end
handles.resetCLimPlot;

%% correlation per channel to accuracy over runs
figure
for run=[1:13]
    set(gcf,'Name',int2str(run))
    colorset=jet;
    curcolor=colorset(round(run*64/13),:);
    try
        %%
        handles=eval(['D' int2str(run) '.Data']);
        gridlayout=handles.gridlayout.usechans;
        usechans=reshape(gridlayout',[1 size(gridlayout,1)*size(gridlayout,2)]);
        [indices]=handles.findTrials('4','n','n');
        eventSamp=800;        
        for i=1:256  
            if usechans(i)==0
                continue;
            end
                epos=find(handles.gridlayout.usechans==usechans(i));
                h=plotGridPosition(epos);
                u=find(handles.usechans==usechans(i));           
                m1(epos,:,run)=mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond1),3),4);
                m2(epos,:,run)=mean(mean(handles.segmentedEcog(1).zscore_separate(u,:,:,indices.cond2),3),4);
                
                %plot correlation of max amplitude and accuracy
                R=corrcoef(squeeze(max(mean(m1(epos,:,[1:6 8:13]),4),[],2))',[results.accuracy.words]);
                Rmat(epos).words=R(1,2);
                bar( [Rmat(epos).words;Rmat(epos).pseud])
                R=corrcoef(squeeze(max(mean(m2(epos,:,[1:6 8:13]),4),[],2)),[results.accuracy.pseud]);
                Rmat(epos).pseud=R(1,2);

        end
    end
end
    
 %% plot max over runs for HG
 figure
 for i=1:256
     if usechans(i)==0
         continue;
     end
     epos=find(handles.gridlayout.usechans==usechans(i));
     h=plotGridPosition(epos);
     scatter(repmat(1,1,13),squeeze(mean(m1(epos,800:1200,:))),'.');
     hold on
     scatter(repmat(2,1,13),squeeze(mean(m2(epos,800:1200,:))),'r.');
     plot(repmat([1 2],[13 1])',[squeeze(mean(m1(epos,800:1200,:))),squeeze(mean(m2(epos,800:1200,:)))]')
 end
 %% plot max/ave amplitude over runs for all freq
 load('E:\PreprocessedFiles\EC26\specAll.mat');
 for type=1:2
     figure(type)
     for i=1:256
         if usechans(i)==0
             continue;
         end
         epos=find(handles.gridlayout.usechans==usechans(i));
         h=plotGridPosition(epos);
         if type==1
            meanA=mean(cat(4,specAll.real(epos,800:1200,:)),2);
         elseif type==2
             meanA=mean(cat(4,specAll.pseudo(epos,800:1200,:)),2);
         end
         imagesc(meanA)
         hl=line([800 800],[0 40]);
         set(hl,'Color','k')
     end
end
