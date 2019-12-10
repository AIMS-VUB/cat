function E = cat_edge_coherence(E, bands, options)
%CAT_EDGE_COHERENCE - Coherence
%
%   Calculates the coherence. Its result is stored in the added field
%   'edges.coherence',  which contains a 4D matrix epochs, with dimensions: channels,
%   channels, epochs, subjects and a 3D matrix containing the
%   average over the epochs.
%
%   E = CAT_EDGE_COHERENCE(E, bands)
%
%   E       struct containing the field 'timeseries.epochs' and 'fs'.
%   bands   struct containing fields labels (n-cell array of band names) and
%           intervals (n-by-2 matrix of intervals). Mandatory if not yet
%           incorporated in E, ignored otherwise.
%
%   #2018.12.11 Jorne Laton#

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
coherence_grp = zeros(n_chan, n_chan, n_band, n_subj);

% Loop over subjects
parfor s = 1 : n_subj
  disp(['Computing coherence matrices for subject ' subjects{s}]);
  [coherence_subj, freqs] = coherence(feval(extract, epochs, s), fs, options);
  for b = 1 : n_band
    band_ind = freqs > intervals(b, 1) & freqs <= intervals(b, 2); %#ok<PFBNS>
    coherence_grp(:, :, b, s) = mean(coherence_subj(:, :, band_ind), 3);
  end
end

E.edges.coherence.average = coherence_grp;