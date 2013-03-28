%%ORGANIZE ANALOG FILES
dpath='E:\BrocaRepeatKJ'
cd(dpath)
files=cellstr(ls)
for i=4:15
    try
    copyfile(['C:\Users\Angela_2\Desktop\BrocaRepeatKJ\artifacts\' files{i} '_Artifacts'],[dpath filesep files{i} '\Artifacts'])
    copyfile(['C:\Users\Angela_2\Desktop\BrocaRepeatKJ\broca_repeat\eventfiles\phone_eventfiles\' files{i} '_phone.lab'],[dpath filesep files{i} '\Analog'])
    copyfile(['C:\Users\Angela_2\Desktop\BrocaRepeatKJ\broca_repeat\eventfiles\unique_word_eventfiles\' files{i} '.words.lab'],[dpath filesep files{i} '\Analog'])
    copyfile(['C:\Users\Angela_2\Desktop\BrocaRepeatKJ\broca_repeat\eventfiles\word_PW_eventfiles\' files{i} '.lab'],[dpath filesep files{i} '\Analog'])
    copyfile(['C:\Users\Angela_2\Desktop\BrocaRepeatKJ\broca_repeat\eventfiles\wordlength_PW_eventfiles\' files{i} '_wordlength_PW.lab'],[dpath filesep files{i} '\Analog']) 
    
    end
    quickPreprocessing_ALL([dpath filesep files{i}],3,0,2,[],[],256)
    try
        rmdir('Figures','s')
    end
end
%% CONVERT ANALOG FILES
for i=3:15
    try
        clear allEventTimes
        cd([dpath filesep files{i} filesep 'Analog'])
        tmp=readLabFile([files{i} '.lab'])
        type=tmp(:,2);
        tmp2=readLabFile([files{i} '.words.lab'])
        tmp3=readLabFile([files{i} '_wordlength_PW.lab'])

        words=tmp2(:,2);
        idx=1;
        for j=1:length(words)
            if strcmp(type{j},'WOST')
                allEventTimes{idx,1}=tmp{j,1}
                idx2=findNearest(tmp{j,1},cell2mat(tmp2(:,1)));
                allEventTimes{idx,2}=lower(tmp2{idx2,2})
                allEventTimes{idx,3}= allEventTimes{idx,2}
                allEventTimes{idx,4}=lower(tmp3{idx2,2})
                
                idx=idx+1;
                allEventTimes{idx,1}=tmp{j+1,1}
                allEventTimes{idx,2}='we'
                allEventTimes{idx,3}=allEventTimes{idx-1,3}
                allEventTimes{idx,4}=lower(tmp3{idx2,2})

                idx=idx+1;
                
            elseif strcmp(type{j},'WOPR')
                allEventTimes{idx,1}=tmp{j,1}
                idx2=findNearest(tmp{j,1},cell2mat(tmp2(:,1)));
                allEventTimes{idx,2}='r'
                allEventTimes{idx,3}=allEventTimes{idx-1,3}
                allEventTimes{idx,4}=lower(tmp3{idx2,2})

                idx=idx+1;
                allEventTimes{idx,1}=tmp{j+1,1}
                allEventTimes{idx,2}='re'
                allEventTimes{idx,3}=allEventTimes{idx-1,3}
                allEventTimes{idx,4}=lower(tmp3{idx2,2})

                idx=idx+1;
            elseif strcmp(type{j},'1800BEEP')
                allEventTimes{idx,1}=tmp{j,1}
                allEventTimes{idx,2}='beep'
                allEventTimes{idx,3}=allEventTimes{idx-1,3}
                 allEventTimes{idx,4}=lower(tmp3{idx2,2})

                idx=idx+1;            
            end
        end
        save('allEventTimes','allEventTimes')
        allConditions=unique(allEventTimes(:,2))
        save('allConditions','allConditions')
    end
end
%%
%% GET PHONEMES
for i=3:15
    try
        clear syllablesCount
        cd([dpath filesep files{i} filesep 'Analog']);
        tmp2=readLabFile([files{i} '_phone.lab']);
        phon=tmp2(:,2);
        syllablesCount=tmp2;
        idx=1;
        for j=1:length(phon)
            if strcmp(phon{j},'sp')
               idx=1;
            else
               syllablesCount{j,2}=num2str(idx);
               idx=idx+1;
            end
        end
        syllablesCount(:,3)=phon(:,1)
        save('syllablesCount','syllablesCount');
        BadTimesConverterGUI3 ([syllablesCount{:,1}]',syllablesCount(:,2),'syllablesCount.lab')    
    end
end

%% GET WORD CHARACTERISTICS
[a,b]=xlsread('E:\BrocaRepeatKJ\brocaseg.xlsx')
badChannels=tmp';

%% LOAD FILES
load('C:\Users\Angela_2\Dropbox\AngelaUCSFFiles\DelayWordBackup\brocawords.mat')
D=SegmentedData('E:\BrocaRepeatKJ\EC2_B47\HilbAA_70to150_8band','E:\BrocaRepeatKJ\EC2_B47\HilbAA_70to150_8band',1:256)
%% SEGMENT BY WORDS ONSET
D.segmentedDataEvents40band({{brocawords.names}},{[2000 2000]},[],'aa',1:40,0,'Default','EC2_B47.words.lab')
%%
D.segmentedDataEvents40band({{brocawords.names}},{[2000 2000]},[],'aa',1:40,0,'Default','EC2_B47.words')

%% SEGMENT BY WORDS ONSET
D3.segmentedDataEvents40band({{brocawords.names}},{[2000 2000]},[],'aa',1:40,0,'DelayRep')

%% SEGMENT BY SYLLABLE PLACE
a=cellfun(@(x){num2str(x)}, num2cell(1:12))
D.segmentedDataEvents40band(a,repmat({[50 100]},[1 12]),[],'aa',1:40,0,'Default','syllablesCount.lab')
%% LOAD ALL SYLLABLES TYPES
D.segmentedDataEvents40band({a},repmat({[50 100]},[1 12]),[],'aa',1:40,0,'Default','syllablesCount.lab')

%% SEGMENT BY BEGINNING VS END OF WORD
D.segmentedDataEvents40band({{'1','2','3'},{'10','11','12'}},repmat({[500 500]},[1 3]),[],'aa',1:40,0,'Default','syllablesCount.lab')
%%
D4.calcZscore(0)
D4.plotData('line')
%%
figure
colorjet=jet
coloridx=round(linspace(1,length(colorjet),12));
for i=1:12
    for epos=1:256
        plotGridPosition(epos);
        idx=find(strcmp(int2str(i),D.segmentedEcog(1).event(:,2)));
        plot(mean(D.segmentedEcog(1).zscore_separate(epos,:,:,idx),4),'Color',colorjet(coloridx(i),:))
        %imagesc(squeeze(D.segmentedEcog(1).zscore_separate(epos,:,:,idx))')
        hold on
        axis tight
        %set(gca,'YLim',[-.2 .2])
        if i==1
            line([50/1000*400 50/1000*400 ],[-.2 .2])
        end
        hold off
    end
    i
    input('m')
end
%% Segment Word by Syllable
%  Get Mean of data per syllable
load([D.MainPath '\Analog\syllablesCount.mat'])
eventSamp=800
clear segmentedWord
for tr=1:length( D.segmentedEcog.event)
    eventTime= D.segmentedEcog.event{tr,1}
    curWord= D.segmentedEcog.event{tr,3}
    idxStart=findNearest(eventTime,[syllablesCount{:,1}])
    idxsp=find(strcmp(syllablesCount(:,2),'sp'))
    idxEnd=idxsp(findNearest(eventTime,[syllablesCount{idxsp,1}]))
    segmentedWord(tr).meanSeg=zeros(256,14);
    segmentedWord(tr).meanSegRev=zeros(256,14);

    segmentedWord(tr).segTimes=zeros(1,14)
    segmentedWord(tr).word=curWord
    segmentedWord(tr).syllables=syllablesCount(idxStart:idxEnd,3)
    segmentedWord(tr).sylTot=idxEnd-idxStart;
    segTimes=cell2mat(syllablesCount(idxStart:idxEnd,1))-syllablesCount{idxStart,1};
    segmentedWord(tr).segTimes(1:length(segTimes))=segTimes;
    for s=1:idxEnd-idxStart
        samps=[round(segTimes(s)*400):round(segTimes(s+1)*400)]+eventSamp
        segmentedWord(tr).meanSeg(:,s)=mean(D.segmentedEcog.zscore_separate(:,samps,:,tr),2);
    end
    
    j=1
    for s=idxEnd-idxStart:-1:1
        samps=[round(segTimes(s)*400):round(segTimes(s+1)*400)]+eventSamp
        segmentedWord(tr).meanSegRev(:,j)=mean(D.segmentedEcog.zscore_separate(:,samps,:,tr),2);
        j=j+1;
    end
    
    
end
%% SORT TRIALS BY SYLLABLE NUMBER AND PLOT
figure
dat=cat(3,segmentedWord.meanSeg); 
goodtr=find(dat(1,1,:)~=0)
[~,sortIdx]=sort([segmentedWord(goodtr).sylTot])

for c=1:length(dat)
    plotGridPosition(c);
    dat2=squeeze(dat(c,:,goodtr(sortIdx)))';
    imagesc(dat2,[-1 1])
    axis tight
end
%% PLOT SEGS AVERAGED AROUND LAST SYLLABLE
figure
segTimes=vertcat(segmentedWord.segTimes)
for c=1:length(dat)
    plotGridPosition(c); 
    dat2=squeeze(dat(c,:,goodtr))';
    lastSyl=cell2mat(arrayfun(@(i) find(dat2(i,:),1,'last'),1:size(dat2,1),'UniformOutput',0))
    for i=1:length(lastSyl)
        lastSylMean(i)=dat2(i,lastSyl(i));
    end
    area(lastSylMean(sortIdx))
    
    axis([0 length(goodtr) -.5 2])

end
%% PLOT STACKED TRIALS WITH SYLLABLE BOUNDARIES
figure
for c=1:length(dat)
    plotGridPosition(c); 
    imagesc(squeeze(D.segmentedEcog.zscore_separate(c,800:1200,:,sortIdx))')
    hold on
%     for i=5%1:14
%         plot(segTimes(sortIdx,i)*400,1:length(sortIdx),'r')
%     end
    axis tight
end
%% Stacked AVERAGED AROUND SELECTED SYLLABLE
figure
clear dat2
sylPlace=1;
for c=1:length(dat)
    plotGridPosition(c); 
    for tr=1:length(goodtr)
        idx=find(segTimes(tr,:)~=0,1,'last')
        %idx=find(segTimes(tr,:)~=0,1,'first')
        if ~isempty(idx)
            dat2(tr,:)=D.segmentedEcog.zscore_separate(c,ceil(segTimes(goodtr(tr),idx-sylPlace)*400)+400:ceil(segTimes(goodtr(tr),idx-sylPlace)*400)+900,:,goodtr(tr));
            %samps=ceil(segTimes(goodtr(tr),sylPlace)*400)+400:ceil(segTimes(goodtr(tr),sylPlace)*400)+1200;
            %dat2(tr,:)=D.segmentedEcog.zscore_separate(c,samps,:,goodtr(tr));

        end
    end
    %imagesc(flipud(dat2))    
    %dat2=dat2(sortIdx,:);
    idx1b=find(ismember(goodtr,idx1));
    idx2b=find(ismember(goodtr,idx2));
    plot(mean(dat2(idx1b,:)),'b')
    hold on
     plot(mean(dat2(idx2b,:)),'r')
   line([400 400],[-1 2])
    %line([400 400],[0 length(sortIdx)])
    axis tight
end
%% PLOT AVERAGE LONG VS SHORT
D=D4;
Labels=D.segmentedEcog.event(:,4);
figure
samps=1:1600
for c=1:256
    plotGridPosition(c);
    idx1=find(strcmp('woprs',Labels))
    idx2=find(strcmp('woprl',Labels))
    [hl,hp]=errorarea(mean(D.segmentedEcog.zscore_separate(c,samps,:,idx1),4),ste(D.segmentedEcog.zscore_separate(c,samps,:,idx1),4));
    hold on
    [hl,hp]=errorarea(mean(D.segmentedEcog.zscore_separate(c,samps,:,idx2),4),ste(D.segmentedEcog.zscore_separate(c,samps,:,idx2),4));
    set(hl,'Color','r');set(hp,'FaceColor','r');
    line([800 800],[-1 2])
    axis tight
end
%%
figure
samps=800:1600
for c=1:256
    plotGridPosition(c);
    m=squeeze(max(D.segmentedEcog.zscore_separate(c,samps,:,:),[],2))';
    %plot(1:length(sortIdx)Word.sylTot])
    R(c).Rval=tmp(1,2)
    %bar(m(goodtr(sortIdx)))
end
%% CORR TO SYLLABLE POSITION
dat=cat(3,segmentedWord.meanSeg); 

dat2=dat(:,:,goodtr(sortIdx));
for c=1:256
    R(c).sylPos=zeros(14,size(dat2,3));
    for tr=1:size(dat2,3)
        for s=1:segmentedWord(tr).sylTot
            z=zeros(1,segmentedWord(tr).sylTot);
            z(s)=1;
            d=squeeze(dat2(c,1:segmentedWord(tr).sylTot,tr));
            r=corr(z',d','type','Spearman');
            R(c).sylPos(s,tr)=r;%r(1,2);
        end
    end
end
%%
figure
for c=1:256
    plotGridPosition(c)
    imagesc(R(c).sylPos')
    axis tight
end
%%
dat=cat(3,segmentedWord.meanSegRev);
dat2=dat(:,:,goodtr(sortIdx));
trIdx= goodtr(sortIdx);
for c=1:256
   R(c).sylPosRev=zeros(14,size(dat2,3));
   for tr=1:size(dat2,3)
        sylTot=segmentedWord(trIdx(tr)).sylTot
        for s=1:sylTot
            z=zeros(1,sylTot
            z(s)=1;
            d=squeeze(dat2(c,1:sylTot,tr));
            r=corr(z',d','type','Spearman');
            R(c).sylPosRev(s,tr)=r;%r(1,2);
        end
    end
end
%%
figure
for c=1:256
    plotGridPosition(c)
    imagesc(R(c).sylPosRev)
    axis tight
end
%% SMOOTH DATA
for c=1:256
    D.segmentedEcog.smoothed400(c,:,1,:)=smoothDim(squeeze(D.segmentedEcog.zscore_separate(c,:,:,:)),1,10)';
end
%% CORR OF WL TO PEAK TIME
figure
[sylTot,sortIdx]=sort([segmentedWord.sylTot])
clear R
for c=1:256
    [maxAmp,maxIdx]=max(squeeze(D.segmentedEcog.smoothed400(c,:,:,:))',[],2);
%     imagesc(squeeze(D.segmentedEcog.smoothed400(c,:,:,sortIdx))');
%     hold on
%     plot(maxIdx(sortIdx),1:70,'r.');
    
    
    outliers=find(abs(zscore(maxIdx))>2);
    usetr=setdiff(1:70,outliers);
    %plotGridPosition(c);
    %bar(maxIdx(sortIdx))
    [R(c).RmaxAmp,R(c).pmaxAmp]=corr(sylTot(usetr)',maxAmp(usetr),'Type','Spearman');
    [R(c).RmaxIdx,R(c).pmaxIdx]=corr(sylTot(usetr)',maxIdx(usetr),'Type','Spearman');
    for i=3:12
        R(c).sylTot(i).amp=mean(maxAmp(find(sylTot==i)));
        R(c).sylTot(i).idx=mean(maxIdx(find(sylTot==i)));
    end
    %area([R(c).sylTot.amp])
    
    %axis([0 10 -.5 2])
    %axis tight

end
%%
figure
d=[R.RmaxAmp];
d(find([R.pmaxAmp]>.05))=0
imagesc(reshape(d,16,16)',[-1 1])
labelGridOnMatix
%%
figure
for c=1:256
    if R(c).pmaxAmp<=.05
        plotGridPosition(c);
        area([R(c).sylTot.idx])
        title(num2str(R(c).RmaxAmp))
    end
end
%%

figure
d=[R.RmaxIdx];
d(find([R.RmaxIdx]>.01))=0
imagesc(reshape(d,16,16)',[-1 1])
labelGridOnMatix
