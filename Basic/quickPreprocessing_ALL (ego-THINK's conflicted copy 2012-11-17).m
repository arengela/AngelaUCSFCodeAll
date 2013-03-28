function [ecog_out, per_out]=quickPreprocessing_ALL(pathName,flag,perFlag,input,ref,timeInt,channelsTot,CARflag)
%Preprocesses ecog block. 
%Block must have folders "RawHTK","Artifacts"
%There must be appropriate files in "Artifacts"
%flag= 1: making hilbert 4-200 Hz all channels at once and saving them
%      2: for making hilbert 4-200 Hz one channel at a time and saving them
%      one channel at a time
%      3: making and saving only high gamma
%      4. Save AfterCARandNotch, and stop there
%      5. Save broad filter HG
%      6. Downsample to 1200, make HFO filters
%      7. Save downsampled, and stop there
%      8. Test
%      9. Output DS and periodogram data ***NOT DONE****
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
if nargin<8
    if ismember(input,[3 4])
        CARflag=256;
    else
        CARflag=16;
    end
end

[a,b,c]=fileparts(pathName);
blockName=b;
cd(pathName)
fprintf('File opened: %s\n',pathName)
fprintf('Block: %s',blockName)

ecog_out=[];
per_out=[];

%%
%Set default Values
switch flag
    case 6
        sampFreq=1200;
    otherwise
        sampFreq=400;
end


freqRange=[70 150];
%DEFAULT VALUES
if ~exist('timeInt')
    timeInt=[];
end


if ~exist('channelsTot') 
    cd('RawHTK')
    channelsTot=length(ls)-2;   
    cd ..
elseif isempty(channelsTot)
    cd('RawHTK')
    channelsTot=length(ls)-2;    
    cd ..
end

if ~exist('ref')
    ref=[];
end

%%LOAD MATLAB VARIABLE
switch input
    case 1 %Human ecog (rawHTK)        
        ecog=loadHTKtoEcog_CT(sprintf('%s/%s',pathName,'RawHTK'),channelsTot,timeInt);
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);    
        ecog=downsampleEcog(ecog,sampFreq);

    case 2 %Downsampled ecog
         ecog=loadHTKtoEcog_CT(sprintf('%s/%s',pathName,'ecogDS'),channelsTot,timeInt);
    case 3 %Rat ecog
        ecog=loadHTKtoEcog_rat_CT(sprintf('%s/%s',pathName,'RawHTK'),channelsTot,timeInt,'rat');
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
        ecog=downsampleEcog(ecog,400,ecog.sampFreq);
    case 5 %Downsampled Rat ecog
        ecog=loadHTKtoEcog_rat_CT(sprintf('%s/%s',pathName,'RawHTK'),channelsTot,timeInt,'rat');    
    otherwise
        ecog=loadHTKtoEcog_CT(sprintf('%s/%s/%s','/data_store/raw/human/EC2',blockName,'RawHTK'),channelsTot,timeInt);
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);    
        ecog=downsampleEcog(ecog,400,ecog.sampFreq);
       
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
if perFlag~=0
    ecogDS=ecog;
end
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
if  ~isempty(ref) 
    filtered=ecogFilterTemporal(ecog,[1 200],3);
    filtered.sampFreq=ecog.sampFreq;
    CAR=repmat(filtered.data(ref,:),[256,1]);
    ecog.data=ecog.data-CAR;
    clear filtered;
    
else
    switch CARflag
        case 256 
            %INSERT code for CAR over all channel
             fprintf('\n1 Hz Filter begin...')
             filtered=ecogFilterTemporal(ecog,[1 200],3);
             filtered.sampFreq=ecog.sampFreq;
             fprintf('1 Hz Filter done...\n')
             CAR=mean(filtered.data(setdiff(1:size(filtered.data,1),badChannels),:));
             
             ecog.data=ecog.data-repmat(CAR,[size(filtered.data,1),1]);
             clear 'filtered'
        case 16
                %keyboard                
                fprintf('\n1 Hz Filter begin...')
                filtered=ecogFilterTemporal(ecog,[1 200],3);
                filtered.sampFreq=ecog.sampFreq;
                fprintf('1 Hz Filter done...\n')
                ecog=subtractCAR_16ChanBlocks(filtered,badChannels,ecog);
                clear 'filtered'
        otherwise                
    end
end
%%
%NOTCH FILTER at 60, 120, 180 Hz
switch flag
    case {6,7}
        %No Notch Filter
    otherwise    
        ecog=applyLineNoiseNotch(ecog);
end


%%
switch perFlag
    case 1 %Plot Figures
    if ~isempty(badTimeSegments)
        [row,col]=find((badTimeSegments(:,1)>timeInterval(1)&badTimeSegments(:,1)<timeInterval(2))|(badTimeSegments(:,2)>timeInterval(1)&badTimeSegments(:,2)<timeInterval(2)));
        badTimeSegments=badTimeSegments(row,:);
    end
    b=[];
    for i=1:size(badTimeSegments,1)
        b=[b round(badTimeSegments(i,1)*400):round(badTimeSegments(i,2)*400)]
    end
    ecogTmp.data(badChannels,:)=[];
    if ~isempty(b)
        ecogTmp.data(:,b)=[];
    end

    cd(sprintf('%s/Figures',pathName))
    individualPer='n';
    [ecog,badFreqs]=checkPeriodogramGUI_figName(ecogDS,individualPer,'periodogramAfterCAR')
    set(gcf,'Name',sprintf('%s DS',blockName))
    saveas(gcf,'FIG_periodogramDS','fig')
    [tmp,badFreqs]=checkPeriodogramGUI(ecogTmp,individualPer);
    set(gcf,'Name',sprintf('%s After CAR',blockName))
    saveas(gcf,'FIG_periodogramAfterCAR','fig')

    plotSpectrogramDS_AllChan_AllTS_GUI(ecogDS,blockName)
    set(gcf,'Name',sprintf('%s DS',blockName))
    saveas(gcf,'FIG_spectrogramDS','fig')
    plotSpectrogramDS_AllChan_AllTS_GUI(ecog,blockName)
    set(gcf,'Name',sprintf('%s After CAR',blockName))
    saveas(gcf,'FIG_spectrogramAfterCAR','fig')
    close all
    cd(pathName)
    
%%Only save periodograms, no figures
%NEED TO FIX!!!
%{
    case 2
    periodogram_noFigure(ecog,'periodogramDS')
    periodogram_noFigure(ecogTmp,'periodogramAfterCAR')

    cd(sprintf('%s/Figures',pathName))
    for i=1:256
        spectrogramDS{i}=abs(specgram(ecogDS.data(i,:),[],400));
        spectrogramAfterCAR{i}=specgram(ecogTmp.data(i,:),[],400)
        save(spectrogramDS)
        save(spectrogramAfterCAR)
    end
    cd(pathName)
%}
end

%%
switch flag
    case {4,7} %Save only AfterCARandNotch
        if flag==4
            newfolder='AfterCARandNotch';
        elseif flag==7
            newfolder='Downsampled400';
        end
        
        if input==3
            mkdir([pathName filesep newfolder])
            cd([pathName filesep newfolder])
    %         mkdir('/data/Kunal/EC2_B88/AfterCARandNotch');
    %         cd('/data/Kunal/EC2_B88/AfterCARandNotch');
            Fs=sampFreq;
            fprintf('Saving:\n')
            for nBlocks=1:96
                   varName=sprintf('Wave%s.htk',num2str(nBlocks));
                   chanNum=nBlocks;
                   fprintf('%i\n.',chanNum)
                   data=(ecog.data(nBlocks,:));
                   writehtk (varName, data, Fs, chanNum);        
            end
        else        
        
            mkdir([pathName filesep newfolder])
            cd([pathName filesep newfolder])
    %         mkdir('/data/Kunal/EC2_B88/AfterCARandNotch');
    %         cd('/data/Kunal/EC2_B88/AfterCARandNotch');
            Fs=sampFreq;
            blockNum=floor(channelsTot/64);
            elecNum=rem(channelsTot,64);
            fprintf('Saving:\n')
            for nBlocks=1:blockNum
                for k=1:64
                   varName=sprintf('Wav%s%s.htk',num2str(nBlocks),num2str(k));
                   chanNum=(nBlocks-1)*64+k;
                   fprintf('%i\n.',chanNum)
                   data=(ecog.data((nBlocks-1)*64+k,:));
                   writehtk (varName, data, Fs, chanNum);        
                end
            end
        end
        cd(pathName)  
        
    case 1  %Calculate all Hilbert all channels at once
        mkdir('HilbImag_4to200_40band')
        mkdir('HilbReal_4to200_40band')
        [ecog,cfs,sigma_fs]=processingHilbertTransform_filterbankGUI_complex_mem(ecog, sampFreq, [4 200]);
        
        %SAVE High Gamma
        currentPath=pwd;
        x=find(cfs>=freqRange(1)&cfs<=freqRange(2));
        newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(freqRange(1)),int2str(freqRange(2)),int2str(length(x)));
        newPath=sprintf('%s/%s',pathName,newFolder);
        saveEcogToHTK(newPath,ecog)
        fprintf('Done!')    
        
    case 2    %Calculate all bands one channel at a time
        mkdir('HilbImag_4to200_40band')
        mkdir('HilbReal_4to200_40band')
        w=1;
        fprintf('Hilbert:')
        Fs=sampFreq;
        blockNum=floor(channelsTot/64);
        elecNum=rem(channelsTot,64);
        for nBlocks=1:blockNum
             for k=1:64
                 varName=sprintf('Wav%s%s.htk',num2str(nBlocks),num2str(k));
                 chanNum=(nBlocks-1)*64+k;
                 fprintf('%i',chanNum)
                 [cfs,sigma_fs,hilbdata]=processingHilbertTransform_filterbankGUI_onechan(ecog.data(chanNum,:),Fs,[4 200]);
                  data1=real(squeeze(hilbdata))';
                  cd('HilbReal_4to200_40band')
                  writehtk (varName, data1, 400, chanNum); 
                  clear data1
                  cd ..
                  cd('HilbImag_4to200_40band')
                  data2=imag(squeeze(hilbdata))';
                  writehtk (varName, data2, 400, chanNum); 
                  clear data2
                  cd ..

                    x=find(cfs>=freqRange(1)&cfs<=freqRange(2));
                    newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(freqRange(1)),int2str(freqRange(2)),int2str(length(x)));
                    newPath=sprintf('%s/%s',pathName,newFolder);
                    if w==1
                        mkdir(newPath);
                        w=0;
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
        end
        if elecNum>0
                for i=1:elecNum
                 chanNum=blockNum*64+i;
                 fprintf('%i',chanNum)
                 varName=sprintf('Wav%i%i.htk',nBlocks+1,i);
                 [cfs,sigma_fs,hilbdata]=processingHilbertTransform_filterbankGUI_onechan(ecog.data(chanNum,:),Fs,[4 200]);
                 data1=real(squeeze(hilbdata))';
                 cd('HilbReal_4to200_40band')
                 writehtk (varName, data1, 400, chanNum); 
                 clear data1
                 cd ..
                 cd('HilbImag_4to200_40band')
                 data2=imag(squeeze(hilbdata))';
                   writehtk (varName, data2, 400, chanNum); 
                   clear data2
                   cd ..

                    x=find(cfs>=freqRange(1)&cfs<=freqRange(2));
                    newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(freqRange(1)),int2str(freqRange(2)),int2str(length(x)));
                    newPath=sprintf('%s/%s',pathName,newFolder);

                    if w==1
                        mkdir(newPath);
                        w=0;
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
         end
%%
        case 3  %Calculate and save only HG
            [ecog,cfs,sigma_fs]=processingHilbertTransform_filterbankGUI(ecog, sampFreq, freqRange);
            currentPath=pwd;
            x=find(cfs>=freqRange(1)&cfs<=freqRange(2));
            newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(freqRange(1)),int2str(freqRange(2)),int2str(length(x)));
            newPath=sprintf('%s/%s',pathName,newFolder);
            saveEcogToHTK(newPath,ecog)
        case 5
            [ecog,cfs,sigma_fs]=processingHilbertTransform_filterbankGUI_broad(ecog, sampFreq, freqRange);
            currentPath=pwd;
            x=find(cfs>=freqRange(1)&cfs<=freqRange(2));
            newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(freqRange(1)),int2str(freqRange(2)),int2str(length(x)));
            %newPath=sprintf('%s/%s','/data/AR/FilterTests/EC2',newFolder);
            saveEcogToHTK([pathName filesep newFolder],ecog)
        case 6 
            mkdir('HilbReal_4to500_45band_1200Hz')
            mkdir('HilbImag_4to500_45band_1200Hz')
            w=1;
            fprintf('Hilbert:')
            Fs=sampFreq;
            blockNum=floor(channelsTot/64);
            elecNum=rem(channelsTot,64);
            for nBlocks=1:blockNum
                 for k=1:64
                     varName=sprintf('Wav%s%s.htk',num2str(nBlocks),num2str(k));
                     chanNum=(nBlocks-1)*64+k;
                     fprintf('%i',chanNum)
                     [cfs,sigma_fs,hilbdata]=processingHilbertTransform_filterbankGUI_onechan(ecog.data(chanNum,:),Fs,[4 500]);
                      data1=real(squeeze(hilbdata))';
                      cd('HilbReal_4to500_45band_1200Hz')
                      writehtk (varName, data1, sampFreq, chanNum); 
                      clear data1
                      cd ..
                      cd('HilbImag_4to500_45band_1200Hz')
                      data2=imag(squeeze(hilbdata))';
                      writehtk (varName, data2, sampFreq, chanNum); 
                      clear data2
                      cd ..
                        
                      %{
                        x=find(cfs>=freqRange(1)&cfs<=freqRange(2));
                        newFolder=sprintf('HilbAA_%sto%s_%sband',int2str(freqRange(1)),int2str(freqRange(2)),int2str(length(x)));
                        newPath=sprintf('%s/%s',pathName,newFolder);
                        if w==1
                            mkdir(newPath);
                            w=0;
                        end
                      
                        cd(newPath)            
                        envData=abs(hilbdata(1,:,:));
                        data3=squeeze(envData(:,:,x));
                        writehtk (varName, data3', Fs, chanNum);        
                        cd ..
                      
                        clear hilbdata
                        clear data3
                        clear envData   
      %}
                end
            end
end

