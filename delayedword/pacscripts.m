allpaths{1}='E:\PreprocessedFiles\EC18\EC18_B1';
allpaths{2}='E:\PreprocessedFiles\EC18\EC18_B2';
allpaths{3}='E:\PreprocessedFiles\EC18\EC18_rest';

chanAll=1:256%[20 25 101 119 120 124 221 255];
lowf=[5,8,15,20,25,30];
highf=31;
trials=1:10;
timeSeg=[-4:.5:8].*1000;
lowf=8

%% Calculate PAC over entire duration
timeSeg=[-4:.5:8].*1000;

for folder=1:2
    handles.pathName=allpaths{folder};
    load([handles.pathName '/Analog/allConditions']);
    load([handles.pathName '/Analog/allEventTimes']);
    t3=regexp(allEventTimes(:,2),allConditions{1});
    p3=find(cellfun(@(x) isequal(x,1),t3));
    for e=1:length(timeSeg)-1
        clear dataC_all        
        buffer=[timeSeg(e) timeSeg(e+1)-1];
        dest=sprintf('%s/PAC_allfreqs_v2/alignedW_seg%i_%i_%i',handles.pathName,e,buffer(1),buffer(2));
        mkdir(dest)
        amp_phase_all=zeros(1,40,99,length(p3));
        pac=zeros(1,1,40,length(p3));        
        for chanNum=chanAll
            for i=1%trials
                [R,I]=loadHTKtoEcog_onechan_complex_real_imag(handles.pathName,chanNum,floor([allEventTimes{p3(i)}*1000+buffer(1) allEventTimes{p3(i)}*1000+buffer(2)]));
                dataC_all(1,:,:)=complex(R,I)';                
                for lf=8%[5,8,15,20,25,30]%[1:40]
                    for hf=highf
                        [tmp, tmp2]=PAC_preprocesseddata(dataC_all(1,:,:),lf);
                        pac(1,1,:,i)=squeeze(tmp(1,lf,:));
                        amp_phase_all(1,:,:,i)=tmp2{1};                    
                        cd(dest)
                        writehtk(['amp_phase' int2str(chanNum) '_t' int2str(i) '_lf' int2str(lf) '_hf' int2str(hf) '.htk'],squeeze(tmp2{1}(lf,:)),400,chanNum);
                        writehtk(['pac' int2str(chanNum) '_t' int2str(i) '_lf' int2str(lf) '_hf' int2str(hf) '.htk'],squeeze(tmp(1,lf,hf)),400,chanNum);
                    end
                end
            end
        end
    end
end

%% Load PAC over entire duration
for folder=1:2
    handles.pathName=allpaths{folder};
    load([handles.pathName '/Analog/allConditions']);
    load([handles.pathName '/Analog/allEventTimes']);
    t3=regexp(allEventTimes(:,2),allConditions{2});
    p3=find(cellfun(@(x) isequal(x,1),t3));
    for e=1:8%length(timeSeg)-1        
        buffer=[timeSeg(e) timeSeg(e+1)-1];
        dest=sprintf('%s/PAC_allfreqs_v2/alignedW_seg%i_%i_%i',handles.pathName,e,buffer(1),buffer(2))
        for chanNum=chanAll
            for i=1%trials
                for lf=lowf
                    for hf=highf
                        cd(dest)
                        tmppac(1,i)=readhtk(['pac' int2str(chanNum) '_t' int2str(i) '_lf' int2str(lf) '_hf' int2str(hf) '.htk']);
                        tmpPA(1,:,i)=readhtk(['amp_phase' int2str(chanNum) '_t' int2str(i) '_lf' int2str(lf) '_hf' int2str(hf) '.htk']);
                    end
                end
                PA_all(e,chanNum,:,:)=nanmean(tmpPA,3);
                pac_all(e,chanNum,:)=nanmean(tmppac,2);
            end
        end
    end
    pacstruct(folder).phaseamp=PA_all;
    pacstruct(folder).pac=pac_all;
end

%% Plot phase-amp plots per channel
figure
for lf=lowf
    for chanNum=chanAll
        subplot(2,1,1)
        pcolor(squeeze(pacstruct(1).phaseamp(:,chanNum,lf,:))')
        caxis([-.5 .5])
        colormap(flipud(pink))
        shading interp
        hold on
        time0=find(timeSeg==0);
        hl=line([time0 time0], [1 99])
        set(hl,'Color','r')
        title([chanNum lf])
        
        
        subplot(2,1,2)
        pcolor(squeeze(pacstruct(2).phaseamp(:,chanNum,lf,:))')
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
%% plot PAC per channel at all timepoints
figure
for lf=1%lowf
    for chanNum=chanAll
        tmp=squeeze(pacstruct(1).pac(:,chanNum))';
        plot(tmp)
        hold on
        tmp=squeeze(pacstruct(2).pac(:,chanNum))';
        plot(tmp,'r')
        
        hp=patch([9 9 11 11],[0 .1 .1 0],'y');
        set(hp,'EdgeColor','none')
        set(hp,'FaceAlpha',.2)
        
        tmp=squeeze(pacstruct(3).pac(:,chanNum))';
        plot(tmp,'g')        
        
        axis([0 24 0 .05])
        hold off
        
        title([chanNum lf])
        input('next')
    end
end
%%
PAC