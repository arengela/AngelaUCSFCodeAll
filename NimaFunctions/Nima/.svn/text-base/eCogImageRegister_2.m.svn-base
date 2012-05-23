function [xy,img] = eCogImageRegister_2(imname, flag)
% flag: 1: register the image
%       0: load from file
%       2: display electrode numbers
% assume 256 electrodes
a = imread(imname);
[t1,t2,t3] = fileparts(imname);
regfile = [t1 filesep 'regdata.mat'];
switch flag
    case 1
        xy = zeros(2,128);
        if size(a,3)>1,
            a = a(:,:,2);
        end
        img = a;
        figure;
        imagesc(a);colormap(gray);
        hold on;
        [x,y] = ginput(4);
        eind = 1;
        % make a line between x(1)y(1) and x(2)y(2)
        for cnt1 = 0:15
            a = cnt1/15;
            xh1 = (1-a)*x(1)+a*x(4);
            xh2 = (1-a)*x(2)+a*x(3);
            yh1 = (1-a)*y(1)+a*y(4);
            yh2 = (1-a)*y(2)+a*y(3);
            line([xh1 xh2],[yh1 yh2]);
            mh = (yh2-yh1)/(xh2-xh1);
            nh = yh1-xh1*mh;
            %
            for cnt2 = 0:7
                b = cnt2/7;
                xv1 = (1-b)*x(1)+b*x(2);
                xv2 = (1-b)*x(4)+b*x(3);
                yv1 = (1-b)*y(1)+b*y(2);
                yv2 = (1-b)*y(4)+b*y(3);
                line([xv1 xv2],[yv1 yv2]);
                % now find the intersections:
                mv = (yv2-yv1)/(xv2-xv1);
                nv = yv1-xv1*mv;
                xy(1,eind) = -(nv-nh)/(mv-mh);
                xy(2,eind) = (mh*nv-mv*nh)/(mh-mv);
                %                 plot(xy(1,eind),xy(2,eind),'r*');
                text(xy(1,eind),xy(2,eind),num2str(eind),'color','r');
                eind = eind+1;
            end
        end
        save (regfile,'xy');
    case 0
        load (regfile);
        if size(a,3)>1, a = a(:,:,3);end
        img = a;
    case 2
end
