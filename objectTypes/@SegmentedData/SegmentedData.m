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
        usechans
    end
    
    methods
        function handles=SegmentedData(Filepath,BaselinePath,loadflag)
            %Initialize variables, load data
            %Filepath: path to data to be loaded ie /data_store/EC3/EC3_B1/HilbAA_70to150_8band'
            [handles.MainPath,handles.folderType,~]=fileparts(Filepath);
            cd(Filepath)
            handles.Filepath=Filepath;
            cd(handles.Filepath)
            try
                [data, handles.Params.sampFreq, ~,chanNum] = readhtk ( 'Wav11.htk');
                handles.Params.sampDur=1000/handles.Params.sampFreq;
            catch
                [data, handles.Params.sampFreq, ~,chanNum] = readhtk ( 'ANIN1_400hz.htk');
                handles.Params.sampDur=1000/handles.Params.sampFreq;
            end
            handles.loadArtifacts
            handles.loadGridPic
            
            if nargin<3
            elseif loadflag==1
                handles.loadData
                handles.loadBaselineFolder(BaselinePath);                
            end
            
            if nargin>1
                if ~isempty(BaselinePath)
                    %handles.loadBaselineFolder(BaselinePath);
                    handles.BaselineChoice='ave';
                end
            end
        end
        
        function loadData(handles)
            %% LOAD ECOG DATA
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
        
        
        function getDataParams(handles)
            %% GET ECOG DATA PARAMETERS
            cd(handles.Filepath)
            [data, handles.Params.sampFreq, ~,chanNum] = readhtk ( 'Wav11.htk');
            dataLength=size(data,2);
            bandNum=size(data,1);
            handles.ecogFiltered.data=zeros(handles.channelsTot,dataLength,bandNum);
            handles.ecogFiltered.sampFreq=handles.Params.sampFreq;
            handles.Params.sampDur=1000/handles.Params.sampFreq;
            
        end
        
        function showDataParams(handles)
            %%
            if isempty(handles.Params.sampFreq)
                handles.getDataParams;
            else
                printf('Sampling Freq: %f Hz',handles.Params.sampFreq)
                printf('Block Duration: %f sec',size(handles.ecogFiltered.data,2)/handles.Params.sampFreq)
                printf('Number of Freq Bands: %d',size(handles.ecogFiltered.data,3))
            end
        end
        
        function loadArtifacts(handles)
            %% LOAD ARTIFACT FILES
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
        
        function loadGridPic(handles)
            %% LOAD GRID LAYOUT
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
        
        function loadBaselineFolder(handles,BaselineChoice,output)
            %% LOAD BASELINE FOLDER
            if nargin<3
                output='aa';
            end
            fprintf('Baseline File opened: %s\n',BaselineChoice);
            handles.BaselineChoice=BaselineChoice;
            baselineMainPath=fileparts(BaselineChoice);            
            handles.ecogBaseline.data=[];
            for  c=1:handles.channelsTot
                chanNum=handles.usechans(c);
                nBlocks=ceil(chanNum/64);
                k=chanNum-(nBlocks-1)*64;
                varName1=['Wav' num2str(nBlocks) num2str(k)];                
                if strmatch(handles.folderType,'HilbReal_4to200_40band')
                    cd([ baselineMainPath '\HilbReal_4to200_40band'])
                    [r, sampFreq, tmp, chanNum] = readhtk (sprintf('%s.htk',varName1));
                    fprintf('%i.',chanNum)
                    cd([ baselineMainPath '\HilbImag_4to200_40band'])
                    im = readhtk (sprintf('%s.htk',varName1));
                    if find(strcmp(output,'complex'))
                        handles.ecogBaseline.data(c,:,:)=complex(r,im)';
                    end
                    if find(strcmp(output,'phase'))
                        handles.ecogBaseline.mean(c,1,:)=mean(angle(complex(r,im))',1);
                        handles.ecogBaseline.std(c,1,:)=std(angle(complex(r,im))',[],1);
                        handles.ecogBaseline.phase(c,:,:)=angle(complex(r,im))';
                    end
                    if find(strcmp(output,'aa'))
                        handles.ecogBaseline.mean(c,1,:)=mean(abs(complex(r,im))',1);
                        handles.ecogBaseline.std(c,1,:)=std(abs(complex(r,im))',[],1);
                        %handles.ecogBaseline.data(chanNum,:,:)=abs(complex(r,im))';
                    end
                else
                    cd(BaselineChoice);
                    [data, sampFreq, tmp, chanNum] = readhtk (sprintf('%s.htk',varName1));
                    handles.ecogBaseline.data(c,:,:)=mean(data',2);                    
                    handles.ecogBaseline.mean(c,:)=mean(data,2);
                    handles.ecogBaseline.std(c,:)=std(data,[],2);
                end
            end
            handles.ecogBaseline.sampFreq=sampFreq;
            cd( handles.MainPath)
        end
        
        
        
        function segmentedDataEvents40band(handles,subsetLabel,segmentTimeWindow,saveflag, trialnum,output,freqband)
        %% LOAD TIMESEGMENTS FROM ECOG DATA ON DISK
        %  INPUTS: subsetLabel= index (from AllConditions file) of event you want to segment by (each cell array specifies different segmentation group) ex {[2],[3]}       
                               % optional: second row is event to sort by ex {[2;3]}
                               %           third row specifies to what type
                               %           of event the event must belong to 
        %          segmentTimeWindow= pre and post buffer time (ms) around event(one cell corresponds to each subsetLabel) ex. {[500 1000].[500 1000]}
        %          trialnum= max number of trials to load (if empty, load all)
        %          saveflag= specifies what to do with extracted data
        %                   ex. 'keep' store in handle
        %                       'save' save to disk
        %          output= data form to be extracted 
        %                  ex. 'aa' extracts Analytic Amplitude (default)
        %                      'phase' extracts phase info
        %                      'complex' extracts complex values
        %          freqband= frequency bands to extract
        %                  ex. 31:38 is high gamma range (default)
        %                      1:40 is all frequency bands
        % OUTPUT:  each event stored in separate array under handles.segmentedEcog
%                    handles.segmentedEcog(1).data= channels x time x frequency
%                    bands x trials
%                    handles.segmentedEcog(1).event= event info for each trial                   
            if nargin<6
                output='aa';
            end
            
            if nargin<4
                saveflag='na'
            end            
            
            if nargin<7
                freqband=1:40;
            elseif isequal(freqband, [31:38])
                freqband=1;
            end
            
            handles.eventParams.subsetLabel=subsetLabel;
            handles.eventParams.segmentTimeWindow=segmentTimeWindow;
            load([handles.MainPath '/Analog/allEventTimes.mat'])
            load([handles.MainPath '/Analog/allConditions.mat'])            
            
            %DISCARD TRIALS THAT OVERLAP WITH BAD TIME SEGMENTS
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
                %% FIND EVENT TIMES FROM TRIALLOG
                curevent=allConditions(unique(handles.eventParams.subsetLabel{i}(1,:)));
                p3=find(ismember(allEventTimes(:,2),curevent));                
                if size(handles.eventParams.subsetLabel{i},1)>2
                    try
                        pidx=find(ismember(allEventTimes(p3,3),allConditions(unique(handles.eventParams.subsetLabel{i}(3,:)))));
                        if ~isempty(pidx)
                            p3=p3(pidx);
                        end
                    catch
                        
                    end
                end
                if nargin<5
                elseif isempty(trialnum)
                    trialnum=length(p3);                    
                end
                buffer=handles.eventParams.segmentTimeWindow{i};
                
                %% PRE-ALLOCATE SPACE FOR DATA
                switch saveflag
                    case 'save'
                        handles.segmentedEcog(i).data=NaN(handles.channelsTot,ceil((sum(buffer)/1000)*handles.Params.sampFreq),40,2);
                        dest=sprintf('%s/segmented_40band/event%s_%i_%i',handles.MainPath,int2str(unique(subsetLabel{i}(1,:))),buffer(1),buffer(2));
                        mkdir(dest);
                        cd(dest)
                    case 'skip'%'keep'                        
                        if strcmp(output,'analog')
                            handles.segmentedEcog(i).analog=zeros(handles.channelsTot,ceil((sum(buffer)/1000)*handles.Params.sampFreq),length(freqband),trialnum);
                        else
                            handles.segmentedEcog(i).analog=zeros(2,ceil((sum(buffer)/1000)*handles.Params.sampFreq),1,trialnum);                            
                            
                            handles.segmentedEcog(i).data=zeros(handles.channelsTot,ceil((sum(buffer)/1000)*handles.Params.sampFreq),length(freqband),trialnum);
                        end
                        handles.segmentedEcog(i).event=cell(trialnum,2);                        
                    otherwise
                end
                
                %% LOAD DATA FROM DISK ONE CHANNEL AND ONE TRIAL AT A TIME
                for c= 1:length(handles.usechans)
                    chanNum=handles.usechans(c);
                    printf('%i.',chanNum);
                    for s=1:trialnum
                        timeInt=[allEventTimes{p3(s),1}*1000-buffer(1) allEventTimes{p3(s),1}*1000+buffer(2)];                        
                        %delete bad time seg
                        for badsegidx=1:size(handles.Artifacts.badTimeSegments,1)
                            if (timeInt(1)>handles.Artifacts.badTimeSegments(1) & timeInt(1)<handles.Artifacts.badTimeSegments(2)) | (timeInt(2)>handles.Artifacts.badTimeSegments(1) & timeInt(1)<handles.Artifacts.badTimeSegments(2))
                                continue
                            end
                        end                      
                        
                        if strcmp(output,'analog')
                            cd([handles.MainPath '/Analog'])
                            data2=readhtk(['ANIN' int2str(chanNum) '_400Hz.htk'],round(timeInt));
                        elseif isequal(freqband, 1)
                            cd(handles.Filepath)
                            data=loadHTKtoEcog_onechan(chanNum,round(timeInt));
                        else
                            [R,I]=loadHTKtoEcog_onechan_complex_real_imag(handles.MainPath,chanNum,timeInt);
                            data=complex(R,I);
                        end
                        switch saveflag
                            case 'save'
                                mkdir([dest '/Chan' int2str(chanNum)]);
                                cd([dest filesep 'Chan' int2str(chanNum)])
                                writehtk(['t' int2str(s) '.htk'],data',allEventTimes{p3(s),1}*1000,find(strcmp(allConditions,allEventTimes{p3(s),2})));                                
                                if chanNum==1
                                    if find(strcmp(allEventTimes{p3(s)+1,2},unique(allConditions(handles.eventParams.subsetLabel{i}(2,:)))))
                                        handles.segmentedEcog(i).event(s,1:4)=[allEventTimes(p3(s),1:2)  allEventTimes{p3(s)+1,1} allEventTimes{p3(s)-1,2}];
                                    else
                                        handles.segmentedEcog(i).event(s,1:4)=[allEventTimes(p3(s),1:2) 0 0];
                                    end
                                end
                            case 'keep'
                                if c==1
                                    cd([handles.MainPath '/Analog'])
                                    [an1,f]=readhtk(['ANIN1.htk'],round(timeInt));
                                    handles.segmentedEcog(i).analog(1,:,:,s)=resample(an1,400,round(f));
                                    [an2,f]=readhtk(['ANIN2.htk'],round(timeInt));
                                    handles.segmentedEcog(i).analog(2,:,:,s)=resample(an2,400,round(f));
                                    handles.segmentedEcog(i).analog24Hz(1,:,1,s)=an1;         
                                    handles.segmentedEcog(i).analog24Hz(2,:,1,s)=an2;                            


                                    if 1%find(strcmp(allEventTimes{p3(s)+1,2},unique(allConditions(handles.eventParams.subsetLabel{i}(2,:)))))
                                    %%GET EVENT INFORMATION    
                                        handles.segmentedEcog(i).event(s,1:4)=[allEventTimes(p3(s),1:2)  0 0 ];
                                        curset=allEventTimes(p3(s),3);
                                        sortbyword=unique(allConditions(handles.eventParams.subsetLabel{i}(2,:)));                                        
                                        position=5;
                                        for ii=-5:6
                                            try
                                                newset=allEventTimes(p3(s)+ii,2);
                                            catch
                                                newset='none';
                                            end
                                            try
                                                if strmatch(allEventTimes(p3(s)+ii,3),curset)
                                                    handles.segmentedEcog(i).event(s,position:position+1)=[allEventTimes(p3(s)+ii,1:2)];
                                                    if strmatch(sortbyword,newset,'exact') & ii>0
                                                        handles.segmentedEcog(i).event(s,3:4)=[allEventTimes(p3(s)+ii,1:2)];
                                                    end
                                                    position=position+2;
                                                elseif  strmatch(sortbyword,newset,'exact')
                                                    handles.segmentedEcog(i).event(s,3:4)=[allEventTimes(p3(s)+ii,1:2)];
                                                end
                                            end
                                        end
                                        handles.segmentedEcog(i).event(s,:);
                                    end
                                end
                                
                                if find(strcmp(output,'aa'))
                                    try
                                        if isequal(freqband, [31:38])
                                            handles.segmentedEcog(i).data(c,:,:,s)=mean(abs(data)',2);
                                        else
                                            handles.segmentedEcog(i).data(c,:,:,s)=abs(data(freqband,:))';
                                        end
                                    end
                                end
                                
                                if find(strcmp(output,'phase'))
                                    handles.segmentedEcog(i).phase(c,:,:,s)=angle(data(freqband,:))';
                                end
                                
                                if find(strcmp(output,'analog'))
                                    handles.segmentedEcog(i).analog(c,:,:,s)=data2';
                                end
                                
                                if find(strcmp(output,'complex'))
                                    handles.segmentedEcog(i).phase(c,:,:,s)=data(freqband,:)';
                                end              
                            otherwise
                        end
                        
                    end 
                end
                
                %% SORT TRIALS BY SPECIFIED EVENT 
                try
                    sorttrials=handles.Params.sorttrials;
                catch
                    sorttrials=1;
                end
                
                if sorttrials==1 & size(handles.eventParams.subsetLabel{i},1)<=2
                    rt=cell2mat(handles.segmentedEcog(i).event(:,3))-cell2mat(handles.segmentedEcog(i).event(:,1));
                    [~,sortidx]=sort(rt);
                    handles.segmentedEcog(i).rt=rt(sortidx);
                    handles.segmentedEcog(i).data=handles.segmentedEcog(i).data(:,:,:,sortidx);
                    handles.segmentedEcog(i).event=handles.segmentedEcog(i).event(sortidx,:);
                    try
                        handles.segmentedEcog(i).analog=handles.segmentedEcog(i).analog(:,:,:,sortidx);
                    end
                    try
                        handles.segmentedEcog(i).rt2=cell2mat(handles.segmentedEcog(i).event(:,1))-cell2mat(handles.segmentedEcog(i).event(:,6));
                    end
                elseif sorttrials==1
                    load(['E:\DelayWord\EC22\EC22_B1/Analog/wordlength']);
                    for idx=1:length(handles.segmentedEcog(i).event(:,7))
                        try
                            tmp=strmatch(handles.segmentedEcog(i).event(idx,7),wordlength(:,1));
                            wl(idx)=wordlength{tmp,2};
                        end
                    end
                    [sortedwl,sortidx]=sort(wl);
                    handles.segmentedEcog(i).wl=wl(sortidx);
                    handles.segmentedEcog(i).data=handles.segmentedEcog(i).data(:,:,:,sortidx);
                    handles.segmentedEcog(i).event=handles.segmentedEcog(i).event(sortidx,:);
                    handles.segmentedEcog(i).rt=cell2mat(handles.segmentedEcog(i).event(:,3))-cell2mat(handles.segmentedEcog(i).event(:,1));
                    try
                        handles.segmentedEcog(i).rt2=cell2mat(handles.segmentedEcog(i).event(:,1))-cell2mat(handles.segmentedEcog(i).event(:,6));
                    end
                end
                trialnum=[];
            end
        end
        
        %%
        function plotData(handles,plottype,recalc)
            comparePlots='n';
            if strmatch(comparePlots,'y')
                colors={'k','g','m','b','c','r'};  
            else 
                colors={'k','k','k','k','k','k','k'};
            end
            handles.calcZscore
            handles.rejectExtremes
            if handles.Params.indplot==1;
                handles.makeIndPlots2([],plottype,[],[])
            else                
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
                                %plotBands=30:38;
                                plotBands=1;
                                for chanNum=1:handles.channelsTot
                                    zScore(chanNum,:)=mean(mean(handles.segmentedEcog(i).zscore_separate(chanNum,:,plotBands,:,:),4),3);
                                end
                            else
                                zScore=mean(mean(handles.segmentedEcog(i).zscore_separate,3),4);
                            end                            
                        case 'stacked'
                            zScore=squeeze(mean(handles.segmentedEcog(i).zscore_separate,3));
                        case 'spectrogram'                                                    
                            zScore=mean(handles.segmentedEcog(i).zscore_separate,4);
                        case 'image'
                            zScore=mean(handles.segmentedEcog(i).zscore_separate,4);                            
                    end                    
                    handles.makePlots(zScore,plottype,i,color)                    
                end
            end
        end
        
        
        function makePlots(handles,zScore,plottype,idx,color)
            
            eventSamp=handles.eventParams.segmentTimeWindow{idx}(1)*handles.Params.sampFreq/1000;
            badChannels=handles.Artifacts.badChannels;
            
            
            try
                gridlayout=handles.gridlayout.usechans;
                usechans=reshape(gridlayout',[1 size(gridlayout,1)*size(gridlayout,2)]);
                usechans=usechans(ismember(usechans,handles.usechans));
            end
            extra=handles.gridlayout.extra;
            
            rowtot=handles.gridlayout.dim(1);
            coltot=handles.gridlayout.dim(2);           
            
            maxZallchan=max(zScore,[],2);
            minZallchan=min(zScore,[],2);
            
            a=find(maxZallchan>.75);
            diff=maxZallchan-minZallchan;
            diff(badChannels)=NaN;
            maxdiff=max(diff);

            i=1;
            
            
            usetrials=1:size(handles.segmentedEcog(1).zscore_separate,4)                        
            r=input('Compare Trial Types? ([y]/n)\n','s');
            if ~strcmp('n',r)
                indices=handles.findTrials;
                usetrials=[indices.cond1 indices.cond2];
                

            else
                indices.cond1=usetrials;
%                 l=floor(length(usetrials)/2);
%                 indices.cond1=usetrials(1:l);
%                 indices.cond2=usetrials(l:end);
            end
            
            try
                r_time=handles.segmentedEcog(idx).rt(usetrials)*handles.Params.sampFreq;
            end
            
            
            
            while i<=length(usechans)
                epos=find(handles.gridlayout.usechans==usechans(i));
                m=floor(epos/coltot);
                n=rem(epos,coltot);
                if n==0
                    n=coltot;
                    m=m-1;
                end
                
                p(1)=6*(n-1)/100+.03;
                p(2)=6.2*(15-m)/100+0.01;
                p(3)=.055;
                p(4)=.055;            
                
                switch plottype
                    case 'line'
                        h=subplot('Position',p);                        
                        hp=plot(mean(mean(handles.segmentedEcog(1).zscore_separate(i,:,:,indices.cond1),3),4),'k');
                        hold on
                        try
                            hp=plot(mean(mean(handles.segmentedEcog(1).zscore_separate(i,:,:,indices.cond2),3),4),'r');
                        end

                        %axis([0 size(zScore,2) minZallchan(usechans(i)) minZallchan(usechans(i))+maxdiff]);
                        %hl=line([eventSamp,eventSamp],[minZallchan(usechans(i)), minZallchan(usechans(i))+maxdiff]);
                        hl=line([eventSamp,eventSamp],[0 5]);
                        
                        set(hl,'Color','r')
                        axis tight
                        ht=text(1,minZallchan(i)+maxdiff-0.1,num2str(usechans(i)));
                        set(h, 'ButtonDownFcn', @popupImage4)
                        hold on
                        
                    case 'stacked'
                        h=subplot('Position',p);
                        %hp=imagesc(squeeze(zScore(usechans(i),:,:))');
                        hp=imagesc(squeeze(mean(handles.segmentedEcog(idx).zscore_separate(i,:,:,usetrials),3))',[-1.5 1.5]);
                        ht=text(p(1),p(2),int2str(usechans(i)));
                        hold on
                        colormap(flipud(pink))
                        for col=[5 7 9 11 13 15]
                            try
                                plot(eventSamp+(cell2mat(handles.segmentedEcog(idx).event(usetrials,col))-cell2mat(handles.segmentedEcog(idx).event(usetrials,1)))*handles.Params.sampFreq,[1:size(zScore,3)],'r')
                            end
                        end
                        
%                         try
%                             plot([eventSamp+r_time],[1:size(zScore,3)],'k')
%                         end
                        plot([eventSamp eventSamp+.001],[0 size(zScore,3)],'k')
                        set(h, 'ButtonDownFcn', @popupImage4)                        
                    case 'spectrogram'                        
                        h=subplot('Position',p);                        
                        %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:)))'));
                        %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:))')));
                        hp=imagesc(flipud(squeeze(zScore(i,:,:))'),[-1.5 1.5]);                        
                        hold on
                        plot([eventSamp eventSamp+0.001],[0 size(zScore,2)],'r');
                        ht=text(p(1),p(2),int2str(usechans(i)));
                        colormap(flipud(pink))
                        set(h, 'ButtonDownFcn', @popupImage4)
                    case 'image'
                        if i==1
                            set(gcf,'Color','w')
                            ha = axes('units','normalized','position',[0 0 1 1]);
                            cd(['E:\General Patient Info\' handles.patientID])
                            imname=[pwd filesep 'brain+grid_3Drecon_cropped2.jpg']
                            [xy_org,img] = eCogImageRegister(imname,0);
                            G=real2rgb(img,'gray');
                            hi=imagesc(G);
                            %colormap(gray)
                            set(ha,'handlevisibility','off')
                            imgsize=size(img);
                            xy(1,:)=xy_org(1,:)/imgsize(2);
                            xy(2,:)=1-xy_org(2,:)/imgsize(1);
                            %axis([1000 3000 0 40])                            
                            %freezeColors
                        end
                        
                        xy_coord=xy(:,usechans(i));
                        ha=axes('position',[xy_coord(1),xy_coord(2),.03,.03]);                        
                        imagesc(flipud(squeeze(zScore(i,:,:))'),[-1.5 1.5])
                        %colormap(flipud(pink))
                        hl=line([2000 2000],[0 40]);
                        %set(gca,'XTick',[0:400:2400]);
                        %set(gca,'XTickLabel',[-3:1:3])
                        set(gca,'XTickLabel',[]);
                        set(gca,'YTickLabel',[]);
                        %set(gca,'Box','off');
                        set(gca,'visible','off');
                        axis([1500 3500 0 40])
                        text(900, 38,int2str(usechans(i)))
                    otherwise                        
                end
                %set(gca,'xtick',[],'ytick',[])
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
        
        function makeIndPlots(handles,zScore,plottype,idx,color)
            save_file='C:\Users\Angela_2\Documents\Presentations\DelayWordAutoImages4.ppt'
            powerpoint_object=SAVEPPT2(save_file,'init')
            h1=gcf;
            set(gcf,'Color','w')
            %colormap(flipud(pink))            
            h2=figure;
            set(gcf,'Color','w')            
            badChannels=handles.Artifacts.badChannels;            
            usechans=handles.usechans;
            extra=handles.gridlayout.extra;            
            rowtot=handles.gridlayout.dim(1);
            coltot=handles.gridlayout.dim(2);
            
            
            plotlist={'stacked','stacked','line','line','stacked','stacked','brainimage'};
            titleall={'slide','word onset','word offset','beep','response','line','brainimage'};            
            %             titleall={' ','theta stacked',...
            %                 'alpha stacked','beta stacked',...
            %                 'HG band ','averaged zscore','averaged zscore'};
            colors={'k','r','b','g','m'};
            eventname={'Word Onset','Response Onset','Word Offset','Beep Onset','Response Onset'}
            i=1;
            load('E:\DelayWord\frequencybands');
            freqbandsall={1:8,1:8,1:8,1:8,1:8,1:8,[]}            
            %freqbandsall={[],frequencybands.theta,frequencybands.alpha,frequencybands.beta,frequencybands.hg,[],[]}
            while i<=length(usechans)
                clf
                m=floor(i/coltot);
                n=rem(i,coltot);
                if n==0
                    n=coltot;
                    m=m-1;
                end
                for event=1:length(handles.eventParams.subsetLabel)
                    titleall{1}=['Ch' int2str(usechans(i)) ': ' eventname{event}  ]                    
                    zScore{event}=handles.segmentedEcog(event).zscore_separate;
                    eventSamp=handles.eventParams.segmentTimeWindow{event}(1)*handles.Params.sampFreq/1000;
                    badChannels=handles.Artifacts.badChannels;
                    try
                        handles.segmentedEcog(1).zscore_separate(:,:,:,handles.Artifacts.badtrials)=[];
                    end
                    try
                        r_time=handles.segmentedEcog(event).rt*400;
                    end
                    try
                        r_time2=handles.segmentedEcog(event).rt2*400;
                    end
                    try
                        usetrials=handles.segmentedEcog(event).usetrials{i};
                    catch
                        usetrials=size(handles.segmentedEcog(event).zscore_separate,4)
                        
                    end                    
                    try
                        r_time=r_time(usetrials);
                        r_time2=r_time2(usetrials);
                    end                    
                    
                    color=colors{event};
                    for pp=1:2%7
                        p=event+(pp-1)*2;
                        figure(h1)
                        freqbands=freqbandsall{p};
                        %                             if event==1
                        %                                 if mod(p,2)==1
                        %                                     plotnum=(p-1)+1;
                        %                                 else
                        %                                     plotnum=(p-1)+2;
                        %                                 end
                        %                             else
                        %                                 if mod(p,2)==1
                        %                                     plotnum=p+1;
                        %                                 else
                        %                                     plotnum=p+2;
                        %                                 end
                        %                             end
                        if p==8
                            figure(h2)
                        else
                            subplot(1,7,p)
                            %subplot(6,5,(p-1)*5+event);
                        end
                        plottype=plotlist{p};
                        switch plottype
                            case 'line'
                                hold off
                                l=floor(length(usetrials)/3);
                                tr=usetrials(1:l)
                                Y=squeeze(mean(mean(zScore{event}(i,:,:,tr),4),3));
                                E=std(mean(zScore{event}(i,:,frequencybands.theta,usetrials),4),[],3)/sqrt(length(usetrials));
                                [handl,handp]=errorarea(Y,E);
                                set(handl,'Color','r')
                                set(handp,'FaceColor','k')
                                %[amp,peak1]=max(Y(2000:4000));
                                %hp=plot(squeeze(mean(mean(zScore{event}(i,:,4:10,:),4),3)),'b');
                                %axis([0 size(zScore2{event},2) minZallchan(usechans(i)) minZallchan(usechans(i))+maxdiff]);
                                %hl=line([eventSamp,eventSamp],[minZallchan(usechans(i)), minZallchan(usechans(i))+maxdiff]);
                                hl=line([eventSamp,eventSamp],[-1 2]);
                                set(hl,'Color','k')
                                
                                %                                     try
                                %                                         mr=mean(r_time);
                                %                                         hl=line([eventSamp+mr,eventSamp+mr],[-1 2]);
                                %                                         set(hl,'Color','k')
                                %                                     end
                                %
                                %                                     try
                                %                                         mr=mean(r_time2);
                                %                                         hl=line([eventSamp-mr,eventSamp-mr],[-1 2]);
                                %                                         set(hl,'Color','k')
                                %                                     end
                                axis tight
                                %ht=text(1,minZallchan(usechans(i))+maxdiff-0.1,num2str(usechans(i)));
                                set(h, 'ButtonDownFcn', @popupImage4)
                                hold on
                                tr=usetrials(l:l*2)
                                Y=squeeze(mean(mean(zScore{event}(i,:,:,tr),4),3));
                                E=std(mean(zScore{event}(i,:,:,tr),4),[],3)/sqrt(length(tr));
                                [handl,handp]=errorarea(Y,E);
                                set(handl,'Color','g')
                                set(handp,'FaceColor','g')
                                
                                tr=usetrials(l*2:end)%
                                Y=squeeze(mean(mean(zScore{event}(i,:,:,tr),4),3));
                                E=std(mean(zScore{event}(i,:,:,tr),4),[],3)/sqrt(length(tr));
                                [handl,handp]=errorarea(Y,E);
                                set(handl,'Color','k')
                                set(handp,'FaceColor','k')
                                %
                                %                                     %hp=plot(squeeze(mean(mean(zScore{event}(i,:,30:38,:),4),3)),color);
                                %                                     %hold off
                                %                                     Y=squeeze(mean(mean(zScore{event}(i,:,frequencybands.hg,usetrials),4),3));
                                %                                     E=std(mean(zScore{event}(i,:,frequencybands.hg,usetrials),3),[],4)/sqrt(length(usetrials));
                                %                                     [handl,handp]=errorarea(Y,E);
                                %                                     set(handl,'Color','b')
                                %                                     set(handp,'FaceColor','b')
                                %
                                
                                
                                hold off
                                
                                %[amp2,peak2]=max(Y(2000:4000));
                                %title(int2str([peak2  peak1]))
                                title(titleall{p})
                            case 'stacked'
                                hp=imagesc(squeeze(mean(zScore{event}(i,:,freqbands,usetrials),3))',[-1.5 1.5]);
                                %ht=text(p(1),p(2),int2str(i));
                                hold on
                                %colormap(flipud(pink))
                                try
                                    plot([eventSamp+r_time],[1:length(usetrials)],'k')
                                end
                                
                                try
                                    plot([eventSamp-r_time2],[1:length(usetrials)],'k')
                                end
                                plot([eventSamp eventSamp+.001],[0 length(usetrials)],'k')
                                title(titleall{p})
                                
                                set(h, 'ButtonDownFcn', @popupImage4)
                            case 'spectrogram'
                                %colormap(flipud(pink))
                                
                                %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:)))'));
                                %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:))')));
                                hp=imagesc(flipud(squeeze(mean(zScore{event}(i,:,:,usetrials),4))'),[-1.2 1.2]);
                                
                                hold on
                                plot([eventSamp eventSamp+0.001],[0 size(zScore{event},2)],'k');
                                %ht=title(int2str(usechans(i)));
                                %colormap(winter)
                                set(h, 'ButtonDownFcn', @popupImage4)
                                title(titleall{p})
         
                                try
                                    mr=mean(r_time);
                                    hl=line([eventSamp+mr,eventSamp+mr],[0 40]);
                                    set(hl,'Color','k')
                                end
                                
                                try
                                    mr=mean(r_time2);
                                    hl=line([eventSamp-mr,eventSamp-mr],[0 40]);
                                    set(hl,'Color','k')
                                end
                            case 'brainimage'
                                visualizeGrid(2,['E:\General Patient Info\' handles.patientID '\brain+grid_3Drecon_cropped.jpg'],usechans(i))
                            otherwise
                                
                        end
                        set(gcf,'Name',int2str(usechans(i)));
                        if p==6
                            set(gca,'xtick',[200:400:size(zScore{event},2)],'ytick',[-1:2])
                            set(gca,'xticklabel',[-2:1:2],'yticklabel',[-1:2])
                        else
                            set(gca,'xtick',[],'ytick',[])
                            
                        end
                        
                        if find(ismember(badChannels,usechans(i)))
                            try
                                set(ht,'BackgroundColor','y')
                            end
                        end
                    end                 
                end
                
                saveppt2('ppt',powerpoint_object,'scale',true,'stretch',false,'Padding',[0 0 0 0]);                
                %figure(h2)
                %visualizeGrid(2,['E:\General Patient Info\' handles.patientID '\brain+grid_3Drecon_cropped.jpg'],usechans(i))
                %SAVEPPT2('ppt',powerpoint_object);
                %pause(1)
                i=i+1;                
                figure(h1)                
                if i>length(usechans) & extra~=0
                    figure
                    i=1;
                    usechans=extra;
                end
                %print -dmeta                
                %keyboard                
                input('next')
                %{
               saveas(gcf,['E:\DelayWord\Images\' handles.patientID '_allplots_SE_WO_aud_-500to1500ms_ch' int2str(usechans(i))],'fig')
               return
                %}
            end
        end
        
        %%
       function makeIndPlots2(handles,zScore,plottype,idx,color)
            %save_file='C:\Users\Angela_2\Documents\Presentations\DelayWordAutoImages4.ppt'
            %powerpoint_object=SAVEPPT2(save_file,'init')
            h1=gcf;
            set(gcf,'Color','w')
            %colormap(flipud(pink))
            h2=figure;
            set(gcf,'Color','w')
            
            badChannels=handles.Artifacts.badChannels;
            
            usechans=handles.usechans;
            extra=handles.gridlayout.extra;
            
            rowtot=handles.gridlayout.dim(1);
            coltot=handles.gridlayout.dim(2);            
            
            plotlist={'stacked','stacked','stacked','stacked','stacked','spectrogram','brainimage'};
            titleall={'slide','word onset','word offset','beep','response onset to response off','beep','response','line','brainimage'};
            colors={'k','r','b','g','m'};
            eventname={'slide','Word Onset','Word Offset','Beep Onset','Response Onset','Response offset'};
            i=1;
            load('E:\DelayWord\frequencybands');
            %freqbandsall={1:8,1:8,1:8,1:8,1:8,1:8,[]}
            freqbandsall={1,1,1,1,1,1,1,1};
            %freqbandsall={frequencybands.beta,frequencybands.beta,frequencybands.beta,frequencybands.beta,frequencybands.beta,frequencybands.alpha,[]}
            usetrials=1:size(handles.segmentedEcog(1).zscore_separate,4)                        
            r=input('Compare Trial Types? ([y]/n)\n','s');
            if ~strcmp('n',r)
                indices=handles.findTrials;
            else
                l=floor(length(usetrials)/2);
                indices.cond1=usetrials(1:l);
                indices.cond2=usetrials(l:end);
            end
            
            
            while i<=length(usechans)
                clf
                m=floor(i/coltot);
                n=rem(i,coltot);
                if n==0
                    n=coltot;
                    m=m-1;
                end
                for event=1:length(handles.eventParams.subsetLabel)
                    titleall{1}=['Ch' int2str(usechans(i)) ': ' eventname{event}  ]
                    
                    zScore{event}=handles.segmentedEcog(event).zscore_separate;
                    eventSamp=handles.eventParams.segmentTimeWindow{event}(1)*handles.Params.sampFreq/1000;
                    badChannels=handles.Artifacts.badChannels;
                    try
                        handles.segmentedEcog(1).zscore_separate(:,:,:,handles.Artifacts.badtrials)=[];
                    end
                    try
                        r_time=handles.segmentedEcog(event).rt*400;
                    end
                    try
                        r_time2=handles.segmentedEcog(event).rt2*400;
                    end
                 

                    try
                        r_time=r_time(usetrials);
                        r_time2=r_time2(usetrials);
                    end                    
                    
                    color=colors{event};
                    for pp=1%:7
                        p=event+(pp-1)*2;
                        figure(h1)
                        freqbands=freqbandsall{p};
                        
                        plottype=plotlist{p};
                        switch plottype
                            case 'line'
                                hold off                                
                                Y=squeeze(mean(mean(zScore{event}(i,:,:,indices.cond1),4),3));
                                E=std(mean(zScore{event}(i,:,frequencybands.theta,usetrials(indices.cond1)),4),[],3)/sqrt(length(usetrials(indices.cond1)));
                                [handl,handp]=errorarea(Y,E);
                                set(handl,'Color','r');
                                set(handp,'FaceColor','k');
                                hl=line([eventSamp,eventSamp],[-1 2]);
                                set(hl,'Color','k');
                                axis tight
                                hold on
                                Y=squeeze(mean(mean(zScore{event}(i,:,:,indices.cond2),4),3));
                                E=std(mean(zScore{event}(i,:,requencybands.theta,usetrials(indices.cond2)),4),[],3)/sqrt(length(indices.cond2));
                                [handl,handp]=errorarea(Y,E);
                                set(handl,'Color','g');
                                set(handp,'FaceColor','g');                               
                           case 'stacked'
                                subplot(5,5,[1:4 6:8 11:13]);
                                hold off
                                hp=imagesc(squeeze(mean(zScore{event}(i,:,freqbands,usetrials),3))');
                                data=get(hp,'CData');
                                hold on
                                %colormap(flipud(pink))
                                try
                                    plot([eventSamp+r_time],[1:length(usetrials)],'k','LineWidth',2);
                                end
                                
                                try
                                    plot([eventSamp-r_time2],[1:length(usetrials)],'k','LineWidth',2);
                                end
                                plot([eventSamp eventSamp+.001],[0 length(usetrials)],'k','LineWidth',2);
                                title(titleall{p});  
                                subplot(5,5,[5,10,15]);
                                plot(mean(data,2),1:length(usetrials));
                                axis([-1 2 1 length(usetrials)]);
                                subplot(5,5,[16:19 21:24]); 
                                [hl,hp]=errorarea(mean(data(indices.cond1,:),1),std(data(indices.cond1,:)./sqrt(length(indices.cond1)),[],1));
                                set(hl,'Color','b');
                                set(hp,'FaceColor','b');                                
                                hold on
                                [hl,hp]=errorarea(mean(data(indices.cond2,:),1),std(data(indices.cond2,:)./sqrt(length(indices.cond2)),[],1));
                                set(hl,'Color','r');
                                set(hp,'FaceColor','r');                                
                                
                                hl=line([eventSamp,eventSamp],[-1 2]);
                                set(hl,'Color','k');
                                axis tight
                                hold off
                               set(h, 'ButtonDownFcn', @popupImage4)
                            case 'spectrogram'
                                %colormap(flipud(pink))
                                
                                %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:)))'));
                                %hp=imagesc(mapstd(flipud(squeeze(zScore(usechans(i),:,:))')));
                                hp=imagesc(flipud(squeeze(mean(zScore{event}(i,:,:,usetrials),4))'),[-1.2 1.2]);
                                hold on
                                plot([eventSamp eventSamp+0.001],[0 size(zScore{event},2)],'k');                                
                                set(gca,'xtick',[0:400:size(zScore{event},2)],'ytick',[1:40]);
                                set(gca,'xticklabel',-2:1:2);                              
                                set(gca,'YTickLabel',flipud(frequencybands.cfs));
                                colorbar    ;                            
                                %ht=title(int2str(usechans(i)));
                                %colormap(winter)
                                set(h, 'ButtonDownFcn', @popupImage4)
                                title(titleall{p})
                                try
                                    mr=mean(r_time);
                                    hl=line([eventSamp+mr,eventSamp+mr],[0 40]);
                                    set(hl,'Color','k');
                                end
                                
                                try
                                    mr=mean(r_time2);
                                    hl=line([eventSamp-mr,eventSamp-mr],[0 40]);
                                    set(hl,'Color','k');
                                end
                            case 'brainimage'
                                visualizeGrid(2,['E:\General Patient Info\' handles.patientID '\brain+grid_3Drecon_cropped.jpg'],usechans(i))
                            otherwise
                                
                        end
                        set(gcf,'Name',int2str([usechans(i) event]));
                        
                        if p==6
                            set(gca,'xtick',[0:400:size(zScore{event},2)],'ytick',[-1:2])
                            set(gca,'xticklabel',[-2:1:2],'yticklabel',[-1:2])
                        else
                            %set(gca,'xtick',[],'ytick',[])
                            
                        end                        
                        if find(ismember(badChannels,usechans(i)))
                            try
                                set(ht,'BackgroundColor','y')
                            end
                        end
                    end                   
                    %saveppt2('ppt',powerpoint_object,'scale',true,'stretch',false,'Padding',[0 0 0 0]);                    
                end                
                %saveppt2('ppt',powerpoint_object,'scale',true,'stretch',false,'Padding',[0 0 0 0]);
                
                %subplot(4,4,[1:4 4:8 9:12])
                %figure(h2)
                %visualizeGrid(2,['E:\General Patient Info\' handles.patientID '\brain+grid_3Drecon_cropped.jpg'],usechans(i))
                %SAVEPPT2('ppt',powerpoint_object);
                %pause(1)
                i=i+1;                
                figure(h1)                
                if i>length(usechans) & extra~=0
                    figure
                    i=1;
                    usechans=extra;
                end
                %print -dmeta                
                %keyboard                
                r=input('next','s')
                if strcmp(r,'b')
                    i=i-2;
                end
                %{
               saveas(gcf,['E:\DelayWord\Images\' handles.patientID '_allplots_SE_WO_aud_-500to1500ms_ch' int2str(usechans(i))],'fig')
               return
                %}                
            end
       end
        
        
        function listConditions(handles)
        %% LIST CONDITIONS FOR THIS BLOCK    
            cd([handles.MainPath '/Analog'])
            load allConditions
            for i=1:length(allConditions)
                printf('%i. %s',i,allConditions{i});
            end
            cd([handles.MainPath '/Analog'])
        end
        
        
        function calcZscore(handles)
        %% CALCULATE ZSCORE USING BASELINE SPEFICIED    
            for i=1:length(handles.segmentedEcog)
                datalength=size(handles.segmentedEcog(1).data,2);
                switch handles.BaselineChoice
                    case'PreEvent'
                        %Use 300 ms before each event for baseline
                        samples=[ceil(handles.Params.baselineMS(1)*4/10):floor(handles.Params.baselineMS(2)*4/10)];%This can be changed to adjust time used for baseline
                        Baseline=handles.segmentedEcog(i).data(:,samples,:,:);
                        meanOfBaseline=repmat(mean(Baseline,2),[1, datalength,1,1]);
                        stdOfBaseline=repmat(std(Baseline,0,2),[1,datalength,1, 1]);
                        
                    case 'RestEnd'
                        %Use resting at end for baseline
                        handles.ecogBaseline.data=handles.ecogBaseline.data(:,round(handles.baselineMS(1)*handles.sampFreq/1000:handles.baselineMS(2)*handles.sampFreq/1000),:,:);
                        meanOfBaseline=repmat(mean(handles.ecogBaseline.data,2),[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                        stdOfBaseline=repmat(std(handles.ecogBaseline.data,0,2),[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                        
                    case 'none' %if strmatch('RestBlock',handles.BaselineChoice)
                        if ~isfield('mean',handles.ecogBaseline)
                            handles.ecogBaseline.mean=mean(mean(handles.segmentedEcog(i).data,4),2);
                            handles.ecogBaseline.std=std(std(handles.segmentedEcog(i).data,[],4),[],2);
                        end
                        
                        meanOfBaseline=repmat(handles.ecogBaseline.mean,[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                        stdOfBaseline=repmat(handles.ecogBaseline.mean,[1, datalength,1,size(handles.segmentedEcog(i).data,4)]);
                        
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
                
       
        function rejectExtremes(handles)
        %% REJECT TRIALS WITH DATA EXTREMES
            for event=1:length(handles.segmentedEcog)
                for c=1:handles.channelsTot
                    chanNum=c;
                    %chanNum=handles.usechans(c);
                    usetrials=[];
                    tmp=squeeze(mean(handles.segmentedEcog(event).zscore_separate(chanNum,:,:,:),3));
                    [a,badt]=find(tmp>7);
                    usetrials=setdiff(1:size(handles.segmentedEcog(event).zscore_separate(chanNum,:,:,:),4),unique(badt));
                    handles.segmentedEcog(event).usetrials{chanNum}=usetrials;
                end
            end
        end
        
        
        function resetCLimPlot(handles)
            %% RESET AXES OF PLOTS
            bad=zeros(1,256);
            hplots=get(gcf,'Children');
            for  chanNum=1:256
                set(hplots(chanNum),'YTickLabel',[])
                set(hplots(chanNum),'CLim',[-1.2 3])
                try
                    c2=get(hplots(chanNum),'Children');
                    data=get(c2(10),'CData');
                    tmp=prctile(data,.8,2);                    
                    %tmp=max(data,[],2);
                    p=prctile(tmp,.8);
                    try
                        set(hplots(chanNum),'CLim',[-p p]);
                        
                        %set(hplots(chanNum),'CLim',[-1.5 3]);
                    catch
                        bad(chanNum)=1;
                        assignin('base','bad',bad)
                    end
                    k=kurtosis(reshape(data,[1 size(data,1)*size(data,2)]));
                    if 0%k>5 | isnan(k)
                        cla(hplots(chanNum));                        
                        %hold off
                        %set(c2(10),'CData',10000);
                        %plot(1000,1000)
                        set(hplots(chanNum),'Color','w');
                        set(hplots(chanNum),'Box','off')
                        set(hplots(chanNum),'Visible','off')                        
                        %set(hplots(chanNum),'Children',[]);
                    end                    
                    colormap(jet)
                    %colormap(flipud(pink))
                    %set(hplots(chanNum),'CLim',[-2 2]);
                    %set(hplots(chanNum),'CLimMod','auto');                    
                    set(hplots(chanNum),'XTickLabel',[]);
                    set(hplots(chanNum),'YTickLabel',[]);                    
                    %             tmp=get(hplots(chanNum),'Children')
                    %             set(tmp(1),'Color','k')
                    %             set(tmp(1),'LineWidth',.1)
                    %             set(tmp(1),'LineStyle','-')
                    %
                    %              set(tmp(2),'AlphaData',1)
                end
            end
        end
        
           function indices=findTrials(handles)
                 Labels=handles.segmentedEcog(1).event(:,8);
                 load('E:\DelayWord\brocawords');
                 
                 r=input('Compare:\n 1. short vs long\n 2. easy vs difficult\n 3. frequent vs infrequent\n','s');
                 if ~strcmp(r,'1')
                     r2=input('Use long words only? (y/[n])','s');
                 else 
                     r2='n';
                 end
                 
                 for i=1:length(Labels)
                    try
                        wordidx=find(strcmp(Labels{i},{brocawords.names}));
                        all_label1(i)=find(strcmp({'','','','short','long'},brocawords(wordidx).lengthtype));
                        all_label2(i)=find(strcmp({'easy','','hard'},brocawords(wordidx).difficulty));
                        all_label3(i)=brocawords(wordidx).logfreq_HAL;
                        all_label4(i)=wordidx;
                    catch
                        wordidx=NaN;
                        all_label4(i)=wordidx;
                    end
                 end                              
                %select only long words
                
                if strcmp(r2,'y')
                    useidx=find(all_label1==5)%only long words
                else
                    useidx=1:length(all_label1);
                end               
                                 
                switch r
                    case '1'
                        all_label=all_label1(useidx);
                        conditions=[4 5];
                    case '2'                        
                        all_label=all_label2(useidx);
                        conditions=[1 3];
                    case '3'
                        all_label(find(all_label3(useidx)<8))=2;%frequent vs less frequent
                        all_label(find(all_label3(useidx)>9))=1;
                        conditions=[1 2];
                    otherwise
                        all_label=all_label1(useidx);
                        conditions=[4 5];
                end
                
                r3=input('Equal number in 2 groups?(y/[n])\n','s')
                if strcmp(r3,'y')
                    count=30;
                    cont=0;
                    while cont==0
                        useidx2=[find(all_label==conditions(1),count)  find(all_label==conditions(2),count)]%get 50/50 in training/test sets
                        if length(find(all_label(useidx)==conditions(1)))>=count & length(find(all_label(useidx)>=conditions(2)))>=count
                            cont=1;
                        else 
                            count=count-1;
                        end
                    end
                else
                    useidx2=1:size(all_label,2);
                end
                all_label=all_label(useidx2);
                
                indices.cond1=useidx(find(all_label==1 | all_label==4));
                indices.cond2=useidx(find(all_label==2 | all_label==3 | all_label==5 ));   
                Labels([indices.cond1 indices.cond2])
        end
    end
end


%%%

