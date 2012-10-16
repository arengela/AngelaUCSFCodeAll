classdef accessDatabase<handle
    %% SEARCHES TRIALNOTES AND DATA SERVER TO CREATE DATABASE 
    %% INSTRUCTIONS:
    %% INITIATE:                                D=accessDatabase;
    %% SEARCH FOR BLOCKS BY:                    [blocks,idx]=D.searchTrials('flag1',{'param1'},'flag2',{'param2'})
    %%                      SUBJECT ('s'):      [blocks,idx]=D.searchTrials('s',{'EC28','EC29'})
    %%                      TASK ('t'):         [blocks,idx]=D.searchTrials('t',{'Syllables'}) 
    %%                      EXCLUDE TASK ('u'): [blocks,idx]=D.searchTrials('u',{'Listen'})
    %%                                          note: search terms are case insensitive. 
    %%                                          You can combine the above search parameters ie
    %%                                          [blocks,idx]=D.searchTrials('s',{'EC28','EC29'},'t',{'Syllables'},'u',{'Listen'})
    %%                      OUTPUTS:            blocks= block ID
    %%                                          idx= index to handles.AllTrials 
    %% SEE PATIENT INFO:                        B.getSubjectInfo('EC22')
    %% GET NOTES FOR SPECIFIC BLOCKS            B.getBlockDetails({'EC28_B1','EC28_B2'})
    %%                                 
    properties
        %{
        InfoFolder='/data_store/human/PatientInfo';
        TDTBackupFolder='/data_store/human/raw_data/TDTbackup';
        RawDataFolder='/data_store/human/raw_data';
        ProcessedDataFolder='/data_store/human/prcsd_data'
        %}
        InfoFolder='C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info';
        TDTBackupFolder='E:\RawTDTData';
        RawDataFolder='E:\DelayWord';
        ProcessedDataFolder='E:\DelayWord'
        PreprocessingFileLogFolder
        MainPath
        AllSubjID
        AllTrials
        DataLog
        DailyNotes
    end
    
    methods
        function handles=accessDatabase(field1)
            %% Initiate database
            handles.getTrialnotes;
            if nargin>0
                if strcmp(field1,'u')
                    handles.getUserInput
                end  
            end     
        end
        
        function [blockNames,idx0,restBlocks,restIdx]=searchTrials(handles,field1,param1,field2,param2,field3,param3,field4,param4)
            %% Search for blocks by input parameters
            for i=1:(nargin-1)/2
                searchBy.(eval(['field' int2str(i)]))=eval(['param' int2str(i)]);
            end
            
            %Search by subject
            idx=[];
            idx0=1:length(handles.AllTrials);
            if isfield(searchBy,'s') 
                for i=1:length(searchBy.s)
                    idx=[idx idx0(find(strcmp(searchBy.s{i},handles.AllTrials(idx0,5))))];
                end
                idx0=idx;
                idx=[];
            end
            
            % Search by task
            if  isfield(searchBy,'t') 
                for i=1:length(searchBy.t)
                    idx=[idx idx0(find(~cellfun(@isempty,(regexpi(handles.AllTrials(idx0,2),searchBy.t{i},'match')))))];
                end
                idx0=idx;
                idx=[];
            end 
            
            % Do not include task
            if  isfield(searchBy,'n') 
                for i=1:length(searchBy.t)
                    idx=[idx idx0(find(~cellfun(@isempty,(regexpi(handles.AllTrials(idx0,2),searchBy.n{i},'match')))))];
                end
                idx0=setdiff(idx0,idx);
                idx=[];
            end 
            
            % search by day
            if  isfield(searchBy,'d') 
                for i=1:length(searchBy.d)
                    idx=[idx idx0(find(~cellfun(@isempty,(regexpi(handles.AllTrials(idx0,10),searchBy.d{i},'match')))))];
                end
                idx0=idx;
                idx=[];
            end 
            
            %get block names
            blockNames=handles.AllTrials(idx0,12);   
            if ~strcmp(searchBy.t,'Rest')
                [restBlocks,restIdx]=handles.getCorrespondingRest(blockNames);
            end
            display(handles.AllTrials(idx0,:));
        end
        
        function [restBlocks,restIdx]=getCorrespondingRest(handles,blocks)
            %% Get rest blocks that were recorded on same days as input blocks
            restIdx=[];
            for i=1:length(blocks)
                idx=find(strcmp(blocks{i},handles.AllTrials(:,12)));
                day=handles.AllTrials(idx,10);
                if ~isempty(day{1})
                    [b,idx2]=handles.searchTrials('t',{'Rest'},'d',day);
                else
                    idx2=0;
                end
                
                if isempty(idx2)
                    restIdx=[restIdx NaN];
                elseif length(idx2)>1
                    blockTime=datenum([handles.AllTrials{idx,10:11}]);
                    for i2=1:length(idx2)
                        restTimes(i2)=datenum([handles.AllTrials{idx2(i2),10:11}]);
                    end
                    idx2=idx2(findnearest(blockTime,restTimes));
                    restIdx=[restIdx idx2];
                else
                    restIdx=[restIdx idx2];
                end
            end
            
            for i=1:length(restIdx)
                if restIdx(i)==0 
                    restBlocks{i,1}='unknown';
                elseif isnan(restIdx(i))
                    restBlocks{i,1}='none';
                else
                    restBlocks{i,1}=handles.AllTrials{restIdx(i),12};
                end
            end
        end

        function getUserInput(handles)
            %% Walk user through 
            r=input('What would you like to do?\n1.Display Summary\n2.Get Subject Info\n3.Get Tasks\n','s');
            switch r
                case '1'
                case '2'
                    subjID=input('Subject ID?\n','s');
                    getSubjectInfo(handles,subjID);
                case '3'
                    taskName=input('Task name?','s');
                    tmp=regexpi(handles.AllTrials(:,2),taskName,'match');
                    idx=find(~cellfun(@isempty,tmp));
                    display(handles.AllTrials(idx,1:3))
                case '4'
            end
        end

        function getTrialnotes(handles)
        %% Get trial notes for all subjects and store in handle
            d=dir(handles.InfoFolder);
            subj={d.name};
            subj=subj(3:end);
            
            %Extract each subj's notes from trial notes files
            for i=1:20%1:length(subj)
                try
                    cd([handles.InfoFolder filesep subj{i}])
                    [num,txt]=xlsread([subj{i} '_trialnotes_database']);  
                    raw(i).data=cell(length(num),12);
                    raw(i).data(:,1)=num2cell(num(:,1));%change to column 2 for linux (weird, I know)
                    l=length(txt(:,4:10));
                    raw(i).data(1:l,2:9)=txt(:,3:10);
                    raw(i).data(:,5)=subj(i);
                    dayNotes(i).data=txt(:,1);
                end
            end
            handles.AllTrials=vertcat(raw.data);    
            handles.AllSubjID=unique(handles.AllTrials(find(~cellfun(@isempty,handles.AllTrials(:,5))),5));
            
            % Get notes from each day's recording
            tmp=vertcat(dayNotes.data);
            dateIdx=[];
            for i=1:length(tmp)
                if ~isempty(tmp{i})
                    try
                        d=datevec(tmp{i});
                        dateIdx=[dateIdx i];
                    catch
                    end
                end
            end
            dateIdx(end+1)=length(tmp)+1;
            
            %Store date of recording for each block
            for i=1:length(dateIdx)-1
                d=datevec(tmp{dateIdx(i)});
                for j=dateIdx(i):dateIdx(i+1)-1
                    handles.AllTrials{j,10}=datestr(datenum(d),'mm/dd/yy HH:MM:SS:PM');
                end
            end

            %Store daily notes in handles
            for i=1:length(dateIdx)-1
                  d=datevec(tmp{dateIdx(i)});
                  handles.DailyNotes(i).day=datestr(datenum(d),'mm/dd/yy HH:MM:SS:PM');
                  handles.DailyNotes(i).subj=handles.AllTrials{dateIdx(i),5};
                  try
                        handles.DailyNotes(i).notes={tmp{dateIdx(i)+1:dateIdx(i+1)-1}}';
                  catch
                        handles.DailyNotes(i).notes=tmp{dateIdx(i)+1:end};  
                  end
            end 
            handles.AllTrials(:,12)=strcat(handles.AllTrials(:,5),'_B',cellfun(@num2str,handles.AllTrials(:,1),'UniformOutput',0));

        end

        function getSubjectInfo(handles,subjID)
            %% Display recording info and files associated with subj
            handles.getRecordingConditions(subjID)
            handles.getSubjectFiles(subjID)
        end
        
        function getRecordingConditions(handles,subjID)
            %% Display general recording info for patient
            try
                [~,txt]=xlsread([handles.InfoFolder filesep subjID filesep subjID '_trialnotes_database'],'sheet2');
            catch
                [~,txt]=xlsread([handles.InfoFolder filesep subjID filesep subjID '_trialnotes_database'],'Subject Info');
            end
            display(txt);
        end

        function getSubjectFiles(handles,subjID)
            %% Display files associated with subj
            display(ls([handles.InfoFolder filesep subjID]))       
        end
        
        function getRecordingTimes(handles)
            %%  Get time of recording from TDT file info and put it in trial
            % notes
            %% Doesn't really word because TDT file dates got changed to the copy date.
            for i=1:length(handles.AllTrials)
                try
                    subj=handles.AllTrials{i,5};
                    block=[subj '_B' int2str(handles.AllTrials{i,1})];
                    d=dir([handles.TDTBackupFolder filesep subj filesep block]);
                    t=d(1).date;
                    tv=datevec(t);
                    handles.AllTrials{i,10}=datestr(datenum(tv(1),tv(2),tv(3)),'mm/dd/yy');
                    handles.AllTrials{i,11}=datestr(datenum(tv),'HH:MM:SS:PM');
                end                
            end
        end
        
        function getDataInfo(handles,subjID,folderChoice)
            %% Display blocks inside folder for specified subject
            folder={'TDTBackupFolder','RawDataFolder','ProcessedDataFolder'};            
            if nargin>1
                subj{1}=subjID;
            else 
                tmp=cellstr(handles.AllSubjID);
                subj=tmp(2:end)
            end
            if nargin<4
                folderChoice=1:3;
            end
            for i=1:length(subj)
                display(subj{i})
                for f=folderChoice
                    display(folder{f});
                    contents=dir([handles.(folder{f}) filesep subj{i}]);
                    contents=contents(3:end);
                    display([{contents.name}' {contents.date}' {contents.bytes}'])
                end
            end                           
        end
        
       	function [missingBlocks]=getAvailableBlockData(handles,blockChoices,folderChoice)
        %% Display folders available for each block
            folder={'TDTBackupFolder','RawDataFolder','ProcessedDataFolder'};  
            if nargin<3
                folderChoice=1:3;
            end
            missingBlocks=[];
            for i=1:length(blockChoices)
                [subj,b]=regexp(blockChoices{i},'_','split');  
                display(blockChoices{i})
                for j=1:3
                    display(folder{j})
                    contents=dir([handles.(folder{j}) filesep subj{1} filesep blockChoices{i}]);
                    display([{contents(3:end).name}' {contents(3:end).date}']);    
                    if isempty(contents)
                        missingBlocks={missingBlocks;blockChoices{i}};
                    end
                end
            end
        end

            
            
            
        function getBlockDetails(handles,blocks)
            %% Get details from trial notes about block
            for i=1:length(blocks)
                [subj,b]=regexp(blocks{i},'_','split');  
                tmp=regexp(subj{1},'[123456789]','match');
                blockNum=str2num(tmp{1})
                idx(i)=intersect(find(strcmp(subj{1},handles.AllTrials(:,5))), find(cell2mat(handles.AllTrials(:,1))==blockNum));     
            end
            display(handles.AllTrials(idx,:));
            
            %Get notes associated with that day's recording
            d=handles.AllTrials(idx,10)
            for i=1:length(d)
                try
                    notes(i).idx=find(~cellfun(@isempty,(strfind({handles.DailyNotes.day},d{i}))))
                end
            end
            idx=unique([notes.idx]);
            for i=1:length(idx)
                display(handles.DailyNotes(i).day)
                display(handles.DailyNotes(i).subj)
                display(handles.DailyNotes(i).notes)
            end     
        end
        
        function checkPreprocessing(handles,blocks)
            handles.DataLog=cell(length(blocks),7); 
        end
        
        function copyData(handles,blocks)
        end      
    end
end