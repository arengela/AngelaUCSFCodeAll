function saveEcogToHTK(filename,ecog)

currentPath=pwd;

mkdir(filename)
cd(filename)
Fs=ecog.sampFreq;


blockNum=floor(size(ecog.data,1)/64);
elecNum=rem(size(ecog.data,1),64);
    %[data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
    %handles.sampFreq=sampFreq;
    %ecog.data=zeros(channelsTot,size(data,2),size(data,1));
    %LOAD HTK FILES
    for nBlocks=1:blockNum
        for k=1:64
           varName=sprintf('Wav%s%s.htk',num2str(nBlocks),num2str(k));
            chanNum=(nBlocks-1)*64+k;
            fprintf('%i.\n',chanNum);
            data=squeeze(ecog.data((nBlocks-1)*64+k,:,:));
            writehtk (varName, data', Fs, chanNum);       
        end
    end

    if elecNum>0
        for i=1:elecNum
        varName=sprintf('Wav%s%s.htk',num2str(blockNum+1),num2str(i));
       chanNum=blockNum*64+i;
       fprintf('%i.\n',chanNum);
       data=squeeze(ecog.data(chanNum,:,:));
       writehtk (varName, data', Fs, chanNum);           
        end   

    end

cd(currentPath)
fprintf('%s saved\n',filename)