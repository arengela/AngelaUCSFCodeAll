function [ header ] = edfExtractHeader( varargin )
%edf_extract_header returns  information from an edf header and other info
%
%   Input:  filepathname  is full path string to the edf file
%   Output: header is a structure that contains information from the edf 
%   header.
%
%   See also:  edfExtractChanClip, edfExtractAnnotations,
%   edfExtractChanFull


if nargin<1
    %For Debug purposes, so that you can run this as a script.
    filepathname = '/Users/Vera/Desktop/WorkingFiles/S2/edfDataSz/s2_11_04_27_11_59_44ecog1.edf';
    fprintf('\n Warning: using default file in header extraction, only for Debug purposes\n');
else
    filepathname = varargin{1};
end

%% Make sure file exists
    if exist(filepathname,'file') == 0
       error('File not found')
    end

%% Open File and get file info
   [fid,message]=fopen(filepathname, 'r');  %Read only with 'r' choice
   if fid<0
       FIDS = fopen('all')
       disp(message)
       error('FID invalid, try again')
   end
       

%% Go through header and extract important information:
    headerlength = 256;  %always true for .edf files
    H=fread(fid, headerlength, 'uint8');
    header=char(H');
    %Determine if file is EDF or EDF+:
        hinfo.firstreservedspace = header(193:193+43);
        isEdfPlus = ~isempty(strfind(hinfo.firstreservedspace,'EDF+'));
        if isEdfPlus&&isempty(strfind(hinfo.firstreservedspace,'EDF+C'))
            disp(['EDF may not be continuous, see EDF website for details.' ... 
            'If first reserved header is EDF+D, then file is discontinuous'])
            %http://www.edfplus.info/specs/edfplus.html#timekeeping
        end
        
    %Get subject Info: 
        dataformatversion = header(1);
        patientInfoLine = header(9:9+79);
        patbirthindx = regexpi(patientInfoLine, '\d\d-...-....');
        if ~isempty(patbirthindx)
            hinfo.subject_birthyear = patientInfoLine(patbirthindx(1)+7:patbirthindx(1)+10);
        else
            hinfo.subject_birthyear = 0;
        end

        subject_IDstring  = patientInfoLine(1:8);
        localrecord = header(89:89+79); % local recording identification, mostly blank
        hinfo.startdate = header(169:169+7); %startdate of recording
        hinfo.starttime= header(177:177+7); %start time hh.mm.ss
        try
            hinfo.startDateVec = datevec([hinfo.startdate ' ' hinfo.starttime], 'dd.mm.yy HH.MM.SS');
        catch
            hinfo.startDateVec = datevec('00.00.00 00.00.00', 'dd.mm.yy HH.MM.SS');
            %This indicates file is corrupt or start date of recording is
            %not in file for some reason
        end
        header(185:185+7); %number of bytes in header record
        hinfo.edfFormat = header(193:193+43); % firstreservedspace reserved for edf+ (44 char)
        hinfo.nrecords = str2num(header(237:237+7));  %number of data records
        hinfo.duration = str2num(header(245:245+7));  %duration of each record in seconds
        hinfo.nchan = str2num(header(253:253+3));  % number of signals (ns) in data record
        ns = hinfo.nchan;
       
       isEdfPlus = ~isempty(strfind(hinfo.firstreservedspace,'EDF+')); 
       hinfo.isEdfPlus = isEdfPlus;
   %% Look at channel information:  
    %Store relevant channel information in chaninfo structure.
     %Channel labels: (16 ascii/chan). Note last chan will be annotations
     %if file is EDF+
       H=fread(fid, ns*16, 'uint8');
       chanlabels=char(H');
       hinfo.chan.labels = vec2mat(chanlabels, 16,ns);
     %Transducer types: (80 ascii/chan)
       H=fread(fid, ns*80, 'uint8');
       %hinfo.chan.chantransducertypes=char(H');  %all unknowns, not useful
     %Physical dimensions (muV) (8 ascii/chan)
       H=fread(fid, ns*8, 'uint8');
       physicaldims=char(H');
       hinfo.chan.physicalUnits = vec2mat(physicaldims, 8,ns);
     %physical minimums (8 ascii/chan)
       H=fread(fid, ns*8, 'uint8');
       physicalmins=char(H');
       hinfo.chan.physicalmins = str2num(vec2mat(physicalmins,8, ns));
     %physical maximums (8 ascii/chan)
       H=fread(fid, ns*8, 'uint8');
       physicalmaxes=char(H');
       hinfo.chan.physicalmaxes = str2num(vec2mat(physicalmaxes,8, ns));
     %digitial minimums (8 ascii/chan)
       H=fread(fid, ns*8, 'uint8');
       digitalmins=char(H');
       hinfo.chan.digitalmins= str2num(vec2mat(digitalmins,8, ns));
     %digital maximums (8 ascii/chan)
       H=fread(fid, ns*8, 'uint8');
       digitalmaxes=char(H');
       hinfo.chan.digitalmaxes = str2num(vec2mat(digitalmaxes,8, ns)); 
     %prefiltering (80 ascii/chan)
       H=fread(fid, ns*80, 'uint8');
       prefilters=char(H') ; %TODO:  ARE THESE REALLY Always filtered?
       hinfo.chan.prefilters = vec2mat(prefilters, 80, ns);
     %number of samples in data records (8 ascii/chan), per 1 sec.  this is
                %hz essentially
       H=fread(fid, ns*8, 'uint8');
       nsampperdatarecord=char(H');
       hinfo.chan.Nsamplesperrecord = str2num(vec2mat(nsampperdatarecord, 8, ns));
     %reserved space for each (32ascii/chan)
       H=fread(fid, ns*32, 'uint8');
       reservedspace=char(H');

%% Go into first annotation to grab the actual start time (finer grain than
% sec)  First number in each annotation line is the actual precise time
% see: http://www.edfplus.info/specs/edfplus.html#timekeeping
        for m=1:ns   %this is number of signals (number of channels recorded)         
            nr=hinfo.chan.Nsamplesperrecord(m); %samples per duration for this channel
            if isempty(strfind(hinfo.chan.labels(m,:), 'Annotation')) %Annotation line?
                %H=fread(fid, nr*1, 'int16');    %Data integers
                fseek(fid,  nr*2,0); %instead of reading, just skip sections 
            else    
                H = fread(fid, 512, 'uint8');   
                char20s=find(H==20);
                hinfo.factionsecondstart =str2double(char(H(2:char20s(1)-1)') ); %first digit is always a +
            end
        end
%% Do very basic calculations that will be helpful:
 hinfo.chan.physicaloffsets = (hinfo.chan.physicalmaxes+hinfo.chan.physicalmins)/2;
 hinfo.chan.scaleperBit = (hinfo.chan.physicalmaxes-hinfo.chan.physicalmins)./(hinfo.chan.digitalmaxes-hinfo.chan.digitalmins)  ;
 hinfo.chan.samplingRate = hinfo.chan.Nsamplesperrecord./hinfo.duration; 
 areAllSameSamplngRate =isempty(find(hinfo.chan.samplingRate~=hinfo.chan.samplingRate(1)));
 if areAllSameSamplngRate
     hinfo.samplingRate = hinfo.chan.samplingRate(1);
 else
     hinfo.samplingRate =[];
 end
%% Include file this is coming from and header information:
    hinfo.originatingFile = filepathname;
    %hinfo.dateExtractedFromRawFile = datestr(date, 29);
%%       
   header = hinfo;
   fclose(fid);
end

