%{
mainpath='/data/EC2'
cd(mainpath)

r=ls
for i=1:7
    [tok,r]=strtok(r)
    cd(tok)
    cd Analog
    [data,sampFreq]= readhtk ('ANIN1.htk');

    wavwrite((0.99*data/max(abs(data)))', sampFreq,'ANIN1.htk');
    cd(mainpath)
end
%}

mainpath='/data_store/SyllablesListening'
cd(mainpath)
[tok,r]=strtok(ls)

for i=1:7
    
    [tok,r]=strtok(r)
    %{
    cd([mainpath filesep tok filesep 'Analog'])
    [data,sampFreq]= readhtk ('ANIN1.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'analog1.wav');
    
    [data,sampFreq]= readhtk ('ANIN2.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'analog2.wav');
    
    [data,sampFreq]= readhtk ('ANIN3.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'analog3.wav');
    
    [data,sampFreq]= readhtk ('ANIN4.htk');
    wavwrite((0.99*data/max(abs(data)))', sampFreq,'analog4.wav');
    %}
   try
       quickPreprocessing1([mainpath filesep tok],1,0);
   catch
       fprintf('Oops\n')
   end
    
    cd(mainpath)
end

    