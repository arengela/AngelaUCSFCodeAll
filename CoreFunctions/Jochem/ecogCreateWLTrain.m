%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second approach: continuous wavelet transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frequencies = [3.5,4.3,5.1,5.9,6.7,7.6,8.5,9.5,10.6,11.7,13.0,14.4,...
              15.9,17.5,19.4,21.3,23.5,25.9,28.5,31.4,34.5,38.0,41.8,...
              46.0,50.6,55.7,61.2,67.4,74.1,81.5,89.7,98.6,108.5,119.3,...
              131.3,144.4,158.9,174.7];%(freqs_high(5:end)+freqs_low(5:end))/2;
nfreq = size(frequencies,2);

wname = ['cmor' num2str(centfrq('morl')) '-' num2str(centfrq('morl'))];

delta = sampDurMs/1000; % sampling period according to sampling rate

% getting scales corresponding to frequencies and wavelet
scales = centfrq(wname)./(frequencies.*delta);
movWL = zeros([size(movTS), length(frequencies)]);
% iterating over all channels and trials
for ch_i =1:size(movTS,1),
    fprintf('%s','.');
    for tr_i=1:size(movTS,3),
       series = movTS(ch_i,:,tr_i);
       c=abs(cwt(series,scales,wname));
       movWL(ch_i,:,tr_i,:) = c';
    end;
end;
statWL = zeros([size(statTS), length(frequencies)]);
% iterating over all channels and trials
for ch_i =1:size(statTS,1),
    fprintf('%s','.');
    for tr_i=1:size(statTS,3),
       series = statTS(ch_i,:,tr_i);
       c=abs(cwt(series,scales,wname));
       statWL(ch_i,:,tr_i,:) = c';
    end;
end;

% determine t-values
Tval = ecog_t_value(movWL,statWL);
Tval_sort = sort(abs(Tval(:)),'descend');
feat_idx = find(abs(Tval)>=Tval_sort(10000));
LABELS = [ones(size(statWL,3),1);-ones(size(movWL,3),1)];
TRAIN = zeros(size(statWL,3)+size(movWL,3),length(feat_idx));
for tr_i = 1:size(statWL,3),
    curI = squeeze(statWL(:,:,tr_i,:));
    TRAIN(tr_i,:) = curI(feat_idx);
end
for tr_i = 1:size(movWL,3),
    curI = squeeze(movWL(:,:,tr_i,:));
    TRAIN(tr_i+size(statWL,3),:) = curI(feat_idx);
end

% diffWL = squeeze(mean(movWL,3)-mean(statWL,3));
% create TRAIN data
% statWL_train = squeeze(sum(power(statWL,2),2));
% movWL_train = squeeze(sum(power(movWL,2),2));
% statWL_train=permute(statWL_train,[3,1,2]);
% movWL_train=permute(movWL_train,[3,1,2]);

% TRAIN = [reshape(statWL_train,size(statWL_train,1)*size(statWL_train,2),size(statWL_train,3)),...
%          reshape(movWL_train,size(movWL_train,1)*size(movWL_train,2),size(movWL_train,3))]';
% scale
TRAIN = TRAIN.*(10/max(TRAIN(:)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first approach: wavelet pyramid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % get wavelet coeff
% wLevel = 9;
% wName = 'db2';
% [wlCoeff,L] = wavedec(movTS(1,:,1),wLevel,wName);
% [pseudoFreq, pFInd] = wdecFrq(wLevel,L,sampDurMs/1000,wName);
%
% movWL = zeros(size(movTS,1),length(wlCoeff), size(movTS,3));
% for ch = 1:size(movTS,1),
%     for tr = 1:size(movTS,3),
%         movWL(ch,:,tr) = wavedec(movTS(ch,:,tr),wLevel,wName);
%     end
% end
% statWL = zeros(size(statTS,1),length(wlCoeff), size(statTS,3));
% for ch = 1:size(statTS,1),
%     for tr = 1:size(statTS,3),
%         statWL(ch,:,tr) = wavedec(statTS(ch,:,tr),wLevel,wName);
%     end
% end
%
% statWL_train = statWL(:,pFInd(end):end,:);
% movWL_train = movWL(:,pFInd(end):end,:);
% % statWL_train = zeros(size(statWL,1),length(pFInd),size(statWL,3));
% % movWL_train = zeros(size(movWL,1),length(pFInd)+1,size(movWL,3));
% % pFInd_start = [1 pFInd];
% % pFInd_end = [(pFInd-1),length(wlCoeff)];
% % for k=1:length(pFInd_start)
% %     statWL_train(:,k,:) = mean(abs(statWL(:,pFInd_start(k):pFInd_end(k),:)),2);
% %     movWL_train(:,k,:) = mean(abs(movWL(:,pFInd_start(k):pFInd_end(k),:)),2);
% % end
%
%
% % create TRAIN data
% LABELS = [ones(size(statWL_train,3),1);-ones(size(movWL,3),1)];
% statWL_train=permute(statWL_train,[2,1,3]);
% movWL_train=permute(movWL_train,[2,1,3]);
%
% TRAIN = [reshape(statWL_train,size(statWL_train,1)*size(statWL_train,2),size(statWL_train,3)),...
%          reshape(movWL_train,size(movWL_train,1)*size(movWL_train,2),size(movWL_train,3))]';
% % scale
% TRAIN = TRAIN.*(10/max(TRAIN(:)));

