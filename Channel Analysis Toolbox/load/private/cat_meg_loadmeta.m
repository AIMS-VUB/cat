function E = cat_meg_loadmeta(src_file, options)
%CAT_MEG_LOADMETA SPM metadata extracter
%
%   This function extracts metadata from SPM MEG files.
%
%   E = CAT_MEG_LOADMETA(src_file)
%
%   src_file      full file name of the EEGlab file

% Last edit: 20200128 Jorne Laton - streamlined with changes to processing code
% Authors:   Jorne Laton

if nargin < 2
  options = [];
end

meg = spm_eeg_load(src_file);

[~, filename] = fileparts(src_file);
E.group = filename(1:3);

if isfield(options, 'eventlabel')
  E.event = options.eventlabel;
else
  cond = conditions(meg);
  E.event = cond{1};
end

E.fs = fsample(meg);
E.timeseries.times = time(meg)';

E.channels.labels = chanlabels(meg)';
E.channels.positions = coor2D(meg)';

if isfield(options, 'chanind') || isfield(options, 'chantype')
  if isfield(options, 'chantype')
    options.chanind = strcmp(options.chantype, chantype(meg));  
  end
  E.channels.labels = E.channels.labels(options.chanind);
  E.channels.positions = E.channels.positions(options.chanind, :);
end