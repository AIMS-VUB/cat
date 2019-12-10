function cat_plot_timeseries_compare(E1, E2, options)
%CAT_PLOT_TIMESERIES_COMPARE plots two groups' time series
%
%   CAT_PLOT_TIMESERIES_COMPARE(E1, E2, options) plots the average time
%   series stored in E1 and E2. Plot options can be given through the struct options.
%
% Input
%   E1, E2      standard CAT struct
%   options     see CAT_CHECKPLOTOPTIONS for all general setting fields.
%               Specific fields below:
%   .interval   time interval in milliseconds to show, empty to show all (default)
%
%   See also CAT_PLOT_CHECKOPTIONS.

%   #2019.05.03 Jorne Laton#

if nargin < 3
  options = [];
end
if ~isfield(options, 'interval') || isempty(options.interval)
  options.interval = [];
  options.interval = 1 : length(E1.timeseries.times);
else
  options.interval = E1.timeseries.times >= options.interval(1)...
    & E1.timeseries.times < options.interval(2);
end
options = cat_plot_checkoptions(E1, options);

% Select one or all subjects, select one or all channels, select frequency
% interval
timeseries1 = E1.timeseries.average(options.interval, options.chanindices, :);
timeseries2 = E2.timeseries.average(options.interval, options.chanindices, :);
% Average over subjects
timeseries1 = mean(timeseries1, 3);
timeseries2 = mean(timeseries2, 3);

subjectname = 'average';
legenda = {E1.group E2.group};
plottitle = [E1.paradigm ' ' E1.event ' ' options.chanlabels{1}];

%% Plot
hold all
plot(E1.timeseries.times(options.interval), timeseries1, 'Linewidth', 3)
plot(E2.timeseries.times(options.interval), timeseries2, 'Linewidth', 3)
grid on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.9;
hold off
if isfield(options, 'ylimits')
  options.interval = find(options.interval);
  axis([-inf inf options.ylimits]);
end

set(gca, 'FontSize', options.fontsize)
set(findall(gcf, 'type', 'text'), 'fontSize', options.fontsize)
xlabel('Time (ms)');
ylabel('Amplitude (µV)');
title(plottitle, 'FontWeight', 'Normal');
legend(legenda, 'Location', 'NorthWest');

%% Save it
if options.save
  save2pdf(fullfile(options.save, [E1.paradigm '_' E1.event '_' E1.group '-' E2.group ...
    '_' subjectname '_timeseries_' options.chanlabels{1}]));
end