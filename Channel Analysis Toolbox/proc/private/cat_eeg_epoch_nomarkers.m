function eeg = cat_eeg_epoch_nomarkers(eeg, options)
%CAT_EEG_EPOCH_FULL helper function for complete EEG epoching

% Create fake events spaced at options.interval from each other
n_evts = floor((eeg.xmax - eeg.xmin) / options.interval) - 1;
evt = [repmat(options.eventcode, n_evts, 1), ...
  num2cell(eeg.xmin+options.interval : options.interval : eeg.xmax-options.interval)'];
eeg = pop_importevent(eeg, 'event', evt, 'fields', {'type', 'latency'});

% Reject data using clean rawdata and ASR
if isfield(options, 'car') && options.car
  eeg = clean_artifacts(eeg, 'FlatlineCriterion',5,'ChannelCriterion',0.8,...
    'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,...
    'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
end
eeg = eeg_checkset(eeg);

% Cut epochs around freshly inserted event markers
eeg = pop_epoch(eeg, options.eventcode, [0, options.interval]);