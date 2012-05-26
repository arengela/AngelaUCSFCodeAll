classdef SegmentedData < handle
    properties
        Filepath
        Events
        Data
        Baseline
        channelsTot=256;
        MainPath
        Params
        ecogFiltered
        folderType
        patientID
        gridlayout
        Artifacts
        eventParams
        segmentedEcog
        ecogBaseline
        BaselineChoice
        holdField
    end
    
    %%
    methods
        function handles=SegmentedData(Filepath,BaselinePath,loadflag)
            [handles.MainPath,handles.folderType,~]=fileparts(Filepath);
            cd(Filepath)
            handles.Filepath=Filepath;

            cd(handles.Filepath)
            [data, handles.Params.sampFreq, ~,chanNum] = readhtk ( 'Wav11.htk');               
            handles.Params.sampDur=1000/handles.Params.sampFreq;
            
            handles.loadArtifacts
            handles.loadGridPic

            if nargin<3
            elseif loadflag==1                    
               handles.loadData
            end
                
                
           
            
            if nargin>1
                if ~isempty(BaselinePath)
                    handles.loadBaselineFolder(BaselinePath);
                    handles.BaselineChoice='ave';
                end
            end
        end
        
        %%
        function loadData(handles)
            
            getDataParams(handles)

            if strmatch(handles.folderType,'HilbReal_4to200_40band')
                blockNum=floor(handles.channelsTot/64);
                elecNum=rem(handles.channelsTot,64);
                for chanNum=1:handles.channelsTot
                    data=loadHTKtoEcog_onechan_complex(handles.MainPath,chanNum,[]);
                    handles.ecogFiltered.data(chanNum,:,:)=data';
                    fprintf([int2str(chanNum) '.'])
                end
            elseif ~isempty(strfind(handles.MainPath,'Rat'))
                handles.ecogFiltered=loadHTKtoEcog_rat_CT(handles.MainPath,96,[])
            elseif strmatch(handles.folderType,'Analog')
                handles.ecogFiltered=loadAnalogtoEcog_CT(handles.MainPath,4,[]);
                handles.baselineChoice='None';
            else
                handles.ecogFiltered=loadHTKtoEcog_CT(handles.Filepath,handles.channelsTot,[]);
                handles.ecogFiltered.data=mean(handles.ecogFiltered.data,3);
            end
        end
        %%
        function getDataParams(handles)
            cd(handles.Filepath)
            [data, handles.Params.sampFreq, ~,chanNum] = readhtk ( 'Wav11.htk');
            dataLength=size(data,2);
            bandNum=size(data,1);
            handles.ecogFiltered.data=zeros(handles.channelsTot,dataLength,bandNum);
            handles.ecogFiltered.sampFreq=handles.Params.sampFreq;
            handles.Params.sampDur=1000/handles.Params.sampFreq;
            
        end
        %%
        function showDataParams(handles)
            if isempty(handles.Params.sampFreq)
                handles.getDataParams;
            else
                printf('Sampling Freq: %f Hz',handles.Params.sampFreq)
                printf('Block Duration: %f sec',size(handles.ecogFiltered.data,2)/handles.Params.sampFreq)
                printf('Number of Freq Bands: %d',size(handles.ecogFiltered.data,3))
            end            
        end
        %%
        function loadArtifacts(handles)
            
            cd(sprintf('%s/Artifacts',handles.MainPath))
            load 'badTimeSegments.mat'
            handles.Artifacts.badTimeSegments=badTimeSegments;
            fprintf('%d bad time segments loaded',size(handles.Artifacts.badTimeSegments,1));
            fid = fopen('badChannels.txt');
            tmp = fscanf(fid, '%d');
            handles.Artifacts.badChannels=tmp';
            fclose(fid);
            fprintf('Bad Channels: %s',int2str(handles.Artifacts.badChannels));
            cd(handles.MainPath)
            
        end
        %%
        function loadGridPic(handles)
            tmp=regexp(handles.MainPath,'_','split');
            names=regexp(tmp{1},'\','split');
            handles.patientID=names{end};
            
            try
                load('gridlayout');
                usechans=reshape(gridlayout',1, size(gridlayout,1)*size(gridlayout,2));
                handles.gridlayout.dim=[size(gridlayout,1) size(gridlayout,2)];
                
            catch
                usechans=[1:handles.channelsTot];
                handles.gridlayout.dim=[16 16];
            end
            
            extra=0;
            
            if length(usechans)>256
                extra=usechans([256:length(usechans)]);
                usechans=usechans(1:256);
                extra=size(zScore,1)-256;
            end
            handles.gridlayout.usechans=usechans;
            handles.gridlayout.extra=extra;           
            
        end
        
        %%
        function segmentedDataEvents(handles,subsetLabel,segmentTimeWindow)
            handles.eventParams.subsetLabel=subsetLabel;
            handles.eventParams.segmentTimeWindow=segmentTimeWindow;
            
            %sort=input('Sort Events? (y/n)','s');
            %checkEvents=input('Check Events Visually? (y/n)','s');
            sortstacked='y';
            if strcmp(sortstacked,'n')
                handles.eventParams.sortstacked=0;
            else
                handles.eventParams.sortstacked=1;
            end
            checkEvents='n';
            cd(sprintf('%s/Analog',handles.MainPath))            
            
            handles.segmentedEcog=segmentingEcogGUI_2events(handles.MainPath, handles.ecogFiltered,handles.eventParams.subsetLabel,handles.eventParams.segmentTimeWindow, handles.Artifacts.badTimeSegments,handles.Params.sampFreq, 0);
            if strmatch('y',checkEvents)
                handles.segmentedEcog.badTrials=checkEventSegmentationVisually(handles.segmentedEcog.eventTS)
                for i=1:size(handles.segmentedEcog.eventTS)
                    goodtrials{i}=setdiff(1:size(handles.segmentedEcog.eventTS{i},4),handles.segmentedEcog.badTrials{i})
                end
            elseif strmatch('y',sortstacked)
                handles.sortStacked            
            end
            
        end
        
        %%
        function sortStacked(handles)
            for i=1:size(handles.segmentedEcog,2)
                e=squeeze(handles.segmentedEcog(i).eventTS);
                goodtrials{i}=[];
                for j=1:size(e,2)
                    if size(handles.segmentedEcog(i).desiredSubsets,1)==4
                        s=find(ismember(e(handles.eventParams.segmentTimeWindow{i}(1)/1000*handles.Params.sampFreq+1:end,j),handles.segmentedEcog(i).desiredSubsets(4,:)));
                    else
                        s=find(ismember(e(handles.eventParams.segmentTimeWindow{i}(1)/1000*handles.Params.sampFreq+1:end,j),handles.segmentedEcog(i).desiredSubsets(2,:)));
                        handles.segmentedEcog(i).desiredSubsets(4,:)=handles.segmentedEcog(i).desiredSubsets(2,:);
                    end
                    if ~isempty(s)
                        goodtrials{i}=[goodtrials{i} j];
                    end
                end
                handles.segmentedEcog(i).badTrials=setdiff(1:size(handles.segmentedEcog(i).eventTS,4),goodtrials{i})
                
                 for j=1:length(goodtrials{i})
                    e=squeeze(handles.segmentedEcog(i).eventTS);
                    r(j)=find(ismember(e(handles.eventParams.segmentTimeWindow{i}(1)/1000*handles.Params.sampFreq+1:end,goodtrials{i}(j)),handles.segmentedEcog(i).desiredSubsets(4,:)),1);
                  end
                
                if exist('r')
                    [r2,idx]=sort(r);
                    t=1:length(goodtrials{i});
                    handles.segmentedEcog(i).data=handles.segmentedEcog(i).data(:,:,:,goodtrials{i}(idx));
                    handles.segmentedEcog(i).rt=r2;
                    handles.segmentedEcog(i).trialidx=idx;
                    clear r
                else
                    handles.segmentedEcog(i).rt=zeros(1,j);
                end
                
            end          
            cd(sprintf('%s',handles.MainPath))
            
        end
        
        %%
        function loadBaselineFolder(handles,BaselineChoice)
            
            fprintf('Baseline File opened: %s\n',BaselineChoice);
            handles.BaselineChoice=BaselineChoice;
            if strmatch(handles.folderType,'HilbReal_4to200_40band')
                cd([ handles.MainPath '\HilbReal_4to200_40band'])
                [r, sampFreq, tmp, chanNum] = readhtk ('Wav11.htk');
                
                for nBlocks=1:4
                    for k=1:64
                        cd([ handles.MainPath '\HilbReal_4to200_40band'])
                        varName1=['Wav' num2str(nBlocks) num2str(k)];
                        [r, sampFreq, tmp, chanNum] = readhtk (sprintf('%s.htk',varName1));
                        fprintf('%i.',chanNum)
                        cd([  handles.MainPath '\HilbImag_4to200_40band'])
                        im = readhtk (sprintf('%s.htk',varName1));
                        %handles.ecogBaseline.data(chanNum,:,:)=abs(complex(r,im))';
                        handles.ecogBaseline.mean(chanNum,1,:)=mean(abs(complex(r,im))',1);
                        handles.ecogBaseline.std(chanNum,1,:)=std(abs(complex(r,im))',[],1);
                        
                    end
                end
                handles.ecogBaseline.sampFreq=sampFreq;
                
            else
                cd(BaselineChoice);
                [data, sampFreq, chanNum] = readhtk ( 'Wav11.htk' );
                handles.ecogBaseline.data=zeros(256,length(data),size(data,1));
                for nBlocks=1:4
                    for k=1:64
                        varName1=['Wav' num2str(nBlocks) num2str(k)];
                        [data, sampFreq, tmp, chanNum] = readhtk (sprintf('%s.htk',varName1));
                        handles.ecogBaseline.data(chanNum,:,:)=mean(data',3);                        
                    end
                end
                %handles.ecogBaseline.data=mean(handles.ecogBaseline.data,3);                
                handles.ecogBaseline.sampFreq=sampFreq;
            end
            cd( handles.MainPath)
            
        end
        
        %%
        function plotData(handles,plottype,recalc)
            comparePlots='n';
            colors={'k','g','m','b','c','r'};
            
            
            recalc=1;
            if 1%nargin>2
                if recalc==1
                    handles.calcZscore
                    handles.rejectExtremes
                end
            end

            for i=1:length(handles.segmentedEcog)               
                if ~strcmp('y',comparePlots)
                    figure
                    color=colors{i};
                elseif i==1
                    figure
                    color='k';
                end
                               
                set(gcf,'Name',[handles.patientID ' event: ' int2str(i)]);
                set(gcf,'Color','w')
                handles.segmentedEcog(i).zscore_separate(handles.Artifacts.badChannels,:,:,:)=NaN;

                


                
                switch plottype
                    case 'line'
                        if nargin==2   
                           %plotBands=30:39
                           plotBands=2:8

                            for chanNum=1:256
                                zScore(chanNum,:)=mean(mean(handles.segmentedEcog(i).zscore_separate(chanNum,:,plotBands,handles.segmentedEcog.usetrials{chanNum}),3),4);                       
    %                         Y=zScore;
    %                         E = std(Y,[],3)/sqrt(size(Y,3));
                            end
                        else
                             zScore=mean(mean(handles.segmentedEcog(i).zscore_separate,3),4);   
                        end

                    case 'stacked'
                        zScore=squeeze(mean(handles.segmentedEcog(i).zscore_separate,3));
                    case 'spectrogram'
                        if 1%isfield(handles.segmentedEcog(i),'usetrials')
                            zScore=zeros(handles.channelsTot,size(handles.segmentedEcog(i).zscore_separate,2),size(handles.segmentedEcog(i).zscore_separate,3));
        
                            
                            for chanNum=1:256
                                  usetrials=[];
                                    tmp=squeeze(mean(handles.segmentedEcog(i).zscore_separate(chanNum,:,:,:),3));
                                    [a,badt]=find(tmp>10);
                                    usetrials=setdiff(1:size(handles.segmentedEcog(i).zscore_separate(chanNum,:,:,:),4),unique(badt));
                                    handles.segmentedEcog(i).usetrials{chanNum}=usetrials;
                                     zScore(chanNum,:,:)=mean(handles.segmentedEcog(i).zscore_separate(chanNum,:,:,handles.segmentedEcog(i).usetrials{chanNum}),4);

                                    zScore(chanNum,:,:)=mean(handles.segmentedEcog(i).zscore_separate(chanNum,:,:,handles.segmentedEcog(i).usetrials{chanNum}),4);
                            end
                            
                         else

                            zScore=mean(handles.segmentedEcog(i).zscore_separate,4);
                        end
                    otherwise
                        keyboard
                end 
                
                handles.makePlots(zScore,plottype,i,color)
            end
        end
        
        %%
        function makePlots(handles,zScore,plottype,idx,color)              

            eventSamp=handles.eventParams.segmentTimeWindow{idx}(1)*handles.Params.sampFreq/1000;
            badChannels=handles.Artifacts.badChannels;
            try
                r_time=handles.segmentedEcog(idx).rt;
            end
            usechans=handles.gridlayout.usechans;
            extra=handles.gridlayout.extra;
            
            rowtot=handles.gridlayout.dim(1);
            coltot=handles.gridlayout.dim(2);     

            
            ztmp=zScore(setdiff(1:256,badChannels),:);
            maxZallchan=max(zScore,[],2);
            minZallchan=min(zScore,[],2);
            
            a=find(maxZallchan>.75);
            diff=maxZallchan-minZallchan;
            diff(badChannels)=NaN;
            maxdiff=max(diff);
            
            
            i=1;
            while i<=length(usechans)
                m=floor(i/coltot);
                n=rem(i,coltot);
                if n==0
                    n=coltot;
                    m=m-1;
                end
                
                p(1)=6*(n-1)/100+.03;
                p(2)=6.2*(15-m)/100+0.01;
                p(3)=.055;
                p(4)=.055;
                h=subplot('Position',p);                
                
                switch plottype
                    case 'line'
                        hp=plot(zScore(usechans(i),:),color);                   
                        axis([0 size(zScore,2) minZallchan(usechans(i)) minZallchan(usechans(i))+maxdiff]);
                        %hl=line([eventSamp,eventSamp],[minZallchan(usechans(i)), minZallchan(usechans(i))+maxdiff]);
                        hl=line([eventSamp,eventSamp],[0 5]);
                        
                        set(hl,'Color','r')
                        axis tight
                        ht=text(1,minZallchan(usechans(i))+maxdiff-0.1,num2str(usechans(i)));                       
                        set(h, 'ButtonDownFcn', @popupImage)
                        hold on
                        
                    case 'stacked'                        
                        hp=imagesc(squeeze(zScore(usechans(i),:,:))',[0 1.5]);
                        ht=text(p(1),p(2),int2str(usechans(i)));
                        hold on
                        colormap(flipud(pink))
                        try
                            plot([eventSamp+r_time],[1:size(zScore,3)],'r')
                        end
                        plot([eventSamp eventSamp+.001],[0 size(zScore,3)],'r')
                        set(h, 'ButtonDownFcn', @popupImage3)

                    case 'spectrogram'
                        
                        
                        %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:)))'));
                        %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:))')));
                        hp=imagesc(flipud(squeeze(zScore(usechans(i),:,:))'),[0 2]);

                        hold on
                        plot([eventSamp eventSamp+0.001],[0 size(zScore,2)],'r');
                        ht=text(p(1),p(2),int2str(usechans(i)));                    
                        colormap(flipud(pink))
                        set(h, 'ButtonDownFcn', @popupImage)

                    otherwise
                        
                end
                set(gca,'xtick',[],'ytick',[])
                if find(ismember(badChannels,usechans(i)))
                    set(ht,'BackgroundColor','y')
                end
                
                i=i+1;
                if i>length(usechans) & extra~=0
                    figure
                    i=1;
                    usechans=extra;
                end
            end
            
            
                
        end
%%

    function makeIndPlots(handles,zScore,plottype,idx,color)
            for i=1: length(handles.eventParams.subsetLabel)
                
               for chanNum=1:256
                     zScore2{i}(chanNum,:,:)=mean(handles.segmentedEcog(i).zscore_separate(chanNum,:,:,handles.segmentedEcog(i).usetrials{chanNum}),4);

               end
            end
    
    
    
            eventSamp=handles.eventParams.segmentTimeWindow{idx}(1)*handles.Params.sampFreq/1000;
            badChannels=handles.Artifacts.badChannels;
            try
                r_time=handles.segmentedEcog(idx).rt;
            end
            usechans=handles.gridlayout.usechans;
            extra=handles.gridlayout.extra;
            
            rowtot=handles.gridlayout.dim(1);
            coltot=handles.gridlayout.dim(2);     

            
           
            
            colors={'k','r','b','g','m'}
            i=1;
            while i<=length(usechans)
                m=floor(i/coltot);
                n=rem(i,coltot);
                if n==0
                    n=coltot;
                    m=m-1;
                end
                for event=1:length(handles.eventParams.subsetLabel)                
                    color=colors{event};

                    h=subplot(1,length(handles.eventParams.subsetLabel),event);                

                    switch plottype
                        case 'line'
                            hp=plot(zScore2{event}(usechans(i),:),color);                   
                            axis([0 size(zScore2{event},2) minZallchan(usechans(i)) minZallchan(usechans(i))+maxdiff]);
                            %hl=line([eventSamp,eventSamp],[minZallchan(usechans(i)), minZallchan(usechans(i))+maxdiff]);
                            hl=line([eventSamp,eventSamp],[0 5]);

                            set(hl,'Color','r')
                            axis tight
                            ht=text(1,minZallchan(usechans(i))+maxdiff-0.1,num2str(usechans(i)));                       
                            set(h, 'ButtonDownFcn', @popupImage)
                            hold on

                        case 'stacked'                        
                            hp=imagesc(squeeze(zScore2{event}(usechans(i),:,:))',[0 1.5]);
                            ht=text(p(1),p(2),int2str(usechans(i)));
                            hold on
                            colormap(flipud(pink))
                            try
                                plot([eventSamp+r_time],[1:size(zScore,3)],'r')
                            end
                            plot([eventSamp eventSamp+.001],[0 size(zScore,3)],'r')
                            set(h, 'ButtonDownFcn', @popupImage3)

                        case 'spectrogram'


                            %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:)))'));
                            %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:))')));
                            hp=imagesc(flipud(squeeze(zScore2{event}(usechans(i),:,:))'),[-2 2]);

                            hold on
                            plot([eventSamp eventSamp+0.001],[0 size(zScore2{event},2)],'r');
                            ht=title(int2str(usechans(i)));                    
                            colormap(winter)
                            set(h, 'ButtonDownFcn', @popupImage)

                        otherwise

                    end

                    set(gca,'xtick',[],'ytick',[])
                    if find(ismember(badChannels,usechans(i)))
                        set(ht,'BackgroundColor','y')
                    end

                    
                
                
                end
                i=i+1;
                    if i>length(usechans) & extra~=0
                        figure
                        i=1;
                        usechans=extra;
                    end
                input('next')

            end
    end
            
            
                
        
%%                    
        function listConditions(handles)
            cd([handles.MainPath '/Analog'])
            load allConditions            
            for i=1:length(allConditions)
                printf('%i. %s',i,allConditions{i});
            end
            cd([handles.MainPath '/Analog'])
        end
            
        
        %%
        function calcZscore(handles)
            for i=1:length(handles.segmentedEcog)
                datalength=size(handles.segmentedEcog(1).data,2);
                switch handles.BaselineChoice
                    case'PreEvent'
                    %Use 300 ms before each event for baseline
                    samples=[ceil(handles.baselineMS(1)*4/10):floor(handles.baselineMS(2)*4/10)];%This can be changed to adjust time used for baseline
                    Baseline=handles.segmentedEcog(1).data(:,samples,:,:);
                    meanOfBaseline=repmat(mean(Baseline,2),[1, datalength,1,1]);
                    stdOfBaseline=repmat(std(Baseline,0,2),[1,datalength,1, 1]);
                    
                    case 'RestEnd'
                    %Use resting at end for baseline
                    handles.ecogBaseline.data=handles.ecogBaseline.data(:,round(handles.baselineMS(1)*handles.sampFreq/1000:handles.baselineMS(2)*handles.sampFreq/1000),:,:);
                    meanOfBaseline=repmat(mean(handles.ecogBaseline.data,2),[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                    stdOfBaseline=repmat(std(handles.ecogBaseline.data,0,2),[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                    
                     case 'none' %if strmatch('RestBlock',handles.BaselineChoice)
                           meanOfBaseline=repmat(NaN,[handles.channelsTot, datalength,size(handles.segmentedEcog(i).data,3),size(handles.segmentedEcog(i).data,4)]);
                            stdOfBaseline=repmat(NaN,[handles.channelsTot, datalength,size(handles.segmentedEcog(i).data,3),size(handles.segmentedEcog(i).data,4)]);
                            handles.segmentedEcog(i).zscore_separate=handles.segmentedEcog(i).data(:,:,:,1);
                            continue
                           
                    case 'rest'
                            %use rest block for baseline
                            %handles.baselineFiltered.data=handles.ecogBaseline.data;
                            meanOfBaseline=repmat(mean(handles.ecogBaseline.data,2),[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                            stdOfBaseline=repmat(std(handles.ecogBaseline.data,[],2),[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                    case 'ave'
                            meanOfBaseline=repmat(handles.ecogBaseline.mean,[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                            stdOfBaseline=repmat(handles.ecogBaseline.std,[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                end
                    
                handles.segmentedEcog(i).zscore_separate=(handles.segmentedEcog(i).data-meanOfBaseline)./stdOfBaseline;
            end
        end
    



%%

    function segmentedDataEvents40band(handles,subsetLabel,segmentTimeWindow,saveflag, trialnum)

            if nargin<4
                saveflag='na'
            end
            handles.eventParams.subsetLabel=subsetLabel;
            handles.eventParams.segmentTimeWindow=segmentTimeWindow;
            load([handles.MainPath '/Analog/allEventTimes.mat'])
            load([handles.MainPath '/Analog/allConditions.mat'])
            
            
            %discard bad segments
            buffer=handles.eventParams.segmentTimeWindow{1};

            

%             for b=1:size(handles.Artifacts.badTimeSegments,1)
%                 for t=1:size(allEventTimes,1)
%                     segmentTimes=[allEventTimes{t,1}-buffer(1)/1000, allEventTimes(t,1)+buffer(2)/1000];
%                     if (handles.Artifacts.badTimeSegments(b,1)>=segmentTimes(t,1)) & (handles.Artifacts.badTimeSegments(b,1)<=segmentTimes(t,2)) | (handles.Artifacts.badTimeSegments(b,2)>=segmentTimes(t,1)) & (handles.Artifacts.badTimeSegments(b,2)<=segmentTimes(t,2))
%                         allEventTimes{t,1}='0';
%                     end
%                 end
%             end
    
            
            for i=1:length(handles.eventParams.subsetLabel)
                curevent=allConditions(unique(handles.eventParams.subsetLabel{i}(1,:)));
                p3=find(ismember(allEventTimes(:,2),curevent));                
                if nargin<5
                    trialnum=length(p3);
                end
                buffer=handles.eventParams.segmentTimeWindow{i};
                switch saveflag
                    case 'save'
                        handles.segmentedEcog(i).data=NaN(handles.channelsTot,ceil((sum(buffer)/1000)*handles.Params.sampFreq),40,2);
                        dest=sprintf('%s/segmented_40band/event%s_%i_%i',handles.MainPath,int2str(unique(subsetLabel{i}(1,:))),buffer(1),buffer(2));
                        mkdir(dest);
                        cd(dest)
                    case 'keep'
                        %handles.segmentedEcog(i).data=zeros(handles.channelsTot,ceil((sum(buffer)/1000)*handles.Params.sampFreq),40,trialnum);
                        handles.segmentedEcog(i).event=cell(trialnum,2);

                    otherwise                          
                    end
                    
                    
                for chanNum= 1:handles.channelsTot                    
                    for s=1:trialnum
                        timeInt=[allEventTimes{p3(s),1}*1000-buffer(1) allEventTimes{p3(s),1}*1000+buffer(2)];
                        [R,I]=loadHTKtoEcog_onechan_complex_real_imag(handles.MainPath,chanNum,timeInt);
                        data=complex(R,I);
                        switch saveflag                            
                            case 'save'
                                %nextevent=find(strcmp(allEventTimes{p3(s)+1,2},allConditions(1:40)))

                                mkdir([dest '/Chan' int2str(chanNum)]);
                                cd([dest filesep 'Chan' int2str(chanNum)])
                                writehtk(['t' int2str(s) '.htk'],data',allEventTimes{p3(s),1}*1000,find(strcmp(allConditions,allEventTimes{p3(s),2})));
                                
                                if chanNum==1
                                    if find(strcmp(allEventTimes{p3(s)+1,2},unique(allConditions(handles.eventParams.subsetLabel{i}(2,:)))))
                                        handles.segmentedEcog(i).event(s,1:4)=[allEventTimes(p3(s),1:2)  allEventTimes{p3(s)+1,1} allEventTimes{p3(s)+1,2}];
                                    else
                                        handles.segmentedEcog(i).event(s,1:4)=[allEventTimes(p3(s),1:2) 0 0];
                                    end
                                end
                                %handles.segmentedEcog(i).data(chanNum,:,:,2)=abs(data)';
                                %handles.segmentedEcog(i).data(chanNum,:,:,1)=nanmean(handles.segmentedEcog(i).data(chanNum,:,:,:),4);
                            case 'keep'
                                handles.segmentedEcog(i).data(chanNum,:,:,s)=abs(data)';
                                handles.segmentedEcog(i).event(s,1:2)=allEventTimes(p3(s),1:2);
                            otherwise
                        end

                    end   
%                     
%                     [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);
%                       usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
%                     meanSeg=squeeze(zscore(mean(handles.segmentedEcog(i).data(chanNum,:,:,:),2),[],4));
%                     [a,b]=find(meanSeg>3);
%                     handles.segmentedEcog(i).data(chanNum,:,:,b)=NaN;                   
                end 
                %meanSeg=squeeze(mean(zscore(mean(handles.segmentedEcog(i).data(:,:,:,:),2),[],4),3));

                cd(dest)
                segmentLog=handles.segmentedEcog(i).event;
                save('segmentLog.mat','segmentLog')
            end

    end
    
    
     function segmentedDataEvents8band(handles,subsetLabel,segmentTimeWindow,saveflag,trialnum)

            if nargin<4
                saveflag='na'
            end
            

            handles.eventParams.subsetLabel=subsetLabel;
            handles.eventParams.segmentTimeWindow=segmentTimeWindow;
            load([handles.MainPath '/Analog/allEventTimes.mat'])
            load([handles.MainPath '/Analog/allConditions.mat'])
            
            %discard bad segments
            buffer=handles.eventParams.segmentTimeWindow{1};
            segmentTimes=[E-buffer(1)/1000, allEventTimes(:,1)+buffer(2)/1000];
            for b=1:size(handles.params.badTimeIntervals,1)
                for t=1:size(segmentTimes,1)
                    if (handles.params.badTimeIntervals(b,1)>=segmentTimes(t,1)) & (handles.params.badTimeIntervals(b,1)<=segmentTimes(t,2)) | (handles.params.badTimeIntervals(b,2)>=segmentTimes(t,1)) & (handles.params.badTimeIntervals(b,2)<=segmentTimes(t,2))
                        s3{t}='0';
                    end
                end
            end
    
            for i=1:length(handles.eventParams.subsetLabel)
                curevent=allConditions(handles.eventParams.subsetLabel{i}(1,:))
                p3=find(ismember(allEventTimes(:,2),curevent))
                if nargin<=5
                    trialnum=length(p3);
                end
                buffer=handles.eventParams.segmentTimeWindow{i};
                switch saveflag
                    case 'save'
                        handles.segmentedEcog(i).data=NaN(handles.channelsTot,ceil((sum(buffer)/1000)*handles.Params.sampFreq),8,2);
                        dest=sprintf('%s/segmented_8band/event%s_%i_%i',handles.MainPath,int2str(subsetLabel{i}(1,:)),buffer(1),buffer(2));
                        mkdir(dest);
                        cd(dest)
                    case 'keep'
                        handles.segmentedEcog(i).data=zeros(handles.channelsTot,ceil((sum(buffer)/1000)*handles.Params.sampFreq),8,trialnum);
                    otherwise                          
                    end
                    

                for chanNum= 1:handles.channelsTot                    
                    for s=1:trialnum
                         %cd(handles.MainPath)

                        timeInt=[allEventTimes{p3(s),1}*1000-buffer(1) allEventTimes{p3(s),1}*1000+buffer(2)];
                        
                        
  
                        
                        
                        cd(handles.Filepath)
                        data=loadHTKtoEcog_onechan(chanNum,round(timeInt));
                        switch saveflag 
                            case 'ave'
                                handles.segmentedEcog(i).data(chanNum,:,:,2)=abs(data);
                                handles.segmentedEcog(i).data(chanNum,:,:,1)=nanmean(handles.segmentedEcog(i).data(chanNum,:,:,:),4);
                            case 'save'                            
                                mkdir([dest '/Chan' int2str(chanNum)]);
                                cd([dest filesep 'Chan' int2str(chanNum)])
                                
                                writehtk(['t' int2str(s) '.htk'],data',400);
                                handles.segmentedEcog(i).data(chanNum,:,:,2)=abs(data);
                                handles.segmentedEcog(i).data(chanNum,:,:,1)=nanmean(handles.segmentedEcog(i).data(chanNum,:,:,:),4);
                            case 'keep'
                                handles.segmentedEcog(i).data(chanNum,:,:,s)=abs(data)';
                            otherwise
                        end

                    end               
                end 
                
                
                meanSeg=mean(handles.segmentedEcog(i).data,4);
                
            end
     end
    
     function loadSegments(handles,folderPath,trialNum,sorttrials)
        
        
         for i=1:length(folderPath)
             
             load([handles.MainPath '/Analog/allConditions.mat'])
             load([handles.MainPath '/Analog/allEventTimes.mat'])

            [tmp,segFolder]=fileparts(folderPath{i})
            cd(folderPath{i})
            
            
            
            chanFolder=cellstr(ls);
            handles.channelsTot=length(cellstr(ls))-2;
            [~,tmp]=fileparts(segFolder);
            tok=regexp(tmp,'_','split');
            handles.eventParams.segmentTimes{i}=str2num([tok{2} ' ' tok{3}]);
            handles.eventParams.subsetLabel{i}=str2num(tok{1}(find(isstrprop(tok{1},'digit'))));

            buffer=handles.eventParams.segmentTimes{i}
            
            for j=3:handles.channelsTot
                numidx=find(isstrprop(chanFolder{j},'digit'))
                chanNum=str2num(chanFolder{j}(numidx));
                cd([folderPath{i} filesep chanFolder{j}])
                if nargin<3
                    trialNum=length(ls)-2;                  
                end
                 [data,b,c]=readhtk(['t2.htk']);

                handles.segmentedEcog(i).data=zeros(handles.channelsTot,length(data),40,trialNum);
                for t=2:trialNum
                    [data,b,c]=readhtk(['t' num2str(t) '.htk']);
                    tmp=size(data,2);
                    if size(data,2)<40
                        load([handles.MainPath '/Analog/allConditions.mat'])
                        load([handles.MainPath '/Analog/allEventTimes.mat'])
                        curevent=allConditions{handles.eventParams.subsetLabel{i}(1,:)};
                        p3=find(ismember(allEventTimes(:,2),curevent))
                        timeInt=[allEventTimes{p3(t),1}*1000-buffer(1) allEventTimes{p3(t),1}*1000+buffer(2)];
                        [R,I]=loadHTKtoEcog_onechan_complex_real_imag(handles.MainPath,chanNum,timeInt);
                        data=complex(R,I);
                        
                        cd([folderPath{i} filesep chanFolder{j}])
                        writehtk(['t' int2str(t) '.htk'],data',allEventTimes{p3(t),1}*1000,find(strcmp(allConditions,allEventTimes{p3(t),2})));
                        [data,b,c]=readhtk(['t' num2str(t) '.htk']);
                    
                    end
                        handles.segmentedEcog(i).data(chanNum,:,:,t)=data;
                    if sorttrials==1 & chanNum==1
                        cureventidx=findnearest(b/1000,cell2mat(allEventTimes(:,1)));
                        handles.segmentedEcog(i).event{t,1}=allEventTimes{cureventidx,1};
                        handles.segmentedEcog(i).event{t,2}=allEventTimes{cureventidx,2};
                        handles.segmentedEcog(i).event{t,3}=allEventTimes{cureventidx+1,1};
                        handles.segmentedEcog(i).event{t,4}=allEventTimes{cureventidx+1,2};
                    end
                end
            end
            
            if sorttrials==1
                rt=cell2mat(handles.segmentedEcog(i).event(:,3))-cell2mat(handles.segmentedEcog(i).event(:,1));

                [~,sortidx]=sort(rt);
                handles.segmentedEcog(i).rt=rt(sortidx);
                handles.segmentedEcog(i).data=handles.segmentedEcog(i).data(chanNum,:,:,sortidx);
                handles.segmentedEcog(i).event=handles.segmentedEcog(i).event(sortidx,:);            
            end
            
         end
     end
             
     
     
     
     function rejectExtremes(handles)
         for event=1:length(handles.segmentedEcog)
             for chanNum=1:256
                 usetrials=[];
                tmp=squeeze(mean(handles.segmentedEcog(event).zscore_separate(chanNum,:,:,:),3));
                [a,badt]=find(tmp>10);
                usetrials=setdiff(1:size(test2.segmentedEcog(event).zscore_separate(chanNum,:,:,:),4),unique(badt));
                handles.segmentedEcog(event).usetrials{chanNum}=usetrials;
             end
         end
     end
     
     
     function resetCLimPlot(handles)
         hplots=get(gcf,'Children');
        for  chanNum=1:256
            
            set(hplots(chanNum),'CLim',[0 1.5]);
        end
     end
    end
end


%%%

