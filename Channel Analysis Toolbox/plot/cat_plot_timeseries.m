function cat_plot_timeseries(E, options)
%CAT_PLOT_TIMESERIES plots the time series
%
%   CAT_PLOT_TIMESERIES(E, options) plots the average time series stored in E.
%   Plot options can be given through the struct options.
%
% Input
%   E           standard CAT struct
%   options     see CAT_PLOT_CHECKOPTIONS for all general setting fields.
%               Specific fields below:
%   .interval   time interval in milliseconds to show, empty to show all (default)
%
%   See also CAT_PLOT_CHECKOPTIONS.

%   #2018.11.29 Jorne Laton#

if nargin < 2
  options = [];
end
if ~isfield(options, 'interval') || isempty(options.interval)
  options.interval = [];
  options.interval = 1 : length(E.timeseries.times);
else
  options.interval = E.timeseries.times >= options.interval(1)...
    & E.timeseries.times < options.interval(2);
end
options = cat_plot_checkoptions(E, options);

% Select one or all subjects, select one or all channels, select frequency
% interval
timeseries = E.timeseries.average(options.interval, options.chanindices, options.subject);
% Average over subjects
timeseries = mean(timeseries, 3);
if strcmp(options.chanlabels, 'average')
  timeseries = squeeze(mean(timeseries, 2));
  legenda = 'channel average';
else
  if strcmp(options.chanlabels, 'median')
    timeseries = squeeze(median(timeseries, 2));
    legenda = 'channel median';
  else
    legenda = E.channels.labels(options.chanindices);
  end
end

if length(options.subject) > 1
  subjectname = 'average';
else
  subjectname = E.filenames{options.subject}(1:end-4);
end

plottitle = [E.paradigm ' ' E.event ' ' E.group ' ' subjectname ' time series'];

%% Plot
plot(E.timeseries.times(options.interval), timeseries, 'Linewidth', 2)
if isfield(options, 'ylimits')
  options.interval = find(options.interval);
  axis([-inf inf options.ylimits]);
end

set(gca, 'FontSize', options.fontsize)
set(findall(gcf, 'type', 'text'), 'fontSize', options.fontsize)
xlabel('Time (ms)');
ylabel('Amplitude');
title(plottitle);
legend(legenda);

%% Save it
if options.save
  save2pdf(fullfile(options.save, [E.paradigm '_' E.event '_' E.group '_' subjectname...
    '_timeseries']));
end