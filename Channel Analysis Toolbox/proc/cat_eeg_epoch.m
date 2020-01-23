function chanlocs = cat_eeg_epoch(src_folder, dst_folder, options)
%CAT_EEG_EPOCH EEGLab folder epocher
%
%   Creates epochs in marked valid signal parts in a set file, around every occurrence of a
%   specific stimulus type or in the whole file by inserting fake events.
%   
%   CAT_EEG_EPOCH(src_folder, dst_folder, options)
%
%Input
%   src_folder  folder containing the source files
%   dst_folder  folder where the new files will be stored
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
%
%Output
%   options     only if options.car was set. This struct contains the following field:
%   chanlocs    original channels before removing bad channels. Necessary for interpolation.
%
%   See also CAT_EEG_EPOCH_FILE.

% Last edit: 20200122 Jorne Laton - added CAR and ASR
% Authors:   Jorne Laton

cat_check('parpool');

filepaths = listfiles(src_folder, '*.set');

parfor f = 1 : length(filepaths)
  eeg = cat_eeg_epoch_file(filepaths{f}, options);
  pop_saveset(eeg, 'filepath', dst_folder, 'filename', eeg.filename);
end

eeg = pop_loadset('filename', filepaths{1});
chanlocs = eeg.chanlocs;

end