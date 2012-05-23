function convertRatTDT
%%PURPOSE: TDT to HTK conversion function for rat ecog
%%calls ui to get blocknames and destination path
%%Can select multiple blocks to convert
%%Extracts ecog and epoch data
%%Will automatically create a block in destination folder that has the same
%%block name
%%by Angela Ren, 11/1/11
%%uigetfiles by Douglas Schwarz
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
