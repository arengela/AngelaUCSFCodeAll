krisblocks{1}=[6, 5,6,17,18,19,23,24,26,27,28,29,30,31,39,40,44,46,47,48,49,50,51,52,53,54,55,57,58,60,61,62,64,65,67,68,69,79,80,81,82,87,88,89,90,91,92,93,94,95,98,99,100,106,107,108];
krisblocks{2}=[9 31,36,39,46,49,53,60,63]
krisblocks{3}=[8 1,2,4,9,12,13,14,15,39,40,41,42]
krisblocks{4}=[11 2,5,8,40,41,42,44,46,47,48,49,62,63,64,65,67,76,77,78,82]
krisblocks{5}=[31 14,28,35,75]
krisblocks{6}=[2 47,48]
krisblocks{7}=[33 47,48]

%%
k_blocks=[]
subj={}
%%
mainpath='E:\PreprocessedFiles\AllArtifacts3'
sampFreq=400;
%%Check if files exist on computer
dest='E:\PreprocessedFiles'
dest2='C:\Users\Angela_2\Documents\ECOGdataprocessing\PatientData'
%%
for i=1:5%size(k_blocks,1)
    if 1%k_blocks(i,4)~=2
        if ismember(k_blocks(i,1),[2,3,4,5,11,6,8,9])
            subjID=['EC' num2str(k_blocks(i,1))];
        else
            subjID=['GP' num2str(k_blocks(i,1))];
            
        end
        
        try
            %cd([dest filesep subjID filesep subjID '_B' num2str(k_blocks(i,2))])
        catch
            %cd([dest2 filesep subjID filesep subjID '_B' num2str(k_blocks(i,2))])
        end
        %cd ..
        %copyfile([dest filesep subjID filesep subjID '_B' num2str(k_blocks(i,2))],[mainpath filesep  subjID '_B' num2str(k_blocks(i,2))])
        %copyfile('Artifacts',[mainpath filesep  subjID '_B' num2str(k_blocks(i,2))])
        %copyfile('RawHTK',[mainpath filesep  subjID '_B' num2str(k_blocks(i,2))])
        %copyfile(['E:\PreprocessedFiles\TIMIT\' subjID '_B' num2str(k_blocks(i,2)) filesep 'HilbAA_70to150_8band','K:\Timit')
        %delete('Figures','RawHTK','Downsample400','original_RawHTK')
        %quickPreprocessing_ALL(pwd,7,0,1);
        %quickPreprocessing_ALL(pwd,3,0,1);
        
        try
            cd([dest filesep subjID filesep subjID '_B' num2str(k_blocks(i,2))])
            preprocessing_GUI(pwd)
            keyboard
            close all
            k_blocks(i,3)=2;
        end
       
        %%
        %{
            ecog=loadHTKtoEcog_CT(sprintf('%s/%s',pwd,'RawHTK'),256,[]);
            baselineDurMs=0;
            sampDur=1000/ecog.sampFreq;
            ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
            ecog=downsampleEcog(ecog,sampFreq);

            allDS{i}=ecog.data;

            k_blocks(i,3)=3;
        %}
        %%
        %([dest2 filesep subjID filesep subjID '_B' num2str(k_blocks(i,2))])
        %copyfile('Artifacts',[mainpath filesep  subjID '_B' num2str(k_blocks(i,2))])

        %{
                rmdir('Figures','s')
                            rmdir('RawHTK','s')
                            try
                             rmdir( 'Downsampled400','s')
                            end
                            try
                             rmdir('original_RawHTK','s')
                            end
        %}
        %quickPreprocessing_ALL(pwd,7,0,1);
        %{
                preprocessing_GUI(1)
                keyboard
                close all
                k_blocks(i,3)=3;
        %}
        %{
                ecog=loadHTKtoEcog_CT(sprintf('%s/%s',pwd,'RawHTK'),256,[]);
                baselineDurMs=0;
                sampDur=1000/ecog.sampFreq;
                ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
                ecog=downsampleEcog(ecog,sampFreq);

                allDS{i}=ecog.data;
                k_blocks(i,3)=3;
        %}
        
    end
end
%{
    [uV sV] = memory;
    if  sV.PhysicalMemory.Available<  1.3533e+07
        break
    end
%}

%%

allArray=[]
for i=1:length(k_blocks)
    if ~isempty(allDS{i})
        allArray=[allArray; allDS{i}(:,1:6000)];
        
    end
end