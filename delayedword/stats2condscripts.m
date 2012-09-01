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


load('E:\DelayWord\EC23\EC23params.mat')
load('E:\DelayWord\EC18\EC18params.mat')
load('E:\DelayWord\EC22\EC22params.mat')
load('E:\DelayWord\EC24b\EC24params.mat')

 e=2
 
 %visualizeGrid(9,['E:\General Patient Info\EC23' '\brain.jpg'],ch2,57-(2:56),[],pkval(sortt),[])
ch2=unique([EC23params.event(5).activech EC23params.event(4).activech EC23params.event(2).activech]) ; %activech(c);
%ch2=[EC23params.event(5).activech ]
%ch2=setdiff(EC23params.event(5).activech, EC23params.event(2).activech) ;
%ch2=1:256
sp=1

c=1
e=1
eidx2=[2 4 5]
holdsig=zeros(1,length(ch2))
badtrials=[31 23 ]
badtrials=[]
%%


for n=12
    %[1 2 9]   
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
        test.Params.indplot=0;
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
                
                 Labels=test.segmentedEcog(eidx).event(:,8)
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
                
                
                %
                clear all_label1 all_label2 all_label
                 Labels=test.segmentedEcog(eidx).event(:,8)
                 for i=1:length(Labels)
                    try
                        wordidx=find(strcmp(Labels{i},{brocawords.names}));
                        all_label1(i)=find(strcmp({'','','','short','long'},brocawords(wordidx).lengthtype));
                        all_label2(i)=find(strcmp({'easy','','hard'},brocawords(wordidx).difficulty));
                        all_label3(i)=brocawords(wordidx).logfreq_HAL;
                        %all_label(i)=wordidx;
                    catch
                        wordidx=NaN
                        all_label(i)=wordidx;
                    end
                end
                              
                  %select only long words
                useidx=find(all_label1==5)%only long words
                %useidx=1:length(all_label1);%all words
                all_label1=all_label1(useidx);
                all_label2=all_label2(useidx);
                all_label3=all_label3(useidx);
                all_label=all_label2;
                 test.segmentedEcog(eidx).data=test.segmentedEcog(eidx).data(:,:,:,useidx);
                test.segmentedEcog(eidx).zscore_separate=test.segmentedEcog(eidx).zscore_separate(:,:,:,useidx);
                test.segmentedEcog(eidx).rt=test.segmentedEcog(eidx).rt(useidx);
                test.segmentedEcog(eidx).event=test.segmentedEcog(eidx).event(useidx,:);              
                

                all_label(find(all_label3<8))=1;%frequent vs less frequent
                all_label(find(all_label3>9))=2;

                count=20
                cont=0
                conditions=[1 2];
                while cont==0
                    useidx=[find(all_label==conditions(1),count)  find(all_label==conditions(2),count)]%get 50/50 in training/test sets
                    if length(find(all_label(useidx)==conditions(1)))==count & length(find(all_label(useidx)==conditions(2)))==count
                        cont=1;
                    else 
                        count=count-1;
                    end
                end
                all_label=all_label(useidx);
                 test.segmentedEcog(eidx).data=test.segmentedEcog(eidx).data(:,:,:,useidx);
                test.segmentedEcog(eidx).zscore_separate=test.segmentedEcog(eidx).zscore_separate(:,:,:,useidx);
                test.segmentedEcog(eidx).rt=test.segmentedEcog(eidx).rt(useidx);
                test.segmentedEcog(eidx).event=test.segmentedEcog(eidx).event(useidx,:);

                %%  
                try
                    cd(dest)
                catch
                    mkdir(dest);
                    cd(dest);
                    
                end
                %psfilename='ps_nboot10000_slide_baseline3'
                psfilename='ps_nboot10000_wl_short'  
             
                
                %psfilename='ps_nboot10000'
                if ~isempty(find(strmatch(psfilename,cellstr(ls))))
                    psfilename='ps_nboot10000_wl_short'  
                    load(psfilename)
                    psfilename='ps_nboot10000_wl_long'     
                    load(psfilename)
                    
                    
                    load('ps_2cond_wl') 
                    
                    
                    
                    
                else if 0
%                         psfilename='ps_nboot10000_wl_short'  
%                     load(psfilename)
%                     psfilename='ps_nboot10000_wl_long'     
%                     load(psfilename)
%                     load('ps_2cond_wl') 
                    
                    
                    ps=singleConditionStats(squeeze(mean(test.segmentedEcog(eidx).zscore_separate(1,:,:,:),3))',[200 400],1:size(test.segmentedEcog(eidx).zscore_separate,2))
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
                    
                    
                    ps_2cond_raw=twoConditionStats(squeeze(mean(test.segmentedEcog(eidx).zscore_separate(1,:,:,1:triallength/2),3))',squeeze(mean(test.segmentedEcog(eidx).zscore_separate(1,:,:,triallength/2+1:end),3))',1:1600,ps1,ps2,baselinezscore1,baselinezscore2)
                    save('ps_2cond_wl','ps_2cond_raw','-v7.3')         
                    

                end
                triallength=floor(size(test.segmentedEcog(eidx).zscore_separate,4));

                data(c,:)=squeeze(mean(mean(test.segmentedEcog(1).zscore_separate,3),4))';
                data2=squeeze(mean(test.segmentedEcog(eidx).zscore_separate,3));
                %%
                width=.15;
%                      subpos=[(.005+width)*(eidx-1) .1 width .8]
%                     subplot('position',subpos)%                     


%%
                %plot stacked
                figure(1)
                %subplot(1,6,(eidx-1)*2+1)
                subplot(1,4,eidx)
                %imagesc(squeeze(data2)',[-1 3])
                
                
                pcolor(flipud(squeeze(data2)'))
                shading interp
                caxis([-1 3])


                hold on
                
                for col=1:2:11
                    wo=cell2mat(test.segmentedEcog(eidx).event(:,1))
                    we=cell2mat(test.segmentedEcog(eidx).event(:,col))
                    rt=we-wo;
                    plot(rt*400+800,size(test.segmentedEcog(eidx).rt,1):-1:1,'k','LineWidth',1.3)
                end         
                
                hl=line([800 800],[ 0 53])                
                set(hl,'LineStyle','--')
                set(hl,'Color','k')
                
                set(gca,'XTick',1:400:2000)
                
                set(gca,'XTickLabel',-2:1:2)
                title(['Ch ' int2str(ch)],'Fontsize',15)
                %colormap(flipud(pink))
                colormap(redblueblack)
                hold off

%%               plot zscores 
                hold off
                freezeColors;
                if ~mod(eidx,2)
                    set(gca,'YTickLabel',[])
                end
                
                try
                    %% plot condition 1
                    %subplot(1,6,(eidx-1)*2+2)   
                    subplot(1,4,eidx)
                    %errorarea(mean(data2,4),std(data2,[],4)/sqrt(size(data2,4)))
                    m=mean(data2(:,1:triallength/2),2);
                    m1=m;
                    plot(m,'m','LineWidth',2)
                    hold on
                    m=mean(data2(:,triallength/2+1:end),2);
                    m2=m;
                    plot(m,'k','LineWidth',2)    
                    hl=line([800 800],[-1 7])
                    axis tight
                    set(hl,'LineStyle','--')
                    set(hl,'Color','k')
                    title(['Ch ' int2str(ch)],'Fontsize',15)
                    set(gca,'XTick',1:400:1600)
                    set(gca,'XTickLabel',-2:1:2)     
                    
                    
                    
                    
                    ps=ps1
                    alpha=.05;
                    idx=find(~isnan(ps));
                    [ps_fdr,h_fdr]=MT_FDR_PRDS(ps(idx),alpha);
                    ps(idx)=ps_fdr;
                    sigidx=find(ps<alpha & (ps~=0 & ~isnan(ps)));                
                    %plot sig pvalue
                    if ~isempty(sigidx)
                        plot(sigidx,-.5,'m.')
                    end                
                    % plot condition 2
                   
                    ps=ps2
                    alpha=.05;
                    idx=find(~isnan(ps));
                    [ps_fdr,h_fdr]=MT_FDR_PRDS(ps(idx),alpha);
                    ps(idx)=ps_fdr;
                    sigidx=find(ps<alpha & (ps~=0 & ~isnan(ps)));                
                    %plot sig pvalue
                    if ~isempty(sigidx)
                        plot(sigidx,-.6,'k.')
                    end

                    %% plot p-value two condition                
                    ps=ps_2cond_raw;
                    alpha=.05;
                    idx=find(~isnan(ps));
                    [ps_fdr,h_fdr]=MT_FDR_PRDS(ps(idx),alpha);
                    ps(idx)=ps_fdr;
                    sigidx=find(ps<alpha & (ps~=0 & ~isnan(ps)));                
                    %plot sig pvalue
                    for si=1:length(sigidx)
                        hl=line([sigidx(si) sigidx(si)], [ m1(sigidx(si)) m2(sigidx(si))])
                        hold on
                        set(hl,'Color','g')                    
                    end  
                    plot(m1,'m','LineWidth',2)    
                    hold on
                    plot(m2,'k','LineWidth',2)    

                    %
                    hl=line([800 800],[-1 7])
                    axis tight
                    set(hl,'LineStyle','--')
                    set(hl,'Color','k')
                    title(['Ch ' int2str(ch)],'Fontsize',15)
                    set(gca,'XTick',1:400:1600)
                    set(gca,'XTickLabel',-2:1:2)        
                end

                %%
                if eidx~=1
                    set(gca,'YTickLabel',[])
                end
                %print -dmeta
                hold off
                end
            end
            
            subplot(1,4,4)
            visualizeGrid(2,['E:\General Patient Info\EC24' '\brain_3Drecon.jpg'],ch2(c))

            SAVEPPT2('ppt',powerpoint_object,'stretch','off'); 
            hold off
            r='y';
            %r=input('next','s')            
            if strcmp(r,'n')
                keyboard
            end
             clf
        end
    end
end
%%

for ch=1:length(ch2)
    visualizeGrid(2,['E:\General Patient Info\EC23' '\brain.jpg'],ch2(ch))
    set(gca,'XTick',[]')
    set(gca,'YTick',[]')
    set(gca,'Box','off')
    set(gca,'visible','off')
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');

    %SAVEPPT2('ppt',powerpoint_object,'stretch','off'); 

end
              
%%



for c=c:length(ch2)%[1 2 9]      
    for n=1:2
         test=SegmentedData([allfiles{n} '/HilbAA_70to150_8band']);
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
        test.Params.indplot=0;
        m=mean(test.ecogBaseline.data(:,:,:,:),3);
        baselinezscore=(m-repmat(mean(test.ecogBaseline.mean,2),[1 size(m,2)]))./repmat(mean(test.ecogBaseline.std,2),[1 size(m,2)]);
        test.Params.sorttrials=1;
        
            %load segments    
            test.segmentedDataEvents40band(seg(:,[2,4]),{[2000 2000],[2000 2000]},'keep',[],'aa',31:38)
            
            test.calcZscore;
            
            for eidx=1:2
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
            end
            
            
            
        if n==1
            test1=test;
            clear test
        else
            test2=test;
            clear test
        end
    end
    
    
    for eidx=1%:2
         dest=[allfiles{n} '/pvalues/e' int2str(unique(seg{e}(1,:))) '/ch' int2str([ch])];              

         try
             cd(dest)
         catch
             mkdir(dest);
             cd(dest);
             
         end
         
         %psfilename='ps_nboot10000_slide_baseline3'
         psfilename='ps_nboot10000_active'
         
         
         %psfilename='ps_nboot10000'
         if ~isempty(find(strmatch(psfilename,cellstr(ls))))
             psfilename='ps_nboot10000_wl_short'
             load(psfilename)
             psfilename='ps_nboot10000_wl_long'
             load(psfilename)
             load('ps_2cond_active_passive')
             
             
             
             
         elseif 1                 
                 triallength=floor(size(test1.segmentedEcog(eidx).zscore_separate,4));
                 
                 baselinezscore=squeeze(mean(test1.segmentedEcog(1).zscore_separate(:,400:600,:,1:triallength/2),3));
                 baselinezscore1=reshape(baselinezscore,[1 size(baselinezscore,1)*size(baselinezscore,2)]);
                 [ps1,bse]=singleConditionStats(squeeze(mean(test1.segmentedEcog(eidx).zscore_separate(1,:,:,:),3))',baselinezscore1,1:size(test1.segmentedEcog(eidx).zscore_separate,2))
                 psfilename='ps_nboot10000_active'
                 save(psfilename,'ps1','-v7.3')
                 
                 baselinezscore=squeeze(mean(test2.segmentedEcog(1).zscore_separate(:,400:600,:,triallength/2+1:end),3));
                 baselinezscore2=reshape(baselinezscore,[1 size(baselinezscore,1)*size(baselinezscore,2)]);
                 [ps2,bse]=singleConditionStats(squeeze(mean(test2.segmentedEcog(eidx).zscore_separate(1,:,:,:),3))',baselinezscore2,1:size(test2.segmentedEcog(eidx).zscore_separate,2))
                 
                 psfilename='ps_nboot10000_passive'
                 save(psfilename,'ps2','-v7.3')
                 
                 
                 ps_2cond_raw=twoConditionStats(squeeze(mean(test1.segmentedEcog(eidx).zscore_separate(1,:,:,:),3))',squeeze(mean(test2.segmentedEcog(eidx).zscore_separate(1,:,:,:),3))',1:1600,ps1,ps2,baselinezscore1,baselinezscore2)
                 save('ps_2cond_active_passive','ps_2cond_raw','-v7.3')                
        end
    end             
end
                
%%

for c=c:length(ch2)%[1 2 9]      
    for n=1:2
         test=SegmentedData([allfiles{n} '/HilbAA_70to150_8band']);
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
        test.Params.indplot=0;
        m=mean(test.ecogBaseline.data(:,:,:,:),3);
        baselinezscore=(m-repmat(mean(test.ecogBaseline.mean,2),[1 size(m,2)]))./repmat(mean(test.ecogBaseline.std,2),[1 size(m,2)]);
        test.Params.sorttrials=1;
        
            %load segments
            if n==2
                test.segmentedDataEvents40band(seg(:,[2,4]),{[2000 2000],[2000 2000]},'keep',[],'aa',31:38)
                numevent=2;
            else
                test.segmentedDataEvents40band(seg(:,[2,4,5]),{[2000 2000],[2000 2000],[2000 2000]},'keep',[],'aa',31:38)
                numevent=3;
            end
            test.calcZscore;
            
            for eidx=1:numevent
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
            end
            
            
            
        if n==2
            test2=test;
            clear test
        else
            test1=test;
            clear test
        end
    end
    
    for eidx=1:3
        figure(1)
        subplot(1,4,eidx)
       triallength=floor(size(test1.segmentedEcog(eidx).zscore_separate,4));

        plot(squeeze(mean(mean(test1.segmentedEcog(eidx).zscore_separate(1,:,:,1:triallength/2),3),4)),'m','LineWidth',2)
        hold on
        try
            plot(squeeze(mean(mean(test1.segmentedEcog(eidx).zscore_separate(1,:,:,triallength/2:end),3),4)),'k','LineWidth',2)
        end
        hl=line([800 800],[-1 7])
        axis tight
        set(hl,'LineStyle','--')
        set(hl,'Color','k')
        title(['Ch ' int2str(ch)],'Fontsize',15)
        set(gca,'XTick',1:400:1600)
        set(gca,'XTickLabel',-2:1:2)
        title(int2str(ch2(ch)));
        hold off
    end
        subplot(1,4,4)
        %visualizeGrid(2,['E:\General Patient Info\EC18_v2' '\brain_3Drecon.jpg'],ch2(ch))
        %visualizeGrid(2,['E:\General Patient Info\EC22' '\brain.jpg'],ch2(ch))        
        
        SAVEPPT2('ppt',powerpoint_object,'stretch','off');
        r='y';
        %r=input('next','s')
        if strcmp(r,'n')
            keyboard
        end
        clf
    
end
%%

for ch=1:length(ch2)
    visualizeGrid(2,['E:\General Patient Info\EC23' '\brain.jpg'],ch2(ch))
    set(gca,'XTick',[]')
    set(gca,'YTick',[]')
    set(gca,'Box','off')
    set(gca,'visible','off')
    saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');

    %SAVEPPT2('ppt',powerpoint_object,'stretch','off'); 

end
              