function E = cat_eeg_loadmeta(src_file)
%CAT_EEG_LOADMETA EEGlab metadata extracter
%
%   This function extracts metadata from EEGlab files.
%
%   E = CAT_EEG_LOADMETA(src_file)
%
%   src_file      full file name of the EEGlab file

% Last edit: 20200128 Jorne Laton - streamlined with changes to processing code
% Authors:   Jorne Laton

eeg = pop_loadset('filename', src_file);
eeg = eeg_checkset(eeg);

[~, filename] = fileparts(src_file);
E.group = filename(1:3);
E.event = eeg.event(1).type;
E.fs = eeg.srate;
E.timeseries.times = eeg.times';
E.channels.labels = {eeg.chanlocs.labels}';
E.channels.positions = zeros(length(E.channels.labels), 2);
[E.channels.positions(:, 1), E.channels.positions(:, 2)] = ...
  cat_eeg_topoplot([], eeg.chanlocs, 'noplot', 'on', 'chaninfo', eeg.chaninfo);
E.channels.eeglablocs = eeg.chanlocs;