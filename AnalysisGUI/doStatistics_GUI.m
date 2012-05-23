function [ps,ps2,ERPs]=doStatistics_GUI(channelsOfInterest,stats_type,zsn, condition1,condition2)
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

%create condition matrix
neps1=size(condition1,3);
if nargin==5
    nboot2=10000;
    neps2=size(condition2,3);
    second_cond=1;
    ps=repmat(NaN,[length(channelsOfInterest),size(sts,2),2]); 
else
	neps2=0;
    condition2=[];
    ps=repmat(NaN,[length(channelsOfInterest),size(sts,2),1]); 
end
neps=neps1+neps2;
test_samps=zsn+1:zsn+size(condition1,2)-zsn;
sts_all=cat(3,condition1,condition2);

if stats_type==2
    ps2=repmat(NaN,[length(channelsOfInterest),size(ERPs,2)]);
end
%f=figure;
for i=1:length(channelsOfInterest)
    
    chcnt=channelsOfInterest(i);
    sts1=squeeze(sts_all(chcnt,:,:))';
    bslevs(chcnt,1)=sum(sum(sts1(1:neps1,1:zsn)))/(neps1*zsn);%mean of all samples in baseline interval

    sts=zeros(neps,size(sts1,2));
    sts(1:neps1,:)=100*sts1(1:neps1,:)./bslevs(chcnt,1)-100;    
    
    %gets average event related AA (% change)
    ERPs(i,:,1)=sum(sts(1:neps1,:))./neps1; 
    
     
     if second_cond==1
         bslevs(chcnt,2)=sum(sum(sts1(neps1+1:end,1:zsn)))/(neps2*zsn);
         sts(neps1+1:end,:)=100*sts1(neps1+1:end,:)./bslevs(chcnt,2)-100;
         ERPs(i,:,2)=sum(sts(neps1+1:end,:))./neps2;
     end
     
    %{
    figure
    ERPs1=squeeze(ERPs(i,:,1));
    ERPs2=squeeze(ERPs(i,:,2));
    plot(ERPs1)
    hold on
    plot(ERPs2)
    %}

    %%
    %perform single condition statistical analysis on condition 1
    boot_means=zeros([1 nboot]);
    
    %build bootstrap distribution of baseline
    for bi=1:nboot
        %This is to randomly select the index within all baseline latencies
        %for all trials in a condition
        trs=ceil(rand(1,neps1)*neps1); 
        boot_tsbs=ceil(rand(1,neps1)*(zsn-4))+2;
        boot_tsbs=neps*(boot_tsbs-1)+trs; 
        boot_means(bi)=sum(sts(boot_tsbs))/neps1;%Get the bootstrap distribution of be baseline mean
    end
    bse=sqrt(sum((mean(boot_means)-boot_means).^2)/(nboot-1));%Calculate the standard error of the bootstrap distribution of baseline mean (delta)
    tmps=intersect(find(abs(ERPs(chcnt,:,1))>bse),test_samps);%Find indices where signal exceeds the 'good enough' belt. Only these samples will be tested for significance.
    tmpJ=zeros([1 neps1]);
    
    for s=tmps %test each latency at a time
                tmp1=sts(1:neps1,s); %Get vector of all repetitions at that latency
                m1=sum(tmp1)/neps1;%Average of signal at latency
                for bi=1:nboot
                    %Pick values from vector at random with replacement,
                    %for each bootstrap replication, then get the mean.
                    %Will build the bootstrap distribution.
                    boot_means(bi)=sum(tmp1(ceil(rand(1,neps1)*neps1)))/neps1;
                end
                if ERPs(chcnt,s,1)>0, 
                    ps(chcnt,s,1)=length(find(boot_means<bse))/nboot;%percentage of bootstrap means within delta (chance of erroneously labeling latency as significant)
                else
                    ps(chcnt,s,1)=length(find(boot_means>-bse))/nboot; 
                end
                if ps(chcnt,s,1)==0, 
                    ps(chcnt,s,1)=1/nboot;
                end
                if ps(chcnt,s,1)==1, 
                    ps(chcnt,s,1)=(nboot-1)/nboot; 
                end
                z0=length(find(boot_means<m1))/nboot;
                z0=-sqrt(2).*erfcinv(2*z0); %z0=norminv(z0,0,1);
                w0=-sqrt(2).*erfcinv(2*ps(chcnt,s,1)); %w0=norminv(ps(chcnt,s,1),0,1);
                %a=z0; %for now, since this is good estimate in one-parameter families
                tmpJ(neps1)=sum(tmp1(1:neps1-1))/(neps1-1);
                for ep=1:neps1-1, tmpJ(ep)=sum(tmp1([1:ep-1 ep+1:neps1]))/(neps1-1); end
                a=sum((m1-tmpJ).^3)/(6*(sum((m1-tmpJ).^2)^1.5));
                ps(i,s,1)=.5*erfc(-((w0-z0)/(1+a*(w0-z0))-z0)./sqrt(2)); %ps(chcnt,s,1)=normcdf((w0-z0)/(1+a*(w0-z0))-z0);
    end
    ps(i,:,1)=2*min(ps(i,:,1),1-ps(i,:,1));

    sig1=find(ps(i,:,1)<0.05 & ps(i,:,1)~=0);
    %{
    figure
    plot(ERPs(chcnt,:,1))
    hold on
    plot(sig1,2,'g-')
    %}

%%
    %if second condition exists, perform single condition statistical
    %analysis on condition 2 
    if second_cond==1
        boot_means=zeros([1 nboot]);
        for bi=1:nboot
            trs=ceil(rand(1,neps1)*neps1); 
            boot_tsbs=ceil(rand(1,neps1)*(zsn-4))+2;
            boot_tsbs=neps*(boot_tsbs-1)+trs; 
            boot_means(bi)=sum(sts(boot_tsbs))/neps1;
        end
        bse=sqrt(sum((mean(boot_means)-boot_means).^2)/(nboot-1));
        tmps=intersect(find(abs(ERPs(chcnt,:,1))>bse),test_samps);
        tmpJ=zeros([1 neps1]);
        boot_means=zeros([1 nboot]);
        for bi=1:nboot
            trs=ceil(rand(1,neps2)*neps2)+neps1; boot_tsbs=ceil(rand(1,neps2)*(zsn-4))+2;
            boot_tsbs=neps*(boot_tsbs-1)+trs; boot_means(bi)=sum(sts(boot_tsbs))/neps2;
        end
        bse=sqrt(sum((mean(boot_means)-boot_means).^2)/(nboot-1));
        tmps=intersect(find(abs(ERPs(chcnt,:,2))>bse),test_samps);
        tmpJ=zeros([1 neps2]); %holds jacknife values for estimate of a
        for s=tmps
             tmp2=sts(neps1+1:end,s); m2=sum(tmp2)/neps2;
            for bi=1:nboot
                boot_means(bi)=sum(tmp2(ceil(rand(1,neps2)*neps2)))/neps2;
            end
            if ERPs(chcnt,s,2)>0, ps(chcnt,s,2)=length(find(boot_means<bse))/nboot;
            else ps(chcnt,s,2)=length(find(boot_means>-bse))/nboot; end
            if ps(chcnt,s,2)==0, ps(chcnt,s,2)=1/nboot; end
            if ps(chcnt,s,2)==1, ps(chcnt,s,2)=(nboot-1)/nboot; end
            z0=length(find(boot_means<m2))/nboot;
            z0=-sqrt(2).*erfcinv(2*z0); w0=-sqrt(2).*erfcinv(2*ps(chcnt,s,2));
            tmpJ(neps2)=sum(tmp2(1:neps2-1))/(neps2-1);
            for ep=1:neps2-1, tmpJ(ep)=sum(tmp2([1:ep-1 ep+1:neps2]))/(neps2-1); end
            a=sum((m2-tmpJ).^3)/(6*(sum((m2-tmpJ).^2)^1.5));
            ps(chcnt,s,2)=.5*erfc(-((w0-z0)/(1+a*(w0-z0))-z0)./sqrt(2));
        end
        ps(i,:,2)=2*min(ps(i,:,2),1-ps(i,:,2));
        sig2=find(ps(i,:,2)<0.05 & ps(i,:,2)~=0);
        %{
        figure
        plot(ERPs(chcnt,:,2))
        hold on
        plot(sig2,1,'r-')
        %}


        if stats_type==2;
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

%{

            sig=find(ps2(chcnt,:)<0.05 & ps2(chcnt,:)~=0);


            figure(f);
             m=floor(i/16);
            n=rem(i,16);

            if n==0
                n=16;
                m=m-1;
            end

            p(1)=6*(n-1)/100+.03;
            p(2)=6.2*(15-m)/100+0.01;

            p(3)=.055;
            p(4)=.055; 
            h=subplot('Position',p);
            
            
            
            
            
            
            ERPs_to_plot=ERPs(chcnt,:,:);
            plot(ERPs(chcnt,:,1))
            hold on
            plot(ERPs(chcnt,:,2),'k')

            line(vertcat(sig,sig),vertcat(ERPs(chcnt,sig,1),ERPs(chcnt,sig,2)),'linewidth',1,'color',[1,0,1]);
            plot(sig1,2,'g-')
            plot(sig2,1,'r-') 
            %title(sprintf('Channel%d',chcnt))
            axis tight
%}
        end
    end
end


    %{
    figure
    plot(ERPs(chcnt,:,1))
    hold on
    plot(ERPs(chcnt,:,2))
    line(vertcat(sig,sig),vertcat(ERPs(chcnt,sig,1),ERPs(chcnt,sig,2)),'linewidth',1,'color',[0,0,0])

    sig=find(ps(chcnt,:,2)<0.05 & ps(chcnt,:,2)~=0);
    plot(sig,1,'r')
    sig2=find(ps(chcnt,:,1)<0.05 & ps(chcnt,:,1)~=0);
    plot(sig2,2,'g')
%}