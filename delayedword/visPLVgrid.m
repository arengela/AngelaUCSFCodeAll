function visPLVgrid
visualizeGrid(2,'E:\General Patient Info\EC23\brain.jpg',test.usechans)
C2 = nchoosek(1:test.channelsTot,2)
connectStrength=zeros(1,size(C2,1));
load('E:\General Patient Info\EC23\regdata.mat')
timeInt=400:1200%800%800:1200%1200:1600;
cM= jet
ELECTRODE_HEIGHT=2;
bounds=[.2 -.3]
boundcolors={'g' 'r','b'}
timeInt=400:1200;
for f=1:40
    visualizePLVconnections
    input('next')
end

    function visualizePLVconnections
        subplot(1,2,1)
        visualizeGrid(2,'E:\General Patient Info\EC23\brain.jpg',test.usechans)
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