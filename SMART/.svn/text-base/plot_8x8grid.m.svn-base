function plot_8x8grid(to_plot, f, num_freq_bands, window_around_event, clim, to_plot_grid)
% Should be used offline since it recalculates positioning of lines and #s
% optimal for avg plot and single event plot
% every time
% 
% Plots to_plot_grid x to_plot_grid grid

% set grid lines
set(f,'DefaultAxesxtick',[0.5: (window_around_event+1):to_plot_grid*(window_around_event+1)])
set(f,'DefaultAxesytick',[0.5: num_freq_bands:to_plot_grid*num_freq_bands])
set(f,'DefaultAxesxticklabel',[])
set(f,'DefaultAxesyticklabel',[])
set(f,'DefaultAxesgridlinestyle','-')


axes('Position',[0 0 1 1],'visible','off') %Labeling of graph with second axes
%x labels
% y=.08*ones(1,17);
% text([.10,.1457,.1684,.2363,.2590,.3270,.3497,.4176,.4405,.5090,.5316,.5996,.6222,.6902,.7129,.7809,.8189] ,y,{'-.5',...
%     '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5 -.5', '0','.5'})
% x=.095*ones(1,16);
% %ylabels
% text(x,[.154,.182,.259,.290,.365,.395,.471,.501,.578,.607,.684,.713,.790,.820,.896,.926],{'45','145',...
%     '45','145','45','145','45','145','45','145','45','145','45','145','45','145'})
% %x2=.065*ones(1,8);
% text(x(1:8),[.122,.229,.336,.442,.548,.654,.760,.866],{'10','10',...
%     '10','10','10','10','10','10'})
 h=axes('Position',[.1 .1 .85 .85], 'visible', 'off');



% Calcaulate placement of #s and dashed lines
avgfig_dash_y = repmat([0 num_freq_bands*to_plot_grid],to_plot_grid,1)';
fig_dash_x = repmat([round((window_around_event+1)/2):window_around_event+1:to_plot_grid*window_around_event],2,1);

fig_num_y = [6.4:num_freq_bands:to_plot_grid*num_freq_bands];
fig_num_y = reshape(repmat(fig_num_y,[to_plot_grid 1]),to_plot_grid^2,1);
fig_num_x = [10:(window_around_event+1):to_plot_grid*(window_around_event+1)];
fig_num_x = reshape(repmat(fig_num_x,[1 to_plot_grid]),to_plot_grid^2,1);
fig_nums = {};
for i = 1:to_plot_grid^2
    fig_nums = [fig_nums {num2str(i)}];
end



% plot
imagesc(real(to_plot),clim)
line(fig_dash_x,avgfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);
set(f,'Color',[1,1,1])

cbar_handle=colorbar('Yticklabel',clim,'ytick',clim);
set(get(cbar_handle,'ylabel'),'string','z-score')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
text(fig_num_x, fig_num_y, fig_nums)
line(fig_dash_x,avgfig_dash_y,'LineStyle','--','linewidth',1','color',[0 0 0]);

grid on
% drawnow;
pause(.01)
set(f,'CurrentAxes',h)