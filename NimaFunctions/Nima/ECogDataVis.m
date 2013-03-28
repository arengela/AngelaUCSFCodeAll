function ECogDataVis (dpath, subject, elects, data, flag, imname,maxsc,data2,impch,colormat,showImFlag,alphaData)
%
%
%{
tmp = strfind(dpath,'eCogProjects');
if ~iscell(subject),
    tmp2{1} = subject;
    tmp2{2} = 1;
    subject = tmp2;
end
imname = [dpath(1:tmp-1) 'eCogProjects' filesep 'Subjects' filesep subject{1} filesep 'brain' num2str(subject{2}) '.jpg'];
if ~exist('maxsc','var')
    maxsc = [];
end
%}
cd(dpath);
if isempty(imname)
    imname=[dpath filesep 'brain.jpg'];
end
[xy,img] = eCogImageRegister(imname,0);
allxy=xy;
try
    xy = xy(:,elects);
end
G=real2rgb(img,'gray');
if nargin<10
    showImFlag=1;
end
if showImFlag==1
    cla
end
switch flag
    case 0
        %figure;
        %colormap(gray);
        if showImFlag
            hi=imagesc(G);
        end
        hold on;
         s=scatter(xy(1,:),xy(2,:),30,'filled','r');

        if ~isempty(colormat)
             set(s,'MarkerFaceColor',colormat)
        end
    case 2
        %figure;
        if showImFlag
            imshow(img);
        end

        %set(hi,'AlphaData',.7)
        axis tight
        hold on;
        %plot(xy(1,:),xy(2,:),'r.','LineWidth',100);
        s=scatter(xy(1,:),xy(2,:),30,'filled','r');

        if ~isempty(colormat)
             set(s,'MarkerFaceColor',colormat)
        end
        for cnt1 = 1:size(xy,2)
            text(xy(1,cnt1)+3,xy(2,cnt1),num2str(elects(cnt1)),'color','b','FontSize',6);
        end
        %axis([200 1400 150 900])
    case 1
        xy = ceil(xy);
        % this line has to be optimized:
        tmp1 = zeros(size(img));
        for cnt1 = 1:size(xy,2)
            tmp1(xy(2,cnt1),xy(1,cnt1)) = data(cnt1);
        end
        %         tmp1 = conv2(tmp1,fspecial('disk',16),'same');
        if nargin<8 | isempty(colormat)
            r = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        else
            r = cat(3,ones(size(img))*colormat(1),ones(size(img))*colormat(2),ones(size(img))*colormat(3));
        end
        
        if showImFlag
            imshow(img);
            hold on
        end
        
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        %         figure;
        hr = imshow(r);
        hb = imshow(b);
        %
        d = fspecial('disk',9);
        tmpp = max(tmp1,0);
        tmpp = conv2(tmpp,d,'same').^1.33;
        % tmpp = conv2(tmpp,d,'same');

        tmpn = -min(tmp1,0);
        tmpn = conv2(tmpn,d,'same').^1.33;
        %tmpn = conv2(tmpn,d,'same');

        if isempty(maxsc)
            mm = max(max(tmpp(:)),max(tmpn(:)));
            %mm=max(tmpp(:));
        else
            mm = maxsc;
        end
        tmpp = tmpp/mm;
        tmpn = tmpn/mm;
        
        if ~isempty(alphaData)
            tmpp(find(tmpp>0))=alphaData;
        end
        set(hr,'AlphaData',tmpp);
        set(hb,'AlphaData',tmpn);
        for cnt1 = 1:size(xy,2)
            text(xy(1,cnt1)+3,xy(2,cnt1),num2str(elects(cnt1)),'color','y','FontSize',10);
        end
        
      case 5
          try
                corners = round(allxy(:,[1 16 241 256]));
          catch
                corners = round(allxy(:,[57  128 1 72 ]));
          end
        tmp = zeros(16);
        tmp(elects) = data;
        t = maketform('affine',[16 16 1;16 1 16]',corners(:,1:3)');
        R = makeresampler('cubic','fill');
        tmp2 = imtransform(tmp,t,R,'XYScale',1);
        tmp2 = rot90(tmp2,2);
        tmp2 = tmp2*0.999/max(max(abs(tmp2)));
        tmp3 = zeros(size(img));
        tmp3(min(corners(2,:)):min(corners(2,:))+size(tmp2,1)-1,min(corners(1,:)):min(corners(1,:))+size(tmp2,2)-1) = tmp2;
        if showImFlag
            imshow(img);
        end
        hold on
        if nargin<8 | isempty(colormat)
            r = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        else
            r = cat(3,ones(size(img))*colormat(1),ones(size(img))*colormat(2),ones(size(img))*colormat(3));
        end
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        %hb = imshow(b);
        hr = imshow(r);
        %tmp3=tmp3.^2;
        tmp3=tmp3./2;
        %set(hb,'AlphaData',max(-tmp3,0));
        tmp3=tmp3;
        set(hr,'AlphaData',max(tmp3,0));       
        
     case 51
         try
             corners = round(allxy(:,[1 16 241 256]));
             
         catch
             corners = round(allxy(:,[57  128 1 72 ]));
         end
         tmp = zeros(16);
            tmp(elects) = data;
            t = maketform('affine',[16 16 1;16 1 16]',corners(:,1:3)');
            R = makeresampler('cubic','fill');
            tmp2 = imtransform(tmp,t,R,'XYScale',1);
            tmp2 = rot90(tmp2,2);
            if ~isempty(maxsc)
               tmp2 = tmp2/maxsc;                
            else
                tmp2 = tmp2/max(max(abs(tmp2)));
            end
            tmp3 = zeros(size(img));
            tmp3(min(corners(2,:)):min(corners(2,:))+size(tmp2,1)-1,min(corners(1,:)):min(corners(1,:))+size(tmp2,2)-1) = tmp2;
            hold off;         

            %axes('visible','off'); 
             ha = axes('units','normalized', ...
     'position',[0 0 1 1]);
            
            if showImFlag
                imshow(real2rgb(img,'gray'));   
            end
            %freezeColors
             set(ha,'handlevisibility','off', ...
    'visible','off')
            zeroMat=zeros(size(img));
            hold on
            %imshow(zeroMat);
            %a=axis;
            hold on
            %colormap(gray)
            %freezeColors

             axes('position',[0 0 1 1])
            imshow(tmp3,[min(data)./max(data) 1])
            %imshow(tmp5)
            %imagesc(tmp3)
            tmp3(find(tmp3<0))=0;
            %imagesc(tmp3,[min(data)./max(data) 1])
            %tmp4=tmp3.^3;
            tmp4=double(tmp3>max(max(tmp3))*.7);
            
            %tmp4(find(tmp3>prctile(reshape(tmp3,1,[]),99.9)))=.7;
            alpha(tmp4*alphaData)
            %alpha(tmp3);
            %axis(a)
            %colormap(jet)
            if ~isempty(colormat)
                colormap(repmat(colormat,256,1));
            else
                %load('C:\\Users\Angela_2\Dropbox\AngelaUCSFFiles\AngelaSVN\basic\redblueblack_diverge.mat')
                colormap(redblue)
            end
        case 8 
        xy = ceil(xy);
        % this line has to be optimized:
        tmp1 = zeros(size(img));
        for cnt1 = 1:length(xy)
            tmp1(xy(2,cnt1),xy(1,cnt1)) = data(cnt1);
        end
        %         tmp1 = conv2(tmp1,fspecial('disk',16),'same');
        %r = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        color=rgb('red');
        r = cat(3,ones(size(img))*(color(1)),ones(size(img))*(color(2)),ones(size(img))*(color(3)));
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        %         figure;
        hold off;
        imshow(img);
        hold on
        hr = imshow(r);
        %hb = imshow(b);
        %
        d = fspecial('disk',9);
        tmpp = max(tmp1,0);
        %tmpp = conv2(tmpp,d,'same').^1.33;
         tmpp = conv2(tmpp,d,'same');

        tmpn = -min(tmp1,0);
        %tmpn = conv2(tmpn,d,'same').^1.33;
        %tmpn = conv2(tmpn,d,'same');

        if isempty(maxsc)
            mm = max(max(tmpp(:)),max(tmpn(:)));
            %mm=max(tmpp(:));
        else
            mm = maxsc;
        end
        tmpp = tmpp/mm;
        tmpn = tmpn/mm;
        set(hr,'AlphaData',tmpp);
        %set(hb,'AlphaData',tmpn);
        
        %p=prctile(mean(data,2),90);
        %elects=find(mean(data,2)>p);
        hold on;
        %xy = xy(:,elects);

%         plot(xy(1,:),xy(2,:),'r.');
%         for cnt1 = 1:size(xy,2)
%             text(xy(1,cnt1)+3,xy(2,cnt1),num2str(elects(cnt1)),'color','y','FontSize',8);
%             %text(xy(1,cnt1)+3,xy(2,cnt1),num2str(cnt1),'color','y','FontSize',8);
% 
%         end
        hold off

     case 11 
        xyHold=xy;
        imshow(img);
        freezeColors;
        hold on
        zeroMat=ones(size(img))*-500;
        %imagesc(zeroMat);
        a=axis;
        colors={'w','r','g','y','c','k','m','b'};
        %load('E:\DelayWord\modhot.mat')
        load('E:\DelayWord\modcopper.mat')
        colors=colormap(autumn).*gray;
        groups=find(~cellfun(@isempty,elects));
        for i=1:length(groups)
            groups1{i}=num2str(groups(i))
        end
        for i=1:length(elects)
            xy = xyHold(:,elects{i});
            xy = ceil(xy);
            % this line has to be optimized:
            tmp1 = zeros(size(img));
            if isempty(colormat)
                 colormat=colors(round(256/length(elects)*i),:);
                 colormat([3])=.5;
            end
            scatter(xy(1,:),xy(2,:),20,colormat,'filled')
%             for cnt1 = 1:size(xy,2)
%                 text(xy(1,cnt1)-6,xy(2,cnt1),num2str(elects{i}(cnt1)),'color','k','FontSize',7);
%                 %text(xy(1,cnt1)+5,xy(2,cnt1),num2str(cnt1),'color','w','FontSize',7);
%             end
        end
        %legend(groups1)
        set(gca,'FontSize',15)       
        axis off       
        axis(a)        
    case 9 
        xy = ceil(xy);
        % this line has to be optimized:
        tmp1 = zeros(size(img));
        for cnt1 = 1:length(xy)
            tmp1(xy(2,cnt1),xy(1,cnt1)) = data(cnt1);
        end
        %         tmp1 = conv2(tmp1,fspecial('disk',16),'same');
        r = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        %         figure;
        imshow(img);
        freezeColors;
        hold on
        zeroMat=ones(size(img))*-500;
        %imagesc(zeroMat);
        a=axis;        
        negex=max(abs(data(data<0)));
        posex=max(data(data>0));
        if negex>posex 
            maxex=negex;
        elseif isempty(posex)
            maxex=negex;
        elseif posex>negex 
            maxex=negex;            
        elseif isempty(negex)8
            maxex=posex;
        else
            return
        end
        mindata=min(data);
        mindata2=min(data2);
        plotdata=((data+1-mindata))/(maxex-mindata);
        plotdata2=((data2+1-mindata2))/(maxex-mindata2);  
        
        if isempty(impch)            
            scatter(xy(1,:),xy(2,:),100*plotdata2+150,plotdata*256+1,'filled')  
            colormap(pink)
            colorbar
        else
            scatter(xy(1,:),xy(2,:),10,repmat(50,[1 length(data2)]),'filled')
            idx=find(elects==impch)
            scatter(xy(1,idx),xy(2,idx),50,'filled','r')
            text(xy(1,idx)+6,xy(2,idx),num2str(impch),'color','w','FontSize',8);
        end
        axis([200 1400 150 900])        
        set(colorbar,'YTick',linspace(1,256,6))
        set(colorbar,'YTickLabel',linspace(mindata,maxex,6))
        set(gca,'FontSize',15)       
        axis off       
        axis(a)
        
    case 10
        xyHold=xy;        
        xy = xyHold(:,elects);        
        xy = ceil(xy);
        % this line has to be optimized:
        tmp1 = zeros(size(img));
        for cnt1 = 1:length(xy)
            tmp1(xy(2,cnt1),xy(1,cnt1)) = data(cnt1);
        end
        imshow(img);
        hold on               
        if isempty(impch)
            xy = xyxyHold(:,elects);

            xy = ceil(xy);
            % this line has to be optimized:
            tmp1 = zeros(size(img));
            for cnt1 = 1:length(xy)
                tmp1(xy(2,cnt1),xy(1,cnt1)) = data(cnt1);
            end
            for i=1:size(xy,2)
                hc=filledCircle(xy(:,i),10,100,'c')
                set(hc,'FaceAlpha',.3)
                set(hc,'EdgeAlpha',.3)
                set(hc,'FaceVertexAlphaData',.3)

            end
            colormap(jet)
            colorbar
            for cnt1 = 1:size(xy,2)
                text(xy(1,cnt1)+6,xy(2,cnt1),num2str(elects(cnt1)),'color','w','FontSize',7);
                %text(xy(1,cnt1)+5,xy(2,cnt1),num2str(cnt1),'color','w','FontSize',7);

            end
        else
            scatter(xy(1,:),xy(2,:),10,repmat(50,[1 length(data2)]),'filled')

            idx=find(elects==impch)
            scatter(xy(1,idx),xy(2,idx),50,'filled','r')
            text(xy(1,idx)+6,xy(2,idx),num2str(impch),'color','w','FontSize',8);
        end
        set(colorbar,'YTick',linspace(1,256,6))
        set(colorbar,'YTickLabel',linspace(mindata,maxex,6))
        set(gca,'FontSize',15)        
        hold off
    case 7
        xy = ceil(xy);
        % this line has to be optimized:
        tmp1 = zeros(size(img));
        for cnt1 = 1:length(xy)
            tmp1(xy(2,cnt1),xy(1,cnt1)) = data(cnt1);
        end
        %         tmp1 = conv2(tmp1,fspecial('disk',16),'same');
        r = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        %         figure;
        imshow(img);
        hold on
        hr = imshow(r);
        hb = imshow(b);
        %
        d = fspecial('disk',9);
        tmpp = max(tmp1,0);
        %tmpp = conv2(tmpp,d,'same').^1.33;
         tmpp = conv2(tmpp,d,'same');

        tmpn = -min(tmp1,0);
        %tmpn = conv2(tmpn,d,'same').^1.33;
        tmpn = conv2(tmpn,d,'same');

        if isempty(maxsc)
            mm = max(max(tmpp(:)),max(tmpn(:)));
            %mm=max(tmpp(:));
        else
            mm = maxsc;
        end
        tmpp = tmpp/mm;
        tmpn = tmpn/mm;
        set(hr,'AlphaData',tmpp);
        set(hb,'AlphaData',tmpn);
        
         for cnt1 = 1:size(xy,2)
                text(xy(1,cnt1)+6,xy(2,cnt1),num2str(elects(cnt1)),'color','w','FontSize',7);
                %text(xy(1,cnt1)+5,xy(2,cnt1),num2str(cnt1),'color','w','FontSize',7);

            end
    case 3 % include the time, color codes time,
        
        xy = ceil(xy);
        % this line has to be optimized:
        tmp = zeros([size(img) 3]);
        data = max(0,data);
        seg=6;
        N = floor(size(data,2)/seg);
        for cnt2 = 1:seg
            for cnt1 = 1:length(xy)
                tmp(xy(2,cnt1),xy(1,cnt1),cnt2) = mean(data(cnt1,(cnt2-1)*N+1:cnt2*N),2);
            end
        end
        % set only one to non-zero:
        for cnt1 = 1:length(xy)
            tmp2 = squeeze(tmp(xy(2,cnt1),xy(1,cnt1),:));
            [m,i] = max(tmp2);
            if m>0
                tmp(xy(2,cnt1),xy(1,cnt1),:)=0;
                tmp(xy(2,cnt1),xy(1,cnt1),i)=m;
            end
        end
        
          %       tmp1 = conv2(tmp1,fspecial('disk',16),'same');
        
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        g = cat(3,zeros(size(img)),ones(size(img)),zeros(size(img)));
        c = cat(3,zeros(size(img)),ones(size(img)),zeros(size(img)));

        y = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        m = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        r = cat(3,zeros(size(img)),ones(size(img)),zeros(size(img)));
        %         figure;
        imshow(img);
        hold on
        
        hb = imshow(b);
        hg = imshow(g);
        hc = imshow(c);
        hy = imshow(y);
        hm = imshow(m);
        hr = imshow(r);
        
        %
        d = fspecial('disk',12);
        for cnt1 = 1:seg
            tmp(:,:,cnt1) = conv2(tmp(:,:,cnt1),d,'same').^1.33;
         tmp(:,:,cnt1) = tmp(:,:,cnt1)/max(max(tmp(:,:,cnt1)));
        end
        if isempty(maxsc)
            mm = max(tmp(:));
        else
            mm = maxsc;
        end
        tmp = tmp/mm;
        set(hb,'AlphaData',tmp(:,:,1));
        set(hg,'AlphaData',tmp(:,:,2));
        set(hc,'AlphaData',tmp(:,:,3));
        set(hy,'AlphaData',tmp(:,:,4));
        set(hm,'AlphaData',tmp(:,:,5));
        set(hr,'AlphaData',tmp(:,:,6));
        
      case 5
        xy = ceil(xy);
        % this line has to be optimized:
        tmp1 = zeros(size(img));
        for cnt1 = 1:1%length(xy)
            tmp1(xy(2,cnt1),xy(1,cnt1)) = data(1,cnt1);
        end
        %         tmp1 = conv2(tmp1,fspecial('disk',16),'same');
        r = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        %         figure;
        imshow(img);
        hold on
        hr = imshow(r);
        hb = imshow(b);
        %
        d = fspecial('disk',12);
        tmpp = max(tmp1,0);
        tmpp = conv2(tmpp,d,'same').^1.33;
        tmpn = -min(tmp1,0);
        tmpn = conv2(tmpn,d,'same').^1.33;
    
        mm = max(max(tmpp(:)))

        tmpp = tmpp/mm;
        set(hr,'AlphaData',tmpp);
        
        
         for cnt1 = 1:length(xy)
            tmp1(xy(2,cnt1),xy(1,cnt1)) = -data(2,cnt1);
         end
         tmpn = -min(tmp1,0);
         tmpn = conv2(tmpn,d,'same').^1.33;
         mm = max(max(tmpp(:)),max(tmpn(:)))
         mm = max(max(tmpn(:)))

        tmpn = tmpn/mm;
        set(hb,'AlphaData',tmpn);
        
        
        case 6
        xy = ceil(xy);
        % this line has to be optimized:
        tmp1 = zeros(size(img));
        for cnt1 = 1:length(xy)
            tmp1(xy(2,cnt1),xy(1,cnt1)) = data(cnt1);
        end
        %         tmp1 = conv2(tmp1,fspecial('disk',16),'same');

        g = cat(3,zeros(size(img)),ones(size(img)),zeros(size(img)));
             %b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        %         figure;
        imshow(img);
        hold on
        hg= imshow(g);
        hb = imshow(b);
        %
        d = fspecial('disk',9);
        tmpp = max(tmp1,0);
        tmpp = conv2(tmpp,d,'same').^1.33;
        tmpn = -min(tmp1,0);
        tmpn = conv2(tmpn,d,'same').^1.33;
        if isempty(maxsc)
            mm = max(max(tmpp(:)),max(tmpn(:)));
        else
            mm = maxsc;
        end
        tmpp = tmpp/mm;
        tmpn = tmpn/mm;
        set(hg,'AlphaData',tmpp);
        set(hb,'AlphaData',tmpn);
end