% find destination trigger
dest_idx = find(eventsResampled==9);

% find direction trigger
dir_idx = find(eventsResampled>0 & eventsResampled < 7);
label_idx = dir_idx;
% remove zero values
dest_idx(x(dest_idx)<1 | y(dest_idx)<0.5)=[];
label_idx(x(dest_idx)<1 | y(dest_idx)<0.5)=[];
dir_idx(x(dir_idx)<1 | y(dir_idx)<0.5)=[];

centerX = mean(x(dir_idx));
centerY = mean(y(dir_idx));
centerDist = (...
            sqrt(power(x(dir_idx)-centerX,2)+power(y(dir_idx)-centerY,2)));
centerDistAll = sqrt(power(x-centerX,2)+power(y-centerY,2));  
maxDist = std(centerDist)*2;

% get number samples for 600 ms interval
nSamp = round(0.6*srate);
nSamp2 = round(0.4*srate);

dir_idx(centerDist>maxDist)=[];
movement_ons = dest_idx-nSamp+1;
movement_off = dest_idx;
static_ons = dir_idx - ceil(nSamp/2)+1;
static_off = dir_idx + ceil(nSamp/2);

% get distance
staticX = [];
staticY = [];
for k=1:length(static_ons);
    %find minimum slope within nSamp2 samples of nSamp Samples
    sMovOpt = inf;
    onset = static_ons(k);
    for slidW = 0:nSamp-nSamp2,
        sMov = sum(abs(diff(sqrt(...
            power(x(onset+slidW:onset+slidW+nSamp2),2)+...
            power(y(onset+slidW:onset+slidW+nSamp2),2)))));
        if sMov<sMovOpt,
            sMovOpt = sMov;
            static_ons(k)=onset+slidW;
        end
    end
    static_off(k)=static_ons(k)+nSamp2-1;
    staticX(k,:)=x(static_ons(k):static_off(k));
    staticY(k,:)=y(static_ons(k):static_off(k));
end
sMov = sum(abs(diff(sqrt(power(staticX',2)+power(staticY',2)))));
%figure;
discard_idx = find(sMov>(std(sMov)+mean(sMov)));
staticX(discard_idx,:) = [];
staticY(discard_idx,:) = [];
static_ons(discard_idx)=[];
static_off(discard_idx)=[];

% same for movement
movementX = [];
movementY = [];
for k=1:length(movement_ons);
    %find maximum slope within nSamp2 samples of nSamp Samples
    sMovOpt = 0;
    onset = movement_ons(k);
    for slidW = 0:nSamp-nSamp2,
        sMov = sum(abs(diff(sqrt(...
            power(x(onset+slidW:onset+slidW+nSamp2),2)+...
            power(y(onset+slidW:onset+slidW+nSamp2),2)))));
        if sMov>sMovOpt,
            sMovOpt = sMov;
            movement_ons(k)=onset+slidW;
        end
    end
    movement_off(k)=movement_ons(k)+nSamp2-1;  
    movementX(k,:)=x(movement_ons(k):movement_off(k));
    movementY(k,:)=y(movement_ons(k):movement_off(k));
end
sMov = sum(abs(diff(sqrt(power(movementX',2)+power(movementY',2)))));

discard_idx = find(sMov<(mean(sMov)-2*std(sMov)));

movementX(discard_idx,:) = [];
movementY(discard_idx,:) = [];
movement_ons(discard_idx) = [];
movement_off(discard_idx) = [];
label_idx(discard_idx) = [];

% here we have the static sample indices in
% static_ons and static_off
% and the movement sample indices in
% movement_ons and movement_off

channels = setdiff(1:size(Dec_CAReeg,1),bad_chan);
movTS = zeros(length(channels),nSamp2,length(movement_ons));
statTS = zeros(length(channels),nSamp2,length(static_ons));

for k=1:length(movement_ons),
    % baseline correction
    baseline = repmat(...
        mean(Dec_CAReeg(channels,movement_ons(k)-100:movement_ons(k)),2) ...
        ,1,(movement_off(k)-movement_ons(k)+1));
    movTS(:,:,k) = Dec_CAReeg(channels,movement_ons(k):movement_off(k)) ...
        - baseline;
end
for k=1:length(static_ons),
    % baseline correction
    baseline = repmat(...
        mean(Dec_CAReeg(channels,static_ons(k)-100:static_ons(k)),2) ...
        ,1,(static_off(k)-static_ons(k)+1));
    statTS(:,:,k) = Dec_CAReeg(channels,static_ons(k):static_off(k)) ...
        - baseline;
end

directions = eventsResampled(label_idx);
%
%  figure;plot([[0:0.01:(62*0.01)]'*ones(1,458)]'+mmovTS'); hold on;
%  plot([[0:0.01:(62*0.01)]'*ones(1,458)]'+mstatTS','--');ylim([-0.04 0.65])

