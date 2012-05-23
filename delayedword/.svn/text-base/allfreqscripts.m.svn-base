load E:\PreprocessedFiles\EC18\EC18_B1\Analog\allEventTimes
load E:\PreprocessedFiles\EC18\EC18_B1\Analog\allConditions
%%
t3=regexp(allEventTimes(:,2),'word')
p3=find(~cellfun(@isempty,t3))

%%
p3=find(ismember(allEventTimes(:,2),wordlist))
%%
handles.pathName='C:\Users\Angela_2\Documents\ECOGdataprocessing\Projects\ButtonPressAnalysis\EC2_B5'
handles.pathName='E:\PreprocessedFiles\EC18\EC18_B1'
handles.pathName='E:\PreprocessedFiles\EC18\EC18_B2'




allpaths{1}='E:\PreprocessedFiles\EC18\EC18_B1';
allpaths{2}='E:\PreprocessedFiles\EC18\EC18_B2';


%handles.pathName='E:\PreprocessedFiles\EC20\EC20_B18'

chanNum=5;
buffer=[10000 10000]
buffer=[500 3000]

seglength=[20*400]
dest='E:\PreprocessedFiles\EC18\EC18_B1\segmentedSpectrograms\event3_pac_1000_3000'
%%
mkdir(dest)
%% Calculate PAC and save
%buffer_all={[0 2000],[0 1000],[-200 1500],[0 1000],[500 1000]}

%dataC_all=zeros(256,(buffer(2)+buffer(1))*.4,40);
for event=1:5
    %clear dataC_all
    
    %t3=regexp(allEventTimes(:,2),allConditions{event})
    %p3=find(cellfun(@(x) isequal(x,1),t3))
    
    buffer=buffer_all{event};
    dest=sprintf('E:/PreprocessedFiles/EC22/EC22/segmented_40band/event%i_%i_%i',event,buffer(1),buffer(2))
    mkdir(dest)
    
    %amp_phase_all=zeros(1,40,99,length(p3));
    %pac=zeros(1,1,40,length(p3));
    
    for chanNum= 1:256
        cd(dest)
        mkdir(['Chan' int2str(chanNum)]);
        for i=1:length(p3)
            timeInt=[allEventTimes{p3(i),1}*1000-buffer(1) allEventTimes{p3(i),1}*1000+buffer(2)];
            %timeInt=[2000 102000]
            [R,I]=loadHTKtoEcog_onechan_complex_real_imag(handles.pathName,chanNum,round(timeInt));
            
            %dataC_all(1,:,:)=complex(R,I)';
            data=complex(R,I);
            cd([dest filesep 'Chan' int2str(chanNum)])
            writehtk(['t' int2str(i) '.htk'],data',400);
            %keep(chanNum,:,:,i)=data';
            
%             for lf=[8 10 15 20]
%                 [tmp, tmp2]=PAC_preprocesseddata(dataC_all(1,:,:),lf);
%                 pac(1,1,:,i)=squeeze(tmp(1,lf,:));
%                 amp_phase_all(1,:,:,i)=tmp2{1};
%                 
%                 mkdir([dest '/lowf' int2str(lf)])
%                 cd([dest '/lowf' int2str(lf)])
%                 writehtk(['pac' int2str(chanNum) '_t' int2str(i) '.htk'],squeeze(tmp),400);
%                 writehtk(['amp_phase' int2str(chanNum) '_t' int2str(i) '.htk'],squeeze(tmp2{1}),400);
%             end
            
        end
        %pac_ave(chanNum,:,:)=mean(pac(1,:,:,:),4);
        %amp_phase_ave(chanNum,:,:)=mean(amp_phase_all,4);
        %     figure
        %     imagesc(flipud(squeeze(mean(zscore(zScoreall(1).data{3}(chanNum,:,:,:),[],2),4))'))
        %     colorbar
        
        %keep(chanNum,:,:)=squeeze(mean(zScoreall(1).data{3}(chanNum,:,:,:),4))';
        %clear zScoreall
        
    end
%     plot256chan(amp_phase_ave,'polar')
%     saveas(gcf,'avepolar','fig')
%     plot256chan(amp_phase_ave,'cart')
%     saveas(gcf,'avecart','fig')
    
end

%%
%% Calculate PAC over entire duration
timeSeg=[-4:.5:8].*1000;

t3=regexp(allEventTimes(:,2),allConditions{2})
p3=find(cellfun(@(x) isequal(x,1),t3))
%dataC_all=zeros(256,(buffer(2)+buffer(1))*.4,40);
for folder=1:2
    handles.pathName=allpaths{folder}
    load([handles.pathName '/Analog/allConditions')
    load([handles.pathName '/Analog/allEventTimes')

    for e=1:length(timeSeg)
        clear dataC_all

        buffer=[timeSeg(e) timeSeg(e+1)-1];
        dest=sprintf('%s/PAC_allfreqs/alignedW_seg%i_%i_%i',handles.pathName,e,buffer(1),buffer(2))
        mkdir(dest)
        amp_phase_all=zeros(1,40,99,length(p3));
        pac=zeros(1,1,40,length(p3));

        for chanNum=25%[20 25 101 119 120 124 221 255]%12:256
            for i=1:10%length(p3)                       
                [R,I]=loadHTKtoEcog_onechan_complex_real_imag(handles.pathName,chanNum,floor([allEventTimes{p3(i)}*1000+buffer(1) allEventTimes{p3(i)}*1000+buffer(2)]));

                dataC_all(1,:,:)=complex(R,I)';

                for lf=8%[5,8,15,20,25,30]%[1:40]
                    hf=31;
                    [tmp, tmp2]=PAC_preprocesseddata(dataC_all(1,:,:),lf);
                    pac(1,1,:,i)=squeeze(tmp(1,lf,:));
                    amp_phase_all(1,:,:,i)=tmp2{1};

                    cd([dest])

                    cd(dest)
                   writehtk(['amp_phase' int2str(chanNum) '_t' int2str(i) '_lf' int2str(lf) '_hf' int2str(hf) '.htk'],squeeze(tmp),400,chanNum);
                   writehtk(['amp_phase' int2str(chanNum) '_t' int2str(i) '_lf' int2str(lf) '_hf' int2str(hf) '.htk'],squeeze(tmp),400,chanNum);

                end


            end
        end
    end
end
%%


%% Load PAC over entire duration
timeSeg=[-4:.5:8].*1000;
t3=regexp(allEventTimes(:,2),allConditions{2})
p3=find(cellfun(@(x) isequal(x,1),t3))
%dataC_all=zeros(256,(buffer(2)+buffer(1))*.4,40);
for folder=1:2
    handles.pathName=allpaths{folder}
    for e=1:length(timeSeg)-1

        buffer=[timeSeg(e) timeSeg(e+1)-1];
        dest=sprintf('%s/PAC_allfreqs/alignedW_seg%i_%i_%i',handles.pathName,e,buffer(1),buffer(2))   

        chanAll=[20 25 101 119 120 124 221 255];
        for chanNum=chanAll%12:256
            for i=1:10%length(p3)
                lowf=8%[5,8,15,20,25,30];
                for lf=lowf%[1:40]
                    hf=31;
                    cd(dest)
                    tmppac(lf,i)=readhtk(['pac' int2str(chanNum) '_t' int2str(i) '_lf' int2str(lf) '_hf' int2str(hf) '.htk']);
                    tmpPA(lf,:,i)=readhtk(['amp_phase' int2str(chanNum) '_t' int2str(i) '_lf' int2str(lf) '_hf' int2str(hf) '.htk']);

                end

                PA_all(e,chanNum,:,:)=nanmean(tmpPA,3);
                pac_all(e,chanNum,:)=nanmean(tmppac,2);
            end        
        end
    end
    pac(folder).phaseamp=PA_all;
    pac(folder).pac=pac_all;

end

%%
figure
for lf=lowf
    for chanNum=chanAll
            pcolor(squeeze(PA_all(:,chanNum,lf,:))')
            caxis([-.5 .5])
            colormap(flipud(pink))
            shading interp
            hold on
            time0=find(timeSeg==0);
            hl=line([time0 time0], [1 99])
            set(hl,'Color','r')
            title([chanNum lf])
            input('next')
    end
end
%%
figure
for lf=lowf
    for chanNum=chanAll
        tmp=squeeze(pac(1).pac(:,chanNum,lf,:))';
        plot(tmp)
        hold on
        tmp=squeeze(pac(2).pac(:,chanNum,lf,:))';
        plot(tmp,'r')
        
        plot(9,tmp(9),'g*')
        plot(11,tmp(11),'g*')
        
        hold off
        
        title([chanNum lf])
        input('next')
    end
end


%% load PAC from disk
event=3

dest=['E:\PreprocessedFiles\EC18\EC18_B2\PAC\event' int2str(event) '_pac_' int2str(buffer_all{event}(1)) '_' int2str(buffer_all{event}(2))];
for chanNum=1:256
    for i=1:10%length(p3)
        
        
        cd(dest)
        tmp=readhtk(['pac' int2str(chanNum) '_t' int2str(i) '.htk']);
        tmp2=readhtk(['amp_phase' int2str(chanNum) '_t' int2str(i) '.htk']);
        
        pac(1,:,:,i)=squeeze(tmp);
        amp_phase_all(1,:,:,i)=tmp2;
        
    end
    pac_ave(chanNum,:,:)=mean(pac(1,:,:,:),4);
    amp_phase_ave(chanNum,:,:)=mean(amp_phase_all,4);
    %     figure
    %     imagesc(flipud(squeeze(mean(zscore(zScoreall(1).data{3}(chanNum,:,:,:),[],2),4))'))
    %     colorbar
    
    %keep(chanNum,:,:)=squeeze(mean(zScoreall(1).data{3}(chanNum,:,:,:),4))';
    %clear zScoreall
    
end


% %%
%
% event=1
% dest=sprintf('E:/PreprocessedFiles/EC18/EC18_B1/segmentedSpectrograms/event%i',event)
% cd(dest)
%
% for chanNum=1:256
%     for i=1:10%length(p3)
%
%
%         tmp=readhtk(['spec' int2str(chanNum) '_t' int2str(i) '.htk']);
%         tmpall(i,:,:)=tmp;
%
%     end
%     specall(chanNum,:,:)=mean(tmpall,1);
% end
%%
plot256chan(pac_ave(:,8,:),'line')

plot256chan(amp_phase_ave,'cart')
plot256chan(amp_phase_ave,'polar')
plot256chan(spec_ave,'cart')
%%
figure
for f=25:39
    imagesc(reshape(squeeze(pac_ave(:,8,f)),[16 16])')
    colormap(flipud(pink))
    colorbar
    title(int2str(f))
    input('next')
end

%% save baseline files
newfolder='E:\PreprocessedFiles\EC18\EC18_rest'

%[data, sampFreq, tmp,chanNum] = readhtk ( 'Wav11.htk');
%handles.sampFreq=sampFreq;
%ecog.data=zeros(channelsTot,size(data,2),size(data,1));
%LOAD HTK FILES
for nBlocks=1:4
    for k=1:64
        varName=sprintf('Wav%s%s.htk',num2str(nBlocks),num2str(k));
        chanNum=(nBlocks-1)*64+k;
        fprintf('%i.\n',chanNum);
        [R,I]=loadHTKtoEcog_onechan_complex_real_imag(handles.pathName,chanNum,[ 280000 310000]);
        cd E:\PreprocessedFiles\EC18\EC18_rest\HilbReal_4to200_40band
        
        writehtk (varName, R, 400, chanNum);
        cd E:\PreprocessedFiles\EC18\EC18_rest\HilbImag_4to200_40band
        writehtk (varName, I, 400, chanNum);

        
        
    end
end

%%
dest='E:\PreprocessedFiles\EC18\EC18_rest\pac' 
for ch=1:256
    [R,I]=loadHTKtoEcog_onechan_complex_real_imag(newfolder,ch,[]);
            
            dataC_all(1,:,:)=complex(R,I)';
            %cd(dest)
            %writehtk(['spec' int2str(chanNum) '_t' int2str(i) '.htk'],data',400);
            %keep(chanNum,:,:,i)=data';
            
            for lf=[1:40]
                hf=31;
                [tmp, tmp2]=PAC_preprocesseddata(dataC_all(1,:,:),lf,hf);

                

                writehtk(['pac' int2str(chanNum) '_t' int2str(i) '.htk'],squeeze(tmp),400);
                writehtk(['amp_phase' int2str(chanNum) '_t' int2str(i) '.htk'],squeeze(tmp2{1}),400);
            end    
end
%%
%event=5;
handles.pathName='E:\PreprocessedFiles\EC18\EC18_B1\'
dest=[handles.pathName '\PAC\event' int2str(event)]

dest=[handles.pathName '\segmentedSpectrograms\event' int2str(event)]
handles.pathName='E:\PreprocessedFiles\EC18\EC18_B1'
load([handles.pathName '/Analog/allEventTimes']);
t3=regexp(allEventTimes(:,2),allConditions{event})

p3=find(cellfun(@(x) isequal(x,1),t3))
allEventTimes(p3,2)
dest=[handles.pathName '\segmentedSpectrograms\event' int2str(event)]
baselinefolder='E:\PreprocessedFiles\EC18\EC18_rest\HilbAA_4to200_40band'
figure
cd(sprintf('%s/Artifacts',handles.pathName))
load 'badTimeSegments.mat'
fid = fopen('badChannels.txt');
tmp = fscanf(fid, '%d');
badChannels=tmp';
fclose(fid);
coltot=16

%buffer_all{1}=[3000 3000]
seglength=floor(1200+buffer_all{event}(2)/1000*400)-floor(1200-buffer_all{event}(1)/1000*400);
%%
for chanNum=1:256
    i=chanNum;
    if ismember(i,badChannels)
        continue
    end
    m=floor(i/coltot);
    n=rem(i,coltot);
    
    if n==0
        n=coltot;
        m=m-1;
    end
    
    p(1)=6*(n-1)/100+.03;
    p(2)=6.2*(15-m)/100+0.01;
    
    p(3)=.055;
    p(4)=.055;
    
    h=subplot('Position',p);
    %%
    
    specall=zeros(10,seglength,40);
    for i=1:10%length(p3)
        %timeInt=[allEventTimes{p3(i),1}*1000-buffer(1) allEventTimes{p3(i),1}*1000+buffer(2)];
        %data=loadHTKtoEcog_onechan_complex(handles.pathName,chanNum,round(timeInt));
        cd(dest)
        %writehtk(['spec' int2str(chanNum) '_t' int2str(i) '.htk'],data',400);
        %keep(chanNum,:,:,i)=data';
        data=readhtk(['spec' int2str(chanNum) '_t' int2str(i) '.htk']);
        
        specall(i,:,:)=data(floor(1200-buffer_all{event}(1)/1000*400)+1:floor(1200+buffer_all{event}(2)/1000*400),:);
    end
    cd(baselinefolder)
    baseline=loadHTKtoEcog_onechan(chanNum,[]);
    meanbaseline=repmat(mean(baseline,2),[1,seglength]);
    stdbaseline=repmat(std(baseline,[],2),[1,seglength]);
    zScorespec=(squeeze(mean(specall,1))'-meanbaseline)./stdbaseline;
    %imagesc(flipud(zScorespec))
    %imagesc(flipud(zScorespec),[0 1])
    %subplot(1,2,1)
    pcolor(zScorespec)
    shading interp
    caxis([0 1])
    colormap(flipud(pink))
    %colorbar
    hold on
    plot(linspace(buffer_all{event}(1)/1000*400,buffer_all{event}(1)/1000*400,40),linspace(0,40,40),'k--');
    %{
    subplot(1,2,2)
    pcolor(squeeze(amp_phase_ave(chanNum,:,:)));shading interp
    caxis([0 .2])
    colorbar
    colormap(flipud(pink))
    set(gca,'xtick',[],'ytick',[])
    title(int2str(chanNum))

    %}
    %     set(gcf,'Color','w')
    %     set(gca,'XTick',0:400:2400)
    %     set(gca,'XTickLabel',[-3:3])
    %     set(gca,'YTick',[5:5:40])
    %
    %     set(gca,'YTickLabel',fliplr(round(cfs_all(1:5:40))))
    %     set(gca,'Box','off')
    %     set(gca,'fontsize',7)
    %     xlabel('time (seconds)')
    %     ylabel('Center Frequency (Hz)')
    title(['Electrode ' int2str(chanNum)])
    hold off
    %     uinput=input('next')
    %     if strmatch(uinput,'b')
    %         chanNum=chanNum-2;
    %     end
    
    %{
     for n=1:length(p3)
        imagesc(flipud((squeeze(specall(n,:,:))'-meanbaseline)./stdbaseline),[-1 7]);
        title(int2str(n))
        colorbar
        input('next')
     end
     
     
    imagesc(squeeze((zScoreall(1).data{3}(chanNum,:,usetrials(:,1))))')
    %}
    
    %     figure
    %     imagesc(flipud(squeeze(mean(zscore(zScoreall(1).data{3}(chanNum,:,:,:),[],2),4))'))
    %     colorbar
    
    %keep(chanNum,:,:)=squeeze(mean(zScoreall(1).data{3}(chanNum,:,:,:),4))';
    %clear zScoreall
end
%%
figure
for c=1:256
    plot(angle(dataC_all(c,:,8)));
    hold on
    plot(abs(dataC_all(c,:,35)),'r');
    axis([0 1600 -2 5])
    hold off
    input('next')
end

%%
figure(1)
figure(2)
t=19
for ch=1:256
    %%
    if ismember(ch,badChannels)
        continue
    end
    cd(['E:\PreprocessedFiles\EC18\EC18_B1\segmentedSpectrograms\event' int2str(event)])
    spec=readhtk(['spec' int2str(ch) '_t' int2str(t) '.htk']);
    cd(['E:\PreprocessedFiles\EC18\EC18_B1\PAC\event' int2str(event) '_pac_' int2str(buffer_all{event}(1)) '_' int2str(buffer_all{event}(2))])
    PA=readhtk(['amp_phase' int2str(ch) '_t' int2str(t) '.htk']);
    figure(1)
    subplot(4,1,1)
    title(int2str(ch))
    pcolor((mapstd(spec')))
    shading interp
    colormap(flipud(pink))
    caxis([0 3])
    hold on
    line([1200-buffer_all{event}(1)/1000*400 1200-buffer_all{event}(1)/1000*400],[ 0 40])
    line([1200+buffer_all{event}(2)/1000*400 1200+buffer_all{event}(2)/1000*400],[ 0 40])
    hold off
    
    freezeColors
    
    subplot(4,1,2)
    plot(mean(mapstd(spec(:,30:37)'),1),'k')
    axis tight
    
    subplot(4,1,3)
    pcolor(PA)
    %pcolor(squeeze(amp_phase_ave(ch,:,:)))
    caxis([0 .5])
    shading interp
    freezeColors
    
    subplot(4,1,4)
    patientID='EC18'
    ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,ch,[],2,[],[]);
    colormap('gray');
    
    
    figure(2)
    cd(['E:\PreprocessedFiles\EC18\EC18_B2\segmentedSpectrograms\event' int2str(event)])
    spec=readhtk(['spec' int2str(ch) '_t' int2str(t) '.htk']);
    cd(['E:\PreprocessedFiles\EC18\EC18_B2\PAC\event' int2str(event) '_pac_' int2str(buffer_all{event}(1)) '_' int2str(buffer_all{event}(2))])
    PA2=readhtk(['amp_phase' int2str(ch) '_t' int2str(t) '.htk']);
    
    subplot(4,1,1)
    title(int2str(ch))
    pcolor((mapstd(spec')))
    shading interp
    colormap(flipud(pink))
    caxis([0 3])
    hold on
    line([1200-buffer_all{event}(1)/1000*400 1200-buffer_all{event}(1)/1000*400],[ 0 40])
    line([1200+buffer_all{event}(2)/1000*400 1200+buffer_all{event}(2)/1000*400],[ 0 40])
    hold off
    
    freezeColors
    
    subplot(4,1,2)
    plot(mean(mapstd(spec(:,30:37)'),1),'k')
    axis tight
    
    subplot(4,1,3)
    pcolor(PA2)
    %pcolor(squeeze(amp_phase_ave(ch,:,:)))
    caxis([0 .5])
    shading interp
    freezeColors
    
    %keyboard
    
    %input('Next')
    tmp=corrcoef(PA,PA2)
    RX(ch)=tmp(1,2);
    %%
    %input('Next')
end
%%
PA_all=zeros(256,28,40,99);
PA2_all=zeros(256,28,40,99);
figure
for ch=1:256
    for t=1:28
        if ismember(ch,badChannels)
            continue
        end
        cd(['E:\PreprocessedFiles\EC18\EC18_B1\PAC\event' int2str(event) '_pac_' int2str(buffer_all{event}(1)) '_' int2str(buffer_all{event}(2))])
        PA=readhtk(['amp_phase' int2str(ch) '_t' int2str(t) '.htk']);
        PA_all(ch,t,:,:)=PA;

        cd(['E:\PreprocessedFiles\EC18\EC18_B2\PAC\event' int2str(event) '_pac_' int2str(buffer_all{event}(1)) '_' int2str(buffer_all{event}(2))])
        PA2=readhtk(['amp_phase' int2str(ch) '_t' int2str(t) '.htk']);
        PA2_all(ch,t,:,:)=PA2;
        
        %subplot(3,1,1)
        %imagesc(squeeze(mean(PA_all(ch,3,30:36,:),3))
        
        

%         subplot(2,1,1)
%         
%         plot(mean(PA(30:36,:),1))
%         hold on
%         plot(mean(PA2(30:36,:),1),'r')
%         hold off
%         title(int2str(ch))
%         
%         subplot(2,1,2)
%         patientID='EC18'
%         ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,ch,[],2,[],[]);
%         colormap('gray');
%         
%         input('next')

    end
end
%%
figure(1)
figure(2)
for ch=1:256
    if ismember(ch,badChannels)
        continue
    end
    figure(1)
    subplot(4,1,1)
    M=mean(PA_all(ch,:,31:36,:),3);
    Y=squeeze(mean(M,2))';
    E=squeeze(std(M,[],2)/sqrt(size(M,2)))';
    Y2=Y(~isnan(Y))
    E2=E(~isnan(E))
    [hl,hp]=errorarea(Y2,E2)
    Ya=Y;
    Ya(isnan(Ya))=0;
    
    hold on
    M=mean(PA2_all(ch,:,31:36,:),3);
    Y=squeeze(mean(M,2))';
    E=squeeze(std(M,[],2)/sqrt(size(M,2)))';
    Y2=Y(~isnan(Y))
    E2=E(~isnan(E))
    [hl,hp]=errorarea(Y2,E2)
    set(hp,'FaceColor','y')
    set(hl,'Color','r')
	Yp=Y;
    Yp(isnan(Yp))=0;
    
   
    
    axis([1 100 -.2 .2])
    XR=corrcoef(Ya,Yp)
    set(gcf,'Name',num2str(XR(1,2)))
    hold off
    
    subplot(4,1,2)
    imagesc(squeeze(mean(PA_all(ch,:,30:36,:),3)),[0 .5])
    colormap(flipud(pink))
    freezeColors
    subplot(4,1,3)
    imagesc(squeeze(mean(PA2_all(ch,:,30:36,:),3)),[0 .5])
    colormap(flipud(pink))
    freezeColors
    
    %figure(2)
    subplot(4,1,4)
    
    ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,ch,[],2,[],[]);
    colormap('gray');
    input('next')
end

%%
XR_all=zeros(1,256);

for ch=1:256
     if ismember(ch,badChannels)
        continue
     end
    M=mean(PA_all(ch,:,31:36,:),3);
    Y=squeeze(mean(M,2))';
    Ya=Y;
    Ya(isnan(Ya))=0;
    M=mean(PA2_all(ch,:,31:36,:),3);
    Y=squeeze(mean(M,2))';
    Yp=Y;
    Yp(isnan(Yp))=0;
    XR=corrcoef(Ya,Yp)
    XR_all(ch)=XR(1,2);
end
%%
figure
patientID='EC18'
ECogDataVis (['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' patientID],patientID,1:256,XR_all,1,[],[]);
%%

pathname='E:\PreprocessedFiles\EC18\EC18_B1\PAC_allfreqs\alignedW_seg1_-4000_-3501';
PA_all=zeros(256,99,40,40,56);
PA_all=NaN(12,99,40,1,1);
pac_all=NaN(12,40,1);
m=1;
for ch=1:12
    for lf=1:40
        for hf=31
            for t=1:56
                try
                    %filename=sprintf('amp_phase%i_t%i_lf%i_hf%i.htk',ch,t,lf,hf);
                    filename=sprintf('pac%i_t%i_lf%i_hf%i.htk',ch,t,lf,hf);

                    %tmp(t,:)=readhtk([pathname filesep filename]);    
                    tmp(t)=readhtk([pathname filesep filename]);    
                catch
                    %keyboard
                    missing{m}=filename;
                    m=m+1;
                end
                
                
            end
            %keyboard

            %PA_all(ch,:,lf,1,1)=nanmean(tmp,1);
            pac_all(ch,lf,1)=nanmean(tmp);
        end
    end
end
%%
figure
for ch=chanAll
    subplot(2,1,1)
    pcolor(squeeze(PA_all(ch,lowf,:)));shading interp
    caxis([-.5 .5])
    
    colormap(flipud(pink))
    text(1,-1,num2str(ch))
%     subplot(2,1,2)
%     
%     plot(squeeze(PA_all(ch,50,:)))
    input('Next')
end
%% load segmented files




