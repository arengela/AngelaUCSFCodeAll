function convert_analog(pathName, analogChan)
    cd(pathName);
    load(analogChan);
    %analog_1=data;
    %save('analog_1','analog_1')
    %wavwrite(data',params.sampFreq,'articulation')
    wavwrite(data',params.sampFreq,'buttonDa')
end
        
        
