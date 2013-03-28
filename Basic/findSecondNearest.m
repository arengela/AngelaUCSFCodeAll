function idx2=findSecondNearest(x,xarray)

idx=findNearest(x,xarray);
idxLeft=setdiff(1:length(xarray),idx);
idx2=idxLeft(findNearest(x,xarray(idxLeft)));