function organizeGUI3

w=600;
l=600;
m1=10;
c1=151;
figure('MenuBar','none','Name','OrganizeGUI','NumberTitle','off','Position',[100,100,w,l]);

getSourcePath = uicontrol('Style','Edit','String','Block Folder','Position',[m1,.95*l,c1,20],...
    'CallBack', @getBlockFolder_callback, 'HorizontalAlignment','left');

getDestPath = uicontrol('Style','Edit','String','Destination Path','Position',[m1,.9*l,c1,20], 'HorizontalAlignment','left');

PatientListBox=uicontrol('Style','ListBox','Position',[m1,.5*l,c1,.35*l],'Max',10,'CallBack',@patientListBox_callback);

BlockListBox=uicontrol('Style','ListBox','Position',[2*m1+c1,.5*l,c1,.35*l],'Max',10);

FileListBox=uicontrol('Style','ListBox','Position',[3*m1+2*c1,.5*l,c1,.35*l],'Max',10,'String',{'Analog','RawHTK',...
    'HilbAA_70to150_8band','HilbReal_4to200_40band','HilbImag_4to200_40band','Artifacts','ecogDS','Video'});

uicontrol('Style','PushButton','String','Copy Files','Position',[m1,.4*l,c1,20],'CallBack',@copyButton);

uicontrol('Style','PushButton','String','Preprocess Files','Position',[m1,.35*l,c1,20],'CallBack',@preprocessButton);

uicontrol('Style','PushButton','String','Delete Files','Position',[m1,.3*l,c1,20],'CallBack',@deleteButton);
uicontrol('Style','PushButton','String','TDT to HTK','Position',[m1,.25*l,c1,20],'CallBack',@convertButton);
uicontrol('Style','PushButton','String','Analog htk to wav','Position',[m1,.20*l,c1,20],'CallBack',@convertAnalogButton);
%%
    function getBlockFolder_callback(varargin)
        folderPath = get(getSourcePath,'String')
        cd(folderPath)
        tmp=cellstr(ls);
        tmp=tmp(find(cellfun(@(x) ~ismember(x,{'.','..'}),tmp)))
        set(PatientListBox, 'String',tmp);
    end
%%
    function patientListBox_callback(varargin)
        tmp=get(PatientListBox,'String');
        a=cellfun(@(x) dir(x),tmp,'UniformOutput',false);
        pval=get(PatientListBox,'Value');
        blockpaths=[];
        for j=1:length(pval)
            i=pval(j);
            idx=find([a{i}.isdir]&  cellfun(@(x) ~ismember(x,{'.','..'}),{a{i}.name}));
            blockpaths=vertcat(blockpaths,{a{i}(idx).name}');
        end
        set(BlockListBox, 'String',blockpaths);
    end
%%
    function copyButton(varargin)
        List = get(BlockListBox, 'String');
        Val = get(BlockListBox, 'Value');
        selectedContents=List(Val);
        
        List2 = get(FileListBox, 'String');
        Val2 = get(FileListBox, 'Value');
        selectedFolders=List2(Val2);
        
        
        destPath=get(getDestPath,'String');
        sourcePath=get(getSourcePath,'String');
        [a,b,c]=fileparts(destPath);
        
        
        
        %[f,ia,ib]=setxor(selectedContents,ls([destPath filesep subj{1}]));
        for i=1:length(selectedContents)
            [subj,~]=regexp(selectedContents{i},'_','split');
            if isempty(strmatch(selectedContents{i},ls([destPath filesep subj{1}]),'exact'))
            quickPreprocessing_ALL_TMP([sourcePath filesep subj{1} filesep selectedContents{i}],3,0,1)
                if ~isempty(find(ismember(selectedFolders,'Analog'))) & strmatch(b,'raw')
                    %selectedFolders=selectedFolders(find(ismember(selectedContents,'Analog')));
                    try
                    copyfile([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'Analog' filesep 'ANIN*'],[destPath filesep subj{1} filesep selectedContents{i} filesep 'Analog'],'f')
                    end
                    end
               try
                    cellfun(@(x) copyfile([sourcePath filesep subj{1} filesep selectedContents{i} filesep x '*'],[destPath filesep subj{1} filesep selectedContents{i}],'f'),selectedFolders);
               end
               end
         end
        
    end
%%
    function preprocessButton(varargin)
        List = get(BlockListBox, 'String');
        Val = get(BlockListBox, 'Value');
        selectedContents=List(Val);
        
        List2 = get(FileListBox, 'String');
        Val2 = get(FileListBox, 'Value');
        selectedFolders=List2(Val2);
        
        
        destPath=get(getDestPath,'String');
        sourcePath=get(getSourcePath,'String');
        [a,b,c]=fileparts(destPath);
        
        for i=1:length(selectedContents)
            [subj,~]=regexp(selectedContents{i},'_','split');
            %loadHTKtoEcog_DS_save([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'RawHTK'],256,1)
            if strcmp(subj{1},'EC20')
                quickPreprocessing_ALL([sourcePath filesep subj{1} filesep selectedContents{i}],2,0,1)
            else
                quickPreprocessing_ALL_TMP([sourcePath filesep subj{1} filesep selectedContents{i}],2,0,1)
            end
            
        end
        
    end


%%
    function convertButton(varargin)
        List = get(BlockListBox, 'String');
        Val = get(BlockListBox, 'Value');
        selectedContents=List(Val);
        destPath=get(getDestPath,'String');
        sourcePath=get(getSourcePath,'String');
        
        for i=1:length(selectedContents)
            [subj,~]=regexp(selectedContents{i},'_','split');
            cd([sourcePath filesep subj{1} filesep selectedContents{i}])
            ecogTDTData2MatlabConvertMultTags(pwd,selectedContents{i});
            destinationPath=[destPath filesep subj{1} filesep selectedContents{i}];
            
            mkdir(sprintf('%s/%s/%s',destinationPath,selectedContents{i},'RawHTK'))
            mkdir(sprintf('%s/%s/%s',destinationPath,selectedContents{i},'Analog'))
            movefile('Wav*.htk',sprintf('%s/%s/%s',destinationPath,selectedContents{i},'RawHTK'));
            try
                movefile('ANIN*.htk',sprintf('%s/%s/Analog',destinationPath,selectedContents{i}));
            catch
                fprintf('No Analog')
            end
            
            try
                movefile('Trck*.htk',sprintf('%s/%s/VideoTracking',destinationPath,selectedContents{i}));
            catch
                fprintf('No Video')
            end
            
            try
                movefile('LFP*.htk',sprintf('%s/%s',destinationPath,selectedContents{i}));
            end
            
            mkdir(sprintf('%s/%s/Artifacts',destinationPath,selectedContents{i}))
            mkdir(sprintf('%s/%s/Figures',destinationPath,selectedContents{i}))
            cd(sprintf('%s/%s/Analog',destinationPath,selectedContents{i}))
            
            try
                [data1,sampFreq]= readhtk ('ANIN1.htk');
                [data2,sampFreq]= readhtk ('ANIN2.htk');
                [data3,sampFreq]= readhtk ('ANIN3.htk');
                [data4,sampFreq]= readhtk ('ANIN4.htk');
                
                wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
                wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
                wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
                wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');
            catch
                fprintf('No Analog')
            end
        end
    end

    function convertAnalogButton(varargin)
        List = get(BlockListBox, 'String');
        Val = get(BlockListBox, 'Value');
        selectedContents=List(Val);
        %destPath=get(getDestPath,'String');
        sourcePath=get(getSourcePath,'String');
        for i=1:length(selectedContents)
                     [subj,~]=regexp(selectedContents{i},'_','split');

            cd([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'Analog'])


        
        
                [data1,sampFreq]= readhtk ('ANIN1.htk');
                [data2,sampFreq]= readhtk ('ANIN2.htk');
                [data3,sampFreq]= readhtk ('ANIN3.htk');
                [data4,sampFreq]= readhtk ('ANIN4.htk');
                
                wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
                wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
                wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
                wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');
        end
    end
%%
    function deleteButton(varargin)
        List = get(BlockListBox, 'String');
        Val = get(BlockListBox, 'Value');
        selectedContents=List(Val);
        destPath=get(getDestPath,'String');
        sourcePath=get(getSourcePath,'String');
        
        for i=1:length(selectedContents)
            [subj,~]=regexp(selectedContents{i},'_','split');
           
            try
                rmdir([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'Video*'],'s')
                delete([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'Analog' filesep 'ANIN*'])

                %rmdir([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'HilbAA_70to150_8band'],'s')
            end
            try
                 %rmdir([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'HilbReal_4to200_40band'],'s')
                 %rmdir([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'HilbReal_4to200_40band'],'s')

            catch
            end
        end
    end
end