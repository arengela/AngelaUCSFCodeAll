function filenames=getFileNames(namingConv,channels)

switch namingConv
    case 'blocks'
        for cidx=1:length(channels)
            c=channels(cidx);
            block=ceil(c/64);
            k=rem(c,64);
            if k==0
                k=64;
            end
            filenames{cidx}=['Wav' num2str(block) num2str(k)];
        end
    case 'continuous'
         for cidx=1:length(channels)
            c=channels(cidx);
            filenames{cidx}=['Wave' num2str(c)];
         end
    case 'eeg'
        for cidx=1:length(channels)
            c=channels(cidx);
            filenames{cidx}=['eeg' num2str(c)];
        end
end    