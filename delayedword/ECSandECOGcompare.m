for i=1:2
    subplot(2,1,i)
    imagesc(flipud(squeeze(mean(D(ch(i),:,:),1))'))
    title(int2str(ch(i)))
    hl=line([800 800],[0 40])
    set(hl,'Color','k')
end
