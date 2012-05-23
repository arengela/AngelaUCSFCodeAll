i=1;
b=1;
movie=zeros(16,16,600);
while i<257
    movie(b,:,:)=handles.zScore{1}(i:(i+15),:);
    i=i+16;
    b=b+1;
end

for t=1:600
    k = waitforbuttonpress 
    imagesc(movie(:,:,t))
    t
    title(sprintf('%d',t))
end