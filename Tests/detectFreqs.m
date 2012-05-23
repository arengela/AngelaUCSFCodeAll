assignin('base','ecogDS',handles.ecogDS);
%%
Pall=[];
b=1
for i=1:256
    
    [Pall(b,:),f]=periodogram(ecogDS.data(i,:),[],[],400);
    b=b+1
end
logPeriodogram=20*log10(Pall);


m=mean(logPeriodogram,1);
 %OR
 %{
 badch=[113 114 115 116 124 128]
 m=mean(logPeriodogram(setdiff(1:256,badch),:),1);
 %}
figure
plot(m)

%smean10000=smooth(m,10000);
smean10000=smooth(m,50000);
figure;plot(f,smean10000)

%P=polyfit([cursor_info.Position(1) cursor_info2.Position(1)],[cursor_info.Position(2) cursor_info2.Position(2)],1)
%smean10000([cursor_info.Position(1): cursor_info2.Position(1)])=polyval(P,[cursor_info.Position(1): cursor_info2.Position(1)]);
s1000_Pall=[];
for i=1:256
    s1000_Pall(i,:)=smooth(logPeriodogram(i,:),100);
end

diff_sm=s1000_Pall-repmat(smean10000',[256,1]);
figure
imagesc(diff_sm)

diff_sm_norm=detrend(diff_sm')';

diff_sm=diff_sm_norm;

abs_diff=abs(diff_sm);
figure
imagesc(abs_diff,[0 40])
title('Difference between channel power spectrum and template spectrum')
colorbar

for i=1:256
    x=find(abs_diff(i,:)>12);
    m=unique(round(f(x)));
    bad_f{i}=m(find(m>0));
end

figure
for i=1:256
    try
        plot(bad_f{i},i,'b.')
    catch
    end
    hold on
end
%{
count_badf2=[];
for i=1:256
    count_badf2=vertcat(count_badf2, bad_f{i});
end
figure
hist(count_badf2,200)
title('Distribution of abnormal frequencies')
xlabel('Freq(Hz)')
ylabel('Count')



for i=1:256
    count_badf(i)=length(bad_f{i});
end
figure
subplot(2,1,1)
bar(count_badf)
title('Counts of Abnormal Frequencies per electrode')

axis([0 200 0 40])

subplot(2,1,2)
imagesc(reshape(count_badf,16,16)')
colorbar
title('Abnormal frequency distribution over all electrodes')
%}
%%
N=zeros(256,200);

for c=1:256
    N(c,bad_f(1).d{c})=1;
end

for c = 1:200, lab{c}=c;end
F = ECogDataMovie('C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC6','EC6',1:256,N,lab);
movie(F);

%make with multitaper periodogram
L2=detrend(logPeriodogram,1);
L2(find(L2<-1))=-1;
F = ECogDataMovie('C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC6','EC6',1:256,L2,lab);
%{
meanP=zeros(256,200);
for i=1:200
    for c=1:256
        col=find(abs_diff(c,:)>(i-1) & abs_diff(c,:)<i);
        meanP(c,i)=mean(abs_diff(c,col),2);
    end
end
%}
%%
f=6;
visualizeGrid(1,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC11\brain_3Drecon.jpg'],1:256,N(:,f),[])


%%
%get bad Frequencies of many blocks
b=1;
for i=130:length(allBlocks);
    try
        s=regexp(allBlocks{i},'_','split');
        subj=s{1};
        [bad_f(b).d,flag]=getAbnormalFreqs(['E:\PreprocessedFiles\' subj filesep allBlocks{i}],b);

        bad_f(b).s=subj;
        bad_f(b).block=allBlocks{i};
        b=flag;
        if b>50
            return
        end
            
            
    catch
    end
end

%%
%Block bad frequencies all blocks all channels
p=20;
figure
for p=1:31
    for i=1:256
        try
            plot(bad_f(p).d{i},(p-1)*256+i,'b.')
        catch
        end
        hold on
    end
end
%%
%
tmp=[]
for p=1:31
    for i=1:256
        tmp=[tmp length(bad_f(p).d{i})];
    end
end
%%
%count of channels with most bad Freqs over all blocks
tmp2=zeros(1,256);
for p=1:31
    for i=1:256
        tmp2(i)=[tmp2(i) + length(find(bad_f(p).d{i}>40 & bad_f(p).d{i}<190))];
    end
end
 
imagesc(reshape(tmp2,[16,16])',[0 500]);

%%
%count of bad freqs for each channel, with blocks separated
tmp2=zeros(1,256);
for p=1:31
    for i=1:256
        tmp2(p,i)=length(find(bad_f(p).d{i}>40 & bad_f(p).d{i}<190));
    end
end
 figure
imagesc(tmp2)
%%
%get block names
for i=1:31
    block{i}=bad_f(i).block
end

%%
count_badf2=[];

for p=1:31
    for i=1:256
        count_badf2=vertcat(count_badf2, bad_f(p).d{i});
    end
end
hist(count_badf2,200)

