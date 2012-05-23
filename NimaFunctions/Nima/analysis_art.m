%% discrim analysis for eCog
% 1
bef = 0.4; aft = 0.5;
dpath = datapath(pwd);
expt = {'GP33_B1','GP33_B5','GP33_B30'};
expt = {'EC2_B1','EC2_B8','EC2_B9','EC2_B15','EC2_B76',...
    'EC2_B89','EC2_B105'};
subject = expt{1};tmp = strfind(subject,'_');subject = subject(1:tmp(1)-1);
cond = 'ProcessedFiles';
imname = [dpath  'GP33/braincompact.png'];
cond = 'ProcessedHTK';
cond = 'HilbAA_70to150_6band';
% load elects;
% elects = elects(1:39);
evntfname = [dpath expt{1} '_' cond '_evnt.mat'];
slist = {'baa','bee','boo','daa','dee','doo','faa','fee','foo','gaa','gee','goo',...
    'haa','hee','hoo','kaa','kee','koo','laa','lee','loo','maa','mee','moo','naa','nee','noo',...
    'paa','pee','poo','raa','ree','roo','saa','see','soo','shaa','shee','shoo','taa','tee','too',...
    'thaa','thee','thoo','vaa','vee','voo','waa','wee','woo','yaa','yee','yoo','zaa','zee','zoo'};
if ~exist(evntfname,'file'),
    % load elects;
    % elects = -1;
    elects = [];
    evnt = ECogLoadEvents(dpath,expt,cond,[bef aft 4],elects);
    save (evntfname,'evnt');
else
    load (evntfname);
end
%% cleaning up the transcriptions:
% 2
badind = [];
ii1 = [1 3 2 4];
ii2 = [3 4 2 1];
for cnt1 = 1:length(evnt)
    badflag=0;
    st = []; tmp = [];
    for cnt2 = 1:4
        st{cnt2} = evnt(cnt1).(['Note' num2str(cnt2)]);
        if ~isempty(st{cnt2})
            st{cnt2} = strrep(st{cnt2},'u','o');
            st{cnt2} = strrep(st{cnt2},'gh','g');
            st{cnt2} = strrep(st{cnt2},'aw','aa');
            st{cnt2} = strrep(st{cnt2},'oe','oo');
            st{cnt2} = strrep(st{cnt2},'who','hoo');
%             if isempty(strfind(st{cnt2},num2str(ii(cnt2)))), badflag=1;end
            if length(st{cnt2})>5, badflag=1;end
        end
    end
%     if ~strcmpi(st{1}(1:end-1),st{2}(1:end-1)) || ~strcmpi(st{2}(1:end-1),st{3}(1:end-1))
%         badflag = 1;
%     end
    % StopTime 1<3<4<2
    tmp = cat(1,evnt(cnt1).StopTime1,evnt(cnt1).StopTime3,evnt(cnt1).StopTime4,...
        evnt(cnt1).StopTime2);
    if ~isempty(find(diff(tmp)<0)),
        disp(cnt1);
        badflag = 1;
    end
    % it has to be in the list:
    if isempty(find(strcmpi(slist,st{3}(1:end-1)))), badflag = 1;end
    if badflag
        badind = [badind cnt1];
    else
        for cnt2 = 1:4
            evnt(cnt1).(['Note' num2str(cnt2)]) = st{cnt2};
        end
    end
end
evnt(badind) = [];
evnt2 = evnt;
%% normalize each data point:
% 3
for cnt1 = 1:length(evnt)
%     evnt3(cnt1).data = mapstd(evnt(cnt1).data);
    evnt2(cnt1).data = (evnt(cnt1).data - repmat(evnt(cnt1).exptmean,[1 size(evnt(cnt1).data,2)])) ./ ...
        repmat(evnt(cnt1).exptstd,[1 size(evnt(cnt1).data,2)]);
end
%% get all the events:
% 4
elects = 1:256;
% load elects;
bef = 0.39;aft = 0.5;
notes=cell(length(evnt2),1);
[notes{:}]=deal(evnt2.Note3);
unotes = unique(notes);
% sort them based on sname:
sind = [];
for cnt1 = 1:length(unotes)
    sind(cnt1) = find(strcmpi(unotes{cnt1}(1:end-1),slist));
end
[a,b] = sort(sind);
unotes = unotes(b);
X = []; labs = [];Y=[]; labnote = []; labind = 0; exptnums = []; oind = [];
allmeans=[]; ufreq=[]; StopTimes = []; StartTimes = [];
for cnt1 =1:length(unotes)
    disp(cnt1);
    ind = find(strcmp(notes,unotes(cnt1)));
    temp2 = length(ind);
    temp = [];
    for cnt2 = 1:temp2
        temp3 = evnt2(ind(cnt2)).data(elects,:);
        temp = cat(3,temp,temp3(:,ceil((-bef+evnt2(ind(cnt2)).StopTime3)*100): ...
            ceil((aft+evnt2(ind(cnt2)).StopTime3)*100)));
    end
%     temp = temp(elects,:,:);
    temp3 = cat(1,evnt2(ind).exptnum);
    % just the motor:
%     temp = temp(1:39,:,:);
    allmeans(:,:,cnt1) = mean(temp, 3);
    if size(temp,3)>4
        labind = labind+1;
        X(end+1:end+size(temp,3),:) = reshape(temp,[size(temp,1)*size(temp,2) size(temp,3)])';
        Y(:,:,end+1:end+size(temp,3)) = temp;
        labs(end+1:end+size(temp,3)) = labind;
        for cnt3 = 1:4
            tmp = cat(2,evnt2(ind).(['StopTime' num2str(cnt3)]));
            StopTimes(labind).(['mStopTime' num2str(cnt3)]) = mean(tmp);
            StopTimes(labind).(['sStopTime' num2str(cnt3)]) = std(tmp);
            tmp = cat(2,evnt2(ind).(['StartTime' num2str(cnt3)]));
            StartTimes(labind).(['mStartTime' num2str(cnt3)]) = mean(tmp);
            StartTimes(labind).(['sStartTime' num2str(cnt3)]) = std(tmp);
        end
        labnote{end+1} = unotes{cnt1};
        exptnums(end+1:end+size(temp,3)) = temp3;
        ufreq(end+1) = temp2;
        oind(end+1:end+length(ind)) = ind;
    else
        nn=0;
    end
end
Y(:,:,1)=[];
save ([subject 'allphn.mat'],'Y','labnote','labs','StopTimes','StartTimes')

