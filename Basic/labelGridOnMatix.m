set(gca,'XGrid','on')
set(gca,'YGrid','on')
set(gca,'XTick',[1.5:16.5])
set(gca,'YTick',[1.5:(16+.5)])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
for c=1:16
    for r=1:16
        text(c,r,num2str((r-1)*16+c))
    end
end