function log=checkBlocksOnDist(trialPath,dataPath,suffix,folder)

tmp=dir(trialPath);
idx=find([tmp.isdir]);
subj={tmp(idx).name};

i=1;
for s=3:length(subj)
    
    try
        try
            [a,b,c]=xlsread([trialPath filesep subj{s} filesep subj{s} '_trialnotes']);
        catch
            try
                [a,b,c]=xlsread([trialPath filesep subj{s} filesep subj{s} '_trialnotes.xlsx']);
            catch

                try
                    [a,b,c]=xlsread([trialPath filesep subj{s} filesep subj{s} '_trialnotes_database']);
                catch
                    [a,b,c]=xlsread([trialPath filesep subj{s} filesep subj{s} '_trialnotes_database.xlsx']);
                end
            end

        end
    catch
        continue
    end

    [row,col]=find(strcmp(c,'Block'));
    blocks=c(row+1:size(c,1),col:col+1);
    
    if ~isempty(blocks)
        for b=1:size(blocks,1)
            if isnan(blocks{b,1})
                continue
            elseif isnumeric(blocks{b,1})
                blockName=[subj{s} '_B' int2str(blocks{b,1})];
            else
                blockName=[subj{s} '_' blocks{b,1}];
            end

            if ~strcmp(lower(blocks{b,2}),'none') & ~strcmp(lower(blocks{b,2}),'bad') & ~isnan(blocks{b,2})
                if nargin<4
                    contents=dir([dataPath filesep subj{s} filesep blockName]);
                else
                    contents=dir([dataPath filesep subj{s} filesep blockName filesep folder ]);
                end

                log{i,1}=subj{s};
                log{i,2}=blockName;
                log{i,3}=blocks{b,2};
                for x=1:length(suffix)
                    idx=find(~cellfun(@isempty,regexp({contents.name},suffix{x})));
                    log{i,x+3}=length(idx);
                    log{i,x+length(suffix)+3}=sum([contents(idx).bytes])/10e9;
                end
                i=i+1;
            end
        end
    end
end
            