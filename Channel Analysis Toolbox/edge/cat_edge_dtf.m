function E = cat_edge_dtf(E, bands, options)
%CAT_EDGE_DTF - Directed transfer function
%
%   Calculates the directed transfer function. Its result is stored in the
%   added field 'edges.dtf',  which contains a 4D matrix, with dimensions: channels,
%   channels, epochs, subjects and a 3D matrix containing the average over the
%   epochs.
%
%   E = CAT_EDGE_DTF(E, bands, options)
%
%   E             struct containing the fields 'timeseries' and 'fs'
%   bands         struct containign the fields 'labels' and 'intervals'
%   options       struct containing the following fields
%   .order        model order. Default 4.
%   .windowlength length of the window
%   .alignment    'epoch' for alignment with start of the epoch, 'stimulus' for
%                 alignment with stimulus
%   .baseline     length of the baseline

%   #2019.03.22 Jorne Laton#

cat_check('parpool');

if nargin < 3
  options = [];
end

if exist('bands', 'var') && ~isempty(bands)
  if isfield(bands, 'labels') && isfield(bands, 'intervals')
    if ~isfield(E, 'bands')
      E.bands = bands;
    else
      warning(['There is already a specific band definition in the CAT struct. '...
        'Ignoring bands parameter.']);
    end
  else
    error('The parameter bands must be a struct with fields labels and intervals');
  end
end

if iscell(E.timeseries.epochs)
  extract = @extractcell;
  n_chan = size(E.timeseries.epochs{1}, 2);
  n_subj = length(E.filenames);
else
  extract = @extractmat;
  [~, n_chan, ~, n_subj] = size(E.timeseries.epochs);
end

% Get required fields from E for use in parfor
n_band = length(E.bands.labels);
epochs = E.timeseries.epochs;
fs = E.fs;
subjects = strrep(E.filenames, '.mat', '');
intervals = E.bands.intervals;
dtf_grp = zeros(n_chan, n_chan, n_band, n_subj);

% Loop over subjects
parfor s = 1 : n_subj
  disp(['Computing directed transfer function matrices for subject ' subjects{s}]);
    [dtf_subj, freqs] = dtf(feval(extract, epochs, s), fs, options);
    for b = 1 : n_band
      band_ind = freqs > intervals(b, 1) & freqs <= intervals(b, 2); %#ok<PFBNS>
      dtf_grp(:, :, b, s) = mean(dtf_subj(:, :, band_ind), 3);
    end
end

E.edges.dtf.average = dtf_grp;