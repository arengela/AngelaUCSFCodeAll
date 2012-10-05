%plot % stim causing any sort of error
load('E:\DelayWord\errorsites')
errorstat=errorsites(:,1,:)./errorsites(:,2,:)
figure
setTitle={'word','delay','repetition'}
for s=1:3
    subplot(3,1,s)
    bar(errorstat(:,:,s))
    for t=1:5
        text(t,errorstat(t,:,s),[num2str(errorsites(t,1,s)) '/' num2str(errorsites(t,2,s))],...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')
    end
    title(setTitle{s})
    ylabel('% elliciting errors')
    xlabel('site')
end
%% plot error rates by type
load('E:\DelayWord\errorsites')
figure
order=[1 3 4 2 5]
for s=1:3
    subplot(3,1,s)
    bar(errorrates(order,1:3,s),'stacked');
    xlabel('site')
    ylabel('stimulation')
    title(setTitle{s})
end
subplot(3,1,1)
 legend('perceptual','phonological','none')

 subplot(3,1,3)
 set(gca,'XTickLabel',{'EC22 D','EC23 C','EC24 E','EC23 D','EC24 D'})


