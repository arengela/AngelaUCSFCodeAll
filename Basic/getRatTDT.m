mainPath='E:\RawTDTData\RatEcog_7_15_11'
cd(mainPath)
blocks=cellstr(ls)
dest='E:\PreprocessedFiles\RatEcog_7_15_11'


for i=3:11
    
    rawDataPath=[mainPath '/' blocks{i}]
    tmp=ls([rawDataPath filesep '*.tev'])
    [p,tankName,e]=fileparts(tmp);
    
    TTX = actxcontrol('TTank.X');
    TTX.ConnectServer('Local', 'Me')
    TTX.OpenTank(mainPath,'R')
    TTX.SelectBlock(['~' blocks{i}])
  
    
    
    cd(rawDataPath)
    mkdir('Epochs')
    cd('Epochs')
    freq = TTX.GetEpocsV('Freq',0,0,1e7);
    dura = TTX.GetEpocsV('Dura',0,0,1e7);
    dely = TTX.GetEpocsV('Dely',0,0,1e7);
    ampl = TTX.GetEpocsV('Ampl',0,0,1e7);
    tick = TTX.GetEpocsV('Tick',0,0,1e7);
    save('freq','freq','-v7.3')
    save('dura','dura','-v7.3')
    save('dely','dely','-v7.3')
    save('ampl','ampl','-v7.3')
    save('tick','tick','-v7.3')
   
    TTX.CloseTank
    TTX.ReleaseServer
     copyfile([mainPath filesep blocks{i} filesep 'Epochs'], [dest filesep blocks{i} filesep 'Epochs'])
end




