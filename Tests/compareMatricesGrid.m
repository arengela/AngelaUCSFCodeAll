set(gca,'XGrid','on')
set(gca,'YGrid','on')
set(gca,'XTick',[1.5:18.5])
set(gca,'YTick',[1.5:18.5])
%set(gca,'XTickLabel',[1:16])

set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
for c=1:16
    for r=1:18
        text(c,r,num2str((r-1)*16+c))

    end
end

figure;plot(zAve11);

b20=zeros(18,16);
b20(find(zAve20>.4))=1;
figure
imagesc(reshape(b20,16,18)')
title('20')

b19=zeros(18,16);
b19(find(zAve19>.3))=1;
figure
imagesc(reshape(b19,16,18)')
title('19')


b11=zeros(18,16);
b11(find(zAve11>.3))=1;
figure
imagesc(reshape(b11,16,18)')
title('11')

b10=zeros(18,16);
b10(find(zAve10>.3))=1;
figure
imagesc(reshape(b10,16,18)')
title('10')



