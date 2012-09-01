regvar=[];
varidx=1
eidx=1
step=10
lagidx=1


%[~,fs]=readhtk('E:\DelayWord\EC23\EC23_B1\Analog\ANIN1.htk');
loadload;close;

for lag=round([0:10:400])
    idx=1;
    for ch=1%:length(ch2)%100:150%0:test.channelsTot
        for tr=1:27%setdiff(1:size(test.segmentedEcog(eidx).event,1),badtrials)     
            %[PC,S,L]=princomp(mean(test.segmentedEcog(eidx).zscore_separate(:,:,:,tr),3)');
            for t=1:30%1:(size(test.segmentedEcog(eidx).zscore_separate,2)-200)/step
                timeset=[2:.05:3.5];
                timeStart=timeset(t);
                %initiate matrix
                %regvar2(ch).trial(tr).matrix(t,:)=zeros(1,10+28+length(ch2)+size(test.segmentedEcog(eidx).zscore_separate,2)/step);
                %output ecog
                %Y is analog signal at all frequencies
                usesamps=floor(timeStart*fs:(timeStart+.05)*fs);
                dataA=squeeze(test.segmentedEcog(eidx).analog24Hz(2,usesamps,:,tr));
                dataA=resample(dataA,16000,round(fs));
                aud{tr}= mean(wav2aud6oct(dataA)',2);
                regvar2(ch).trial(tr).yout(t,:)=reshape(aud{tr}',1, []);
                usesamps=floor((timeStart+lag/1000)*400:(timeStart+lag/1000+.05)*400);
                
                %data downsampled to 100Hz
                dataE=mean(mean(test.segmentedEcog(eidx).zscore_separate(:,usesamps,:,tr),3),4);
                for c=1:size(dataE,1)
                    data100{tr}(c,:)= mean(resample(dataE(c,:),1,4));
                end
                regvar2(ch).trial(tr).matrix(t,:)=reshape(data100{tr},1,[]);
                %regvar2(ch).trial(tr).matrix(t,:)=mean(mean(test.segmentedEcog(eidx).zscore_smoothed(:,(t-1)*step+1+lag:t*step+lag,:,tr),3),2);%mean zscore ecog
                %regvar2(ch).trial(tr).matrix(t,:)=mean(S((t-1)*step+1+lag:t*step+lag,1:50)',2);
                %regvar2(ch).trial(tr).yout(t,1)=mean(mean(test.segmentedEcog(eidx).analog(1,(t-1)*step+1:t*step,:,tr),3),2);%mean analog
                %regvar2(ch).trial(tr).loadings=PC(:,1:50);
                %regvar2(ch).trial(tr).matrix(t,2)=diff([test.segmentedEcog(eidx).event{tr,[7,9]}]);
                %%word length
                %             try
                %                 idx=find(strcmp({brocawords.names}',test.segmentedEcog(eidx).event{tr,8}));
                %                  idx2=find(strcmp({brocawords(idx).difficulty},{'easy','hard'}));
                %                 regvar2(ch).trial(tr).matrix(t,3+idx2)=1;
                %                 idx2=find(strcmp({brocawords(idx).realpseudo}',{'real','pseudo'}));
                %                 regvar2(ch).trial(tr).matrix(t,5+idx2)=1;
                %                 regvar2(ch).trial(tr).matrix(t,7)=brocawords(idx).freq_HAL;
                %                 regvar2(ch).trial(tr).matrix(t,7)=brocawords(idx).logfreq_HAL;
                %                 regvar2(ch).trial(tr).matrix(t,8)=diff([test.segmentedEcog(eidx).event{tr,[11,13]}]);%response times
                %                 regvar2(ch).trial(tr).matrix(t,9+idx)=1;%the word presented
                %                 regvar2(ch).trial(tr).matrix(t,9+28+t)=1;
                %                 regvar2(ch).trial(tr).matrix(t,9+28+size(test.segmentedEcog(eidx).zscore_separate,2)/step+ch)=1;
                %
                %             catch
                %                 continue
                %             end
            end
        end
    end
    %%

    for testtrials=1:length(regvar2(1).trial)
        traintrials=setdiff(1:length(regvar2(1).trial),testtrials);
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
            
            
            %plot(Ytest)
            %hold on
            %plot(Ypred,'r')
            %hold off
            idx=idx+1;
            %input('n')
        end
    end
    %%
     Rall{lagidx}=R2;
     Rotherall{lagidx}=R_other2;
     lagidx=lagidx+1;
end

%% plot R distribution
for testtrials=1:27
    hist(regvar2(c).trial(testtrials).R_other)
    hold on
    plot(regvar2(c).trial(testtrials).R,1,'r*')
    hold off
    input('n')
end



