function evnt = ECogLoadEvents(dpath,expt,cond,param,elects)
%
% discrim analysis for eCog
if ~exist('param','var') || isempty(param)
    bef = 0.3; aft = 0.3; EvPerEv = 3;% in miliseconds
else
    bef = param(1);aft = param(2); EvPerEv = param(3);
end
if ~exist('elects','var') || isempty(elects)
    elects = 1:256;
end
%%
newfs = 100;
evnt=[];ind = 0;
for cnt10 = 1:length(expt)
    dfolder = [dpath expt{cnt10} '_data' filesep cond];
    labfile  = [dpath expt{cnt10} '_data/transcript.lab'];
    tmpevnt = ECogGetEvents(labfile);
    cnt1 = 1;
    while cnt1<length(tmpevnt)        % check accuracy:
        st1 = tmpevnt(cnt1).Note;
        st2 = tmpevnt(cnt1+1).Note;
        st3 = tmpevnt(cnt1+2).Note;
        if (cnt1+3)<length(tmpevnt)
            st4 = tmpevnt(cnt1+3).Note;
        else
            st4 = [];
        end
        if ~strncmpi(st4,st3,2), % assume its a 3 event thing:
            thisEv = 3;
        else
            thisEv = 4;
        end
        if ~strncmpi(st1,st2,2) || ~strncmpi(st1,st3,2)
            warning([expt{cnt10} ' ' num2str(cnt1) ' ' tmpevnt(cnt1).Note ' ' tmpevnt(cnt1+1).Note ...
                ' ' tmpevnt(cnt1+2).Note ' ' tmpevnt(cnt1+3).Note]);
            if strncmpi(st1,st2,2) && ~strncmpi(st2,st3,2)
                cnt1 = cnt1-1-(thisEv-3);
            elseif ~strncmpi(st1,st2,2) && strncmpi(st2,st3,2)
                cnt1 = cnt1-2-(thisEv-3);
            end
        else
            Start = 1000*(tmpevnt(cnt1).StopTime-bef);
            Stop  = 1000*(tmpevnt(cnt1+thisEv-1).StopTime+aft);
            disp(['event ' num2str(cnt1) ' out of ' num2str(length(tmpevnt))]);
            [temp,fs,flag] = ECogReadData(dfolder,[Start Stop],elects);
            if flag
                if elects(1)>0
                    wszb = ceil(fs*.05);
                    wsza = ceil(newfs*.05);
                    exptemp = [zeros(size(temp,1),wszb) temp zeros(size(temp,1),wszb)];
                    temp2 = resample(exptemp',newfs*100,ceil(100*fs))';
                    temp2 = temp2(:,wsza+1:end-wsza);
                    %                 temp2 = mapstd(temp2);
                    %                 temp2(:,(bef+aft)*newfs+1:end)=[];
                else
                    loadload;close;
                    temp2 = (wav2aud(temp,[10 10 -2 log2(fs/16000)]).^.125)';
                end
                ind = ind+1;
                Ref = -bef + tmpevnt(cnt1).StopTime;
                evnt(ind).bef = bef;
                evnt(ind).aft = aft;
                for cnt2 = 1:thisEv
                    evid = str2num(tmpevnt(cnt1+cnt2-1).Note(end));
                    if ~isempty(evid)
                        evnt(ind).(['Note' num2str(evid)])      = tmpevnt(cnt1+cnt2-1).Note;
                        evnt(ind).(['StartTime' num2str(evid)]) = tmpevnt(cnt1+cnt2-1).StartTime-Ref;
                        evnt(ind).(['StopTime' num2str(evid)])  = tmpevnt(cnt1+cnt2-1).StopTime-Ref;
                    end
                end
                evnt(ind).Trial     = tmpevnt(cnt1).Trial;
                evnt(ind).exptnum   = cnt10;
                evnt(ind).expt      = expt{cnt10};
                evnt(ind).cond      = cond;
                evnt(ind).data      = temp2;
                evnt(ind).fs        = newfs;
            end
        end
        cnt1 = cnt1+thisEv;
    end
    if elects(1)>0 % not needed for analog in (sound)
        [mnst] = ECogReadData(dfolder,-2,elects,labfile);
        tmpind = find(cat(2,evnt.exptnum)==cnt10);
        for cnt1 = tmpind
            evnt(cnt1).exptmean = mnst(:,1);
            evnt(cnt1).exptstd  = mnst(:,2);
        end
    end
end

