function evnt = ECogFindEvents(dtpath,wpath,expt,names,params)
% read the experiment, and return all the events in the following form:
%   evntname: name
%   wordlist: array of all the words in that event
%   wordtime: timing of the words in that events (if more than one word,
%   return it still
%   type: expt type

%
if ~exist('params','var')
    thd = 0.5;
else
    thd = params(1);
end
%%
evind = 0;
fr = 16000;
for cnt10 = 1:length(expt)
    dpath = [dtpath filesep expt{cnt10}];
    wname = [dpath '/articulation.wav'];
    wname = [dpath '/ANIN2.htk'];
    if ~exist(wname,'file')
        wname = [dpath '/Analog/ANIN2.htk'];
    end
%     if ~exist(wname,'file')
%         wname = [dpath '/Analog/analog2.wav'];
%     end
    ind = [];
    [t1,t2,t3] = fileparts(wname);
    %     [w,f] = wavread(wname);
    if strcmpi(t3,'.wav')
        [w,f] = wavread(wname);
    else
        [w,f] = readhtk(wname);
    end
    w = w(:);
    w = resample(w,round(fr),round(f));
    f = fr;
    w = w-mean(w);
    t1 = abs(w)>(.05*std(w));
    t0 = sort(w);
    t1 = abs(w)>(.135*t0(end-500));
    t2 = find(t1);
    t3 = diff(t2)>(4*std(diff(t2)));
    t4 = find(t3);
    ind(1) = t2(1);
    for cnt1 = 1:length(t4)
        ind = [ind t2(t4(cnt1)+1)];
    end
    %%
    wo = [];
    for cnt1 = 1:length(names)
        
            wname = [wpath names{cnt1} '.wav'];
            [t,fs] = wavread(wname);
            t = resample(t(:,1),f,fs);
            tmp1 = find(t>(.2*std(t)));
            wi{cnt1} = tmp1(1);
            wo{cnt1} = t(tmp1(1):end);
        
    end
    %%
    cc=[];ci = [];
    tmpind = -200:5:500;
    for cnt2 = 1:length(wo)
        disp([num2str(cnt2) ' out of ' num2str(length(wo))]);
        tmp2 = resample(wo{cnt2},1,10);
        tmp2 = conv(abs(tmp2),ones(1,10),'same');
        tmp2 = [zeros(201,1); tmp2; zeros(201,1)];
        for cnt1 = 1:length(ind)
            %             disp([num2str(cnt1) ' out of ' num2str(length(ind))]);
            %
            w(end+1:ind(cnt1)+length(wo{cnt2})-1) = 0;
            tmp1 = resample(w(ind(cnt1):ind(cnt1)+length(wo{cnt2})-1),1,10);
            tmp1 = conv(abs(tmp1),ones(1,10),'same');
            %             cc(cnt1,cnt2) = corrnum(tmp1,tmp2);
            tmp1 = [zeros(201,1); tmp1; zeros(201,1)];
            for cnt3 = 1:length(tmpind)
                tmp3(cnt3) = corrnum(tmp1,circshift(tmp2,tmpind(cnt3)));
            end
            [cc(cnt1,cnt2), ci(cnt1,cnt2)] = max(tmp3);
            %             plot(tmp3);
            %             cc(cnt1,cnt2) = mean2(abs(tmp1/std2(tmp1)-tmp2/std2(tmp2)));
            %             if (cnt1==3) && (cnt2==273)%cc(cnt1,cnt2)>0.5
            %                 nn=0;
            %             end
            %             tmp3 = xcorr(tmp1,tmp2,1000,'unbiased');
            %             tmp3 = cc(cnt1,cnt2)*tmp3/tmp3(1);
            %             [tmp4, crc(cnt1,cnt2)] = max(tmp3);
            %             cc(cnt1,cnt2) = tmp4;
        end
    end
    % imagesc(cc/max2(cc));colorbar
    %%
    cc = cc/max(max(cc));
    [m,i] = max((cc)');
    ind2 = ind;
    thdrng = find(m<thd);
    ind2(thdrng)=[];
    i(thdrng)=[];
    %%
    tmp1 = [];
    ci(thdrng,:)=[]; cc(thdrng,:)=[];
    for cnt1 = 1:length(i), tmp1(cnt1) = ci(cnt1,i(cnt1));tmp2(cnt1) = cc(cnt1,i(cnt1)); end
    %%
    for cnt1 = 1:length(ind2)
        evind = evind + 1;
        evnt(evind).name = names{i(cnt1)};
        evnt(evind).ind  = i(cnt1);
        evnt(evind).confidence = tmp2(cnt1);
        %     evnt(cnt1).exptype = exptype;
        evnt(evind).StartTime = (ind2(cnt1)-wi{i(cnt1)}+tmpind(tmp1(cnt1))*10)/f;
        evnt(evind).StopTime  = evnt(evind).StartTime + (wi{i(cnt1)}+length(wo{i(cnt1)}))/f;
        evnt(evind).wname = [wpath names{i(cnt1)} '.wav'];
        evnt(evind).expt  = expt{cnt10};
        %
        tmp = strfind(expt{cnt10},'_');
        evnt(evind).subject = expt{cnt10}(1:tmp(1)-1);
        if length(tmp)>2
            evnt(evind).block = strrep(expt{cnt10}(tmp(1)+1:tmp(2)-1),'_data','');
        else
            evnt(evind).block = strrep(expt{cnt10}(tmp(1)+1:end),'_data','');
        end
        evnt(evind).exptind = cnt10;
        evnt(evind).trial = cnt1;
        evnt(evind).dpath = dpath;
    end
    %% check:
    if 0
        %         ssind = ceil(sqrt(length(evnt)));
        for n = 1%:length(evnt)
            subplot(ssind,ssind,n);
            disp(evnt(n).wname);
            wtmp = w(ceil(f*(evnt(n).StartTime-.25)):ceil(f*(evnt(n).StopTime+.25)));
            plot(wtmp);
            axis tight;
            a = axis;
            line([ceil(f*0.25) ceil(f*.25)],[a(3) a(4)],'color','r');
            line([a(2)-ceil(f*.25) a(2)-ceil(f*0.25)],[a(3) a(4)],'color','r');
            axis off;
            drawnow;
            %             soundsc(wtmp,f);
        end
        %% check 2
        hold off; n = 13;
        w1 = w((evnt(n).StartTime-.25)*f:(evnt(n).StopTime+.25)*f);
        plotm1(w1,'g');
        hold on
        [w2,fs] = wavread([wpath evnt(n).name]);
        w2 = resample(w2,f,fs);
        w2 = [zeros(f*.25,1); w2 ;zeros(f*0.25,1)];
        plotm1(w2,'k');
    end
end