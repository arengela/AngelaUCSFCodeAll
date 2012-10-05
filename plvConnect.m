function plvConnect(C2,gridlayout,linecolor,strength)
connectStrength=zeros(1,size(C2,1));
%load('E:\General Patient Info\EC23\regdata.mat')
cM= jet
ELECTRODE_HEIGHT=2;
bounds=[.2 -.3]
boundcolors={'g' 'r','b'}
m=nanmax(nanmax(strength));
colors=jet;
l=length(colors);
for kk = 1:size(C2,1)
    if isequal(size(gridlayout),[16 16])
        [r1,c1]=find(gridlayout==C2(kk,1));
        [r2,c2]=find(gridlayout==C2(kk,2));
    else
        tmp=gridlayout(:,C2(kk,1));
        c1=tmp(1);r1=tmp(2);
        tmp=gridlayout(:,C2(kk,2));
        c2=tmp(1);r2=tmp(2);
    end
    d=pdist([c1 r1;c2 r2],'euclidean');
    
    if nargin>3
       linecolor=colors(round((strength(C2(kk,1),C2(kk,2))/m)*l),:);
    end
    
    if nargin<3
        if d>10
            linecolor='y';
        elseif d>2
            linecolor=rgb('orange');
        else
            linecolor='r';
        end
    end
        
    
    plot3([c1 c2],[r1 r2], [ELECTRODE_HEIGHT, ELECTRODE_HEIGHT], 'LineWidth', 2, 'Color', linecolor);
        hold on
% 
%     plot(c1, r1,'.r')  
%     plot(c2 ,r2,'.r')   

end

