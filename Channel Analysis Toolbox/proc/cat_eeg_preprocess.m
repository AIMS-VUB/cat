function log = cat_eeg_preprocess(src_folder, dst_folder, options)
%%CAT_EEG_PREPROCESS Pre-processing for folders containing EEGlab files
%   
%   CAT_EEG_PREPROCESS(src_folder, dst_folder, options) preprocesses all EEGlab
%   files in a folder src_folder and saves the new files in dst_folder. Preprocessing options are
%   channel selection, channel position assignment, filtering, re-referencing and resampling. Any
%   selected steps will be done in this order.
%
% Input
%   src_folder    folder containing the files to be pre-processed
%   dst_folder    folder where the pre-processed files will be saved
%   options       struct with possible fields listed below
%   Field         Value
%   .chanlabels   cell array of channel labels to select particular channels. If
%                 omitted or empty, all channels are used.
%   .newlabels    cell array of new channel labels, in the same order as
%                 the selection
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
%
%   See also CAT_EEG_PREPROCESS_FILE.

% Last edit: 20230123 Jorne Laton - add new labels options
% Authors:   Jorne Laton

cat_check('parpool');

if nargin < 3
  options = [];
end
options.save = dst_folder;

[filepaths, filenames] = listfiles(src_folder, '*.set');
n_files = length(filepaths);
log = cell(n_files, 1);

[~, ~] = mkdir(dst_folder); % makes a folder if it doesn't exist. The ~s prevent warnings.

parfor f = 1 : n_files
  try
    cat_eeg_preprocess_file(filepaths{f}, options);
    log{f} = 'ok';
  catch e
    log{f} = e;
  end
end

log = [filenames, log];

end