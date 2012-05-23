subject = 'EC6';
dpath = datapath(pwd);
allexpt = ECogBlockNames(dpath,subject);
electbr = {'stg',1};
elects = ECogElectrodeLabel(subject,electbr{1},dpath,electbr{2});
specflag = 'audnorm'; % aud mel
cond = 'HilbAA_70to150_8band';
load EC6_B43_HilbAA_70to150_8band_stg_1_audnorm_out;
N = 16;
tmp = strfind(dpath,'eCogProjects');
spath  = [dpath(1:tmp-1) 'eCogProjects/Subjects/' subject '/g_' 'Timit' '_' ...
    cond '_' electbr{1} '_' num2str(electbr{2}) '_' specflag '.mat'];
load(spath);
lfp = ECogLFPresp({out(N).lfp},u(:,1:2,:),[],[],0,[mm1 mm2]);
lfp = lfp{1};
[tmp,rstim] = StimuliReconstruction([],[],mean(lfp,3)',g,rlags);
subplot(2,1,1);
imagesc(out(N).aud);axis xy;
subplot(2,1,2);
imagesc(rstim);axis xy;