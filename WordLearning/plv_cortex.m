%load('/home/angela/Documents/runtrials.mat')
load('E:\PreprocessedFiles\EC26\runtrials.mat')
load('E:\PreprocessedFiles\EC26\ePositions.mat')

%%
x=[x{:}];
%%
%x=[209:214 97:102]
contents=dir('E:\PreprocessedFiles\EC26\PLV_4000post')
%%
for run=1:12
    %test=SegmentedData(['/data_store/human/prcsd_data/EC26/EC26_B' int2str(runtrials(2,run)) '/HilbReal_4to200_40band'])
%    test=SegmentedData(['E:\PreprocessedFiles\EC26\EC26_B' int2str(runtrials(2,run)) '/HilbReal_4to200_40band'])
    test=SegmentedData(['E:\DelayWord\EC18\EC18_B1\HilbReal_4to200_40band'])
    %%
    if strcmp(test.patientID,'EC26')
        load gridlayout
        gridch=reshape(gridlayout',[1 256])
        %y=x(find(gridch(x)~=0));
        %test.usechans=gridch(y);
        test.usechans=1:256;
    else
            gridch=1:256
            test.usechans=1:256;
            x=1:256
    end
    test.channelsTot=length(test.usechans)
    test.Artifacts.badChannels=[];
    test.Artifacts.badTimeSegments=[];
    test.Params.sortidx=0;
    test.BaselineChoice='PreEvent';%use rest block as baseline
    test.Params.baselineMS=[500 1000];%time of pre-event baseline (ms)
    test.Params.indplot=0;%do not plot individual channels
    test.Params.sorttrials=0;%1 to sort trials, 0 to skip sorting
    lh=1:40%load all words            
    seg={[repmat([41],[1 length(lh)]);lh],[lh;repmat([42],[1 length(lh)])],[repmat([42],[1 length(lh)]);lh],[repmat([43],[1 length(lh)]);lh],[repmat([44],[1 length(lh)]);lh],[45;41]};
            
    test.segmentedDataEvents40band(seg(run),{[2000 2000]},'keep',[],'phase',1:40)%
    %test.segmentedDataEvents40band_2({[1:50;1:50]},{[2000 4000]},'keep',[],'phase',1:40)
    indices=test.findTrials('1','n','n');
    %% Choose Pairs of electrodes
    posPair=nchoosek(x,2)
    for idx=28455:size(posPair,1)
        usechan=[gridch(posPair(idx,1)) gridch(posPair(idx,2))];
        if ismember(0,usechan)
            continue
        end
        pos=posPair(idx,:);
%         if ~isempty(find(~cellfun(@isempty,regexp({contents.name}',[int2str(chanNum(1)) '_' int2str(chanNum(2)) '_']))))
%             continue
%         end
        plvdata=zeros(40,size(test.segmentedEcog.phase,2));
        for type=1:2
            for f=1:40
                tmpPLV=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(usechan,:,f,eval(['indices.cond' int2str(type)]))),400,[],[]);
                plvdata(f,:)=tmpPLV(:,1,2)';
            end
            if type==1
                save([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_re'],'plvdata','-v7.3')
            else
                save([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_ps'],'plvdata','-v7.3')
            end
        end
    end
end

%% LOAD and plot PLV
for run=1:12
    %%    
    % test=SegmentedData(['E:\PreprocessedFiles\EC26\EC26_B' int2str(runtrials(2,run)) '/HilbReal_4to200_40band'])
    test=SegmentedData(['E:\DelayWord\EC18\EC18_B1\HilbReal_4to200_40band'])
    %%
    try
        load gridlayout
        gridch=reshape(gridlayout',[1 256])
        y=x(find(gridch(x)~=0));
        test.usechans=gridch(y);
    catch
        y=1:256;
        test.usechans=y;
    end    
    sigch=nchoosek(y,2);
    %plvAll(run).pseudMat=NaN(length(sigch),length(sigch),40);
    %plvAll(run).pseudMat_post=NaN(length(sigch),400,40);
    %plvAll(run).pseudMat_pre=NaN(length(sigch),400,40);    
    %plvAll(run).pseudMat_ratio=NaN(256,256,40);
    uniquech=unique(sigch(:,1))
    %%
    for i=1:length(uniquech)
        curidx=find(sigch(:,1)==uniquech(i));
        %plvAll(run).pseudMat_post=NaN(length(curidx),800,40);
        for j=1:length(curidx)
           try
               pos=sigch(curidx(j),:);
               %plvAll(run).posPair(ch,1:2)=pos(1:2);
               %load(['E:\PreprocessedFiles\EC26\PLV_4000post\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_re'])
               %plvAll(run).real(ch,:,:)=plvdata';
               load([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_ps']);
               %plvAll(run).pseud(ch,:,:)=plvdata';
               %plvAll(run).pseudMat_post(curidx(j),:,:)=plvdata(:,800:1200)';
               %plvAll(run).pseudMat_pre(matidx,:,:)=plvdata(:,401:800)';           
               %plvAll(run).pseudMat_ratio(pos(1),pos(2),:)=mean(plvdata(:,800:1200),2)./mean(plvdata(:,400:600),2);
               %plvAll(run).pseudMat_premean(pos(1),pos(2),:)=mean(plvdata(:,400:800),2);
               tmp=mean(plvdata(:,600:750),2);
               tmp2=plvdata(:,801:1200)-repmat(tmp,1,400);
               [thr,thc]=find(tmp2>.3);
               [u,n]=count_unique(thr);
               tmp3=zeros(1,40);
               tmp3(u)=n;
               plvAll(run).pseudMat_postTh(pos(1),pos(2),:)=tmp3;
               plvAll(run).pseudMat_postmedian(pos(1),pos(2),:)=prctile(tmp2,70,2);
               
               
               
               load([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_re']);
               tmp=mean(plvdata(:,600:750),2);
               tmp2=plvdata(:,801:1200)-repmat(tmp,1,400);
               [thr,thc]=find(tmp2>.3);
               [u,n]=count_unique(thr);
               tmp3=zeros(1,40);
               tmp3(u)=n;
               plvAll(run).realMat_postTh(pos(1),pos(2),:)=tmp3;
               plvAll(run).realMat_postmedian(pos(1),pos(2),:)=prctile(tmp2,70,2);
           catch
               printf('no file')
           end
        end
%         plotGridPosition(uniquech(i))
%         imagesc(flipud(squeeze(mean(plvAll(run).pseudMat_post(1:j,:,:),1))'))
%         hold on
%         line([400 400],[0 40])
    end
end
%%
for i=1:256%hplots'
    axes(hplots(i))
          hold on
        line([400 400],[0 40])
end



%% PLOT PRE AND POST PLV
for fidx=1:5
    %plot grid
    f=frange{fidx}
    tmp=mean(plvAll(run).pseudMat_postTh(:,:,f),3);
    %pr =prctile(prctile(mean(plvAll(run).pseudMat_ratio(:,:,f),3),95),50);
    %pr2=prctile(prctile(mean(median(plvAll(run).pseudMat_post(:,:,f),2),3),70),50);
    %[a,b]=find((mean(plvAll(run).pseudMat_postmean(:,:,f),3)>pr2))
    %[a2,b2]=find( (mean(plvAll(run).pseudMat_ratio(:,:,f),3)>pr))
    %x=intersect([a b],[a2 b2],'rows')
    [a,b]=find(tmp>50)
    x=[a b];
    %%
    [~,sortidx]=sort(x(:,1));
    sigch=[x(sortidx,:)];
    for ch=1:length(sigch)
        pos=sigch(ch,:);
        plvAll(run).posPair(ch,1:2)=pos;
        try
            load([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_ps']);
        catch
            load([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(2)) '_' int2str(pos(1)) '_ps']);
        end
        tmp1=plvdata(:,801:1600)';
        tmp2=plvdata(:,1:800)';
        plvAll(run).pseudMat_ratio(pos(1),pos(2),:)=mean(plvdata(:,800:1200),2)./mean(plvdata(:,400:600),2);
        
        subplot(2,3,1)
        imagesc(flipud(squeeze(tmp2)'),[0 1])
        title(int2str(f))
        subplot(2,3,2)
        imagesc(flipud(squeeze(tmp1)'),[0 1])
        subplot(2,3,3)
        try
            visualizeGrid(2,['E:\General Patient Info\' test.patientID '\brain.jpg'],pos)
        catch
            blankgrid=ones(16,16);
            blankgrid(sigch(ch,:))=0;
            imagesc(blankgrid')
            Locations={'L-Front','L-Par','L-Cent1','L-Cent','L-Lat','L-Subtmp','L-Depth','L-Micro'...
                'R-Front','R-Par','R-Cent1','R-Cent2','R-Lat','R-Subtmp','R-Depth','R-Micro'}
            set(gca,'YTick',1:16,'YTickLabel',Locations)
            saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        end
        
        try
            load([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_re']);
        catch
            load([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(2)) '_' int2str(pos(1)) '_re']);
        end
        tmp1=plvdata(:,801:1600)';
        tmp2=plvdata(:,1:800)';
        plvAll(run).pseudMat_ratio(pos(1),pos(2),:)=mean(plvdata(:,800:1200),2)./mean(plvdata(:,400:600),2);
        
        subplot(2,3,4)
        imagesc(flipud(squeeze(tmp2)'),[0 1])
        title(int2str(f))
        subplot(2,3,5)
        imagesc(flipud(squeeze(tmp1)'),[0 1])
        saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        dos('cmd /c "echo off | clip"')
        %input('n')
        clf
    end
end


%% PLOT PRE AND POST PLV
for fidx=1:5
    f=frange{fidx}
    tmp=mean(plvAll(run).pseudMat_postTh(:,:,f),3);
    %pr =prctile(prctile(mean(plvAll(run).pseudMat_ratio(:,:,f),3),95),50);
    %pr2=prctile(prctile(mean(median(plvAll(run).pseudMat_post(:,:,f),2),3),70),50);
    %[a,b]=find((mean(plvAll(run).pseudMat_postmean(:,:,f),3)>pr2))
    %[a2,b2]=find( (mean(plvAll(run).pseudMat_ratio(:,:,f),3)>pr))
    %x=intersect([a b],[a2 b2],'rows')
    [a,b]=find(tmp>100)
    x=[a b];
    %%
    [~,sortidx]=sort(x(:,1));
    sigch=[x(sortidx,:)];
    for ch=1:length(sigch)
        pos=sigch(ch,:);
        plvAll(run).posPair(ch,1:2)=pos;
        load([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_ps']);
        subplot(1,3,[1 2])
        plot(mean(plvdata(f,:),1),'r')
        hold on
        title(int2str(f))
        line([800 800],[0 1])        
        load([test.MainPath '\PLV\PLV_run' int2str(runtrials(1,run)) '_epos' int2str(pos(1)) '_' int2str(pos(2)) '_re']);
        plot(mean(plvdata(f,:),1),'b')
        hold off
        subplot(1,3,3)                
        try
            visualizeGrid(2,['E:\General Patient Info\' test.patientID '\brain.jpg'],pos)
        catch
            blankgrid=ones(16,16);
            blankgrid(sigch(ch,:))=0;
            imagesc(blankgrid')
            Locations={'L-Front','L-Par','L-Cent1','L-Cent','L-Lat','L-Subtmp','L-Depth','L-Micro'...
                'R-Front','R-Par','R-Cent1','R-Cent2','R-Lat','R-Subtmp','R-Depth','R-Micro'}
            set(gca,'YTick',1:16,'YTickLabel',Locations)
            saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        end
        hold off        
        %saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        %dos('cmd /c "echo off | clip"')
        input('n')
        %clf
    end
end



%% PLOT PLV CONNECTIONS
%figure
load('E:\DelayWord\frequencybands.mat')
 gridlayout=reshape(1:256,[16 16])' 
 F= fieldnames(frequencybands)
 for i=1:5
     frange{i}=getfield(frequencybands,F{i+1})
 end
for fidx=1:5   
    %%
    %plot grid
    f=frange{fidx}
    %plot plv connections
    try        
        tmp=mean(plvAll(run).realMat_postTh(:,:,f),3);
        %pr =prctile(prctile(mean(plvAll(run).pseudMat_ratio(:,:,f),3),2),2); 
        %pr =prctile(prctile(mean(plvAll(run).pseudMat_ratio(:,:,f),3),99),99);  
%         pr2=prctile(prctile(mean(plvAll(run).pseudMat_postmean(:,:,f),3),95),95);
%         [a,b]=find((mean(plvAll(run).pseudMat_postmean(:,:,f),3)>pr2))
%         [a2,b2]=find( (mean(plvAll(run).pseudMat_ratio(:,:,f),3)>pr))
%         x=intersect([a b],[a2 b2],'rows')
%         x=[a2 b2]
        %pr=prctile(reshape(tmp,1,[]),99.5);
        [a,b]=find(tmp>150)
        x=[a b];
        
        try
            visualizeGrid(2,['E:\General Patient Info\' test.patientID '\brain.jpg'],unique(x))
            load('regdata')
            gridlayout=xy;
        catch
            blankgrid=ones(16,16);
            imagesc(blankgrid)
            colormap(gray)
            axis tight
            set(gca,'XGrid','on')
            set(gca,'YGrid','on')
            set(gca,'XTick',[1.5:16.5])
            set(gca,'YTick',[1.5:(16+.5)])
            set(gca,'XTickLabel',[])
            set(gca,'YTickLabel',[])
            for c=1:16
                for r=1:16
                    text(c,r,num2str((r-1)*16+c))
                end
            end
            hold on
            blankgrid(a)=0;
            blankgrid(b)=0;
            imagesc(blankgrid')   
            view(2)
            Locations={'L-Front','L-Par','L-Cent1','L-Cent','L-Lat','L-Subtmp','L-Depth','L-Micro'...
                'R-Front','R-Par','R-Cent1','R-Cent2','R-Lat','R-Subtmp','R-Depth','R-Micro'}
            set(gca,'YTickLabel',Locations)
        end
        plvConnect(x,gridlayout,[],tmp)
    end
    title(int2str(f))
    hold off
    input('next')
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off','title',['# above th: freqband ' int2str(fidx)]);
    clf
end


%% PLOT PLV PER CHANNEL TO ALL OTHER CHANNELS

for i=1:5
    %%
    f=frange{i};
    for c=1:256
        tmp1=mean(plvAll(run).pseudMat_ratio(c,:,f),3);
        tmp2=mean(plvAll(run).pseudMat_ratio(:,c,f),3)';
        plvOneChan=nansum([tmp1;tmp2]);
        h=plotGridPosition(c);
        imagesc(reshape(plvOneChan,[16 16])',[-1 1])
        hold on
        m=floor(c/16)+1;
        n=rem(c,16);
        if n==0
            n=16;
        end
        plot(n,m,'k*','LineWidth',2)
    end
    test.resetCLimPlot
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
    clf
end
%%
