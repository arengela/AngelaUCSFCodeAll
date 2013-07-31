function [edfData,headerInfo]=loadEDFData(startTime,duration,edfFolder,flag)
% startTime: startTime of block in matlab vector format. If imprecise,
% round to earlier time and then sync data afters
% duration: duration you want to extract (ie duration of tdt block) in
% seconds. If imprecise, round up
% edfFolder: path of folder containing edf files. Will extract header info
% to get start times
%flag: 1 if edf files are in matlab structure form, 2 if in edf form

    [edfTimes,edfNames]=getEDFtimes(edfFolder,flag);
    useIdx=getClosestEDF(startTime,duration,edfTimes);       
    useNames=edfNames(useIdx);
    [edfData,headerInfo]=loadEDFFiles(useNames,startTime,duration,flag);
end


function [edfStructTimes,edfStructNames]=getEDFtimes(edfFolder,flag)
    cd(edfFolder)
    switch flag 
        case 1
            structNames=dir('*.mat');
        case 2
            structNames=dir('*.edf');
    end
    for i=1:length(structNames)        
        switch flag
            case 1
                tmp=regexp(structNames(i).name,'_','split');
                tmp2=regexp(tmp{end},'.mat','split');
                edfStructTimes(i)=datenum(str2num(tmp2{1}));
            case 2
                [headerInfo] = edfExtractHeader(structNames(i).name);
                edfStructTimes(i)=datenum(headerInfo.startDateVec)+headerInfo.factionsecondstart/(60*60*24); 
        end
        
    end
    [edfStructTimes,idx]=sort(edfStructTimes);
    edfStructNames={structNames(idx).name};
end

function useIdx=getClosestEDF(startTime,duration,edfTimes)
    diffTime=datenum(startTime)-edfTimes;
    diffTime(diffTime<0)=NaN;
    [~,i]=nanmin(diffTime);
    newStartTime=edfTimes(i);
    
    diffTime=edfTimes-addtodate(datenum(startTime),duration,'second');
    diffTime(diffTime>0)=NaN;
    [~,i]=max(diffTime);
    newEndTime=edfTimes(i);
    
    useIdx=find(datenum(edfTimes)>=datenum(newStartTime) & datenum(edfTimes)<=datenum(newEndTime));
end

function  [edfData,headerInfo]=loadEDFFiles(useNames,startTime,duration,flag)
    for x=1:length(useNames)
        switch flag
            case 2
                [allChanData, samplingRates, annotations, headerInfo ] = edfExtractAllData( useNames{x} );
                EDFstruct.allChanData=allChanData;
                EDFstruct.samplingRates=samplingRates;
                EDFstruct.annotations=annotations;
                EDFstruct.headerInfo=headerInfo; 
            case 1
                load(useNames{x});
        end
            
        
       
        
        if x==1
            eegStartTime=datenum(EDFstruct.headerInfo.startDateVec)+EDFstruct.headerInfo.factionsecondstart/(60*60*24)
            elapsedSec=(datenum(startTime)-eegStartTime)*24*60*60;
            startSamp=floor(elapsedSec*512);
        else
            startSamp=1;
        end
        
        if x==length(useNames)
            eegStartTime=datenum(EDFstruct.headerInfo.startDateVec)+EDFstruct.headerInfo.factionsecondstart/(60*60*24)
            elapsedSec=(addtodate(datenum(startTime),duration,'second')-eegStartTime)*24*60*60;
            endSamp=ceil(elapsedSec*512);
        else
            endSamp=size(EDFstruct.allChanData{1},2);
        end   
        
         for chan=1:length(EDFstruct.allChanData)
            d=EDFstruct.allChanData{chan}';
            tmp=resample(d(startSamp:endSamp),400,512);
            if ~exist('d400')
                d400=zeros(length(EDFstruct.allChanData),length(tmp));
            end
            d400(chan,:)=tmp;
        end      
        
        
        
        holdd400{x}=d400;
        clear d400;
    end
    headerInfo= EDFstruct.headerInfo;
    edfData=horzcat(holdd400{:});
end