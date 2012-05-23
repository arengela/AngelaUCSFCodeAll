for i=13:length(filesall)
            [a,b]=fileparts(filesall{i})

            newfiles{i}=['C:\Users\Angela\Documents\Data_preprocess_temp/' b]
    mkdir(newfiles{i})
    copyfile(filesall{i},newfiles{i})

end
    
for i=2:7

        handles.pathName=newfiles{i};
        [a,b,c]=fileparts(handles.pathName);
        handles.blockName=b;
        cd(handles.pathName);
        handles.folderName=sprintf('%s_data',handles.blockName);


        if strmatch('RawHTK',ls) 
            cd('Artifacts')
            if strmatch('badChannels.txt',ls) & strmatch('badTimeSegments',ls)
                cd(handles.pathName)
                quickPreprocessing_v2(filesall{i})
                %per_info2{i}=quickPreprocessing_getperiodograms(filesall{i})


            end

        end

end