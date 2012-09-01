%% search for bad trails
badtrials=[4 9 13 42 38 40  30 24 37]

badtrials=[31 23 ]
n=10
event=5;
T=PLVtests(12,event)
test=T.Data

load('E:\DelayWord\wordgroups')
load('E:\DelayWord\brocawords')
%%
eidx=1;
for tr=1:size(test.segmentedEcog(eidx).analog,4)
    test.segmentedEcog(eidx).analog(1,:,:,tr)=abs(hilbert(test.segmentedEcog(eidx).analog(1,:,:,tr)));
    test.segmentedEcog(eidx).analog(2,:,:,tr)=abs(hilbert(test.segmentedEcog(eidx).analog(2,:,:,tr)));
end



for c=1:test.channelsTot
    for tr=1:size(test.segmentedEcog(1).zscore_separate,4)
        test.segmentedEcog(1).zscore_smoothed(c,:,1,tr)=smooth(mean(test.segmentedEcog(1).zscore_separate(c,:,:,tr),3),10);
    end
end

%% Make Variables: Predict Analog
regvar=[];
varidx=1
eidx=1
step=10
lagidx=1


[~,fs]=readhtk('E:\DelayWord\EC23\EC23_B1\Analog\ANIN1.htk');
loadload;close;

for lag=round([10:10:400])
    idx=1;
    for ch=1%:length(ch2)%100:150%0:test.channelsTot
        for tr=1:30%setdiff(1:size(test.segmentedEcog(eidx).event,1),badtrials)     
            %[PC,S,L]=princomp(mean(test.segmentedEcog(eidx).zscore_separate(:,:,:,tr),3)');
            for t=1:30%1:(size(test.segmentedEcog(eidx).zscore_separate,2)-200)/step
                timeset=[2:.05:3.5];
                timeStart=times(t);
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
                    data100{tr}(c,:)=resample(dataE(c,:),1,4);
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
            [beta,sigma,resid,vars,loglik]=mvregress(X,Y);
            Ypred=bsxfun(@times,Xtest',beta);    
            Ypred=sum(Ypred);

            %Corr between predicted and real Y
            R=corrcoef(smooth(Ytest,10),smooth(Ypred,1));
            R2(idx)=R(1,2);
            regvar2(c).trial(testtrials).beta=beta;
            regvar2(c).trial(testtrials).ypred=Ypred;  
            %plot(Ytest)
            %hold on
            %plot(Ypred,'r')
            %hold off
            idx=idx+1;
            %input('n')
        end
    end
     Rall{lagidx}=R2;
     lagidx=lagidx+1;
end

%%
plot(vertcat(Rall{:}))
imagesc(vertcat(Rall{:})')


%% Make Variables
regvar=[];
varidx=1
eidx=1
step=10
for ch=1:length(ch2)%100:150%0:test.channelsTot
    for tr=1:30%setdiff(1:size(test.segmentedEcog(eidx).event,1),badtrials)        
        for t=1:size(test.segmentedEcog(eidx).zscore_separate,2)/step
            
            %initiate matrix
            regvar2(ch).trial(tr).matrix(t,:)=zeros(1,10+28+length(ch2)+size(test.segmentedEcog(eidx).zscore_separate,2)/step);         
            
            %output ecog
            regvar2(ch).trial(tr).yout(t,:)=mean(mean(test.segmentedEcog(eidx).zscore_separate(ch,(t-1)*step+1:t*step,:,tr),3),2);%mean zscore ecog          
           
            regvar2(ch).trial(tr).matrix(t,1)=mean(mean(test.segmentedEcog(eidx).analog(1,(t-1)*step+1:t*step,:,tr),3),2);%mean analog           
            regvar2(ch).trial(tr).matrix(t,2)=diff([test.segmentedEcog(eidx).event{tr,[7,9]}]); %word length
            try
                idx=find(strcmp({brocawords.names}',test.segmentedEcog(eidx).event{tr,8}));
                 idx2=find(strcmp({brocawords(idx).difficulty},{'easy','hard'}));
                regvar2(ch).trial(tr).matrix(t,3+idx2)=1;           
                idx2=find(strcmp({brocawords(idx).realpseudo}',{'real','pseudo'}));
                regvar2(ch).trial(tr).matrix(t,5+idx2)=1;           
                %regvar2(ch).trial(tr).matrix(t,7)=brocawords(idx).freq_HAL;
                regvar2(ch).trial(tr).matrix(t,7)=brocawords(idx).logfreq_HAL;
                regvar2(ch).trial(tr).matrix(t,8)=diff([test.segmentedEcog(eidx).event{tr,[11,13]}]);%response times
                regvar2(ch).trial(tr).matrix(t,9+idx)=1;%the word presented       
                regvar2(ch).trial(tr).matrix(t,9+28+t)=1;
                regvar2(ch).trial(tr).matrix(t,9+28+size(test.segmentedEcog(eidx).zscore_separate,2)/step+ch)=1;
                
            catch
                continue
            end
           
            
        end
    end
end


%%
clear R2
clear betaall
clear preddata
clear predch
clear betaall
clear realdata
clear chidx
load('E:\General Patient Info\EC23\regfeatures.mat')
chidx{1}=[]
N=10
idx=1

%%
for testtrials=1:length(regvar2(1).trial)
    traintrials=setdiff(1:length(regvar2(1).trial),testtrials);
    for c=1:length(regvar2)
        X=vertcat(regvar2(c).trial(traintrials).matrix);
        Y=vertcat(regvar2(c).trial(traintrials).yout);   
        Xtest=vertcat(regvar2(c).trial(testtrials).matrix);
        Ytest=vertcat(regvar2(c).trial(testtrials).yout);

        [beta,sigma,resid,vars,loglik]=mvregress(X,Y);
        Ypred=bsxfun(@times,Xtest',beta);    
        Ypred=sum(Ypred);
        R=corrcoef(smooth(Ytest,10),smooth(Ypred,1));
        R2(idx)=R(1,2);
        regvar2(c).trial(testtrials).beta=beta;
        regvar2(c).trial(testtrials).ypred=Ypred;  
        plot(Ytest)
        hold on
        plot(Ypred,'r')
        hold off
        idx=idx+1;
        %input('n')
    end
end


%%
for ch=1:length(regvar2)
        figure(1)        
        B=horzcat(regvar2(ch).trial.beta);
        subplot(3,1,1)
        plot(B)
        errorarea(mean(B,2),std(B,[],2));             
        weighthold(ch).electrode=ch2(ch)        
        for j=[1:37]            
            weighthold(ch).feature(j).name=regfeatures{unique(j),:}
            weighthold(ch).feature(j).weight=B(unique(j),:)
        end
        title(int2str(ch))
        hold off
        input('n')
end
%%
idx=1;
for ch=1:length(regvar2)
    for f=[1:10]
        weightcell{idx,1}=weighthold(ch).electrode;
        weightcell{idx,2}=weighthold(ch).feature(f).name;
        weightcell{idx,3}=weighthold(ch).feature(f).weight;
        idx=idx+1;
    end
    
end

%%
idx=1;
for ch=1:length(ch2)
    for f=[1:35]
        weightcell{idx,1}=weighthold(ch).electrode;
        weightcell{idx,2}=weighthold(ch).feature(f).name;
        weightcell{idx,3}=weighthold(ch).feature(f).weight;
        idx=idx+1;
    end
    
end
%%
%powerpoint_object=SAVEPPT2('testppt','init')

for i=1:35%length(regfeatures2)
    %tmp2=zeros(1,length(ch2))
    figure(1)
    clear tmp2
    clear tmp3
    clear tmp4
    [a,b]=find(strcmp(regfeatures{i},weightcell));
    
    
    figure(1)
    subplot(3,1,1)
    hold on
    for j=1:length(a)
        tmp=weightcell(a,3);
        d=tmp{j}(find(tmp{j}~=0));
                %d=zscore(tmp{j}(find(tmp{j}~=0)))'

        tmp2(j)=mean(d);
        tmp3(j)=std(d);
        tmp4(j)=sqrt(length(d));
        if ~isnan(d)
            plot(d)
        end
    end
    hold off
    subplot(3,1,2)
    errorarea(tmp2,tmp3./tmp4)
    subplot(3,1,3)
    figure(2)
    chan=cell2mat(weightcell(a,1))
    %visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],chan',tmp3,[],max(tmp2)-tmp2)
    visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],chan',tmp2,[],tmp2)

    %colormap(flipud(hot))
    
    
   
    
    
    regfeatures{i}
    title(    regfeatures{i})
    %pause(.1)
    SAVEPPT2('ppt',powerpoint_object,'stretch','off');
    input('n')
end
%%




%% plot by frequency

for eidx=1:length(test.segmentedEcog)
    
    wordlength=cell2mat(test.segmentedEcog(eidx).event(:,9))-cell2mat(test.segmentedEcog(eidx).event(:,7))
    [sorted,tridx]=sort(wordlength);
%     wordorder=test.segmentedEcog(eidx).event(:,8)
%     clear wordfreq
%     for i=1:length(wordorder)
%         try
%             idx=find(strcmp(wordorder(i),{brocawords.names}))
%             wordfreq(i)=brocawords(idx).freq_HAL;
%         end
%     end
%     [sorted,tridx]=sort(wordfreq);
%     
    test.segmentedEcog(eidx).zscore_separate=test.segmentedEcog(eidx).zscore_separate(:,:,:,tridx);
    test.segmentedEcog(eidx).data=test.segmentedEcog(eidx).data(:,:,:,tridx);
    %test.segmentedEcog(eidx).rt=test.segmentedEcog(eidx).rt(tridx);
    test.segmentedEcog(eidx).event=test.segmentedEcog(eidx).event(tridx,:);
end

test.segmentedEcog(1).rt=cell2mat(test.segmentedEcog(1).event(:,9))-cell2mat(test.segmentedEcog(1).event(:,7))
test.segmentedEcog(2).rt=cell2mat(test.segmentedEcog(2).event(:,13))-cell2mat(test.segmentedEcog(2).event(:,11))
test.segmentedEcog(3).rt=cell2mat(test.segmentedEcog(3).event(:,15))-cell2mat(test.segmentedEcog(3).event(:,13))
