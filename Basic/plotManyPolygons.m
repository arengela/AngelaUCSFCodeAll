function plotManyPolygons(centers,sides,color,alphas,sizeRatio,flag,ch)
if nargin<6
    flag=1;
end
if flag==1
    if size(centers,1)~=length(alphas)
        alphas=repmat(alphas,length(centers),1);
    end
    for i=1:size(centers,1)
        try
            plotPolygon(centers(i,:),sides,color(i,:),alphas(i),sizeRatio);    
        catch
            plotPolygon(centers(i,:),sides,color,alphas(i),sizeRatio);    
        end
       hold on
    end
else 
    
    
    
    
end

