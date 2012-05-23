function ps2_raw=twoConditionStats(zscore_stack1,zscore_stack2,test_samps,ps_raw1,ps_raw2,zscore_baseline1,zscore_baseline2)
%%do 2 condition statistics 
%%LENGTH BOTH CONDITIONS PER TRIAL MUST BE EQUAL

%%INPUTS: 
%%ZSCORE_STACK1= N BY S MATRIX OF ZSCORES CONDITION 1
%%ZSCORE_STACK2= N BY S MATRIX OF ZSCORES CONDITION 2 
%%TEST SAMPLES= ARRAY OF SAMPLES TO TEST FOR SIGNIFICANCE
%%PS_RAW1= RAW P-VALUES FOR CONDITION 1
%% PS_RAW2= RAW P-VALUES FOR CONDITION 2
%%ZSCORE_BASELINE1= BASELINE FOR CONDITION 1 
%%  A) IF PRE-EVENT, INPUT 1 VALUE (LENGTH OF BASELINEIN SAMPLES)
%%  B) IF BASELINE SEPARATE, INPUT 1D ARRAY OF BASELINE VALUES
%%ZSCORE_BASELINE2= BASELINE FOR CONDITION 2
%% SAME CONVENTION AS ZSCORE_BASELINE1

%%OUTPUT:
%%PS2_RAW: RAW P VALUE 



%{
Original code, kind of confusing, but need to double check if new code is the same
            for bi=1:nboot2
                trs=ceil(rand(1,neps2)*neps2)+neps1;
                boot_tsbs=ceil(rand(1,neps2)*(zsn-4))+2;
                boot_tsbs=neps*(boot_tsbs-1)+trs;
                
                boot_means(bi)=sum(sts(boot_tsbs))/neps2;
                
                trs=ceil(rand(1,neps1)*neps1);
                boot_tsbs=ceil(rand(1,neps1)*(zsn-4))+2;
                boot_tsbs=neps*(boot_tsbs-1)+trs;
                
                boot_means(bi)=boot_means(bi)-sum(sts(boot_tsbs))/neps1;
            end
%}
nboot2=10000;
boot_means=zeros([1 nboot2]);

neps1=size(zscore_stack1,1);
neps2=size(zscore_stack2,1);

if length(zscore_baseline1)==1& length(zscore_baseline2)==1
    tmp=zscore_stack1(:,1:zscore_baseline1);
    baseline1=reshape(tmp,1,numel(tmp));
    tmp=zscore_stack2(:,1:zscore_baseline2);
    baseline2=reshape(tmp,1,numel(tmp));
else
    baseline1=zscore_baseline1;
    zscore_baseline1=length(zscore_baseline1);
    baseline2=zscore_baseline2;
    zscore_baseline2=length(zscore_baseline2);
end    

%bootstrap distribution of differences in baseline to get "good enough"
%belt
for bi=1:nboot2
    rand_idx=ceil(rand(1,zscore_baseline1)*zscore_baseline1);
    boot_means1(bi)=mean(baseline1(rand_idx));
    rand_idx=ceil(rand(1,zscore_baseline2)*zscore_baseline2);
    boot_means2(bi)=mean(baseline2(rand_idx));
end

bse=sqrt(sum((mean(boot_means1)-boot_means1).^2)/(nboot2-1));%delta between cond1 and 2
diffERP=mean(zscore_stack1,1)-mean(zscore_stack2,1);

%test only latencies that exceed delta, and there is
%significance from baseline for single condition analyses
tmps=intersect(find(abs(diffERP(1:end))>bse & (ps_raw1<.05 | ps_raw2<.05)),test_samps);
sts=vertcat(zscore_stack1,zscore_stack2);


ps2=repmat(NaN,[1,size(zscore_stack1,2)]); 

for s=tmps
    tmp1=sts(1:neps1,s); %all c1 at latency s
    m1=sum(tmp1)/neps1; %mean of tmp1
    tmp2=sts(neps1+1:end,s); %all c2 at latency s
    m2=sum(tmp2)/neps2; %mean of tmp2
    m=m2-m1;%m=0 if H0 is true (no diff between cases
    
    %bootstrap distribution of difference between 2 conditions
    for bi=1:nboot2
        boot_means(bi)=sum(tmp2(ceil(rand(1,neps2)*neps2)))/neps2;
        boot_means(bi)=boot_means(bi)-sum(tmp1(ceil(rand(1,neps1)*neps1)))/neps1;
    end
    
    %calculated ASL (p-value)
    if diffERP(s)>0,
        ps2(s)=length(find(boot_means<bse))/nboot2;
    else ps2(s)=length(find(boot_means>-bse))/nboot2;
    end
    
    if ps2(s)==0,
        ps2(s)=1/nboot2;
    end
    if ps2(s)==1,
        ps2(s)=(nboot2-1)/nboot2;
    end
    
    %ASL bias-corrected and accelerated
    z0=length(find(boot_means<m))/nboot2;
    z0=-sqrt(2).*erfcinv(2*z0); w0=-sqrt(2).*erfcinv(2*ps2(s));
    a=z0;
    ps2(s)=.5*erfc(-((w0-z0)/(1+a*(w0-z0))-z0)./sqrt(2));
end
ps2_raw=2*min(ps2,1-ps2);
