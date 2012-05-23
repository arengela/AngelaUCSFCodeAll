x=ecogDS.data(79,:);

[B,f,t]=specgram(x,[],400);
figure
imagesc(t,f,20*log10(abs(B)));

B2=abs(B);
Bz=zscore(B2,[],2);
Y2 = prctile(Bz,99,2)
tmp=Bz-repmat(Y2,[1,2020]);
tmp2=sum(tmp,1);

figure
imagesc(tmp)
figure
plot(tmp2)

%%
for i=1:length(c)
    t=find(c==i);
    t2(i)=length(t);
    clear t
end

%%
ecogDS=handles.ecogDS;
d=ecogDS.data;
d_normall=detrend(d')';
badch=handles.badChannels;
badch=90
ecogDS.badChannels=badch;


k1=kurtosis(d_normall,[],2);
k2=kurtosis(d_normall,[],1);

k_t=find(k1>8);
k_c=find(k2>10);

k_t=1:256;

p99_all=prctile(d_normall,99,2);
[c,bad_t_all,v]=find(d_normall>repmat(p99_all,[1 size(d_normall,2)])|d_normall<repmat(-p99_all,[1 size(d_normall,2)]));


p99_all_ch=prctile(d_normall(setdiff(1:256,badch),:),99,1);
[c_ch,bad_t_all_ch,v_ch]=find(d_normall>repmat(p99_all_ch,[size(d_normall,1),1])|d_normall<repmat(-p99_all_ch,[size(d_normall,1),1]));



A=zeros(256,size(d_normall,2));
A2=zeros(256,size(d_normall,2));

for i=1:256
    cur_c=find(c==i);
    A(i,bad_t_all(cur_c))=d_normall(i,bad_t_all(cur_c));
    
    %cur_c2=find(c_ch==i);
    %A2(i,bad_t_all_ch(cur_c2))=d_normall(i,bad_t_all_ch(cur_c2));
end

for i=1:256
    cur_c=find(c==i);
    A(i,bad_t_all(cur_c))=1;
    
end 



A2=A2*2;
A3=A+A2;
figure
imagesc(A3)
A4=abs(A3);
figure
imagesc(A4)

A4_sum=sum(A4,1);

%plot(1:length(A4_sum),A4_sum,'.')

%%
A_sum=A4_sum;

A_sum=sum(abs(A),1);
bad_t=find(A_sum>prctile(A_sum,95));


bad_seg=[(bad_t/400-.1)' (bad_t/400+.1)'];

B=bad_seg(1,:);
m=1
for i=1:size(bad_seg,1)-1
    
        if bad_seg(i+1,1)> bad_seg(i,1)-.1 & bad_seg(i+1,1)< bad_seg(i,2)+.1
            B(m,2)=bad_seg(i+1,2)
        else 
            m=m+1
            B(m,:)=bad_seg(i+1,:);
        end
end        

dif=B(:,2)-B(:,1);
idx=find(dif<.22);
B(idx,:)=[]

%
B1=B;
B2=B;

%%


B=[];
m=1
for i=1:size(B1,1)
    for j=1:size(B2,1)
        if (B1(i,1)>=B2(j,1) & B1(i,1)<= B2(j,2)) | (B1(i,2)>= B2(j,1) & B1(i,2)<= B2(j,2))
            B=[B;B1;B2];
        end
    end
end        

[X,i]=sort(B(:,1));
BBB=B(i,:);
B=BBB;

K=[];
m=1
for i=1:size(B,1)-1
    
        if B(i+1,1)> B(i,1)-.1 & B(i+1,1)< B(i,2)+.1
            K(m,2)=B(i+1,2)
        else 
            m=m+1
            K(m,:)=B(i+1,:);
        end
end   


ecogDS.badIntervals=[K zeros(length(K),3)]


ecogDS.badIntervals=[B zeros(length(B),3)]




ecogTSGUI(ecogDS)

%%
%find slope

for i=1:256
    dsm(i,:)=smooth(d_normall(i,:));
end
slope=diff(dsm,[],2);
slope=diff(d_normall,[],2);

slope_z=abs(zscore(slope));
slope_p=prctile(slope,95,2);
bad_t=zeros(size(slope));
for i=1:256
    idx=find(abs(slope(i,:))>slope_p(i));
    bad_t(i,idx)=1;
end

tmp=std(slope,[],1);
bad_t=find(tmp>60);

tmp=range(slope,1);
bad_t=find(tmp>500);

figure
plot(tmp)


%%
z=zscore(ecogDS.data,[],2);
dev=zeros(size(ecogDS.data));
for i=1:256
    idx=find(z(i,:)>3);
    dev(i,idx)=z(i,idx);
end



    
