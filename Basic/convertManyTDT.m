path='C:\TDT\OpenEx\Tanks\ECOG256';
cd(path)
tmp=ls;
%tmp2=cellstr(tmp);
destinationPath='E:\PreprocessedFiles';

num=[6,73,75,80,84,85,86,87,89,94,95]
%{
tmp2={'EC11_B3';
    'EC11_B21';
'EC11_B22';    
'EC11_B25';
}
%}

for n=1:length(num)
    tmp2{n}=['EC11_B' num2str(num(n))]
end


for i=5:11
    cd(sprintf('%s/%s',path,tmp2{i}))    
    ecogTDTData2MatlabConvertMultTags(pwd,tmp2{i});
    %mkdir(sprintf('%s/%s',destinationPath,tmp2{i}))
    %mkdir(sprintf('%s/%s/%s',newDir,tmp2{i},sprintf('%s_data',tmp2{i})))
    %mkdir(sprintf('%s/%s/%s_data/%s',newDir,tmp2{i},tmp2{i},'RawHTK'))
    mkdir(sprintf('%s/%s/%s',destinationPath,tmp2{i},'RawHTK'))
    mkdir(sprintf('%s/%s/%s',destinationPath,tmp2{i},'Analog'))
    movefile('Wav*.htk',sprintf('%s/%s/%s',destinationPath,tmp2{i},'RawHTK'));
    try
        movefile('ANIN*.htk',sprintf('%s/%s/Analog',destinationPath,tmp2{i}));
    catch
        fprintf('No Analog')
    end
    
    try
        movefile('Trck*.htk',sprintf('%s/%s/VideoTracking',destinationPath,tmp2{i}));
    catch
        fprintf('No Video')
    end
    
    try
       movefile('LFP*.htk',sprintf('%s/%s',destinationPath,tmp2{i}));
    end
    
    mkdir(sprintf('%s/%s/Artifacts',destinationPath,tmp2{i}))
    mkdir(sprintf('%s/%s/Figures',destinationPath,tmp2{i}))
    cd(sprintf('%s/%s/Analog',destinationPath,tmp2{i}))
    
    try
        [data1,sampFreq]= readhtk ('ANIN1.htk');
        [data2,sampFreq]= readhtk ('ANIN2.htk');
        [data3,sampFreq]= readhtk ('ANIN3.htk');
        [data4,sampFreq]= readhtk ('ANIN4.htk');    
    
        wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
        wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
        wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
        wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');
    catch
        fprintf('No Analog')
    end
    

        

    
    cd ..

end
%%
for i=13:19
    %{
    cd(sprintf('%s/%s',path,tmp2{i}))    
    ecogTDTData2MatlabConvertMultTags(pwd,tmp2{i});
    %mkdir(sprintf('%s/%s',destinationPath,tmp2{i}))
    %mkdir(sprintf('%s/%s/%s',newDir,tmp2{i},sprintf('%s_data',tmp2{i})))
    %mkdir(sprintf('%s/%s/%s_data/%s',newDir,tmp2{i},tmp2{i},'RawHTK'))
    mkdir(sprintf('%s/%s/%s',destinationPath,tmp2{i},'RawHTK'))
    mkdir(sprintf('%s/%s/%s',destinationPath,tmp2{i},'Analog'))
    movefile('Wav*.htk',sprintf('%s/%s/%s',destinationPath,tmp2{i},'RawHTK')); 
    movefile('ANIN*.htk',sprintf('%s/%s/Analog',destinationPath,tmp2{i}));
    movefile('Trck*.htk',sprintf('%s/%s/VideoTracking',destinationPath,tmp2{i}));
    mkdir(sprintf('%s/%s/Artifacts',destinationPath,tmp2{i}))
    mkdir(sprintf('%s/%s/Figures',destinationPath,tmp2{i}))
    %}
    cd(sprintf('%s/%s/Analog',destinationPath,tmp2{i}))
    [data1,sampFreq]= readhtk ('ANIN1.htk');
    [data2,sampFreq]= readhtk ('ANIN2.htk');
    [data3,sampFreq]= readhtk ('ANIN3.htk');
    [data4,sampFreq]= readhtk ('ANIN4.htk');
    
    wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
    wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
    wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
    wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');
    cd ..

end

