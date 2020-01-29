function E = cat_eeg_loadfolder(src_folder, options)
%%CAT_EEG_LOADFOLDER EEGLab set folder epoch extractor
%   
%   E = CAT_EEG_LOADFOLDER(src_folder, options)
%
%   setfolder   folder containing epoched set files
%   options     struct containing optional parameters
%   .n_epochs   number of epochs to extract.
%               If omitted, lowest possible number over all files.
%               Choose 'all' to retain all epochs for each file, this
%               generates a cell array of 3D matrices in the field epochs.

%   .robust     set to perform robust averaging of the epochs. Otherwise regular
%               averaging.

% Last edit: 20200129 Jorne Laton - streamlined with changes to processing code
% Authors:   Jorne Laton

cat_check('parpool');

if nargin < 2
  options = [];
end

if ~isfield(options, 'pattern')
  options.pattern = '*';
end

[filepaths, filenames] = listfiles(src_folder, [options.pattern '.set']);
n_files = length(filenames);

% If not in options, find minimum number of epochs over all files
if ~isfield(options, 'n_epochs')
  options.n_epochs = cat_eeg_leastepochs(filepaths, E.filenames);
end

% Get common fields and data dimensions from first file
E = cat_eeg_loadmeta(filepaths{1});
E.filenames = filenames;

% Get epochs
if strcmp(options.n_epochs, 'all')
  options = rmfield(options, 'n_epochs');
  epochs = cell(n_files, 1);
  parfor f = 1 : n_files
    temp = cat_eeg_loaddata(filepaths{f}, options);
%     epochs{f} = zeros(size(temp));
    epochs{f} = temp;
    epochs{f} = permute(epochs{f}, [2 1 3]);
  end
else
  temp = cat_eeg_loaddata(filepaths{1}, options);
  epochs = zeros(length(E.channels.labels), temp.pts, options.n_epochs, n_files);
  epochs(:, :, :, 1) = temp.data;
  parfor f = 2 : n_files
      temp = cat_eeg_loaddata(filepaths{f}, options);
      epochs(:, :, :, f) = temp;
  end
  epochs = permute(epochs, [2 1 3 4]);
end

E.timeseries.epochs = epochs;
E.timeseries.changed = true;

end