addpath(genpath('/home/angela/Dropbox'))
unique_folders={'TDT','RawHTK','Analog','Analog','Artifacts','HilbReal_4to200_40band','HilbImag_4to200_40band','HilbAA_70to150_8band','Video','segmented_40band'}'
%unique_folders={'TDT','RawHTK','Analog','Analog','Artifacts','HilbReal_4to200_40band','HilbImag_4to200_40band','HilbAA_70to150_8band','Video'}'

% unique_files=unique(P_files);
tdtfilenames={'*.tev','*.Tdx','*.tev','*.tsq'}
%%
load /home/angela/alllog.mat
%load /home/angela/Documents/files/alllogFilled.mat
mainpath='/data_store/human'
subfolder='raw_data'
subfolder='prcsd_data'
subfolder='TDTbackup'


F={'raw_data','prcsd_data','TDTbackup'}
%%
for i=1:size(alllog,1)
    for count=1:3
        subfolder=F{count}
        subj=regexp(alllog{i,1},'_','split')
        %cd([mainpath filesep subfolder filesep subj{1} filesep alllog{i,1}])
        if strmatch(subfolder,'raw_data')
            folders_count=[2,3,9];
        elseif strmatch(subfolder,'prcsd_data')
            folders_count=[4:8];
        elseif strcmp(subfolder,'TDTbackup')
            folders_count=1;
        end
        for j=folders_count
            contents=dir([mainpath filesep subfolder filesep subj{1} filesep alllog{i,1} filesep unique_folders{j}])
            switch j
                case 1
                    contents=dir([mainpath filesep 'raw_data' filesep subfolder filesep subj{1} filesep alllog{i,1}])
                    
                    ib=find([cell2mat(regexp({contents.name}','tev')) cell2mat(regexp({contents.name}','tsq')) cell2mat(regexp({contents.name}','Tdx')) cell2mat(regexp({contents.name}','Tbk'))])
                    
                case{2,6,7,8}%RawHTK
                    %[c, ia, ib]=union(contents,wavfilenames);
                    ib=length(strmatch('Wav',{contents.name}'))
%                                         if length(contents)>2;
%                                             ib=contents(3).date;
%                                         end
                case 3
                    ib=length(strmatch('ANIN',{contents.name}'))
                case 4
                    ib=length(strmatch('analog',{contents.name}'))
                case {5,9}
                    ib=length({contents.name}')-2;
                                        if length(contents)>2;
                                            ib=contents(3).date;
                                        end
                    
                otherwise
                    continue
                    
                    
            end
            alllog{i,j+1}=ib;
            
            clear ib;
        end
        clear folder_count contents
    end
    
end
cd('/home/angela/')
%save('alllogFilled','alllog')
save('alllogFilled2','alllog')

%%
%Get processing dates
for i=1:size(alllog,1)
    for count=1:3
        subfolder=F{count}
        subj=regexp(alllog{i,1},'_','split')
        %cd([mainpath filesep subfolder filesep subj{1} filesep alllog{i,1}])
        if strmatch(subfolder,'raw_data')
            folders_count=[2,3];
        elseif strmatch(subfolder,'prcsd_data')
            folders_count=[4:9];
        elseif strcmp(subfolder,'TDTbackup')
            folders_count=1;
        end
        for j=folders_count
            contents=dir([mainpath filesep subfolder filesep subj{1} filesep alllog{i,1} filesep unique_folders{j}])
            if length(contents)>=3
                switch j
                    %case 1
                        contents=dir([mainpath filesep 'raw_data' filesep subfolder filesep subj{1} filesep alllog{i,1}])
                        
                        ib=find([cell2mat(regexp({contents.name}','tev')) cell2mat(regexp({contents.name}','tsq')) cell2mat(regexp({contents.name}','Tdx')) cell2mat(regexp({contents.name}','Tbk'))])
                        
                    case{2,6,7,8}%RawHTK
                        %[c, ia, ib]=union(contents,wavfilenames);
                        ib=length(strmatch('Wav',{contents.name}'))
                        ib=contents(3).date;
                    %case 3
                        ib=length(strmatch('ANIN',{contents.name}'))
                    %case 4
                        ib=length(strmatch('analog',{contents.name}'))
                    case {5,9}
                        ib=length({contents.name}');
                        ib=contents(3).date;
                        
                    otherwise
                        continue
                end
                alllog{i,j+10}=ib;
                ib=[];
            end
        end
        clear folder_count contents
    end
end

%%
for i=1:size(alllog,1)
    if ~alllog{i,7}==0
        idx=strmatch(alllog{i,1},{PL{:,1}},'exact');
        PL{idx,7}=alllog{i,7};
        PL{idx,5}=alllog{i,6};
    end
end





%%
%copy missing folders
folders_count=2;
switch folders_count
    case 2
        rows=find(vertcat(alllog{:,3})<256)
end

alllog2=alllog(rows,:)
for i=1:length(rows)
    subj=regexp(alllog2{i,1},'_','split')
    source=['E:\PreprocessedFiles\' subj{1} filesep alllog2{i,1} filesep unique_folders{folders_count}]
    dest=['N:\raw' filesep subj{1} filesep alllog2{i,1}  filesep unique_folders{folders_count}];
    try
        copyfile(source,dest);
    end
end
%%
P=fuf(mainpath,1,'detail');
%%
ii=1;
P_split=regexp(P,filesep,'split');
%P_split=regexp(P,'/','split');

for i=1:size(P_split,1)
    if size(P_split{i},2)==8
        P_split2{ii}=P_split{i};
        ii=ii+1;
    end
end
P_split=P_split2;
%{
P_split{1}=
  Columns 1 through 7

    ''    'data_store'    'human'    'raw_data'    'CH'    'CH_B1'    'Analog'

  Column 8

    'ANIN1.htk'
%}

%P_split=P_split2';

P_patients=cellfun(@(x)(x{5}),P_split,'UniformOutput',0);
P_blocks=cellfun(@(x)(x{6}),P_split,'UniformOutput',0);
P_folders=cellfun(@(x)(x{7}),P_split,'UniformOutput',0);
P_files=cellfun(@(x)(x{end}),P_split,'UniformOutput',0);

%for TDT folders
P_patients=cellfun(@(x)(x{6}),P_split,'UniformOutput',0);
P_blocks=cellfun(@(x)(x{7}),P_split,'UniformOutput',0);
%P_folders=cellfun(@(x)(x{7}),P_split,'UniformOutput',0);
P_files=cellfun(@(x)(x{end}),P_split,'UniformOutput',0);


%%

unique_patients=unique(P_patients);
unique_blocks=unique(P_blocks);
%unique_folders=unique(P_folders);
unique_folders={'TDT','RawHTK','Analog','Analog','Artifacts','HilbReal_4to200_40band','HilbImag_4to200_40band','HilbAA_70to150_8band','Video'}'
unique_files=unique(P_files);
tdtfilenames={'*.tev','*.Tdx','*.tev','*.tsq'}
%%
load /home/angela/Documents/files/alllog.mat

%%
%search TDT files
for i=1:size(alllog,1)
    block_idx=strmatch(alllog{i},P_blocks,'exact');
    for folders_count=1%2:size(unique_folders,1);
        %folder_idx=strmatch(unique_folders{folders_count},P_folders(block_idx),'exact');
        contents=P_files(block_idx)
        switch folders_count
            case 1
                ib=find([cell2mat(regexp(contents,'tev')) cell2mat(regexp(contents,'tsq')) cell2mat(regexp(contents,'Tdx')) cell2mat(regexp(contents,'Tbk'))])
                
            case{2,5,6,7}%RawHTK
                %[c, ia, ib]=union(contents,wavfilenames);
                ib=length(strmatch('Wav',contents))
            case 3
                ib=length(strmatch('ANIN',contents))
            case 4
                ib=length(strmatch('analog',contents))
            case 5
                ib=length(dir)-2;
                
        end
        alllog{i,folders_count+1}=ib;
        
    end
end
%%
for i=1:size(alllog,1)
    block_idx=strmatch(alllog{i},P_blocks,'exact');
    for folders_count=2%4:length(unique_folders)
        folder_idx=strmatch(unique_folders{folders_count},P_folders(block_idx),'exact');
        contents=P_files(block_idx(folder_idx))
        switch folders_count
            case 1
                ib=find([cell2mat(regexp(contents,'tev')) cell2mat(regexp(contents,'tsq')) cell2mat(regexp(contents,'Tdx')) cell2mat(regexp(contents,'Tbk'))])
                
            case{2,6,7,8}%RawHTK
                %[c, ia, ib]=union(contents,wavfilenames);
                ib=length(strmatch('Wav',contents))
            case 3
                ib=length(strmatch('ANIN',contents))
            case 4
                ib=length(strmatch('analog',contents))
            case 5
                ib=length(contents);
                
        end
        alllog{i,folders_count+1}=ib;
        clear ib;
    end
end

%%

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
%On Windows

%Get missing blocks
for i=1:size(unique_patients,1)
    curblocks={allblocksnotes{strmatch(unique_patients{i},allblocksnotes(:,1)),2}}'
    diskblocks={log.(unique_patients{i}).BlockName}'
    [missingblocks,iA,iB]=setxor(curblocks,diskblocks)
    missingRawCortex.(unique_patients{i}).blocknames=missingblocks;
    missingRawCortex.(unique_patients{i}).iLog=iA;
    missingRawCortex.(unique_patients{i}).iDisk=iB;
end

%check if all blocks have enough files
for i=1:size(unique_patients,1)
    %curblocks={allblocksnotes{strmatch(unique_patients{i},allblocksnotes(:,1)),2}}'
    diskblocks={log.(unique_patients{i}).BlockName}'
    %rawtest=log.EC2(end).RawHTK
    contentsize=cell2mat(cellfun(@(x) size(x,1)>=256,{log.EC2.RawHTK}','UniformOutput',0));
    mismatch{i}=cell2mat(cellfun(@(x) size(x,1)>=256,{log.EC2.RawHTK}','UniformOutput',0));
    
    if ~isempty(find(contentsize==0))
        mismatch{i}=contentsize;
    end
end
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
            case 8
                ib=length(dir)-2;
                
        end
        alllog{i,folders_count+1}=ib;
        
    end
end

%%
for i=3:length(files)
    mkdir(['/data_store/human/prcsd_data/EC8/' files(i).name '/Videos'])
    copyfile([mainpath filesep files(i).name filesep '*'],['/data_store/human/prcsd_data/EC8/' files(i).name '/Videos'])
    
end
