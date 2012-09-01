%% TEST A VARIOUS LAGS OF NEURAL DATA
%test_adjust=T.Data
[~,fs]=readhtk('E:\DelayWord\EC23\EC23_B1\Analog\ANIN1.htk');
lagset=0:40:400
%%


for c=1:256
    for t=1


%%
for l=2%1:length(lagset)
    lag=lagset(l);
%% get audio and ecog training data
    eidx=1
    loadload
    analoglength=size(test_adjust.segmentedEcog(eidx).analog24Hz,2)
    datalength=size(test_adjust.segmentedEcog(eidx).data,2)
    clear aud
    clear data100
    %test event
    N=size(test_adjust.segmentedEcog(eidx).data,4)
    %N=27

    for i=1:N%size(test.segmentedEcog(eidx).data,4)
        usesamps=floor(analoglength/4)*2:floor(analoglength/4)*3.5;
        dataA=squeeze(test_adjust.segmentedEcog(eidx).analog24Hz(1,usesamps,:,i));
        %dataA=squeeze(test.segmentedEcog(eidx).analog24Hz(2,:,:,i));
        dataA=resample(dataA,16000,round(fs));
        aud{i}= wav2aud6oct(dataA);   

        usesamps=floor(datalength/4)*2:floor(datalength/4)*3.5;
        usesamps=usesamps+lag;
        dataE=squeeze(mean(test_adjust.segmentedEcog(eidx).zscore_separate(:,usesamps,:,i),3));
        for c=1:size(dataE,1)
            data100{i}(c,:)=smooth(resample(dataE(c,:),1,4),10);
        end      
    end

    %% TRAIN AND TEST RECONSTRUCTION (all vs 1)
    clear rstim
    clear holdtrials
    colormap jet
    for i=1:N%size(test.segmentedEcog(eidx).data,4)
        clear trainaud
        clear traindata
        clear testdata    
        %otheridx=setdiff(1:N,i);
        %repeatidx=otheridx(find(strcmp(Labels(otheridx),Labels{i})))
        %SET TRAINING VARIABLES TO DATA FROM ALL OTHER TRIALS
        %traintrials=setdiff(1:N,[i repeatidx]);
        traintrials=1:N;
        trainaud=vertcat(aud{traintrials})';
        traindata=horzcat(data100{traintrials})';    

        % GET TEST DATA IF TESTING ON DIFFERENT SEGMENT
       usesamps=100:800%floor(datalength/4)*2:floor(datalength/4)*3;
        tmp=squeeze(mean(test_beep.segmentedEcog(1).zscore_separate(:,usesamps,:,i),3));
        for c=1:size(dataE,1)
             testdata(c,:)=resample(tmp(c,:),1,4);
        end 

        %IF TEST DATA IS SAME TYPE OF TRAINING DATA
        %testdata=data100{i};        
        % RECONSTRUCTION
        [g,rstim{i}] = StimuliReconstruction (trainaud,traindata,testdata');
    end
    %% pLOT RECONSTRUCTION AND CORRELATIONS
    for i=1:N

        % PLOT RESCONSTRUCTION
        subplot(2,2,1)
        imagesc(rstim{i})
        % PLOT ORIGINAL AUDIO
        subplot(2,2,2)
        imagesc(aud{i}')
        % PLOT CROSS CORRELATION
        subplot(2,2,3)
        %R=corrcoef(rstim{i}',aud{i})
        %RCur=R(1,2);
        XR=xcorr2(rstim{i},aud{i}');
        imagesc(XR)
        [a,maxidx]=max(XR(100,:));
        shift=maxidx-163;
        %title(['R= ' num2str(RCur)])
        % PLOT DISTRIBUTION OF CORRELATION TO AUDIO FROM OTHER TRIALS
        traintrials=setdiff(1:N,i);
        for ii=1:N%traintrials
            notaud=aud{ii};
            %R=corrcoef(rstim{i}',aud{ii});
            R2=cov((mean(rstim{i},2)+1),(mean(aud{ii},1)));
            %Rother(ii)=R(1,2);
            R_freq(ii)=R2(1,2);
        end
        subplot(2,2,4)
        
%         hist(Rother)
%         hold on
%         plot(RCur,1,'r*')
%         hold off
%         title(['Rother=' num2str(mean(Rother)) ' +/- ' num2str(std(Rother))]);    
        input('n')    
       
        otheridx=setdiff(1:N,i);
        repeatidx=otheridx(find(strcmp(Labels(otheridx),Labels{i})))
        %SET TRAINING VARIABLES TO DATA FROM ALL OTHER TRIALS
        traintrials=setdiff(1:N,[i repeatidx]);
       %Rlag(l).Current(i)=RCur;
%        try
%             Rlag(l).Others(i,:)=Rother(traintrials);
%        catch
%             Rlag(l).Others(i,:)=Rother(traintrials(1:end-1));
%        end
        %Rlag(l).Confusion(i,:)=Rother;
        Rlag(l).Freq(i,:)=R_freq;
    end
end


%%
lag=2
for i=1:N
    Rpercentile(i)=(length(find(Rlag(lag).Confusion(i,1:N)>=Rlag(lag).Current(i))))/N;
end
bar(1-Rpercentile(1:N))
xlabel('trial','Fontsize',14)
ylabel('Percentile of R(match) compared to R(nonmatch)','Fontsize',14)
set(gca,'FontSize',12)
title([num2str(mean(1-Rpercentile(1:27))) '+-' num2str(std((1-Rpercentile(1:27))))])


