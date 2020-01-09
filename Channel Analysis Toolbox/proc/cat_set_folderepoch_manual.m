function cat_set_folderepoch_manual(sourcedir, destdir, options)
%%CAT_SET_FOLDEREPOCH EEGLab set folder epocher
%   
%   CAT_SET_FOLDEREPOCH(sourcedir, destdir, options)
%
%   Options is a struct containing the following fields
%   Field         Value
%   eventlabel    string denoting the event in the data
%   epoch_len     number of time points per epoch, typically power of two
%   selection     indices of epochs to retain, use to remove overlapping epochs.
%                 Passing a scalar will retain 1/selection of the original
%                 amount of epochs, evenly spread.
%   reject        bool indicating whether to reject artefacts

%   #2019.04.08 Jorne Laton#

cat_check('parpool');

filepaths = listfiles(sourcedir, '*.set');

<<<<<<< Updated upstream:EEG Analysis Toolbox/preproc/eat_set_folderepoch_manual.m
parfor f = 1 : length(filepaths)
  
  % ICA components can be removed with
  % eeg = pop_subcomp(eeg); 
  
=======
for f = 1 : length(filepaths)
>>>>>>> Stashed changes:EEG Analysis Toolbox/load/preproc/eat_set_folderepoch_manual.m
  eeg = cat_set_epoch_manual(filepaths{f}, options);
  eeg = eeg_checkset(eeg);
  % Reject epochs automatically
  if isfield(options, 'reject') && options.reject
    eeg = pop_autorej(eeg, 'nogui', 'on', 'eegplot', 'off');
  end
  % Remove baseline
  if isfield(options, 'bc_interval')
    eeg = pop_rmbase(eeg, options.bc_interval);
  end
  % Select epochs
  if isfield(options, 'selection')
    selection = options.selection;
    if strcmp(selection, 'auto')
      ev = find(ismember({eeg.event.type}, options.eventcode));
      selection = (eeg.event(ev(2)).latency-eeg.event(ev(1)).latency)/eeg.srate;
      selection = ceil((options.interval(2)-options.interval(1))/selection);
    end
    if length(selection) == 1
      selection = 1 : selection : eeg.trials-selection;
    end
    eeg = pop_select(eeg, 'trial', selection);
  end
  eeg = eeg_checkset(eeg);
  pop_saveset(eeg, 'filepath', destdir, 'filename', eeg.filename);
end

end