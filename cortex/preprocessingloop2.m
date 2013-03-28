
nohup taskset 0f0000 matlab -nodesktop
%% HILBERT OUTPUT ON CORTEX
addpath(genpath('/home/angela/Dropbox/AngelaSVN/'))
%blocks={'EC33_B30', 'EC33_B74'}
success=[12 17 2 34 35 4 43 44 60 9]
for b=1:length(success)
    blocks{b}=['EC37' '_B' int2str(success(b))]
    s=regexp(blocks{b},'_','split')
     try
         copyfile(['/data_store/human/prcsd_data/' s{1} filesep blocks{b} '/Artifacts'],['/data_store/human/raw_data/' s{1}  filesep  blocks{b} filesep 'Artifacts'])
     end
    cd(['/data_store/human/raw_data/' s{1}  filesep blocks{b}])
    quickPreprocessing_ALL(pwd,3,0,1)
%     try
%         rmdir(['/data_store/human/prcsd_data/'  s{1}  filesep blocks{b} '/Hilb*'],'s')
%     end
%     try
%         copyfile(['/data_store/human/raw_data/' s{1} filesep blocks{b} '/Artifacts'],['/data_store/human/prcsd_data/' s{1}  filesep  blocks{b} filesep 'Artifacts'])
%     end

    
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