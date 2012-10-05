%% wordlearning_behav_analysis
%
% For analyzing reaction time and accuracy data from the word learning
% task.
%
% Also provides index of each word in each run for item analysis of ECoG
% data.

%% Params

% subject number
subj = 'EC26';

% accuracy threshold
acc_thresh = 0.33;

% plotting flags
mean_plots_flag = 1;
item_plots_flag = 1;

% define "early" vs. "late" runs
early_start = 1;
early_end = 6;
late_start = 7;
late_end = 12;


logfile_dir = ['E:\PreprocessedFiles\EC26\logfiles'];

%%
% get list of files in runs logfile directory
dirlist = dir(logfile_dir);
loglist = {dirlist(3:end).name};

% get numbers of each logfile
for i = 1:length(loglist)
    if ~isempty(strfind(loglist{i},'txt'))
        run_num = regexp(loglist(i), '_', 'split');
        run_num = regexp(run_num{1}, '[1234567890]','match');
        logf(i).runn = run_num{2};
        logf(i).runn = str2double([logf(i).runn{:}]);
    end
end

% sort logfiles by number
[y,idx] = sort([logf.runn]);
for i = 1:length(loglist)
    loglist_sorted(i) = loglist(idx(i));
end

% parse logfile
for i = 1:length(loglist)
    logfile = importdata([logfile_dir '/' loglist_sorted{i}]);
    logf(i).type = 'run';
    run_num = regexp(loglist_sorted(i), '_', 'split');
    run_num = regexp(run_num{1}, '[1234567890]','match');
    logf(i).runn = run_num{2};
    logf(i).runn = str2double([logf(i).runn{:}]);
    logf(i).word = logfile.textdata(3:end,1);
    for j = 3:length(logfile.textdata)
        if strcmpi(logfile.textdata(j,2),'LP') || ...
                strcmpi(logfile.textdata(j,2),'SP')
            logf(i).cond(j-2) = 2; % pseudo
        else
            logf(i).cond(j-2) = 1; % word
        end
    end
    logf(i).resp = logfile.data(:,1);
    logf(i).accu = logfile.data(:,2);
    logf(i).chrt = logfile.data(:,3);
    logf(i).wdrt = logfile.data(:,4);
end

% compile results
for i = 1:length(logf)
    if strcmpi(logf(i).type, 'run')
        words = find(logf(i).cond == 1);
        pseud = find(logf(i).cond == 2);
        
        % accuracy
        results.accuracy(i).words = length(find(logf(i).accu(words))) / length(words);
        results.accuracy(i).pseud = length(find(logf(i).accu(pseud))) / length(pseud);
        
        % choices RT
        results.chrt(i).words_mean = mean(logf(i).chrt(words));
        results.chrt(i).words_stdv = std(logf(i).chrt(words));
        results.chrt(i).pseud_mean = mean(logf(i).chrt(pseud));
        results.chrt(i).pseud_stdv = std(logf(i).chrt(pseud));
        
        % word RT
        results.wdrt(i).words_mean = mean(logf(i).wdrt(words));
        results.wdrt(i).words_stdv = std(logf(i).wdrt(words));
        results.wdrt(i).pseud_mean = mean(logf(i).wdrt(pseud));
        results.wdrt(i).pseud_stdv = std(logf(i).wdrt(pseud));
    end
end

% compile means and stdevs
rts.mean = [results.wdrt.words_mean ; results.wdrt.pseud_mean]';
rts.stdv = [results.wdrt.words_stdv ; results.wdrt.pseud_stdv]';

% plot the data
if mean_plots_flag
    mean_fig = figure;
%     barwitherrors(rts.stdv,rts.mean);
    [ax, h1, h2] = plotyy(1:length(logf),rts.mean, 1:length(logf), ...
        [results.accuracy.words ; results.accuracy.pseud], @bar, @line);
    hold on;
    barwitherrors(rts.stdv,rts.mean);
    set(h2,'Marker','.');
    set(h2(1),'Color','blue');
    set(h2(2),'Color','red');
    
    xlabel('Run #');
    ylabel('RT (sec)');
    set(get(ax(2),'Ylabel'),'String','Accuracy (%)')
    title([subj ' behavioral analysis']);
    legend('Words','Pseudowords','Location','NorthEast');
        
%     for i = 1:length(results.accuracy)
% %         text(i,ylim-1,sprintf('W:%0.2f\nP:%0.2f',results.accuracy(i).words,results.accuracy(i).pseud));
%         text(i,max(max(rts.mean(i,:)) + max(rts.stdv(i,:)))+1,sprintf('W:%0.2f\nP:%0.2f',results.accuracy(i).words,results.accuracy(i).pseud));
%     end
end

%% Item analysis

wordlist = logf(1).word;
for i = 1:length(wordlist)
    for j = 1:length(logf)
        item_idx(i,j) = find(strcmpi(wordlist{i},logf(j).word));
        item_accu(i,j) = logf(j).accu(item_idx(i,j));
    end
end

item_accu_mean = mean(item_accu,2);
corr_items = find(item_accu_mean > acc_thresh);
corr_items_words = wordlist(corr_items);
incorr_items = find(item_accu_mean < acc_thresh);
incorr_items_words = wordlist(incorr_items);

corr_early_items = find(mean(item_accu(:,early_start:early_end),2) > acc_thresh);
corr_early_items_words = wordlist(corr_early_items);
incorr_early_items = find(mean(item_accu(:,early_start:early_end),2) < acc_thresh);
incorr_early_items_words = wordlist(incorr_early_items);
corr_late_items = find(mean(item_accu(:,late_start:late_end),2) > acc_thresh);
corr_late_items_words = wordlist(corr_late_items);
incorr_late_items = find(mean(item_accu(:,late_start:late_end),2) < acc_thresh);
incorr_late_items_words = wordlist(incorr_late_items);

% plot
if item_plots_flag
    for i = 1:5
        figure;
        for j = 1:10
            subplot(10,1,j);
            plot(item_accu(j*i,:));
            title(wordlist(j*i));
            set(gca,'YLim',[-0.1 1.1])
        end
    end
end