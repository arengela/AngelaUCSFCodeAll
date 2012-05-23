function pac=calculatePAC(complex_data,low_freq_band,high_freq_band)
%calculate PAC using preprocessed data

pac = zeros([size(complex_data, 1) size(low_freq_band, 2) size(high_freq_band, 2)]);

% Calculate PAC
for chanIt = 1:size(complex_data, 1)
    signal = complex_data(chanIt, :);
    
    for lowIt = low_freq_band
        %disp(['Channel ' num2str(chanIt) ' Low Frequency ' num2str(lowIt)]);
        
        % Extract low frequency analytic phase
        low_frequency_phase{chanIt}(lowIt,:)=angle(complex_data(chanIt,:,lowIt));
        
        for highIt = high_freq_band
            % Extract low frequency analytic phase of high frequency analytic amplitude
            high_frequency_amplitude{chanIt}(highIt,:)=abs(complex_data(chanIt,:,highIt));
            tmp=fft(high_frequency_amplitude{chanIt}(highIt,:));
            T=size(complex_data,2);
            [H,h]=makeHilbWindow(T,lowIt);
            high_frequency_phase{chanIt}(lowIt,:)=angle(ifft(tmp.*(H.*h),T));
            
            % Calculate PAC
            pac(chanIt, lowIt, highIt) =...
                abs(sum(exp(1i * (low_frequency_phase{chanIt}(lowIt,:) - high_frequency_phase{chanIt}(lowIt,:))), 'double'))...
                / length(high_frequency_phase{chanIt}(lowIt,:));
        end
    end
end