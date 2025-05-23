function cat_eeg_convert(src_folder, dst_folder, type, filename_pattern)
%CAT_EEG_CONVERT Convert files in a directory to EEGlab files in another directory
%   
%   CAT_EEG_CONVERT(src_folder, dst_folder, type)
%   CAT_EEG_CONVERT(src_folder, dst_folder, type, filename_pattern)
%
% Input
%   src_folder        folder containing the original files to be converted
%   dst_folder        folder to save the new files in
%   type              extension of the original files.
%                       Options: 'edf', 'spm' and 'fif'.
%   filename_pattern  (optional) regex to select specific files.
%                       Examples: '*' = all files (default)
%                                 'P*' = all files starting with P
%
%   See also POP_BIOSIG.

cat_check('parpool');

if nargin < 4
  filename_pattern = '*';
end

switch type
  case 'edf'
    conv2set = @pop_biosig;
  case 'spm'
    type = 'mat';
    conv2set = @pop_fileio;
  case 'fif'
    conv2set = @pop_fileio;
  otherwise
    error('Unknown filetype. Supported options are ''edf'', ''spm'' and ''fif''.');
end

src_files = listfiles(src_folder, [filename_pattern '.' type]);

n_file = length(src_files);

[~, ~] = mkdir(dst_folder); % makes a folder if it doesn't exist. The ~s prevent warnings.

parfor f = 1 : n_file
  disp(['Converting ' src_files{f}])
  eeg = conv2set(src_files{f});
  [~, eeg.setname, ext] = fileparts(src_files{f});
  eeg = eeg_checkset(eeg);
  pop_saveset(eeg, 'filepath', dst_folder, 'filename', [eeg.setname ext]);
end