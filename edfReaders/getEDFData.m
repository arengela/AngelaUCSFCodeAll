function handles=convertEDFToMAT(filepaths)
    for i=1:length(filepaths)
        [ allChanData, samplingRates, annotations, headerInfo ] = edfExtractAllData( filepaths{i} );
        EDFstruct.allChanData=allChanData;
        EDFstruct.samplingRates=samplingRates;
        EDFstruct.annotations=annotations;
        EDFstruct.headerInfo=headerInfo;
        eegStartTime=datestr(datenum(EDFstruct.headerInfo.startDateVec)+EDFstruct.headerInfo.factionsecondstart/(60*60*24));
        save(['EDFstruct_' subj '_' num2str( datevec(eegStartTime))],'EDFstruct','-v7.3');
    end
end



