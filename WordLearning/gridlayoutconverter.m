for j=3:7
    allgrids(j).G=zeros(16,16);
    for i=1:size(layout,1)
        try
            allgrids(j).G(i,layout{i,1})=layout{i,j}
        catch
             allgrids(j).G(i,layout{i,1}(1:7))=layout{i,j}
        end
    end
end
%%
for i=1:size(blockday,1)
    try
        cd(['E:\PreprocessedFiles\EC26\EC26_B' int2str(blockday{i,1})])
    catch
        continue
    end
        gridlayout=allgrids(blockday{i,2}+1).G
        save('gridlayout','gridlayout')

        load gridlayout
        gridlayout=gridlayout';

        eval(['D' int2str(i) '.Data.gridlayout.usechans=reshape(gridlayout,[1 256]);'])
    
end
%%

