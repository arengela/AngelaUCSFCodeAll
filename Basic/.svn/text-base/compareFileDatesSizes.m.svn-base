dest_path='E:\PreprocessedFiles'
original_params.BTdate=[]
original_params.BTbytes=[]
original_params.Rawdate=[]
original_params.Rawbytes=[]
original_params.ANdate=[]
original_params.ANbytes=[]

copied_params.BTdate=[]
copied_params.BTbytes=[]
copied_params.Rawdate=[]
copied_params.Rawbytes=[]
copied_params.ANdate=[]
copied_params.ANbytes=[]


for i=1:length(successful)
    [a,block]=fileparts(successful{i})
    [b,patient]=fileparts(a)
    
    path_original=[successful{i} '/' block '_data']
    path_copied=[dest_path '/' patient '/' block]
    
    if isdir(path_original) & isdir(path_copied)

        cd(successful{i})
        tmp=dir('ANIN1.htk');
        
        if size(tmp,1)==0
            clear tmp
            tmp.date='0'
            tmp.bytes=0
        end
            original_params.ANdate{i}=tmp.date
            original_params.ANbytes{i}=tmp.bytes
        
        
        
        cd(path_original)
        tmp=dir('bad_time_segments.lab');
        if size(tmp,1)==0
            clear tmp
            tmp.date='0'
            tmp.bytes=0
        end
        original_params.BTdate{i}=tmp.date
        original_params.BTbytes{i}=tmp.bytes

   

        cd('RawHTK')
        tmp=dir('Wav11.htk');
        if size(tmp,1)==0
            clear tmp
            tmp.date='0'
            tmp.bytes=0
        end
        original_params.Rawdate{i}=tmp.date
        original_params.Rawbytes{i}=tmp.bytes

        cd(path_copied)
        cd('Analog')

        
        
        tmp=dir('ANIN1.htk');
        if size(tmp,1)==0
            clear tmp
            tmp.date='0'
            tmp.bytes=0
        end
        copied_params.ANdate{i}=tmp.date
        copied_params.ANbytes{i}=tmp.bytes

        cd ..

        cd('RawHTK')
         tmp=dir('Wav11.htk');
        if size(tmp,1)==0
            clear tmp
            tmp.date='0'
            tmp.bytes=0
        end
        copied_params.Rawdate{i}=tmp.date
        copied_params.Rawbytes{i}=tmp.bytes

        cd ..

        cd('Artifacts')
            tmp=dir('bad_time_segments.lab');
        if size(tmp,1)==0
            clear tmp
            tmp.date='0'
            tmp.bytes=0
        end
        copied_params.BTdate{i}=tmp.date
        copied_params.BTbytes{i}=tmp.bytes
    end
end


BTdate=strcmp(original_params.BTdate, copied_params.BTdate)
Rawdate=strcmp(original_params.Rawdate, copied_params.Rawdate)
ANdate=strcmp(original_params.ANdate, copied_params.ANdate)
BTbytes=isequal(original_params.BTbytes, copied_params.BTbytes)
Rawbytes=isequal(original_params.Rawbytes, copied_params.Rawbytes)
ANbytes=isequal(original_params.ANbytes, copied_params.ANbytes)





