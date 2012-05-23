P=fuf('E:\PreprocessedFiles\EC2',1,'detail');
ii=1;
P_split=regexp(P,filesep,'split');
for i=1:size(P_split,1)
    if size(P_split{i},2)==6
        P_split2{ii}=P_split{i};
        ii=ii+1;
    end
end

P_split=P_split2';

P_patients=cellfun(@(x)(x{3}),P_split,'UniformOutput',0);
P_blocks=cellfun(@(x)(x{4}),P_split,'UniformOutput',0);
P_folders=cellfun(@(x)(x{5}),P_split,'UniformOutput',0);
P_files=cellfun(@(x)(x{end}),P_split,'UniformOutput',0);


 unique_patients=unique(P_patients);
 unique_blocks=unique(P_blocks);
 %unique_folders=unique(P_folders);
 unique_folders={'RawHTK','Artifacts','Analog','HilbReal_4to200_40band','HilbImag_4to200_40band','HilbAA_70to150_8band','Video'}'
 unique_files=unique(P_files);
%%
for i=1:size(alllog,1)
    block_idx=strmatch(alllog{i},P_blocks,'exact');
    for folders_count=2:size(unique_folders,1);         
         folder_idx=strmatch(unique_folders{folders_count},P_folders(block_idx),'exact');
         contents=P_files(block_idx(folder_idx))         
         switch folders_count         
             case{2,4,5,6}%RawHTK
                 %[c, ia, ib]=union(contents,wavfilenames);
                 ib=length(strmatch('Wav',contents))
             case 3
                 ib=length(strmatch('ANIN',contents))
             case 7
                 ib=length(strmatch('analog',contents))            
             case 8un
                 ib=length(dir)-2;       

         end  
          alllog{i,folders_count+1}=ib;       
 
    end 
end



%%
i=1;
 for patients_count=1:size(unique_patients,1);
     
    patient_idx=strmatch(unique_patients{patients_count},P_patients,'exact');
    i=1;
    %for i=1:size(unique_blocks,1)
         %patient_idx=strmatch(unique_patients{patients_count},P_patients,'exact');
       u=unique(P_blocks(patient_idx));  
       for blocks_count=1:size(u,1);
            block_idx=strmatch(u{blocks_count},P_blocks(patient_idx),'exact');
             for folders_count=1:size(unique_folders,1);
                 
                 folder_idx=strmatch(unique_folders{folders_count},P_folders(block_idx),'exact');
                 S=unique_patients{patients_count};
                 
                 
                 log.(S)(i).SubjectID=unique_patients{patients_count};
                 log.(S)(i).BlockName=u{blocks_count};
                 
                 afc=1;
                log.(S)(i).MiscFiles{afc}=[];
                 try
                    log.(S)(i).(unique_folders{folders_count})=[];
                    try
                        contents=dir(['E:\PreprocessedFiles\' log.(S)(i).SubjectID filesep log.(S)(i).BlockName filesep unique_folders{folders_count}]);    
                        log.(S)(i)=setfield(log.(S)(i),unique_folders{folders_count},contents(3:end));
             
                    end
                 catch
                     log.(S)(i).MiscFiles{afc}=unique_folders{folders_count};
                     afc=afc+1;
                 end
 
             end  
             i=i+1;
         end
         

end
 %%
 
 %If TDT not converted, convert TDT to raw
mainpath='C:\TDT\OpenEx\Tanks\ECOG256'
destPath2='E:\TransferFiles\prcsd_data'
destPath='E:\TransferFiles\raw_data'

 for i=1:size(alllog,1)
     if alllog{i,4}==0
         [subj,~]=regexp(alllog{i,2},'_','split');
         try 
       
            %Create source and destination paths

            source=[mainpath '\', subj{1}, '\', alllog{i,2}];
            cd(source);

            dest=[destPath, '\', subj{1}, '\', alllog{i,2}];
            mkdir(dest)   
            %HTK and move to RawHTK folder
            ecogTDTData2MatlabConvertMultTags(pwd,alllog{i,2});
            mkdir(sprintf('%s%s%s',dest,filesep,'RawHTK'));
            movefile('Wav*',sprintf('%s%s%s',dest,filesep,'RawHTK'));
            movefile('ANIN*',sprintf('%s%s%s',dest,filesep,'Analog'));

    
            %Convert Analog to .wav files, and move to Analog folder

            cd(sprintf('%s%s%s',dest,filesep,'Analog'))
                [data1,sampFreq]= readhtk ('ANIN1.htk');
                [data2,sampFreq]= readhtk ('ANIN2.htk');
                [data3,sampFreq]= readhtk ('ANIN3.htk');
                [data4,sampFreq]= readhtk ('ANIN4.htk');    

                wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
                wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
                wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
                wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');
                dest_pr=[destPath2, '\', subj{1}, '\', alllog{i,2}];
                mkdir([dest_pr filesep 'Analog'])
                movefile('analog*',[dest_pr filesep 'Analog']);
                
                alllog{i,4}=length(dir(sprintf('%s%s%s',dest,filesep,'RawHTK')))-2;
                alllog{i,5}=length(dir(sprintf('%s%s%s',dest,filesep,'Analog')))-2
                alllog{i,6}=length(dir(sprintf('%s%s%s',dest_pr,filesep,'Analog')))-2;


         catch
              alllog{i,4}=777;
         end
     end
 end
             
 
 %%
 destPath='G:\TDT'
 for i=1:length(noTDT)
     [subj,~]=regexp(noTDT{i,1},'_','split');
      source=[mainpath '\', subj{1}, '\', noTDT{i,1}];
      try
          cd(source);
          dest=[destPath, '\', noTDT{i,1}];
          %mkdir(dest);
          %copyfile('E*',dest);
          alllog{find(strcmp(alllog(:,2),noTDT(i,1))),3}=1:length(dir(dest))-2;
      catch
      end
      
 end
            %movefile('ANIN*',sprintf('%s%s%s',dest,filesep,'Analog'));
 
noTDT=alllog(:,find(cellfun(@isempty , alllog(:,3))));
