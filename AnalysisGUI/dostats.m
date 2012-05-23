a=6;
b=7;

a=1;
b=2;

condition1=squeeze(mean(handles.segmentedEcogGrouped{a},3));
condition2=squeeze(mean(handles.segmentedEcogGrouped{b},3));


channelsOfInterest=[1];
channelsOfInterest=[36,37,38,40]
stats_type=2;

[ps,ps2,ERPs]=doStatistics_GUI(channelsOfInterest,stats_type,200,condition1,condition2);
[ps,ps2,ERPs]=doStatistics_GUI(channelsOfInterest,stats_type,200,zscore_stack1,zscore_stack2);


for x=1:length(channelsOfInterest)%1:256
    chcnt=channelsOfInterest(x)
     i=chcnt;
sig1=find(ps(chcnt,:,1)<0.05 & ps(chcnt,:,1)~=0);
sig2=find(ps(chcnt,:,2)<0.05 & ps(chcnt,:,2)~=0);
sig=find(ps2(chcnt,:)<0.05 & ps2(chcnt,:)~=0);
            
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
            
            
            
            
            
            line(vertcat(sig,sig),vertcat(ERPs(chcnt,sig,1),ERPs(chcnt,sig,2)),'linewidth',1,'color',[0 1 1]);
            hold on
            ERPs_to_plot=ERPs(chcnt,:,:);
            plot(ERPs(chcnt,:,1))
            %hold on
            plot(ERPs(chcnt,:,2),'r')
            
            
            
            if ~isempty(sig1)
                plot(sig1,2,'g-')
            end
            if ~isempty(sig2)
                plot(sig2,1,'r-') 
            end
            text(1,0,num2str(i))

            axis([0 1000 -10 200])
end