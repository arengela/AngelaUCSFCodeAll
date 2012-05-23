[data, sampFreq, chanNum] = readhtk ( 'Wav11.htk',[30*1000 50*1000] );
%[data, sampFreq, chanNum] = readhtk ( 'Wav11.htk');
ecog.a=zeros(256,length(data));
for nBlocks=1:4
    for k=1:64
        varName1=['Wav' num2str(nBlocks) num2str(k)]
        chanNum
        [data, sampFreq, tmp, chanNum] =readhtk (sprintf('%s.htk',varName1),[30*1000 50*1000] );
        %[data, sampFreq, tmp, chanNum] =readhtk (sprintf('%s.htk',varName1));
        %ecog.data((nBlocks-1)*64+k,:)=data; 
        ecog.a(chanNum,:)=data;
    end
end

figure
for i=1:256
    plot(ecog.c(i,:))
    title(num2str(i))
    hold on
    plot(size(ecog.a(1,:),2),0,'r*')
    x=input('next')
    hold off
end