function convertTDTorg(type,blockpaths)
%%PURPOSE: TDT to HTK conversion function for rat ecog
%%calls ui to get blocknames and destination path
%%Can select multiple blocks to convert
%%Extracts ecog and epoch data
%%Will automatically create a block in destination folder that has the same
%%block name
%%by Angela Ren, 11/1/11
%%uigetfiles by Douglas Schwarz

if type==2 %rat
    blockpaths=uipickfiles('prompt','Pick blocks to convert','filterspec','C:\Users\RatECoG_babcock\Desktop\TDT_programs\');
    pause(.5)
    dest=uigetdir('C:\Users\RatECoG_babcock\Desktop\TDT_programs\','Select destination directory');


    for i=1:length(blockpaths)
        rawDataPath=blockpaths{i};
        [~,blocks{i}]=fileparts(blockpaths{i});
        %%
        %Extract and move ecog information
        cd(rawDataPath)
        ecogTDTData2MatlabConvertMultTags(pwd,blocks{i});

        mkdir(sprintf('%s/%s/%s',dest,blocks{i},'RawHTK'))
        movefile('Wav*.htk',sprintf('%s/%s/%s',dest,blocks{i},'RawHTK'));

        mkdir(sprintf('%s/%s/%s',dest,blocks{i},'LFP'))
        movefile('LFP*.htk',sprintf('%s/%s/%s',dest,blocks{i},'LFP'));
        %%    
        %Extract and move epoch information
        cd(rawDataPath)

        tmp=ls([rawDataPath filesep '*.tev'])
        [p,tankName,e]=fileparts(tmp);

        TTX = actxcontrol('TTank.X');
        TTX.ConnectServer('Local', 'Me')
        TTX.OpenTank(mainPath,'R')
        TTX.SelectBlock(['~' blocks{i}])

        freq = TTX.GetEpocsV('Freq',0,0,1e7);
        dura = TTX.GetEpocsV('Dura',0,0,1e7);
        dely = TTX.GetEpocsV('Dely',0,0,1e7);
        ampl = TTX.GetEpocsV('Ampl',0,0,1e7);
        tick = TTX.GetEpocsV('Tick',0,0,1e7);


        TTX.CloseTank
        TTX.ReleaseServer   

        mkdir([dest filesep blocks{i} filesep 'Epochs'])
        cd([dest filesep blocks{i} filesep 'Epochs'])
        save('freq','freq','-v7.3')
        save('dura','dura','-v7.3')
        save('dely','dely','-v7.3')
        save('ampl','ampl','-v7.3')
        save('tick','tick','-v7.3')
        %%    
        %Move Stim and Vrfy variables if they exist
        cd(rawDataPath) 

       try
             movefile('Stim*.htk',sprintf('%s/%s/%s',dest,blocks{i},'Epochs'));
             movefile('Vrfy*.htk',sprintf('%s/%s/%s',dest,blocks{i},'Epochs'));
       end
    end
else if type==1
        if ~exist('blockpaths')            
             blockpaths=uipickfiles('prompt','Pick blocks to convert','filterspec','C:\Users\RatECoG_babcock\Desktop\TDT_programs\');
            pause(.5)
        end
        
        dest=uigetdir('C:\Users\RatECoG_babcock\Desktop\TDT_programs\','Select destination directory');
        


        for i=1:length(blockpaths)
            try
                rawDataPath=blockpaths{i};
                [~,blocks{i}]=fileparts(blockpaths{i});
                s=regexp(blocks{i},'_','split');
                %%
                %Extract and move ecog information
                cd(rawDataPath)
                ecogTDTData2MatlabConvertMultTags(pwd,blocks{i});

                tmp=sprintf('%s/raw_data/%s/%s/%s',dest,s{1},blocks{i},'RawHTK');
                mkdir(tmp)
                movefile('Wav*.htk',tmp);


                tmp=sprintf('%s/raw_data/%s/%s/%s',dest,s{1},blocks{i},'Analog');
                mkdir(tmp)
                movefile('ANIN*.htk',tmp);



                  %convert Analog to wav
                cd(tmp)

                [data1,sampFreq]= readhtk ('ANIN1.htk');
                [data2,sampFreq]= readhtk ('ANIN2.htk');
                [data3,sampFreq]= readhtk ('ANIN3.htk');
                [data4,sampFreq]= readhtk ('ANIN4.htk');    

                wavwrite((0.99*data1/max(abs(data1)))', sampFreq,'analog1.wav');
                wavwrite((0.99*data2/max(abs(data2)))', sampFreq,'analog2.wav');
                wavwrite((0.99*data3/max(abs(data3)))', sampFreq,'analog3.wav');
                wavwrite((0.99*data4/max(abs(data4)))', sampFreq,'analog4.wav');

                tmp=sprintf('%s/prcsd_data/%s/%s/%s',dest,s{1},blocks{i},'Analog');
                mkdir(tmp)
                movefile('an*.wav',tmp);
            end



        end
        
        
        
    end
    
end

    
    
    
    