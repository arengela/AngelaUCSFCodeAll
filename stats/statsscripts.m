%%start with zscores of segmented data
%example variables: zscore_stack1, zscore_stack2
%zscore_stack1 is N by S matrix
%where N=number of trials
%S is number of samples
%%
%Get zscore matrices from single stacked plots
%Make sure your current figure active is the stacked plots
channels=256:-1:1;
for n=1:256
    figureData=get(gcf);
    axisData=get(figureData.Children(n),'Children');
    zscore_seg{1}(channels(n),:,:)=get(axisData(4),'CData');
end
%%
%get baseline by clicking "Use Command Line" in analysis_GUI

%enter the  followin command line
 assignin('base','handles',handles)
 return
 %%Run following code
 %%
 for i=1:length(handles.segmentedEcogGrouped)
        datalength=size(handles.segmentedEcogGrouped{i},2);        
       if strmatch('PreEvent',handles.baselineChoice)
            %Use 300 ms before each event for baseline
            samples=[handles.baselineMS(1)*4/10:handles.baselineMS(2)*4/10];%This can be changed to adjust time used for baseline
            Baseline=handles.segmentedEcogGrouped{i}(:,samples,:,:);
            zscore_baseline{i}=repmat(handles.baselineMS(2)*4/10,[256,1]);
            meanOfBaseline=repmat(mean(Baseline,2),[1, datalength,1,1]);
            stdOfBaseline=repmat(std(Baseline,0,2),[1,datalength,1, 1]);
        
       elseif strmatch('RestEnd',handles.baselineChoice)
            %Use resting at end for baseline
            handles.baselineFiltered.data=handles.ecogFiltered.data(:,handles.baselineMS(1)*4/10:handles.baselineMS(2)*4/10,:,:);
            zscore_baseline{i}=handles.baselineFiltered.data;
            meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);

       elseif strmatch('RestBlock',handles.baselineChoice)
            %use rest block for baseline
            handles.baselineFiltered.data=handles.ecogBaseline.data;
            zscore_baseline{i}=handles.baselineFiltered.data;

            meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
            stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
       end        
        zscore_separate=(handles.segmentedEcogGrouped{i}-meanOfBaseline)./stdOfBaseline;
        zScore{i}=squeeze(mean(zscore_separate,3));
        zScore{i}(handles.badChannels,:,:)=NaN;

end
%%

zScore2{2}=zScore{1};

%%
%load variables
load C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\zScoreall2_EC18_Active_Passive_3000to3000.mat

load C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\baseline_EC18;
load C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\usetrials;


test_samp=[800:2000];%latency samples to test (samples of interest)
dest='C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\stats'
for event=2;
    newfolder=[dest filesep 'Event_B_' int2str(event)];
    mkdir(newfolder)
    cd(newfolder)
    for i=241:256%[35 19 5 255 100 237]
        zscore_stack1=squeeze(zScoreall(1).data{event}(i,:,:,:))';
        zscore_stack2=squeeze(zScoreall(2).data{event}(i,:,:,:))';   


        %raw p values for condition1
        ps_raw1=singleConditionStats(zscore_stack1,baseline(i,:),test_samp);
        %ps_raw1b(i,:)=ps_raw1;
        %raw p values for condition2
        ps_raw2=singleConditionStats(zscore_stack2,baseline(i,:),test_samp);
        %ps_raw2b(i,:)=ps_raw2;
        cd(newfolder)
        %ps_raw1=readhtk(['ps_raw_A' int2str(i)]);
        %ps_raw2=readhtk(['ps_raw_P' int2str(i)]);

        writehtk(['ps_raw_A' int2str(i)],ps_raw1,400,i);
        writehtk(['ps_raw_P' int2str(i)],ps_raw2,400,i);
        ps_2cond_raw=twoConditionStats(zscore_stack1,zscore_stack2,test_samp,ps_raw1,ps_raw2,baseline(i,:),baseline(i,:))
        writehtk(['ps_2cond_raw' int2str(i)],ps_2cond_raw,400,i);
        %clear ps_raw_2;
        %clear ps_raw_1b;
        %clear ps_2cond_raw;
    end
    
    clear ps_raw_2b
    clear ps_raw_1b
    clear ps_2cond_raw;
end



%{
%view plots
figure
plot(mean(zscore_stack1,1));
hold on
plot(find(ps_raw1<0.05& ps_raw1~=NaN),1,'g.')
%}
%{
%view plots
figure
plot(mean(zscore_stack2,1));
hold on
plot(find(ps_raw2<0.05& ps_raw2~=NaN),1,'r.')
%}


%%
%perform 2 condition tests

%zscore_baseline1=200
%zscore_baseline2=200

%raw p value for 2 condition significance
ps_2cond_raw=twoConditionStats(zscore_stack1,zscore_stack2,test_samp,ps_raw1,ps_raw2,zscore_baseline1,zscore_baseline2)

ps_2cond_raw=twoConditionStats(zscore_stack1,zscore_stack2,test_samp,ps_raw1,ps_raw2,zscore_baseline{1},zscore_baseline{2})


%ps_2cond_raw_P=twoConditionStats_permute(zscore_stack1,zscore_stack2,test_samp,ps_raw1,ps_raw2,zscore_baseline1,zscore_baseline2)

%{
figure
plot(mean(zscore_stack2,1));
hold on
plot(mean(zscore_stack1,1));
plot(find(ps_2cond_raw<0.05& ps_2cond_raw~=NaN),1,'r.')
%}
%%
%%FDR for multiple comparisions
alpha=.05;
idx=find(ps_raw1>0.05 & ps_raw2>0.05)
ps_2cond_raw(idx)=NaN;
ps2_2cond_raw(ps_2cond_raw==0)=NaN;
idx=find(~isnan(ps_2cond_raw));

[ps_fdr,h_fdr]=MT_FDR_PRDS(ps_2cond_raw(idx),alpha);

%{
figure
plot(mean(zscore_stack2,1));
hold on
plot(mean(zscore_stack1,1));

tmp_idx=find(ps_fdr<0.05& ps_fdr~=NaN)
plot(idx(tmp_idx),1,'c.')
%}

%%
%plot average zscores and significant latencies for single and two
%conditions
dest='C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\DelayWordPseudoword\stats\Event_B_3'
event=3;
cd(dest)
figure
set(gcf,'Color','w')

for i=1:256
    try
        ps_raw1=readhtk(['ps_raw_A' int2str(i)]);
        ps_raw2=readhtk(['ps_raw_P' int2str(i)]);
        ps_2cond_raw=readhtk(['ps_2cond_raw' int2str(i)]);
    catch
        continue
    end
    
    %Multiple Comparison Correction
    alpha=.05;
    idx=find(ps_raw1>0.05 & ps_raw2>0.05);
    ps_2cond_raw(idx)=NaN;
    ps2_2cond_raw(ps_2cond_raw==0)=NaN;
    idx=find(~isnan(ps_2cond_raw));

    [ps_fdr,h_fdr]=MT_FDR_PRDS(ps_2cond_raw(idx),alpha);
    
    
    
    
    
    
    
    zscore_stack1=squeeze(zScoreall(1).data{event}(i,:,:,:))';
    zscore_stack2=squeeze(zScoreall(2).data{event}(i,:,:,:))';


    z1_ave=mean(zscore_stack1,1);
    z2_ave=mean(zscore_stack2,1);

    sig1=find(ps_raw1<0.05& ps_raw1~=NaN);
    sig2=find(ps_raw2<0.05& ps_raw2~=NaN);

    idx=find(~isnan(ps_2cond_raw));
    tmp_idx=find(ps_fdr<0.05& ps_fdr~=NaN)

    %{
    idx=find(~isnan(ps_2cond_raw_P));
    tmp_idx=find(ps_2cond_raw_P<0.05&ps_2cond_raw_P~=NaN)

    idx=find(~isnan(ps_2cond_raw));
    tmp_idx=find(ps_2cond_raw<0.05&ps_2cond_raw~=NaN)

    idx=find(~isnan(ps2));
    tmp_idx=find(ps2<0.05&ps2~=NaN)


    sig_2cond=tmp_idx
    %}
    sig_2cond=idx(tmp_idx);


    line(vertcat(sig_2cond,sig_2cond),vertcat(z1_ave(sig_2cond),z2_ave(sig_2cond)),'linewidth',1,'color','g');
    hold on

    plot(z1_ave,'k','LineWidth',2)
    plot(z2_ave,'r','LineWidth',2)

    plot(linspace(1200,1200.01,41),[-1:.1:3],'k--');

    if ~isempty(sig1)
        plot(sig1,-0.5,'k-','LineWidth',3)
    end
    if ~isempty(sig2)
        plot(sig2,-0.6,'r-','LineWidth',3)
    end

    y=get(gca,'YLim')
    y(1)=-1.2
    set(gca,'YLim',y)
    

    set(gca,'XTick',[0:400:2400])
    set(gca,'XTickLabel',[-3:3])
    title(['electrode ' int2str(i)])
    hold off
    
    input('next')
    clf
end
%%
%Check baseline
figure
for i=1:256
    
    plot(mean(baseline2.data(i,:,:),3),'k')
    hold on
    
    plot(mean(rest.data(i,:,:),3),'r')

    %meanb=mean(mean(baseline2.data(i,:,:),3));
    
    %meane=mean(mean(ecogP.data(i,:,:),3));
    %stdb=std(mean(baseline2.data(i,:,:),3));
    %stde=std(mean(ecogP.data(i,:,:),3));    
    %text(5e4,5,['mb= ' num2str(meanb) '| me' num2str(meane) '| sb' num2str(stdb) '| se' num2str(stde)])
    text(5e4,5,num2str([meane meanb stde stdb]'))

    
    %plot(zScoreall(1).data{3}(i,:,1),'g')
    %plot(zScoreall(2).data{3}(i,:,1),'r')
    ylim([-2 7])
    title(int2str(i))
    input('next')
    hold off
end

    


