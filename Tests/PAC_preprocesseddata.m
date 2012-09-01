function [pac,ave_amp_phase]=PAC_preprocesseddata(complex_data,low_freq_band,high_freq_band,makeDistribution)
%INPUT: 
%complex_data: C by T by F matrix, where C=channels, T=time (in samples),
%F= frequency band, and each element is a complex value
% low_freq_band and high_freq_band should hold only one value

%OUTPUT:
%pac: The Phase Amplitude Coupling Index; a C by #HF by #HL matrix, where
%C=channels, HF=high frequency band
%HL=low frequency band
%ave_amp_phase: a cell array, where each cell holds the average amplitude
%of the high frequency bands, aligned at each phase of the low frequency
%band

%ave_amp_phase are also plotted 
pac=[];
ave_amp_phase=[];
if nargin<4
    makeDistribution=0;
end

if ~exist('low_freq_band')
    low_freq_band=8; %pick low frequency band(s) (corresponds with the 40 band output of hilbert transform-- see center frequencies) This will determine the phase for pac
end

if ~exist('high_freq_band')
    high_freq_band=35;  %pick high frequency band(s); this will be the amplitude for pac
end

T=size(complex_data,2);

%calculates the phase amplitude coupling index 
pac=calculatePAC(complex_data,low_freq_band,high_freq_band,makeDistribution);

%calculates average amplitude of high freq band at each phase of
%low_freq_band (from -pi to pi)
ave_amp_phase=calcAmpPhase(complex_data,low_freq_band,high_freq_band);

%plot ave_amp_phase in cartesian and polar coordinates
%plotAmpPhasePolar256(ave_amp_phase)
%plotAmpPhaseCart256(ave_amp_phase)



function [H,h]=makeHilbWindow(T,f)
%Creates gaussian window for hilbert transform
a=[log10(.39); .5];
frange=[4 200];
Fs=400;
f0=0.018;
octspace=1/7;
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

cfs(end)=[];
cfs=cfs(find(cfs>=minf & cfs<=maxf));
npbs=length(cfs);
sigma_fs=(10.^([ones(length(cfs),1) log10(cfs')]*a))';
badfs=[find(cfs>340 & cfs<480) find(cfs>720 & cfs<890)];
sigma_fs=sigma_fs(setdiff(1:npbs,badfs));
cfs_all=cfs;
cfs=cfs(setdiff(1:npbs,badfs));
npbs=length(cfs);
sds=sigma_fs.*sqrt(2);



freqs=(0:floor(T/2)).*(Fs/T); nfreqs=length(freqs);
h = zeros(1,T);
if 2*fix(T/2)==T %if T is even
    h([1 T/2+1]) = 1;
    h(2:T/2) = 2;
else h(1) = 1; h(2:(T+1)/2) = 2;
end

H = zeros(1,T);
k = freqs-cfs(f);
H(1:nfreqs) = exp((-0.5).*((k./sds(f)).^2));
H(nfreqs+1:end)=fliplr(H(2:ceil(T/2)));
H(1)=0;





%%
function pac=calculatePAC(complex_data,low_freq_band,high_freq_band,makeDistribution)
%calculate PAC using preprocessed data
numsurrogate=200;  %% number of surrogate values to compare to actual value 

pac = zeros([size(complex_data, 1) size(low_freq_band, 2) size(high_freq_band, 2)]);
% Calculate PAC
for chanIt = 1:size(complex_data, 1)
    signal = complex_data(chanIt, :);
    
    for lowIt =  1:length(low_freq_band)
        %disp(['Channel ' num2str(chanIt) ' Low Frequency ' num2str(lowIt)]);
        
        % Extract low frequency analytic phase
        low_frequency_phase{chanIt}(lowIt,:)=angle(complex_data(chanIt,:,low_freq_band(lowIt)));
        
        for highIt =  1:length(high_freq_band)
            % Extract low frequency analytic phase of high frequency analytic amplitude
            amplitude=abs(complex_data(chanIt,:,high_freq_band(highIt)));
            high_frequency_amplitude{chanIt}(highIt,:)=abs(complex_data(chanIt,:,high_freq_band(highIt)));
            tmp=fft(high_frequency_amplitude{chanIt}(highIt,:));
            T=size(complex_data,2);
            [H,h]=makeHilbWindow(T,low_freq_band(lowIt));
            high_frequency_phase{chanIt}(lowIt,:)=angle(ifft(tmp.*(H.*h),T));
            
            % Calculate PAC
            pac(chanIt, lowIt, highIt) =...
                abs(sum(exp(1i * (low_frequency_phase{chanIt}(lowIt,:) - high_frequency_phase{chanIt}(lowIt,:))), 'double'))...
                / length(high_frequency_phase{chanIt}(lowIt,:));
            
            
            %Make distribution
            if makeDistribution==1
                pacDist=zeros([size(complex_data, 1) size(low_freq_band, 2) size(high_freq_band, 2)],numsurrogate);
                srate=400;    %% sampling rate used in this study, in Hz 
                numpoints=size(complex_data,2);   %% number of sample points in raw signal 
                numsurrogate=200;   %% number of surrogate values to compare to actual value 
                minskip=srate;   %% time lag must be at least this big 
                maxskip=numpoints-srate; %% time lag must be smaller than this 
                skip=ceil(numpoints.*rand(numsurrogate*2,1)); 
                skip(find(skip>maxskip))=[]; 
                skip(find(skip<minskip))=[]; 
                skip=skip(1:numsurrogate,1); 
                surrogate_m=zeros(numsurrogate,1);  
                for s=1:numsurrogate 
                  surrogate_phase=[high_frequency_phase{chanIt}(lowIt,skip(s):end) high_frequency_phase{chanIt}(lowIt,1:skip(s)-1)]; 
                  pacDist(chanIt, lowIt, highIt,s) =...
                abs(sum(exp(1i * (low_frequency_phase{chanIt}(lowIt,:) - surrogate_phase)), 'double'))...
                / length(high_frequency_phase{chanIt}(lowIt,:));
                  %surrogate_m(s)=abs(mean(surrogate_amplitude.*exp(i*phase))); 
                  %disp(numsurrogate-s) 
                end
            end
            
        end
    end
end


%%
function ave_amp_phase=calcAmpPhase(complex_data,low_freq_band,high_freq_band)%%
%get AA of each frequency band at phase of selected low frequency
%band using Hilbert transformed  preprocessed data

p=linspace(-pi,pi,100)

for chanIt = 1:size(complex_data, 1)
    signal = complex_data(chanIt, :,:);
    for lowIt = 1:length(low_freq_band)
        % Extract low frequency analytic phase
        low_frequency_phase{chanIt}(lowIt,:)=angle(complex_data(chanIt,:,low_freq_band(lowIt)));
        
        %use hilbert
        for highIt = 1:length(high_freq_band)
            % Extract high frequency analytic amplitude
            high_frequency_amplitude_z{chanIt}(highIt,:)=zscore(abs(complex_data(chanIt,:,high_freq_band(highIt))));
            
        end
    end
    for j=1:size(high_frequency_amplitude_z{chanIt},1);
        for i=1:length(p)-1
            %get analytic amplitude of high frequency signal at every phase
            %of low frequency
            idx{i}=find(low_frequency_phase{chanIt}(lowIt,:)>p(i) & low_frequency_phase{chanIt}(lowIt,:)<p(i+1));
            ave_amp_phase(chanIt,j,i)=mean(high_frequency_amplitude_z{chanIt}(j,idx{i}));
        end
    end
end



%%
function plotAmpPhaseCart256(ave)
%plot average AA at low frequency phases for all channels (currently works
%for 256 channels)
%x-axis is [-pi to pi]
%y-axis is frequency band [1 to 40]
%color is zscore of AA power
figure
for chanIt=1:256
    %plot amplitude of high frequency band by phase
    m=floor(chanIt/16);
    n=rem(chanIt,16);
    
    if n==0
        n=16;
        m=m-1;
    end
    
    po(1)=6*(n-1)/100+.03;
    po(2)=6.2*(15-m)/100+0.01;
    
    po(3)=.055;
    po(4)=.055;
    h=subplot('Position',po);
    
    pcolor(ave{chanIt});shading interp
    text(1,0,num2str(chanIt))
    set(gca,'xtick',[],'ytick',[])
end
%%

function plotAmpPhasePolar256(ave)
%%plot average AA at low frequency phases for all channels in radial graph (currently works
%for 256 channels)
%in polar coordinates:
%theta-axis is [-pi pi]
%r-axis is frequency band [1 40]
%color is zscore of AA power
figure
for chanIt=1:256
    m=floor(chanIt/16);
    n=rem(chanIt,16);
    
    if n==0
        n=16;
        m=m-1;
    end
    
    po(1)=6*(n-1)/100+.03;
    po(2)=6.2*(15-m)/100+0.01;
    
    po(3)=.055;
    po(4)=.055;
    h=subplot('Position',po);
    
    
    [X,Y]=cylinder(1:size(ave{chanIt},1),98);
    
    surf(X,Y,ave{chanIt});
    view(2)
    shading interp

end