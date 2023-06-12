function eeg = cat_eeg_epoch_file(eeg, options)
%CAT_EEG_EPOCH_FILE Single-file epocher
%
%   Creates epochs in marked valid signal parts in a set file, around every occurrence of a
%   specific stimulus type or in the whole file by inserting fake events.
%
%   eeg = CAT_EEG_EPOCH_FILE(setfile, options)
%
%   src_file    full file name of the set file
%   options     struct containing the following fields:
%   Field       Value
%   car         set to perform continuous artefact rejection (bad channels, bad data periods) and
%               correction with Artefact Subspace Reconstruction (ASR). EEGlab's defaults are used.
%   markertype  string to select method to cut epochs
%               'stimulus': around stimulus events; in this case the eventcode is assumed to refer
%               to stimulus events.
%               'segment': cut epochs from continuous segments; in this case the eventcode should
%               refer to relevant eeg segments (typical for cleaned rest data).
%               'none': cut epochs from whole EEG, this will add fake events spaced according to
%               interval.
%   eventcode   string denoting the event in the data, either a reoccurring stimulus, a marker of
%               relevant segments or the name the fake events will get.
%   interval    lower and upper time limit (two-element vector, markertype = 'stimulus') for the
%               epoch in seconds, or epoch length (scalar, stimulus = 'segment' or 'none') for
%               non-stimulus EEG.
%   selection   indices of epochs to retain, use to remove overlapping epochs.
%               Passing a scalar will retain 1/selection of the original
%               number of epochs, evenly spread.
%               Passing 'auto', will automatically select only non-overlapping epochs.
%   bc_interval interval in milliseconds for baseline correction

% Last edit: 20200225 Jorne Laton - streamlined
% Authors:   Jorne Laton

if (ischar(eeg))
    eeg = pop_loadset('filename', eeg);
end
eeg = eeg_checkset(eeg);

% Extract epochs
switch options.markertype
  case 'stimulus'
    % Reject data using clean rawdata and ASR
    if isfield(options, 'car') && options.car
      eeg = cat_eeg_clean_artifacts(eeg, 'FlatlineCriterion',5,'ChannelCriterion',0.8,...
        'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,...
        'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7],...
        'IgnoredChannels', options.ignore_channels);
    end
    eeg = eeg_checkset(eeg);
    % Cut epochs around stimuli with EEGlab's built-in epocher
    eeg = pop_epoch(eeg, options.eventcode, options.interval);
  case 'segment'
    % Get epochs from relevant segments, marked by events with durations
    % This will insert a marker for each epoch
    eeg = cat_eeg_epoch_segment(eeg, options);
  case 'none'
    % Get epochs from the whole EEG
    % This will insert a marker for each epoch
    eeg = cat_eeg_epoch_nomarkers(eeg, options);
  otherwise
    error('Options.type should be one of ''stimulus'', ''segment'' or ''none''');
end

% Remove baseline
if isfield(options, 'bc_interval')
  % Ensure bc_interval is within epoch
  options.bc_interval = [max(options.bc_interval(1), eeg.xmin), min(options.bc_interval(2), eeg.xmax)];
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