function [n_epochs, n_epochs_per_file] = cat_meg_leastepochs(filepaths, filenames)
%CAT_MEG_LEASTEPOCHS - Minimum number of epochs over all spm MEG files in a folder
%
%   Returns the least number of valid epochs of a certain length that can
%   be extracted from each of the SPM MEG files.
%
%   min_epochs = CAT_MEG_LEASTEPOCHS(filepaths, filenames)
%
%   filepaths   cell array - path to each file
%   filenames   cell array - name of each file

%   #2020.01.28 Jorne Laton#

n_epochs_per_file = zeros(length(filepaths), 1);

parfor i = 1 : length(filepaths)
  meg = spm_eeg_load(filepaths{i});
  n_epochs_per_file(i) = ntrials(meg);
end

n_epochs = min(n_epochs_per_file);
n_epochs_per_file = [filenames, num2cell(n_epochs_per_file)];