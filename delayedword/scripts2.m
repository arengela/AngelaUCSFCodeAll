blockpath='E:\PreprocessedFiles\EC22\EC22_B1'

load([blockpath filesep 'segmented_sorted_3to3s.mat']);
load([blockpath filesep 'zScoreall_sorted_3to3s.mat']);

load([blockpath filesep 'segmentedAnalog_sorted.mat']);
%%
zScoreall=seg;
zScoreall.data=zScore;
save('zScoreall_3to3s','zScoreall','-v7.3');
%%
allfiles=    {
    'E:\DelayWord\EC16\EC16_B1';
    'E:\DelayWord\EC18\EC18_B1';    
    'E:\DelayWord\EC20\EC20_B18';
    'E:\DelayWord\EC20\EC20_B23';
    'E:\DelayWord\EC20\EC20_B54';
    'E:\DelayWord\EC20\EC20_B64';
    'E:\DelayWord\EC20\EC20_B67';
    'E:\DelayWord\EC21\EC21_B1';
    'E:\DelayWord\EC22\EC22_B1'
    }
baseline{2}='E:\DelayWord\EC18\EC18_B1'
baseline{8}=    'E:\DelayWord\EC21\EC21_B1';
    baseline{9}='E:\DelayWord\EC22\EC22_B1'

seg={[repmat(41,[1 40]);1:40],[1:40;repmat(42,[1 40])],[42;43],[43;44],[44;45]}
            clear test
%%
for n=1:length(allfiles)
    for e=1:5
        try
            test=SegmentedData([allfiles{n} '/HilbReal_4to200_40band'],[],0); 
            if n==1
                test.channelsTot=128;
            end
            test.segmentedDataEvents40band(seg(e),{[5000 5000]},'save')    
            clear test
        end
    end
end
    
%%   
cd('E:\DelayWord\EC20\EC20_B18\segmented_40band')
eventfolders=cellstr(ls);
alllog=eventfolders(3:7)'
r=1;
for n=1:length(allfiles)
    for e=1:5
        cd([allfiles{n} '\segmented_40band']);
            eventfolders=cellstr(ls);
            for f=3:length(eventfolders)
                idx=find(strcmp(eventfolders{f},alllog(1,:)));
                if idx
                    cd([allfiles{n} '\segmented_40band' filesep eventfolders{f}]);
                    %input('cont')
                    alllog{n+1,6}=length(ls)-2;
                    chanFile=cellstr(ls);
                    if length(chanFile)>2
                        for c=3%:length(chanFile)-1

                                 cd([allfiles{n} '\segmented_40band' filesep eventfolders{f} filesep chanFile{c}])
                            %alllog{n+1,idx}=[alllog{n+1,idx} length(ls)-2];
                                alllog{n+1,idx}=length(ls)-2;


                        end
                    end
                end
            end
    end
end
        
%%
    save_file='C:\Users\Angela_2\Documents\Presentations\Autotest5.ppt'

for n=1:length(allfiles)
    for e=1:5
        try
            test=SegmentedData([allfiles{n} '/HilbReal_4to200_40band'],[baseline{n} '/HilbReal_4to200_40band'],0); 
            if n==1
                test.channelsTot=128;
            end
            %test.loadSegments({[allfiles{n} '\segmented_40band\event' int2str(unique(seg{e}(1,:))) '_5000_5000']},10,1)
             test.segmentedDataEvents40band(seg(e),{[5000 5000]},'keep')  

            
            
            powerpoint_object=SAVEPPT2(save_file,'init')
            SAVEPPT2('ppt',powerpoint_object,'n',allfiles{i} );

            
            clear test
        end
    end
end

    save_file='C:\Users\Angela_2\Documents\Presentations\Autotest5.ppt'
    powerpoint_object=SAVEPPT2(save_file,'init')
    SAVEPPT2('ppt',powerpoint_object,'n','This is a test2');
    SAVEPPT2('ppt',powerpoint_object);

