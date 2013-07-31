function ecog=loadHTKFile_Name(folderPath,filenames,timeInt)
currentPath=pwd;
cd(folderPath)
for i=1:length(filenames)
    if ~exist('timeInt') || ~isempty(timeInt)
        [data, sampFreq, tmp,chanNum] = readhtk ([filenames{i} '.htk']);
    else
        [data, sampFreq, tmp,chanNum] = readhtk ([filenames{i} '.htk'],timeInt);
    end
    if i==1
        ecog.data=zeros(length(filenames),size(data,2),size(data,1));
    end
    ecog.data(i,:,:)=data';
    ecog.sampFreq=sampFreq;
    fprintf([filenames{i} '.\n'])
end
end