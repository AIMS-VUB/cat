function cat_eeg_removeic(src_folder, dst_folder, options)
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

filepaths = listfiles(src_folder, '*.set');

parfor f = 1 : length(filepaths)
  eeg = cat_eeg_removeic_file(filepaths{f}, options);
  pop_saveset(eeg, 'filepath', dst_folder, 'filename', eeg.filename);
end

end