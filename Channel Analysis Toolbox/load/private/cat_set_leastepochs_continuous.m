function [n_epochs, n_epochs_per_file] = cat_set_leastepochs_continuous(folder, options)
%CAT_SET_MIN_EPOCHS - Minimum number of epochs over continuous files in a folder
%
%   Returns the least number of valid epochs of a certain length that can
%   be cut out of the continuous EEG files found in a folder.
%
%   [n_epochs, n_epochs_per_file] = CAT_SET_LEASTEPOCHS_CONTINUOUS(folder, options)
%
%   folder      folder from which the files are retrieved
%   options     struct containing the following fields
%   .epoch_len  length of epochs in number of time points
%   .eventlabel label marking the start of the event

%   #2018.03.19 Jorne Laton#

[filepaths, filenames] = listfiles(folder, '*.set');
n_epochs_per_file = zeros(length(filepaths), 1);

eventlabel = options.eventlabel;
epoch_len = options.epoch_len;

parfor i = 1 : length(filepaths)
  eeg = pop_loadset('filename', filepaths{i});
  eeg = eeg_checkset(eeg);
  keep_sig = strcmp({eeg.event(:).type}', eventlabel);
  durations = [eeg.event(keep_sig).duration]';
  n_epochs_per_file(i) = sum(floor(durations/epoch_len));
end

n_epochs = min(n_epochs_per_file);
n_epochs_per_file = [filenames, num2cell(n_epochs_per_file)];