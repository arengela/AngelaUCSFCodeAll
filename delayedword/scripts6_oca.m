 
f=14
%test.loadBaselineFolder([baseline{n} '/HilbReal_4to200_40band']);

test.segmentedDataEvents40band(seg(1:5),{[2500 2500],[2500 2500],[2500 2500],[2500 2500],[2500 2500]},'keep',[],'aa',f)
%%
test.ecogBaseline.mean=ecogBaseline.mean(:,:,f);
test.ecogBaseline.std=ecogBaseline.std(:,:,f);
%%
test.BaselineChoice='ave';
%test.calcZscore
test.plotData('stacked')
%%
e=3      
X=mean(test.segmentedEcog(e).zscore_separate,4);
[COEFF,SCORE,latent] = princomp(X(:,1:end)');
%%
%figure

for i=1:4
        subplot(1,3,1)

    %subplot(4,3,(i-1)*3+1)
    plot(SCORE(:,i),'k')
    hl=line([1000 1000],[-4 4])
        title(['PC' int2str(i)])
        
    subplot(1,3,2)

    %subplot(4,3,(i-1)*3+2)
    visualizeGrid(1,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',1:256,COEFF(:,i))
    
    subplot(1,3,3)
    %subplot(4,3,(i-1)*3+3)
    visualizeGrid(2,'E:\General Patient Info\EC22\brain+grid_3Drecon_cropped.jpg',find(COEFF(:,i)>.1))
    print -dmeta
    r=input('next')
    if strcmp(r,'k')
        keyboard
    end

    
end
%%

