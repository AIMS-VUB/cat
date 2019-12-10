function [eeg, fs, labels, positions, ind] = cat_set_loadfile(setfile, options)
%CAT_SET_LOADFILE Common load part for continuous and epoched set files
%
%   This function is used by cat_set_loadfile_continuous and
%   eat_set_loadfile_epoched and does the common part of loading a set file and
%   extracting some information. Only the epoch extraction is specific to those
%   functions.
%
%   [epochs, fs, labels, options] = CAT_SET_LOADFILE(setfile, options)
%
%   setfile       full file name of the set file
%   options       struct containing parameters, listed below
%   .chanlabels   channels to be selected. This is a cell array of labels. If
%                 omitted or empty, all channels will be used.

%   #2018.04.24 Jorne Laton#

eeg = pop_loadset('filename', setfile);
eeg = eeg_checkset(eeg);

fs = eeg.srate;
labels = {eeg.chanlocs.labels}';
positions = zeros(length(labels), 2);
[positions(:, 1), positions(:, 2)] = ...
  cat_set_topoplot([], eeg.chanlocs, 'noplot', 'on', 'chaninfo', eeg.chaninfo);

if isfield(options, 'chanlabels') && iscell(options.chanlabels)
  [~, ind] = ismember(options.chanlabels, labels);
else
  ind = 1 : eeg.nbchan;
end

labels = labels(ind);
positions = positions(ind, :);