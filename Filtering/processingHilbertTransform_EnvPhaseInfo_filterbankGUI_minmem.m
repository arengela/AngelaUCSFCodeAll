function processingHilbertTransform_EnvPhaseInfo_filterbankGUI_minmem(ecog,Fs,freqRange)
%{
PURPOSE: Perform Hilbert transform 

INPUTS: ecog data structure
        Sampling frequency
        Optional: frequency range for window (2 element array with low frequency first)-- if no input, go to default range

OUTPUT: envelope and phase of analytic signal
%}

%********CHANGE, allow for multiband freqRange*************
%{
if nargin==3
    freqH=freqRange(2);
    freqL=freqRange(1);
else
    freqH=150;
    freqL=70;
end

max_freq=Fs/2;
%}

%%%%%%%%%%%%%%%CREATE FILTER BANK
%a=[log10(2.2); 0]; 
%a=[log10(.07); 1]; 
%a=[log10(.14); .8]; 
a=[log10(.39); .5];


frange=freqRange;
f0=0.018; 
octspace=1/7;%usually 1/7
%octspace=1;
minf=frange(1); 
maxf=frange(2); 
maxfo=log2(maxf/f0);
cfs=f0; 
sigma_f=10^(a(1)+a(2)*log10(cfs(end)));

while log2(cfs(end)/f0)<maxfo
    cfo=log2(cfs(end)/f0); 
    cfo=cfo+octspace;
    
    if cfs(end)<4, 
        cfs=[cfs cfs(end)+sigma_f]; %switches to log spacing at 4 Hz
    else cfs=[cfs f0*(2^(cfo))]; 
    end
    
    sigma_f=10^(a(1)+a(2)*log10(cfs(end)));
end
%cfs(end)=[];
cfs=cfs(find(cfs>=minf & cfs<=maxf)); 
npbs=length(cfs);
sigma_fs=(10.^([ones(length(cfs),1) log10(cfs')]*a))';
badfs=[find(cfs>340 & cfs<480) find(cfs>720 & cfs<890)];
sigma_fs=sigma_fs(setdiff(1:npbs,badfs)); 
cfs_all=cfs; 
cfs=cfs(setdiff(1:npbs,badfs)); 
npbs=length(cfs);
sds=sigma_fs.*sqrt(2);

 T=size(ecog.data,2);
    freqs=(0:floor(T/2)).*(Fs/T); nfreqs=length(freqs);
    h = zeros(1,T);
    if 2*fix(T/2)==T %if T is even
        h([1 T/2+1]) = 1; 
        h(2:T/2) = 2;
    else h(1) = 1; h(2:(T+1)/2) = 2;
    end




%CHANGE: vectorize across channels, take out loop*******************
%x=fft(ecog.data,nfft,2);
filteredData.data=zeros(size(ecog.data,1),T,npbs);
%phaseInfo.data=zeros(size(ecog.data,1),T,npbs);


for c=1:size(ecog.data,1)
            adat=fft(ecog.data(c,:),T);  
            tic
            for f=1:npbs
                H = zeros(1,T); 
                k = freqs-cfs(f);
                H(1:nfreqs) = exp((-0.5).*((k./sds(f)).^2));
                H(nfreqs+1:end)=fliplr(H(2:ceil(T/2))); 
                H(1)=0;
                %filteredData.data(c,:,f)=abs(ifft(adat(c,:).*(H.*h),T));
                hilbdata=ifft(adat(end,:).*(H.*h),T);
                filteredData.data(c,:,f)=abs(hilbdata);
                %phaseInfo.data(c,:,f)=angle(hilbdata);                
            end  
            c
            t(c)=toc
end

%{
for c=1:size(ecog.data,1)
            adat=fft(ecog.data(c,:),T);           
            for f=1:npbs
                H = zeros(1,T); 
                k = freqs-cfs(f);
                H(1:nfreqs) = exp((-0.5).*((k./sds(f)).^2));
                H(nfreqs+1:end)=fliplr(H(2:ceil(T/2))); 
                H(1)=0;
                hilbdata=ifft(adat(end,:).*(H.*h),T);
                filteredData.data(c,:,f)=abs(hilbdata);
                %phaseInfo.data(c,:,f)=angle(hilbdata);                
            end           
end
%}

%filteredData.timebase=ecog.timebase;
%filteredData.sampDur=ecog.sampDur;
filteredData.sampFreq=ecog.sampFreq;
phaseInfo.sampFreq=ecog.sampFreq;
%filteredData.baselineDur=ecog.baselineDur;
%filteredData.nSamp=ecog.nSamp;
%filteredData.nBaselineSamp=ecog.nBaselineSamp;
%filteredData.selectedChannels=ecog.selectedChannels;
%filteredData.badChannels=ecog.badChannels;
%filteredData.excludeBad=ecog.excludeBad;
%filteredData.channel2GridMatrixIdx=ecog.channel2GridMatrixIdx;
%filteredData.baselineSamps=ecog.baselineSamps;



%%

%SAVE ANALYTIC AMPLITUDE FROM 4 TO 200
currentPath=pwd;

%Save Preprocessed files with all bands separate
mkdir('HilbAA_4to200')
cd('HilbAA_4to200')
Fs=ecog.sampFreq;

fid = fopen('processing_params.txt', 'w');
fprintf(fid, 'Hilbert Transform');
fprintf(fid, '\nCenter frequencies(Hz):');
fprintf(fid, '\n %6.6f',cfs);
fprintf(fid, '\n Sigma_fs:');
fprintf(fid, '\n %6.6f',sigma_fs);
fprintf(fid, '\n\nFrequency bands separate');
fclose(fid);

for nBlocks=1:4
    for k=1:64
       varName=sprintf('Wav%s%s.htk',num2str(nBlocks),num2str(k))
       chanNum=(nBlocks-1)*64+k
       %data=mean(handles.ecogFiltered.data((nBlocks-1)*64+k,:,:),3);
       data=squeeze(filteredData.data((nBlocks-1)*64+k,:,:))';
       writehtk (varName, data, Fs, chanNum);        
    end
end

cd(currentPath)

clear filteredData;

%%

phaseInfo.data=zeros(size(ecog.data,1),T,npbs);
for c=1:size(ecog.data,1)
            adat=fft(ecog.data(c,:),T);  
            tic
            for f=1:npbs
                H = zeros(1,T); 
                k = freqs-cfs(f);
                H(1:nfreqs) = exp((-0.5).*((k./sds(f)).^2));
                H(nfreqs+1:end)=fliplr(H(2:ceil(T/2))); 
                H(1)=0;
                %filteredData.data(c,:,f)=abs(ifft(adat(c,:).*(H.*h),T));
                hilbdata=ifft(adat(end,:).*(H.*h),T);
                %filteredData.data(c,:,f)=abs(hilbdata);
                phaseInfo.data(c,:,f)=angle(hilbdata);                
            end  
            c
            t(c)=toc
end

%%

%Save Phase for 4 to 200 Hz
currentPath=pwd;

%Save Preprocessed files with all bands separate
mkdir('HilbPhase_4to200')
cd('HilbPhase_4to200')
Fs=ecog.sampFreq;

fid = fopen('processing_params.txt', 'w');
fprintf(fid, 'Hilbert Transform');
fprintf(fid, '\nCenter frequencies(Hz):');
fprintf(fid, '\n %6.6f',cfs);
fprintf(fid, '\n Sigma_fs:');
fprintf(fid, '\n %6.6f',sigma_fs);
fprintf(fid, '\n\nFrequency bands separate');
fclose(fid);

for nBlocks=1:4
    for k=1:64
       varName=sprintf('Wav%s%s.htk',num2str(nBlocks),num2str(k))
       chanNum=(nBlocks-1)*64+k
       %data=mean(handles.ecogFiltered.data((nBlocks-1)*64+k,:,:),3);
       data=squeeze(phaseInfo.data((nBlocks-1)*64+k,:,:))';
       writehtk (varName, data, Fs, chanNum);        
    end
end


cd(currentPath)
