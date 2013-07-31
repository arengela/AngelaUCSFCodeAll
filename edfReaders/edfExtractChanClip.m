function [channelData, samplingRate] = edfExtractChanClip(fullfilepath, channelNo,clipBounds)
% edfExtractChanClip.m extracts single channel's data from file of edf+
% or edf
%
% Example usage: [channeldata, samplingRate] =
% edfExtractChanClip('My/File/Path/filename.edf', 1, [0 10]); %would extract
%       data from 0 to 10 sec from channel 1.
% Input:   fullfilepath - 	string listing full path to edf file 
%          channelNo -      integer listing of channel.
%          clipBounds -     2-vector (i.e. [1 2]), indicating time in
%                   seconds which want to be clipped.  Note, if clipBounds
%                   don't line up with sampling rate to an integer, this
%                   will be rounded to closest sample.
%
% Output:  channelData is array in microVolts (or whatever hinfo.chan says)
%           samplingRate is sampling rate in Hz of the channel




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Notes and warnings:
% Warning: result may contain extra zeros at end (padded with zeros).
% Note: if EDF is noncontinuous, this may not be accurate.  Have not used
% this function with noncontinuous EDF files
% Note: last record may contain extra 0's.
% NOTE:  BE CAREFUL if using this on a non-Nicolet-generated EDF file,
% may need to
% change certain fields
% Script extracts edf+ annotations and data
% Things may need to be updated to be generalized:  change patient info
% interpretation, change channel offsets calculation 
% (physical unit halfway point, in this data it's all zeros) and use, this
% file is designed to be general, but has not been tested on a variety of
% EDF files, and I have already noticed that some EDF files do not follow
% all the same criteria, possibly due to the software that generates them.


%% User Settings
eegfile=fullfilepath;
chanToSave = channelNo;  

%% Other checks:
if exist(eegfile,'file') == 0
   error('File not found')
end


%% Go through header and extract important information:
hinfo = edfExtractHeader(eegfile);
        ns = hinfo.nchan;
        nrecords = hinfo.nrecords;
        duration = hinfo.duration;
maxSec = hinfo.nrecords*hinfo.duration;
if clipBounds(2)>maxSec
    error('Clip bounds exceed actual length of clip.')
end
%% Open File and get file info
   [fid,message]=fopen(eegfile, 'r');  %Read only with 'r' choice
   if fid<0
       FIDS = fopen('all')
       disp(message)
       error('FID invalid, try again')
   end
 %Skip through header and channel information:
    headerlength = 256;  %always true for edf files
    H=fread(fid, headerlength, 'uint8'); %skip through header
    chaninfolength = ns*256;
    H=fread(fid, chaninfolength, 'uint8'); %skip through channel information

    %Check for discontinuous EDF+ (not dealt with so far)
    isEdfPlus = hinfo.isEdfPlus; %~isempty(strfind(hinfo.firstreservedspace,'EDF+'));
        if isEdfPlus&&isempty(strfind(hinfo.firstreservedspace,'EDF+C'))
            disp(['EDF may not be continuous, see EDF website for details.' ... 
            'If first reserved header is EDF+D, then file is discontinuous'])
            %http://www.edfplus.info/specs/edfplus.html#timekeeping
        end 
        
   %% Calculate relevant physical units per unit integer for data:
        %Offset of physical units (often 0)
        physicaloffset = hinfo.chan.physicaloffsets(chanToSave);
            %mV (or other physical unit) per unit of integer in data.
        scaleperBit = hinfo.chan.scaleperBit(chanToSave);
        
   %% Look at Data Records 
   if isEdfPlus 
   %IF it's an EDF+ file (may have annotations)
       annotChan = find(cellfun('isempty',regexpi(cellstr(hinfo.chan.labels), 'Annotations'))==0);   
     %Check edge cases:
       if chanToSave==(annotChan)
           error(['Can''t Save Annotation Channel as data channel,'...
               'instead use edf_extract_annotations on annotation channel']);
       elseif chanToSave>ns
           error(['Channel does not exist. Only ' num2str(ns) 'channels in this data set'])
       end
   
       nBytesPerSample=2; % Each sample is a 2-byte number, so multiple number samples by 2
       nSamplesPerRecord =hinfo.chan.Nsamplesperrecord(chanToSave);
   
     %Define the # of lines between each consecutive record for this channel
       otherDataChans = 1:ns;  
       otherDataChans([chanToSave,annotChan])=[];%All channel indicese that aren't chanToSave or annotChan
       nlinesbetween = 512+ nBytesPerSample*sum(hinfo.chan.Nsamplesperrecord(otherDataChans));%OR: 512+(nSamplesPerRecord*2)*(ns-2); 
   %END EDF+ section
   
   else  
   %IF it's NOT an EDF+, but rather a regular EDF
     %Check edge cases:
       if chanToSave>ns
           error(['Channel does not exist. Only ' num2str(ns) 'channels in this data set'])
       end  
       nBytesPerSample=2; % Each sample is a 2-byte number, so multiple number samples by 2
       nSamplesPerRecord =hinfo.chan.Nsamplesperrecord(chanToSave);
       
     %Define the # of lines between each consecutive record for this channel
       otherDataChans = 1:ns;  
       otherDataChans([chanToSave])=[];%All channel indicese that aren't chanToSave or annotChan
       nlinesbetween = nBytesPerSample*sum(hinfo.chan.Nsamplesperrecord(otherDataChans));
   %END regular EDF section
   end
   
   %First move file reader head to first data record of correct channel: (past others).
        linesToChanOfInterest = nBytesPerSample*sum(hinfo.chan.Nsamplesperrecord(1:(chanToSave-1)));
        fseek(fid,linesToChanOfInterest,0);
   
   %Find number of lines to clip of interest:*
       clipStartRecord=floor(clipBounds(1)/duration);  %duration is Nsec
       clipStartIndex =round((clipBounds(1)/duration-clipStartRecord)*nSamplesPerRecord); %TODO: check indexing for non 1-sec durations
       clipStopRecord = floor(clipBounds(2)/duration); 
       clipStopIndex = round((clipBounds(2)/duration-clipStopRecord)*nSamplesPerRecord);

   %Loop through all clip records
        nFullRecordsWithinClip = clipStopRecord-clipStartRecord-1; %hinfo.nrecords;          %number of records, each duration seconds
        isClipContainedWithinSinglePartialRecord = (nFullRecordsWithinClip<0);  
   % If clip is contained in 1 record, need separate case
    
    %% Reading Clip Data In:
       nTotalSamplesInClip = (nFullRecordsWithinClip+1)*nSamplesPerRecord+clipStopIndex-clipStartIndex;
       clipRawData = zeros(nTotalSamplesInClip,1); %allocate memory for clip to store 16bit integers

   %Get first partial record in clip:
       fseek(fid,(nlinesbetween+nSamplesPerRecord*nBytesPerSample)*clipStartRecord,0);  %go to start record by skipping all records (including this one's)
       fseek(fid, clipStartIndex*2,0) ;                %go to start index in start record
       
       if isClipContainedWithinSinglePartialRecord  %If clip is wholly in one record
           nInFirstPartialRecord=clipStopIndex-clipStartIndex; 
           clipRawData(1:nInFirstPartialRecord)=fread(fid, nInFirstPartialRecord, 'int16'); %Data integers
       else     % If clip extends beyond one record
            nInFirstPartialRecord=nSamplesPerRecord-clipStartIndex;  %number of points in first partial record
            clipRawData(1:nInFirstPartialRecord)=fread(fid, nInFirstPartialRecord, 'int16'); %Data integers       
            fseek(fid, nlinesbetween, 0);  %Skip over other data   
  
          %Read all full records in clip
          try
           for p = 1:nFullRecordsWithinClip
                    iClipDataLoop=1+(p-1)*nSamplesPerRecord+nInFirstPartialRecord:(p)*nSamplesPerRecord+nInFirstPartialRecord;
                    clipRawData(iClipDataLoop)=fread(fid, nSamplesPerRecord, 'int16'); %Data integers
                    fseek(fid, nlinesbetween, 0);  %Skip over other data                    
           end
          catch
              disp('error')
          end
    % Read final partial record
            if isempty(p)
                p=0;
            end
            p=p+1;  %increment p to start at correct spot
            clipRawData(1+(p-1)*nSamplesPerRecord+nInFirstPartialRecord:(p-1)*nSamplesPerRecord+nInFirstPartialRecord+clipStopIndex)=fread(fid, clipStopIndex, 'int16'); %Data integers
        end   

        channelData = clipRawData*scaleperBit+physicaloffset;
   
   fclose(fid);
   
   %Additional optional output:
   samplingRate = hinfo.chan.samplingRate(channelNo);
   end    
