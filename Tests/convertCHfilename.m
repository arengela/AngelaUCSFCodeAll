sourcePath='E:\PreprocessedFiles\CH\CH'
cd(sourcePath)
blocks=cellstr(ls)
for j=3:length(blocks) 
    cd([sourcePath filesep blocks{j} '\RawHTK'])
    files=cellstr(ls)
    for i=3:length(files)
        [a,b,c]=readhtk(files{i});
        chanNum=str2num(cell2mat(regexp(files{i},'[1234567890]','match')));
        if chanNum<=64
            blockNum=1;
        else
            blockNum=2;
            chanNum=chanNum-64;
        end
        mkdir([sourcePath filesep blocks{j} '\RawHTK_numchange'])
        writehtk([sourcePath filesep blocks{j} '\RawHTK_numchange\Wav' num2str(blockNum) num2str(chanNum) '.htk'],a,b,c)
    end
    %rmdir([sourcePath filesep blocks{j} '\RawHTK'],'s')
     %movefile([sourcePath filesep blocks{j} '\RawHTK\*'],[sourcePath filesep blocks{j} '\RawHTK_original\'])
     movefile([sourcePath filesep blocks{j} '\RawHTK_numchange\*'],[sourcePath filesep blocks{j} '\RawHTK\'])

end
