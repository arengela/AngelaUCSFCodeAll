function [annotations] = edfExtractAnnotations(fullfileinputpath)
% [annotations] = edfExtractAnnotations(fullfileinputpath)
% Extracts only annotations from an edf file and returns them 
% 
% Inputs
%       fullfileinputpath  - path to the edf file to get annotations from
%       fullfilesavepath   - full path string of where to save results
% Outputs
%       annotations - structure with following fields containing notes
%           onsetTimes:  time of each annotation onset (seconds)
%           durationTimes: duration of each annotation (seconds)
%           annotations: text of each annotation.  Note that many are
%               blank of unclear purpose or origin. (seconds)
%           recordStartTimes: start time of each record in seconds (this is
%               related to the number of records in the file, not the 
%               number of annotations. Only the first is really necessary
%               as the rest are separated by constant amount of seconds
%               indicating the duration of a 'record' in the file type.
            
% NOTE: this may take a while to run on large multi-GB files.
%
% NOTE:  BE CAREFUL if using this on a non-UCSF EDF file, may need to
% change certain fields, or pay attention to things ignored.   See below
% for examples.
%
% 
% This may need to be updated to be generalized when using 
% non-Nicolet-exported edf+ files. May need to change patient info
% interpretation, change channel offsets calculation 
% (physical unit halfway point, in this data it's all zeros) and use, 
% pay attention to type of channel (unknowns when exported from nicolet), 
% Go to http://www.edfplus.info/specs/edfplus.html and
% http://www.edfplus.info/specs/edf.html for more information  on data
% setup and specs, and double check results.  EEGLAB or other edf importers
% may be used to check validity of import of data, annotations import
% correctness should be clear from whether meaningful annotations are
% present or not, although double-checking against other existing programs
% for timing information is not a bad idea.





%% Open File and get file info
    hinfo=edfExtractHeader(fullfileinputpath);
        ns = hinfo.nchan;
        nrecords = hinfo.nrecords;
        duration = hinfo.duration;
   [fid, message]=fopen(fullfileinputpath, 'r');  %Read only with 'r' choice
   if fid<0
       FIDS = fopen('all')
       disp(message)
       error('FID invalid, try again')
   end


    
%% Go through header lines before file information starts
    headerlength = 256;  %always true for edf files
    H=fread(fid, headerlength, 'uint8');
    chaninfolength = ns*256;
    H=fread(fid, chaninfolength, 'uint8'); %skip through channel information
      
    
    chaninfo = hinfo.chan;
 
   %% Look at Data Records
   %For Nicolet-exported EDF+ files, annotations channel is labeled
   %'Annotations'
   annotChan = find(cellfun('isempty',regexpi(cellstr(chaninfo.labels), 'Annotations'))==0);

   if (annotChan~=ns)
        %For nicolet-exported EDF+  files, annotation is last channel, if
        %not, this should catch that difference, and produce an error. Code
        %will need to be updated in minor way to skip to correct channel if
        %this is the case.
       error(['This code assumes annotation channel is the last channel'...
           'Need to edit this and make complex way to get to first annotation '...
           'line, see for instance edf_extract_data']);
   end
   
   nlinesBtwnAnnotations = 2*sum(chaninfo.Nsamplesperrecord(1:(annotChan-1)));
   
  
   ainfo.recordStartTimes= -ones(hinfo.nrecords,1);  %Note: Can probably toss
                        %these out if EDF is continuous 
                        %(except for first saved in header). (EDF+C), which
                        % is saved in edfExtractHeader.m
   allocatesize=  floor(hinfo.nrecords/200);
   ainfo.onsetTimes =-ones( allocatesize,1);
   ainfo.durationTimes=zeros( allocatesize,1);
   ainfo.annotations = cell(allocatesize,1);
   acount = 1;
   nrecordsToExplore = hinfo.nrecords;          %number of records, each duration seconds
   for p = 1:nrecordsToExplore 
       %preallocate space
       maxNTAL=50;
       durationTimes=  -ones(maxNTAL, 1);
       onsetOffsetTimes=-ones(maxNTAL, 1);
       TALannotations=cell(maxNTAL, 1);
       
       if mod(p, 1000)==0
           %toc
           disp([num2str(p) 'of' num2str(nrecordsToExplore)])  
       end       
       %Data channels:
            fseek(fid,nlinesBtwnAnnotations,0); %skip all data lines:
       %Annotation channel data:
            H = fread(fid, 512, 'uint8')';   %Annotation data 
        
        %First annotation followed by 20 is time stamp of record past 
        %original file start time        
        char20s=find(H==20);
        recordStartTime =str2double(char(H(1:char20s(1)-1)));
        
        if length(char20s)==2  %There are no real annotations (just star time) if only 2 char(20)s
           ainfo.recordStartTimes(p) = recordStartTime; 
           nTAL=0;
        else         
            char0s = [find(H==0)];
            btwn0sL = [1, char0s(1:end-1)+1]; %index of things between 0s on left
            btwn0sR = [char0s-1];              %index of things between 0s on right
            emptyannotes=find(btwn0sR-btwn0sL<0); %ignore spots where there were consecutive 0s
            btwn0sL(emptyannotes) = [];
            btwn0sR(emptyannotes) =[];
            nTAL = length(btwn0sL)-1; %first annotation is just time stamp. %To check: make 100% sure this is true
            for o=1:nTAL
                currTAL = (H(btwn0sL(o+1):btwn0sR(o+1)));
                curr20s = find(currTAL==20);
                curr21s =find(currTAL==21);  
                Ncurrannot= length(curr20s)-1;
                if isempty(curr21s)  %no 21 means that it's got no duration
                    durationTimes(o) = 0;  %default is 0 duration
                    onsetOffsetTimes(o) = str2num(char(currTAL(1:curr20s(1)-1)));
                else %if there is a duration, it is between 21 and 20. only one duration per TAL
                    durationTimes(o) = str2double(char(currTAL(curr21s+1:curr20s(1)-1)));
                    onsetOffsetTimes(o) = str2num(char(currTAL(1:curr21s(1)-1)));
                end
                if Ncurrannot == 1  %only one annotation 
                    TALannotations{o}= char(currTAL(curr20s(1)+1:curr20s(2)-1));
                else %multiple annotations:
                    error('Are there ever multiples? If so modify code')
                    %NOTE: could just keep multiple annotations as a set,
                    %no reason to split them necessarily since it's same
                    %onset and duration.
                end
            end

        %For only 1 annotation per TAL:
            ainfo.onsetTimes(acount:acount+nTAL-1) = onsetOffsetTimes(1:nTAL);
            ainfo.durationTimes(acount:acount+nTAL-1)= durationTimes(1:nTAL);
            ainfo.annotations(acount:acount+nTAL-1) =  TALannotations(1:nTAL);
            ainfo.recordStartTimes(p) = recordStartTime;
            acount=acount+nTAL;       
        end
  
   end
   %Note for future:  consider removing blank annotations.  For now the are
   %left as-is.  perhaps informative?
   
   %Remove extra allocated space in matrices
   extraindices=find(ainfo.onsetTimes==-1);
   ainfo.onsetTimes(extraindices)=[];
   ainfo.durationTimes(extraindices)=[];
   ainfo.annotations(extraindices)=[];
   
 
   
   %Close file:
        fclose(fid);
   %Toss out recordStartTimes if all are different by exactly 1 (cts)
    if isempty(find(diff(ainfo.recordStartTimes(:))~=1))  
        rmfield(ainfo, 'recordStartTimes');
    else
        error('EDF fxn seems discontinuous')
    end
        
   %Save final annotations to return 
    annotations = ainfo;
    %toc
end
     
