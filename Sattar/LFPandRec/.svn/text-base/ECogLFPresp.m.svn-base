function rp = ECogLFPresp (lfp,u,PSr,n,meanflag,mm)
% function
% get lfp (dim*time*rep)
% u: pca of EACH electrode (6*d*elect)
% n: which electrode
if ~exist('u','var') || isempty(u)
    u = [];
end
if ~exist('n','var') || isempty(n)
    n = [];
end
if ~exist('PSr','var') || isempty(PSr)
    PSr = [];
end
if ~exist('meanflag','var') || isempty(meanflag)
    meanflag = 1;
end
if ~exist('mm','var')
    mm = [];
end
rp = [];
NB  = size(lfp{1},1)/size(u,3); % how many bands for ech elect?
for cnt1 = 1:length(lfp)
    tmd2 = []; tmd3 = [];
    for cnt2 = 1:size(u,3)
        tmd2 = [];
        for cnt3 = 1:size(lfp{cnt1},3)
            tmp = lfp{cnt1}((cnt2-1)*NB+1:cnt2*NB,:,cnt3);
            if ~isempty(mm)
                tmp = mm(1)*tanh(tmp/mm(1));
            end
            if ~isempty(u)
                tmp = u(:,:,cnt2)'*tmp;
            end
            if ~isempty(mm)
                tmp = mm(2)*tanh(tmp/mm(2));
            end
            tmd2 = cat(3,tmd2,tmp);
        end
        if meanflag
            tmd2 = mean(tmd2,3);
        end
        tmd3 = cat(1,tmd3,tmd2);
    end
    if ~isempty(PSr)
        tmd3 = mapstd('apply',tmd3,PSr);
    end
    rporg{cnt1} = tmd3;
end
%%
if ~isempty(n)
    NB  = size(rporg{1},1)/size(u,3); % how many bands for ech elect?
    for cnt1 = 1:length(lfp)
        rp{cnt1} = rporg{cnt1}((n-1)*NB+1:(n-1)*NB+1,:,:);
    end
else
    rp = rporg;
end