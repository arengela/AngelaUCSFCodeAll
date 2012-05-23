%%
%Get path info
handles.file='C:\Users\Angela\Documents\ECOGdataprocessing\Data_preprocess_temp\EC5\EC5_B6\HilbReal_4to200_40band'
[handles.pathName,block,c]=fileparts(handles.file)
fprintf('File opened: %s\n',handles.file);
[a,folder]=fileparts(handles.file)

%%
%Get Artifact Info
cd(sprintf('%s/Artifacts',handles.pathName))

load 'badTimeSegments.mat'
handles.badTimeSegments=badTimeSegments;
fprintf('%d bad time segments loaded',size(handles.badTimeSegments,1));

fid = fopen('badChannels.txt');
tmp = fscanf(fid, '%d');
handles.badChannels=tmp';
fclose(fid);
fprintf('Bad Channels: %s',int2str(handles.badChannels));

cd(handles.pathName)

%%

handles.segmentationWindow={[500 1000]}
handles.segmentType={'Auto'}
handles.subsetLabel={[1]}

%%
timeWindow=handles.segmentationWindow;
processed_ecog.sampFreq=400;

for i=1:size(timeWindow,2)
    sampWindow{i}=round((timeWindow{i}*processed_ecog.sampFreq)/1000);
end


cd('Analog')
load('allConditions.mat')
load('allEventTimes.mat')

idx=strmatch('b',allEventTimes(:,2))
p=1;
for t=1:length(idx)
    for b=1:size(handles.badTimeSegments,1)
        if ((allEventTimes{idx(t),1}-handles.segmentationWindow{1}(1)/1000>=handles.badTimeSegments(b,1))...
            & (allEventTimes{idx(t),1}-handles.segmentationWindow{1}(1)/1000<=handles.badTimeSegments(b,2))) | ...
            ((allEventTimes{idx(t),1}-handles.segmentationWindow{1}(2)/1000>=handles.badTimeSegments(b,1)) & ...
            (allEventTimes{idx(t),1}-handles.segmentationWindow{1}(2)/1000<=handles.badTimeSegments(b,2)))
        
            badidx(p)=t;
            p=p+1;
        end
    end
end

goodidx=setdiff(1:length(idx),unique(badidx))

cd(handles.pathName);

%%

cd(handles.file)
[a,Fs,tmp,ch]=readhtk('Wav11.htk',[allEventTimes{idx(i),1}*1000-handles.segmentationWindow{1}(1) allEventTimes{idx(i),1}*1000+handles.segmentationWindow{1}(2)]);

handles.segmentedEcog.data=zeros(256,size(a,2),size(a,1),length(goodidx)); 
if strmatch(block,'HilbReal_4to200_40band')
    cd([ handles.pathName '\HilbReal_4to200_40band'])
    [r, sampFreq, tmp, chanNum] = readhtk ('Wav11.htk');
    %handles.ecogFiltered.data=zeros(256,size(r,2),size(r,1));
    for nBlocks=1:4
        for k=1:64
            cd([ handles.pathName '\HilbReal_4to200_40band'])
            varName1=['Wav' num2str(nBlocks) num2str(k)]
                    for i=1:length(goodidx)
                        cd([ handles.pathName '\HilbReal_4to200_40band'])

                        [r,Fs,tmp,ch]=readhtk(sprintf('%s.htk',varName1),[allEventTimes{goodidx(i),1}*1000-handles.segmentationWindow{1}(1) allEventTimes{goodidx(i),1}*1000+handles.segmentationWindow{1}(2)]);
                        
                        cd([ handles.pathName '\HilbImag_4to200_40band'])
                        [im,Fs,tmp,ch]=readhtk(sprintf('%s.htk',varName1),[allEventTimes{goodidx(i),1}*1000-handles.segmentationWindow{1}(1) allEventTimes{goodidx(i),1}*1000+handles.segmentationWindow{1}(2)]);
                        handles.segmentedEcog.data(ch,:,:,i)=abs(complex(r,im))';
                    end           
        end
    end   

    %ecogreal=loadHTKtoEcog([ handles.pathName '\HilbReal_4to200_40band'])
    %ecogimag=loadHTKtoEcog([ handles.pathName '\HilbImag_4to200_40band'])
    %ecogcomplex.data=complex(ecogreal.data,ecogimag.data);
    %handles.ecogFiltered.data=abs(ecogcomplex.data);
    handles.sampFreq=sampFreq;    
    handles.ecogFiltered.sampFreq=sampFreq;
  
    
else
    for nBlocks=1:4
            for k=1:64
                varName1=['Wav' num2str(nBlocks) num2str(k)]
                    for i=1:length(goodidx)
                        [a,Fs,tmp,ch]=readhtk(sprintf('%s.htk',varName1),[allEventTimes{goodidx(i),1}*1000-handles.segmentationWindow{1}(1) allEventTimes{goodidx(i),1}*1000+handles.segmentationWindow{1}(2)]);
                        handles.segmentedEcog.data(ch,:,:,i)=a';
                    end
            end
    end
end
%%

handles.segmentedEcogGrouped{1}=handles.segmentedEcog.data;
rmfield(handles,'segmentedEcog')
cd ..
%%
for i=1:length(handles.segmentedEcogGrouped)
       datalength=size(handles.segmentedEcogGrouped{i},2);
        
        
        %Use 300 ms before each event for baseline
        samples=[80:200];%This can be changed to adjust time used for baseline
        Baseline=handles.segmentedEcogGrouped{i}(:,samples,:,:);
        meanOfBaseline=repmat(mean(Baseline,2),[1, datalength,1,1]);
        stdOfBaseline=repmat(std(Baseline,0,2),[1,datalength,1, 1]);
        %meandata=mean(handles.segmentedEcogGrouped{i},4);
        
        
        
        
        
        %Use resting at end for baseline
        %{
        handles.baselineFiltered.data=handles.ecogFiltered.data(:,1.5*60*400:1.9*60*400,:,:);
         meanOfBaseline=repmat(mean(handles.baselineFiltered.data,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
        stdOfBaseline=repmat(std(handles.baselineFiltered.data,0,2),[1, datalength,1,size(handles.segmentedEcogGrouped{i},4)]);
        
        %}
        
        zscore_separate=(handles.segmentedEcogGrouped{i}-meanOfBaseline)./stdOfBaseline;
        clear meanOfBaseline;
        clear stdOfBaseline;
        zScore_separate_ave{i}=mean(zscore_separate,4);
        %clear zscore_separate;
        %zScore_separate_ave{i}(handles.badChannels,:,:)=NaN;
        
          
end

%%
%Plot Spectrograms
i=1;
eventSamp=handles.segmentationWindow{i}(1)*400/1000;

maxZallchan=max(max(max(zScore_separate_ave{i},[],2),[],3),[],1);
minZallchan=min(min(min(zScore_separate_ave{i},[],2),[],3),[],1);
usechans=[1:size(zScore_separate_ave{i},1)];
figure
for c=1:length(usechans)
    m=floor(c/16);
    n=rem(c,16);
    
    if n==0
        n=16;
        m=m-1;
    end
    
    p(1)=6*(n-1)/100+.03;
    p(2)=6.2*(15-m)/100+0.01;
    
    p(3)=.055;
    p(4)=.055; 
    h=subplot('Position',p);
    
    if find(ismember(handles.badChannels,i))
        
    else
        c
        %imagesc(flipud(squeeze(zScore_separate_ave{i}(c,:,:))'),[minZallchan maxZallchan])
        imagesc(flipud(squeeze(zScore_separate_ave{i}(c,:,:))'))



        %axis tight

        hold on
        plot([eventSamp eventSamp+0.001],[0 size(zScore_separate_ave{i},2)],'w')

        %set(gca,'xtick',[],'ytick',[])  
    end
        text(1,0,num2str(usechans(c)))
        %plot(meanOfBaseline(usechans(n),:),'c');
        %plot(meandata(usechans(n),:),'m')
end

clear zScore_separate_ave
%%
%Plot singleStacked
zScore=squeeze(mean(zscore_separate,3));


eventSamp=handles.segmentationWindow{i}(1)*400/1000;

maxZallchan=max(max(max(zScore_separate_ave{i},[],2),[],3),[],1);
minZallchan=min(min(min(zScore_separate_ave{i},[],2),[],3),[],1);
usechans=[1:size(zScore,1)];
figure
for c=1:length(usechans)
    m=floor(c/16);
    n=rem(c,16);
    
    if n==0
        n=16;
        m=m-1;
    end
    
    p(1)=6*(n-1)/100+.03;
    p(2)=6.2*(15-m)/100+0.01;
    
    p(3)=.055;
    p(4)=.055; 
    h=subplot('Position',p);
    
    if find(ismember(handles.badChannels,i))
        
    else
        c
        %imagesc(flipud(squeeze(zScore_separate_ave{i}(c,:,:))'),[minZallchan maxZallchan])
        imagesc(squeeze(zScore(c,:,:))')
        h=text(p(1),p(2),int2str(c));


        %axis tight

        hold on
        plot([eventSamp eventSamp+0.001],[0 size(zScore_separate_ave{i},2)],'w')
        set(h,'BackgroundColor','w')
        hold on
        %axis([0 length(zScore(1,:)) minZallchan(i) minZallchan(i)+maxdiff(i)])
        plot([eventSamp eventSamp+.001],[0 size(zScore,3)],'w')

        %set(gca,'xtick',[],'ytick',[])  
    end
        text(1,0,num2str(usechans(c)))
        %plot(meanOfBaseline(usechans(n),:),'c');
        %plot(meandata(usechans(n),:),'m')
end


