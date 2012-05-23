function ECogDataVis_Positive (dpath, subject, elects, data, flag, maxsc)
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
cd(dpath)
imname='brain.jpg'
[xy,img] = eCogImageRegister(imname,0);
xy = xy(:,elects);
switch flag
    case 0
        figure;
        imagesc(img);colormap(gray);
        hold on;
        plot(xy(1,:),xy(2,:),'r.');
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
        %b = cat(3,zeros(size(img)),zeros(size(img)),ones(size(img)));
        %         figure;
        hold off;
        imshow(img);
        hold on
        hr = imshow(r);
        %hb = imshow(b);
        %
        d = fspecial('disk',12);
        tmpp = max(tmp1,0);
        tmpp = conv2(tmpp,d,'same').^1.33;
        %tmpn = -min(tmp1,0);
        %tmpn = conv2(tmpn,d,'same').^1.33;
        if isempty(maxsc)
            mm = max(tmpp(:))
        else
            mm = maxsc;
        end
        tmpp = tmpp/mm;
        %tmpn = tmpn/mm;
        set(hr,'AlphaData',tmpp);
        %set(hb,'AlphaData',tmpn);
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
        d = fspecial('disk',12);
        for cnt1 = 1:3
            tmp(:,:,cnt1) = conv2(tmp(:,:,cnt1),d,'same').^1.33;
%             tmp(:,:,cnt1) = tmp(:,:,cnt1)/max2(tmp(:,:,cnt1));
        end
        if isempty(maxsc)
            mm = max(tmp(:));
        else
            mm = maxsc;
        end
        tmp = tmp/mm;
        set(hb,'AlphaData',tmp(:,:,1));
        set(hg,'AlphaData',tmp(:,:,2));
        set(hr,'AlphaData',tmp(:,:,3));
        
end