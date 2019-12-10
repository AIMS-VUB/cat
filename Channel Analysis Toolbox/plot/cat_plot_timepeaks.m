function cat_plot_timepeaks(E, options)
%CAT_PLOT_TIMEPEAKS plots the time peaks
%
%   CAT_PLOT_TIMEPEAKS(E, options) plots the peaks on top of the average time
%   series stored in E. Plot options can be given through the struct options.
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
if ~isfield(options, 'subject') || isempty(options.subject)
  options.subject = 1;
end
options = cat_plot_checkoptions(E, options);

hold all
cat_plot_timeseries(E, options);
plot(squeeze(E.timeseries.peaks.times(options.subject, options.chanindices, :)), ...
  squeeze(E.timeseries.peaks.ampls(options.subject, options.chanindices, :)), 'rO')
hold off
