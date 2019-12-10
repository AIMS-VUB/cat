function cat_fif2set(fif_filepath, set_dir, set_filename)

disp(['Converting ' fif_filepath])
eeg = pop_fileio(fif_filepath);
eeg.setname = set_filename;
eeg = eeg_checkset(eeg);
pop_saveset(eeg, 'filepath', set_dir, 'filename', [eeg.setname '.set']);
