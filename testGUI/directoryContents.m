function directoryContents(filename)


fileList=getSubDir(filename)

for i=1:length(fileList)
     f(i).path=fileList{i};
end

t= regexp({f.path},'Analog')
find([t{:}])
t=strmatch('Analog',{f.path})

%%
function fileList=getSubDir(filename)

tmp=dir(filename);
subdir=tmp(find([tmp.isdir]&~ismember({tmp.name},{'.','..'})));
fileList=cellfun(@(x) fullfile(filename,x),{subdir.name},'UniformOutput',false); %# Prepend path to files
for i=1:length(fileList)
    f=getSubDir(fileList{i});
    fileList=horzcat(fileList,f); 
end