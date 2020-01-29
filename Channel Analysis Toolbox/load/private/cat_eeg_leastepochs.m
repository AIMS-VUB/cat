function [n_epochs, n_epochs_per_file] = cat_eeg_leastepochs(filepaths, filenames)
%CAT_EEG_LEASTEPOCHS - Minimum number of epochs in a set of files
%
%   Returns the least number of valid epochs of a certain length that can
%   be extracted from each of the EEG files.
%
%   min_epochs = CAT_EEG_LEASTEPOCHS(folder, ~)
%
%   filepaths   cell array - path to each file
%   filenames   cell array - name of each file

%   #2020.01.28 Jorne Laton#

n_epochs_per_file = zeros(length(filepaths), 1);

parfor i = 1 : length(filepaths)
  eeg = pop_loadset('filename', filepaths{i});
  eeg = eeg_checkset(eeg);
  n_epochs_per_file(i) = eeg.trials;
end

n_epochs = min(n_epochs_per_file);
n_epochs_per_file = [filenames, num2cell(n_epochs_per_file)];