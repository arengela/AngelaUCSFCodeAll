function [v5,v6] = wav2aud6oct(x, p)
% assume fs = 16000 . . 
if ~exist('p','var') || isempty(p)
    p = [10 10 -2 0];
end
aud2 = wav2aud(x,[p(1) p(2) p(3) p(4)]);
aud1 = 2.5*wav2aud(resample(x,2,5),[p(1)/2.5 p(2)/2.5 p(3) p(4)]);
% 
v5 = cat(2,aud1(:,1:64),aud2(:,32:end));
v5 = v5.^.25;
v6 = resample(v5(:,1:40)',1,2)';
v6(:,21:21+120) = v5(:,41:end);
v5 = resample(v5',100,size(v5,2))';
v5 = max(0,v5);
v5 = v5.^(1/.25);
v6 = resample(v6',100,size(v6,2))';
v6 = max(0,v6);
v6 = v6.^(1/.25);
disp('6oct');