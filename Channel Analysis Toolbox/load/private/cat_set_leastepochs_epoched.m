function [n_epochs, n_epochs_per_file] = cat_set_leastepochs_epoched(folder, ~)
%CAT_SET_MIN_EPOCHS - Minimum number of epochs over continuous files in a folder
%
%   Returns the least number of valid epochs of a certain length that can
%   be cut out of the continuous EEG files found in a folder.
%
%   min_epochs = CAT_SET_MIN_EPOCHS(folder, ~)
%
%   folder      folder from which the files are retrieved

%   #2018.05.17 Jorne Laton#

[filepaths, filenames] = listfiles(folder, '*.set');
n_epochs_per_file = zeros(length(filepaths), 1);

parfor i = 1 : length(filepaths)
  eeg = pop_loadset('filename', filepaths{i});
  eeg = eeg_checkset(eeg);
  n_epochs_per_file(i) = eeg.trials;
end

n_epochs = min(n_epochs_per_file);
n_epochs_per_file = [filenames, num2cell(n_epochs_per_file)];