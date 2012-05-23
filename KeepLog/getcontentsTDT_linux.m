cd '/data/AR'
load('subjects')

main='/data_store/human/raw_data'
cd(main)
contents{1,1}='Block'
contents{1,2}='HilbAA_70to150_8band'
contents{1,3}='HilbImag_4to200_40band'
contents{1,4}='HilbReal_4to200_40band'
contents{1,5}='Artifacts'
contents{1,6}='Analog'
contents{1,7}='RawHTK'
contents{1,8}='AfterCARandNotch'
contents{1,9}='copied'
%{
subjects{1}='EC1'
subjects{2}='EC2'
subjects{3}='GP26'
subjects{4}='GP30'
subjects{5}='EC11'
subjects{6}='EC6'
subjects{7}='EC9'
subjects{8}='GP31'
%}
%%
subjects{1}=[];


count=2;
m=1;
for i=1:length(subjects)
    try
        cd([main filesep subjects{i}])
        tmp=textscan(ls','%s')
        c=tmp{1}
        
        %c=tmp(3:end);
        for j=1:length(c)
            try
                cd([main filesep subjects{i} filesep c{j}])
                contents{count,1}=c{j};
                tmp=textscan(ls','%s');
                f=tmp{1};      
            catch
            end

                     
        end
      
    catch
        missing{m}=subjects{i};
        m=m+1;
    end
end
cur=pwd;