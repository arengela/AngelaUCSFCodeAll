function [rsf,allrsf] = ModulationAnalysis (infeat,param,rv,sv)
% infeat can be wave cells or aud cells
rsf = []; allrsf = []; 
if ~exist('param','var') || isempty(param)
    param = [10 10 -2 0 0 1 1];
end
if ~exist('rv','var') || isempty(rv)
    rv = 2.^(0:5); sv = 2.^(-2:3);
end
if isvector(infeat{1})
%     loadload;close;
    for cnt1 = 1:length(infeat)
        wav = infeat{cnt1};
        wav = unitseq(wav);
        tmp = wav2aud(wav,param(1:4));
        aud{cnt1} = (tmp).^.25;
    end
else
    aud = infeat;
end
for cnt1 = 1:length(aud)
    tmp = aud2cor(aud{cnt1},param,rv,sv,'tmp');
    if param(6)==1
        tmp = tmp(:,:,:,65:64+128);
    end
    cor{cnt1} = abs(tmp);
end
%% analysis:
pow =.25;
mcor = [];maud = [];
for cnt1 = 1:length(cor)
    tmp = aud{cnt1};
    maud = cat(1,maud,tmp);
    tmp = cor{cnt1};
    mcor = cat(3,mcor,tmp);
    tmp = squeeze(mean(tmp,3));
    allrsf{1}{cnt1} = rst_view(tmp.^pow,rv,sv,1,[],[],2);
    allrsf{2}{cnt1} = rst_view(tmp.^pow,rv,sv,2,[],[],2);
    allrsf{3}{cnt1} = rst_view(tmp.^pow,rv,sv,3,[],[],2);    
end
mcor = squeeze(mean(mcor,3));
% figure;
subplot(2,3,1);
tmp = mean(maud,1);
plot(tmp/sum(tmp));
title('Frequency');
axis tight;
a = axis; axis([a(1) a(2) a(3)*.9 a(4)*1.1]);
h1 = subplot(2,3,2);
h2 = subplot(2,3,3);
rsf{1} = rst_view(mcor.^pow,rv,sv,1,[],[],[],[h1 h2]);
title('rate-frequency');
h1 = subplot(2,3,4);
rsf{2} = rst_view(mcor.^pow,rv,sv,2,[],[],[],[h1]);
title('scale-frequency');
h1 = subplot(2,3,5);
h2 = subplot(2,3,6);
rsf{3} = rst_view(mcor.^pow,rv,sv,3,[],[],[],[h1 h2]);
title('rate-scale');