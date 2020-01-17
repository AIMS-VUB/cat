function cat_eeg_epoch(src_folder, dst_folder, options)
%%CAT_EEG_EPOCH EEGLab folder epocher
%
%   Creates epochs in marked valid signal parts in a set file, or around every occurrence of a
%   specific stimulus type.
%   
%   CAT_EEG_EPOCH(src_folder, dst_folder, options)
%
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
%
%   See also CAT_EEG_EPOCH_FILE.

% Last edit: 20200114 Jorne Laton - streamlined
% Authors:   Jorne Laton

cat_check('parpool');

filepaths = listfiles(src_folder, '*.set');

parfor f = 1 : length(filepaths)
  eeg = cat_eeg_epoch_file(filepaths{f}, options);
  pop_saveset(eeg, 'filepath', dst_folder, 'filename', eeg.filename);
end

end