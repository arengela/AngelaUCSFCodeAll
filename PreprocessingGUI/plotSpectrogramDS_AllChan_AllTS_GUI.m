function plotSpectrogramDS_AllChan_AllTS_GUI(ecog, blockName,badch)

figure
set(gcf,'Color','w')
set(gcf,'Name','Spectrogram')
for i=1:size(ecog.data,1)
    fprintf('%i ',i)
    m=floor(i/16);
    n=rem(i,16);
    
    if n==0
        n=16;
        m=m-1;
    end
    
    p(1)=6*(n-1)/100+.03;
    p(2)=6.05*(15-m)/100;
    
    p(3)=.055;
    p(4)=.055; 
    h=subplot('Position',p);
    specgram(ecog.data(i,:),[],ecog.sampFreq)
   
    if i~=1
        set(gca,'visible','off')
    else
        set(gca,'XAxisLocation','top')
    end
    
    if ismember(i,badch)
        text(1,190,num2str(i),'Background','y')
    end

        
        text(1,190,num2str(i))
    %p=get(h,'pos');
    
  
    
end

set(gcf,'Name',blockName)