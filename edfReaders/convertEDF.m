function convertEDF(flag,subj,blockpaths)
%INPUTS:
%flag: 1 to just rename EDf files, 2 to save as matlab structures
%OPTIONAL INPUTS:
%subj: prefices all renamed files with this string. If not entered, will assume
%edf files are in folder labeled with subject ID, and will use that as
%prefix.
%blockpaths: cell array of full paths to edf files. If this is an input,
%will bypass GUI
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
                    copyfile(blockpaths{i},[subj '_' num2str( datevec(eegStartTime)) '.edf']);
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

                    