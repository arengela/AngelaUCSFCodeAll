function evnt = CRMgetBehavior (dpath,subject,expt,evnt)
%
% results:
%   correct: both color and number are correct
%   ~correct: both color and number are correct, but wrong speaker
%   color:  just the color is correct
%   digit: just the digit is correct


crmfields = {'trial','name','Sp1','CS1','C1','N1','Sp2','CS2','C2','N2',...
    'TCS','TC','TN','RT'};
behpath = [dpath 'behavior/'];
offset = [];
files = dir([behpath '*.txt']);
for cnt1 = 1:length(expt)
    offset = [];
    bind = 1;
    for cnt2 = 1:length(files)
        tmp = strfind(expt{cnt1},'_');
        if length(tmp)>1
            blk = expt{cnt1}(tmp(1)+1:tmp(2)-1);
        else
            blk = expt{cnt1}(tmp(1)+1:end);
        end
        if ~isempty(strfind(files(cnt2).name,[blk '_']))
            fname = [behpath files(cnt2).name];
            break;
        end
    end
    disp(fname);
    fid = fopen(fname,'r');
    %read the label:
    flab  = fgetl(fid);
    ftime = fgetl(fid);
    while ~feof(fid)
        tmp1 = fgetl(fid);
        tmp2 = strfind(tmp1,',');
        tmp2 = [1 tmp2];
        st = [];
        if length(tmp2)>10
            tind = 1:14;
        else
            tind = [1 2 4 5 6 12 13 14 15];
        end
        if length(tmp2)==10, % dealing with an old case:
            tmp1(tmp2(6):tmp2(7)-1)=[];
            tmp2 = strfind(tmp1,',');
            tmp2 = [1 tmp2];
        end
        for cnt2 = 1:length(tmp2)-1;
            tmp3 = tmp1( tmp2(cnt2):tmp2(cnt2+1));
            tmp3 = strrep(tmp3,',','');
            tmp3 = strrep(tmp3,'.wav','');
            st.(crmfields{tind(cnt2)}) = tmp3;
        end
        if isempty(offset), offset = ifstr2num(st.trial)-1;end % assume the first trial is the offset.
        % correct incorrect:
        st.Res = 'Incorrect';
        if ~isfield(st,'TCS'), st.TCS = st.CS1;end
        
        if strcmpi(st.TCS,st.CS1) && strcmpi(st.TC,st.C1) && strcmpi(st.TN,st.N1)
            st.Res = 'Correct';
        end
                    
        if isfield(st,'CS2') && strcmpi(st.TCS,st.CS2) && strcmpi(st.TC,st.C2) && strcmpi(st.TN,st.N2)
            st.Res = 'Correct';
        end
        
        if isfield(st,'C2') && ((strcmpi(st.TCS,st.CS1) && strcmpi(st.TC,st.C2) && strcmpi(st.TN,st.N2)) || ...
           (strcmpi(st.TCS,st.CS2) && strcmpi(st.TC,st.C1) && strcmpi(st.TN,st.N1)))
            st.Res = '~Correct';
        end
        
        if isfield(st,'C2') && ((strcmpi(st.TCS,st.CS1) && strcmpi(st.TC,st.C1) && ~strcmpi(st.TN,st.N1)) || ...
           (strcmpi(st.TCS,st.CS2) && strcmpi(st.TC,st.C2) && ~strcmpi(st.TN,st.N2)))
            st.Res = 'Color';
        end
        
        if isfield(st,'C2') && ((strcmpi(st.TCS,st.CS1) && ~strcmpi(st.TC,st.C1) && strcmpi(st.TN,st.N1)) || ...
           (strcmpi(st.TCS,st.CS2) && ~strcmpi(st.TC,st.C2) && strcmpi(st.TN,st.N2)))
            st.Res = 'Number';
        end
        
        if ~isfield(st,'Sp1'), st.Sp1 = st.name(2:3);end
        if strcmpi(st.TCS,st.CS1), 
            st.TSp = st.Sp1;
        else
            st.TSp = st.Sp2;
        end
        % now check to see if it is valid:
        bevnt(bind) = st;
        bind = bind+1;
    end
    % now match them, do it stupid way:
    tmp = strfind(expt{cnt1},'_');
    subject = expt{cnt1}(1:tmp(1)-1);
    if length(tmp)>1
        block   = expt{cnt1}(tmp(1)+1:tmp(2)-1);
    else
        block = expt{cnt1}(tmp(1)+1:end);
    end
    for cnt2 = 1:length(evnt)
        if cnt2==355
            nn=0;
        end
        if strcmpi(evnt(cnt2).subject,subject) && strcmpi(evnt(cnt2).block,block)
            for cnt3 = 1:length(bevnt)
                if strcmpi(evnt(cnt2).name,bevnt(cnt3).name) && (evnt(cnt2).trial==(ifstr2num(bevnt(cnt3).trial)-offset))
                    % then they are really the same ;-)
                    evnt(cnt2).behavior = bevnt(cnt3);
                    evnt(cnt2).behavior.trial = ifstr2num(evnt(cnt2).behavior.trial)-offset;
                    break;
                end
                
            end
        end
        
    end
end
