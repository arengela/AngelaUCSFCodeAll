%%
mainpath='/data_store/human/raw_data'
dest='/data_store/human/prcsd_data'
blocks{1}=[9 31,36,39,46,49,53,60,63];
blocks{2}=[8,2,4,9,12,13,14,15,39,40,41,42];
blocks{3}=[11 2,5,8,40,41,42,44,46,47,48,49,62,63,64,65,67,76,77,78,82];
blocks{4}=[31 14,28,35,75];
blocks{5}=[2 47,48];
blocks{6}=[33 31,38];
Patients={'EC9','EC8','EC11','GP31','EC2','GP33'}
er=[]
for p=2:6
    for i=1:length(blocks{p})
        try
            cd([mainpath filesep Patients{p} filesep Patients{p} '_B' int2str(blocks{p}(i)) filesep 'Analog']);

             [data1,sampFreq]= readhtk ('ANIN1.htk');
                [data2,sampFreq]= readhtk ('ANIN2.htk');
                [data3,sampFreq]= readhtk ('ANIN3.htk');
                [data4,sampFreq]= readhtk ('ANIN4.htk');    

                wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
                wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
                wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
                wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');
                mkdir([dest filesep Patients{p} filesep Patients{p} '_B' int2str(blocks{p}(i)) filesep 'Analog']);
                movefile('an*',[dest filesep Patients{p} filesep Patients{p} '_B' int2str(blocks{p}(i)) filesep 'Analog']);
        catch
            er=horzcat(er,[p;i]);
        end
                    
    end
end

%%
mainpath='E:\PreprocessedFiles';
mainpath='C:\TDT\OpenEx\Tanks\ECOG256';

for j=1:length(er)
    p=er(1,j);
    i=er(2,j);
        try
           % cd([mainpath filesep Patients{p} filesep Patients{p} '_B' int2str(blocks{p}(i)) filesep 'Analog']);
          cd([mainpath filesep Patients{p} filesep Patients{p} '_B' int2str(blocks{p}(i)) ]);
          er(3,j)=2;
        catch
            
        end
                    
end


%%

mainpath='C:\TDT\OpenEx\Tanks\ECOG256';
destinationPath='E:\ConvertedEcog';

for j=1:length(er)
    p=er(1,j);
    i=er(2,j);
    try
        blockname=[Patients{p} '_B' int2str(blocks{p}(i))];
        cd([mainpath filesep Patients{p} filesep blockname ]);
        
        er(3,j)=2;
        
        ecogTDTData2MatlabConvertMultTags(pwd,blockname);
        %mkdir(sprintf('%s/%s',destinationPath,tmp2{i}))
        %mkdir(sprintf('%s/%s/%s',newDir,tmp2{i},sprintf('%s_data',tmp2{i})))
        %mkdir(sprintf('%s/%s/%s_data/%s',newDir,tmp2{i},tmp2{i},'RawHTK'))
        mkdir(sprintf('%s/%s/%s',destinationPath,blockname,'RawHTK'))
        mkdir(sprintf('%s/%s/%s',destinationPath,blockname,'Analog'))
        movefile('Wav*.htk',sprintf('%s/%s/%s',destinationPath,blockname,'RawHTK'));
        try
            movefile('ANIN*.htk',sprintf('%s/%s/Analog',destinationPath,blockname));
        catch
            fprintf('No Analog')
        end

        try
            movefile('Trck*.htk',sprintf('%s/%s/VideoTracking',destinationPath,blockname));
        catch
            fprintf('No Video')
        end

        try
           movefile('LFP*.htk',sprintf('%s/%s',destinationPath,blockname));
        end

        mkdir(sprintf('%s/%s/Artifacts',destinationPath,blockname))
        %mkdir(sprintf('%s/%s/Figures',destinationPath,blockname))
        cd(sprintf('%s/%s/Analog',destinationPath,blockname))

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



       er(3,j)=3;

        cd ..
    catch
        printf('error')
    end

end