function eeg = cat_eeg_epoch_file(src_file, options)
%CAT_EEG_EPOCH_FILE Single-file epocher
%
%   Creates epochs in marked valid signal parts in a set file.
%
%   eeg = CAT_EEG_EPOCH_FILE(setfile, options)
%
%   src_file    full file name of the set file
%   options     struct containing the following fields:
%   Field       Value
%   type        string to select method to cut epochs
%               'stimulus': around stimulus events; in this case the eventcode is assumed to refer
%               to stimulus events.
%               'segments': cut epochs from continuous segments; in this case the eventcode should
%               refer to relevant eeg segments (typical for rest data).
%               'full': cut epochs from whole EEG, omitting margins at beginning and end of EEG if
%               passed through options.margins (in seconds).
%   eventcode   string denoting the event in the data, either a reoccurring stimulus or a marker of
%               relevant segments.
%   interval    lower and upper time limit (two-element vector, stimulus = 1) for the epoch in
%               seconds, or epoch length (scalar, stimulus = 'segment' or 'full') for non-stimulus EEG.
%   margin      for use with type = 'full', number of seconds to omit at the beginning and end of
%               EEG.
%   selection   indices of epochs to retain, use to remove overlapping epochs.
%               Passing a scalar will retain 1/selection of the original
%               amount of epochs, evenly spread.
%               Passing 'auto', will automatically select only non-overlapping epochs.
%   bc_interval interval in milliseconds for baseline correction

% Last edit: 20200114 Jorne Laton - streamlined
% Authors:   Jorne Laton

eeg = pop_loadset('filename', src_file);
eeg = eeg_checkset(eeg);

% Extract epochs
switch options.type
  % Cut epochs around stimuli with EEGlab's built-in epocher
  case 'stimulus'
    eeg = pop_epoch(eeg, options.eventcode, options.interval);
    % Get epochs from relevant segments, marked by events with durations
  case 'segments'
    eeg = cat_eeg_epoch_segments(eeg, options);
    % Get epochs from the whole EEG, omitting margins at beginning and end of EEG
  case 'full'
    eeg = cat_eeg_epoch_full(eeg, options);
  otherwise
    error('Options.type should be one of ''stimulus'', ''segments'' or ''full''');
end

% Remove baseline
if isfield(options, 'bc_interval')
  eeg = pop_rmbase(eeg, options.bc_interval);
end

% Select epochs
if isfield(options, 'selection')
  selection = options.selection;
  % Automatically skip overlapping epochs
  if strcmp(selection, 'auto')
    % Determine length of first epoch
    ev = find(ismember({eeg.event.type}, options.eventcode));
    selection = (eeg.event(ev(2)).latency-eeg.event(ev(1)).latency)/eeg.srate;
    % Compare with desired epoch length, to determine number of epochs to skip
    selection = ceil((options.interval(2)-options.interval(1))/selection);
  end
  % Skip every 'selection' epochs
  if length(selection) == 1
    selection = 1 : selection : eeg.trials-selection;
  end
  eeg = pop_select(eeg, 'trial', selection);
end
eeg = eeg_checkset(eeg);