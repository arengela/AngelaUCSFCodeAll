blocks(1,:)=[6 9 12 14 18 20 24 26 27 28 35 36]
blocks(2,:)=[1:6 8:13]
wpath='E:\PreprocessedFiles\EC26\stimuli_norm_db\'
dtpath='E:\DelayWord\EC28'
cd(wpath)
wordlist=cellstr(ls);
wordlist=wordlist(3:end);
tmp=regexp(wordlist,'.wav','split')
for i=1:length(tmp)
    names(i)=tmp{i}(1);
end
names=names'
%%
for i=1:2
    expt{1}=['EC28_B' int2str(blocks(1,i))]
    try
        evnt = ECogFindEvents(dtpath,wpath,expt,names)
    catch
        continue
    end
    clear tmp
    idx=1;
    for j=1:length(evnt) 
        if evnt(j).confidence>.80 & ~ismember(evnt(j).name,{'correct','incorrect'})
            tmp{idx,1}=evnt(j).StartTime
            tmp{idx,2}=evnt(j).name
            idx=idx+1;
        end
    end
    tmp2=tmp(:,[1,2]);
    E_times=cell2mat(tmp2(:,1))
    trialslog=tmp2(:,2)
    cd([dtpath filesep expt{1} '\Analog'])    
    BadTimesConverterGUI3 (E_times,trialslog,sprintf('transcript_AN%d.lab',2))
    makeCombinedEventFiles({sprintf('transcript_AN%d.lab',2)})
    
    load('allEventTimes')
    cd('C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC26\logfiles\word_learning')
    t=importdata(['EC26_run' int2str(blocks(2,i)) '.txt']);
    
    if isempty(find(strcmp(allEventTimes(:,2),t.textdata(3:end,1))==0))    
        allEventTimes(:,2:3)=t.textdata(3:end,1:2);
        allEventTimes(:,4:7)=num2cell(t.data);
        cd([dtpath filesep expt{1} '\Analog'])    
        save('allEventTimes','allEventTimes')
    else
        error(i)=1;           
                
    end
end

    
    
