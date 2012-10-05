regvar=[];
varidx=1
eidx=1
step=10
lagidx=1


[~,fs]=readhtk('E:\DelayWord\EC23\EC23_B1\Analog\ANIN1.htk');
loadload;close;
test=T.Data
usechan=setdiff(T.Data.usechans,T.Data.Artifacts.badChannels)
%%
            D=T.Data.segmentedEcog.zscore_separate(usechan,:,:,:);
            L=1:size(D,3)
            avgData = zeros(size(D,1),size(D,2),length(unique(L)));
            for i = 1:size(avgData,3)
                avgData(:,:,i) = mean(D(:,:,L==i),3);    
            end

            dat = [];
            for i = 1:size(avgData,3)
                dat = [dat; avgData(:,:,i)'];
            end
            [eigcoeff, eigvec] = pca(dat);
            pcnum=20
            [eigcoeff, eigvec] = pca(dat,pcnum);
            %%


timeset=200:350;
for lag=10%round([0:10:400])
    idx=1;
    for ch=1
        for tr=1:size(test.segmentedEcog(eidx).zscore_separate,4)
            dataE=eigvec'*test.segmentedEcog(eidx).zscore_separate(usechan,:,:,tr);       
            %dataE=mean(mean(test.segmentedEcog(eidx).zscore_separate(usechan,:,:,tr),3),4);
            dataA=squeeze(test.segmentedEcog(eidx).analog24Hz(2,:,:,tr));
            dataA=resample(dataA,16000,round(fs));
            audSpec= wav2aud6oct(dataA)';
            for c=1:size(dataE,1)
                data100{tr}(c,:)= resample(dataE(c,:),1,4);
            end
            for t=1:150
                %timeStart=timeset(t);
                %Y is analog signal at all frequencies
                %usesamps=floor(timeStart*100:(timeStart+.05)*100);
                usesamps=timeset(t);
                regvar2(ch).trial(tr).yout(t,:)=reshape(mean(audSpec(:,usesamps),2)',1, []);
                regvar2(ch).trial(tr).matrix(t,:)=reshape(data100{tr}(:,usesamps),1,[]);
            end
        end
    end
    %%
    numTrials=length(regvar2(1).trial);
    for testtrials=1:numTrials
        traintrials=setdiff(1:numTrials,testtrials);
        for c=1:length(regvar2)
            %Get Training and test variables
            X=vertcat(regvar2(c).trial(traintrials).matrix);
            Y=vertcat(regvar2(c).trial(traintrials).yout);   
            Xtest=vertcat(regvar2(c).trial(testtrials).matrix);
            Ytest=vertcat(regvar2(c).trial(testtrials).yout);

            %Regression function
            for f=1:size(Y,2)
                [beta(:,f),sigma,resid,vars,loglik]=mvregress(X,Y(:,f));
                Ypred=bsxfun(@times,Xtest',beta(:,f));    
                Ypred2(:,f)=sum(Ypred,1);
            end

            %Corr between predicted and real Y
            R=corrcoef(Ytest,Ypred2);
            regvar2(c).trial(testtrials).R=R(1,2);
            R2(idx)=R(1,2);
            regvar2(c).trial(testtrials).beta=beta;
            regvar2(c).trial(testtrials).ypred=Ypred2;              
            
            
            %Corr to non-matches
            for tr=1:length(traintrials)    
                Ytrain=regvar2(c).trial(traintrials(tr)).yout;
                R=corrcoef(Ytrain,Ypred2);
                R_other(tr)=R(1,2);
            end
            regvar2(c).trial(testtrials).R_other=R_other;
            R_other2(idx,:)=R_other;
            %input('n')
        end
    end
    %%
     Rall{lagidx}=R2;
     Rotherall{lagidx}=R_other2;
     lagidx=lagidx+1;
end
%% visualize beta
for f=1:5:100
    %if used pc
    for pcnum=1:20
        tmp=eigvec(:,pcnum);
        weights(pcnum,:)=regvar2(c).trial(testtrials).beta(pcnum,f)*tmp';
    end       
    if 1
        visualizeGrid(5,['E:\General Patient Info\' test.patientID '\brain.jpg'],usechan,mean(weights));
    else
        weights2=zeros(1,256);
        weights2(usechan)=mean(weights,1);
        tmp=reshape(weights2,16,16)';
        imagesc(tmp)
    end
    title(int2str(f))
    input('n')
    clf
 end


%% plot R distribution
for testtrials=1:length(regvar2.trial)
    hist(regvar2(c).trial(testtrials).R_other)
    hold on
    plot(regvar2(c).trial(testtrials).R,1,'r*')
    hold off
    input('n')
end
%% PLOT SPECTROGRAMS, CORR ACROSS TIME
for t=1:length(regvar2.trial)
    figure(1)
    subplot(2,2,1)
    imagesc(regvar2.trial(t).yout')
    title(Labels{t})
    subplot(2,2,2)
    imagesc(regvar2.trial(t).ypred')
    for s=1:150
        R=corrcoef(regvar2.trial(t).yout(s,:),regvar2.trial(t).ypred(s,:));
        rtime(s)=R(1,2);
    end
    subplot(2,2,3)
    plot(rtime)
    hold on
    plot(mean(regvar2.trial(t).yout,2),'r')
    plot(mean(regvar2.trial(t).ypred,2),'g')
    title(regvar2.trial(t).R)   
    hold off
    
    for f=1:100
        R=corrcoef(regvar2.trial(t).yout(:,f),regvar2.trial(t).ypred(:,f));
        rfreq(f)=R(1,2);
    end
    
    subplot(2,2,4)
    plot(rfreq)
    
    
    input('n')
    clf
end