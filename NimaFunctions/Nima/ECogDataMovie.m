function mv = ECogDataMovie (dpath,subject, elects, data, labs, maxsc)
% in this case, data is #elects * Frame
if ~exist('maxsc','var')
    maxsc = [];
end
if ~exist('labs','var') 
    labs = [];
end
for cnt1 = 1:size(data,2)
    %ECogDataVis(dpath,subject,elects,data(:,cnt1),1,maxsc);
    ECogDataVis(dpath,subject,elects,data(:,cnt1),1,[],maxsc);
    if ~isempty(labs)
        text(100,100,num2str(labs{cnt1}),'fontsize',24,'color','w');
    end
    %drawnow;
    mv(cnt1) = getframe;
end
