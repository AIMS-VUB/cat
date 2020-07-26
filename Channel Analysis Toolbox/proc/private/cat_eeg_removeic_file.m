function eeg = cat_eeg_removeic_file(src_file, options)
%CAT_EEG_REMOVEIC_FILE Remove artefactual independent components and interpolate removed bad channels
%
%   eeg = CAT_EEG_REMOVEIC_FILE(src_file, options)
%
%Input
%   src_file    full file name of the set file
%   options     struct containing the following fields:
%   .automark     automatically mark components for removal. Optional values: 'mara'.
%   .marathresh   mara probability threshold for classifying components as artefacts, default 0.5.
%   .autoremove   automatically remove marked components
%   .chanlocs     output of cat_eeg_epoch, used for interpolation of removed bad channels
%   .chanlabels   labels of channels to retain

% Last edit: 20200122 Jorne Laton - created
% Authors:   Jorne Laton

eeg = pop_loadset('filename', src_file);
eeg = eeg_checkset(eeg);

% Automatically mark ICA components to reject
if isfield(options, 'automark')
  if ~iscell(options.automark)
    options.automark = {options.automark};
  end
  if contains(options.automark, 'mara')
    % selected components are stored in EEG.reject.gcompreject
    [~, eeg] = processMARA([], eeg);
    if isfield(options, 'marathresh')
      eeg.reject.gcompreject = eeg.reject.MARAinfo.posterior_artefactprob > options.marathresh;
    end
  end
  if contains(options.automark, 'eogcorr')
    cfg.EOGcorr.enable = 1;
    cfg.EOGcorr.Heogchannames = 'HEOG';
    cfg.EOGcorr.corthreshH = 'auto 4';
    cfg.EOGcorr.Veogchannames = 'VEOG';
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

eeg = eeg_checkset(eeg);
  
end