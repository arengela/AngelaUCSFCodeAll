function organizeGUI_rat

w=600;
l=600;
m1=10;
c1=151;
figure('MenuBar','none','Name','OrganizeGUI','NumberTitle','off','Position',[100,100,w,l]);

uicontrol('Style','PushButton','String','TDT to HTK','Position',[m1,.25*l,c1,20],'CallBack',@convertButton);


%%
    function convertButton(varargin)
       blocks=uigetfile('MultiSelect','on');
       dest=uigetdir('/Computer','Pick a destination directory');

       
       for i=1:length(blocks)       
           %Convert Rat ecog functions
       end   
    end    
    
end