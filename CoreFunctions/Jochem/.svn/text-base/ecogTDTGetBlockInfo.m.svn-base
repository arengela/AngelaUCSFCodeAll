function params=ecogTDTGetBlockInfo(rawDataPath,blockName)
% params=ecogTDTGetBlockInfo(rawDataPath,blockName) Returns information about a data block
%
% PURPOSE:  Find the available data  four letter tags in a block of data
%           written by the TDT system.
%           Thats the tag names you need for reading/converting data
%
% INPUT:
% rawDataPath:      Where the raw data live
%                   e.g. D:\Data\Ecog\bp21FingerMov090127\GP21_B12
% blockName:        The data block of interest e.g. GP21_B12. Typically
%                   this is the last part of the pathname and is included in
%                   the name of the raw files. An error is thrown and the
%                   availabe blocks are listed if the requested block does
%                   not exist in the tank.
%
% OUTPUT:
% params:           A structure containing the information in the fields:
%                   totalTime: the total data length in seconds
%                   tagNames: All four letter tags available in this block
%                   sampFreq: The sampling frequency associate with
%                   channels with a certain tag
%                   nChannels: The number of channels associated with that
%                   tag
%                   notes: contains the notes string which includes
%                   basically all you need to know about the block
%
% REQUIREMENTS:     This function requires Microsoft Windows and the
%                   TDT drivers installed (and possibly OpenEx)
%                   Get the software from www.tdt.com. OpenEX is password
%                   protected
% EXAMPLE:
% params=ecogTDTGetBlockInfo('D:\Data\Berkeley\Ecog\bp22090323\resultsFile\GP22_B28','GP22_B28')

% 090324 JR wrote it. Bugs:actxcontrol() opens a window. Can we prevent
%                           that?
% 090401 JR now parses the notes to get the number of channels
%        see openEx developer help for documentation
% 090421 JR Tank name is now found in the directory. No more assumptions
%          about prefixes are made
%          If a block name is not available, all available names are listed before throwing an error
% 091222 JR Made estimation of number of channels more fail proof

% Are we compatible ?
switch computer
    case 'PCWIN'
    case 'PCWIN64'
    otherwise
        error('Requires Microsoft Windows. Uses ActiveX controls.')
end
%Connect to server
TT = actxcontrol('TTank.X');
%for whatever reason actxcontrol seems to open a figure window
e=invoke(TT,'ConnectServer','Local','Me');
if (e==0)
    error('Cannot connect to server');
end

try
    pause(1)
    %connectto tank
    %    e=invoke(TT,'OpenTank',[rawDataPath '\Ecog2_' blockName],'R');%PLACE PATH OF TANK TO COLLECT DATA FROM
    % the sumption here is that there is only one tank in a directory and
    % that the extension is tev
    tmp=ls([rawDataPath filesep '*.tev']);
    [p,tankName,e]=fileparts(tmp);
    e=invoke(TT,'OpenTank',[rawDataPath filesep tankName],'R');%PLACE PATH OF TANK TO COLLECT DATA FROM
    if (e==0)
        error(['Cannot open data tank: ' rawDataPath filesep blockName]);
    end
    pause(1)
    %select block
    e=invoke(TT,'SelectBlock',blockName);%PLACE NAME OF BLOCK
    if (e==0)
        display('Available block names are:')
        count=1;
        while (~isempty(TT.QueryBlockName(count)))
            display(TT.QueryBlockName(count));
            count=count+1;
        end
        error(['Cannot find block name: ' blockName]);
    end
    % Thats contains everything but is ugly
    params.notes=TT.CurBlockNotes;
    %Thats the same for all tags
    params.totalTime = TT.CurBlockStopTime- TT.CurBlockStartTime; %Gets total tank duration.

    %Get the tag codes
    eventCodes=TT.GetEventCodes(0);
    %translate them
    tagNames=[];
    sampFreq=[];
    nChannels=[];
    idxHDRStart=findstr(params.notes,'['); 
    idxHDRStart=[idxHDRStart length(params.notes)];

    for k=1:length(eventCodes)
        tagNames=strvcat(tagNames, TT.CodeToString(eventCodes(k)));
        % try to get the number of channels associated with that field
        idx1=strfind(params.notes,['VALUE=' tagNames(k,:)]);
        % We may have found multiple occurences and scan them now
        m=1;
        while m<=length(idx1)
            tmpIdx=max(find(idxHDRStart<idx1(m))); % where the current header block starts
            %Get the header block
            tmpString=params.notes(idxHDRStart(tmpIdx):idxHDRStart(tmpIdx+1));
            % Now the line containing the number of channels in this block
            idxLineStart=strfind(tmpString,'NAME=NumChan;TYPE=');
            lineLength=min(find(double(tmpString(idxLineStart(1):end))==13));
            tmpString=tmpString(idxLineStart(1):idxLineStart(1)+lineLength);
            % the number of channels. The line ends with a semikolon which
            % we skip
            tmp=str2num(tmpString(findstr(tmpString,'VALUE=')+length('VALUE='):end-1));
            if ~isempty(tmp)
                nChannels=[nChannels;tmp];
                m=length(idx1)+1; % and we stop when we found something
            elseif isempty(tmp) && m==length(idx1) % no channel number spcified for this tag
                nChannels=[nChannels;0];
                m=m+1; % We stop here
            else
                m=m+1; % try the next block
            end

        end
        %load the infor associated with the data tag
        res=TT.GetCodeSpecs(TT.StringToEvCode(tagNames(k,:)));
        %Get the frequency
        sampFreq=[sampFreq;TT.EvSampFreq(1)];

        %TT.EvDataSize(1)
    end
    params.tagNames=tagNames;
    params.sampFreq=sampFreq;
    params.nChannels=nChannels;
    invoke(TT,'CloseTank')%closes the server.

catch %Make sure the server is closed if anything chrashes
    rethrow(lasterror);
    invoke(TT,'CloseTank')%closes the server.
end