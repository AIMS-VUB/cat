function eeg = cat_eeg_epoch_segments(eeg, options)
%CAT_EEG_EPOCH_SEGMENTS helper function for segment epoching

% Interval in seconds for convenience, rescale to data points
options.epoch_len = options.interval * eeg.srate;

% Extract relevant segments
keep_sig = strcmp({eeg.event(:).type}', options.eventcode);
event.durations = [eeg.event(keep_sig).duration]';
event.latencies = [eeg.event(keep_sig).latency]';

% Calculate possible number of epochs
event.n_epochs = floor(event.durations/options.epoch_len);
eeg.trials = sum(event.n_epochs);

epochs = zeros(eeg.nbchan, options.epoch_len, eeg.trials, 'single');

epoch_ind = 1;

% Prepare eeg content
eeg.event = [];
eeg.urevent = [];

% Mark epochs
for ev = 1 : length(event.latencies)
  for ep = 1 : event.n_epochs(ev)
    start_ind = event.latencies(ev) + options.epoch_len*(ep - 1);
    end_ind = event.latencies(ev) + options.epoch_len*ep - 1;
    eeg.event(epoch_ind).type = options.eventcode;
    eeg.event(epoch_ind).value = 'marker';
    eeg.event(epoch_ind).latency = 0;
    eeg.event(epoch_ind).duration = 0;
    eeg.event(epoch_ind).urevent = start_ind;
    eeg.event(epoch_ind).epoch = epoch_ind;
    epochs(:, :, epoch_ind) = eeg.data(:, start_ind : end_ind);
    epoch_ind = epoch_ind + 1;
  end
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