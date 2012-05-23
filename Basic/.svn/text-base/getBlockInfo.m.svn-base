function handles=getBlockInfo(pathName)
    handles.pathName=pathName
    [a,b,c]=fileparts(handles.pathName)
    handles.blockName=b
    cd(handles.pathName)
    fprintf('File opened: %s\n',handles.pathName)
    fprintf('Block: %s',handles.blockName)
end