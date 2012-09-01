clear
clc
close all
% This code generates short-time PDC and DTF plots of a newborn EEG signal.
%
% Reference paper: A. Omidvarnia, M. Mesbah, J. M. O'Toole et al.,
% “Analysis of the time-varying cortical neural connectivity in the newborn EEG: A time-frequency approach,” 
% in Systems, Signal Processing and their Applications (WOSSPA), 2011 7th International Workshop on, 2011, pp. 179-182
%
% The paper is also available at: 
% http://qspace.qu.edu.qa/handle/10576/10737?show=full
%
% Written by: Amir Omidvarnia
%
% See also: BioSig toolbox (available at: http://biosig.sourceforge.net/),
% ARFIT toolbox (available at: http://www.gps.caltech.edu/~tapio/arfit/)

%% Multivariate system
load SampleEEG
% 20 seconds of the first five channels of an EEG dataset obtained from EEGLAB is loaded in the variable
% 'y' with the length of 2560 samples (Fs=128Hz). The complete size of
% the sample data file for the EEGLAB tutorial can be obtained from 
% http://sccn.ucsd.edu/eeglab/download/eeglab_data.set. 
% It is notable that the EEG signal may not be relevant to EEG connectivity analysis.
% It has only been used to show the usage of the following code.

Fs = 128; % Sampling rate
L = size(y,1); % Number of samples
CH = size(y,2); % Number of channels
N_freq = Fs; % Number of frequency points
Fmax = 30;      % Maximum frequency limit in the PDC and DTF plots

%% Time-invariant MVAR estimation -- to estimate the optimum moel order
[w, A_TI, C_TI, sbc, fpe, th] = arfit(y, 1, 20, 'sbc'); % ---> ARFIT toolbox
[tmp,p_opt] = min(sbc); % Optimum order for the MVAR model

[PDC_TI, DTF_TI] = PDC_DTF_matrix(A_TI,p_opt,Fs,Fmax,N_freq); % Compute time-varying PDC and DTF measures

%% Short-Time PDC and DTF of the original signal
win_len = Fs; % Window length
overlap = fix(win_len/4); % Overlap
start_point = 1;
s = 1;
Mode1 = 10; % ARFIT(10), Multichannel Yule-Walker(1) ---> BioSig toolbox 

while( start_point + win_len - 1 < L )
    seg = y(start_point:start_point+win_len-1,:);
    seg = seg.*repmat(hamming(length(seg)),1,CH);
    [A_ST,RCF,C_ST] = mvar(seg, p_opt, Mode1); % ---> BioSig toolbox
    [PDC_ST(:,:,:,s), DTF_ST(:,:,:,s)] = PDC_DTF_matrix(A_ST,p_opt,Fs,Fmax,N_freq);
    start_point = start_point + (win_len-overlap);
    s = s + 1;
end

%% Surrogate data method (shuffling over samples)
N_Surr = 20; % Number of surrogates
PDC_Surr = zeros([size(PDC_ST) N_Surr]); % CH x CH x N_freq x N_segments x N_surr
DTF_Surr = zeros([size(DTF_ST) N_Surr]); % CH x CH x N_freq x N_segments x N_surr

for surr = 1 : N_Surr
    
    clear A_tmp A_tmp_reshape y_surr
    for j = 1 : CH
        y_surr(:,j) = y(randperm(size(y,1)),j); % Randomize all columns of 'y'
    end

    start_point = 1; % Start point of each segment
    s = 0;
    while( start_point + win_len - 1 < L )
        s = s + 1; % Index of the segments
        seg = y_surr(start_point:start_point+win_len-1,:);
        seg = seg.*repmat(hamming(length(seg)),1,CH);
        [A_Surr,RCF,C_Surr] = mvar(seg, p_opt, Mode1); % ---> MVAR estimation: from BioSig toolbox
        [PDC_Surr(:,:,:,s,surr), DTF_Surr(:,:,:,s,surr)] = PDC_DTF_matrix(A_Surr,p_opt,Fs,Fmax,N_freq);
        start_point = start_point + (win_len-overlap);
    end

    disp(['The surrogate number ' num2str(surr) ' was finished.']) 
    
end

PDC_Surr2 = max(PDC_Surr,[],5); % Maximum values of the PDC measure at each time and each frequency over surrogates for all channels are extracted.
DTF_Surr2 = max(DTF_Surr,[],5); % Maximum values of the DTF measure at each time and each frequency over surrogates for all channels are extracted.

%% Plot --> Short-time PDC and DTF 
figure, % ---> DTF plot 
s1 = 0;
alpha_level = .01; % Alpha level (1 - confidence interval) ---> for hypothesis testing

for i = 1 : CH
    for j = 1 : CH
        s1 = s1 + 1;
        h = subplot(CH,CH,s1);
        set(h,'FontSize',13);
        
        DTF_tmp = abs(DTF_ST(i,j,:,:));
        DTF_Surr_tmp = abs(DTF_Surr2(i,j,:,:));
        mask = DTF_tmp>(1-alpha_level/2)*DTF_Surr_tmp;
        
        img = squeeze(DTF_tmp.*mask);
        imagesc([0 Fmax],[0 L/Fs],img')
        set(h,'YDir','normal')
        caxis([0 1])
        grid on
        if(i==CH && j==ceil(CH/2))
            xlabel('Frequency (Hz)','Fontsize',14)
        end
        if(i==ceil(CH/2) && j==1)
            ylabel('Time (sec)','Fontsize',14)
        end
        title(['Ch' num2str(i) ' <--- Ch ' num2str(j)],'Fontsize',14)
    end
end
h = colorbar;
set(h, 'Position', [.92 .11 .03 .8150],'FontSize',14)

figure, % ---> PDC plot 
s1 = 0;
clear mask
for i = 1 : CH
    for j = 1 : CH
        s1 = s1 + 1;
        h = subplot(CH,CH,s1);
        set(h,'FontSize',13);
        
        PDC_tmp = abs(PDC_ST(i,j,:,:));
        PDC_Surr_tmp = abs(PDC_Surr2(i,j,:,:));
        mask = PDC_tmp>(1-alpha_level/2)*PDC_Surr_tmp;
        
        img = reshape(PDC_tmp.*mask,N_freq,size(PDC_tmp,4));
        imagesc([0 Fmax],[0 L/Fs],img')
        set(h,'YDir','normal')
        caxis([0 1])
        grid on
        if(i==CH && j==ceil(CH/2))
            xlabel('Frequency (Hz)','Fontsize',14)
        end
        if(i==ceil(CH/2) && j==1)
            ylabel('Time (sec)','Fontsize',14)
        end
        title(['Ch' num2str(i) ' <--- Ch ' num2str(j)],'Fontsize',14)
    end
end
h = colorbar;
set(h, 'Position', [.92 .11 .03 .8150],'FontSize',14)
