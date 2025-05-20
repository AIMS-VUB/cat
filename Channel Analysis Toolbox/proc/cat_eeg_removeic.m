function log = cat_eeg_removeic(src_folder, dst_folder, options)
%CAT_EEG_REMOVEIC Remove artefactual independent components and interpolate removed bad channels
%
%   eeg = CAT_EEG_REMOVEIC(src_folder, dst_folder, options)
%
%Input
%   src_folder  folder containing the source files
%   dst_folder  folder where the new files will be stored
%   options     struct containing the following fields:
%   .automark     automatically mark components for removal. Optional values: 'mara'.
%   .marathresh   mara probability threshold for classifying components as artefacts, default 0.5.
%   .autoremove   automatically remove marked components
%   .chanlocs     output of cat_eeg_epoch, used for interpolation of removed bad channels
%   .chanlabels   labels of channels to retain

% Last edit: 20200121 Jorne Laton - created
% Authors:   Jorne Laton

cat_check('parpool');

[filepaths, filenames] = listfiles(src_folder, '*.set');
n_files = length(filepaths);
log = cell(n_files, 1);

[~, ~] = mkdir(dst_folder);

% parfor temporarily removed because the code hangs when a error dialog wants to be shown. Without
% parfor, the dialog box (about no vertical or horizontal EOG channels is shown and can be closed
% manually
% TODO resolve this error so that parfor can be used again
for f = 1 : n_files
  try
    eeg = cat_eeg_removeic_file(filepaths{f}, options);
    pop_saveset(eeg, 'filepath', dst_folder, 'filename', eeg.filename);
    log{f} = 'ok';
  catch e
    log{f} = e;
  end
end

log = [filenames, log];

end