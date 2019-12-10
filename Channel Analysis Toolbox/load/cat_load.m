function E = cat_load(filepath, lightmode)
%CAT_LOAD loads a CAT object
%
%   It expects the CAT object has been saved as follows:
%   folder/paradigm_event_groupname.mat
%   and the original time signals in individual files in
%   folder/data/paradigm_event_groupname*.mat
%
%   If filepath is omitted, a selection dialog will pop up.
%
%   See also: CAT_SAVE.

cat_check('parfor')

if nargin < 2
  lightmode = false;
end
if nargin < 1 || isempty(filepath)
  filepath = filedialog('o', '*.mat', 'Select a CAT struct file');
end

[folder, filename] = fileparts(filepath);

S = load(filepath);
E = S.E;
E.timeseries.changed = false;

% Load time series from individual files if not in lightmode
if nargin < 2 || ~lightmode
  datafiles = listfiles(fullfile(folder, 'data'), [filename '*.mat']);
  n_files = length(datafiles);
  
  timeseries_epochs = cell(n_files, 1);
  
  parfor f = 1 : n_files
    S = load(datafiles{f});
    timeseries_epochs{f} = S.data;
  end
  
  E.timeseries.epochs = timeseries_epochs;
end