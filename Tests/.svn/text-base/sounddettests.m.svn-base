%Load Analog into GUI
handles.pathName='C:\Users\Angela_2\Documents\ECOGdataprocessing\ButtonPressAnalysis\EC2_B5'

cd(sprintf('%s/Artifacts',handles.pathName))
load 'badTimeSegments.mat'
handles.badTimeSegments=badTimeSegments;
fprintf('%d bad time segments loaded',size(handles.badTimeSegments,1));

fid = fopen('badChannels.txt');
tmp = fscanf(fid, '%d');
handles.badChannels=tmp';
fclose(fid);
fprintf('Bad Channels: %s',int2str(handles.badChannels));
cd(handles.pathName);

cd('Analog')
[a,b]=readhtk('ANIN1.htk');
r=resample(a,16000,round(b));
handles.sampFreq=16000;
handles.ecogFiltered.data=r;
handles.ecogFiltered.sampFreq=16000;
cd(handles.pathName)
guidata(hObject, handles);
return

%%
%plot segmented Analog Channels

for s=1:length(handles.segmentedEcogGrouped)
    figure
    subplot(2,2,1)
    d=handles.segmentedEcogGrouped{s};
    plot(squeeze(mean(d,4)))
    x=handles.segmentTimeWindow{s}(1)*handles.sampFreq/1000;
    hold on
    h=line([x,x],[min(squeeze(mean(d,4))) max(squeeze(mean(d,4)))])
    set(h,'Color','r')
    axis tight
    
    subplot(2,2,2)
    specgram(squeeze(mean(d,4)),[],handles.sampFreq)
    hold on
    x2=handles.segmentTimeWindow{s}(1)/1000;
    h2=line([x2,x2],[0 10000])
    set(h2,'Color','r')
    
    subplot(2,2,[3,4])
    o=0;
    for i=1:size(d,4)
        d2=squeeze(d(1,:,1,i))+o;
        plot(d2)
        hold on
        o=o-1;
        h=line([x,x],[min(squeeze(mean(d2,4))) max(squeeze(mean(d2,4)))])
        set(h,'Color','r')
    end

    axis tight
    set(gcf,'Name',num2str(s))
end
%%
%plot MATLAB spectrograms separately
for s=1:length(handles.segmentedEcogGrouped)
    d=handles.segmentedEcogGrouped{s}; 
    
    figure
    set(gcf,'Name',num2str(s))
    for i=1:size(d,4)
        tmp=squeeze(d(:,:,:,i));
        subplot(4,5,i)
        specgram(tmp,[],handles.sampFreq)
        hold on
        h=line([handles.segmentTimeWindow{s}(1)/1000 handles.segmentTimeWindow{s}(1)/1000],[0,8000]);
        set(h,'Color','r')
    end
end

%%
%calculate Nima's spectrograms
for s=1:length(handles.segmentedEcogGrouped)
    d=handles.segmentedEcogGrouped{s};  
    figure
    
    for i=1:size(d,4)
        tmp=squeeze(d(:,:,:,i));
        loadload;close;        
        aud{s}(:,:,i)= wav2aud6oct (tmp);

    end

end

%%
%Plot Nima's spectrograms individually
for s=1:length(handles.segmentedEcogGrouped)
    figure
    set(gcf,'Name',num2str(s))
    for i=1:size(d,4)
        subplot(4,5,i)
        imagesc ( aud{s}(:,:,i)' .^ 0.25);
        hold on
        h=line([handles.segmentTimeWindow{s}(1)/1000*100 handles.segmentTimeWindow{s}(1)/1000*100],[0,100]);
        set(h,'Color','r')
    end
end

%%
%plot ave Nima's spectrogram
for s=1:length(handles.segmentedEcogGrouped)
    figure
    set(gcf,'Name',num2str(s))
   
    imagesc ( mean(aud{s}(:,:,i),3)' .^ 0.25);
    hold on
    h=line([handles.segmentTimeWindow{s}(1)/1000*100 handles.segmentTimeWindow{s}(1)/1000*100],[0,100]);
    set(h,'Color','r')
end

%%
%calculate Nima's spectrograms
for s=1:6
    d=segAnalog.data{s};  
    figure
    
    for i=1:size(d,3)
        tmp=squeeze(d(:,:,i));
        loadload;close;        
        aud{s}(:,:,i)= wav2aud6oct (tmp);

    end

end
