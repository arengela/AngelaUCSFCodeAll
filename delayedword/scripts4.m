function plvscripts()
allfiles=    {
    'E:\DelayWord\EC16\EC16_B1';
    'E:\DelayWord\EC18\EC18_B1';    
    'E:\DelayWord\EC20\EC20_B18';
    'E:\DelayWord\EC20\EC20_B23';
    'E:\DelayWord\EC20\EC20_B54';
    'E:\DelayWord\EC20\EC20_B64';
    'E:\DelayWord\EC20\EC20_B67';
    'E:\DelayWord\EC21\EC21_B1';
    'E:\DelayWord\EC22\EC22_B1'
    }
n=9;
test=SegmentedData([allfiles{n} '/HilbReal_4to200_40band'],[],0); 

test.usechans=activech{e}
test.channelsTot=length(test.usechans);


%test.segmentedDataEvents40band({[repmat([42;43],[1,40]);1:40]},{[3000 3000]},'keep',10)
test.segmentedDataEvents40band({[1:40;repmat(42,[1,40])]},{[2000 2000]},'keep',[],'phase')

test.Params.sorttrials=0;
%test.segmentedDataEvents40band({[1:40;repmat(42,[1,40])]},{[1000 1000]},'keep',20,'complex')
% 
% for low=2:30
%     for t=1:20
%         [pac(t).pac,pac(t).ave_amp_phase]=PAC_preprocesseddata(test.segmentedEcog(1).complex(:,:,:,t),low,32);
%     end
% end


%% Calc PLV
function calcPLV(f)
    dataplv=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(:,:,f,:)),400,[],[]);
end
%% Look at PLV of 1 chan compared to all other chan for entire timeseries

figure
data=zeros(1,256);
timeInt=1:1600;
for f=2:40
    dataplv=pn_eegPLV_modified(squeeze(test.segmentedEcog(1).phase(:,:,f,:)),400,[],[]);

    for ch=1:test.channelsTot
        subplot(2,1,1)
        tmp=squeeze((squeeze(dataplv(:,ch,:))+dataplv(:,:,ch)))';
        btmp=bPLV(f).mean(:,test.usechans,test.usechans);
        btmp=squeeze(btmp(1,ch,:))+btmp(1,:,ch)';
        imagesc(tmp./repmat(btmp,[1 size(dataplv,1)]))
        title(['ch ' int2str(test.usechans(ch)) 'f ' int2str(f)])
        line([800 800],[0 test.channelsTot])
        %colorbar

        subplot(2,1,2)
        mtmp=mean(tmp(:,800:1600),2);
        %imagesc(reshape(mtmp,[16,16])')
        %plot(mtmp)

        ch_hold=find(mtmp>.3);
        data(test.usechans)=mtmp;
    %     hold on
    %     plot(ch_hold,mtmp(ch_hold),'ro')
        visualizeGrid(1,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',1:256,data)

        title(int2str(ch_hold'))
        %saveppt2('ppt',powerpoint_object,'driver','bitmap','stretch','off');
        input('n')
    end
end

%% visualize connections on brain pic

%figure
visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped2.jpg',test.usechans)
C2 = nchoosek(1:test.channelsTot,2)
connectStrength=zeros(1,size(C2,1));
load('E:\General Patient Info\EC22\regdata.mat')
timeInt=400:1200%800%800:1200%1200:1600;
cM= jet
ELECTRODE_HEIGHT=2;
bounds=[.2 -.3]
boundcolors={'g' 'r','b'}
for f=1:40
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

