function ave_amp_phase=calcAmpPhase(complex_data,low_freq_band,high_freq_band)%%
%get AA of each frequency band at phase of selected low frequency
%band using Hilbert transformed  preprocessed data

p=linspace(-pi,pi,100)

for chanIt = 1:size(complex_data, 1)
    signal = complex_data(chanIt, :);
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
            ave_amp_phase{chanIt}(j,i)=mean(high_frequency_amplitude_z{chanIt}(j,idx{i}));
        end
    end
end
