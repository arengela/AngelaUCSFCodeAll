%% INITIALIZE
allfiles=    {
    'E:\DelayWord\EC18\EC18_B1';
    'E:\DelayWord\EC18\EC18_B2';
    'E:\DelayWord\EC20\EC20_B18';
    'E:\DelayWord\EC20\EC20_B23';
    'E:\DelayWord\EC20\EC20_B54';
    'E:\DelayWord\EC20\EC20_B64';
    'E:\DelayWord\EC20\EC20_B67';
    'E:\DelayWord\EC21\EC21_B1';
    'E:\DelayWord\EC22\EC22_B1'
    'E:\DelayWord\EC23\EC23_B1'
    'E:\DelayWord\EC24\EC24_B2'

    'E:\DelayWord\EC24b\EC24_B1'
    'E:\DelayWord\EC24b\EC24_B3'
    }
load('E:\DelayWord\wordgroups')
load('E:\DelayWord\brocawords')

lh=wordgroups.lh
lh=1:40

baseline{1}='E:\DelayWord\EC18\EC18_rest'
baseline{2}='E:\DelayWord\EC18\EC18_rest'
baseline{8}=    'E:\DelayWord\EC21\EC21_B2';
baseline{9}='E:\DelayWord\EC22\EC22_B2'
baseline{10}='E:\DelayWord\EC23\EC23_B2'
 baseline{11}='E:\DelayWord\EC24\EC24_B3'

 baseline{12}='E:\DelayWord\EC24b\EC24_B2'

%seg={[repmat(41,[1 40]);1:40],[1:40;repmat(42,[1 40])],[42;43],[43;44],[44;45]}
seg={[repmat([41],[1 length(lh)]);lh;lh],[lh;repmat([42],[1 length(lh)]);lh],[repmat([42;43],[1 length(lh)]);lh],[repmat([43;44],[1 length(lh)]);lh],[repmat([44;45],[1 length(lh)]);lh]}
%seg={[repmat([41],[1 length(lh)]);lh],[lh;repmat([42],[1 length(lh)])],[repmat([42],[1 length(lh)]);lh],[repmat([43],[1 length(lh)]);lh],[repmat([44],[1 length(lh)]);lh]}
seg={[repmat([41],[1 length(lh)]);lh],[lh;repmat([42],[1 length(lh)])],[repmat([42],[1 length(lh)]);lh],[repmat([43],[1 length(lh)]);lh],[repmat([44],[1 length(lh)]);lh],[45;41]}

%% Load segments 
n=9
start=[ 1    33    65    97   129   161   193   225]

freq{1}=frequencybands.theta;
freq{2}=frequencybands.alpha;
freq{3}=frequencybands.beta;
freq{4}=frequencybands.gamma;
freq{5}=frequencybands.hg;


%%
n=10
N=20
for e=[ 3 4 5]
    for cidx=1%2:8
        %ch=start(cidx):start(cidx)+63;
        ch=1:256
        test=SegmentedData([allfiles{n} '/HilbAA_70to150_8band']);
        %test=SegmentedData([allfiles{n} '/HilbReal_4to200_40band']);

        test.usechans=ch;
        test.channelsTot=length(test.usechans);
        %test.segmentedDataEvents40band(seg([2 5]),{[3000 3000],[3000 3000]},'keep',N,'aa',31:38)
        test.segmentedDataEvents40band(seg(e),{[2500 2500]},'keep',[],'aa',31:38)
        %test.segmentedDataEvents8band(seg(e),{[2500 2500]},'keep',[])
        
        %test.loadBaselineFolder([baseline{n} '/HilbReal_4to200_40band'])
        test.loadBaselineFolder([baseline{n} '/HilbAA_70to150_8band'])
        test.Artifacts.badChannels=[];
        test.BaselineChoice='rest'
        test.Params.indplot=1;
        test.Params.indplot=0;
        %test.calcZscore;
        
        test.plotData('stacked')
        %test.usechans=1:2
        %test.segmentedDataEvents40band(seg(e),{[2500 2500]},'keep',[],'analog',1)
        
        %test.plotData('line')
        %test.plotData('stacked')
        %keyboard
        
        %%
        
%         %powerpoint_object=SAVEPPT2(save_file,'init')
%         int=40;
%         count=1
%         for t=600:int:2000-int
%             %subplot(4,5,count)
%             tseg=t:t+int;
%             d=mean(mean(test.segmentedEcog.zscore_separate(:,tseg,:,:),3),4);
%             %p=prctile(mean(d,2),85)
%             %c=find(mean(d,2)>p);
%             %visualizeGrid(1,['E:\General Patient Info\' test.patientID '\brain+grid_3Drecon_cropped.jpg'],1:256,d,.003)
% 
%             visualizeGrid(8,['E:\General Patient Info\' test.patientID '\brain+grid_3Drecon_cropped.jpg'],1:256,d,.003)
%             set(gcf,'Name',int2str(t))
%             title(int2str(t))
%             SAVEPPT2('ppt',powerpoint_object,'stretch','off');
%             %input('next\n')
%             count=count+1;
%         end
      %%  
        %test.plotData('spectrogram')
%         test.plotData('spectrogram')
%         for f=1:5
%             usef=freq{f};
%             for t=1:10
%                 %subplot(1,10,t)
%                 subplot('Position',[t*.1 .1 .09 .9])
%                 d=mean(mean(mean(test.segmentedEcog.zscore_separate(:,(t-1)*200+1:t*200-1,usef,:),4),2),3);
%                 d=detrend(d);
%                % keyboard
%                 %z=zscore(d);
%                 %z(find(z>3))=3;
%                 %z(find(z<-3))=-3;
%                 visualizeGrid(1,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',1:256,d,.004)
%                 title(['f= ' int2str(f) 't= ' int2str(t)])
%             end
%             saveppt2('ppt',powerpoint_object,'scale',true,'stretch',false,'Padding',[0 0 0 0]);              
%             %keyboard
%         end        
%         dos('cmd /c "echo off | clip"')

    end
end

%%
for e=3:6
    for cidx=1:8
        ch=start(cidx):start(cidx)+31;
        test=SegmentedData([allfiles{n} '/HilbReal_4to200_40band']);
    
        test.usechans=ch;
        test.channelsTot=length(test.usechans);
        %test.segmentedDataEvents40band({[43;44]},{[4000 6000]},'keep',[])
                test.segmentedDataEvents40band({[42;43]},{[4000 6000]},'keep',[])
        test.Artifacts.badChannels=[];
                test.Artifacts.badTimeSegments=[];

        test.loadBaselineFolder([baseline{n} '/HilbReal_4to200_40band'])
        test.BaselineChoice='ave'
        test.Params.indplot=1;
        %test.calcZscore;
        test.plotData('spectrogram')
  
       
        dos('cmd /c "echo off | clip"')

    end
end

%% View amplitudes on brain withots

%figure
int=100;
count=1
for t=1:int:2000-int
    subplot(4,5,count)
    tseg=t:t+int;
    d=test.segmentedEcog.zscore_separate(:,tseg);
    visualizeGrid(7,['E:\General Patient Info\' test.patientID '\brain+grid_3Drecon_cropped.jpg'],1:256,d,.01)
    set(gcf,'Name',int2str(t))
    title(int2str(t))
    %input('next\n')
    count=count+1;
end

%% Load downsampled data
test=SegmentedData([allfiles{n} '/Downsampled400']);
test.usechans=1:256;
test.channelsTot=length(test.usechans);

test.segmentedDataEvents8band(seg(2),{[2500 2500]},'keep',[])

test.loadBaselineFolder([baseline{n} '/Downsampled400'])
test.BaselineChoice='ave'

%% LOAD VARIABLES
load E:\DelayWord\frequencybands.mat
load('E:\DelayWord\wordgroups')

load('E:\DelayWord\EC22\EC22_B1\activech')
load('E:\General Patient Info\EC22\regdata.mat')
load E:\DelayWord\EC22\EC22_B2\PLV\baselinePLVmean

load('E:\DelayWord\EC18\EC18_B1\activech')
load('E:\General Patient Info\EC18\regdata.mat')
load E:\DelayWord\EC18\EC18_rest\PLV\baselinePLV


load('E:\DelayWord\EC23\EC23params.mat')



%% INITIALIZE PPT FOR AUTO COPY
save_file='C:\Users\Angela_2\Documents\Presentations\DelayWordAutoImages5.ppt'
powerpoint_object=SAVEPPT2(save_file,'init')

%% STATS 
load('E:\DelayWord\EC23\EC23params.mat')
load('E:\DelayWord\EC22\EC22params.mat')

 e=2
 %visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2,57-(2:56),[],pkval(sortt),[])
ch2=unique([EC23params.event(5).activech EC23params.event(4).activech EC23params.event(2).activech]) ; %activech(c);
%ch2=[EC23params.event(e).activech ]
%ch2=setdiff(EC23params.event(5).activech, EC23params.event(2).activech) ;

sp=1

c=1
e=2
eidx2=[2 4 5]
holdsig=zeros(1,length(ch2))
%%

for n=10%[1 2 9]   
    test=SegmentedData([allfiles{n} '/HilbAA_70to150_8band']);
    for c=c:length(ch2)
        %load object
        ch=ch2(c);
        test.usechans=ch;
        test.channelsTot=length(test.usechans)
        test.Artifacts.badChannels=[];
        test.Artifacts.badTimeSegments=[];
        test.Params.sortidx=1;
        
        %Calc baseline
        test.loadBaselineFolder([baseline{n} '/HilbAA_70to150_8band']);
        test.ecogBaseline.data=test.ecogBaseline.data(:,1.5e4:end,:,:);
        test.BaselineChoice='PreEvent';
        test.Params.baselineMS=[500 1000];
        test.Params.indplot=1;
        m=mean(test.ecogBaseline.data(:,:,:,:),3);
        baselinezscore=(m-repmat(mean(test.ecogBaseline.mean,2),[1 size(m,2)]))./repmat(mean(test.ecogBaseline.std,2),[1 size(m,2)]);
        test.Params.sorttrials=1;

        for i2=1      
            %load segments    
            test.segmentedDataEvents40band(seg(:,[2,4,5]),{[2000 2000],[2000 2000],[2000 2000]},'keep',[],'aa',31:38)
            test.calcZscore;
            
            for eidx=1:3
                %delete bad trials
                usetrials=setdiff(1:size(test.segmentedEcog(eidx).data,4),badtrials);
                test.segmentedEcog(eidx).data=test.segmentedEcog(eidx).data(:,:,:,usetrials);
                test.segmentedEcog(eidx).zscore_separate=test.segmentedEcog(eidx).zscore_separate(:,:,:,usetrials);
                test.segmentedEcog(eidx).rt=test.segmentedEcog(eidx).rt(usetrials);
                test.segmentedEcog(eidx).event=test.segmentedEcog(eidx).event(usetrials,:);
                
                %resort data
                 e=eidx2(eidx)
                wo=cell2mat(test.segmentedEcog(eidx).event(:,7))
                we=cell2mat(test.segmentedEcog(eidx).event(:,9))
                rt=we-wo;
                [a,b]=sort(rt)
                test.segmentedEcog(eidx).data=test.segmentedEcog(eidx).data(:,:,:,b);
                test.segmentedEcog(eidx).zscore_separate=test.segmentedEcog(eidx).zscore_separate(:,:,:,b);
                test.segmentedEcog(eidx).rt=test.segmentedEcog(eidx).rt(b);
                test.segmentedEcog(eidx).event=test.segmentedEcog(eidx).event(b,:);
                dest=[allfiles{n} '/pvalues/e' int2str(unique(seg{e}(1,:))) '/ch' int2str([ch])];
                  
                try
                    cd(dest)
                catch
                    mkdir(dest);
                    cd(dest);
                    
                end
                %psfilename='ps_nboot10000_slide_baseline3'
                psfilename='ps_nboot10000_wl_short'               
                psfilename='ps_nboot10000_wl_long'               
                save('ps_2cond_wl','ps_2cond_raw','-v7.3') 

                %psfilename='ps_nboot10000'
                if find(strmatch(psfilename,cellstr(ls)))
                    load(psfilename);
                else
                    %ps=singleConditionStats(squeeze(mean(test.segmentedEcog(eidx).zscore_separate(1,:,:,:),3))',[200 400],1:size(test.segmentedEcog(eidx).zscore_separate,2))
                    triallength=floor(size(test.segmentedEcog(eidx).zscore_separate,4));
                    
                    baselinezscore=squeeze(mean(test.segmentedEcog(1).zscore_separate(:,400:600,:,1:triallength/2),3));
                    baselinezscore1=reshape(baselinezscore,[1 size(baselinezscore,1)*size(baselinezscore,2)]);
                    [ps1,bse]=singleConditionStats(squeeze(mean(test.segmentedEcog(eidx).zscore_separate(1,:,:,1:triallength/2),3))',baselinezscore1,1:size(test.segmentedEcog(eidx).zscore_separate,2))
                    psfilename='ps_nboot10000_wl_short'               
                    save(psfilename,'ps1','-v7.3')    
                    
                      baselinezscore=squeeze(mean(test.segmentedEcog(1).zscore_separate(:,400:600,:,triallength/2+1:end),3));
                    baselinezscore2=reshape(baselinezscore,[1 size(baselinezscore,1)*size(baselinezscore,2)]);
                    [ps2,bse]=singleConditionStats(squeeze(mean(test.segmentedEcog(eidx).zscore_separate(1,:,:,triallength/2+1:end),3))',baselinezscore2,1:size(test.segmentedEcog(eidx).zscore_separate,2))
                    psfilename='ps_nboot10000_wl_long'               
                    save(psfilename,'ps2','-v7.3')                    
                    
                    ps_2cond_raw=twoConditionStats(squeeze(mean(test.segmentedEcog(eidx).zscore_separate(1,:,:,1:triallength/2),3))',squeeze(mean(test.segmentedEcog(eidx).zscore_separate(1,:,:,triallength/2+1:end),3))',[],ps1,ps2,baselinezscore1,baselinezscore2)
                    save('ps_2cond_wl','ps_2cond_raw','-v7.3') 
                end
                   
                psall=ps;
                data(c,:)=squeeze(mean(mean(test.segmentedEcog(1).zscore_separate,3),4))';
                data2=mean(test.segmentedEcog(eidx).zscore_separate,3);
                %%
                width=.15;
%                      subpos=[(.005+width)*(eidx-1) .1 width .8]
%                     subplot('position',subpos)%                     


%%
                %plot stacked
                figure(1)
                subplot(1,6,(eidx-1)*2+1)
                imagesc(squeeze(data2)',[-1 3])
                hold on
                for col=1:2:15
                    wo=cell2mat(test.segmentedEcog(eidx).event(:,1))
                    we=cell2mat(test.segmentedEcog(eidx).event(:,col))
                    rt=we-wo;
                    plot(rt*400+1000,1:size(test.segmentedEcog(eidx).rt,1),'k','LineWidth',1.4)
                end                     
                hl=line([800 800],[ 0 53])                
                set(hl,'LineStyle','--')
                set(hl,'Color','k')
                set(gca,'XTick',200:400:2000)
                
                set(gca,'XTickLabel',-2:1:2)
                title(['Ch ' int2str(ch)],'Fontsize',15)
                colormap(flipud(pink))

%%                
                hold off
                freezeColors;
                if ~mod(eidx,2)
                    set(gca,'YTickLabel',[])
                end
%%
                subplot(1,6,(eidx-1)*2+2)                
                %errorarea(mean(data2,4),std(data2,[],4)/sqrt(size(data2,4)))
                m=mean(data2,4);
                plot(m,'k','LineWidth',2)
                hold on
                alpha=.05;
                idx=find(~isnan(psall));
                [ps_fdr,h_fdr]=MT_FDR_PRDS(psall(idx),alpha);
                psall(idx)=ps_fdr;
                sigidx=find(psall<alpha & (psall~=0 & ~isnan(psall)));
                
                %plot sig pvalue
                start=find(sigidx>1,1,'first')
                for si=start:length(sigidx)
                    hl=line([sigidx(si) sigidx(si)], [-1 m(sigidx(si))])
                    set(hl,'Color','m')
                end
                plot(m,'k','LineWidth',2)
                hl=line([800 800],[-1 7])
                axis tight
                set(hl,'LineStyle','--')
                set(hl,'Color','k')
                title(['Ch ' int2str(ch)],'Fontsize',15)
                set(gca,'XTick',200:400:2000)
                set(gca,'XTickLabel',-2:1:2)
                
                %%
                                %Get first sig p value
                
                [a,ball]=find(psall(300:800)<alpha & (psall(300:800)~=0 & ~isnan(psall(300:800))))
                if length(ball)<40
                    [a,ball]=find(psall(800:end)<alpha & (psall(800:end)~=0 & ~isnan(psall(800:end))))
                    %keyboard
                    try
                       b=ball(1)
                        holdsig(c)=b+800;
                        %line([b b]+800,[-1 50])                        
                    end
                else
                    try
                        b=ball(1);
                        holdsig(c)=b+300;
                        %line([b b]+300,[-1 50])
                        
                    end
                end
                
                %%
                
                
                
                
                if ~mod(eidx,2)
                    set(gca,'YTickLabel',[])
                end
                %print -dmeta
                hold off
                pshold(c,:)=psall;
            end
            
            %subpos=[(.02+width)*4 .1 width .8]
            %subplot('position',subpos)
            %plot(ps)
            % visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2,max(thidx(sortt))-thidx(sortt),[],thidx(sortt),ch)
            
            SAVEPPT2('ppt',powerpoint_object,'stretch','off');
            
            figure(2)
            plot(squeeze(data2))
            
            hold off
            r='y'
            %r=input('next','s')
            
            if strcmp(r,'n')
                keyboard
            end
                            clf

            
        end
    end
    %clear test
end



%%
plotch=unique(plotch)
for p=1:length(plotch)
    
    
    plotch2(p)=find(EC23params.event(2).activech==plotch(p))

    plotch3{p}=int2str(plotch(p))
end
    legend(plotch3)
    %%
    
    for p=1:length(  plotch2)
        pidx=find(sortedidx==plotch2(p))
        plotch4(pidx)=plotch2(p)
    end
%%
    
%% PLV
%%%%%%%%%%%%%
%%%%%%%%%%%%%
%%%%%%%%%%%%%

% Choose Pairs of electrodes
C2=nchoosek(test.usechans,2)
C2(:,3)=C2(:,2)-C2(:,1);
idx=find(C2(:,3)>10)
sigch=C2(idx,1:2);


%% Calculate and Plot PLV significance per channel for all frequencies for selected events

test2=PLVtests('load new',9,[6 7 8],20,unique([activech{2}]));
%test.Params.sortdata=0;
%test.segmentedDataEvents40band(seg(1:5),{[2500 2500],[2500 2500],[2500 2500],[2500 2500],[2500 2500],[2500 2500]},'keep',[],'phase',f)
%%
buffer=[2500 2500]
segsize=(sum(buffer)/1000)*400
midline=(buffer(1)/1000)*400
set(gcf,'Color','w')
f=9;
for ch=1:size(sigch,1)

    usechan=[ find(test.usechans==sigch(ch,1)) find(test.usechans==sigch(ch,2))];
    chanNum=sigch(ch,:);
%     test3=segmentedData('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band',0)
%     test3.usechans=chanNum;
%     test3.channelsTot=length(test3.usechans);
%     test3.loadBaselineFolder('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','phase');    
%     baseline=test3.ecogBaseline.phase(:,:,f);
%     
%     for e=[1:3]
%         sigdata=zeros(40,2000);
%         plvdata=zeros(40,2000);
%         
%         for f=1:40
%             stack1=squeeze(test.segmentedEcog(e).phase(usechan(1),:,:,:));
%             stack2=squeeze(test.segmentedEcog(e).phase(usechan(2),:,:,:));
%             [ps,realPLV,bse]=PLVstats(squeeze(stack1(:,f,:))',squeeze(stack2(:,f,:))',baseline,bPLV(f),chanNum);            
%             idx=find(ps<=.001 & abs(realPLV)>=bse);
%             sigdata(f,idx)=realPLV(idx);
%             plvdata(f,:)=realPLV;            
%         end
        for e=[1:3]

                cd(['E:\DelayWord\EC22\EC22_B2\PLV\event' int2str(e)])
                load(['sigdata' int2str(chanNum)])
               load(['plvdata' int2str(chanNum)])

                %subplot(2,4,e+4)
                subplot(1,4,e)
                colormap(flipud(pink))
                imagesc(flipud(plvdata))
                %[x,y]=find(flipud(sigdata));
                %imagesc(flipud(sigdata))
                hold on
                %plot(y,x,'k.')
                contour(flipud(sigdata),.5,'k')
                try
                    plot(find(ps<=.001 & abs(realPLV)>=bse),0,'.k')
                end
                line([1000 1000],[0 41])
                
                hold off

        end

        subplot(1,4,4)
        visualizeGrid(2,['E:\General Patient Info\' test.patientID '\brain+grid_3Drecon_cropped.jpg'],chanNum)
        r=input('next','s');
        r='y'
        if strmatch(r,'y')
            saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        end
        dos('cmd /c "echo off | clip"')        
end
%%
load('E:\DelayWord\holdRatio.mat')
buffer=[2500 2500]
segsize=(sum(buffer)/1000)*400
midline=(buffer(1)/1000)*400
set(gcf,'Color','w')
f=9;
for ch=ch:size(sigch,1)
    usechan=[ find(test.usechans==sigch(ch,1)) find(test.usechans==sigch(ch,2))];
    chanNum=sigch(ch,:);
%     test3=segmentedData('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band',0)
%     test3.usechans=chanNum;
%     test3.channelsTot=length(test3.usechans);
%     test3.loadBaselineFolder('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','phase');    
      baseline=test.ecogBaseline.phase(usechan,:,f);
%     
%     for e=[1:3]
        sigdata=zeros(40,1600);
        plvdata=zeros(40,1600);
%       
        e=1
        for f=1:40
            stack1=squeeze(test.segmentedEcog(e).phase(usechan(1),:,:,:));
            stack2=squeeze(test.segmentedEcog(e).phase(usechan(2),:,:,:));
            
            for t=1:51
                XR(t,:)=xcorr(stack1(:,f,t),stack2(:,f,t));                
            end
            plot(mean(XR,1))
            
            [ps,realPLV,bse]=PLVstats(squeeze(stack1(:,f,:))',squeeze(stack2(:,f,:))',baseline,[],chanNum);            
            idx=find(ps<=.001 & abs(realPLV)>=bse);
            sigdata(f,idx)=realPLV(idx);
            plvdata(f,:)=realPLV;            
        end
%         
         %cd(['E:\DelayWord\EC22\EC22_B2\PLV\event' int2str(e)])
        % blocks=cellstr(ls);
        %load(['sigdata' int2str(chanNum)])
       %load(['plvdata' int2str(chanNum)])
        
        %subplot(2,4,e+4)
        subplot(1,4,e)
        colormap(jet)
        imagesc(flipud(plvdata))
        %[x,y]=find(flipud(sigdata));
        %imagesc(flipud(sigdata))
        hold on
        %plot(y,x,'k.')
        contour(flipud(sigdata),.5,'k')
        try
            plot(find(ps<=.001 & abs(realPLV)>=bse),0,'.k')
        end
        line([800 800],[0 41])
        hold off
    
    %plvhold(ch,:,:)=plvdata;
    subplot(1,4,4)
    visualizeGrid(2,['E:\General Patient Info\' test.patientID '\brain+grid_3Drecon_cropped.jpg'],chanNum)
    %r=input('next','s');
    r='y'
    if strmatch(r,'y')
    SAVEPPT2('ppt',powerpoint_object,'stretch','off');
    end
    %dos('cmd /c "echo off | clip"')
end

%%

%%
buffer=[2500 2500]
segsize=(sum(buffer)/1000)*400
midline=(buffer(1)/1000)*400
set(gcf,'Color','w')
f=9;
for ch=1:size(sigch,1)
    usechan=[ find(test.usechans==sigch(ch,1)) find(test.usechans==sigch(ch,2))];
    chanNum=sigch(ch,:);
%     test3=segmentedData('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band',0)
%     test3.usechans=chanNum;
%     test3.channelsTot=length(test3.usechans);
%     test3.loadBaselineFolder('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','phase');    
      baseline=test.ecogBaseline.phase(usechan,:,f);
%     
%     for e=[1:3]
        sigdata=zeros(40,1000);
        plvdata=zeros(40,1000); 

        e=1
        if 1%length(find(holdRatio(ch,:)>2))>=3
            for f=1:30
                 stack1=squeeze(test.segmentedEcog(e).phase(usechan(1),:,:,:));
                 stack2=squeeze(test.segmentedEcog(e).phase(usechan(2),:,:,:));
                 
                 for t=1:51
                     [lag,XR_base(t,:)]=cxcorr(stack1(400:800,f,t)',stack2(400:800,f,t)');
                     [lag,XR(t,:)]=cxcorr(stack1(800:1200,f,t)',stack2(800:1200,f,t)');
                 end
                 %subplot(1,4,1)
                 %             plot(mean(XR_base,1),'r')
                 %             hold on
                 %             plot(mean(XR,1))
                 %             hold off
                 %            [a_base,b]=max(mean(XR_base,1));
                 %
                              [a,b]=max(mean(XR,1));
                 %             title(['f' int2str(f) ' lag' num2str(lag(b)) ' ratio ' num2str(a/a_base)])
                 %holdRatio(ch,f)=a/a_base;
                 
                 shift=lag(b);
                 try
                     lagidx=1
                     for shift=0:200
                         shiftStack1=squeeze(stack1(401:1400,:,f))';
                         shiftStack2=squeeze(stack2(401+shift:1400+shift,:,f))';

                         [ps,realPLV,bse]=PLVstats(shiftStack1,shiftStack2,baseline,[],chanNum);
                         idx=find(ps<=.001 & abs(realPLV)>=bse);
                         PLV(ch).sigdata(f,idx)=realPLV(idx);
                         PLV(ch).plvdata(f,:)=realPLV;
                         PLV(ch).plv_shift(lagidx,f,:)=realPLV;
                         lagidx=lagidx+1;
                     end
                 end
            end
            %r=input('next','s');
        end
        if ~ isequal(plvdata,zeros(40,1000))
            subplot(1,4,e)
            colormap(jet)
            imagesc(flipud(plvdata))
            %[x,y]=find(flipud(sigdata));
            %imagesc(flipud(sigdata))
            hold on
            %plot(y,x,'k.')
            %contour(flipud(sigdata),.5,'k')
            try
                plot(find(ps<=.001 & abs(realPLV)>=bse),0,'.k')
            end
            line([800 800],[0 41])
            hold off       

            subplot(1,4,4)
            visualizeGrid(2,['E:\General Patient Info\' test.patientID '\brain.jpg'],chanNum)
            %r=input('next','s');
            r='y'
            if strmatch(r,'y')
              SAVEPPT2('ppt',powerpoint_object,'stretch','off');
            end
        end
end
    %dos('cmd /c "echo off | clip"')
end
%% Calculate PCA (one frequency over space)
%%%
%%%
n=9
f=34
test=SegmentedData([allfiles{n} '/HilbReal_4to200_40band']);
test.usechans=1:256;
test.channelsTot=length(test.usechans);
%test.loadBaselineFolder([baseline{n} '/HilbReal_4to200_40band']);
test.segmentedDataEvents40band(seg(1:6),{[2500 2500],[2500 2500],[2500 2500],[2500 2500],[2500 2500],[2500 2500]},'keep',[],'aa',f)
test.ecogBaseline.mean=ecogBaseline.mean(:,:,f);
test.ecogBaseline.std=ecogBaseline.std(:,:,f);
test.BaselineChoice='ave';
test.calcZscore

test.Params.indplot=0
test.plotData('stacked')



%% Plot First 4 PC's and location of highest weights
%figure
for e=1:6
    X=mean(test.segmentedEcog(e).zscore_separate,4);
    X(231,:)=0;
    X(55,:)=0;
    X(247,:)=0;

    [COEFF,SCORE,latent] = princomp(X(:,1:end)');
    for i=1:4
        %subplot(1,3,1)        
        subplot(4,3,(i-1)*3+1)
        plot(SCORE(:,i),'k')
        hl=line([1000 1000],[-4 4])
        title([ 'Frequency band ' int2str(f) '(' int2str(frequencybands.cfs(f)) 'Hz) PC' int2str(i)])
        
        %subplot(1,3,2)        
        subplot(4,3,(i-1)*3+2)
        visualizeGrid(1,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',1:256,COEFF(:,i))
        
        %subplot(1,3,3)
        subplot(4,3,(i-1)*3+3)
        visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',find(COEFF(:,i)>.1))
        %print -dmeta
        %r=input('next')
        r='n';
        if strcmp(r,'k')
            keyboard
        end
    end
    print -dmeta

    keyboard
end




%% PAC
%%%
%%%

n=9
e=[6 7 8]
test2=PLVtests('load new',n,e,20,unique([activech{2}]));
test2=PLVtests('load new',n,e,20,1:256]));

test2.doPACs
cd('E:\DelayWord\pacs\EC22')


test2.loadBaseline([baseline{n} '/HilbReal_4to200_40band'],'complex');
test2.doBaslinePACs


pac=test2.test.segmentedEcog(e).pac;
save('pac','pac','v7.3')

%% plot PAC
colormap(flipud(pink))
A=zeros(29,4*99);
e=1
for cidx=1:41
     meanPAC=[];
     A=zeros(29,4*99);

    for s=1:4
        meanPAC(s).d=nanmean(test2.test.segmentedEcog(e).pac(s).PAC(cidx,:,:,:),4)';
        
        %subplot(2,10,s)     
        A(:,(s-1)*99+1:s*99)=flipud(squeeze(nanmean(test2.test.segmentedEcog(e).pac(s).ave_amp_phase(cidx,:,:,:,:),4)));
        %imagesc(flipud(squeeze(nanmean(test2.test.segmentedEcog(e).pac(s).ave_amp_phase(cidx,:,:,:,:),4))))
        title(['Ch' int2str(test2.test.usechans(cidx)) ' s' int2str(s)])
        
        
        
        %subplot(2,10,s+10)
        %visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',test2.test.usechans(cidx))

        
        
        %input('next')
    end
    
    %baselinePhA=imagesc(flipud(squeeze(nanmean(test2.test.ecogBaseline.pac(s).ave_amp_phase(cidx,:,:,:,:),4))))
    baselinePACmean=mean(test2.test.ecogBaseline.pac(1).PAC(cidx,:,:,:),4);
    %baselinePACstd=std(test2.test.ecogBaseline.pac(1).PAC(cidx,:,:,:),[],4);
   
    subplot(2,10,1:4)
    imagesc(A)
    set(gca,'XTick',[0:99:1000])
    set(gca,'XGrid','on')
    set(gca,'XGrid','on')
    set(gca,'GridLineStyle','--')
    set(gca,'LineWidth',2) 
    hl=line([99*4 99*4],[0 41])
    set(hl,'Color','r')
    set(hl,'LineWidth',3)
    set(gca,'YTickLabel',30:-5:0)

    subplot(2,10,5)
    %imagesc(flipud(([meanPAC.d]-repmat(baselinePACmean,[9,1])')./repmat(baselinePACstd,[9,1])'))
    

    imagesc(flipud(([meanPAC.d]./repmat(baselinePACmean,[4,1])')));
    
            subplot(2,10,6)

    imagesc(flipud(([meanPAC.d])));
    %colorbar
    set(gca,'YTickLabel',30:-5:0)

    %imagesc(zscore(flipud([meanPAC.d]),[],2))
     %hl=line([4.5 4.5],[0 30])
    %set(hl,'Color','r')
    set(hl,'LineWidth',3)
    %title(['Ch ' int2str(test2.test.usechans(cidx))])
    %colorbar
    subplot(2,10,11:14)
    imagesc(flipud(squeeze(zscore(nanmean(abs(test2.test.segmentedEcog(e).phase(cidx,1:2000,:,[1:10 12:20])),4),[],2))'))    
   set(gca,'XTick',[300 700 800 1100 1200 1500 1600 2000])
    set(gca,'XGrid','on')
    

    set(gca,'GridLineStyle','--')
    set(gca,'LineWidth',2)
    %hl=line([800 800],[0 41])
    set(hl,'Color','r')
    set(hl,'LineWidth',3)
    axis([300 2000 0 40])
    subplot(2,10,15)

    visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',test2.test.usechans(cidx))
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');

    r=input('next ')
end
%% view baseline PAC
colormap(flipud(pink))
for cidx=1:41,
    subplot(1,2,1)
    imagesc(flipud(squeeze(nanmean(test2.test.ecogBaseline.pac(1).ave_amp_phase(cidx,:,:,:,:),4)))),
    title(['Ch',int2str(test2.test.usechans(cidx))])
    subplot(1,2,2)
    imagesc(flipud(mean(test2.test.ecogBaseline.pac(1).PAC(cidx,:,:,:),4)'))
    colorbar
    input('s'),
end
%%
colormap(flipud(pink))
for cidx=1:41
    for s=1:4
        for t=1:20
            subplot(1,2,1)
            imagesc(flipud(squeeze(test2.test.segmentedEcog(e).pac(s).ave_amp_phase(cidx,:,:,t,:))))
                set(gca,'YTickLabel',30:-5:0)

            title(['Ch ',int2str(test2.test.usechans(cidx)) ' s ' int2str(s)   ' t ' int2str(t') ])
            subplot(1,2,2)
            imagesc(flipud(squeeze(test2.test.segmentedEcog(e).pac(s).PAC(cidx,:,:,:))))
            set(gca,'YTickLabel',30:-5:0)

            input('s')
        end
    end
end
%%

for cidx=1:41
    for s=1:9
        meanPAC(s).d=median(test2.test.segmentedEcog(e).pac(s).PAC(cidx,:,:,:),4)';
        
        %subplot(2,10,s)     
        A(:,(s-1)*99+1:s*99)=flipud(squeeze(nanmean(test2.test.segmentedEcog(e).pac(s).ave_amp_phase(cidx,:,:,:,:),4)));
        %imagesc(flipud(squeeze(nanmean(test2.test.segmentedEcog(e).pac(s).ave_amp_phase(cidx,:,:,:,:),4))))
        title(['Ch' int2str(test2.test.usechans(cidx)) ' s' int2str(s)])
        
        
        
        %subplot(2,10,s+10)
        %visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',test2.test.usechans(cidx))

        
        
        %input('next')
    end
    
    %baselinePhA=imagesc(flipud(squeeze(nanmean(test2.test.ecogBaseline.pac(s).ave_amp_phase(cidx,:,:,:,:),4))))
    baselinePACmean=mean(test2.test.ecogBaseline.pac(1).PAC(cidx,:,:,:),4);
    baselinePACstd=std(test2.test.ecogBaseline.pac(1).PAC(cidx,:,:,:),[],4);
    
    subplot(1,4,1)
    %imagesc(repmat(baselinePACmean,[9,1])')
    imagesc([squeeze(test2.test.ecogBaseline.pac(1).PAC(cidx,:,:,:)),baselinePACmean'])
    
    
    subplot(1,4,2)
    %imagesc(repmat(baselinePACstd,[9,1])')
    plot(baselinePACmean)
    hold on
    plot(baselinePACstd,'r')
    plot(median(test2.test.ecogBaseline.pac(1).PAC(cidx,:,:,:),4),'g')
    hold off

        
    subplot(1,4,3)
    imagesc(flipud([meanPAC.d]))
    
    subplot(1,4,4)

    imagesc(flipud(([meanPAC.d]-repmat(baselinePACmean,[9,1])')./repmat(baselinePACstd,[9,1])'))
    
    %imagesc(zscore(flipud([meanPAC.d]),[],2))
     hl=line([4.5 4.5],[0 30])
    %set(hl,'Color','r')
    set(hl,'LineWidth',3)
    colorbar
    input('m')
end

%% Modulation Index
ecogDS.data=squeeze(test.segmentedEcog(1).data);
ecogBaseline.data=squeeze(test.ecogBaseline(1).data);

freq=[4 8; 8 12; 12 20; 20 25; 25 30; 30 35]
S=[100:1000; 1000:1900]
S=1:2000;
for s=1%:2%:4
    for l=1:size(freq,1)
        clear m_norm

        lf=freq(l,:);
        for jj=1:18
            for c=1:size(ecogDS.data,1)
                samps=1:2000;
                x=ecogDS.data(c,samps,jj);
                srate=400;    %% sampling rate used in this study, in Hz 
                numpoints=length(x);   %% number of sample points in raw signal 
                numsurrogate=200;   %% number of surrogate values to compare to actual value 
                minskip=srate;   %% time lag must be at least this big 
                maxskip=numpoints-srate; %% time lag must be smaller than this 
                skip=ceil(numpoints.*rand(numsurrogate*2,1)); 
                skip(find(skip>maxskip))=[]; 
                skip(find(skip<minskip))=[]; 
                skip=skip(1:numsurrogate,1); 
                surrogate_m=zeros(numsurrogate,1);  


                %% HG analytic amplitude time series, uses eegfilt.m from EEGLAB toolbox  
                %% (http://www.sccn.ucsd.edu/eeglab/) 
                amplitude=abs(hilbert(eegfilt(x,srate,80,150))); 
                %% theta analytic phase time series, uses EEGLAB toolbox 
                phase=angle(hilbert(eegfilt(x,srate,lf(1),lf(2)))); 
                %% complex-valued composite signal 
                z=amplitude.*exp(i*phase); 
                %% mean of z over time, prenormalized value 
                m_raw=mean(z);  
                %% compute surrogate values 
                   for s=1:numsurrogate 
                      surrogate_amplitude=[amplitude(skip(s):end) amplitude(1:skip(s)-1)]; 
                      surrogate_m(s)=abs(mean(surrogate_amplitude.*exp(i*phase))); 
                      disp(numsurrogate-s) 
                   end 
                %% fit gaussian to surrogate data, uses normfit.m from MATLAB Statistics toolbox 
                [surrogate_mean,surrogate_std]=normfit(surrogate_m); 
                %% normalize length using surrogate data (z-score) 
                m_norm_length=(abs(m_raw)-surrogate_mean)/surrogate_std; 
                m_norm_phase=angle(m_raw); 
                m_norm(c,jj)=m_norm_length*exp(i*m_norm_phase); 
                %ecogBaseline.m_norm(l).data=m_norm;
                %keep ecogDS m_norm
            end
        end

        tmp=(mean(abs(m_norm),2))./abs(ecogBaseline.m_norm(l).data);
        idx=find(tmp>70)
        tmp(idx)=NaN;
        visualizeGrid(1,['E:\General Patient Info\' test.patientID '\brain+grid_3Drecon_cropped.jpg'],1:256,tmp)
        
        %{
        % grid image
        tmp=(mean(abs(m_norm),2))./abs(ecogBaseline.m_norm(l).data);
        idx=find(tmp>70)
        tmp(idx)=NaN;
        imagesc(reshape(tmp,[16 16])',[0 5])
        %imagesc(reshape((mean(abs(m_norm),2)./abs(ecogBaseline.m_norm(l).data)),[16,16])')
        colorbar

            title(['length '  int2str(lf)])

            set(gca,'XGrid','on')
            set(gca,'YGrid','on')
            set(gca,'XTick',[1.5:16.5])
            set(gca,'YTick',[1.5:(r+.5)])
            set(gca,'XTickLabel',[])
            set(gca,'YTickLabel',[])
            for c=1:16
                for r=1:16
                    text(c,r,num2str((r-1)*16+c))
                    if ismember((r-1)*16+c,handles.badChannels)
                        text(c,r,num2str((r-1)*16+c),'Background','y')
                    end
                end
            end
         saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');

        imagesc(reshape(mean(angle(m_norm),2),[16,16])')
        colorbar

            title(['phase' int2str(lf)])

            set(gca,'XGrid','on')
            set(gca,'YGrid','on')
            set(gca,'XTick',[1.5:16.5])
            set(gca,'YTick',[1.5:(r+.5)])
            set(gca,'XTickLabel',[])
            set(gca,'YTickLabel',[])
            for c=1:16
                for r=1:r
                    text(c,r,num2str((r-1)*16+c))
                    if ismember((r-1)*16+c,handles.badChannels)
                        text(c,r,num2str((r-1)*16+c),'Background','y')
                    end
                end
            end
        %}
         saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');

       %keyboard
    end
end
 %%
 %Analog correlations
 
 for t=1:size(test.segmentedEcog.analog,4)
    a1(t,:)=abs(hilbert(test.segmentedEcog.analog(2,:,1,t)));    
 end
R=corrcoef(a1');
imagesc(R)
 %%
 for c=1:256
    d1=squeeze(mean(test.segmentedEcog.zscore_separate(c,:,:,:),3))';
    R=corrcoef( d1(:,1000:end)');
    %figure
    imagesc(R,[0 1])
    set(gca,'YTick',1:size(test.segmentedEcog.event,1))
    set(gca,'YTickLabel',test.segmentedEcog.event(:,2))
    set(gca,'XTick',1:17)
    set(gca,'XTickLabel',test.segmentedEcog.event(:,2))
    title(int2str(c))
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
    input('next')
 end
 
 %%
 wo=cell2mat(test.segmentedEcog.event(:,11))

 we=cell2mat(test.segmentedEcog.event(:,13))
 rt=we-wo;
 [a,b]=sort(rt)
 
 
 
 %%
 %save_file='C:\Users\Angela_2\Documents\Presentations\DelayWordAutoImages4.ppt'
%powerpoint_object=SAVEPPT2(save_file,'init')
 %hf=figure(1);
 %newf=figure
 %gcf=newf
 colormap(flipud(pink))
 chans=fliplr(test.gridlayout.usechans);
 chanNum=1
 while chanNum<=256
    figure(newf)
    plotLoc=find(chans==chanNum)
    subplot(3,1,1)
    data=blowUpImage(hf,plotLoc,newf,chanNum);
    
    %%
    samps=500:1500;
     R=corrcoef([squeeze(mean(test.segmentedEcog.zscore_separate(chanNum,samps,:,:),3))]);
    imagesc(R)
    set(gca,'XTickLabel',test.segmentedEcog.event(:,8))
    set(gca,'YTick',1:53)
    set(gca,'XTick',1:53)
    set(gca,'YTickLabel',test.segmentedEcog.event(:,8))
    set(gca,'FontSize',5)

    rotateticklabel(gca,90)

     title(['Channel ' int2str(chanNum)],'Fontsize',14)
    %%
    
    
    subplot(3,1,2)

    seg=3;
    totT=floor(size(data,1)/seg);
    
    i=0;
    m=mean(data(b(totT*i+1:(i+1)*totT),:),1);
    s=std(data(b(totT*i+1:(i+1)*totT),:),[],1)/sqrt(totT);

    [he,ha]=errorarea(m,s)
    set(ha,'FaceColor','b')
    set(he,'Color','b')
    hold on

    i=1;
    m=mean(data(b(totT*i+1:(i+1)*totT),:),1);
    s=std(data(b(totT*i+1:(i+1)*totT),:),[],1)/sqrt(totT);

    [he,ha]=errorarea(m,s)
    set(ha,'FaceColor','r')
    set(he,'Color','r')
    hold on
    
    i=2;
    m=mean(data(b(totT*i+1:(i+1)*totT),:),1);
    s=std(data(b(totT*i+1:(i+1)*totT),:),[],1)/sqrt(totT);

    [he,ha]=errorarea(m,s)
    set(ha,'FaceColor','g')
    set(he,'Color','g')

    hl=line([800 800],[ -5 5])
    set(hl,'Color','k')
    hold off
    axis tight
 
    legend('1','','2','','3','')
    
    subplot(3,1,3)
         imagesc(data(b,:))
    hl=line([800 800],[0 52])
     
     
     r=input('next','s');
     if strcmp(r,'b')
         chanNum=chanNum-1;
         
     else
         if strcmp(r,'s')
                 SAVEPPT2('ppt',powerpoint_object,'stretch','off'); 
         end
         chanNum=chanNum+1;
     end
 end
 %% Look at stacked analog
 for t=1:53
     anEnv(t,:)=hilbert(squeeze(test.segmentedEcog.analog(1,:,:,t)));
 end
 
%% CORR

for c=1:256
    R=corrcoef([squeeze(mean(test.segmentedEcog.zscore_separate(c,:,:,:),3))]);
    imagesc(R)
    set(gca,'XTickLabel',test.segmentedEcog.event(:,8))
    set(gca,'YTick',1:53)
    set(gca,'XTick',1:53)
    set(gca,'YTickLabel',test.segmentedEcog.event(:,8))
    rotateticklabel(gca,90)
    title(int2str(c))
    input('next')
    
end
%%
for i=1:size(data,1)
    if 0%ismember(ch2(i),EC23params.event(4).activech)
        start=1000;
        printf('x')
    else
        start=1000;;
    end
        %keyboard

        datasm(i,:)=smooth(data(i,1:end),100)';
        derv(i,:)=diff(datasm(i,:));    
        try
            thidx(i)=find(derv(i,start:end)>.002 | data(i,start+1:end)>.2  ,1,'first')+start;
        catch
            thidx(i)=0;
        end
   
    plot(data(i,:))

    hold on
    
        plot(datasm(i,:),'r')

    plot(derv(i,:)*100,'g')
    line([thidx(i) thidx(i)],[-1 3])
    title(int2str(ch2(i)))
    hold off
    r=input('next','s')
    
    if strcmp(r,'n')
        keyboard
    end
end

%%
thidx(find(thidx==0)) =NaN


[~,sortt]=sort(thidx)
sortt=sortt(~isnan(thidx(sortt)))
[pkval,pkidx]=max(datasm(sortt,:)')
ch2=ch2(sortt)
sortt=sortt(1:end-1)
visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2,max(thidx(sortt))-thidx(sortt),[],thidx(sortt),[])
visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2,800-thidx(sortt),[],thidx(sortt),[])
visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2,max(thidx(sortt))-thidx(sortt),[],ones(1,length(sortt))*200,[])

%visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],unique(ch2(sortt)),42-sortt,[],42-sortt,[])

colormap(hot)

colorbar
set(colorbar,'YTick',linspace(1,256,6))
set(colorbar,'YTickLabel',linspace(min(thidx(sortt)),max(thidx(sortt)),6))
set(gca,'FontSize',15)

title('First significant timepoint after response onset (ms)','Fontsize',15)

%%t

[pkval,pkidx]=max(datasm(sortt,:)')
[~,sortt]=sort(pkidx)


ch2=ch2(sortt)
visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2,thidx(sortt),[],thidx(sortt),[])
%% visualize data


for t=1:20:1600
    data=mean(test.segmentedEcog(2).zscore_separate(:,t:t+19,:,:),4);
    visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2,data,[],data,[])

end
%%
firstsig=zeros(1,size(pshold,1))
for i=1:size(pshold,1)
    %[a,b]=find(pshold(i,420:end)<alpha & (pshold(i,420:end)~=0 & ~isnan(pshold(i,420:end))),1,'first')
    if isempty(holdsig{i})
        firstsig(i)=0;
    else
        firstsig(i)=holdsig{i};
    end

end
thidx=firstsig
[a,b]=find(pshold<alpha & (pshold~=0 & ~isnan(pshold)))
plot(b,a,'.')
%%
C2 = nchoosek(1:test.channelsTot,2)
timeInt=400:1200%800%800:1200%1200:1600;

for f=1:40
    dataplv=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(:,timeInt,f,:)),400,[],[]);
    visualizePLVconnections(dataplv,test.usechans,C2)
    title(int2str(f))
end
%%
C2=nchoosek(test.usechans,2)
C2(:,3)=C2(:,2)-C2(:,1);
idx=find(C2(:,3)>10)
sigch=C2(idx,1:2);
