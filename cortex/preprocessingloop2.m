
nohup taskset f00000 matlab -nodesktop
%% HILBERT OUTPUT ON CORTEX
addpath(genpath('/home/angela/Dropbox/AngelaSVN/'))
%blocks={'EC33_B30', 'EC33_B74'}
%success=[50]

sourceDir='/home/angela/Tmp'
tmp=dir([sourceDir filesep 'EC36']);
blocks={tmp.name};

for b=setdiff(3:length(blocks),6)
    %blocks{b}=['EC35' '_B' int2str(success(b))]
    s=regexp(blocks{b},'_','split')
    copyfile([sourceDir filesep s{1} filesep blocks{b} '/Artifacts'],['/data_store/human/raw_data/' s{1}  filesep  blocks{b} filesep 'Artifacts'])
    cd(['/data_store/human/raw_data/' s{1}  filesep blocks{b}])
    quickPreprocessing_ALL(pwd,3,0,1)
     try
         rmdir(['/data_store/human/prcsd_data/'  s{1}  filesep blocks{b} '/Hilb*'],'s')
     end
     
      try
         rmdir(['/data_store/human/prcsd_data/'  s{1}  filesep blocks{b} '/Artifacts*'],'s')
     end
%     try
%         copyfile(['/data_store/human/raw_data/' s{1} filesep blocks{b} '/Artifacts'],['/data_store/human/prcsd_data/' s{1}  filesep  blocks{b} filesep 'Artifacts'])
%     end 
    movefile(['/data_store/human/raw_data/' s{1}  filesep blocks{b} '/Art*'],['/data_store/human/prcsd_data/'  s{1}  filesep blocks{b}],'f')

    movefile(['/data_store/human/raw_data/' s{1}  filesep blocks{b} '/Hilb*'],['/data_store/human/prcsd_data/'  s{1}  filesep blocks{b}],'f')
end
%% COPY ARTIFACT FILES FROM LOCAL TO CRTX
nums=[37 34 28 13]
noArtifacts=[]
success=[]
blockNum=cellfun(@num2str,num2cell(nums),'UniformOutput',0)
for b=1:length(blockNum)
    try
        copyfile(['C:\Users\Angela_2\Desktop\EC33\EC33_B' blockNum{b} '\Artifacts'],...
            ['\\crtx\data_store\human\prcsd_data\EC33\EC33_B'  blockNum{b} '\Artifacts'],'f')    
        success=[success nums(b)]
    catch
        noArtifacts=[noArtifacts nums(b)]
    end
end
