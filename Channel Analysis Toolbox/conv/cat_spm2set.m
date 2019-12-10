function cat_spm2set( spm_dir, set_dir, pattern )
%CAT_SPM2SET Convert spm files in a directory to set files in another directory
%   
%  

if nargin < 3
  pattern = '*';
end

[spm_filepaths, spm_filenames] = listfiles(spm_dir, [pattern '.mat']);

n_file = length(spm_filepaths);

for f = 1 : n_file
  disp(['Converting ' spm_filepaths{f}])
  eeg = pop_fileio(spm_filepaths{f});
  [~, eeg.setname] = fileparts(spm_filenames{f});
  eeg = eeg_checkset(eeg);
  pop_saveset(eeg, 'filepath', set_dir, 'filename', [eeg.setname '.set']);
end

end