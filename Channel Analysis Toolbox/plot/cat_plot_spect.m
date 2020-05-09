function cat_plot_spect(E, options)
%CAT_PLOT_SPECT plots the spectra
%
%   CAT_PLOT_SPECT(E, options) plots the spectra calculated and stored in E, in
%   a frequency spectrum plot. Plot options can be given through the struct options.
%
% Input
%   E           standard CAT struct, including the field spect
%   options     see CAT_PLOT_CHECKOPTIONS for all general setting fields.
%               Specific fields below:
%   .interval   frequency interval to show, empty to show all (default)
%
%   See also CAT_SPECT and CAT_PLOT_CHECKOPTIONS.

%   #2018.11.27 Jorne Laton#

if nargin < 2
  options = [];
end
if ~isfield(options, 'interval') || isempty(options.interval)
  options.interval = 1 : length(E.spect.freqs);
else
  options.interval = E.spect.freqs >= options.interval(1) & E.spect.freqs < options.interval(2);
end
if isfield(options, 'region')
  options.chanlabels = E.spect.peaks.regions.channels{options.region};
end
options = cat_plot_checkoptions(E, options);

% Select one or all subjects, select one or all channels, select frequency
% interval
spect = E.spect.average(options.interval, options.chanindices, options.subject);
% Average over subjects
spect = mean(spect, 3);
if strcmp(options.chanlabels, 'average')
  spect = squeeze(mean(spect, 2));
  legenda = 'channel average';
else
  if strcmp(options.chanlabels, 'median')
    spect = squeeze(median(spect, 2));
    legenda = 'channel median';
  else
    legenda = E.channels.labels(options.chanindices);
  end
end

if length(options.subject) > 1
  subjectname = ' average';
  id = '';
else
  subjectname = [' (' E.filenames{options.subject}(1:end-4) ')'];
  id = num2str(options.subject);
  id = [repmat('0', 1, 3 - length(id)), id];
end
if isfield(options, 'region')
  region = [' ' E.spect.peaks.regions.labels{options.region}];
else
  region = '';
end

% plottitle = [E.group id subjectname ' spectrum'];
plottitle = [E.group id subjectname region ' spectra'];

%% Plot
plot(E.spect.freqs(options.interval), spect, 'LineWidth', 2)
if isfield(options, 'ylimits')
  options.interval = find(options.interval);
  axis([-inf inf options.ylimits]);
end
if isfield(options, 'region') && length(options.subject) == 1 && ...
    ~isnan(E.spect.peaks.regions.ampls(options.subject, options.region))
  hold on
  plot(E.spect.peaks.regions.freqs(options.subject, options.region), ...
    E.spect.peaks.regions.ampls(options.subject, options.region), 'rx', 'MarkerSize', 20, 'LineWidth', 2)
  hold off
end

set(gca, 'FontSize', options.fontsize)
set(findall(gcf, 'type', 'text'), 'fontSize', options.fontsize)
xlabel('Frequency (Hz)');
ylabel('Power (\muVA²/Hz)');
title(plottitle);
legend(legenda);

%% Save it
if options.save
  region = strrep(region, ' ', '_');
  filepath = fullfile(options.save, [E.paradigm '_' E.event '_' E.group id region  '_spectra']);
  if strcmp(options.savetype, 'pdf')
    save2pdf(filepath);
  else
    saveas(gcf, filepath, options.savetype);
  end

end