mainpath='E:\PreprocessedFiles'
mainpath='/data_store/human/prcsd_files'
for n=1:size(alllog,1)
    try
        s=regexp(alllog{n,1},'_','split');
        cd([mainpath filesep s{1} filesep alllog{n,1} filesep 'Artifacts']);
        %load 'badTimeSegments.mat'

        fid = fopen('badChannels.txt');
        badChan = fscanf(fid, '%d');
        fclose(fid);

        alllog{n,20}=badChan';
        clear badChan;
    end
end
    
    