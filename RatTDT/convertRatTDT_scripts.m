%Where your TDT blocks live
mainPath='C:\Users\RatECoG_babcock\Desktop\TDT_programs\AuditoryStim_rp2_96_12ksamprate_nafi_TDT2\DataTanks\Rat7'
cd(mainPath)
blocks=cellstr(ls)

%Where you want to copy converted files
dest='C:\Users\RatECoG_babcock\Desktop\TDT_programs\AuditoryStim_rp2_96_12ksamprate_nafi_TDT2\DataTanks\Rat7\converted'

%% Goes through blocks and converts TDT format to HTK; Save epoch data as mat files

for i=[8,9,10] %length(blocks)
    rawDataPath=[mainPath '/' blocks{i}]
    cd(rawDataPath)
    %cd(sprintf('%s/%s',path,tmp2{i}))    
    ecogTDTData2MatlabConvertMultTags(pwd,blocks{i});

    mkdir(sprintf('%s/%s/%s',dest,blocks{i},'RawHTK'))
    movefile('Wav*.htk',sprintf('%s/%s/%s',dest,blocks{i},'RawHTK'));
    
    mkdir(sprintf('%s/%s/%s',dest,blocks{i},'LFP'))
    movefile('LFP*.htk',sprintf('%s/%s/%s',dest,blocks{i},'LFP'));
    
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
  
    movefile('Stim*.htk',sprintf('%s/%s/%s',dest,blocks{i},'Epochs'));
    movefile('Vrfy*.htk',sprintf('%s/%s/%s',dest,blocks{i},'Epochs'));

    cd(rawDataPath)
end
