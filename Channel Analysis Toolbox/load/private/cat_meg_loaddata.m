function epochs = cat_meg_loaddata(src_file, options)
%CAT_MEG_LOADDATA Extracts epoched data from SPM file
%
%   Copies a number of epochs defined in options from an epoched SPM file.
%
%   [epochs] = CAT_MEG_LOADDATA(src_file, options)
%
%   src_file    full file name of the SPM file
%   options     struct containing parameters, listed below
%   .n_epochs   number of epochs to be cut out. If this number is smaller than
%               the actual number of epochs in the file, the selected epochs are
%               evenly distributed across all epochs.
%   .eventlabel label of epochs to retain
%   .chantype   type of channel to retain
%   .chanind    indices of channels to retain

%   .channels   channels to be selected. This is an array of channel indices, or
%               a cell array of labels. If omitted or empty, all channels will
%               be used.

% Last edit: 20200317 Jorne Laton - added support for selecting channels by index
% Authors:   Jorne Laton

meg = spm_eeg_load(src_file);

if isfield(options, 'eventlabel')
  epoch_ind = find(strcmp(options.eventlabel, conditions(meg)));
else
  if ~isfield(options, 'n_epochs')
    options.n_epochs = ntrials(meg);
  end  
  epoch_ind = round(1 : ntrials(meg)/options.n_epochs : ntrials(meg));
end

if ~isfield(options, 'chanind')
  if isfield(options, 'chantype')
    options.chanind = find(strcmp(options.chantype, chantype(meg)));
  else
    options.chanind = 1 : nchannels(meg);
  end
end

epochs = meg(options.chanind, :, epoch_ind);