function saveEC6backwards(pathname)
handles.pathName=pathname
[a,b,c]=fileparts(handles.pathName)
handles.blockName=b
cd(handles.pathName)
%handles.folderName=sprintf('%s_data',handles.blockName);
%guidata(hObject, handles);
fprintf('File opened: %s\n',handles.pathName)
fprintf('Block: %s',handles.blockName)

%%
%%LOAD MATLAB VARIABLE
cd(sprintf('%s/%s',handles.pathName,'RawHTK'))

if isfield(handles,'timeInterval')
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk',[handles.timeInterval(1)*1000 handles.timeInterval(2)*1000]);
else
    [data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
    %load('Wav11.mat')
    %sampFreq=params.sampFreq;
end

handles.rawSampFreq=sampFreq
ecog.data=zeros(256,length(data));
fprintf('Loading channels:')
%chanNum=256;
for nBlocks=1:4
    for k=1:64
        varName1=['Wav' num2str(nBlocks) num2str(k)];
        fprintf('%s.',varName1)
        chanNum=(nBlocks-1)*64+k;
        %[data, sampFreq, tmp, chanNum] =readhtk (sprintf('%s.htk',varName1),[600*1000 900*1000]);
        
        if isfield(handles,'timeInterval')
            [data, sampFreq, tmp, chanNum] = readhtk ( sprintf('%s.htk',varName1),[handles.timeInterval(1)*1000 handles.timeInterval(2)*1000]);
        else
            [data, sampFreq, tmp, chanNum] = readhtk (sprintf('%s.htk',varName1));
            %load(sprintf('%s.mat',varName1))
            
        end
        
        %ecog.data((nBlocks-1)*64+k,:)=data; 
        ecog.data(chanNum,:)=data;
    end
end

cd ..

%%

mkdir('original_RawHTK')
movefile('RawHTK/Wav*','original_RawHTK')
cd('RawHTK')
%Save  
rlog=[]
olog=[]
blog=[]
clog=[]
for i=1:16:256
        real_ch=242-i;
        
        for j=1:16
            rlog=[rlog real_ch];
            olog=[olog i];
            
            
            
            b=ceil(real_ch/64);           
            c=rem(real_ch,64);
            

            if c==0
                c=64;
            end
            blog=[blog b];
            clog=[clog c];
            varName=sprintf('Wav%i%i.htk',b,c);
        
            fprintf('%s',varName)
        
     
            data=ecog.data(i,:);
            writehtk (varName, data, sampFreq, real_ch); 
            real_ch=real_ch+1;
            i=i+1
        end
    
end
