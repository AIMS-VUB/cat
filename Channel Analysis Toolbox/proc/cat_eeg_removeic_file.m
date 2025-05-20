function eeg = cat_eeg_removeic_file(eeg, options)
%CAT_EEG_REMOVEIC_FILE Remove artefactual independent components and interpolate removed bad channels
%
%   eeg = CAT_EEG_REMOVEIC_FILE(src_file, options)
%
%Input
%   src_file    full file name of the set file
%   options     struct containing the following fields:
%   .automark     automatically mark components for removal. Possible
%                 values: 'mara' and 'eogcorr'; can be combined using a
%                 cell array.
%   .corrchan     to set custom EOG channel names. Default {'HEOG' 'VEOG'}.
%   .marathresh   mara probability threshold for classifying components as artefacts, default 0.5.
%   .autoremove   automatically remove marked components
%   .chanlocs     output of cat_eeg_epoch, used for interpolation of removed bad channels
%   .chanlabels   labels of channels to retain
%   .ref          reference to rereference to
%   .bc_interval  interval for baseline correction in seconds

% Last edit: 20200122 Jorne Laton - created
% Authors:   Jorne Laton

if (ischar(eeg))
    eeg = pop_loadset('filename', eeg);
end
eeg = eeg_checkset(eeg);

if (isfield(options, 'automark') && ~isfield(options, 'corrchan'))
    options.corrchan = {'HEOG', 'VEOG'};
end

% Automatically mark ICA components to reject
if isfield(options, 'automark')
  if ~iscell(options.automark)
    options.automark = {options.automark};
  end
  if any(contains(options.automark, 'mara'))
    % selected components are stored in EEG.reject.gcompreject
    [~, eeg] = processMARA([], eeg);
    if isfield(options, 'marathresh')
      eeg.reject.gcompreject = eeg.reject.MARAinfo.posterior_artefactprob > options.marathresh;
      disp(['With probability threshold at ' num2str(options.marathresh)...
          ', MARA marked the following components for rejection:']);
      disp(find(eeg.reject.gcompreject));
    end
  end
  if any(contains(options.automark, 'eogcorr'))
    cfg.EOGcorr.enable = 1;
    cfg.EOGcorr.Heogchannames = options.corrchan{1};
    cfg.EOGcorr.corthreshH = 'auto 4';
    cfg.EOGcorr.Veogchannames = options.corrchan{2};
    cfg.EOGcorr.corthreshV = 'auto 4';
    [eeg2, ~] = eeg_SASICA(eeg, cfg);
    eeg.reject.gcompreject = eeg.reject.gcompreject | eeg2.reject.gcompreject;
  end
  % Remove marked components
  if isfield(options, 'autoremove')
    eeg = pop_subcomp(eeg, find(eeg.reject.gcompreject), 0);
    eeg = eeg_checkset(eeg);
  end
end

% Interpolate if a channel was removed during bad channel detection in cat_eeg_epoch
if isfield(options, 'chanlocs')
  eeg = pop_interp(eeg, options.chanlocs, 'spherical');
end

% Select channels to retain
if isfield(options, 'chanlabels')
  eeg = pop_select( eeg, 'channel', options.chanlabels);
end

% Re-reference
if isfield(options, 'ref')
  if length(options.ref) > 1 || ~strcmp(options.ref, 'res')
    ref = find(ismember({eeg.chanlocs.labels}, options.ref));
  else % average
    ref = [];
  end
  if isfield(options, 'ref_exclude') && ~isempty(options.ref_exclude)
    excl = find(ismember({eeg.chanlocs.labels}, options.ref_exclude));
  else
    excl = [];
  end
  eeg = pop_reref(eeg, ref, 'exclude', excl);
  eeg = eeg_checkset(eeg);
  if strcmp(options.ref, 'res')
    eeg = cat_eeg_rest(eeg, options.G);
    eeg = eeg_checkset(eeg);
  end
end

% Remove baseline
if isfield(options, 'bc_interval')
  % Ensure bc_interval is within epoch
  options.bc_interval = 1000*[max(options.bc_interval(1), eeg.xmin), min(options.bc_interval(2), eeg.xmax)];
  eeg = pop_rmbase(eeg, options.bc_interval);
end

eeg = eeg_checkset(eeg);
  
end