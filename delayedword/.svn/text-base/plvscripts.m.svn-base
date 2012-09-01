function plvscripts(test,xy)
%%Initialize
% allfiles=    {
%     'E:\DelayWord\EC16\EC16_B1';
%     'E:\DelayWord\EC18\EC18_B1';
%     'E:\DelayWord\EC20\EC20_B18';
%     'E:\DelayWord\EC20\EC20_B23';
%     'E:\DelayWord\EC20\EC20_B54';
%     'E:\DelayWord\EC20\EC20_B64';
%     'E:\DelayWord\EC20\EC20_B67';
%     'E:\DelayWord\EC21\EC21_B1';
%     'E:\DelayWord\EC22\EC22_B1'
%     }
% n=9;
% test=SegmentedData([allfiles{n} '/HilbReal_4to200_40band'],[],0);
% 
% test.usechans=1:256%activech{e}
% test.channelsTot=length(test.usechans);
% 
% 
% %test.segmentedDataEvents40band({[repmat([42;43],[1,40]);1:40]},{[3000 3000]},'keep',10)
% test.segmentedDataEvents40band({[1:40;repmat(42,[1,40])]},{[3000 3000]},'keep',10,'phase')
% clear global
% global test
% 
% test.Params.sorttrials=0;
%test.segmentedDataEvents40band({[1:40;repmat(42,[1,40])]},{[1000 1000]},'keep',20,'complex')
%
% for low=2:30
%     for t=1:20
%         [pac(t).pac,pac(t).ave_amp_phase]=PAC_preprocesseddata(test.segmentedEcog(1).complex(:,:,:,t),low,32);
%     end
% end


    save_file='C:\Users\Angela_2\Documents\Presentations\DelayWordAutoImages5.ppt'
    powerpoint_object=SAVEPPT2(save_file,'init')

    %% Look at PLV of 1 chan compared to all other chan for entire timeseries

    f1=figure
    f2=figure
    data=zeros(1,256);
    timeInt=1200:1400;
    for timeInt=1:200:2200
        for f=4:40
            figure(f1)
            dataplv=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(:,:,f,:)),400,[],[]);
            for ch=1:test.channelsTot
                subplot(2,1,1)

                comparePLVchans
                %SAVEPPT2('ppt',powerpoint_object,'n',['PLV ch= ' int2str(ch) 'f= ' int2str(f)]);

                %input('n')
                saveas(gcf,['ch' int2str(ch) 'f' int2str(f) 't' int2str(timeInt(1))],'fig')

            end
            
            figure(f2)
            visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',1:256)
            colormap gray
            C2 = nchoosek(1:test.channelsTot,2)
            connectStrength=zeros(1,size(C2,1));
            %load('E:\General Patient Info\EC22\regdata.mat')
            
            visualizePLVconnections
            cd('E:\DelayWord\Images')
            saveas(gcf,['f' int2str(f) 't' int2str(timeInt(1))],'fig')
            %SAVEPPT2('ppt',powerpoint_object,'n',['PLV ch= 1:256' int2str(ch) ...
               % 'f= ' int2str(f) 'time= ' int2str([timeInt(1) timeInt(end)])]);
            %input('next')          
        end
    end

    function comparePLVchans
        tmp=squeeze((squeeze(dataplv(:,ch,:))+dataplv(:,:,ch)))';
        imagesc(tmp)
        title(['ch ' int2str(test.usechans(ch)) 'f ' int2str(f)])
        line([1200 1200],[0 test.channelsTot])
        %colorbar
        
        subplot(2,1,2)
        mtmp=mean(tmp(:,timeInt),2);
        %imagesc(reshape(mtmp,[16,16])')
        %plot(mtmp)
        
        ch_hold=find(mtmp>.3);
        data(test.usechans)=mtmp;
        %     hold on
        %     plot(ch_hold,mtmp(ch_hold),'ro')
        visualizeGrid(1,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',1:256,data)
        
        title(int2str(ch_hold'))
    end



%% visualize connections on brain pic


    visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',test.usechans)
    C2 = nchoosek(1:test.channelsTot,2)
    connectStrength=zeros(1,size(C2,1));
    load('E:\General Patient Info\EC22\regdata.mat')
    timeInt=400:1200%800%800:1200%1200:1600;
    cM= jet
    ELECTRODE_HEIGHT=2;
    bounds=[.2 -.3]
    boundcolors={'g' 'r','b'}
    timeInt=1200:1600;
    for f=1:40
        visualizePLVconnections
        input('next')
    end
    
    function visualizePLVconnections
        subplot(1,2,1)
        visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',test.usechans)
        %keyboard

        dataplv=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(:,timeInt,f,:)),400,[],[]);
        %tmp3=squeeze(mean(dataplv,1)-bPLV(f).mean(1,test.usechans,test.usechans))./squeeze(bPLV(f).std(1,test.usechans,test.usechans));
        %tmp3=squeeze(mean(dataplv,1)-bPLV(f).mean(1,test.usechans,test.usechans));

        tmp3=squeeze(mean(dataplv(1:400,:,:),1))-squeeze(mean(dataplv(401:800,:,:),1));
        %tmp3=squeeze(bPLV(f).mean(1,test.usechans,test.usechans));
        for i=1:size(C2,1)
            connectStrength(1,i)=    tmp3(C2(i,1),C2(i,2));
        end
        %Y = prctile(connectStrength,95)
        for idx=1
            Y=bounds(idx);

            %Y = prctile(connectStrength,99.5)

            linecolor=boundcolors{idx};

            if idx==1
                keep=find(connectStrength>Y)
            else
                 keep=find(connectStrength<Y)
            end
            displayStruct.chanPairs=test.usechans(C2(keep,:))
            displayStruct.connectionStrength=connectStrength(keep)';


            y=xy(1,:)
            x=xy(2,:)

            cmapPos = ceil(size(cM, 1)/2)*ones(size(keep, 2), 1);

            for kk = 1:length(keep)
                plot3(y(displayStruct.chanPairs(kk, :)), x(displayStruct.chanPairs(kk, :)), [ELECTRODE_HEIGHT, ELECTRODE_HEIGHT], 'LineWidth', 2, 'Color', linecolor);
                hold on
            end
        end
        title(int2str(f))
        hold off

        %keyboard
            subplot(1,2,2)
                imagesc(tmp3,[-1 1])

        %imagesc(tmp3,[-1 1])
        set(gca,'XTick',1:41);
         set(gca,'YTick',1:41);
        set(gca,'XTickLabel',test.usechans);
        set(gca,'YTickLabel',test.usechans);

        colorbar
        saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        input('next')
        hold off
    end
end
%%