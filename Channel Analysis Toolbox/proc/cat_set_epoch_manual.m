function eeg = cat_set_epoch_manual(setfile, options)
%CAT_SET_EPOCH_MANUAL Creates epochs in continuous eeglab file
%
%   Creates epochs in marked valid signal parts in a set file.
%
%   [epochs, fs, labels] = CAT_SET_LOADFILE_CONTINUOUS(setfile, options)
%
%   setfile     full file name of the set file
%   options     struct containing parameters, listed below
%   .eventlabel label marking the EEG parts to be kept for epoching
%   .epoch_len  length of the epochs that will be cut out
%
%   See also CAT_SET_EPOCH_MANUAL.

%   #2018.06.01 Jorne Laton#

eeg = pop_loadset('filename', setfile);
eeg = eeg_checkset(eeg);

keep_sig = strcmp({eeg.event(:).type}', options.eventlabel);
event.durations = [eeg.event(keep_sig).duration]';
event.latencies = [eeg.event(keep_sig).latency]';
event.n_epochs = floor(event.durations/options.epoch_len);
eeg.trials = sum(event.n_epochs);

epochs = zeros(eeg.nbchan, options.epoch_len, eeg.trials, 'single');

epoch_ind = 1;
eeg.event = [];
eeg.urevent = [];

for ev = 1 : length(event.latencies)
  for ep = 1 : event.n_epochs(ev)    
    start_ind = event.latencies(ev) + options.epoch_len*(ep - 1);
    end_ind = event.latencies(ev) + options.epoch_len*ep - 1;
    eeg.event(epoch_ind).type = options.eventlabel;
    eeg.event(epoch_ind).value = 'marker';
    eeg.event(epoch_ind).latency = 0;
    eeg.event(epoch_ind).duration = 0;
    eeg.event(epoch_ind).urevent = start_ind;
    eeg.event(epoch_ind).epoch = epoch_ind;
    epochs(:, :, epoch_ind) = eeg.data(:, start_ind : end_ind);
    epoch_ind = epoch_ind + 1;
  end
end

eeg.setname = [eeg.setname ' epochs'];
eeg.data = epochs;
eeg.pnts = options.epoch_len;
eeg.xmin = 0;
eeg.xmax = (eeg.pnts - 1)/eeg.srate;
eeg.times = (eeg.xmin : 1/eeg.srate : eeg.xmax)*1000;
eeg = eeg_checkset(eeg);