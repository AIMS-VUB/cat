function E = cat_edge_pli(E)
%CAT_EDGE_PLI - Phase-Lag Index
%
%   Calculates the phase-lag index. Its result is stored in the
%   added field 'pli',  which contains a 5D matrix, with dimensions: channels,
%   channels, epochs, subjects, and a 4D matrix containing the average over the
%   epochs.
%
%   E = CAT_EDGE_PLI(E)
%
%   E   is a struct containing the field 'epochs' and 'fs'.
%
%   #2018.11.26 Jorne Laton#

cat_check('parpool');

[n_chan, n_time, n_epoch, n_subj, n_band] = size(E.timeseries.epochs);

pli_epochs = zeros(n_chan, n_chan, n_epoch, n_subj, n_band);
H = hilbert(E.timeseries.epochs);
phase = angle(H);
filenames = E.filenames;

% Loop over subjects
parfor s = 1 : n_subj
  disp(['Calculating imagcoh matrices for subject ' filenames{s}(1:end-4)]);
  % Loop over bands
  for b = 1 : n_band
    % Loop over epochs
    for e = 1 : n_epoch
      % Loop over all unique combinations of channels
      for c1 = 1 : n_chan
        for c2 = 1 : n_chan
          delta = sign(wrapToPi(phase(:, c1, e, s, b) - phase(:, c2, e, s, b))); %#ok<PFBNS>
          pli_epochs(c1, c2, e, s, b) = abs(sum(delta))/n_time;
        end
      end
    end
  end
end

E.edges.pli.epochs = pli_epochs;
E.edges.pli.average = squeeze(mean(E.edges.pli.epochs, 3));