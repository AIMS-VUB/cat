function [epochs, fs, labels] = cat_set_loadfile_epoched(setfile, options)
%CAT_SET_LOADFILE_EPOCHED Extracts epochs from epoched eeglab file
%
%   Copies a number of epochs from an epoched set files.
%
%   [epochs, fs, labels] = CAT_SET_LOADFILE_EPOCHED(setfile, options)
%
%   setfile     full file name of the set file
%   options     struct containing parameters, listed below
%   .n_epoch    number of epochs to be cut out. If this number is smaller than
%               the actual number of epochs in the file, the selected epochs are
%               evenly distributed across all epochs.
%   .channels   channels to be selected. This is an array of channel indices, or
%               a cell array of labels. If omitted or empty, all channels will
%               be used.
%
%   See also CAT_SET_LOADFILE.

%   #2018.05.24 Jorne Laton#

[eeg, fs, labels, ~, chan_ind] = cat_set_loadfile(setfile, options);

if ~isfield(options, 'n_epochs')
  options.n_epochs = eeg.trials;
end

epoch_ind = round(1 : eeg.trials/options.n_epochs : eeg.trials);

epochs = eeg.data(chan_ind, :, epoch_ind);