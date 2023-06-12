function eeg = cat_eeg_preprocess_file(eeg, options)
%%CAT_EEG_PREPROCESS_FILE Pre-processing for a single EEGlab file
%   
%   CAT_EEG_PREPROCESS_FILE(src_file, options) preprocesses all EEGlab
%   files in a folder src_folder and saves the new files in dst_folder. Preprocessing options are
%   channel selection, channel position assignment, filtering, re-referencing and resampling.
%
%   Field         Value
%   .chanlabels   cell array of channel labels to select particular channels. If
%                 omitted or empty, all channels are used.
%   .chanpos_lookup  lookup file for channel 3D positions. Default lookup files
%                 can be found in eeglab/plugins/dipfit, either in standard_BEM or
%                 standard_BESA.
%   .fs           desired sampling frequency, downsampling is carried out when the
%                 original is different. If omitted, the original sampling frequency
%                 is used.
%   .filters      two-column cell array of filters to apply. First column contains
%                 the cutoff, a one- or two-element vector. Second column
%                 contains the type with the following options: 'highpass',
%                 'lowpass', 'bandpass' and 'bandstop'.
%   .filter_transition_bandwidth  transition bandwidth of the filter(s), default 0.5.
%   .filter_windowtype    window for filtering, default hamming.
%   .ref          cell array of reference channel(s) for re-referencing, leave empty for average
%                 reference or 'res' to use the average reference and standardise it.
%   .G            lead-field matrix, must be given if ref = 'res'.
%   .ref_exclude  cell array of channel labels to be excluded from the average reference
%   .save         directory to save to, '.' to save in the original folder,
%                 overwriting the original file.

% Last edit: 20191218 Jorne Laton
% Authors:   Jorne Laton and Alexander De Cock

if nargin < 2
  options = [];
end

% Load EEGLab set file
if (ischar(eeg))
    eeg = pop_loadset('filename', eeg);
end
eeg = eeg_checkset(eeg);

% Select channels
if isfield(options, 'chanlabels')
  eeg = pop_select(eeg, 'channel', options.chanlabels);
  eeg = eeg_checkset(eeg);
end

% Rename selected channels
if isfield(options, 'newlabels')
  for i = 1 : length(options.newlabels)
    eeg.chanlocs(i).labels = options.newlabels{i};
  end    
  eeg = eeg_checkset(eeg);
end


% Look up and assign channel positions
if isfield(options, 'chanpos_lookup')
  eeg = pop_chanedit(eeg, 'lookup', options.chanpos_lookup);
  eeg = eeg_checkset(eeg);
end

% Apply filters
if isfield(options, 'filters')
  if ~isfield(options, 'filter_transition_bandwidth')
    options.filter_transition_bandwidth = 0.5;
  end
  if ~isfield(options, 'filter_windowtype')
    options.filter_windowtype = 'hamming';
  end
  for f = 1 : size(options.filters, 1)
    forder = pop_firwsord(options.filter_windowtype, eeg.srate, options.filter_transition_bandwidth);
    eeg = pop_firws(eeg, 'fcutoff', options.filters{f, 1},...
      'ftype', options.filters{f, 2},...
      'wtype', options.filter_windowtype, 'forder', forder, 'minphase', 0);
    eeg = eeg_checkset(eeg);
  end
end

% Re-reference
if isfield(options, 'ref')
  if ~isempty(options.ref) && ~strcmp(options.ref, 'res')
    ref = find(ismember({eeg.chanlocs.labels}, options.ref));
  else
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

% Resample if desired sampling rate is different from original
if isfield(options, 'fs') && options.fs ~= eeg.srate
  if options.fs > eeg.srate
    warning(['The desired sample frequency is higher than the original.\n'...
      'Are you sure you want to upsample?']);
  end
  eeg = pop_resample(eeg, options.fs);
  eeg = eeg_checkset(eeg);
end

% Save
if isfield(options, 'save')
  if ~isfolder(options.save)
    mkdir(options.save);
  end
  eeg = pop_saveset(eeg, 'filepath', options.save, 'filename', eeg.filename);
end

end