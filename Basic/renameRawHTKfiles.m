function renameRawHTKfiles(pathName)

handles.pathName=pathName;
[a,b,c]=fileparts(handles.pathName);
handles.blockName=b;
cd(handles.pathName);
handles.folderName=sprintf('%s_data',handles.blockName);
%guidata(hObject, handles);
printf('File opened: %s\n',handles.pathName);
printf('Block: %s',handles.blockName);

%%
%%LOAD MATLAB VARIABLE
cd(sprintf('%s/%s/%s',handles.pathName,handles.folderName,'RawHTK'))
[data,Fs]=readhtk('Wav11.htk');
dataLength=length(data);
cd(sprintf('%s/%s',handles.pathName,handles.folderName))
mkdir('RawHTK_original')
movefile('RawHTK/Wav*','RawHTK_original')
%cd(sprintf('%s/%s/%s',handles.pathName,handles.folderName,'RawHTK'))



for nBlocks=1:4
    for k=1:64
        chanNum=(nBlocks-1)*64+k
        
        if chanNum>=65
            if chanNum==256
                fakedata=zeros(1,dataLength);
                cd(sprintf('%s/%s/%s',handles.pathName,handles.folderName,'RawHTK'))
                writehtk('Wav464.htk',fakedata,Fs,256);                
            else
            wrongChanNum=chanNum+1;
            %nBlocks2=floor(chanNum/64)+1;
            %k2=rem(chanNum,64);
        
            
            varName1=['Wav' num2str(nBlocks) num2str(k)]

            sourceFile=sprintf('%s/%s/RawHTK_original/Wav1%s.htk',handles.pathName,handles.folderName,num2str(wrongChanNum));
            destinationFile=sprintf('%s/%s/RawHTK/%s.htk',handles.pathName,handles.folderName,varName1);
            copyfile(sourceFile,destinationFile)
            end
        else
            varName1=['Wav' num2str(nBlocks) num2str(k)]

            sourceFile=sprintf('%s/%s/RawHTK_original/Wav1%s.htk',handles.pathName,handles.folderName,num2str(chanNum));
            destinationFile=sprintf('%s/%s/RawHTK/%s.htk',handles.pathName,handles.folderName,varName1);
            copyfile(sourceFile,destinationFile)
        end
    end
end
%{
cd(sprintf('%s/%s/%s',handles.pathName,handles.folderName,'RawHTK'))
copyfile('Wav30.htk','Wav264.htk')

copyfile('Wav40.htk','Wav364.htk')
delete('Wav30.htk','Wav40.htk');

%}

