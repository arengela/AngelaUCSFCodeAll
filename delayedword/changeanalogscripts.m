dtpath='E:\DelayWord\EC24b'
dtpath='E:\PreprocessedFiles\EC26'
wpath='C:\Users\Angela_2\Documents\ECOGdataprocessing\TaskFiles\syllables_6\'
wpath='E:\DelayWord\AllAnalog\broca\'

expt{1}='EC24_B1'
expt{1}='EC26_B2'
load 'C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\wordlist.mat'
names=cellstr(wordlist(:,1));
names{29}='Electronic_Chime-KevanGC-495939803'
names{30}='slide'


evnt = ECogFindEvents(dtpath,wpath,expt,names)
%%
idx=1;
for i=1:length(evnt)
    tmp{idx,1}=evnt(i).StartTime
    tmp{idx,2}=evnt(i).name
    tmp{idx,3}=evnt(i).name

    if strcmp(evnt(i).name,{'Electronic_Chime-KevanGC-495939803'})
        tmp{idx,2}='beep';
    elseif ~strcmp(evnt(i).name,'slide')
        %keyboard
        idx=idx+1;
        tmp{idx,1}=evnt(i).StopTime
        tmp{idx,2}='we'
        tmp{idx,3}=evnt(i).name
    end
        idx=idx+1;
end
tmp2=tmp(:,[1,2]);
E_times=cell2mat(tmp2(:,1))
trialslog=tmp2(:,2)

BadTimesConverterGUI3 (E_times,trialslog,sprintf('transcript_AN%d.lab',2))

%%
load([dtpath filesep expt{ex} '\Analog\allEventTimes.mat']);
idx=strcmp(allEventTimes(:,2),'r');
idx=strcmp(allEventTimes(:,2),'re');
%%
for ex=1:length(ex)
    load([dtpath filesep expt{ex} '\Analog\allEventTimes.mat']);
        save([dtpath filesep expt{ex} '\Analog\allEventTimes.mat_OLD'],'allEventTimes');

    for e=1:length(evnt)
        if (evnt(e).confidence<96)~=0

            idx=find(strcmp(allEventTimes(:,2),names(evnt(e).ind)));

            for i=1:length(idx)
                t=findnearest(evnt(e).StartTime,allEventTimes{i,1});
                allEventTimes{idx(i),1}=evnt(e).StartTime
                allEventTimes{idx(i)+1,1}=evnt(e).StopTime
            end
        end
    end
end
%% Add third column of associated word to AllEventsTimes file
for i=1:size(allEventTimes,1)
    if ~isempty(find(strcmp(allEventTimes{i,2},wordlist)))
        currentword=allEventTimes{i,2};
        if strmatch(allEventTimes{i-1,2},'slide')
            allEventTimes{i+1,3}=currentword;
        end
    elseif strmatch(allEventTimes{i,2},'slide')
            currentword= allEventTimes{i+1,2};
    end
        

    allEventTimes{i,3}=currentword;
end
save('allEventTimes','allEventTimes')