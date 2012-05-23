pathname='E:\PreprocessedFiles'
dest='M:\PreprocessedFiles';
cd(pathname)

patients=cellstr(ls)

for i=3:length(patients)
    cd([pathname '/' patients{i}])
    blocks=cellstr(ls);
    for j=3:length(blocks)
        cd(blocks{j})
        contents=cellstr(ls);
        if ~isempty(strmatch('Artifacts',contents))
            dest2=[dest '/' patients{i} '/' blocks{j} '/Artifacts'];
            mkdir(dest2)
            copyfile('Artifacts',dest2)
        end
        cd ..
    end
end