%% Relabel event trials to word

fid=fopen('E:\DelayWord\EC21\EC21_B1\Analog\wordlabels.txt');
fid=fopen('E:\PreprocessedFiles\EC21\EC21_B1\Analog\wordlabels_pseudo.txt');

c=textscan(fid,'%s');
wordlist=c{1};

load allEventTimes
idx=find(strcmp(allEventTimes(:,2),'word'));




allEventTimes(:,3)=allEventTimes(:,2);
allEventTimes(idx,3)=wordlist(1:48)
ev1=vertcat(allEventTimes{:,1})
BadTimesConverterGUI3(ev1,allEventTimes(:,3),'test.lab')
%%
count=1;
new=cell(1,2)
for i=1:size(allEventTimes,1)
        if strcmp(allEventTimes{i,2},'slide')
            new(count,:)=allEventTimes(i,:);
        elseif strcmp(allEventTimes{i,2},'beep')
            new(count,:)=allEventTimes(i,:);
        elseif strcmp(allEventTimes{i,2},'r') | strcmp(allEventTimes{i,2},'r-er') | strcmp(allEventTimes{i,2},'r-pher')
            new(count,:)=allEventTimes(i,:);
            count=1+count;
            new{count,1}=allEventTimes{i,1}+.1;
            new{count,2}='re';

        elseif find(strcmp(wordlist,allEventTimes{i,2}))
            
            new(count,:)=allEventTimes(i,:);
            count=1+count;
            new{count,1}=allEventTimes{i,1}+.1;
            new{count,2}='we';
        end

    
    count=count+1;
end

ev1=vertcat(new{:,1})
BadTimesConverterGUI3(ev1,new(:,2),'test.lab')

%%
%change EC21 badchannel numbers to real grid numbers
b_n=[];
for i=1:length(b_o)
    idx=find(newgrid==b_o(i));
    b_n=[b_n idx];
end
%%
load gridlayout_original
g=reshape(gridlayout',[1 256])
handles.ecogFiltered.data=handles.ecogFiltered.data(g,:,:,:);
handles.ecogBaseline.data=handles.ecogBaseline.data(g,:,:,:);
guidata(hObject, handles);
return
visualizeGrid(4,'E:\General Patient Info\EC21\brain+grid_3Drecon_cropped.jpg')



%% PLot segments zScore; initiate variables
subj='EC21'
figure
set(gcf,'Color','w')
aligned=3000
alignedfs=(aligned/1000)*400;
keep=0;
maxY=9;
minY=-4


buffer=3;

set(gca,'XTick',[0:400:2400]);
set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
plotrows=1
hFigure=figure
hFigure1=figure
hFigure2=figure
c=1:256
eventtext={'slide','word onset','word offset','beep','response onset','responseoffset'}
%% plot each segment averaged zscore and stacked plots and brain pic
i=keep(end)+1
while i<=256
    
    ch=c(i)
    type=1;
    
    %%
    for event=1:5%6
        
        set(0,'CurrentFigure',hFigure1)


        subplot(plotrows,6,event)

        [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);

        usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
        Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-buffer*400+1:alignedfs+buffer*400,usetrials));
        E=std(Y,[],2)/sqrt(size(Y,2));
        errorarea(mean(Y,2),E);
        hp=line([alignedfs alignedfs],[ minY maxY]);
        set(hp,'Color','r')
        ht=text(alignedfs+5, maxY-2,eventtext{event})
        set(ht,'Color','r')
        axis([0 2400 minY maxY])
        set(gca,'XTick',[0:400:2400]);
        set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
        %title(int2str(ch))
        %set(gcf,'Name',int2str(ch))
        title(['N=' int2str(length(usetrials))])



        set(0,'CurrentFigure',hFigure2)

        subplot(plotrows,6,event)

        imagesc(Y',[0 3])
        %pcolor(tmp);
        colormap(flipud(pink))
             hold on
             plot([alignedfs alignedfs+.001],[0 length(usetrials)],'r')
               plot(alignedfs+zScoreall(type).rt{event}(usetrials),1:length(usetrials),'r')
            hold off
      %axis([0 1600 minY maxY])
        set(gca,'XTick',[0:400:2400]);
        set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
    
    
    end
    
    
    set(0,'CurrentFigure',hFigure)
    %figure(hFigure)
    %subplot(2,5,6)
    visualizeGrid(2,sprintf('E:\General Patient Info\%s\brain+grid_3Drecon_cropped.jpg',subj),ch)
    colormap gray
    
    
    
    r=input('Next\n','s')
    if strcmp('y',r)
        
        keep=[keep ch];
    elseif strcmp('b',r)
       i=i-2;
    end
    i=i+1;
end
%%
c=1:256
for event=6%3:6
    activech{event}=[];
    i=1;
    while i<=256
        ch=c(i)
        type=1;
        set(0,'CurrentFigure',hFigure1)


       % subplot(1,2,1)

        [a,badtrials]=find(squeeze(zScoreall(type).data{event}(ch,:,:))>30);

        usetrials=setdiff(1:size(zScoreall(type).data{event}(ch,:,:),3),unique(badtrials));
        Y=squeeze(zScoreall(type).data{event}(ch,alignedfs-buffer*400+1:alignedfs+buffer*400,usetrials));
        E=std(Y,[],2)/sqrt(size(Y,2));
        errorarea(mean(Y,2),E);
        hp=line([alignedfs alignedfs],[ minY maxY]);
        set(hp,'Color','r')
        ht=text(alignedfs+5, maxY-2,eventtext{event})
        set(ht,'Color','r')
        axis([0 2400 minY 5])
        set(gca,'XTick',[0:400:2400]);
        set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
        %title(int2str(ch))
        %set(gcf,'Name',int2str(ch))
        title(['N=' int2str(length(usetrials))])



        set(0,'CurrentFigure',hFigure2)

        %subplot(1,2,2)

        imagesc(Y',[0 1.5])
        %pcolor(tmp);
        colormap(flipud(pink))
             hold on
             plot([alignedfs alignedfs+.001],[0 length(usetrials)],'r')
               plot(alignedfs+zScoreall(type).rt{event}(usetrials),1:length(usetrials),'r')
            hold off
      %axis([0 1600 minY maxY])
        set(gca,'XTick',[0:400:2400]);
        set(gca,'XTickLabel',[-3 -2 -1 0 1 2 3 ])
        title(['CH=' int2str(ch)])

        r=input('Next\n','s')
        if strcmp('y',r)

            activech{event}=[activech{event} ch];
        elseif strcmp('b',r)
           i=i-2;
        end
        i=i+1;
        
        
    
    end
end
    
%%
%plot ave Nima's spectrogram
for s=1:6
    figure
    set(gcf,'Name',num2str(s))
   
    imagesc ( mean(aud{s}(:,:,i),3)' .^ 0.25);
    hold on
    h=line([458 458],[ 0 100])
    set(h,'Color','r')
end

%%

%calculate Nima's spectrograms
for s=1:6
    d=segAnalog.data{s};  
    figure
    
    for i=1:size(d,3)
        tmp=squeeze(d(:,:,3));
        loadload;close;        
        aud{s}(:,:,i)= wav2aud6oct (tmp');

    end

end
%%
tmp2=mean(zScore{1},3);

for ch=1:256
    zDS{1}(ch,:)=resample(tmp2(ch,:),1,4);
end

%%

event=2

    data=zScoreall(1).data{event}(:,1000:2000,:);
n=200
figure
p=1
%%
for n=1:40:1000
    subplot(5,5,p)
        %%
        d=data(:,n:n+200,:);
        d2=max(d,[],2);
           [a,bad]=find(d2>30);

    d3=mean(d2(:,:,setdiff(1:size(d2,3),bad)),3);
    %data=mean(d1(:,n:n+39),2)-mean(d(:,n:n+39),2);
    
    
    ECogDataVis(dpath,subject,c,d3(c),1,[],[]);
    p=p+1;
    
    printf(int2str(n))
    %r=input('next')
end


%%
event=5
tmp=squeeze(mean(zScoreall.data{event}(activech{event},:,:),2));
[~,badtr]=find(tmp>8);
usetr=setdiff(1:size(tmp,2),badtr);
ztmp=mean(zScoreall.data{event}(activech{event},:,usetr),3);

ztmp2=(ztmp(:,1200:1600)')
[m,i]=max(ztmp2)
figure
[s,idx]=sort(i)
imagesc(ztmp2(:,idx)')
hold on
plot(i(idx),1:length(i),'k')
set(gca,'YTick',1:length(i))
set(gca,'YTickLabel',activech{event}(idx))
ECogDataVis(dpath,subject,activech{event}(idx),300-i(idx),1,[],[]);
%% load 40 band segments
test=SegmentedData('E:\DelayWord\EC22\EC22_B1\HilbReal_4to200_40band',[],0);

 test=SegmentedData('E:\DelayWord\EC22\EC22_B1\HilbReal_4to200_40band','E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band',0);
 test.segmentedDataEvents40band({[41;42]},{[5000 5000]},'save')
 
 %%
 handles.makePlots(zScore,'spectrogram',1,'k')
