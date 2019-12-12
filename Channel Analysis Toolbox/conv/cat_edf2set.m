function cat_edf2set(edf_dir, set_dir, edf_pattern)

edf_files = listfiles(edf_dir, [edf_pattern '.edf']);

n_file = length(edf_files);

for f = 1 : n_file
  disp(['Converting ' edf_files{f}])
  eeg = pop_biosig(edf_files{f});
  [~, setname, ext] = fileparts(edf_files{f});
  eeg.setname = setname;
  eeg = eeg_checkset(eeg);
  pop_saveset(eeg, 'filepath', set_dir, 'filename', [setname ext]);
end