function HFOGUI

w=600;
l=600;
m1=10;
c1=151;

hf=figure('MenuBar','none','Name','HFO GUI','NumberTitle','off','Position',[100,100,w,l],'CloseRequestFcn',@my_closereq);
assignin('base','figureHandle',hf)

hPath=uicontrol('Style','Edit','String','GetPath','Position',[m1,.9*l,c1,20], 'HorizontalAlignment','left');

hTimeInterval=uicontrol('Style','Edit','String',' Set Time Interval [ms ms]','Position',[2*m1+c1,.9*l,c1,20], 'HorizontalAlignment','left');
uicontrol('Style','PushButton','String','Load Data and Downsample (1200 Hz)','Position',[3*m1+2*c1,.9*l,c1,20],'CallBack',@loadData);
uicontrol('Style','PushButton','String','Load Complex Data','Position',[3*m1+2*c1,.85*l,c1,20],'CallBack',@loadComplexData);
uicontrol('Style','PushButton','String','FIR bandpass (ripple and HFO)','Position',[3*m1+2*c1,.8*l,c1,20],'CallBack',@bandPassFilter);

freqBands=num2cell(1:45);
hFreqBand=uicontrol('Style','ListBox','Position',[2*m1+c1,.5*l,c1,.35*l],'Max',50,'String',horzcat(freqBands,'All'),'Value',46);




hEcogSet=uicontrol('Style','ListBox','Position',[m1,.5*l,c1,.35*l],'Max',50);

uicontrol('Style','PushButton','String','Detect HFOs','Position',[m1,.4*l,c1,20],'CallBack',@detectHFO);
uicontrol('Style','PushButton','String','Scroll Data','Position',[m1,.35*l,c1,20],'CallBack',@scrollData);

uicontrol('Style','PushButton','String','plotHFOs','Position',[m1,.3*l,c1,20],'CallBack',@plotHFOs);

uicontrol('Style','PushButton','String','visualize HFO counts','Position',[m1,.25*l,c1,20],'CallBack',@hfoCounts);
uicontrol('Style','PushButton','String','Pause in Command Line','Position',[m1,.1*l,c1,20],'CallBack',@commandLine);

%handles.ecogH=[]
handles.ecogDS=[];
guidata(hf,handles);

%%

    function loadComplexData(varargin,tmp)
        keyboard;
        chanTot=256;
        handles=guidata(hf)
        filename= get(hPath,'String');
        [~,tmp,~]=fileparts(filename);
        tmp=regexp(tmp,'_','split','once');
        handles.patientID=tmp{1};
        
        if strmatch(get(hTimeInterval,'String'),'Get Time Interval')
            timeInt=[];
        else
            timeInt=str2num(get(hTimeInterval,'String'));
        end
        
        %tmp=get(hFreqBand,'String');
        pval=get(hFreqBand,'Value');
        %freqBand=tmp(pval);
        cd([ filename '\HilbReal_4to500_45band_1200Hz'])
        r=loadHTKtoEcog_onechan(1,timeInt)';
        if pval==46
           freqDim=45;
        else 
            freqDim=length(pval);
        end
        
        handles.ecogFiltered.data=zeros(256,size(r,1),freqDim);
        for chanNum=1:chanTot
            cd([ filename '\HilbReal_4to500_45band_1200Hz'])
            r=loadHTKtoEcog_onechan(chanNum,timeInt)';
            
            cd([ filename '\HilbImag_4to500_45band_1200Hz'])
            i=loadHTKtoEcog_onechan(chanNum,timeInt)';
            
            %ecogcomplex.data(chanNum,:,:)=complex(r,i);
            if pval~=46
                r=r(:,pval);
                i=i(:,pval);
                
            end
            handles.ecogFiltered.data(chanNum,:,:)=abs(complex(r,i));
        end
        
        
        try
            cd([filename filesep 'Artifacts'])
            tmp=load('badTimeSegments.mat');
            handles.ecogFiltered.badIntervals=tmp.badTimeSegments;
        catch
            handles.ecogFiltered.badIntervals=[];
        end
        
        try
            fid = fopen('badChannels.txt');
            handles.ecogFiltered.badChannels = fscanf(fid, '%d')';
            fclose(fid);
        catch
            handles.ecogFiltered.badChannels=[];
        end
        
        goodch=setdiff(1:256,handles.ecogFiltered.badChannels);
        %handles.ecogFiltered.data(goodch,:)=detrend(handles.ecogFiltered.data(goodch,:),'constant');
        
        if ~isempty(handles.ecogFiltered.badIntervals)
            if ~isempty(timeInt)
                badIntervals=sortrows(handles.ecogFiltered.badIntervals,1);
                badIntervals(find(badIntervals(:,2)>timeInt(2)/1000 | badIntervals(:,1)<timeInt(1)/1000),:)=[];
                handles.ecogFiltered.badIntervals=badIntervals;
            end
        end
        
        handles.ecogFiltered.selectedChannels=1:size(handles.ecogFiltered.data,1);
        handles.ecogFiltered.sampDur=1000/1200;
        handles.ecogFiltered.sampFreq=1200;
        handles.ecogFiltered.timebase=[0:(size(handles.ecogFiltered.data,2)-1)]*handles.ecogFiltered.sampDur;
        handles.ecogFiltered.badChannels=[];
        handles.ecogFiltered.badTimeSegments=[];
        handles.ecogFiltered.badIntervals=[];
        
        %handles.ecogDS.env=ecogH.data;
        %handles.ecogDS.bandpassed=ecogH.data;
         if pval==46
             pval=1:45;
         end
        for fband=1:length(pval)
            newfield=sprintf('ecogFreq%i',pval(fband));
            handles.(newfield)=handles.ecogFiltered;
            handles.(newfield).data=handles.ecogFiltered.data(:,:,fband);
        end
        
        fprintf('Done')
        
        set(hEcogSet, 'String',fieldnames(handles));
        guidata(hf,handles);
    end

%%
    function loadData(varargin,tmp)
        chanTot=256;
        handles=guidata(hf)
        filename= get(hPath,'String');
        [~,tmp,~]=fileparts(filename);
        tmp=regexp(tmp,'_','split','once');
        handles.patientID=tmp{1};
        
        if strmatch(get(hTimeInterval,'String'),'Get Time Interval')
            timeInt=[];
        else
            timeInt=str2num(get(hTimeInterval,'String'));
        end
        ecog=loadHTKtoEcog_CT([filename filesep 'RawHTK'],chanTot,timeInt)
        baselineDurMs=0;
        sampDur=1000/ecog.sampFreq;
        ecog=ecogRaw2EcogGUI(ecog.data,baselineDurMs,sampDur,[],ecog.sampFreq);
        sprintf('Length of Recording: %i\n',size(ecog.data,2)/ecog.sampFreq);
        
        handles.ecogDS.sampFreq=1200;
        handles.ecogDS=downsampleEcog(ecog,handles.ecogDS.sampFreq);
        
        
        handles.ecogDS.data=detrend(handles.ecogDS.data')';
        
        handles.ecogDS.sampFreq=1200;
        
        handles.ecogDS.sampDur=1000/handles.ecogDS.sampFreq;
        handles.ecogDS.selectedChannels=1:size(handles.ecogDS.data,1);
        handles.ecogDS.sampDur=1000/1200;
        handles.ecogDS.sampFreq=1200;
        handles.ecogDS.timebase=[0:(size(handles.ecogDS.data,2)-1)]*handles.ecogDS.sampDur;
        handles.ecogDS.badChannels=[];
        
        try
            cd([filename filesep 'Artifacts'])
            tmp=load('badTimeSegments.mat');
            handles.ecogDS.badIntervals=tmp.badTimeSegments;
        catch
            handles.ecogDS.badIntervals=[];
        end
        
        try
            fid = fopen('badChannels.txt');
            handles.ecogDS.badChannels = fscanf(fid, '%d')';
            fclose(fid);
        catch
            handles.ecogDS.badChannels=[];
        end
        
        goodch=setdiff(1:chanTot,handles.ecogDS.badChannels);
        handles.ecogDS.data(goodch,:)=detrend(handles.ecogDS.data(goodch,:),'constant');
        
        if ~isempty(handles.ecogDS.badIntervals)
            if ~isempty(timeInt)
                badIntervals=sortrows(handles.ecogDS.badIntervals,1);
                badIntervals(find(badIntervals(:,2)>timeInt(2)/1000 | badIntervals(:,1)<timeInt(1)/1000),:)=[];
                handles.ecogDS.badIntervals=badIntervals;
            end
        end
        set(hEcogSet, 'String',fieldnames(handles));
        guidata(hf,handles);
        %rmfield(handles,'ecog');
                fprintf('Done')

    end
%%
    function bandPassFilter(varargin)
        handles=guidata(hf);
        handles.ecogHigh=handles.ecogDS;
        handles.ecogLow=handles.ecogDS;
        
        fprintf('\nFiltering Begin...')
        [b,a]=fir2(1000,[0 70 80 140 150 600]/600,[0 0 1 1 0 0]);
        handles.ecogLow.data=filtfilt(b,a,handles.ecogDS.data')';
        
        %HFO(200-500 Hz)
        [b,a]=fir2(1000,[0 200 210 490 500 600]/600,[0 0 1 1 0 0]);
        handles.ecogHigh.data=filtfilt(b,a,handles.ecogDS.data')';
        guidata(hf,handles);
        fprintf('Filtering Done\n')
        
        
        handles.ecogLow.data(handles.ecogDS.badChannels,:)=0;
        handles.ecogHigh.data(handles.ecogDS.badChannels,:)=0;
              set(hEcogSet, 'String',fieldnames(handles));
        guidata(hf,handles);        fprintf('Done')

    end


%%
    function detectHFO(varargin)
        handles=guidata(hf);
        %keyboard
        
            
            tmp=get(hEcogSet,'String');
            pval=get(hEcogSet,'Value');
            workingSet=tmp(pval);
            if strcmp(workingSet{1},'ecogHigh') | strcmp(workingSet{1},'ecogLow')
                handles.ecogLow=HFODetectionFunction_improved(handles.ecogLow,1);
                handles.ecogHigh=HFODetectionFunction_improved(handles.ecogHigh,1);
            else
                for i=1:size(workingSet)
                    handles.(workingSet{i})=HFODetectionFunction_improved(handles.(workingSet{i}),2);
                end
            end

        
        guidata(hf,handles);        fprintf('Done')

    end

%%
%{
    function getWorkingSet(varargin)
        handles=guidata(hf);
        tmp=get(hEcogSet,'String');
        pval=get(hEcogSet,'Value');
        eval(sprintf('handles.ecogH=handles.%s', tmp{pval}))
        guidata(hf,handles);
    end
%}
%%
    function scrollData(varargin)
        handles=guidata(hf);
        
        tmp=get(hEcogSet,'String');
        pval=get(hEcogSet,'Value');
        workingSet=tmp(pval);
        ecogTSGUI(handles.(workingSet{1}))
        guidata(hf,handles);        fprintf('Done')

    end
%%
    function plotHFOs(varargin)
        handles=guidata(hf);
        figure
        tmp=get(hEcogSet,'String');
        pval=get(hEcogSet,'Value');
            workingSet=tmp(pval);
        
        try
            figure;
            plot(handles.ecogHigh.x,handles.ecogHigh.y,'r.');
            hold on
            plot(handles.ecogLow.x,handles.ecogLow.y,'.');
        catch
            figure;hold on;
            for i=1:size(workingSet)
                  plot(handles.(workingSet{i}).x,handles.(workingSet{i}).y,'.')
            end
        end
        fprintf('Done')

    end

%%
    function hfoCounts(varargin,N2,r,c)
        figure
        tmp=get(hEcogSet,'String');
        pval=get(hEcogSet,'Value');
        workingSet=tmp(pval);
        
        if strmatch(workingSet{1},'ecogHigh')
            N2=[handles.ecogHigh.hfoCounts handles.ecogLow.hfoCounts]';
            flag=5
        else
            N2=sum(handles.(workingSet{:}).hfoCounts,2);
            flag=5;
            N2=repmat(N2,1,2)';
        end
        try
            visualizeGrid(flag,['C:\Users\Angela_2\Dropbox\ChangLab\General Patient Info\' handles.patientID '\brain_3Drecon.jpg'],1:256,N2)
        catch
            if size(handles.ecogDS.data,1)>64
                subplot(1,2,2)
                imagesc(reshape(N2(1,1:64),16,16)')

                ro=16; co=16;
                set(gca,'XGrid','on')
                set(gca,'YGrid','on')
                set(gca,'XTick',[1.5:16.5])
                set(gca,'YTick',[1.5:(ro+.5)])
                set(gca,'XTickLabel',[])
                set(gca,'YTickLabel',[])
                for c=1:16
                    for r=1:ro
                        text(c,r,num2str((r-1)*16+c))
                        if ismember((r-1)*16+c,handles.ecogDS.badChannels)
                            text(c,r,num2str((r-1)*16+c),'Background','y')
                        end
                    end
                end
                colorbar
                title('High')

                subplot(1,2,1)
                imagesc(reshape(N2(2,1:64),16,16)')

                r=16; c=16;
                set(gca,'XGrid','on')
                set(gca,'YGrid','on')
                set(gca,'XTick',[1.5:16.5])
                set(gca,'YTick',[1.5:(r+.5)])
                set(gca,'XTickLabel',[])
                set(gca,'YTickLabel',[])
                for c=1:16
                    for r=1:r
                        text(c,r,num2str((r-1)*16+c))
                        if ismember((r-1)*16+c,handles.ecogDS.badChannels)
                            text(c,r,num2str((r-1)*16+c),'Background','y')
                        end
                    end
                end


                colorbar
                title('Low')
            elseif size(handles.ecogDS.data,1)==64
                subplot(1,2,2)
                imagesc(reshape(N2(1,1:size(handles.ecogDS.data,1)),8,8)')

                
                set(gca,'XGrid','on')
                set(gca,'YGrid','on')
                set(gca,'XTick',[1.5:8.5])
                set(gca,'YTick',[1.5:(8.5)])
                set(gca,'XTickLabel',[])
                set(gca,'YTickLabel',[])
                %{
                for c=1:8
                    for r=1:r
                        text(c,r,num2str((r-1)*16+c))
                        if ismember((r-1)*16+c,handles.ecogDS.badChannels)
                            text(c,r,num2str((r-1)*16+c),'Background','y')
                        end
                    end
                end
                %}
                colorbar
                title('High')

                subplot(1,2,1)
                imagesc(reshape(N2(2,1:64),8,8)')

                r=16; c=16;
                set(gca,'XGrid','on')
                set(gca,'YGrid','on')
                set(gca,'XTick',[1.5:16.5])
                set(gca,'YTick',[1.5:(r+.5)])
                set(gca,'XTickLabel',[])
                set(gca,'YTickLabel',[])
                %{
                for c=1:16
                    for r=1:r
                        text(c,r,num2str((r-1)*16+c))
                        if ismember((r-1)*16+c,handles.ecogDS.badChannels)
                            text(c,r,num2str((r-1)*16+c),'Background','y')
                        end
                    end
                end
                %}

                colorbar
                title('Low')
                
            end
                
                        fprintf('Done')

                
        end
    end
%%

end

function commandLine(varargin)
handles=guidata(varargin{1});
keyboard
end

%%
function my_closereq(varargin)
% User-defined close request function 
% to display a question dialog box 
   selection = questdlg('Close This Figure?',...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         delete(gcf)
      case 'No'
      return 
   end
end