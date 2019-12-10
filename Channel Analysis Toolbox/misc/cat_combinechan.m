function C = cat_combinechan(E, options)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n_region = size(options.regions, 1);

if isfield(E.timeseries, 'epochs')
  [n_time, ~, n_epoch, n_subj] = size(E.timeseries.epochs);  
  C.timeseries.epochs = zeros(n_time, n_region, n_epoch, n_subj);  
  for r = 1 : n_region
    ind = ismember(E.chanlabels, options.regions{r, 2});
    C.timeseries.epochs(:, r, :, :) = mean(E.timeseries.epochs(:, ind, :, :), 2);
  end
  C.timeseries.times = E.timeseries.times;
end

if isfield(E.timeseries, 'average')
  [n_time, ~, n_subj] = size(E.timeseries.average);  
  C.timeseries.average = zeros(n_time, n_region, n_subj);  
  for r = 1 : n_region
    ind = ismember(E.chanlabels, options.regions{r, 2});
    C.timeseries.average(:, r, :) = mean(E.timeseries.average(:, ind, :), 2);
  end
  C.timeseries.times = E.timeseries.times;
end

if isfield(E, 'spect')
  [n_freq, ~, n_subj] = size(E.spect.average);
  C.spect.average = zeros(n_freq, n_region, n_subj);
  for r = 1 : n_region
    ind = ismember(E.channels.labels, options.regions{r, 2});
    C.spect.average(:, r, :) = mean(E.spect.average(:, ind, :), 2);
  end
  C.spect.freqs = E.spect.freqs;
  C.spect.method = E.spect.method;
end

C.fs = E.fs;
C.channels.labels = options.regions(:, 1);
C.filenames = E.filenames;
C.channels.regions = options.regions;
C.bands = E.bands;
C.paradigm = E.paradigm;
C.event = E.event;
C.group = E.group;

end

