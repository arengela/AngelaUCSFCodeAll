%%make pairs
wordlist=test.segmentedEcog(1).event(:,8)
w=1:length(wordlist)
t=1;
clear test_adjust
while ~isempty(w)
    curw=wordlist{w(1)};
    idxall=find(strcmp(curw,wordlist))
    idx=idxall(1);
    test_adjust.segmentedEcog(1).data(:,:,:,t)=mean(test.segmentedEcog(1).data(:,:,:,idx),4);
    test_adjust.segmentedEcog(1).zscore_separate(:,:,:,t)=mean(test.segmentedEcog(1).zscore_separate(:,:,:,idx),4);
    test_adjust.segmentedEcog(1).analog24Hz(:,:,:,t)=mean(test.segmentedEcog(1).analog24Hz(:,:,:,idx),4);
  
    test_adjust.segmentedEcog(2).data(:,:,:,t)=mean(test.segmentedEcog(2).data(:,:,:,idx),4);
    test_adjust.segmentedEcog(2).zscore_separate(:,:,:,t)=mean(test.segmentedEcog(2).zscore_separate(:,:,:,idx),4);
    test_adjust.segmentedEcog(2).analog24Hz(:,:,:,t)=mean(test.segmentedEcog(2).analog24Hz(:,:,:,idx),4);
    
    
      test_adjust.segmentedEcog(3).data(:,:,:,t)=mean(test.segmentedEcog(3).data(:,:,:,idx),4);
    test_adjust.segmentedEcog(3).zscore_separate(:,:,:,t)=mean(test.segmentedEcog(3).zscore_separate(:,:,:,idx),4);
    test_adjust.segmentedEcog(3).analog24Hz(:,:,:,t)=mean(test.segmentedEcog(3).analog24Hz(:,:,:,idx),4);
    
    w=setdiff(w,idxall);
    %wordlist=wordlist(w);
    t=t+1;
end
%% TEST A VARIOUS LAGS OF NEURAL DATA
lagset=0:40:400
test_adjust=T.Data
for l=10%:length(lagset)
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
    [~,fs]=readhtk('E:\DelayWord\EC23\EC23_B1\Analog\ANIN1.htk');
    for i=1:N%size(test.segmentedEcog(eidx).data,4)
        usesamps=floor(analoglength/4)*2:floor(analoglength/4)*3;
        dataA=squeeze(test_adjust.segmentedEcog(eidx).analog24Hz(2,usesamps,:,i));
        %dataA=squeeze(test.segmentedEcog(eidx).analog24Hz(2,:,:,i));
        dataA=resample(dataA,16000,round(fs));
        aud{i}= wav2aud6oct(dataA);   

        usesamps=floor(datalength/4)*2:floor(datalength/4)*3;
        usesamps=usesamps+lag;
        dataE=squeeze(mean(test_adjust.segmentedEcog(eidx).zscore_separate(:,usesamps,:,i),3));
        for c=1:size(dataE,1)
            data100{i}(c,:)=resample(dataE(c,:),1,4);
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
        %SET TRAINING VARIABLES TO DATA FROM ALL OTHER TRIALS
        traintrials=setdiff(1:N,i);
        trainaud=vertcat(aud{traintrials})';
        traindata=horzcat(data100{traintrials})';    

        % GET TEST DATA IF TESTING ON DIFFERENT SEGMENT
    %    usesamps=800:1200%floor(datalength/4)*2:floor(datalength/4)*3;
    %     tmp=squeeze(mean(test_adjust.segmentedEcog(1).zscore_separate(:,usesamps,:,i),3));
    %     for c=1:size(dataE,1)
    %          testdata(c,:)=resample(tmp(c,:),1,4);
    %     end 

        %IF TEST DATA IS SAME TYPE OF TRAINING DATA
        testdata=data100{i};        
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
        R=corrcoef(rstim{i}',aud{i})
        RCur=R(1,2);
        imagesc(xcorr2(rstim{i},aud{i}'))
        title(['R= ' num2str(RCur)])
        % PLOT DISTRIBUTION OF CORRELATION TO AUDIO FROM OTHER TRIALS
        traintrials=setdiff(1:N,i);
        for ii=traintrials
            notaud=aud{ii};
            R=corrcoef(rstim{i}',aud{ii});
            Rother(ii)=R(1,2);
        end
        subplot(2,2,4)
        hist(Rother)
        hold on
        plot(RCur,1,'r*')
        hold off
        title(['Rother=' num2str(mean(Rother)) ' +/- ' num2str(std(Rother))]);    
       % input('n')    
       Rlag(l).Current(i)=RCur;
        Rlag(l).Others(i,:)=Rother;
       
    end

end


%%
for i=1:N%size(test.segmentedEcog(eidx).data,4)
    clear trainaud
    clear traindata
    clear testdata    
    %%make variables
    traintrials=setdiff(1:N,i);
    trainaud=vertcat(aud{traintrials})';
    traindata=horzcat(data100{traintrials})';    
    usesamps=800:1200%floor(datalength/4)*2:floor(datalength/4)*3;
    tmp=squeeze(mean(test_adjust.segmentedEcog().zscore_separate(:,usesamps,:,i),3));
    for c=1:size(dataE,1)
         testdata(c,:)=resample(tmp(c,:),1,4);
    end 
    %testdata=data100{i};
    
    
    %% Reconstruction
    [g,rstim{i}] = StimuliReconstruction (trainaud,traindata,testdata');

    %% correlation against other trials
    for ii=traintrials
        notaud=aud{ii};
        R=corrcoef(sum(adjustedrstim'),sum(notaud));
        notR(ii)=R(1,2);
    end      
    
    %% PLOT RESCONSTRUCTION
    subplot(2,2,1)
    imagesc(rstim{i})
    %colorbar
    adjustedrstim=rstim{i};
    adjustedrstim(find(rstim{i}<0))=0;

    %% PLOT SUM ACROSS TIME
    subplot(2,2,2)
    plot(zscore(sum(aud{i})),'r')
    hold on
    plot(zscore(sum(adjustedrstim')))  

    hold off
    
    %% CORRELATION OF FREQUENCIES COMPARED TO NOT MATCHES
    R=corrcoef(sum(adjustedrstim'),sum(aud{i})); 
    Rtime=corrcoef(sum(adjustedrstim),sum(aud{i},2));

    title(['R= ' num2str(R(1,2)) '    vs    ROthers= ' num2str(mean(notR)) '+-' num2str(std(notR))])
    hold off
    subplot(2,2,3)
    imagesc(aud{i}')
    subplot(2,2,4)    
    
    %% CORRELATION FOR EACH TIME POINT
    Rtime=zeros(1,size(aud{i},1));
    for t=1:size(aud{i},1)
        testaud=aud{i}';
        tmp=corrcoef(adjustedrstim(:,t),testaud(:,t));
        Rtime(t)=tmp(1,2);
    end
    plot(Rtime)
     hold on
      plot(zscore(sum(aud{i},2)),'r')
      hold off
      
      %% XCORR TO FIND OPTIMAL LAG
      [XR,lag]=xcorr(sum(adjustedrstim),sum(aud{i},2));
      idx=find(lag>=0 & lag<=50);
      [~,maxXR]=max(XR(idx));
      plot(XR,'r')
      sumAud=sum(aud{i},2);
      sumRstim=sum(adjustedrstim);
      
      
      Rtime=zeros(1,50);
      for t=1:50
        testaud=aud{i}';
        tmp=corrcoef(adjustedrstim(:,t+lag(maxXR+100)),testaud(:,t));
        Rtime(t)=tmp(1,2);
      end
      %plot(Rtime);
      plot(sumAud(1:51)/40,'r','LineWidth',3)
      hold on

      Rmean=mean(Rtime);
      plot(Rtime,'g','LineWidth',3)

      %% TEST CORRELATION AT OPTIMAL LAG FOR NON-MATCHING TRIALS
      Rmean_nott=1:length(traintrials)
      for ii=traintrials
          [XR,lag]=xcorr(sum(adjustedrstim),sum(aud{ii},2));
          idx=find(lag>=0 & lag<=50);
          [~,maxXR]=max(XR(idx));
          %plot(XR)
          sumAud=sum(aud{ii},2);
          sumRstim=sum(adjustedrstim);

          Rtime=zeros(1,50);
          for t=1:50
            testaud=aud{i}';
            tmp=corrcoef(adjustedrstim(:,t+lag(maxXR+100)),testaud(:,t));
            Rtime(t)=tmp(1,2);
          end   
          Rmean_nott(ii)=mean(Rtime);
          plot(Rtime)
      end
      hold off
      
      %Rlag=corrcoef(sumAud(1:51),sumRstim(lag(maxXR):lag(maxXR)+50))
      
      title(num2str(Rmean))
%     plot(sum(adjustedrstim))
%     hold on
%     plot(sum(aud{i},2),'r')
%     hold off
%     title(num2str(R(1,2)))

    %plot(sum(aud{i}))
%     XR=xcorr(sum(rstim{i}),sum(aud{i}'));
%     plot(XR)
%     ax is tight    
%     
%     holdtrials(i).Rfreq=R(1,2);
%     holdtrials(i).Rfreq_others=notR;
%     hist(holdtrials(i).Rfreq_others,100)
%     hold on
%     plot(holdtrials(i).Rfreq,1,'r*')
%     hold off
%     
%     % calc p-value bootstrap distribution
%     nboot=10000;
%     usen=ceil(rand(1,nboot)*N);
%     useR=[holdtrials(i).Rfreq holdtrials(i).Rfreq_others];
%     bootR=useR(usen);
%     p=length(find(bootR>holdtrials(i).Rfreq))./nboot'
%     holdtrials(i).p_raw=p;
%     title(num2str(p))
    input('next')

end
%%
nboot=10000;
useR=[holdtrials.Rfreq_others];
usen=ceil(rand(1,nboot)*length(useR));
bootR=useR(usen);
hist(bootR,100)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','w','facealpha',0.75)
hold on;

nboot=10000;
useR=[holdtrials.Rfreq];
usen=ceil(rand(1,nboot)*length(useR));
bootR=useR(usen);
hist([bootR],100)
h1 = findobj(gca,'Type','patch');
set(h1,'facealpha',0.75);

hold off

%%
for i=1:N
    traintrials=setdiff(1:N,i);
    for t=traintrials
        testaud=aud{i}';
        

    %%
    subplot(4,1,1)
    imagesc(aud{2}')
    title('original audio')

    subplot(4,1,2)
    imagesc(rstim)
    title('reconstructed audio')

    subplot(4,1,3)
    R=corrcoef([aud{2} rstim']);
    imagesc(R(1:101,100:end))
    title('correlation in frequency')

    subplot(4,1,4)
    R=corrcoef([aud{2}' rstim]);
    imagesc(R(1:101,100:end))
    title('correlation in time')
    %%

    StimTrain=vertcat({aud})';
    TrainResp=horzcat({data100})';

    [g,rstim] = StimuliReconstruction (StimTrain, TrainResp,TestResp,[],-30);%lag -30 to 10, 
    %% xcorr of wordpresentation seg and delay seg
    for c=1:test.channelsTot
        for t=1:size(test.segmentedEcog(1).data,4)
            d1=mean(mean(test.segmentedEcog(1).zscore_separate(c,800:1200,:,t),3),4);
            d2=mean(mean(test.segmentedEcog(2).zscore_separate(c,1:800,:,t),3),4);
            %[XR,lag]=xcorr(d2,d1);
            [XR,lag]=xcorr(d2);

            subplot(4,1,1)
            plot(d1)
            title(int2str(test.usechans(c)));

            %d1=mean(mean(test.segmentedEcog(1).zscore_separate(c,800:1200,:,:),3),4);
            %d2=mean(mean(test.segmentedEcog(2).zscore_separate(c,1:800,:,:),3),4);


            subplot(4,1,2)
            plot(d2);

            subplot(4,1,3)
            plot(XR);
            line([1600 1600],[-200 200]);
                axis tight

            [~,idx]=max(XR);
            stackXR(t,:)=XR;
            title(int2str(idx-1600));
            %input('n')
        end
            imagesc(stackXR);

            subplot(4,1,4)
            plot(mean(stackXR));
            input('n')
    end
end
%%

for i=1:N
    for s=1:size(rstim{i},2)
            tmp=corrcoef(rstim{i}(:,s),aud{i}(s,:)')
            rTime(s)=tmp(1,2)
    end
    subplot(2,2,1)
    imagesc(rstim{i})
    title(Labels{i})
    subplot(2,2,2)
    imagesc(aud{i}')
    subplot(2,2,3)
    plot(rTime)
    hold on
    plot(mean(rstim{i}),'r')
    plot(mean(aud{i}'),'g')
    hold off
    input('n')
end
