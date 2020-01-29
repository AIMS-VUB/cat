function epochs = cat_eeg_loaddata(src_file, options)
%CAT_EEG_LOADDATA Extracts epoched data from EEGlab file
%
%   Copies a number of epochs defined in options from an epoched EEGlab file.
%
%   [epochs] = CAT_EEG_LOADDATA(src_file, options)
%
%   src_file    full file name of the EEGlab file
%   options     struct containing parameters, listed below
%   .n_epochs   number of epochs to be cut out. If this number is smaller than
%               the actual number of epochs in the file, the selected epochs are
%               evenly distributed across all epochs.

%   .channels   channels to be selected. This is an array of channel indices, or
%               a cell array of labels. If omitted or empty, all channels will
%               be used.

% Last edit: 20200129 Jorne Laton - streamlined with changes to processing code
% Authors:   Jorne Laton

eeg = pop_loadset('filename', src_file);
eeg = eeg_checkset(eeg);

if ~isfield(options, 'n_epochs')
  options.n_epochs = eeg.trials;
end

epoch_ind = round(1 : eeg.trials/options.n_epochs : eeg.trials);

epochs = eeg.data(:, :, epoch_ind);