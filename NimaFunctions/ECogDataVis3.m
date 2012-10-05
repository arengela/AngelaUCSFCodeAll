function [xy,img] = ECogDataVis (dpath, subject, elects, data, flag, maxsc)
%
% flag: -2: figure itself
%       -1: register the image
%       0: dots
%       1: DATA
%       2: ELECTRODE NUMBER
%       3: time as color
%       4: images (strfs)
%       5: show the data on the brain, similar to 1 but interporalted.
% maxsc: if -1, then change the background to white

tmp = strfind(dpath,'eCogProjects');
if ~iscell(subject),
    tmp2{1} = subject;
    tmp2{2} = 2;
    subject = tmp2;
end
imname = [dpath(1:tmp-1) 'eCogProjects/Subjects/' subject{1} '/brain' num2str(subject{2}) '.jpg'];
if ~exist('maxsc','var')
    maxsc = [];
end
if flag == -1
    [xy,img] = ECogImageRegister(dpath,subject{1},1);
    return;
end
[allxy,img] = ECogImageRegister(dpath,subject{1});
if maxsc==-1
    ind = find(img<10);
    img(ind)=255;
    maxsc = [];
end
xy = allxy(:,elects);
switch flag
    case -2
        %         figure;
        hold off;
        imagesc(img);colormap(gray);
        axis off;
        hold on;
        %         plot(xy(1,:),xy(2,:),'k.','markersize',4);
    case 0
        figure;
        imagesc(img);colormap(gray);
        hold on;
        plot(xy(1,:),xy(2,:),'r.','markersize',10);
    case 2
        figure;
        imagesc(img);colormap(gray);
        hold on;
        plot(xy(1,:),xy(2,:),'r.');
        for cnt1 = 1:size(xy,2)
            text(xy(1,cnt1)+3,xy(2,cnt1),num2str(elects(cnt1)),'color','y','FontSize',8);
        end
    case 1
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
        hold off;
        imshow(img);
        hold on
        hr = imshow(r);
        hb = imshow(b);
        %
        switch subject{1}
            case 'EC2'
                ds = 12;
            case 'GP31'
                ds = 9.1;
            otherwise
                ds = 6;
        end
        d = fspecial('disk',ds);
        tmpp = max(tmp1,0);
        tmpp = conv2(tmpp,d,'same').^1.33;
        tmpn = -min(tmp1,0);
        tmpn = conv2(tmpn,d,'same').^1.33;
        if isempty(maxsc)
            mm = max(max2(tmpp),max2(tmpn))
        else
            mm = maxsc;
        end
        tmpp = tmpp/mm;
        tmpn = tmpn/mm;
        set(hr,'AlphaData',tmpp);
        set(hb,'AlphaData',tmpn);
    case 3 % include the time, color codes time,
        
        xy = ceil(xy);
        % this line has to be optimized:
        tmp = zeros([size(img) 3]);
        data = max(0,data);
        N = floor(size(data,2)/3);
        for cnt2 = 1:3
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
        
        %         tmp1 = conv2(tmp1,fspecial('disk',16),'same');
        r = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        g = cat(3,zeros(size(img)),ones(size(img)),zeros(size(img)));
        %         figure;
        hold off;
        imshow(img);
        hold on
        hb = imshow(b);
        hg = imshow(g);
        hr = imshow(r);
        %
        switch subject{1}
            case 'EC2'
                ds = 12;
            case 'GP31'
                ds = 9;
            otherwise
                ds = 9;
        end
        d = fspecial('disk',ds);
        for cnt1 = 1:3
            tmp(:,:,cnt1) = conv2(tmp(:,:,cnt1),d,'same').^1.33;
            %             tmp(:,:,cnt1) = tmp(:,:,cnt1)/max2(tmp(:,:,cnt1));
        end
        if isempty(maxsc)
            mm = max2(tmp);
        else
            mm = maxsc;
        end
        tmp = tmp/mm;
        set(hb,'AlphaData',tmp(:,:,1));
        set(hg,'AlphaData',tmp(:,:,2));
        set(hr,'AlphaData',tmp(:,:,3));
    case 4
        if iscell(data),
            infval = data{2};
            data = data{1};
        else
            %             data = data{1};
            infval = ones(1,size(data,3));
        end
        sc = 2.7;
        xlen = ceil(size(data,2)/2);
        ylen = ceil(size(data,1)/2);
        xy = ceil(xy);
        tmp = diff(xy');
        tmp = max(abs(tmp(1,:)));
        for cnt1 = 1:length(xy)
            tmp2 = data(:,:,cnt1);
            tmp2 = tmp2/max2(abs(tmp2));
            tmp2 = tmp2/2 + .5;
            tmp2 = flipud(tmp2);
            tmp4 = grs2rgb(tmp2,jet);
            im = imagesc(tmp4,'XData',[xy(1,cnt1)-tmp/sc xy(1,cnt1)+tmp/sc], ...
                'YData',[xy(2,cnt1)-tmp/sc xy(2,cnt1)+tmp/sc]);
            text(xy(1,cnt1)-tmp/sc/2,xy(2,cnt1)-1.3*tmp/sc,num2str(infval(cnt1),'%2.2f'),...
                'fontsize',16,'fontweight','normal','fontname','Arial');
            tmp5 = infval(cnt1)-min2(infval);
            set(im,'alphaData',tanh(tmp5*10));
            %             cax = ancestor(im,'axes');
            %             set(cax,
        end
    case 5
        corners = round(allxy(:,[1 16 241 256]));
        tmp = zeros(16);
        tmp(elects) = data;
        t = maketform('affine',[16 16 1;16 1 16]',corners(:,1:3)');
        R = makeresampler('cubic','bound');
        tmp2 = imtransform(tmp,t,R,'XYScale',1);
        tmp2 = rot90(tmp2,2);
        tmp2 = tmp2*0.999/max2(abs(tmp2));
        tmp3 = zeros(size(img));
        tmp3(min(corners(2,:)):min(corners(2,:))+size(tmp2,1)-1,min(corners(1,:)):min(corners(1,:))+size(tmp2,2)-1) = tmp2;
        hold off;
        imshow(img);
        hold on
        r = cat(3,ones(size(img)),zeros(size(img)),zeros(size(img)));
        b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        hb = imshow(b);
        hr = imshow(r);
        set(hb,'AlphaData',max(-tmp3,0));
        set(hr,'AlphaData',max(tmp3,0));
        
end