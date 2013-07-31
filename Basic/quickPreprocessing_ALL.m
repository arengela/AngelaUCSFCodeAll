function [ecog_out, per_out]=quickPreprocessing_ALL(pathName,outFlag,input,ref,timeInt,channels,CARflag,sampFreq,freqRange,namingConv)
%Preprocesses ecog block. 
%Block must have folders "RawHTK","Artifacts"
%There must be appropriate files in "Artifacts"
%outFlag= 1: making hilbert 4-200 Hz all channels at once and saving them
%      2: for making hilbert 4-200 Hz one channel at a time and saving them
%      one channel at a time
%      3: making and saving only high gamma
%      4. Save AfterCARandNotch, and stop there
%      5. Save broad filter HG
%      6. STFT output all freq bands
%      7. Save downsampled, and stop there
%      8. bandpassed low and high gamma
%      10. No CAR
%perFlag= 1: Making and saving figures for periodogram and spectrograms
%         2: Making and saving variables for periodogram and spectrograms
%         0: No periodograms or spectrograms
%input= 1: RawHTK
%       2: downsampled Human data
%       3: Raw rat ecog
%       4: Run broadband linux hilbert
%       5: Downsampled Rat data 
%ref=   reference electrode # (optional)
%timeInt= time in ms to load from RawHTK (optional)
%channelsTot= total number of channels
%CAR flag= #ofChannels: use entire grid for CAR
%          16: CAR in blocks of 16
%          1:  Use reference Channel
%          0:  No CAR

[a,b,c]=fileparts(pathName);
blockName=b;
cd(pathName)
fprintf('File opened: %s\n',pathName)
fprintf('Block: %s',blockName)

ecog_out=[];
per_out=[];

%%
%Set default Values
if ~exist('sampFreq') || isempty(sampFreq)
    sampFreq=400;
end

if ~exist('freqRange') || isempty(freqRange)
    freqRange=[70 150];
end

%DEFAULT VALUES
if ~exist('timeInt')
    timeInt=[];
end


if ~exist('channels') || isempty(channels)
    cd('RawHTK')
    channelsTot=length(ls)-2;   
    channels=1:channelsTot;
    cd ..
end

if ~exist('ref')
    ref=[];
end

%%LOAD MATLAB VARIABLE
switch input
    case 1 %Human ecog (rawHTK)  
        filenames=getFileNames(namingConv,channels);
        ecog=loadHTKFile_Name([pathName filesep 'RawHTK'],filenames,timeInt);
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);    
        ecog=downsampleEcog(ecog,sampFreq);
    case 2 %Downsampled ecog
        filenames=getFileNames(namingConv);
         ecog=loadHTKtoEcog_CT(sprintf('%s/%s',pathName,'ecogDS'),channelsTot,timeInt);
    case 3 %Rat ecog
        filenames=getFileNames(namingConv);
        ecog=loadHTKtoEcog_rat_CT(sprintf('%s/%s',pathName,'RawHTK'),channelsTot,timeInt,'rat');
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
        ecog=downsampleEcog(ecog,sampFreq,ecog.sampFreq);
    case 5 %Downsampled Rat ecog
        filenames=getFileNames(namingConv)
        ecog=loadHTKtoEcog_rat_CT(sprintf('%s/%s',pathName,'RawHTK'),channelsTot,timeInt,'rat'); 
end
ecog.selectedChannels=1:size(ecog.data,1);
ecog.sampDur=1000/sampFreq;
ecog.sampFreq=sampFreq;
ecog.timebase=[0:(size(ecog.data,2)-1)]*ecog.sampDur;
badChannels=[];
badTimeSegments=[];
ecog.badChannels=[];
ecog.badTimeSegments=[];


%%
%LOAD ARTIFACT FILES
try
    cd(sprintf('%s/Artifacts',pathName))
    load 'badTimeSegments.mat'
    fid = fopen('badChannels.txt');
    tmp = fscanf(fid, '%d');
    badChannels=tmp';
    fclose(fid);
    cd(pathName)
end
    
%%
%SUBTRACT CAR
fprintf('\n1 Hz Filter begin...')
%filtered=ecogFilterTemporal(ecog,[1 200],3);
%filtered.sampFreq=ecog.sampFreq;
filtered=ecog;
fprintf('1 Hz Filter done...\n')
    
switch CARflag
    case 'all' %CAR over all channels
        CAR=mean(filtered.data(setdiff(1:size(filtered.data,1),badChannels),:));
        ecog.data=ecog.data-repmat(CAR,[size(filtered.data,1),1]);
    case 16 %CAR in 16 channel blocks
        ecog=subtractCAR_16ChanBlocks(filtered,badChannels,ecog);
    case 1 %Use 1 channel (specified with ref flag) for CAR
        if ~isempty(ref)
            CAR=repmat(filtered.data(ref,:),[channelsTot,1]);
            ecog.data=ecog.data-CAR;
        else
            printf('Error: No ref channel specified');
            return
        end
end
clear filtered;        

%%
%NOTCH FILTER at 60, 120, 180 Hz
switch outFlag
    case {6,7}
        %No Notch Filter
    otherwise    
        ecog=applyLineNoiseNotch_60HzHarmonics(ecog,sampFreq);
end

%%
switch outFlag
    case {4,7} %Save only AfterCARandNotch
        if outFlag==4
            newfolder='AfterCARandNotch';
        elseif outFlag==7
            newfolder='Downsampled400';
        end
        mkdir([pathName filesep newfolder])
        cd([pathName filesep newfolder])
        Fs=sampFreq;
        blockNum=floor(channelsTot/64);
        elecNum=rem(channelsTot,64);
        fprintf('Saving:\n')
        for cidx=1:length(channels)
            chanNum=channels(cidx);
            fprintf('%i\n.',chanNum)
            data=(ecog.data(cidx,:));
            writehtk ([filenames{cidx} '.htk'], data, Fs, chanNum);
        end
        cd(pathName)  
        
    case 1  %Calculate all Hilbert all channels at once
        [ecog,cfs,sigma_fs]=processingHilbertTransform_filterbankGUI_complex_mem(ecog, sampFreq, freqRange);
        
        %Save Real and Imag all bands
        newFolder1=([pathName filesep 'HilbImag_' int2str(freqRange(1)) 'to' int2str(freqRange(2)) '_' int2str(length(cfs)) 'band'])
        newFolder2=([pathName filesep 'HilbReal_' int2str(freqRange(1)) 'to' int2str(freqRange(2)) '_' int2str(length(cfs)) 'band'])
        mkdir(newFolder1)
        mkdir(newFolder2)
        
        for cidx=1:length(channels)
            varName=[filenames{cidx} '.htk'];
            chanNum=channels(cidx);
            fprintf('%i',chanNum)
            data1=imag(squeeze(ecog.data(cidx,:,:)))';
            cd(newFolder1)
            writehtk (varName, data1, sampFreq, chanNum);
            clear data1
            cd(newFolder2)
            data2=real(squeeze(ecog.data(cidx,:,:)))';
            writehtk (varName, data2, sampFreq, chanNum);
            clear data2
            
            x=find(cfs>=70&cfs<=150);
            newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(70),int2str(150),int2str(length(x)));
            newPath=sprintf('%s/%s',pathName,newFolder);
            if cidx==1
                mkdir(newPath);
            end
            cd(newPath)
            envData=abs(ecog.data(cidx,:,:));
            data3=squeeze(envData(:,:,x));
            writehtk (varName, data3', sampFreq, chanNum);
            cd ..
            clear hilbdata
            clear data3
            clear envData
        end
        fprintf('Done!')    
        
    case 2    %Calculate all bands one channel at a time
  
        
        fprintf('Hilbert:')
        Fs=sampFreq;
        for cidx=1:length(channels)
            varName=[filenames{cidx} '.htk'];
            chanNum=channels(cidx);
            fprintf('%i',chanNum)
            [cfs,sigma_fs,hilbdata]=processingHilbertTransform_filterbankGUI_onechan(ecog.data(cidx,:),Fs,freqRange);
            
            if cidx==1
                newFolder1=([pathName filesep 'HilbImag_' int2str(freqRange(1)) 'to' int2str(freqRange(2)) '_' int2str(length(cfs)) 'band'])
                newFolder2=([pathName filesep 'HilbReal_' int2str(freqRange(1)) 'to' int2str(freqRange(2)) '_' int2str(length(cfs)) 'band'])
                if sampFreq~=400
                    newFolder1=[newFolder1 '_' int2str(sampFreq) 'Hz'];
                    newFolder2=[newFolder2 '_' int2str(sampFreq) 'Hz'];
                end
                mkdir(newFolder1)
                mkdir(newFolder2)
            end
            data1=imag(squeeze(hilbdata))';
            cd(newFolder1)
            writehtk (varName, data1, sampFreq, chanNum);
            clear data1
            cd(newFolder2)
            data2=real(squeeze(hilbdata))';
            writehtk (varName, data2, sampFreq, chanNum);
            clear data2
            
            x=find(cfs>=70&cfs<=150);
            newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(70),int2str(150),int2str(length(x)));
            newPath=sprintf('%s/%s',pathName,newFolder);
            if cidx==1
                mkdir(newPath);
            end
            cd(newPath)
            envData=abs(hilbdata(1,:,:));
            data3=squeeze(envData(:,:,x));
            writehtk (varName, data3', Fs, chanNum);
            cd ..
            clear hilbdata
            clear data3
            clear envData
        end
    case 3  %Calculate and save only HG
        [ecog,cfs,sigma_fs]=processingHilbertTransform_filterbankGUI(ecog, sampFreq, freqRange);
        currentPath=pwd;
        x=find(cfs>=freqRange(1)&cfs<=freqRange(2));
        newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(freqRange(1)),int2str(freqRange(2)),int2str(length(x)));
        newPath=sprintf('%s/%s',pathName,newFolder);
        mkdir(newPath)
        cd(newPath)
        for cidx=1:length(channels)
            chanNum=channels(cidx);
            fprintf('%i\n.',chanNum)
            data=squeeze((ecog.data(cidx,:,:)))';
            writehtk ([filenames{cidx} '.htk'], data, sampFreq, chanNum);
        end
    case 6 % STFT output
        for cidx=1:size(ecog.data,1)
            c=channels(cidx);
            [YY,tt,ff]=stft_hann(ecog.data(cidx,:)',sampFreq);            
            if cidx==1
                newFolder1=([pathName filesep 'STFTImag_0to' int2str(sampFreq/2) '_' int2str(size(YY,1)) 'band']);
                newFolder2=([pathName filesep 'STFTReal_0to' int2str(sampFreq/2) '_' int2str(size(YY,1)) 'band']);
                mkdir(newFolder1);
                mkdir(newFolder2);
            end
            YY=flipud(YY);
            cd(newFolder1)
            writehtk([filenames{cidx} '.htk'],imag(YY),sampFreq,c);
            cd(newFolder2)
            writehtk([filenames{cidx} '.htk'],real(YY),sampFreq,c);
        end
    case 8 %bandpassed low and high gamma
        newFolder1=([pathName filesep 'BandPass_30to55_1band']);
        newFolder2=([pathName filesep 'BandPass_70to300_1band']);
        if sampFreq~=400
            newFolder1=[newFolder1 '_' int2str(sampFreq) 'Hz'];
            newFolder2=[newFolder2 '_' int2str(sampFreq) 'Hz'];
        end        
        mkdir(newFolder1);
        mkdir(newFolder2);
        for cidx=1:size(ecog.data,1)
            c=channels(cidx);
            %Low Gamma Bandpass
            dat=ecog.data(cidx,:);
            ord=7; %make this 5 for faster
            [b,a]=butter(ord,2*30/sampFreq,'high');
            dat=dat-filtfilt(b,a,dat); %this is high-pass
            [b,a]=butter(ord,2*55/sampFreq,'low');
            dat=filtfilt(b,a,dat);
            cd(newFolder1)
            writehtk([filenames{cidx} '.htk'],dat,sampFreq,c);
            
            %HG Bandpass
            dat=ecog.data(cidx,:);
            ord=7; %make this 5 for faster
            [b,a]=butter(ord,2*70/sampFreq,'high');
            dat=dat-filtfilt(b,a,dat); %this is high-pass
            [b,a]=butter(ord,2*300/sampFreq,'low');
            dat=filtfilt(b,a,dat);
            cd(newFolder2)
            writehtk([filenames{cidx} '.htk'],dat,sampFreq,c);
        end
end

cd(pathName)

