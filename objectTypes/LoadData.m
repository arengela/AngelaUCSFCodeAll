classdef LoadData < handle
    
    properties
        %Initiate
        AllFilePaths
        AllBaselinePaths
        SegmentTypes
        %ListBlocks
        %ChooseBlock
        UserChoice
        EventIdx
        FilePath
        BaselinePath
        eventVariables
        ActiveCh
        %LoadAllChans
        %LoadOneChan
        Data
    end
    
    methods
        function handles=LoadData(handles)          
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
            'E:\DelayWord\EC24\EC24_B2';
            'E:\DelayWord\EC24b\EC24_B1';
            'E:\DelayWord\EC24b\EC24_B3';
            }

            handles.AllBaselinePaths{1}='E:\DelayWord\EC18\EC18_rest'
            handles.AllBaselinePaths{2}='E:\DelayWord\EC18\EC18_rest'
            handles.AllBaselinePaths{8}=    'E:\DelayWord\EC21\EC21_B2';
            handles.AllBaselinePaths{9}='E:\DelayWord\EC22\EC22_B2'
            handles.AllBaselinePaths{10}='E:\DelayWord\EC23\EC23_B2'
            handles.AllBaselinePaths{11}='E:\DelayWord\EC24\EC24_B3'
            handles.AllBaselinePaths{12}='E:\DelayWord\EC24b\EC24_B2'
            
            load('E:\DelayWord\wordgroups')
            load('E:\DelayWord\brocawords')
            load('E:\DelayWord\EC23\EC23params.mat')
            load('E:\DelayWord\EC18\EC18params.mat')
            load('E:\DelayWord\EC22\EC22params.mat')
            load('E:\DelayWord\EC24b\EC24params.mat')
            
            handles.SegmentTypes={[repmat([41],[1 length(lh)]);lh],[lh;repmat([42],[1 length(lh)])],[repmat([42],[1 length(lh)]);lh],[repmat([43],[1 length(lh)]);lh],[repmat([44],[1 length(lh)]);lh],[45;41]};
            handles.EventIdx=[2 4 5]
        end
        
        function ListBlocks(handles,n)
            n
            for i=1:length(handles.AllFilePaths)
                printf([num2str(i) handles.AllFilePaths{i} '\n'])
            end
        end
            
        
        function ChooseBlock(handles,UserChoice,m)
            UserChoice
            handles.UserChoice=n;
            handles.FilePath=handles.AllFilePaths{handles.UserChoice};
            handles.BaselinePath=handles.AllBaselinepaths{handles.Userchoice};
            [a,b,c]=filepaths(handles.FilePath);
            [a,b,c]=filepaths(b);
            switch b
                case 'EC18'
                    load('E:\DelayWord\EC18\EC18params.mat')
                    E23params=EC18params;
                case 'EC20'
                    load('E:\DelayWord\EC18\EC18params.mat')
                    E23params=EC18params;
                case 'EC21'
                    load('E:\DelayWord\EC18\EC18params.mat')
                    E23params=EC21params;
                case 'EC22'
                    load('E:\DelayWord\EC18\EC18params.mat')
                    E23params=EC22params;
                case 'EC23'
                    load('E:\DelayWord\EC18\EC18params.mat')
                    E23params=EC23params;
                case 'EC24'
                    load('E:\DelayWord\EC18\EC18params.mat')
                    E23params=EC24params;
            end
            handles.eventVariables=EC23.event;
            handles.ActiveCh=unique([EC23params.event(5).activech EC23params.event(4).activech EC23params.event(2).activech]);
            handles.LoadAllChans(handles)
        end               
        
        function test=LoadAllChans(handles)    
            n=handles.UserChoice;
            seg=handles.SegmentType;
            
            test=SegmentedData([handles.AllFilePaths{n} '/HilbAA_70to150_8band']);            
            test.usechans=handles.Activech;
            test.channelsTot=length(test.usechans)
            test.Artifacts.badChannels=[];
            test.Artifacts.badTimeSegments=[];
            test.Params.sortidx=1;

            %Calc baseline
            test.loadBaselineFolder([handles.BaselinePath{n} '/HilbAA_70to150_8band']);
            test.ecogBaseline.data=test.ecogBaseline.data(:,:,:,:);
            test.BaselineChoice='PreEvent';
            test.Params.baselineMS=[500 1000];
            test.Params.indplot=0;
            m=mean(test.ecogBaseline.data(:,:,:,:),3);
            baselinezscore=(m-repmat(mean(test.ecogBaseline.mean,2),[1 size(m,2)]))./repmat(mean(test.ecogBaseline.std,2),[1 size(m,2)]);
            test.Params.sorttrials=1;
            test.segmentedDataEvents40band(seg(:,[2,4,5]),{[2000 2000],[2000 2000],[2000 2000]},'keep',[],'aa',31:38)
            test.calcZscore;
            handles.Data=test;
        end

    end
end