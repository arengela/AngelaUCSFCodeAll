function [evnt,badsegments] = ECogGetEvents(labfile)
%extracts times of articulatory events from a transcipt file
%removes events that coincide with bad time segments, if there are any

ind = 0;
badsegments = [];
fid = fopen(labfile,'r');
while ~feof(fid)
    tmp1 = fgetl(fid);
    tmp2 = strfind(tmp1,' ');
    ind = ind+1;
    Note = tmp1(tmp2(2)+1:end);
    if strcmpi(Note,'Stop')
        break;
    end
    evnt(ind).Note = Note;
    evnt(ind).StartTime = str2num(tmp1(1:tmp2(1)))/1E7;
    evnt(ind).StopTime  = str2num(tmp1(tmp2(1)+1:tmp2(2)-1))/1E7;
    evnt(ind).Trial = [];
end
fclose(fid);

% is there a bad file too??
badfile = strrep(labfile,'transcript','bad_time_segments');
if exist(badfile,'file')
    badind = 1;
    tol = .5; % in seconds
    blength = length(evnt);
    % then exclude the segments that are in this file:
    fid = fopen(badfile,'r');
    while ~feof(fid)
        tmp1 = fgetl(fid);
        tmp2 = strfind(tmp1,' ');
        if ~isempty(strfind(tmp1,'b'))
            b = str2num(tmp1(tmp2(1)+1:tmp2(2)-1))/1E7;
        end
        if ~isempty(strfind(tmp1,'e'))
            e = str2num(tmp1(tmp2(1)+1:tmp2(2)-1))/1E7;
            badsegments(badind,1) = b;
            badsegments(badind,2) = e;
            badind = badind + 1;
            tmpevnt = evnt(1);
            tmpind  = 1;
            for cnt2 = 1:length(evnt)
                if ~((evnt(cnt2).StopTime>(b-tol)) && (evnt(cnt2).StopTime<(e+tol)))
                    tmpevnt(tmpind) = evnt(cnt2);
                    tmpind = tmpind+1;
                end
            end
            evnt = tmpevnt;
        end
    end
    if (blength-length(evnt))>0,
        warning ([num2str(blength-length(evnt)) ' events were discarded...']);
    end
    fclose(fid);
end