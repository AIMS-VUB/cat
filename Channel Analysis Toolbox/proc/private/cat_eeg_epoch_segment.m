function eeg = cat_eeg_epoch_segment(eeg, options)
%CAT_EEG_EPOCH_SEGMENTS helper function for segment epoching

% Interval in seconds, rescale to data points
options.epoch_len = options.interval * eeg.srate;

% Extract relevant segments
keep_sig = strcmp({eeg.event(:).type}', options.eventcode);
cleandata.durations = [eeg.event(keep_sig).duration]';
cleandata.latencies = [eeg.event(keep_sig).latency]';

% Calculate possible number of epochs
cleandata.n_pos_epochs = floor(cleandata.durations/options.epoch_len);
n_evts = sum(cleandata.n_pos_epochs);

evt = [repmat(options.eventcode, n_evts, 1), cell(n_evts, 1)];
e = 1; % fake event counter

% Mark fake events
cleandata.latencies = cleandata.latencies / eeg.srate; % We need latencies in seconds from here
for l = 1 : length(cleandata.latencies)
  for p = 1 : cleandata.n_pos_epochs(l)
    evt{e, 2} = cleandata.latencies(l) + options.interval*(p - 1);
    e = e + 1;
  end
end

eeg = pop_importevent(eeg, 'event', evt, 'fields', {'type', 'latency'}, 'append', 'no');

% Reject data using clean rawdata and ASR
if isfield(options, 'car') && options.car
  eeg = clean_artifacts(eeg, 'FlatlineCriterion',5,'ChannelCriterion',0.8,...
    'LineNoiseCriterion',4,'Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,...
    'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
end
eeg = eeg_checkset(eeg);

% Cut epochs around freshly inserted event markers
eeg = pop_epoch(eeg, options.eventcode, [0, options.interval]);
eeg = eeg_checkset(eeg);

% Old code, will be removed after checking the above
% epochs = zeros(eeg.nbchan, options.epoch_len, eeg.trials, 'single');
% 
% epoch_ind = 1;
% 
% % Prepare eeg content
% eeg.event = [];
% eeg.urevent = [];
% 
% % Mark epochs
% for ev = 1 : length(event.latencies)
%   for ep = 1 : event.n_epochs(ev)
%     start_ind = event.latencies(ev) + options.epoch_len*(ep - 1);
%     end_ind = event.latencies(ev) + options.epoch_len*ep - 1;
%     eeg.event(epoch_ind).type = options.eventcode;
%     eeg.event(epoch_ind).value = 'marker';
%     eeg.event(epoch_ind).latency = 0;
%     eeg.event(epoch_ind).duration = 0;
%     eeg.event(epoch_ind).urevent = start_ind;
%     eeg.event(epoch_ind).epoch = epoch_ind;
%     epochs(:, :, epoch_ind) = eeg.data(:, start_ind : end_ind);
%     epoch_ind = epoch_ind + 1;
%   end
% end
% 
% % Save remaining variables for EEGlab compatibility
% eeg.setname = [eeg.setname ' epochs'];
% eeg.data = epochs;
% eeg.pnts = options.epoch_len;
% eeg.xmin = 0;
% eeg.xmax = (eeg.pnts - 1)/eeg.srate;
% eeg.times = (eeg.xmin : 1/eeg.srate : eeg.xmax)*1000;
% eeg = eeg_checkset(eeg);
end