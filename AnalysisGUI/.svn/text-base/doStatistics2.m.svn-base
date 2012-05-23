function output=doStatistics2(segmentedEcog,channelsOfInterest,conditionsOfInterest,zsn,stats_type)
%PURPOSE: procedure for non-parametric statistical assessment of the
%high-gamma analytic amplitude (AA) results. Begins by calculating percent
%change from baseline **can change later to accept zscore**

%There are two statistical tests to perform on the data:

%i) single-condition question, where it is asked if the AA at some latency is significantly 
%different from the baseline AAs for the same condition. Uses the bootstrap standard error as a "good-enough"
%belt for defining the baseline null hypothesis.

%ii) two-condition or comparison question, where it 
%is asked if the AA at some latency is significantly different from the AA at the same latency for another condition. 
%The 2-cond comparison also uses the bse as a "good-enough" belt and tests
%the bootstrap confidence intervals against the bse.

%INPUTS:
%channelsOfInterest: 1D array of channels you want to perform statistics on
%stats_type: 1= perform single condition test, 
%            2= perform 2-condition test
%zsn: # of samples of baseline
%condition1: CxSxN1 matrix of segmented ecog HG AA aligned at event, where C=channels, N1 is # of trials for condition 1,
%and S is samples. 
%condition2: CxSxN2 matrix of segmented ecog HG AA aligned at event, where C=channels, N2 is # of trials for condition 2,
%and S is samples. If not doing 2-condition test, condition2 input not
%necessary.             

%OUTPUTS
%ps: raw p-value of single condition tests
%ps2: raw p-value of 2-condition tests
%ERPs: event related potentials (% change)
%%
%set number of bootstrap iterations
nboot=10000;

for c=conditionsOfInterest
    for i=channelsOfInterest
        chcnt=i;
        %create condition matrix
        neps=size(segmentedEcog{c},3);
        test_samps=zsn+1:zsn+size(segmentedEcog{c},2)-zsn;
        sts1=squeeze(segmentedEcog{c}(i,:,:))';
        %output(c).ps(i,:,:)=repmat(NaN,[length(channelsOfInterest),size(segmentedEcog{c},2),neps]);
    
        baseline=sts1(1:neps,1:zsn);
        bslevs=sum(sum(baseline));%mean of all samples in baseline interval
        sts=100*sts1./bslevs-100;    

        %gets average event related AA (% change)
        output(c).ERPs(i,:)=sum(sts)./neps; 

        %%
        %perform single condition statistical analysis on condition 1
        boot_means=zeros([1 nboot]);

        %build bootstrap distribution of baseline
        for bi=1:nboot
            %This is to randomly select the index within all baseline latencies
            %for all trials in a condition
            boot_tsbs=ceil(rand(1,zsn*neps)*zsn*neps); 
            boot_means(bi)=mean(baseline(boot_tsbs));%Get the bootstrap distribution of be baseline mean
        end
        bse=sqrt(sum((mean(boot_means)-boot_means).^2)/(nboot-1));%Calculate the standard error of the bootstrap distribution of baseline mean (delta)
        tmps=intersect(find(abs(output(c).ERPs(i,:))>bse),test_samps);%Find indices where signal exceeds the 'good enough' belt. Only these samples will be tested for significance.
        tmpJ=zeros([1 neps]);

        for s=tmps %test each latency at a time
                    tmp1=sts(1:neps,s); %Get vector of all repetitions at that latency
                    m1=mean(tmp1);%Average of signal at latency
                    for bi=1:nboot
                        %Pick values from vector at random with replacement,
                        %for each bootstrap replication, then get the mean.
                        %Will build the bootstrap distribution.
                        boot_means(bi)=sum(tmp1(ceil(rand(1,neps)*neps)))/neps;
                    end
                    if output(c).ERPs(i,:)>0, 
                        ps(s)=length(find(boot_means<bse))/nboot;%percentage of bootstrap means within delta (chance of erroneously labeling latency as significant)
                    else
                        ps(s)=length(find(boot_means>-bse))/nboot; 
                    end
                    if ps(s)==0, 
                        ps(s)=1/nboot;
                    end
                    if ps(s)==1, 
                        ps(s)=(nboot-1)/nboot; 
                    end
                    z0=length(find(boot_means<m1))/nboot;
                    z0=-sqrt(2).*erfcinv(2*z0); %z0=norminv(z0,0,1);
                    w0=-sqrt(2).*erfcinv(2*ps(s)); %w0=norminv(ps(chcnt,s,1),0,1);
                    %a=z0; %for now, since this is good estimate in one-parameter families
                    tmpJ(neps)=sum(tmp1(1:neps-1))/(neps-1);
                    for ep=1:neps-1, tmpJ(ep)=sum(tmp1([1:ep-1 ep+1:neps]))/(neps-1); end
                    a=sum((m1-tmpJ).^3)/(6*(sum((m1-tmpJ).^2)^1.5));
                    ps(s)=.5*erfc(-((w0-z0)/(1+a*(w0-z0))-z0)./sqrt(2)); %ps(chcnt,s,1)=normcdf((w0-z0)/(1+a*(w0-z0))-z0);
        end
        output(c).ps(i,:)=2*min(ps,1-ps);
    end
end
%{
%Make into nested function
function doStats_2cond
%Performs 2-condition tests between condition1 and condition2
            boot_means=zeros([1 nboot2]);
            for bi=1:nboot2
                trs=ceil(rand(1,neps2)*neps2)+neps1; boot_tsbs=ceil(rand(1,neps2)*(zsn-4))+2;
                boot_tsbs=neps*(boot_tsbs-1)+trs; boot_means(bi)=sum(sts(boot_tsbs))/neps2;    
                trs=ceil(rand(1,neps1)*neps1); boot_tsbs=ceil(rand(1,neps1)*(zsn-4))+2;
                boot_tsbs=neps*(boot_tsbs-1)+trs; boot_means(bi)=boot_means(bi)-sum(sts(boot_tsbs))/neps1;
            end
            bse=sqrt(sum((mean(boot_means)-boot_means).^2)/(nboot-1));
            diffERP=ERPs(chcnt,:,2)-ERPs(chcnt,:,1);
            tmps=intersect(find(abs(diffERP(1:end))>bse & (ps(chcnt,:,1)<.05 | ps(chcnt,:,2)<.05)),test_samps);
            for s=tmps
                tmp1=sts(1:neps1,s); m1=sum(tmp1)/neps1;
                tmp2=sts(neps1+1:end,s); m2=sum(tmp2)/neps2; m=m2-m1;
                for bi=1:nboot2
                    boot_means(bi)=sum(tmp2(ceil(rand(1,neps2)*neps2)))/neps2;
                    boot_means(bi)=boot_means(bi)-sum(tmp1(ceil(rand(1,neps1)*neps1)))/neps1;
                end
                if diffERP(s)>0, ps2(chcnt,s)=length(find(boot_means<bse))/nboot2;
                else ps2(chcnt,s)=length(find(boot_means>-bse))/nboot2; end
                if ps2(chcnt,s)==0, ps2(chcnt,s)=1/nboot2; end
                if ps2(chcnt,s)==1, ps2(chcnt,s)=(nboot2-1)/nboot2; end
                z0=length(find(boot_means<m))/nboot2;
                z0=-sqrt(2).*erfcinv(2*z0); w0=-sqrt(2).*erfcinv(2*ps2(chcnt,s));
                a=z0;
                ps2(chcnt,s)=.5*erfc(-((w0-z0)/(1+a*(w0-z0))-z0)./sqrt(2));
            end
            ps2(i,:)=2*min(ps2(i,:),1-ps2(i,:));
%}