function organizeGUI

    figure('MenuBar','none','Name','OrganizeGUI','NumberTitle','off','Position',[100,100,500,500]);

    getSourcePath = uicontrol('Style','Edit','String','Block Folder','Position',[10,450,100,20],...
    'CallBack', @getBlockFolder_callback, 'HorizontalAlignment','left');

    ListBox=uicontrol('Style','ListBox','Position',[10,10,200,400],'Max',10);
    
    getDestPath = uicontrol('Style','Edit','String','Destination Path','Position',[10,400,100,20], 'HorizontalAlignment','left');

    FileListBox=uicontrol('Style','ListBox','Position',[200,100,200,400],'Max',10,'String',{'Analog','RawHTK','Hilb','ecogDS','Artifacts'});

    uicontrol('Style','PushButton','String','Copy Files','Position',[20,100,60,20],'CallBack',@copyButton);
    
    
    uicontrol('Style','PushButton','String','Preprocess Files','Position',[70,100,60,20],'CallBack',@preprocessButton);

    uicontrol('Style','PushButton','String','Delete Files','Position',[50,100,60,20],'CallBack',@deleteButton);

    function getBlockFolder_callback(varargin)

        folderPath = get(getSourcePath,'String')
        cd(folderPath)
        tmp=cellstr(ls);
        tmp=tmp(find(cellfun(@(x) ~ismember(x,{'.','..'}),tmp)))       
        
        
        
        
        a=cellfun(@(x) dir(x),tmp,'UniformOutput',false)
        %blocks=cellfun(@(x,y) x&y,a.isdir,cellfun(@(x) ~ismember(x,{'.','..'}),{a.name}))
        blockpaths=[];
        for i=1:length(a)
            idx=find([a{i}.isdir]&  cellfun(@(x) ~ismember(x,{'.','..'}),{a{i}.name}))
            %P=cellfun(@(x) setfield(P,'block',,x),{a{i}(idx).name}','UniformOutput',0)
            %cellfun(@(x) setfield(P,'subj',x),{tmp{i}},{x}), {a{i}(idx).name}','UniformOutput',0)

            blockpaths=vertcat(blockpaths,{a{i}(idx).name}')

        end


        set(ListBox, 'String',blockpaths);


    end


    function copyButton(varargin)
        List = get(ListBox, 'String');
        Val = get(ListBox, 'Value');
        selectedContents=List(Val);
        
        List2 = get(FileListBox, 'String');
        Val2 = get(FileListBox, 'Value');
        selectedFolders=List2(Val2);
        
        
        destPath=get(getDestPath,'String');
        sourcePath=get(getSourcePath,'String');
        [a,b,c]=fileparts(destPath);

        for i=1:length(selectedContents)
            [subj,~]=regexp(selectedContents{i},'_','split');
            %quickPreprocessing_ALL([sourcePath filesep subj{1} filesep selectedContents{i}],3,0,1)
            if ~isempty(find(ismember(selectedFolders,'Analog'))) & strmatch(b,'raw')    
                selectedFolders=selectedFolders(find(ismember(selectedFolders,'Analog')));
               copyfile([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'Analog' filesep 'ANIN*'],[destPath filesep subj{1} filesep selectedContents{i} filesep 'Analog']) 
            end
                
            cellfun(@(x) copyfile([sourcePath filesep subj{1} filesep selectedContents{i} filesep x '*'],[destPath filesep subj{1} filesep selectedContents{i}]),selectedFolders);
        end
        
        
    end



      function preprocessButton(varargin)
        List = get(ListBox, 'String');
        Val = get(ListBox, 'Value');
        selectedContents=List(Val);
        destPath=get(getDestPath,'String');
        sourcePath=get(getSourcePath,'String');
        
        for i=1:length(selectedContents)
            [subj,~]=regexp(selectedContents{i},'_','split');
            quickPreprocessing_ALL([sourcePath filesep subj{1} filesep selectedContents{i}],3,0,1)
            %copyfile([sourcePath filesep selectedContents{i}],[destPath filesep selectedContents{i}]);
        end
        
        
    end
     function deleteButton(varargin)
        List = get(ListBox, 'String');
        Val = get(ListBox, 'Value');
        selectedContents=List(Val);
        destPath=get(getDestPath,'String');
        sourcePath=get(getSourcePath,'String');
        
        for i=1:length(selectedContents)
            [subj,~]=regexp(selectedContents{i},'_','split');
            try
                rmdir([sourcePath filesep subj{1} filesep selectedContents{i} filesep 'Hilb*'],'s')
            catch
            end
            %copyfile([sourcePath filesep selectedContents{i}],[destPath filesep selectedContents{i}]);
        end
        
        
    end
end