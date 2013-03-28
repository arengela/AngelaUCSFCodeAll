
load('E:\DelayWord\brocawords.mat');
clear wordLength wordFreq wordProp
for i=1:length(Labels)
    idx=find(strcmp(Labels(i), {brocawords.names}'))
    if isempty(idx)
        wordProp.l{i}=0;
        wordProp.f{i}=0;
        wordProp.rp{i}='n';
        wordProp.ed{i}='n';
        wordProp.sl{i}='n';
    else
        wordProp.l{i}=brocawords(idx).lengthval;
        wordProp.f{i}=brocawords(idx).logfreq_HAL;
        wordProp.rp{i}=brocawords(idx).realpseudo;
        wordProp.ed{i}=brocawords(idx).difficulty;
        wordProp.sl{i}=brocawords(idx).lengthtype;
    end
    wordProp.name{i}=Labels{i};
end
wordLength=cell2mat(wordProp.l);
wordFreq=cell2mat(wordProp.f);