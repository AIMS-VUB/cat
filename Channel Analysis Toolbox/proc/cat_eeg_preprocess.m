function cat_eeg_preprocess(src_folder, dst_folder, options)
%%CAT_PREPROCESS EEGLab file folder preprocessor
%   
%   options = CAT_PREPROCESS(setpath, options) preprocesses all EEGlab
%   files in a folder src_folder and save the new files in dst_folder. Preprocessing options are
%   channel selection, channel position assignment, filtering, re-referencing and resampling.
%
%   See also CAT_EEG_PREPROCESS_FILE.

% Last edit: 20191218 Jorne Laton - reorganising
% Authors:   Jorne Laton

cat_check('parpool');

if nargin < 3
  options = [];
end
options.save = dst_folder;

src_files = listfiles(src_folder, '*.set');
n_file = length(src_files);

parfor f = 1 : n_file
  cat_eeg_preprocess_file(src_files{f}, options);
end

end