function cat_set_folderepoch(sourcedir, destdir, options)
%%CAT_SET_FOLDEREPOCH EEGLab set folder epocher
%   
%   CAT_SET_FOLDEREPOCH(sourcedir, destdir, options)
%
%   Options is a struct containing the following fields
%   Field         Value
%   eventcode     string denoting the event in the data
%   interval      lower and upper time limit for the epoch in seconds
%   selection     indices of epochs to retain, use to remove overlapping epochs.
%                 Passing a scalar will retain 1/selection of the original
%                 amount of epochs, evenly spread.
%                 Passing 'auto', will automatically select only non-overlapping epochs.
%   
%   reject        bool indicating whether to reject artefacts

%   #2019.03.08 Jorne Laton#

cat_check('parpool');

filepaths = listfiles(sourcedir, '*.set');

parfor f = 1 : length(filepaths)
  eeg = pop_loadset('filename', filepaths{f});
  eeg = eeg_checkset(eeg);
  
  % ICA components can be removed with
  % eeg = pop_subcomp(eeg);
  
  eeg = pop_epoch(eeg, options.eventcode, options.interval); %#ok<PFBNS>
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
    % Automatically skip overlapping epochs
    if strcmp(selection, 'auto')
      % Determine length of first epoch
      ev = find(ismember({eeg.event.type}, options.eventcode));
      selection = (eeg.event(ev(2)).latency-eeg.event(ev(1)).latency)/eeg.srate;
      % Compare with desired epoch length, to determine number of epochs to skip
      selection = ceil((options.interval(2)-options.interval(1))/selection);
    end
    % Skip every 'selection' epochs
    if length(selection) == 1
      selection = 1 : selection : eeg.trials-selection;
    end
    eeg = pop_select(eeg, 'trial', selection);
  end
  eeg = eeg_checkset(eeg);
  pop_saveset(eeg, 'filepath', destdir, 'filename', eeg.filename);
end

end