%make test data
mainpath='E:\PreprocessedFiles\EC20'
blocknames={'EC20_B10','EC20_B11','EC20_B12','EC20_B13'};
loadload;close;

for i=1:length(blocknames)
    ecog=loadHTKtoEcog([mainpath filesep blocknames{i} '\HilbAA_70to150_8band']);
    cd([mainpath filesep blocknames{i} '\Analog'])
    load timeinterval
    [tmp,fs]=readhtk('ANIN2.htk');
    tmp=resample(tmp,16000,round(fs));

    tmp=tmp(timeinterval(1)*16000:timeinterval(2)*16000);
    
    
    aud{i}= wav2aud6oct(tmp);
    
    data=mean(ecog.data(:,timeinterval(1)*ecog.sampFreq:timeinterval(2)*ecog.sampFreq,:),3);
    for c=1:size(data{i},1)
        data100{i}(c,:)=resample(data(c,:),1,4);
    end
end

%%

StimTrain=vertcat({aud})';
TrainResp=horzcat({data100})';
[g,rstim] = StimuliReconstruction (StimTrain, TrainResp);