function cat_set_folderpreprocess(sourcedir, destdir, options)
%%CAT_SET_FOLDERPREPROCESS EEGLab set file folder preprocessor
%   
%   options = CAT_SET_FOLDERPREPROCESS(setpath, options) preprocesses all existing set
%   files in a folder setdir. Preprocessing options are channel selection,
%   downsampling, filtering and re-referencing.
%
%   Field       Value
%   .channels   array of indices to select particular channels. If omitted or
%               empty, all channels are used.
%   .fs         desired sampling frequency, downsampling is carried out when the
%               original is different. If omitted, the original sampling frequency
%               is used.
%   .filters    two-column cell array of filters to apply. First column contains
%               the cutoff, and one- or two-element vector. Second column
%               contains the type with the following options: 'highpass',
%               'lowpass', 'bandpass' and 'bandstop'.
%   .ref        reference channels for re-referencing
%   .save       directory to save to, '.' to save in the original folder,
%               overwriting the original files
%
%   See also CAT_SET_PREPROCESS.

%   #2018.03.09 Jorne Laton#

if nargin < 3
  options = [];
end
options.save = destdir;

setfiles = listfiles(sourcedir, '*.set');
n_file = length(setfiles);

parfor f = 1 : n_file
  cat_set_preprocess(setfiles{f}, options);
end

end