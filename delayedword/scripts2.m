blockpath='E:\PreprocessedFiles\EC22\EC22_B1'

load([blockpath filesep 'segmented_sorted_3to3s.mat']);
load([blockpath filesep 'zScoreall_sorted_3to3s.mat']);

load([blockpath filesep 'segmentedAnalog_sorted.mat']);
%%
zScoreall=seg;
zScoreall.data=zScore;
save('zScoreall_3to3s','zScoreall','-v7.3');
%%
