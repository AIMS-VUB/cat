function E = cat_meg_loadfolder(src_folder, options)
%%CAT_MEG_LOADFOLDER SPM folder epoch extractor
%   
%   E = CAT_MEG_LOADFOLDER(src_folder, options)
%
%   src_folder    folder containing epoched spm (.mat) files
%   options       struct containing optional parameters
%   .pattern      regex pattern to select files in the source folder
%   .n_epochs     number of epochs to extract.
%                 If omitted, lowest possible number over all files.
%                 Choose 'all' to retain all epochs for each file, this
%                 generates a cell array of 3D matrices in the field epochs.
%   .eventlabel   label of epochs to retain
%   .chantype     type of channels to retain
%   .chanind      indices of channels to retain

%   .robust       set to perform robust averaging of the epochs. Otherwise regular
%                 averaging.

% Last edit: 20200310 Jorne Laton - created as mirrored function of cat_eeg_loadfolder
% Authors:   Jorne Laton

cat_check('parpool');

if nargin < 2
  options = [];
end

if ~isfield(options, 'pattern')
  options.pattern = '*';
end

[filepaths, filenames] = listfiles(src_folder, [options.pattern '.mat']);
n_files = length(filenames);

% If not in options, find minimum number of epochs over all files
if ~isfield(options, 'n_epochs') 
  options.n_epochs = cat_meg_leastepochs(filepaths, filenames);
end

% Get common fields and data dimensions from first file
E = cat_meg_loadmeta(filepaths{1}, options);
E.filenames = filenames;

% Get epochs
if strcmp(options.n_epochs, 'all')
  options = rmfield(options, 'n_epochs');
  epochs = cell(n_files, 1);
  parfor f = 1 : n_files
    temp = cat_meg_loaddata(filepaths{f}, options);
    epochs{f} = temp;
    epochs{f} = permute(epochs{f}, [2 1 3]);
  end
else
  temp = cat_meg_loaddata(filepaths{1}, options);
  epochs = zeros([size(temp) n_files]);
  epochs(:, :, :, 1) = temp;
  parfor f = 2 : n_files
      temp = cat_meg_loaddata(filepaths{f}, options);
      epochs(:, :, :, f) = temp;
  end
  epochs = permute(epochs, [2 1 3 4]);
end

E.timeseries.epochs = epochs;
E.timeseries.changed = true;

end