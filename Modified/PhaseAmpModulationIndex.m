for jj=1:573
    for c=1:size(ecogDS.data,1)
        x=ecogDS.data(c,:,jj);
        srate=400;    %% sampling rate used in this study, in Hz 
        numpoints=length(x);   %% number of sample points in raw signal 
        numsurrogate=200;   %% number of surrogate values to compare to actual value 
        minskip=srate;   %% time lag must be at least this big 
        maxskip=numpoints-srate; %% time lag must be smaller than this 
        skip=ceil(numpoints.*rand(numsurrogate*2,1)); 
        skip(find(skip>maxskip))=[]; 
        skip(find(skip<minskip))=[]; 
        skip=skip(1:numsurrogate,1); 
        surrogate_m=zeros(numsurrogate,1);  


        %% HG analytic amplitude time series, uses eegfilt.m from EEGLAB toolbox  
        %% (http://www.sccn.ucsd.edu/eeglab/) 
        amplitude=abs(hilbert(eegfilt(x,srate,80,150))); 
        %% theta analytic phase time series, uses EEGLAB toolbox 
        phase=angle(hilbert(eegfilt(x,srate,4,8))); 
        %% complex-valued composite signal 
        z=amplitude.*exp(i*phase); 
        %% mean of z over time, prenormalized value 
        m_raw=mean(z);  
        %% compute surrogate values 
           for s=1:numsurrogate 
              surrogate_amplitude=[amplitude(skip(s):end) amplitude(1:skip(s)-1)]; 
              surrogate_m(s)=abs(mean(surrogate_amplitude.*exp(i*phase))); 
              disp(numsurrogate-s) 
           end 
        %% fit gaussian to surrogate data, uses normfit.m from MATLAB Statistics toolbox 
        [surrogate_mean,surrogate_std]=normfit(surrogate_m); 
        %% normalize length using surrogate data (z-score) 
        m_norm_length=(abs(m_raw)-surrogate_mean)/surrogate_std; 
        m_norm_phase=angle(m_raw); 
        m_norm(c,jj)=m_norm_length*exp(i*m_norm_phase); 
        keep ecogDS m_norm
    end
end

