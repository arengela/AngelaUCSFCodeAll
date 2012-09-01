function data=blowUpImage(hf,plotLoc,newhf,chanNum)
    hplots=get(hf,'Children');
    if nargin<4
        plotLoc=chanNum;
    end
    c2=get(hplots(plotLoc),'Children');
    
    %t=get(c2(9),'String')
    try
        data=get(c2(10),'CData'); 
    catch
        data=get(c2(9),'CData'); 
    end
    if nargin<3
        newhf=figure;
    end
    imagesc(data)
    hold on
    for i=1:8
        try
           tmpx=get(c2(i),'XData'); 
           tmpy=get(c2(i),'YData'); 

           hl=line(tmpx,tmpy);
           set(hl,'Color','k');
        end
    end
    title(int2str(chanNum))
    hold off
end
       
 
    
    