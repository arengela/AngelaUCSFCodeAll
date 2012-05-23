function [data,fs,flag] = ECogReadData(dpath,duration,elects,labfile)
%
%   elects: sequence of electrodes
%           -1: return the analog input (sound)
%   duration: duration of the signal
%               -1: return the mean and std
%   flag: if the duration of the data is the same as what was asked for, this
%           flag is 1, otherwise is zero.
if ~exist('labfile','var')
    labfile = [];
end

if ~exist('elects','var') || isempty(elects),
    elects = 1:256;
end

if ~exist('duration','var') || isempty(duration)
    duration = [];
end

if ~strcmpi(dpath(end),filesep), dpath = [dpath filesep];end

switch elects(1)
    case -1
        if duration < 0 ,
            flag = 1;
            return;
        end
        fname = [dpath 'ANIN1.htk'];
        fname = strrep(fname,'ProcessedFiles/','');
        [data,fs,ch] = readhtk(fname,duration);
    otherwise
        files = dir([dpath 'W*.htk']);
        if duration>0
            [d,fs,ch] = readhtk([dpath files(1).name],duration);
            data = zeros(length(elects),size(d,2));
        else
            data = [];
        end
        for cnt1 = 1:length(elects)
            temp = num2str(mod(elects(cnt1),64));
            if strcmpi(temp,'0'), temp = '64';end
            fname = [dpath 'Wav' num2str(ceil(elects(cnt1)/64))  temp '.htk'];
            if duration>0
                data(cnt1,:) = readhtk(fname,duration);
            else
                % if the mean and std are needed, see if there is
                % baselineTime.mat file. if not, take the average of the
                % whole thing.
                [tempdata,fs] = readhtk(fname);
                tmp = strfind(dpath,filesep);
                baselinename = [dpath(1:tmp(end-1)) 'baselineTime.mat'];
                if exist(baselinename,'file')
                    load (baselinename);
                else
                    baselineTime = [0 ceil(length(tempdata)/fs)];
                end
                % now need to remove the bad parts before taking the mean
                % and the std:
                tol = .6;
                [evnt,badsegs] = ECogGetEvents(labfile);
                start = 0;
                if isempty(badsegs)
                    goodinds = 1:length(tempdata);
                else
                    goodinds = [];
                    for cnt2 = 1:size(badsegs,1)
                        stop = badsegs(cnt2,1)-tol;
                        goodinds = [goodinds 1+floor(start*fs):ceil(stop*fs)];
                        start = badsegs(cnt2,2)+tol;
                    end
                    goodinds = [goodinds (1+floor(start*fs)):length(tempdata)];
                end
                % find the baseline:
                tmp1 = ceil(baselineTime(1)*fs);
                goodinds = goodinds(goodinds>tmp1);
                tmp1 = ceil(baselineTime(2)*fs);
                goodinds(goodinds>tmp1) = [];
                tempdata = tempdata(goodinds);
                data(cnt1,1) = mean(tempdata);
                data(cnt1,2) = std(tempdata);
            end
        end
end
if duration>0
    flag = (ceil(diff(duration)*fs/1000)==size(data,2));
else
    flag = 1;
end