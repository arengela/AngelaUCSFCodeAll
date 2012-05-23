mainpath=('E:\PreprocessedFiles');
%clear artif
cd(mainpath)
%patients=cellstr(ls);
%destinationfile='E:\PreprocessedFiles'
%destTDT='E:\RawTDTData';
x=1;
cnt=1;
for p=6:21%length(patients)

    x=[mainpath filesep patients{p}]
    cd(x)
    blocks=cellstr(ls);
    goodidx=regexp(blocks,sprintf('%s_',patients{p}))
    
    
    
    for i=1:length(goodidx)
        if ~isempty(goodidx{i}) & exist(blocks{i})==7
            x2=[x filesep blocks{i}]
            cd(x2)
            files=cellstr(ls)
            goodidx2=regexp(files,'Artifacts')

            for j=1:length(goodidx2)
                if ~isempty(goodidx2{j})
                    x3=[x2 filesep 'Artifacts']
                    cd(x3)
                    if strmatch('badChannels',ls) & strmatch('badTimeSegments.mat',ls)
                        load 'badTimeSegments.mat'

                        fid = fopen('badChannels.txt');
                        badChan = fscanf(fid, '%d');
                        fclose(fid);

                        if ~isempty(badTimeSegments)
                            bidx=regexpi(blocks{i},'b');
                            num=str2num(blocks{i}((bidx+1):end));
                            
                            eval(sprintf('r=PreprocessingLogMat.%s(:,1)',patients{p}));
                            for o=1:length(r), 
                                if r{o}==num
                                    row=o
                                end 
                            end
                            
                            eval(sprintf('PreprocessingLogMat.%s{%i,10}=badChan;',patients{p},row));
                           
                            %artif{cnt,3}=mat2str(badTimeSegments(:,1:2));
                            
                            if size(badTimeSegments,2)==5
                                eval(sprintf('PreprocessingLogMat.%s{%i,12}=badTimeSegments(:,5);',patients{p},row));
                            end
                            eval(sprintf('PreprocessingLogMat.%s{%i,11}=badTimeSegments(:,1:2);',patients{p},row));

                        end

                        %artif{cnt,2}=mat2str(badChan');
                        %artif{cnt,1}=blocks{i};
                        cnt=cnt+1;
                    end
                end
            end
        cd(x)    
        end
    end
end
            
%%           
cell2csv('E:\PreprocessedFiles\ArtifactLog2.csv',artif,'\t')

%%
patients={'EC1','EC2','EC4','EC6','EC7','EC8','GP26','GP30','GP31','GP33','GP35','CH'}
for i=1:length(patients)
    [n,t,r]=xlsread('C:\Users\Angela_2\Downloads\p4.xls',patients{i})
    eval(sprintf('PreprocessingLogMat.%s=r;',patients{i}))
end





