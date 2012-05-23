for i=272:length(successful)
    cd(successful{i})
    [a,b]=fileparts(successful{i})
    delete('AN*')
    cd([successful{i} '/' b '_data'])
    if strmatch('RawHTK',ls)
        rmdir('RawHTK','s')
    end
    
    if strmatch('AfterCARandNotch',ls)
        rmdir('AfterCARandNotch','s')
    end

     if strmatch('ProcessedHTK_',ls)
            rmdir('ProcessedHTK_Multibands','s')
     end
    
  if strmatch('ProcessedHTK',ls)
        rmdir('ProcessedHTK','s')
  end
    
end
    

    