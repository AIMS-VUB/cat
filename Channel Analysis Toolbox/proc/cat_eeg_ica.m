function log = cat_eeg_ica(src_folder, dst_folder, options)
%CAT_EEG_ICA ICA for artefact rejection
%
%   eeg = CAT_EEG_ICA(src_folder, dst_folder, options)
%
%Input
%   src_folder  folder containing the source files
%   dst_folder  folder where the new files will be stored
%   options     struct containing the following fields:
%   Field       Value
%   ica         ICA implementation to use
%               'runica': MATLAB, slow (default)
%               'binica': binary, quick but requires extra effort on
%               Windows: https://sccn.ucsd.edu/wiki/Binica

% Last edit: 20200121 Jorne Laton - created
% Authors:   Jorne Laton

cat_check('parpool');

[filepaths, filenames] = listfiles(src_folder, '*.set');
n_files = length(filepaths);
log = cell(n_files, 1);

[~, ~] = mkdir(dst_folder);

parfor f = 1 : n_files
  try
    eeg = cat_eeg_ica_file(filepaths{f}, options);
    pop_saveset(eeg, 'filepath', dst_folder, 'filename', eeg.filename);
    log{f} = 'ok';
  catch e
    log{f} = e;
  end
end

log = [filenames, log];
comp = computer;
if strcmp(comp(1:2), 'PC')
  dos('del binica*');
  dos('del bias_after_adjust');
else
  unix('rm binica*');
  unix('rm bias_after_adjust');
end

end