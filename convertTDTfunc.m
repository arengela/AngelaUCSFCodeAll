function convertTDTfunc(os,flag,blocks)
%%os: w= Windows
%     l= Linux
%%
%What type of path?
flag
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




%{
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
%}

%%
%Get user input for folder selection
%folders=str2num(input('Choose folder numbers:','s'));



%%
%Get destination path
destPath=input('Input destination path: ','s');


%%
%Convert TDT to HTK

for i=1:length(blocks)
    %Create source and destination paths
    dest=sprintf('%s%s%s',destPath,filesep,contents{1}{blocks(i)});
    mkdir(dest)
    source=sprintf('%s%s%s',mainPath,filesep,contents{1}{blocks(i)});
    cd(source);
    
    if flag==1
        %convert Analog to wav
        cd('Analog')
        
        [data1,sampFreq]= readhtk ('ANIN1.htk');
        [data2,sampFreq]= readhtk ('ANIN2.htk');
        [data3,sampFreq]= readhtk ('ANIN3.htk');
        [data4,sampFreq]= readhtk ('ANIN4.htk');    
    
        wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
        wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
        wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
        wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');
        mkdir(sprintf('%s/%s/%s',destinationPath,tmp2{i},'Analog'))
        movefile('an*',sprintf('%s%s%s',dest,filesep,'Analog'));
        
    else
    %convert to HTK and move to RawHTK folder
    ecogTDTData2MatlabConvertMultTags(pwd,contents{1}{blocks(i)});
    mkdir(sprintf('%s%s%s',dest,filesep,'RawHTK'));
    movefile('Wav*',sprintf('%s%s%s',dest,filesep,'RawHTK'));
   movefile('ANIN*',sprintf('%s%s%s',dest,filesep,'Analog'));

    
    %Convert Analog to .wav files, and move to Analog folder
    
    try
        [data1,sampFreq]= readhtk ('ANIN1.htk');
        [data2,sampFreq]= readhtk ('ANIN2.htk');
        [data3,sampFreq]= readhtk ('ANIN3.htk');
        [data4,sampFreq]= readhtk ('ANIN4.htk');    
    
        wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
        wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
        wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
        wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');
        mkdir(sprintf('%s/%s/%s',destinationPath,tmp2{i},'Analog'))
        movefile('an*',sprintf('%s%s%s',dest,filesep,'Analog'));
    catch
        fprintf('No Analog')
    end    
    
    %Move tracking data to VideoTracking folder
    try
        movefile('Trck*.htk',sprintf('%s%s%s',dest,filesep,'VideoTracking'));
    catch
        fprintf('No Video')
    end
    
    %Move LFP data to LFP folder
    try
       movefile('LFP*.htk',sprintf('%s%s%s',dest,filesep,'LFP'));
    end
    end
    
    %Make Figures folder
    %mkdir(sprintf('%s%s%s',dest,filesep,'Figures'));
    
    %Make Artifacts folder and create empty badChannels and BadTimeSegments
    %mkdir(sprintf('%s%s%s',dest,filesep,'Artifacts'));
    %cd(sprintf('%s%s%s',dest,filesep,'Artifacts'));
    
    %BadTimesConverterGUI([],'bad_time_segments.lab');
    %fid = fopen('badChannels.txt', 'w');
    %fprintf(fid, '%6.0f', []);
    %fclose(fid);
end

