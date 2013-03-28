clear all
all{1}=[]

for bl=1
    try
        filename=['C:\Users\Angela_2\Documents\Database\' 'PreprocessingLog (2).xls']
        [dat,txt,raw]=xlsread(filename,'All');
   
    end
    [a,b]=find(strcmp(raw,'Task'))
    lastIdx=length(raw(a+1:end,b))+a;
    lengthAll=length(all);
    for i=[1:length(heading)]
        [a,b]=find(strcmp(raw,heading{i}))
        if ~isempty(b)
            for row=a+1:lastIdx
                try
                    all(lengthAll+row,b)={int2str(raw{row,b})};
                catch
                     all(lengthAll+row,b)=raw(row,b);
                end
            end
        end
    end
    
    for i=[1:length(heading)]
        [a,b]=find(strcmp(raw,heading{i}))
        if ~isempty(b)
            for row=a+1:lastIdx
                try
                    all(lengthAll+row,b)={int2str(raw{row,b})};
                catch
                     all(lengthAll+row,b)=raw(row,b);
                end
                 all(lengthAll+row,3)={[all(lengthAll+row,2) '_B', all(lengthAll+row,4)]};

            end
        end
    end
    
end
    %%

for bl=6:36
    try
        filename=['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC' int2str(bl) '\EC' int2str(bl) '_trialsnotes.xls']
        [dat,txt,raw]=xlsread(filename);
    catch
        try
            filename=['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC' int2str(bl) '\EC' int2str(bl) '_trialnotes.xls']
            [dat,txt,raw]=xlsread(filename);    
        catch
            try
                filename=['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\EC' int2str(bl) '\EC' int2str(bl) '_trialnotes.xlsx']
                [dat,txt,raw]=xlsread(filename); 
            catch
                continue
            end
        end
    end
    [a,b]=find(strcmp(txt,'Task'))
    lastIdx=length(txt(a+1:end,b))+a;
    lengthAll=length(all);
    for i=1:length(heading)
        [a,b]=find(strcmp(txt,heading{i}))
        if ~isempty(b)
            for row=a+1:lastIdx
                try
                    all(lengthAll+row,b)={int2str(raw{row,b})};
                catch
                     all(lengthAll+row,b)=raw(row,b);
                end
                 all(lengthAll+row,2)={['EC' int2str(bl)]};
                 all(lengthAll+row,3)={['EC' int2str(bl) '_B', all(lengthAll+row,4)]};

            end
        end
    end
end
    
    
 

    
 
