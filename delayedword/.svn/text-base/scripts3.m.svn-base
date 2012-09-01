
for n=[2,3]   
            mkdir([allfiles{n} filesep 'HilbAA_4to200_40bands'])
            mkdir([allfiles{n} filesep 'HilbPhase_4to200_40bands'])
    for c=1:256
            [rd,id]=loadHTKtoEcog_onechan_complex_real_imag(allfiles{n},c,[]);
            aadata=abs(complex(rd,id));
            phasedata=angle(complex(rd,id));
            cd([allfiles{n} filesep 'HilbAA_4to200_40bands'])
            writehtk(['Ch' int2str(c) '.htk'],aadata,400);
            cd([allfiles{n} filesep 'HilbPhase_4to200_40bands'])

            writehtk(['Ch' int2str(c) '.htk'],phasedata,400);
    end
end


%%
for f=13:32
    x(f,:)=mean(tmp(ch,:,f,:),4);
    plot(mean(tmp(ch,:,f,:),4));
    hold on
end
%%

%%
    figure
    set(gcf,'Name',int2str(time))
    
    plv=zeros(size(base,2),test.channelsTot,test.channelsTot,40);
    for f=1:40
        %plv(:,:,:,f)=pn_eegPLV_modified(squeeze(handles.ecogBaseline.data(activech{2},:,f,:)),400,[],[]);
         plv(:,:,:,f)=pn_eegPLV_modified(base(:,:,f),400,[],[]);

        baseplv(:,:,:,f)=mean(plv(300:600,:,:,f),1);
        baseplvstd(:,:,:,f)=std(plv(300:600,:,:,f),[],1);
    end
    %% get baseline phase in segments
    l=size(ecogBaseline.phase,2);
    segbase=zeros(256,1200,40,10);
    for s=1:10
        start=round(l/10)*(s-1)+1;    
        segbase(:,:,:,s)=ecogBaseline.phase(:,start:start+1199,:);
    end
 %%   
    tmp=cat(1,phase12(f,:),phase115(f,:));
    l=size(tmp,2);
    segbase=zeros(2,2000,10);
     for s=1:10
        start=ceil(rand(1)*(l-2000))    
        segbase(:,:,s)=tmp(:,start:start+(2000-1));
     end
    bplv=pn_eegPLV_modified(segbase,400,[],[]);
    mean(bplv)
    
 %%   
    %%PLV of baseline segments
    figure
    for f=1:40
        baseplv=pn_eegPLV_modified(squeeze(segbase(:,:,f,:)),400,[],[]);
        subplot(5,8,f)
        imagesc(squeeze(mean(baseplv,1)))
        %bPLV(f).all=baseplv;
        bPLV(f).mean=mean(baseplv,1);
        bPLV(f).std=std(baseplv,[],1);
    end
    
    figure
    for f=1:40
        imagesc(squeeze(bPLV(f).mean))
        title(int2str(f))
        input('n')
    end
    
    figure
    for ch=1:256
        imagesc(squeeze((squeeze(baseplv(:,ch,:))+baseplv(:,:,ch)))')
        title(int2str(ch))
        colorbar
        input('n')
    end
    
%%    
    figure
    colormap gray
    for f=1:40
        subplot(5,8,f)
        tmp3=squeeze(bPLV(f).mean);
        visualizeGrid(0,'E:\General Patient Info\EC18\brain+grid_3Drecon.jpg',[])
        
        %dataplv=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(:,timeInt,f,:)),400,[],[]);
        %tmp3=squeeze(mean(dataplv,1)./bPLV(f).mean(1,test.usechans,test.usechans));
        
        for i=1:size(C2,1)
            connectStrength(1,i)=    tmp3(C2(i,1),C2(i,2));
        end
        %Y = prctile(connectStrength,99.5)
        Y=.8
        keep=find(connectStrength>Y)
        displayStruct.chanPairs=test.usechans(C2(keep,:))
        displayStruct.connectionStrength=connectStrength(keep)';
        
        
        y=xy(1,:)
        x=xy(2,:)
        
        cmapPos = ceil(size(cM, 1)/2)*ones(size(keep, 2), 1);
        
        for kk = 1:length(keep)
            plot3(y(displayStruct.chanPairs(kk, :)), x(displayStruct.chanPairs(kk, :)), [ELECTRODE_HEIGHT, ELECTRODE_HEIGHT], 'LineWidth', 2, 'Color', cM(cmapPos(kk), :));
            hold on
        end
        title(int2str(f))
        hold off
                input('next')

    end
    %%
    figure
for time=1:200:2400;
    
    for f=1:40
                    %subplot(5,8,f)
   
        %subplot(1,2,1)
            %time=400;
            %tmp2=squeeze(plv(time:time+99,:,:,f))./repmat(baseplv(:,:,:,f),[100 1 1 1]);
            %tmp3_a=squeeze(mean(tmp2,1));
            %imagesc(tmp3,[0 2])
            subplot(2,1,1)
            %time=400
            timeInt=time:time+199;
%            baseplv=pn_eegPLV_modified(squeeze(segbase(:,:,f,:)),400,[],[]);
           %bPLV.mean(f,:,:)=mean(baseplv,1);
           %bPLV.std(f,:,:)=std(baseplv,[],1);

           meanbaseplv=bPLV(f).mean(1,test.usechans,test.usechans);
           stdbaseplv=bPLV(f).std(1,test.usechans,test.usechans);

           
           
           dataplv=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(:,timeInt,f,:)),400,[],[]);


            %tmp2=squeeze((dataplv-repmat(meanbaseplv,[size(dataplv,1),1,1]))./repmat(stdbaseplv,[size(dataplv,1),1,1]));
            tmp3=squeeze(mean(dataplv,1)-meanbaseplv./stdbaseplv);
            %dPLV(f,:,:)=tmp3;
            %imagesc(tmp3,[-1.5 1.5])
            imagesc(tmp3)

            colorbar
             
            
%             subplot(2,1,2)
% 
%             time=1200
%             timeInt=time:time+199;
% %            baseplv=pn_eegPLV_modified(squeeze(segbase(:,:,f,:)),400,[],[]);
%            %bPLV.mean(f,:,:)=mean(baseplv,1);
%            %bPLV.std(f,:,:)=std(baseplv,[],1);
% 
%            meanbaseplv=bPLV(f).mean;
%            stdbaseplv=bPLV(f).std;
% 
%            
%            
%            dataplv=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(:,timeInt,f,:)),400,[],[]);
% 
% 
%            tmp3=squeeze(mean(dataplv,1))./squeeze(bPLV(f).mean);
% 
%             %dPLV(f,:,:)=tmp3;
%             %imagesc(tmp3,[-1.5 1.5])
%             imagesc(tmp3)
% 
%             colorbar
            
            
            
%             set(gca,'XTick',1:42)
%             set(gca,'YTick',1:42)
%             set(gca,'XTickLabel',[activech{2} ])
%             set(gca,'YTickLabel',[activech{2} ])
%             set(gca,'XAxisLocation','top')
%             set(gca,'YAxisLocation','right')

            title(int2str([time f]))
            keyboard
              %%


    %           figure
    %         visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',1:256)
    %         colormap gray
    %          chanPairs = nchoosek(activech{2},2)
    % 
    %          for i=1:666
    %             connectStrength(1,i)=    tmp3(C2(i,1),C2(i,2));
    %          end
    %          keep=find(connectStrength>1.2)
    % 
    %         displayStruct2.chanPairs=chanPairs(keep,:)
    %         displayStruct2.connectStrength=connectStrength(:,keep);
    %         hold on
    %         y=xy_org(1,:)
    %         x=xy_org(2,:)
    %         for kk = 1:length(keep)
    %             plot3(y(displayStruct2.chanPairs(kk, :)), x(displayStruct2.chanPairs(kk, :)), [ELECTRODE_HEIGHT, ELECTRODE_HEIGHT], 'LineWidth', 2, 'Color', cM(cmapPos(kk), :));
    %         end
              %input('n')
             % close

    end
        %keyboard
        SAVEPPT2('ppt',powerpoint_object,'n',['PLV Time Interval (200ms intervals): ' int2str(time) 'Sound responsive channels; 1200 is word end']);

 end
%%
figure
visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',1:256)
colormap gray
C2 = nchoosek(1:test.channelsTot,2)
connectStrength=zeros(1,size(C2,1));
load('E:\General Patient Info\EC22\regdata.mat')
for f=1:40
    for i=1:size(C2,1)
        connectStrength(1,i)=    tmp3(C2(i,1),C2(i,2));
    end
    keep=find(connectStrength>1.7)
    displayStruct2.chanPairs=C2(keep,:)
    displayStruct2.connectionStrength=connectStrength(keep)';

    hold on
    y=xy(1,:)
    x=xy(2,:)
    for kk = 1:length(keep)
        plot3(y(displayStruct2.chanPairs(kk, :)), x(displayStruct2.chanPairs(kk, :)), [ELECTRODE_HEIGHT, ELECTRODE_HEIGHT], 'LineWidth', 2)
    end
    title(int2str(f))
    hold off
    %keyboard
    input('next')
end
%%

figure
for f=1:40
    subplot(1,2,1)
    imagesc(squeeze(bPLV.mean(f,:,:)));
    colorbar
        subplot(1,2,2)

    imagesc(squeeze(bPLV.std(f,:,:)));
    colorbar
    keyboard
    
end

%%
for f=1:40
    subplot(5,8,f)
    imagesc(squeeze(dPLV(f,:,:)),[0 2])
end
%%
for ch=1:256
    subplot(2,1,1)
    tmp=squeeze((squeeze(dataplv(:,ch,:))+dataplv(:,:,ch)'))';
    imagesc(tmp)
    title(int2str(test.usechans(ch)))
    line([1200 1200],[0 256])
    colorbar
    
    subplot(2,1,2)
    mtmp=mean(tmp,2)-.5;
    %imagesc(reshape(mtmp,[16,16])')
    %plot(mtmp)
    
    ch_hold=find(mtmp>.5);
%     hold on
%     plot(ch_hold,mtmp(ch_hold),'ro')
    visualizeGrid(1,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',1:256,mtmp)

    title(int2str(ch_hold'))
    hold offh
    input('n')
end
%%
load('E:\DelayWord\EC22\EC22_B1\activech')
load('E:\General Patient Info\EC22\regdata.mat')
load E:\DelayWord\EC22\EC22_B2\PLV\baselinePLVmean
%%
load('E:\DelayWord\EC18\EC18_B1\activech')
load('E:\General Patient Info\EC18\regdata.mat')
load E:\DelayWord\EC18\EC18_rest\PLV\baselinePLV

%%
n=2
n=9
e=[6 7 8]
for e=6:7%2:5
test2=PLVtests([],n,e,20,unique([activech{2}]));
test2.electrodeXY=xy;
    test2.baselinePLV=bPLV;
    saveloc=['E:\DelayWord\Images\e ' int2str(e)];
    mkdir(saveloc)
    test2.doCompare(saveloc)
    clear test2
end
%%

vertcat(test2.baselinePLV.sigch)    
load E:\DelayWord\frequencybands.mat

%%
figure
%%
test=test2.test;
save_file='C:\Users\Angela_2\Documents\Presentations\DelayWordAutoImages5.ppt'
powerpoint_object=SAVEPPT2(save_file,'init')
%%
C2=nchoosek(test.usechans,2)
C2(:,3)=C2(:,2)-C2(:,1);
idx=find(C2(:,3)>50)
sigch=C2(idx,1:2);
%%
buffer=[2500 2500]
segsize=(sum(buffer)/1000)*400
midline=(buffer(1)/1000)*400
set(gcf,'Color','w')
for ch=size(sigch,1):-1:1
   usechan=[ find(test.usechans==sigch(ch,1)) find(test.usechans==sigch(ch,2))];
   chanNum=sigch(ch,:);
   subplot(2,4,1)
    for f=1:40 
        ptmp{f}=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(usechan,:,f,:)),400,[],[]); 
    end
    for f=1:40 
        ptmpall(:,f)=ptmp{f}(:,1,2);
        bmeanall(f)=bPLV(f).mean(1,chanNum(1),chanNum(2));
        bstdall(f)=bPLV(f).std(1,chanNum(1),chanNum(2));
  
    end
    
    ptmpall=(ptmpall-repmat(bmeanall,[segsize 1]))./repmat(bstdall,[segsize 1]);
    imagesc(flipud(ptmpall'),[-2 2])

    %imagesc(flipud(ptmpall'))
    title(['Aligned Word Onset(LW): PLV Channels ' int2str(chanNum)])
    hl=line([midline midline],[0 40]);
    set(hl,'Color','r')
    set(gca,'XTick',0:200:segsize)
    set(gca,'XTickLabel',[-buffer(1):500:buffer(2)])
       set(gca,'YTick',1:2:40)
    set(gca,'YTickLabel',int2str(flipud(frequencybands.cfs(1:2:39))))
    xlabel('Time (ms)')
   ylabel('Center Frequency (Hz)')
colorbar   


   subplot(2,4,2)
    for f=1:40 
        ptmp{f}=pn_eegPLV_modified(squeeze(test.segmentedEcog(2).phase(usechan,:,f,:)),400,[],[]); 
    end
    for f=1:40 
        ptmpall(:,f)=ptmp{f}(:,1,2);,
        
    end
    
    ptmpall=(ptmpall-repmat(bmeanall,[segsize 1]))./repmat(bstdall,[segsize 1]);
    imagesc(flipud(ptmpall'),[-2 2])
    %imagesc(flipud(ptmpall'))

    title(['Aligned Word Offset(LW): PLV Channels ' int2str(chanNum)])
    hl=line([midline midline],[0 40]);
    set(hl,'Color','r')
    set(gca,'XTick',0:200:segsize)
    set(gca,'XTickLabel',[-buffer(1):500:buffer(2)])
        set(gca,'YTick',1:2:40)
    set(gca,'YTickLabel',int2str(flipud(frequencybands.cfs(1:2:39))))
    xlabel('Time (ms)')
   ylabel('Center Frequency (Hz)')
   colorbar   
   
   subplot(2,4,3)
    for f=1:40 
        ptmp{f}=pn_eegPLV_modified(squeeze(test.segmentedEcog(3).phase(usechan,:,f,:)),400,[],[]); 
    end
    for f=1:40 
        ptmpall(:,f)=ptmp{f}(:,1,2);
        
  
    end
    
    ptmpall=(ptmpall-repmat(bmeanall,[segsize 1]))./repmat(bstdall,[segsize 1]);
    imagesc(flipud(ptmpall'),[-2 2])
    %imagesc(flipud(ptmpall'))

    title(['Aligned Response(LW): PLV Channels ' int2str(sigch(ch,:))])
    hl=line([midline midline],[0 40]);
    set(hl,'Color','r')
  set(gca,'XTick',0:200:segsize)
    set(gca,'XTickLabel',[-buffer(1):500:buffer(2)])
        set(gca,'YTick',1:2:40)
    set(gca,'YTickLabel',int2str(flipud(frequencybands.cfs(1:2:39))))
    xlabel('Time (ms)')
   ylabel('Center Frequency (Hz)')
colorbar   
   
   
   subplot(2,4,4)
   
    visualizeGrid(2,['E:\General Patient Info\' test.patientID '\brain+grid_3Drecon_cropped.jpg'],sigch(ch,:))
    
    
    f=9
      test3.usechans=chanNum;
   test3.channelsTot=length(test3.usechans);
   test3.loadBaselineFolder('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','phase');
   
   baseline=test3.ecogBaseline.phase(:,:,f);
 
   
   for e=[1 2 3]
       
       
       
       subplot(2,4,e+4)
       stack1=squeeze(test.segmentedEcog(e).phase(usechan(1),:,:,:));
       stack2=squeeze(test.segmentedEcog(e).phase(usechan(2),:,:,:));
       [ps,realPLV,bse]=PLVstats(squeeze(stack1(:,f,:))',squeeze(stack2(:,f,:))',baseline,bPLV(f),chanNum);
        plot(realPLV)
        hl=line([midline midline],[-2 2]);
        set(hl,'Color','r')
        hold on
        try
            plot(find(ps<=.001 & abs(realPLV)>=bse),0,'.k')
        end
               
        axis([0 2000 -2 2])
        
        hold off
   end
    
    
    %r=input('next','s');
    r='y'
    if strmatch(r,'y')
        saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
    end
    % pause(1)

end


%% PLV significance test
figure
%%
buffer=[2500 2500]
segsize=(sum(buffer)/1000)*400
midline=(buffer(1)/1000)*400
set(gcf,'Color','w')
f=9;
for ch=size(sigch,1):-1:1
   usechan=[ find(test.usechans==sigch(ch,1)) find(test.usechans==sigch(ch,2))];
   chanNum=sigch(ch,:);
    test3=segmentedData('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band',0)   
   test3.usechans=chanNum;
   test3.channelsTot=length(test3.usechans);
   test3.loadBaselineFolder('E:\DelayWord\EC22\EC22_B2\HilbReal_4to200_40band','phase');
   
   baseline=test3.ecogBaseline.phase(:,:,f);
 
   
   for e=[1 2 3]
       sigdata=zeros(40,2000);
       
              plvdata=zeros(40,2000);

       for f=1:40
            stack1=squeeze(test.segmentedEcog(e).phase(usechan(1),:,:,:));
           stack2=squeeze(test.segmentedEcog(e).phase(usechan(2),:,:,:));
            [ps,realPLV,bse]=PLVstats(squeeze(stack1(:,f,:))',squeeze(stack2(:,f,:))',baseline,bPLV(f),chanNum);
            
            idx=find(ps<=.001 & abs(realPLV)>=bse);
            sigdata(f,idx)=realPLV(idx);
            plvdata(f,:)=realPLV;
            
       end
       
       cd(['E:\DelayWord\EC22\EC22_B2\PLV\event' int2str(e)])
       save(['sigdata' int2str(chanNum)],'sigdata','-v7.3')
       save(['plvdata' int2str(chanNum)],'plvdata','-v7.3')

       %subplot(2,4,e+4)
       subplot(1,3,e)
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
    %r=input('next','s');
    r='y'
    if strmatch(r,'y')
        saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
    end
    dos('cmd /c "echo off | clip"')

   
end

