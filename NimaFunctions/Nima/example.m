% discrim analysis for eCog
bef = 0.4; aft = 0.5;
dpath = datapath(pwd);
expt = {'GP33_B1','GP33_B5','GP33_B30'};
% expt = {'EC2_B1','EC2_B8','EC2_B9','EC2_B15','EC2_B76',...
%     'EC2_B89','EC2_B105'};
subject = expt{1};tmp = strfind(subject,'_');subject = subject(1:tmp(1)-1);
cond = 'ProcessedFiles';
imname = [dpath  'GP33/braincompact.png'];
cond = 'ProcessedHTK';
% load elects;
% elects = elects(1:39);
evntfname = [dpath expt{1} '_evnt.mat'];
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