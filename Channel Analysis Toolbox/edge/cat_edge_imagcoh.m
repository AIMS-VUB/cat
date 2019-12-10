function E = cat_edge_imagcoh(E, bands)
%CAT_EDGE_IMAGCOH - Imaginary part of coherency
%
%   E = CAT_EDGE_IMAGCOH(E)
%
%   Calculates the imaginary part of the coherency. Its result is stored in the
%   added field 'edges.imagcoh',  which is a 5D matrix, with dimensions: channels,
%   channels, frequencies, epochs, subjects.
%
%   E   is a struct containing the field 'timeseries.epochs' and 'fs'.
%
%   #2018.11.26 Jorne Laton#

cat_check('parpool');

if exist('bands', 'var')
  if ~E.epochs_filtered_in_bands
    if isfield(bands, 'labels') && isfield(bands, 'intervals')
      E.bands = bands;
    else
      error('The parameter bands must be a struct with fields labels and intervals');
    end
  else
    warning(['There is already a specific band definition in the CAT struct. '...
      'Ignoring bands parameter.']);
  end
end

[n_time, n_chan, n_epoch, n_subj, ~] = size(E.timeseries.epochs);

n_band = length(E.bands.labels);
epochs = E.timeseries.epochs;
filenames = E.filenames;
fs = E.fs;
intervals = E.bands.intervals;
imagcoh_epochs = zeros(n_chan, n_chan, n_epoch, n_subj, n_band);

if E.epochs_filtered_in_bands
  % There is an extra, non-singleton dimension bands in E.epochs
  % This version is roughly n_bands times slower
  % loop over all subjects
  parfor s = 1 : n_subj
    disp(['Computing imagcoh matrices for subject ' filenames{s}(1:end-4)]);
    % loop over all bands
    for b = 1 : n_band
      % loop over all epochs
      for e = 1 : n_epoch
        [Pxy, freq] = cpsd(epochs(:, :, e, s, b), ...
          epochs(:, :, e, s, b), [], [], n_time, fs, 'mimo');
        % loop over all channel pairs
        for c1 = 1 : n_chan
          for c2 = 1 : n_chan
            imagcoh = imag(Pxy(:, c1, c2)./sqrt(Pxy(:, c1, c1).*Pxy(:, c2, c2)));
            band_ind = freq > intervals(b, 1) & freq <= intervals(b, 2); %#ok<PFBNS>
            imagcoh_epochs(c1, c2, e, s, b) = mean(imagcoh(band_ind));
          end
        end
      end
    end
  end

else
  % The data is not filtered in bands, use bands which has been added to E in this
  % function
  % loop over all subjects
  parfor s = 1 : n_subj
    disp(['Computing imagcoh matrices for subject ' filenames{s}(1:end-4)]);
    % loop over all epochs
    for e = 1 : n_epoch
      [Pxy, freq] = cpsd(epochs(:, :, e, s), ...
        epochs(:, :, e, s), [], [], n_time, fs, 'mimo');
      % loop over all channel pairs
      for c1 = 1 : n_chan
        for c2 = 1 : n_chan
          imagcoh = imag(Pxy(:, c1, c2)./sqrt(Pxy(:, c1, c1).*Pxy(:, c2, c2)));
          % loop over all bands
          for b = 1 : n_band
            band_ind = freq > intervals(b, 1) & freq <= intervals(b, 2); %#ok<PFBNS>
            imagcoh_epochs(c1, c2, e, s, b) = mean(imagcoh(band_ind));
          end
        end
      end
    end
  end
  
end

E.edges.imagcoh.epochs = imagcoh_epochs;
s = size(E.edges.imagcoh.epochs);
E.edges.imagcoh.average = reshape(mean(E.edges.imagcoh.epochs, 3), [s([1:2 4:end]) 1]);