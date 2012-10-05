function visualizePLVconnections(dataplv,ch,C2)
connectStrength=zeros(1,size(C2,1));
%load('E:\General Patient Info\EC23\regdata.mat')
cM= jet
ELECTRODE_HEIGHT=2;
bounds=[.2 -.3]
boundcolors={'g' 'r','b'}
% subplot(1,2,1)
% %visualizeGrid(2,'E:\General Patient Info\EC23\brain.jpg',ch)
% tmp3=squeeze(mean(dataplv(1:400,:,:),1))-squeeze(mean(dataplv(401:800,:,:),1));
for i=1:size(C2,1)
    connectStrength(1,i)=dataplv(C2(i,1),C2(i,2));
end
for idx=1
    Y=bounds(idx);
    linecolor=boundcolors{idx};    
    if idx==1
        keep=find(connectStrength>Y)
    else
        keep=find(connectStrength<Y)
    end
    displayStruct.chanPairs=ch(C2(keep,:))
    displayStruct.connectionStrength=connectStrength(keep)';   
    y=xy(1,:)
    x=xy(2,:)    
    cmapPos = ceil(size(cM, 1)/2)*ones(size(keep, 2), 1);    
    for kk = 1:length(keep)
        plot3(y(displayStruct.chanPairs(kk, :)), x(displayStruct.chanPairs(kk, :)), [ELECTRODE_HEIGHT, ELECTRODE_HEIGHT], 'LineWidth', 2, 'Color', linecolor);
        hold on
    end
end
hold off
subplot(1,2,2)
imagesc(tmp3,[-1 1])
set(gca,'XTick',1:41);
set(gca,'YTick',1:41);
set(gca,'XTickLabel',ch);
set(gca,'YTickLabel',ch);
colorbar
input('next')
hold off
