function eeg = cat_set_preprocess(setpath, options)
%%CAT_SET_PREPROCESS EEGLab set file preprocessor
%   
%   options = CAT_SET_PREPROCESS(setpath, options) preprocesses an existing set
%   file created by EEGLab. Preprocessing options are channel selection,
%   downsampling, re-referencing, filtering, ICA, MARA, epoch rejection and
%   baseline rejection.
%
%   Field         Value
%   .chanlabels cell array of channel labels to select particular channels. If
%               omitted or empty, all channels are used.
%   .chanpos_lookup  lookup file for channel 3D positions. Default lookup files
%               can be found in eeglab/plugins/dipfit, either in standard_BEM or
%               standard_BESA.
%   .fs         desired sampling frequency, downsampling is carried out when the
%               original is different. If omitted, the original sampling frequency
%               is used.
%   .filters    two-column cell array of filters to apply. First column contains
%               the cutoff, and one- or two-element vector. Second column
%               contains the type with the following options: 'highpass',
%               'lowpass', 'bandpass' and 'bandstop'.
%   .ref        reference channel(s) for re-referencing, or 'rest' to use the
%               average reference and standardise it.
%   .G          lead-field matrix, must be given if ref = 'rest'.
%   .ica        perform ICA for artefact rejection. Optional algorithms: 'runica' or 'binica'.
%   .automark   automatically mark components for removal. Optional algorithms: 'mara'.
%   .save       directory to save to, '.' to save in the original folder,
%               overwriting the original file.

%   #2019.11.11 Alexander De Cock - Added ICA#
%   #Authors: Jorne Laton and Alexander De Cock#

if nargin < 2
  options = [];
end

% Load EEGLab set file
eeg = pop_loadset('filename', setpath);
eeg = eeg_checkset(eeg);

% Select channels
if isfield(options, 'chanlabels')
  eeg = pop_select(eeg, 'channel', options.chanlabels);
  eeg = eeg_checkset(eeg);
end

% Look up and assign channel positions
if isfield(options, 'chanpos_lookup')
  eeg = pop_chanedit(eeg, 'lookup', options.chanpos_lookup);
  eeg = eeg_checkset(eeg);
end

% Apply filters
if isfield(options, 'filters')
  wtype = 'hamming';
  transition_bandwidth = 0.5;
  for f = 1 : size(options.filters, 1)
    forder = pop_firwsord(wtype, eeg.srate, transition_bandwidth);
    eeg = pop_firws(eeg, 'fcutoff', options.filters{f, 1},...
      'ftype', options.filters{f, 2},...
      'wtype', wtype, 'forder', forder, 'minphase', 0);
    eeg = eeg_checkset(eeg);
  end
end

% Re-reference
if isfield(options, 'ref')
  if ~isempty(options.ref)
    ref = find(ismember({eeg.chanlocs.labels}, options.ref));
  else
    ref = [];
  end
  eeg = pop_reref(eeg, ref);
  eeg = eeg_checkset(eeg);
  if strcmp(options.ref, 'rest')
    eeg = cat_set_rest(eeg, options.G);
    eeg = eeg_checkset(eeg);
  end
end

% Resample if desired sampling rate is different from original
if isfield(options, 'fs') && options.fs ~= eeg.srate
  if options.fs > eeg.srate
    warning(['The desired sample frequency is higher than the original.\n'...
      'Are you sure you want to upsample?']);
  end
  eeg = pop_resample(eeg, options.fs);
  eeg = eeg_checkset(eeg);
end

% Perform ICA if requested
if isfield(options, 'ica')
    eeg = pop_runica(eeg,'icatype',options.ica,'extended',1,'verbose','off'); 
end

% Automatically mark ICA components to reject
if isfield(options, 'automark')

    switch options.automark
      case 'mara'
        % selected components are stored in EEG.reject.gcompreject
        [~,eeg] = processMARA([],eeg);
      otherwise
        [~,eeg] = processMARA([],eeg);
    end
end

% Save
if isfield(options, 'save')
  if ~isfolder(options.save)
    mkdir(options.save);
  end
  eeg = pop_saveset(eeg, 'filepath', options.save, 'filename', eeg.filename);
end

end