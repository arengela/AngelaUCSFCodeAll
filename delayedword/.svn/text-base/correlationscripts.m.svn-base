event=3;
type=1;
samps=1500:2000;
usetrials_A=usetrials(find(usetrials(:,1)),1);
usetrials_A=1:55;
badChannels=find(isnan(zScoreall(type).data{event}(:,1,1)));
useChannels=setdiff(1:256,badChannels);
data=zScoreall(type).data{event}(useChannels,samps,usetrials_A);
data2=zScoreall(type).data{event}(useChannels,:,usetrials_A);

%% correlation between all trials for all channels
x=zeros(size(data,3),size(useChannels,2),size(useChannels,2));
h1=figure
h2=figure
h3=figure
for r=1:size(data,3)
    x(r,:,:)=corrcoef(squeeze(data(:,:,r))');
   
    figure(h2)
    imagesc(squeeze(x(r,:,:)));
    


    %u=input('plot?','s');
    if 1%strcmp('p',u)
        [a,b]=find(squeeze(x(r,:,:))>.4 & squeeze((x(r,:,:)~=1)));
        N=hist(b,256);
        s=find(N>15);
        ECogDataVis (['E:\General Patient Info\EC18_v2'],'EC18',s,[],2,[],[]); %Cropped brain

        for c1=1:211
          if ismember(c1,s)
             ch=useChannels(c1);

            figure(h3)
                colormap(gray)    

            figure(h1)
            subplot(16,16,ch)
            plot(data2(c1,:,r))
            hold on
            Y=data2(c1,:,:);
            mean_Z=mean(Y,3);
                    E = std(Y,[],3)/sqrt(size(Y,3));

            X=1:size(Y,2);
            hp=patch([X, fliplr(X)], [mean_Z+E,fliplr(mean_Z)-E],'m');
            set(hp,'FaceAlpha',.5)
            set(hp,'EdgeColor','none')
            
            axis([0 2400 -2 5])
            set(gca,'XTickLabel',[])
            set(gca,'YTickLabel',[])
            text(1,1,int2str(ch));
            hold off

           end
        end
    end
   input('next');
end
%% correlation of the correlation matrices

x3=zeros(55,55);
for i=1:55
    %r=find(wordmatch(:,1)==i);
    if ~ismember(0,r)
        for j=1:55
            try
                %x2=corrcoef(x(r(1),:,:),x(r(2),:,:));
                %x3(i)=x2(1,2);
                x2=corrcoef(x(i,:,:),x(j,:,:));
                x3(i,j)=x2(1,2);
            end
        end
    end
end

%% correlation between same words vs other words
x4=zeros(1,28);
for i=1:28
    r=find(wordmatch(:,1)==i);
    if ~ismember(0,r)
        try
            x4(i)=x3(r(1),r(2));
            x5(i)=mean(x3(r(1),setdiff(1:55,r)));
        end
    end
end

%% Correlation between stimuli

tmp=reshape(zScoreall.data{2}(activech{2},1200:1600,:),[1,length(activech{2})*length(1200:1600),54]);
tmp(1,:,33)=NaN
R=corrcoef(squeeze(tmp));
R(find(R==1))=0
imagesc(R)
[a,b]=max(R)
wordorder=squeeze(zScoreall.eventTS{2}(1,1200,1,zScoreall.trialidx{2}))
match=allConditions(wordorder)
match(:,2)=match(b,1)




