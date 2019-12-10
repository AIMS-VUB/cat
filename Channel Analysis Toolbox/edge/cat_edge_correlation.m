function E = cat_edge_correlation(E, options)
%CAT_EDGE_CORRELATION - Correlation
%
%   Calculates the correlation. Its result is stored in the added field
%   'edges.correlation',  which contains a 4D matrix with dimensions: locations,
%   locations, epochs, subjects, and a 3D matrix with the average over the
%   epochs.
%
%   E = CAT_EDGE_CORRELATION(E)
%
%   E     struct containing the field 'timeseries' and 'fs'.
%
%   #2019.03.15 Jorne Laton#

cat_check('parpool');

if iscell(E.timeseries.epochs)
  extract = @extractcell;
  n_chan = size(E.timeseries.epochs{1}, 2);
  n_subj = length(E.filenames);
else
  extract = @extractmat;
  [~, n_chan, ~, n_subj] = size(E.timeseries.epochs);
end

% Get required fields from E for use in parfor
epochs = E.timeseries.epochs;
fs = E.fs;
subjects = strrep(E.filenames, '.mat', '');
correlation_average = zeros(n_chan, n_chan, n_subj);

parfor s = 1 : n_subj
  disp(['Calculating correlation for subject ' subjects{s}]);
  correlation_average(:, :, s) = correlation(feval(extract, epochs, s), fs, options);
end

E.edges.correlation.average = correlation_average;

