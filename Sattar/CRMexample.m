subject = 'EC2';
dpath = datapath(pwd);
ddpth = [dpath subject filesep];
[allexpt,blocks] = ECogBlockNames(dpath,subject);
electbr = {'CRMstg',2};
electbr = {'stg',1};
elects = ECogElectrodeLabel(subject,electbr{1},dpath,electbr{2});
cond = 'ProcessedHTK';
cond = 'Hilbaa_70to150_8band';
specflag = 'audnorm';
%
allnames = [];
allnames{1} = {'ST1_Ringo_Blue_2','ST1_Ringo_Blue_5','ST1_Ringo_Green_5','ST1_Ringo_Green_7',...
    'ST1_Ringo_Red_2','ST1_Ringo_Red_7','ST1_Tiger_Blue_2','ST1_Tiger_Blue_5', ...
    'ST1_Tiger_Green_5','ST1_Tiger_Green_7','ST1_Tiger_Red_2','ST1_Tiger_Red_7',...
    'ST5_Ringo_Blue_2','ST5_Ringo_Blue_5','ST5_Ringo_Green_5','ST5_Ringo_Green_7',...
    'ST5_Ringo_Red_2','ST5_Ringo_Red_7','ST5_Tiger_Blue_2','ST5_Tiger_Blue_5',...
    'ST5_Tiger_Green_5','ST5_Tiger_Green_7','ST5_Tiger_Red_2','ST5_Tiger_Red_7'};
cmmnt = {'SingleSpeaker','MultiSpeaker','Noise','Sinewave'};
for cnt1 = 1:28, allnames{2}{cnt1} = ['Trial' num2str(cnt1)];end
allsp = {'ST1','ST5'};
allwd = {'ready','tiger','ringo','go','to','red','blue','green','two','five','seven','now'};
%
allev = []; allout = [];
for N = 1:2
    expt = allexpt{N};
    names = allnames{N};
    wpath = [pwd '/MultiTalker/sounds/'];
    evntfname = [ddpth expt{1} '_evnt.mat'];
    if ~exist(evntfname,'file'),
        switch expt{1}
            case 'GP31_B16'
                param = 0.45;
%                 param = 0.75;
            case 'EC11_B75'
                param = 0.5;
            otherwise
                
                param = 0.75;
        end
        evnt = ECogFindEvents(ddpth,wpath,expt,names,param);
        evnt = ECogFindLabels(evnt);
        evnt = CRMgetBehavior(ddpth,subject,expt,evnt);
        save (evntfname,'evnt');
    else
        load (evntfname);
    end
    allev{N} = evnt;
    %
    outfname = [ddpth expt{1} '_' cond '_' electbr{1} '_' num2str(electbr{2}) '_' specflag '_out.mat'];
    if ~exist(outfname,'file')
        bef = 1;aft = 2.5; % in seconds
        %     bef = 0; aft = 0;
        fs = 100;
        out = ECogExtractData(evnt,cond,elects,names,[],[bef aft fs 4],specflag);
        save (outfname,'out');%,'stim','resp');
    else
        load(outfname);
    end
    allout{N} = out;
end
allout = CRMMatchMultiSingle(dpath,expt,allout);