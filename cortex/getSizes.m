mainPath{1}='/data_store/human/raw_data'
mainPath{2}='/data_store/human/prcsd_data'
mainPath{3}='/data_store/human/raw_data/TDTbackup'
folderNames={'HilbAA_70to150_8band','HilbReal_4to200_40band','HilbImag_4to200_40band'}
folderNames={'RawHTK','Videos','HilbImag_4to200_40band'}

 x=1

for i=1
    cd(mainPath{i})
    patients=dir;
    for p=4:length(patients)
        if ~patients(p).isdir
            continue
        end

        cd([mainPath{i} filesep patients(p).name])
        blocks=dir;
        for b=3:length(blocks)
            if ~blocks(b).isdir
                continue
            end
            cd([mainPath{i} filesep patients(p).name filesep blocks(b).name])
            contents=dir;
            for c=3:length(contents)
                
                if ~contents(c).isdir
                    continue
                end
                col=find(strcmp(contents(c).name,folderNames));
                %col=3;
                
                if isempty(col)
                    continue
                end
                cd([mainPath{i} filesep patients(p).name filesep blocks(b).name filesep contents(c).name])
                folder=dir;
                allContents{x,1}=patients(p).name;
                allContents{x,2}=blocks(b).name;
                allContents{x,col+2}=sum([folder.bytes])/1.074e+9;
            end
            x=x+1;
        end
    end
end
%%
mainPath{1}='/data_store/human/raw_data'
mainPath{2}='/data_store/human/prcsd_data'
mainPath{3}='/data_store/human/raw_data/TDTbackup'
folderNames={'HilbAA_70to150_8band','HilbReal_4to200_40band','HilbImag_4to200_40band'}
 x=1

for i=3
    cd(mainPath{i})
    patients=dir;
    for p=4:length(patients)
        if ~patients(p).isdir
            continue
        end
        cd([mainPath{i} filesep patients(p).name])
        blocks=dir;
        for b=3:length(blocks)
            if ~blocks(b).isdir
                continue
            end
            cd([mainPath{i} filesep patients(p).name filesep blocks(b).name])
            contents=dir;
            for c=4:length(contents)
                
                if ~contents(c).isdir
                %    continue
                end
                %col=find(strcmp(contents(c).name,folderNames));
                col=3;
                
                if isempty(col)
                %    continue
                end
                %cd([mainPath{i} filesep patients(p).name filesep blocks(b).name filesep contents(c).name])
                folder=dir;
                allContents{x,1}=patients(p).name;
                allContents{x,2}=blocks(b).name;
                allContents{x,col+2}=sum([contents.bytes])/1.074e+9;
            end
            x=x+1;
        end
    end
end

%%
clear D
i=1
D.patients=[]
for j=1:length(allContents)
    idx=find(strcmp(vertcat(D.patients),allContents(j,1)))
    if isempty(idx)
        D(i).patients=allContents(j,1)
        i=i+1;
    else
        idx2=find(strcmp(D(idx).patients,allContents(:,1)))
        D(idx).blocks=length(idx2);
        D(idx).sizePrcsd=sum([allContents{idx2,3:5}])
    end    
end
%%
close all
folder='sizePrcsd'
allS=[D.(folder)]
bar(sort(allS,'descend'))
set(gca,'XTick',1:length(allS))
notEmpty=find(~cellfun(@isempty,{D.(folder)}))
[~,sortidx]=sort(allS/sum(allS),'descend')
set(gca,'XTickLabel',[D(notEmpty(sortidx)).patients])
% for t=1:28
%     text(t,[D(notEmpty(sortidx(t))).(folder)]+5,int2str([D(notEmpty(sortidx(t))).blocks]),'FontSize',20)
% end
ylabel('GB')
set(gca,'FontSize',12)
xlabel('Subjects')
%%
col=5
idx=find(~cellfun(@isempty,allContents(:,col)))
sum(cell2mat(allContents(idx,col)))/length(idx)

sum(cell2mat(allContents(idx,col)))



