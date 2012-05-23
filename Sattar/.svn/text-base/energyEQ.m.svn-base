function maud=energyEQ (aud,step);
minen=aud(1,:);
% step=0.04;

% lowfilt=fir1(20,.1);
% for cnt1=1:size(aud,2)
%     lowaud(:,cnt1)=filtfilt(lowfilt,1,aud(:,cnt1));
% end   
% gain norm:
if 1
%     a = conv2(aud,fspecial('disk',100),'same');
    a = mean(aud,2);
    a = conv(a,ones(1,50)/50,'same');
    a = a/max(a);
    aud = aud ./ (.2+repmat(a,[1 size(aud,2)]));
end
    
    
for cnt1=1:size(aud,1)
    minen=min(aud(cnt1,:),minen+step);
%     minen=min(aud(max(1,cnt1-step):min(size(aud,1),cnt1+step),:));
    maud(cnt1,:)=max(0,aud(cnt1,:)-1.1*minen);
end
% maud=max(0,maud);
t=0;