clear
clc
close all
% This code generates Adaptive AR - based PDC and DTF plots of a simulated data.
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

%% Multichannel simulated time-varying model 
% Reference of the simulated model: "Comparison of linear signal processing
% techniques to infer directed interactions in multivariate neural systems" by: M. Winterhalder, B. Schelter, 
% W. Hesse, K. Schwab, L. Leistritz, D. Klan, R. Bauer, J. Timmer, H. Witte Signal Processing, Vol. 85, No. 11. (November 2005)
%
% Example 4

y = zeros(2000,3);
L = size(y,1);    % Number of samples
CH = size(y,2);   % Number of channels
c21 = zeros(1,L); % First time-varying parameter
c23 = zeros(1,L); % Second time-varying parameter
c12 = zeros(1,L); % Third time-varying parameter
N_freq = 50;      % Number of frequency bins
Fs = 200;         % Sampling frequency, necessary for the 'PDC_DTF_matrix' function. 
                  % It doesn't matter for the simulated model what the value of Fs is.
Fmax = Fs/2;      % Maximum frequency limit in the PDC and DTF plots

for n = 3 : L
    c21(n) = 0.2;

    if(n<=L/2)
        c12(n) = 0.5*(n/(L/2));
    else
        c12(n) = 0.5*(L-n)/(L/2);
    end
    
    if(n<=.7*L)
        c23(n) = 0.4;
    else
        c23(n) = 0;
    end
    
    y(n,1) = 0.5*y(n-1,1) - 0.7*y(n-2,1) + c12(n)*y(n-1,2) + randn;
    y(n,2) = 0.7*y(n-1,2) - 0.5*y(n-2,2) + c21(n)*y(n-1,1) + c23(n)*y(n-1,3) + randn;
    y(n,3) = 0.8*y(n-1,3) + randn;
    
end

%% Time-invariant MVAR estimation -- to estimate the optimum model order
[w, A_TI, C, sbc, fpe, th] = arfit(y, 1, 20, 'sbc'); % ---> ARFIT toolbox
[tmp,p_opt] = min(sbc); % Optimum order for the MVAR model using the SBC approach

%% Adaptine PDC and DTF of the original signal
UC = .0001; % Update Coefficient for the adaptive AR modelling
Down_Sample = 10; % Downsampling rate 

%%%%%% AAR estimation from the BioSig toolbox
Mode2 = 2; % Update mode of the process noise covariance matrix Q
[A_TV,e,Kalman,C_TV] = mvaar(y,p_opt,UC,Mode2); % Multivariate Adaptive AR estimation using Kalman filter --> BioSig toolbox

A_TV_reshape = reshape(A_TV', CH*p_opt, CH, size(A_TV,1)); % (CH*p x CH x T)
for i = 1 : size(A_TV_reshape,3)
    A_TV3(:,:,i) = A_TV_reshape(:,:,i)';
end

A_TV3 = A_TV3(:,:,1:Down_Sample:end); % Down sampling in the AR coefficients
T = size(A_TV3,3); % Number of time points after down sampling

[PDC_TV, DTF_TV] = PDC_DTF_matrix(A_TV3,p_opt,Fs,Fmax,N_freq); % Time-varying PDC and DTF

%% Surrogate data method (shuffling over samples)
N_Surr = 20; % Number of surrogates
PDC_Surr = zeros([size(PDC_TV) N_Surr]); % CH x CH x N_freq x N_segments x N_surr
DTF_Surr = zeros([size(DTF_TV) N_Surr]); % CH x CH x N_freq x N_segments x N_surr

for surr = 1 : N_Surr
    
    clear A_tmp A_tmp_reshape y_surr
    for j = 1 : CH
        y_surr(:,j) = y(randperm(size(y,1)),j); % Randomize all columns of 'y'
    end

    [A_tmp,e,Kalman,C_tmp2] = mvaar(y_surr,p_opt,UC,Mode2);
    A_tmp = A_tmp(1:Down_Sample:end,:)'; % Down sampled time-varying MVAR coefficients
    A_tmp_reshape = reshape(A_tmp, CH*p_opt, CH, size(A_tmp,2)); % (CH*p x CH x T)
    for i = 1 : size(A_tmp_reshape,3)
        A_tmp2(:,:,i) = A_tmp_reshape(:,:,i)';
    end

    [PDC_Surr(:,:,:,:,surr), DTF_Surr(:,:,:,:,surr)] = PDC_DTF_matrix(A_tmp2,p_opt,Fs,Fmax,N_freq);
    
    disp(['The surrogate number ' num2str(surr) ' was finished.'])

end

PDC_Surr2 = max(PDC_Surr,[],5); % Maximum values of the PDC measure at each time and each frequency over surrogates for all channels are extracted.
DTF_Surr2 = max(DTF_Surr,[],5); % Maximum values of the DTF measure at each time and each frequency over surrogates for all channels are extracted.

%% Plot - Adaptive PDC and DTF (time-varying)
figure, % ---> DTF plot 
s1 = 0;
alpha_level = .01; % Alpha level (1 - confidence interval) ---> for hypothesis testing

for i = 1 : CH
    for j = 1 : CH
        s1 = s1 + 1;
        h = subplot(CH,CH,s1);
        set(h,'FontSize',13);
        
        DTF_tmp = abs(DTF_TV(i,j,:,:));
        DTF_Surr_tmp = abs(DTF_Surr2(i,j,:,:));
        mask = DTF_tmp>(1-alpha_level/2)*DTF_Surr_tmp;
        
        img = squeeze(DTF_tmp.*mask);
        imagesc([0 .5],[0 L],img') % On the frequency axis, 0.5 is equivalent with the Nyquist rate (Fs/2).
        set(h,'YDir','normal')
        caxis([0 1])
        grid on
        
        if(i==CH && j==ceil(CH/2))
            xlabel('Normalized Frequency','Fontsize',14)
        end
        if(i==ceil(CH/2) && j==1)
            ylabel('Time (sample)','Fontsize',14)
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
        
        PDC_tmp = abs(PDC_TV(i,j,:,:));
        PDC_Surr_tmp = abs(PDC_Surr2(i,j,:,:));
        mask = PDC_tmp>(1-alpha_level/2)*PDC_Surr_tmp;
        
        img = squeeze(PDC_tmp.*mask);
        imagesc([0 .5],[0 L],img') % On the frequency axis, 0.5 is equivalent with the Nyquist rate (Fs/2).
        set(h,'YDir','normal')
        caxis([0 1])
        grid on
        
        if(i==CH && j==ceil(CH/2))
            xlabel('Normalized Frequency','Fontsize',14)
        end
        if(i==ceil(CH/2) && j==1)
            ylabel('Time (sample)','Fontsize',14)
        end
        title(['Ch' num2str(i) ' <--- Ch ' num2str(j)],'Fontsize',14)
    end
end
h = colorbar;
set(h, 'Position', [.92 .11 .03 .8150],'FontSize',14)
