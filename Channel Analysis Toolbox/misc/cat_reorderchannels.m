function E = cat_reorderchannels(E, chanlabels)
%CAT_REORDERCHANNELS Select and/or reorder channels
%
%   Removes spect.peaks.max from E
%   Removes edges from E if channels are removed

if ~isfield(E.timeseries, 'epochs')
  error('Load data in normal (not light) mode to reorder channels.')
end

[~, ind] = ismember(chanlabels, E.channels.labels);
remove_chan = length(ind) ~= length(E.channels.labels);

E.channels.labels = E.channels.labels(ind);
if isfield(E.channels, 'positions')
  E.channels.positions = E.channels.positions(ind, :);
end

if ~iscell(E.timeseries.epochs)
  E.timeseries.epochs = E.timeseries.epochs(:, ind, :, :, :);
  if isfield(E.timeseries, 'average')
    E.timeseries.average = E.timeseries.average(:, ind, :, :);
  end
else
  for p = 1 : length(E.timeseries.epochs)
    E.timeseries.epochs{p} = E.timeseries.epochs{p}(:, ind, :, :);
    if isfield(E.timeseries, 'average')
      E.timeseries.average{p} = E.timeseries.average{p}(:, ind, :);
    end
  end
end

if isfield(E, 'edges') && remove_chan
  E = rmfield(E, 'edges');
  disp('Warning: removing edges. Rerun edge detectors.')
else
  fields = fieldnames(E.edges);
  for e = 1 : length(fields)
    E.edges.(fields{e}).average = E.edges.(fields{e}).average(ind, ind, :, :);
  end
end

if isfield(E.timeseries, 'peaks')
  E.timeseries.peaks.times = E.timeseries.peaks.times(:, ind, :);
  E.timeseries.peaks.ampls = E.timeseries.peaks.ampls(:, ind, :);
end

if isfield(E, 'spect')
  if isfield(E.spect, 'epochs')
    E.spect.epochs = E.spect.epochs(:, ind, :, :, :);
  end
  if isfield(E.spect, 'peaks')
    E.spect.peaks.amp = E.spect.peaks.amp(:, ind);
    E.spect.peaks.freq = E.spect.peaks.freq(:, ind);
    if isfield(E.spect.peaks, 'max')
      E.spect.peaks = rmfield(E.spect.peaks, 'max');
      disp('Warning: removing peaks max. Rerun maxpeak.')
    end
  end
  if isfield(E.spect, 'average')
    E.spect.average = E.spect.average(:, ind, :, :);
  end
end

E.timeseries.changed = true;