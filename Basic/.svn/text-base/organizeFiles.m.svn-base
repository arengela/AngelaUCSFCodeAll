function organizeFiles(pathName,destination)

    handles.pathName=pathName;
    [a,b,c]=fileparts(handles.pathName);
    handles.blockName=b;
    cd(handles.pathName);
    handles.folderName=sprintf('%s_data',handles.blockName);
    printf('File opened: %s\n',handles.pathName);
    printf('Block: %s',handles.blockName);
    
   %mkdir('Artifacts')
   %mkdir('Analog')
   %mkdir('Figures')


    if strmatch('ANIN',ls) 
        copyfile('ANIN*',sprintf('%s/Analog',destination))
    end
    

    if isempty(strmatch(handles.folderName,ls))
        return
    end
    cd(handles.folderName)
    
    if strmatch('bad_time_segments.lab',ls)
        copyfile('bad_time_segments.lab',sprintf('%s/Artifacts',destination))
    end
    
    if strmatch('badTimeSegments',ls)
        copyfile('badTimeSegments.mat',sprintf('%s/Artifacts',destination))
    end
    
    if strmatch('badChannels.txt',ls)
        copyfile('badChannels.txt',sprintf('%s/Artifacts',destination))
    end
    
     if strmatch('articulation',ls)
        copyfile('articulation*',sprintf('%s/Analog',destination))
     end

    if strmatch('stim',ls)
        copyfile('stim*',sprintf('%s/Analog',destination))
    end

    if strmatch('analog',ls)
        copyfile('analog*',sprintf('%s/Analog',destination))
    end
    
   if strmatch('gif',fliplr(ls))
        copyfile('*.fig',sprintf('%s/Figures',destination))
   end
    
      if strmatch('RawHTK',ls)
        copyfile('RawHTK',sprintf('%s/RawHTK',destination))
      end
    
      %{
  if strmatch('AfterCARandNotch',ls)
        movefile('AfterCARandNotch','../AfterCARandNotch')
  end
    
    if strmatch('HilbAA_70to150_8band',ls)
        movefile('HilbAA_70to150_8band','../HilbAA_70to150_8band')
    end
      %}
    
end
    