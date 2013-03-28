function getGridCoord(e,gridlayout)

for i=1:length(e)
    [a,b]=find(gridlayout==e(i));
end