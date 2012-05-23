path='E:\PreprocessedFiles\GP31';
cd(path)
tmp=ls;
tmp2=cellstr(tmp);
m=1;

%%
for i=3:9
    filesall{m}=sprintf('%s/%s',path,tmp2{i});
    m=m+1;
end

%%
filesall{1}=[path '/GP31_B3']
filesall{2}=[path '/GP31_B15']
filesall{3}=[path '/GP31_B16']
filesall{4}=[path '/GP31_B17']
filesall{5}=[path '/GP31_B18']
filesall{6}=[path '/GP31_B19']
filesall{7}=[path '/GP31_B20']
filesall{8}=[path '/GP31_B23']
filesall{9}=[path '/GP31_B24']
filesall{10}=[path '/GP31_B57']
filesall{11}=[path '/GP31_B58']
filesall{12}=[path '/GP31_B59']
filesall{13}=[path '/GP31_B74']
filesall{14}=[path '/GP31_B77']




%%

for i=1:13
    handles.pathName=filesall{i};
    [a,b,c]=fileparts(handles.pathName);
    handles.blockName=b;
    newpathname=sprintf('%s/%s','L:\PreprocessedFilesCRMGP31',b);
    mkdir(newpathname)
    
    
    handles.newfolderName=sprintf('%s/RawHTK',newpathname);
    mkdir(handles.newfolderName)       
    source1=sprintf('%s/RawHTK',handles.pathName); 
    copyfile(source1,handles.newfolderName); 
    
    
    source1b=sprintf('%s/HilbAA_70to150_8band',handles.pathName);  
    handles.newfolderName2=sprintf('%s/HilbAA_70to150_8band',newpathname);
     mkdir(handles.newfolderName2)   
    copyfile(source1b,handles.newfolderName2); 
    
    
    source2=sprintf('%s/%s_data/badChannels.txt',handles.pathName,handles.blockName); 
    if exist(source2)
        copyfile(source2,newpathname); 
    end
   
        source3=sprintf('%s/%s_data/bad_time_segments.lab',handles.pathName,handles.blockName); 
    if exist(source3)
        copyfile(source3,newpathname);
    end
    %{
     source4=sprintf('%s/%s_data/articulation.wav',handles.pathName,handles.blockName); 
     copyfile(source4,newpathname);
     %}
    %{ 
     source5=sprintf('%s/%s_data/transcript.lab',handles.pathName,handles.blockName); 
     if any(i==[1,2,3,28,27,26])
        copyfile(source5,newpathname);
    end
     %}
     
    %COPY ANALOG FILE
    source6=sprintf('%s/ANIN1.htk',handles.pathName); 
    copyfile(source6,newpathname);
end
%%

for i=12:16
    handles.pathName=filesall{i};
    [a,b,c]=fileparts(handles.pathName);
    handles.blockName=b;
    newpathname=sprintf('%s/%s','L:\PreprocessedFiles',b);
    %mkdir(newpathname)
    
    cd(filesall{i})
    [data,sampFreq] = readhtk ('ANIN3.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'articulation');


    source1=sprintf('%s/articulation.wav',handles.pathName); 
    copyfile(source1,newpathname); 
    movefile('articulation.wav',sprintf('%s/%s_data',handles.pathName,handles.blockName));

end
%%
%%

for i=2:7
    handles.pathName=filesall{i};
    [a,b,c]=fileparts(handles.pathName);
    handles.blockName=b;
    newpathname=sprintf('%s/%s','L:\MultitaperTests',b);
    mkdir(newpathname)
    
    handles.newfolderName=sprintf('%s/Multitaper_70to150_40bands',newpathname);
    mkdir(handles.newfolderName)       
    source1=sprintf('%s/%s_data/Multitaper_70to150_40bands',handles.pathName,handles.blockName); 
    copyfile(source1,handles.newfolderName);
    
        handles.newfolderName=sprintf('%s/HilbAA_70to150_8bands',newpathname);
    mkdir(handles.newfolderName)       
    source1=sprintf('%s/%s_data/HilbAA_70to150_8bands',handles.pathName,handles.blockName); 
    copyfile(source1,handles.newfolderName);

end
%%

filesall={
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP31\ARTICULATION\GP31_B78';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP31\ARTICULATION\GP31_B82';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP31\ARTICULATION\GP31_B83';
        'C:\Users\Angela\Documents\ECOGdataprocessing\EC1\Articulation\EC1_B1';
    'C:\Users\Angela\Documents\ECOGdataprocessing\EC1\Articulation\EC1_B7';
      'C:\Users\Angela\Documents\ECOGdataprocessing\GP29\Articulation\GP29_B5';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP29\Articulation\GP29_B10';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP29\Articulation\GP29_B11';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP29\Articulation\GP29_B12';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP29\Articulation\GP29_B13';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP29\Articulation\GP29_B2';
        'C:\Users\Angela\Documents\ECOGdataprocessing\GP26\Articulation\GP26_B7';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP26\Articulation\GP26_B8';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP26\Articulation\GP26_B14';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP26\Articulation\GP26_B16';
    'C:\Users\Angela\Documents\ECOGdataprocessing\GP26\Articulation\GP26_B13';
    
    }




%{
for i=1:1
    handles.pathName=filesall{i};
    [a,b,c]=fileparts(handles.pathName);
    handles.blockName=b;
    newpathname='C:\Users\Angela\Documents\ECOGdataprocessing\EC2\UpdatedPreprocessedFiles';
    sourcepath=sprintf('%s/%s_data',handles.pathName,handles.blockName);
    copyfile(sourcepath, newpathname);
%}