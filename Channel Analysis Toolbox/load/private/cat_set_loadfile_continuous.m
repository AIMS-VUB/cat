function [epochs, fs, chanlabels] = cat_set_loadfile_continuous(setfile, options)
%CAT_SET_LOADFILE_CONTINUOUS Extracts epochs from continuous eeglab file
%
%   Extracts a number of epochs from manually marked valid signal parts in a set
%   file.
%
%   [epochs, fs, labels] = CAT_SET_LOADFILE_CONTINUOUS(setfile, options)
%
%   setfile     full file name of the set file
%   options     struct containing parameters, listed below
%   .eventlabel label marking the EEG parts to be kept for epoching
%   .epoch_len  length of the epochs that will be cut out
%   .n_epoch    number of epochs to be cut out
%   .chanlabels   channels to be selected. This is a cell array of labels. If
%                 omitted or empty, all channels will be used.
%
%   See also CAT_SET_LOADFILE.

%   #2018.04.24 Jorne Laton#

[eeg, fs, chanlabels, ind] = cat_set_loadfile(setfile, options);

epochs = zeros(length(chanlabels), options.epoch_len, options.n_epochs);

keep_sig = strcmp({eeg.event(:).type}', options.eventlabel);
durations = [eeg.event(keep_sig).duration]';
latencies = [eeg.event(keep_sig).latency]';
part_epoch_n = floor(durations/options.epoch_len);

epoch_ind = 1;

for lat_ind = 1 : length(latencies)
  for part_ind = 1 : part_epoch_n(lat_ind)
    epochs(:, :, epoch_ind) = eeg.data(ind, ...
      (latencies(lat_ind) + options.epoch_len*(part_ind - 1)) : ...
      (latencies(lat_ind) + options.epoch_len*part_ind - 1));
    epoch_ind = epoch_ind + 1;
    if epoch_ind > options.n_epochs
      return
    end
  end
end