classdef PLVtests < handle    
    properties
        AllFilePaths
        AllBaselinePaths
        SegmentTypes
        UserChoice
        EventIdx
        FilePath
        BaselinePath
        eventVariables
        ActiveCh
        SubjectID
        Data
        Output
        TaskType
    end
    
    methods
        function handles=PLVtests(n,e,ch,output,TaskType)   
        %INITIALIZES VARIABLES  
        %OPTIONAL INPUT: n= index to blockpath
        %%
            %paths of data blocks
            handles.AllFilePaths= {
                'E:\DelayWord\EC18\EC18_B1';
                'E:\DelayWord\EC18\EC18_B2';
                'E:\DelayWord\EC20\EC20_B18';
                'E:\DelayWord\EC20\EC20_B23';
                'E:\DelayWord\EC20\EC20_B54';
                'E:\DelayWord\EC20\EC20_B64';
                'E:\DelayWord\EC20\EC20_B67';
                'E:\DelayWord\EC21\EC21_B1';
                'E:\DelayWord\EC22\EC22_B1';
                'E:\DelayWord\EC23\EC23_B1';
                'E:\DelayWord\EC24\EC24_B1';
                'E:\DelayWord\EC24\EC24_B2';
                'E:\DelayWord\EC25\EC25_B1';
                '\data_store\human\prcsd_data\EC23\EC23_B1';
                'E:\PreprocessedFiles\EC26\EC26_B2';
                'C:\Users\ego\Documents\UCSF\EcogData\EC24\EC24_B1';
                'E:\DelayWord\EC16\EC16_B1';
                'E:\PreprocessedFiles\EC26\EC26_B6';
                'E:\PreprocessedFiles\EC26\EC26_B9';
                'E:\PreprocessedFiles\EC26\EC26_B12';
                'E:\PreprocessedFiles\EC26\EC26_B14';
                'E:\PreprocessedFiles\EC26\EC26_B18';
                'E:\PreprocessedFiles\EC26\EC26_B20';
                'E:\PreprocessedFiles\EC26\EC26_B23';
                'E:\PreprocessedFiles\EC26\EC26_B24';
                'E:\PreprocessedFiles\EC26\EC26_B26';
                'E:\PreprocessedFiles\EC26\EC26_B27';
                'E:\PreprocessedFiles\EC26\EC26_B28';
                'E:\PreprocessedFiles\EC26\EC26_B35';
                'E:\PreprocessedFiles\EC26\EC26_B36';
                'E:\DelayWord\EC23\EC23_with16CAR';
                'E:\DelayWord\EC23\EC23_withCARWholeGrid';
                'E:\DelayWord\EC18\EC18_16CAR';
                'E:\DelayWord\EC28\EC28_B5';
                'E:\DelayWord\EC28\EC28_B20'
                'E:\DelayWord\EC28\EC28_B22'
                'E:\DelayWord\EC28\EC28_B29'
                'E:\DelayWord\EC28\EC28_B49'
                'E:\DelayWord\EC28\EC28_B50'
                'E:\PreprocessedFiles\EC28\EC28_B33'
                'E:\PreprocessedFiles\EC28\EC28_B45'
                'E:\PreprocessedFiles\EC28\EC28_B33'
                'E:\DelayWord\EC29\EC29_B2'
                'E:\DelayWord\EC29\EC29_B4'
                'E:\DelayWord\EC30\EC30_B1'
                'E:\DelayWord\EC30\EC30_B2'
                'E:\DelayWord\EC31\EC31_B1'
                'C:\Users\ego\Documents\UCSF\EcogData\EC33\EC33_B5'
                }
            
            %path of associated baseline
            handles.AllBaselinePaths{1}='E:\DelayWord\EC18\EC18_rest'
            handles.AllBaselinePaths{2}='E:\DelayWord\EC18\EC18_rest'
            handles.AllBaselinePaths{3}='E:\DelayWord\EC20\EC20_B18'

            handles.AllBaselinePaths{8}=    'E:\DelayWord\EC21\EC21_B2';
            handles.AllBaselinePaths{9}='E:\DelayWord\EC22\EC22_B2'
            handles.AllBaselinePaths{10}= 'E:\DelayWord\EC23\EC23_B2';
            handles.AllBaselinePaths{11}='E:\DelayWord\EC24\EC24_B2'
            handles.AllBaselinePaths{12}='E:\DelayWord\EC24\EC24_B2'
            handles.AllBaselinePaths{14}= 'data_store\human\prcsd_data\EC23\EC23_B2';
             handles.AllBaselinePaths{15}='E:\PreprocessedFiles\EC26\EC26_B1';
            handles.AllBaselinePaths{16}= 'C:\Users\ego\Documents\UCSF\EcogData\EC24\EC24_B1';
            handles.AllBaselinePaths{17}= 'E:\DelayWord\EC16\EC16_rest';
            handles.AllBaselinePaths{18}= 'E:\PreprocessedFiles\EC26\EC26_B3';
            handles.AllBaselinePaths{19}= 'E:\PreprocessedFiles\EC26\EC26_B3';
            handles.AllBaselinePaths{20}= 'E:\PreprocessedFiles\EC26\EC26_B17';
            handles.AllBaselinePaths{21}= 'E:\PreprocessedFiles\EC26\EC26_B17'; 
            handles.AllBaselinePaths{22}= 'E:\PreprocessedFiles\EC26\EC26_B21';
            handles.AllBaselinePaths{23}= 'E:\PreprocessedFiles\EC26\EC26_B21';
            handles.AllBaselinePaths{24}= 'E:\PreprocessedFiles\EC26\EC26_B21';
            handles.AllBaselinePaths{25}= 'E:\PreprocessedFiles\EC26\EC26_B21';            
            handles.AllBaselinePaths{26}= 'E:\PreprocessedFiles\EC26\EC26_B32';
            handles.AllBaselinePaths{27}= 'E:\PreprocessedFiles\EC26\EC26_B32';
            handles.AllBaselinePaths{28}= 'E:\PreprocessedFiles\EC26\EC26_B38';
            handles.AllBaselinePaths{29}= 'E:\PreprocessedFiles\EC26\EC26_B38'; 
            handles.AllBaselinePaths{30}= 'E:\PreprocessedFiles\EC26\EC26_B38';            
            handles.AllBaselinePaths{31}= 'E:\DelayWord\EC23\EC23_B2';  
            handles.AllBaselinePaths{32}= 'E:\DelayWord\EC23\EC23_B2';
            handles.AllBaselinePaths{33}='E:\DelayWord\EC18\EC18_rest'
            handles.AllBaselinePaths{34}='E:\DelayWord\EC28\EC28_B2';
            handles.AllBaselinePaths{35}='E:\DelayWord\EC28\EC28_B17';
            handles.AllBaselinePaths{36}='E:\DelayWord\EC28\EC28_B17';
            handles.AllBaselinePaths{37}='E:\DelayWord\EC28\EC28_B17';
            handles.AllBaselinePaths{38}='E:\PreprocessedFiles\EC28\EC28_B44';
            handles.AllBaselinePaths{39}='E:\PreprocessedFiles\EC28\EC28_B44';
            handles.AllBaselinePaths{40}='E:\PreprocessedFiles\EC28\EC28_B33';
            handles.AllBaselinePaths{41}='E:\PreprocessedFiles\EC28\EC28_B44';
            handles.AllBaselinePaths{42}='E:\PreprocessedFiles\EC28\EC28_B35';
            handles.AllBaselinePaths{43}='E:\DelayWord\EC29\EC29_B3'
            handles.AllBaselinePaths{44}='E:\DelayWord\EC29\EC29_B3'
            handles.AllBaselinePaths{45}='E:\DelayWord\EC30\EC30_rest'
            handles.AllBaselinePaths{46}='E:\DelayWord\EC30\EC30_rest'
            handles.AllBaselinePaths{47}='E:\DelayWord\EC31\EC31_B1'
            handles.AllBaselinePaths{48}='C:\Users\ego\Documents\UCSF\EcogData\EC33\EC33_B4'


            %%
            lh=1:40%load all words            
            handles.SegmentTypes={[repmat([41],[1 length(lh)]);lh],[lh;repmat([42],[1 length(lh)])],...
                [repmat([42],[1 length(lh)]);lh],[repmat([43],[1 length(lh)]);lh],...
                [repmat([44],[1 length(lh)]);lh],[45;41],[1:50;1:50]};
            
           
             if nargin>=3
                 handles.Output=output;
             else
                 handles.Output='aa';
             end
             
            if nargin>0
                handles.ChooseBlock(n,ch);
            end
            
            if nargin<5
                handles.TaskType='DelayRep';
            else
                handles.TaskType='default';
            end
            
            handles.EventIdx=e;
            handles.LoadAllChans;


        end
        
        function ListBlocks(handles) 
        %%LISTS BLOCK PATHS    
            for i=1:length(handles.AllFilePaths)
                printf('%s. %s',num2str(i), handles.AllFilePaths{i})
            end
        end
            
        
        function ChooseBlock(handles,n,ch)
        %%CHOOSE WHICH BLOCK OF DATA TO LOAD    
            handles.UserChoice=n;
            handles.FilePath=handles.AllFilePaths{handles.UserChoice};
            try
                handles.BaselinePath=handles.AllBaselinePaths{handles.UserChoice};
            end
            [a,b,c]=fileparts(handles.FilePath);
            [a,b,c]=fileparts(a);
            handles.SubjectID=b;
            try           
                load('E:\DelayWord\areamap')
            end
            
            if ~isempty(ch)
                handles.ActiveCh=ch;
            elseif ~isempty(areamap(strcmp(b,{areamap.subj})).event(handles.EventIdx).allactive)
                handles.ActiveCh=unique(areamap(strcmp(b,{areamap.subj})).event(handles.EventIdx).allactive); %load active channels
            else
                handles.ActiveCh=1:256;%load all channels    
            end
        end               
        
        function handles=LoadAllChans(handles)    
        %% LOADS BASELINE AND ECOG SEGMENTS
            n=handles.UserChoice;
            seg=handles.SegmentTypes;          
            output=handles.Output;
            switch output
                case 'aa'
                    folder='HilbAA_70to150_8band';
                    freqband=31:38;
                case {'phase','aa40'}
                    folder='HilbReal_4to200_40band';
                    freqband=30:37;
                    output='aa';
                case 'ds'
                    folder='Downsampled400';
                    freqband=1;
                case 'filtered'
                    folder='Filtered_1to40Hz';
                    freqband=1;
            end
            
            test=SegmentedData([handles.FilePath filesep folder],[handles.BaselinePath filesep folder],handles.ActiveCh); 
            %test.BaselineChoice='rest';%use specified pre-event segment as baseline
            test.Params.baselineMS=[400 800];%time of pre-event baseline (ms)            
            sorttrials=0;%1 to sort trials, 0 to skip sorting
            test.segmentedDataEvents40band(seg(:,handles.EventIdx),{[2000 7000]},[],'aa',freqband,sorttrials,handles.TaskType)%load data segments
            %test.calcZscore(1,1);%calculate zscore
            handles.Data=test;%save data object in handles
        end  
    end
end