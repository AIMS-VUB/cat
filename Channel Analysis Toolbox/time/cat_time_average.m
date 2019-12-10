function E = cat_time_average(E, robust, smoothness)

cat_check('parpool');
epochs = E.timeseries.epochs;
filenames = E.filenames;
if nargin < 3
  smoothness = false;
  if nargin < 2
    robust = false;
  end
end
robust = logical(robust);

if robust
  averager = @spm_robust_average;
else
  averager = @mean;
end

average = zeros(length(E.timeseries.times), length(E.channels.labels), length(filenames));
if iscell(epochs)
  parfor s = 1 : length(E.filenames)
    disp(['Averaging ' filenames{s}])
    average(:, :, s) = averager(epochs{s}, 3);
  end
else
  parfor s = 1 : length(E.filenames)
    disp(['Averaging ' filenames{s}])
    average(:, :, s) = averager(epochs(:, :, :, s), 3);
  end
end

if smoothness
  average = smoothdata(average, 'movmean', smoothness);
end

E.timeseries.average = average;
E.timeseries.robust_average = robust;
E.timeseries.smoothness = smoothness;
if isfield(E.timeseries, 'peaks')
  disp('Warning: Removing time peaks');
  E.timeseries = rmfield(E.timeseries, 'peaks');
end