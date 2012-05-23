function make_ERSAs(subjnum,cnd,datdir)
%cnd: condition number to process
%datdir: 'Cardat' or 'Datapac'

subjstr=['GP' int2str(subjnum)];
if nargin<3 | isempty(datdir)
    datdir='Cardat'; %datdir='Datapac';
end
if strcmp(datdir,'Cardat'), artdir='Artrejs2'; else artdir='Artrejs'; end;

cd(['/home/erik/Intrac/Subjs/' subjstr '/Artrejs']);
load badchans; load ref; load nvarchans; load epochs; load t0c; load codecols;
goodchans=setdiff(1:64+nvarchans,[badchans ref]); nchans=length(goodchans);

if strcmp(datdir,'Cardat'), do_stats=1; nboot=1000; else do_stats=0; end;

if subjnum<5 | strcmp(datdir,'Datapac'), frange=[3 250]; 
else frange=[3 1000]; end; if ismember(cnd,[2 45]), frange=[3 250]; end;
a=[log10(2.2); 0]; a=[log10(.07); 1]; a=[log10(.14); .8]; a=[log10(.39); .5];
if cnd==1, frange(1)=15; a=[log10(15); 0]; end; %40Hz SSR clicks
srate=2003; f0=0.018; octspace=1/7;
minf=frange(1); maxf=frange(2); maxfo=log2(maxf/f0);
cfs=f0; sigma_f=10^(a(1)+a(2)*log10(cfs(end)));
while log2(cfs(end)/f0)<maxfo
    cfo=log2(cfs(end)/f0); cfo=cfo+octspace;
    if cfs(end)<4, cfs=[cfs cfs(end)+sigma_f]; %switches to log spacing at 4 Hz
    else cfs=[cfs f0*(2^(cfo))]; end;
    sigma_f=10^(a(1)+a(2)*log10(cfs(end)));
end
cfs=cfs(find(cfs>=minf & cfs<=maxf)); npbs=length(cfs);
sigma_fs=(10.^([ones(length(cfs),1) log10(cfs')]*a))';
badfs=[find(cfs>340 & cfs<480) find(cfs>720 & cfs<890)];
sigma_fs=sigma_fs(setdiff(1:npbs,badfs)); 
cfs_all=cfs; cfs=cfs(setdiff(1:npbs,badfs)); npbs=length(cfs);
sds=sigma_fs.*sqrt(2);

load(['/home/erik/Intrac/Subjs/' subjstr '/Trialslogs/Conds/' int2str(cnd) '/scs']);
if subjnum==5 & cnd==11, scs=[1 21]; end; %this skips processing imag scs for BPN
if cnd==2, scs=setdiff(scs,[1 2]); end; %This skips the STA and DEV so won't bring down FDR
cd(['/home/erik/Intrac/Subjs/' subjstr '/ERSAs/' datdir '/' int2str(cnd)]);
save cfs cfs; save a a; save frange frange; save goodchans goodchans; save badfs badfs; save cfs_all cfs_all;
all_ERSAs=cell(1,length(scs)); all_bsamps=all_ERSAs;
all_ns=zeros(nchans,length(scs));
if do_stats==1, all_bootstat=cell(1,length(scs)); end;
cbnums=[]; sbcnt=0;
for sbcnd=scs
    sbcnt=sbcnt+1;
    load(['/home/erik/Intrac/Subjs/' subjstr '/Trialslogs/Conds/' int2str(cnd) '/sc' int2str(sbcnd)]);
    for b=1:length(sc), cbnums=[cbnums sc(b).bnums]; end;
    et=sc(1).ets; %assumes event type (1 or 2, stim or response) is same for entire subcond
    if et==1, epch=epochs(sc(1).bnums,1:2); else epch=epochs(sc(1).bnums,3:4); end;
    if cnd==45, epch=[401 1903]; end
    nsamps_ep=sum(epch)+1;
    all_ERSAs{sbcnt}=zeros(npbs,nsamps_ep,nchans);
    all_bsamps{sbcnt}=zeros(npbs,nchans);
    if do_stats==1, all_bootstat{sbcnt}=zeros(npbs,nboot,nchans); end;
end
cbnums=unique(cbnums);
% if length(cbnums)>1 %only need to calculate separately if multiple blocks in cnd
%     MAAc=zeros(npbs,nchans); %mean analytic amplitudes over the whole cnd
%     VAAc=zeros(npbs,nchans); %variances of the analytic amplitudes over the whole cnd
%     ntkeeps_tot=zeros(1,nchans);
% end
for bnum=cbnums
    MAAs=zeros(npbs,nchans); %mean analytic amplitudes over the whole block
    %VAAs=zeros(npbs,nchans); %variances of the analytic amplitudes over the whole block
    load(['/home/erik/Intrac/Subjs/' subjstr '/Trialslogs/ev' int2str(bnum)]);
    %load(['/home/erik/Intrac/Subjs/' subjstr '/Artrejs/trunc' int2str(bnum)]);
    load(['/home/erik/Intrac/Subjs/' subjstr '/' artdir '/trejs' int2str(bnum)]);
    load(['/home/erik/Intrac/Subjs/' subjstr '/' artdir '/eprej' int2str(bnum)]);
    load(['/home/erik/Intrac/Subjs/' subjstr '/' datdir '/gdat' int2str(bnum)]);
    loaded_v=0;
    
    T_orig=size(gdat,2); trunc=[];
    if isempty(trunc), do_trunc=0; else do_trunc=1; end;
    if do_trunc, gdat=gdat(:,trunc(1):trunc(2)); end
    
    T=size(gdat,2);
    freqs=(0:floor(T/2)).*(srate/T); nfreqs=length(freqs);
    h = zeros(1,T);
    if 2*fix(T/2)==T %if T is even
        h([1 T/2+1]) = 1; h(2:T/2) = 2;
    else h(1) = 1; h(2:(T+1)/2) = 2; end;

    chcnt=0;
    for ch=goodchans, chcnt=chcnt+1; 
        tkeeps=setdiff(1:T,trejs{ch}); if do_trunc, tkeeps=tkeeps-trunc_ts(1)+1; tkeeps=tkeeps(find(tkeeps>0)); end
        if ch>64 & loaded_v==0
            clear gdat; load(['/home/erik/Intrac/Subjs/' subjstr '/' datdir '/vdat' int2str(bnum)]);
            loaded_v=1; if do_trunc, vdat=vdat(:,trunc(1):trunc(2)); end
        end
        if length(tkeeps)>1
            adat=zeros(npbs,T);
            if ch<65, adat(end,:)=fft(gdat(ch,:),T);
            else adat(end,:)=fft(vdat(ch-64,:),T); end;
            for f=1:npbs
                H = zeros(1,T); k = freqs-cfs(f);
                H(1:nfreqs) = exp((-0.5).*((k./sds(f)).^2));
                H(nfreqs+1:end)=fliplr(H(2:ceil(T/2))); H(1)=0;
                adat(f,:)=abs(ifft(adat(end,:).*(H.*h),T));
                MAAs(f,chcnt)=mean(adat(f,tkeeps)); VAAs(f,chcnt)=var(adat(f,tkeeps));
            end

            MAAs(:,chcnt)=mean(adat(:,tkeeps),2);
            %VAAs(:,chcnt)=var(adat(:,tkeeps)')'; %This is correct, but caused Out of Memory
%             if length(cbnums)>1
%                 ntkeeps_tot(chcnt)=ntkeeps_tot(chcnt)+length(tkeeps);
%                 MAAc(:,chcnt)=MAAc(:,chcnt)+sum(adat(:,tkeeps),2);
%                 VAAc(:,chcnt)=VAAc(:,chcnt)+sum(adat(:,tkeeps).^2,2);
%             end

            sbcnt=0;
            for sbcnd=scs
                sbcnt=sbcnt+1;
                load(['/home/erik/Intrac/Subjs/' subjstr '/Trialslogs/Conds/' int2str(cnd) '/sc' int2str(sbcnd)]);
                scbnums=[]; for b=1:length(sc), scbnums=[scbnums sc(b).bnums]; end; scb=find(scbnums==bnum);
                if ismember(bnum,scbnums)
                    et=sc(scb).ets;
                    if et==1, epch=epochs(sc(scb).bnums,1:2); else epch=epochs(sc(scb).bnums,3:4); end;
                    if cnd==45, epch=[401 1903]; end
                    if sc(scb).ccs==0, events=find(eprej(ch,:,et)==1);
                    else events=find(eprej(ch,:,et)==1  & ismember(ev(:,sc(scb).ccs)',sc(scb).codes)); end;
                    if cnd==45 & sbcnd==2, events=find(eprej(ch,:,et)==1  & ismember(ev(:,sc(scb).ccs)',sc(scb).codes) & eprej(ch,:,2)==0); end;
                    all_ns(chcnt,sbcnt)=all_ns(chcnt,sbcnt)+length(events);
                    bsepch=epochs(sc(scb).bnums,1); %For defining prestim bsline
                    bsevents=ev(events,t0c(bnum,1)); %events for defining prestim bsline
                    if ismember(cnd,[9 10]) %for simple hand and mouth motor
                        bsepch=round(.2*srate);
                        bsevents=bsevents+srate+bsepch;
                    end
                    events=ev(events,t0c(bnum,et)); if do_trunc, events=events-trunc(1)+1; end
                    if length(events)>0
                        for ep=1:length(events)
                            all_ERSAs{sbcnt}(:,:,chcnt)=all_ERSAs{sbcnt}(:,:,chcnt)+adat(:,events(ep)-epch(1):events(ep)+epch(2));
                        end
                        for ep=1:length(bsevents)
                            all_bsamps{sbcnt}(:,chcnt)=all_bsamps{sbcnt}(:,chcnt)+mean(adat(:,bsevents(ep)-bsepch:bsevents(ep)),2);
                            if do_stats==1
                                all_bootstat{sbcnt}(:,:,chcnt)=all_bootstat{sbcnt}(:,:,chcnt)+adat(:,bsevents(ep)-ceil(rand(1,nboot).*bsepch));
                            end
                        end
                    end
                end
            end
        end
    end
    cd(['/home/erik/Intrac/Subjs/' subjstr '/MSPs/' datdir '/' int2str(bnum)]);
    save MAAs MAAs; %save VAAs VAAs;
    save cfs cfs; save a a; save frange frange; save goodchans goodchans; save badfs badfs;
end

%if length(cbnums)>1 & ntkeeps_tot>0
%    VAAs=(VAAc-(MAAc.^2)./repmat(ntkeeps_tot,[npbs 1]))./repmat(ntkeeps_tot-1,[npbs 1]);
%    MAAs=MAAc./repmat(ntkeeps_tot,[npbs 1]);  
%end
%cd(['/home/erik/Intrac/Subjs/' subjstr '/ERSAs/' datdir '/' int2str(cnd)]);
%save MAAs MAAs; save VAAs VAAs;
cd(['/home/erik/Intrac/Subjs/' subjstr '/ERSAs/' datdir '/' int2str(cnd)]);
sbcnt=0;
for sbcnd=scs
    sbcnt=sbcnt+1;
    ERSAs=all_ERSAs{sbcnt}; bsamps=all_bsamps{sbcnt}; ns=all_ns(:,sbcnt)';
    nsamps_ep=size(ERSAs,2);
    if do_stats==1
        load(['/home/erik/Intrac/Subjs/' subjstr '/Trialslogs/Conds/' int2str(cnd) '/sc' int2str(sbcnd)]);
        et=sc(1).ets; if et==1, epch=epochs(sc(1).bnums,1:2); else epch=epochs(sc(1).bnums,3:4); end;
        if cnd==45, epch=[401 1903]; end
        bootstat=all_bootstat{sbcnt}; ps=ones(npbs,nsamps_ep,nchans);
        epsamps_f=cell(1,npbs); %these are the samps to use for testing p-values for each freq band
        for f=1:npbs
            stp=floor(.5*srate/cfs(f)); srate_f(f)=srate/stp;
            epsamps_f{f}=unique([1 [ceil(epch(1)/2):-stp:1] [ceil(epch(1)/2):stp:nsamps_ep] nsamps_ep]);
        end
    end
    morebadchans=find(ns<2); currgoodchans=setdiff(1:nchans,morebadchans);
    for ch=currgoodchans
        ERSAs(:,:,ch)=ERSAs(:,:,ch)./ns(ch); bsamps(:,ch)=bsamps(:,ch)./ns(ch);
        if do_stats==1
            bootstat(:,:,ch)=bootstat(:,:,ch)./ns(ch);
            for f=1:npbs
                for s=epsamps_f{f}
                    ps(f,s,ch)=length(find(bootstat(f,:,ch)>=ERSAs(f,s,ch)))/nboot;
                end
                ps(f,find(ps(f,:,ch)==0),ch)=1/nboot; ps(f,find(ps(f,:,ch)==1),ch)=(nboot-1)/nboot;
                ps(f,:,ch)=2.*min(ps(f,:,ch),1-ps(f,:,ch));
                ps(f,:,ch)=interp1q(epsamps_f{f}',ps(f,epsamps_f{f},ch)',[1:nsamps_ep]')';
            end
        end
    end
    eval(['save ERSAs' int2str(sbcnd) ' ERSAs']);
    eval(['save bsamps' int2str(sbcnd) ' bsamps']); eval(['save ns' int2str(sbcnd) ' ns']);
    if do_stats==1
        %eval(['save ps' int2str(sbcnd) ' ps']);
        ps_fdr_c=cell(1,npbs);
        for f=1:npbs, ps_fdr_c{f}=ps(f,epsamps_f{f},currgoodchans); end;
        ps_fdr_c=MT_FDR_PRDS_c(ps_fdr_c);
        for f=1:npbs
            ps(f,epsamps_f{f},currgoodchans)=ps_fdr_c{f};
            for ch=currgoodchans
                ps(f,:,ch)=interp1q(epsamps_f{f}',ps(f,epsamps_f{f},ch)',[1:nsamps_ep]')';
            end
        end
        eval(['save ps_fdr' int2str(sbcnd) ' ps']);
    end
end
