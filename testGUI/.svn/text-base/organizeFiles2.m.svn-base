function organizeFiles2

 figure('MenuBar','none','Name','OrganizeFiles','NumberTitle','off','Position',[200,200,500,500]);
global VAR
   
    getSourcePath = uicontrol('Style','Edit','String','Block Folder','Position',[10,450,100,20],...
    'CallBack', @getBlockFolder_callback, 'HorizontalAlignment','left');
    

        folderPath = get(getSourcePath,'String')
        cd(folderPath)
        tmp=cellstr(ls);
        contents=tmp(3:end);


   % uicontrol('Style','PushButton','String','unpack','Position',[20,100,60,20],'CallBack',@unpack);

%{
   function getBlockFolder_callback(varargin)
        folderPath = get(getSourcePath,'String')
        cd(folderPath)
        tmp=cellstr(ls);
        contents=tmp(3:end);
        
        
        ListBox=uicontrol('Style','ListBox','Position',[10,300,60,100],'Max',10);
        set(ListBox, 'String',contents);
        uicontrol('Style','PushButton','String','unpack','Position',[20,100,60,20],'CallBack',@unpack);


   end

    function unpack(varargin)
        
        
    end
    %}
end