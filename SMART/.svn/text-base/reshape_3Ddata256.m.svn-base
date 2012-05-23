function to_plot = reshape_3Ddata256(to_reshape, window_around_event,...
    num_freq_bands)
%to_reshape = chan x freq x timepts
to_plot = zeros(num_freq_bands*16, 16*(window_around_event+1));

beginning = 0;
for i = 0:15  %ASSUMES 256 CHANNELS
    last =  beginning+16*(window_around_event+1);
    data = to_reshape(i*16+1:i*16+16,:,:);
    to_plot(i*num_freq_bands+1:i*num_freq_bands+num_freq_bands,:) = ...
        reshape(shiftdim(data,1),num_freq_bands, 16*(window_around_event+1));
    beginning = last;
    %Grab every eight channels and form 16 x 16 square
end
