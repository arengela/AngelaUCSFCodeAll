function convertEDF(flag,subj,blockpaths)
%PURPOSE: RENAME ALL EDF FILES TO THE START TIME AND DATE, AS WELL AS SUBJ
%ID PREFIX. OPENS DIALOG WINDOW TO SELECT EDF FILES TO RENAME. WILL USE
%EDFREADER TO READER HEADER INFO, AND RENAME EACH SELECTED FILE. INPUT SUBJ
%ID TO PREFACE DATE/VECTOR 
%INPUTS (OPTIONAL):
%flag: 1 to just rename EDf files (default), 2 to save as matlab structures
%subj: prefaces all renamed files with this string. If not entered, will assume
%edf files are in folder labeled with subject ID, and will use that as
%prefix.
%blockpaths: cell array of full paths to edf files. If this is an input,
%will bypass GUI
    if nargin<1
        flag=1;
    end
    if nargin<3
         blockpaths=uipickfiles('prompt','Pick blocks to convert');
    end
    for i=1:length(blockpaths)
        mainPath=fileparts(blockpaths{i});
        if nargin<2 || isempty(subj)
           [a,subj]=fileparts(mainPath);           
        end

            
        switch flag
            case 1
                [headerInfo] = edfExtractHeader(blockpaths{i});
                EDFstruct.headerInfo=headerInfo;
                eegStartTime=datestr(datenum(EDFstruct.headerInfo.startDateVec)+EDFstruct.headerInfo.factionsecondstart/(60*60*24));  
                try
                    movefile(blockpaths{i},[mainPath filesep subj '_' num2str( datevec(eegStartTime)) '.edf']);
                catch
                    printf('error');
                end
            case 2
                [ allChanData, samplingRates, annotations, headerInfo ] = edfExtractAllData( blockpaths{i} );
                EDFstruct.allChanData=allChanData;
                EDFstruct.samplingRates=samplingRates;
                EDFstruct.annotations=annotations;
                EDFstruct.headerInfo=headerInfo;
                eegStartTime=datestr(datenum(EDFstruct.headerInfo.startDateVec)+EDFstruct.headerInfo.factionsecondstart/(60*60*24));
                save([mainPath filesep 'EDFstruct_' subj '_' num2str( datevec(eegStartTime))],'EDFstruct','-v7.3');
        end
    end
end

                    