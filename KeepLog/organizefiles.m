%Convert preprocessing log to database


%Find preprocessed blocks

%Save results as csv


%convert to matlab
[num,text,raw] = xlsread('test2.csv')

%%
%check for preprocessed files on computer
nofile{1}=[];
main='E:\PreprocessedFiles'
subject=raw(:,1)
block{1}='Block'
block=raw(:,3)





contents{1,1}='Block'
contents{1,2}='HilbAA_70to150_8band'
contents{1,3}='HilbImag_4to200_40band'
contents{1,4}='HilbReal_4to200_40band'
contents{1,5}='Artifacts'
contents{1,6}='Analog'
contents{1,7}='RawHTK'
contents{1,8}='AfterCARandNotch'
contents{1,9}='copied'
cur=pwd;
for r=1:length(block)
    i=r+1;
    subjectpath=[main filesep subject{i}]
    cd(subjectpath);
    try cd([subjectpath filesep block{i}])
        contents{i,1}=block{i};
        tmp=cellstr(ls);
        for j=2:size(contents,2)
            if find(strcmp(contents{1,j},tmp))
                cd([subjectpath filesep block{i} filesep contents{1,j}])                
                contents{i,j}=length(cellstr(ls))-2;
            end
        end   
    catch
        contents{i,1}=block{i};
    end
        
end
cd(cur)
%%


    
    

%%
%copy appropriate blocks to external-- if they are on my computer
[num,text,raw] = xlsread('copiedfiles.xls')
folders{1}='RawHTK';
folders{2}='Analog';
folders{3}='Video';
folders{4}='Artifacts'

main='E:\PreprocessedFiles'
%main='C:\Users\Angela_2\Documents\ECOGdataprocessing\PatientData'
%blocks=text(3:end)
blocks=subjects;
destpath='K:\OrganizeFiles';
cd(destpath)
m=1;
for i=1:717
    destpath1='K:\OrganizeFiles\raw';
    destpath2='K:\OrganizeFiles\prcsd';
    tmp=regexp(blocks{i},'_','split');
    subj=tmp{1}%blocks{i,2}
    mkdir([destpath1 filesep subj])
    mkdir([destpath2 filesep subj])
    
    try
        cd([main filesep subj filesep blocks{i}]); 
         
        %%
        
        %Move Raw Files
         j=1
         mkdir([destpath1 filesep subj filesep blocks{i} filesep folders{j}]);
         source=[main filesep subj filesep blocks{i} filesep folders{j}];    
         dest=[destpath1 filesep subj filesep blocks{i} filesep folders{j}]
         %dest=[destpath1 filesep subj filesep blocks{i}];
         copyfile(source,dest)

         j=2
         d=[destpath1 filesep subj filesep blocks{i} filesep folders{j}]
         mkdir(d);
         source=[main filesep subj filesep blocks{i} filesep folders{j} filesep 'ANIN*'];    
         dest=d;
         copyfile(source,dest)

         j=3
         d=[destpath1 filesep subj filesep blocks{i} filesep folders{j}]
         mkdir(d);
         source=[main subj blocks{i} filesep 'VideoTracking'];    
         dest=d;
         try
            copyfile(source,dest)
         catch
         end
        
         %%
         %PREPROCESSED FILES
         %{
         j=2;
        cd([main filesep subj filesep blocks{i} filesep 'Analog'])
        %{
        for analogChNum=1:4
         [data,sampFreq] = readhtk ( sprintf('ANIN%i.htk',analogChNum));
         wavwrite((0.99*data/max(abs(data)))', sampFreq,sprintf('analog%i',analogChNum));
        end    
        %}
        source=[main filesep subj  filesep blocks{i}  filesep folders{j} filesep 'ANIN*']; 
        d=[destpath1 filesep subj filesep blocks{i} filesep folders{j}]
        copyfile(source,d,'f')
        %}
     
        %{
        %Move Artifacts
        j=4
        d=[destpath2 filesep subj filesep blocks{i} filesep folders{j}]
        mkdir(d);
        source=[main filesep subj filesep blocks{i} filesep folders{j}];    
        dest=d;
        copyfile(source,dest)
        %}
     
    catch
        missing{m}=blocks{i};
        m=m+1;
    end
end
    
blocks{36}='EC2_B48'
blocks{37}='EC2_B73'
blocks{38}='EC2_B80'
blocks{39}='EC2_B82'
blocks{40}='EC2_B92'
blocks{41}='EC2_B106'

%%
%GET FILES ON COMPUTER
main='C:\Users\Angela_2\Documents\ECOGdataprocessing\PatientData'
cd(main)
contents{1,1}='Block'
contents{1,2}='HilbAA_70to150_8band'
contents{1,3}='HilbImag_4to200_40band'
contents{1,4}='HilbReal_4to200_40band'
contents{1,5}='Artifacts'
contents{1,6}='Analog'
contents{1,7}='RawHTK'
contents{1,8}='AfterCARandNotch'
contents{1,9}='copied'

count=2;
m=1;
for i=1:length(subj)
    for j=6
        d=[destpath2 filesep subj{i,2} filesep subj{i,1} filesep contents{1,6}]
        mkdir(d);
        source=[main filesep subj{i,2} filesep subj{i,1} filesep  contents{1,6}];    
        
        copyfile(source,d)
    
    
    
    
    try
        cd([main filesep subjects{i}])
        tmp=cellstr(ls);
        c=tmp(3:end);
        for j=1:length(c)
            try 
                cd([main filesep subjects{i} filesep c{j}])
                contents{count,1}=c{j};
                tmp=cellstr(ls);
                f=tmp(3:end);
                for k=1:length(f)
                    try
                        cd([main filesep subjects{i} filesep c{j} filesep f{k}])
                        idx=find(strcmp(contents(1,:),f{k}));
                        if ~isempty(idx)
                            contents{count,idx}=length(cellstr(ls))-2;
                        end
                    catch
                    end
                end
                count=count+1;
            catch
            end
        end
    catch
        missing{m}=subjects{i};
        m=m+1;
    end
end
cur=pwd;
%%
%Copy Keith's files

main='E:\PreprocessedFiles'
mkdir('K:\brocaKJ')
destpath='K:\brocaKJ';
cd(destpath)

%copy appropriate blocks to external-- if they are on my computer
folders{1}='RawHTK';
folders{2}='Analog';
folders{3}='Video';
folders{4}='Artifacts'

for i=1:32
  
     %convert analog to .wav and copy to destination
     cd([main filesep subj{i,2}  filesep subj{i,1}  filesep 'Analog'])
     for analogChNum=1:4
         [data,sampFreq] = readhtk ( sprintf('ANIN%i.htk',analogChNum));
         wavwrite((0.99*data/max(abs(data)))', sampFreq,sprintf('analog%i',analogChNum));
     end    
     
     j=2
     d=[destpath filesep subj{i,1} filesep folders{j}]
     source=[main filesep subj{i,2}  filesep subj{i,1}  filesep folders{j} filesep 'ANIN*']; 
     copyfile(source,d,'f')

     source=[main filesep subj{i,2}  filesep subj{i,1}  filesep folders{j} filesep 'analog*']; 
     copyfile(source,d,'f')
     
     
     %convert Raw to DS and copy to destination
     cd([main filesep subj{i,2}  filesep subj{i,1}])
     ecog=loadHTKtoEcog_DS_save([main filesep subj{i,2}  filesep subj{i,1} filesep 'RawHTK'],256,1);
     d=[destpath  filesep subj{i,1} filesep 'ecogDS']
     source=[main filesep subj{i,2}  filesep subj{i,1}  filesep 'ecogDS']; 
     copyfile(source,d,'f')
   
    
end
%%
%%
for i=4:32
    d=[destpath filesep subj{i,1} filesep subj{i,1}]
    cd(d)
    movefile('ecogDS',[destpath filesep subj{i,1}])
    cd ..
    rmdir(subj{i,1})
    mkdir('Artifacts')
end

