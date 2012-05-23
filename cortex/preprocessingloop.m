mainpath='E:\PreprocessedFiles\EC14'
cd(mainpath)
folders=dir
255 256 89 90 75 202 173 174 249  65:67  246 247
%%
for i=4:6
    try
        cd([mainpath filesep folders(i).name])
    catch
        continue
    end
%     [a,b,c]=rmdir('Hilb*','s')
%     [a,b,c]=rmdir('Raw*','s')
%     [a,b,c]=rmdir('Figures','s')
%     [a,b,c]=rmdir('AfterCARandNotch','s')
%     [a,b,c]=rmdir('Downsample*','s')
    preprocessing_GUI(pwd)
    keyboard
    files{i}=folders(i).name
    close all
    %quickPreprocessing_ALL(pwd,3,0,1)
    %mkdir(['K:\Timit\'  b(i).name])
    %copyfile(['E:\PreprocessedFiles\EC5\' b(i).name filesep 'HilbAA_70to150_8band'],['K:\Timit\'  b(i).name filesep 'HilbAA_70to150_8band'])
end
%%

!sync
!sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"
%%
sync
sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"
%%
%Copy Artifacts to correct folder in raw_data, run quickPreprocessing, and
%move Hilb files and Artifact files to pr
mainpath='/data_store/human/prcsd_data/';
dest='/data_store/human/raw_data/'
%%
cd(mainpath)
allfiles=dir;

allfiles = {

    'GP33_B34'
    'GP33_B37'
    'EC3_B1'
    'EC5_B2'}

%%

for i=1:size(k_blocks,1)
    allfiles{i}=['EC' int2str(k_blocks(i,1)) '_B' int2str(k_blocks(i,2))];
end


for i=9:size(k_blocks,1)
    allfiles{i}=['GP' int2str(k_blocks(i,1)) '_B' int2str(k_blocks(i,2))];
end
%%
for i=1:length(allfiles)
    p=regexp(allfiles{i},'_','split')
%     try
%         cd([mainpath  p{1} filesep allfiles{i} filesep 'Artifacts'])
%     catch
%         continue
% 
%     end
%     try
%         rmdir([mainpath p{1} filesep allfiles{i} filesep 'Artifacts'])
%     end

    [~]=mkdir([mainpath  p{1} filesep allfiles{i}])
     copyfile([dest  p{1} filesep  allfiles{i} filesep 'Artifacts'], [mainpath  p{1} filesep allfiles{i} filesep 'Artifacts']);
    cd([dest  p{1} filesep  allfiles{i}])
    quickPreprocessing_ALL(pwd,2,0,1)
    try
        rmdir([mainpath p{1} filesep allfiles{i} filesep 'Hilb*'],'s')

    end
       movefile('Hilb*', ['/data_store/human/prcsd_data/' p{1} filesep allfiles{i}],'f')

        rmdir([dest p{1} filesep allfiles{i} filesep 'Artifacts'],'s')
    
    

    
    try
        mkdir(['/data_store/human/prcsd_data/' p{1} filesep allfiles{i} '/Analog'])
        
            cd([dest  p{1} filesep  allfiles{i} filesep 'Analog'])
    [data,sampFreq]= readhtk ('ANIN1.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'analog1.wav');
    
    [data,sampFreq]= readhtk ('ANIN2.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'analog2.wav');
    
    [data,sampFreq]= readhtk ('ANIN3.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'analog3.wav');
    
    [data,sampFreq]= readhtk ('ANIN4.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'analog4.wav');
        movefile('analog*', ['/data_store/human/prcsd_data/' p{1} filesep allfiles{i} '/Analog'],'f')
    end
        %movefile('Artifacts',['/data_store/human/prcsd_data/' p{1} filesep allfiles(i).name],'f')

end

%%


for i=26:39
    p=regexp(allfiles(i).name,'_','split')
    cd([dest  p{1} filesep allfiles(i).name])
    quickPreprocessing_ALL(pwd,2,0,1)
    movefile('Hilb*', ['/data_store/human/prcsd_data/' p{1} allfiles(i).name])
    movefile('Artifacts',['/data_store/human/prcsd_data/' p{1} allfiles(i).name])
end
%%

allfiles=dir;
for i=3:length(allfiles)
    cd(['/data_store/human/raw_data/EC9/' allfiles(i).name])
    if strfind(ls,'HilbAA')
       try
          movefile('Hilb*', ['/data_store/human/prcsd_data/EC9/' allfiles(i).name])
         movefile('Artifacts',['/data_store/human/prcsd_data/EC9/' allfiles(i).name])
       end
    end
end
%%
dest='E:\PreprocessedFiles'
main='C:\Users\Angela_2\Dropbox\ChangLab\Users\Emily\broca_repeat\artifacts'

cd(main)
allartifacts=dir

for n=3:length(allartifacts)
    p=regexp(allartifacts(n).name,'_','split');
    copyfile([main filesep allartifacts(n).name],[dest filesep p{1} filesep p{1} '_' p{2} filesep 'Artifacts'])
end
   
%%

dest='E:\PreprocessedFiles'
main='C:\Users\Angela_2\Dropbox\ChangLab\Users\Emily\broca_repeat\eventfiles\phone_eventfiles'
main='C:\Users\Angela_2\Dropbox\ChangLab\Users\Emily\broca_repeat\eventfiles\unique_word_eventfiles'
main='C:\Users\Angela_2\Dropbox\ChangLab\Users\Emily\broca_repeat\eventfiles\word_PW_eventfiles'
main='C:\Users\Angela_2\Dropbox\ChangLab\Users\Emily\broca_repeat\eventfiles\wordlength_PW_eventfiles'

%%
dest='/data_store/human/raw_data'
main='/home/angela/Documents/artifacts'


%%

cd(main)
allartifacts=dir

for n=5:length(allartifacts)
    p=regexp(allartifacts(n).name,'[_,.]','split');
    %copyfile([main filesep allartifacts(n).name],[dest filesep p{1} filesep p{1} '_' p{2} filesep 'Artifacts'])
    %delete([dest filesep p{1} filesep p{1} '_' p{2} filesep 'Analog/bad*'])
    cd([dest filesep p{1} filesep p{1} '_' p{2} ])
    quickPreprocessing_ALL(pwd,2,0,1)
    movefile('Hilb*', ['/data_store/human/prcsd_data/' p{1} filesep p{1} '_' p{2}])
    try
        delete(['/data_store/human/prcsd_data/' p{1} filesep allartifacts(n).name filesep 'Artifacts/*'])
    end
    movefile('Artifacts/*',['/data_store/human/prcsd_data/' p{1} filesep p{1} '_' p{2}])
end
    
    




    