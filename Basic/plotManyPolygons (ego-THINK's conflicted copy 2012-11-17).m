function plotManyPolygons(centers,sides,color,alphas,sizeRatio)

if size(centers,1)~=length(alphas)
    alphas=repmat(alphas,length(centers),1);
end
for i=1:size(centers,1)
   plotPolygon(centers(i,:),sides,color,alphas(i),sizeRatio);    
   hold on
end