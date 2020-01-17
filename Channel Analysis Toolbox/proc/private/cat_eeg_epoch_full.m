function eeg = cat_eeg_epoch_full(eeg, options)
%CAT_EEG_EPOCH_FULL helper function for complete EEG epoching

% Interval and margin in seconds for convenience, rescale to data points
options.epoch_len = options.interval * eeg.srate;
options.margin = options.margin * eeg.srate;

% Calculate possible number of epochs
n_epochs = floor((eeg.pnts - options.margin*2) / options.epoch_len);
eeg.trials = sum(n_epochs);

epochs = zeros(eeg.nbchan, options.epoch_len, eeg.trials, 'single');

% Prepare eeg content
eeg.event = [];
eeg.urevent = [];

for ep = 1 : n_epochs
  start_ind = options.margin + options.epoch_len * (ep - 1);
  end_ind = options.margin + options.epoch_len*ep - 1;
  epochs(:, :, ep) = eeg.data(:, start_ind : end_ind);
  eeg.event(ep).type = options.eventcode;
  eeg.event(ep).value = 'marker';
  eeg.event(ep).latency = 0;
  eeg.event(ep).duration = 0;
  eeg.event(ep).urevent = start_ind;
  eeg.event(ep).epoch = ep;
end

% Save remaining variables for EEGlab compatibility
eeg.setname = [eeg.setname ' epochs'];
eeg.data = epochs;
eeg.pnts = options.epoch_len;
eeg.xmin = 0;
eeg.xmax = (eeg.pnts - 1)/eeg.srate;
eeg.times = (eeg.xmin : 1/eeg.srate : eeg.xmax)*1000;
eeg = eeg_checkset(eeg);
end