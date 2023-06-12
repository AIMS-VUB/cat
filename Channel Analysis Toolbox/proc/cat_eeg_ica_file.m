function eeg = cat_eeg_ica_file(eeg, options)
%CAT_EEG_ICA_FILE ICA for artefact rejection
%
%   eeg = CAT_EEG_ICA_FILE(src_file, options)
%
%Input
%   src_file    full file name of the set file
%   options     struct containing the following fields:
%   Field       Value
%   ica         ICA implementation to use
%               'runica': MATLAB, slow (default)
%               'binica': MEX, quick but requires extra effort on Windows

% Last edit: 20200121 Jorne Laton - created
% Authors:   Jorne Laton

if ~isfield(options, 'ica')
  options.ica = 'runica';
end

if (ischar(eeg))
    eeg = pop_loadset('filename', eeg);
end
eeg = eeg_checkset(eeg);

eeg = pop_runica(eeg, 'icatype', options.ica, 'extended', 1, 'verbose', 'off');
eeg = eeg_checkset(eeg);

end