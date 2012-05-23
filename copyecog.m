function copyecog(os)
%%os: w= Windows
%     l= Linux
%%
%What type of path?
type=input('Directory of blocks (0) or one block (1): ');

%%
%Get main path from user
mainPath=input('Input main path: ','s');

%%
%Get contents 
cd(mainPath)
if strmatch(os,'w')
    tmp=cellstr(ls);
    contents{1}=tmp(3:end);    
else
    contents=textscan(ls','%s');
end


%List contents
for i=1:length(contents{1})
    fprintf('%i. %s\n',i,contents{1}{i})
end

%%
%User input selection of contents

blocks=str2num(input('Choose block numbers:','s'));
if blocks==0
    blocks=3:length(contents{1});
end


%%
%List data type folders available
fprintf('1. RawHTK \n 2. Analog \n 3. Artifacts \n 4. High Gamma \n 5. All bands (real and imag) \n 6. Video Tracking \n 7. StimParams \n 8. LFP\n' ) 

folderTypes{1}='RawHTK';
folderTypes{2}='Analog';
folderTypes{3}='Artifacts';
folderTypes{4}='HilbAA_70to150_8band';
folderTypes{5}='HilbImag_4to200_40band';
folderTypes{6}='HilbReal_4to200_40band';
folderTypes{7}='Video Tracking';
folderTypes{8}='StimParams';
folderTypes{9}='LFP';


%%
%Get user input for folder selection
folders=str2num(input('Choose folder numbers:','s'));



%%
%Get destination path
destPath=input('Input destination path: ','s');


%%
%Copy files
for i=1:length(blocks)
    dest=sprintf('%s%s%s',destPath,filesep,contents{1}{blocks(i)});
    mkdir(dest)
    for j=1:length(folders)
        if folders==2
            try
                copyfile(sprintf('%s%s%s%s%s%sanalog*',mainPath,filesep,contents{1}{blocks(i)},filesep,folderTypes{folders(j)},filesep),sprintf('%s%s%s',dest,filesep,folderTypes{folders(j)}))
            end
            try
                copyfile(sprintf('%s%s%s%s%s%sANIN**',mainPath,filesep,contents{1}{blocks(i)},filesep,folderTypes{folders(j)},filesep),sprintf('%s%s%s',dest,filesep,folderTypes{folders(j)}))
            end
                
         else
            copyfile(sprintf('%s%s%s%s%s',mainPath,filesep,contents{1}{blocks(i)},filesep,folderTypes{folders(j)}),sprintf('%s%s%s',dest,filesep,folderTypes{folders(j)}))
            
        end
    end
    fprintf([dest ' Done\n'])
end

%%
%Repeat?
r=input('Another directory?','s');

if strmatch(r,'y')
    copyecog(os);
else
    return
end


