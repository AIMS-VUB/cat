function E = cat_edge_mutualinfo(E, delay)
%CAT_EDGE_MUTUALINFO - Mutual information
%
%   E = CAT_EDGE_MUTUALINFO(E)
%   calculates the mutual information. Its result is stored in the added field
%   'edges.mutualinfo',  which contains two fields: epochs, a 5D matrix with
%   dimensions: channels, channels, epochs, subjects and bands, and averages, a 4D
%   matrix wich is the mean of the epochs field over the third dimension, and
%   squeezed.
%
%Input
%   E       struct containing the field 'epochs' and 'fs'.
%   delay   amount of seconds to delay the signals to see the non-immediate
%           effects. The average is taken over these different delays.
%
%   See also MUTUALINFO and CAT_PLOT_MUTUALINFO.

%   #2018.11.26 Jorne Laton#

cat_check('parpool');

[n_chan, n_time, n_epoch, n_subj, n_band] = size(E.timeseries.epochs);

% Induce delay in signals
if nargin < 2
  delay = 0;
else
  if delay ~= 0
    delay = linspace(0, delay, 6);
  end
end

E.edges.mutualinfo.delays = delay;

delay = floor(delay * mode(E.fs));
n_delay = length(delay);

delays_epochs = zeros(n_chan, n_chan, n_delay, n_epoch, n_subj, n_band);
epochs = E.timeseries.epochs;
filenames = E.filenames;
bandlabels = E.bands.labels;

delaytext = E.edges.mutualinfo.delays;

% Looperdeloop
% loop over delays
parfor d = 1 : n_delay
  t_nodelay = 1 : (n_time - delay(d));
  t_delayed = (delay(d) + 1) : n_time;
  % loop over subjects
  for b = 1 : n_band
    for s = 1 : n_subj
      disp(['Delay = ' num2str(delaytext(d)) ', band = ' bandlabels{b} ...
        ' - calculating mutualinfo for subject ' filenames{s}(1:end-4)]); %#ok<PFBNS>
      % loop over epochs
      for e = 1 : n_epoch
        % calculate mutual info between all unique channel pairs
        for c1 = 1 : n_chan
          for c2 = 1 : n_chan
            delays_epochs(c1, c2, d, e, s, b) = mutualinfo(...
              epochs(c1, t_nodelay, e, s, b), epochs(c2, t_delayed, e, s, b)); %#ok<PFBNS>
          end
        end
      end
    end
  end
end

E.edges.mutualinfo.epochs = delays_epochs;
E.edges.mutualinfo.average = squeeze(mean(E.edges.mutualinfo.epochs, 4));