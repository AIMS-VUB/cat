function E = cat_set_loadfolder(setfolder, options)
%%CAT_SET_LOADFOLDER EEGLab set folder epoch extractor
%   
%   E = CAT_SET_LOADFOLDER(setfolder, options)
%
%   setfolder   folder containing epoched set files
%   options     struct containing optional parameters
%   .eegtype    string switch, possible values:
%               'continuous' there are no epochs in the files, these will be cut
%                 out from valid parts marked with .eventlabel
%               'epoched' there are already epochs in the files, these are
%               simply copied from the file
%   .chanlabels channels to be selected. This is a cell array of labels. If
%               omitted or empty, all channels will be used.
%   .eventlabel label marking the EEG parts to be kept for epoching. Used only
%               with .eegtype = 'continuous'
%   .epoch_len  length of the epochs that will be cut out. Used only with
%               .eegtype = 'continuous' 
%   .n_epochs   number of epochs to extract.
%               If omitted, lowest possible number over all files.
%               Choose 'all' to retain all epochs for each file, this
%               generates a cell array of 3D matrices in the field epochs.
%   .bands      substruct with fields labels and intervals. Not necessary at
%               this stage. Will be used for adjacency measures, and can still
%               be passed as an argument at that time.
%               Example:
%               options.bands.labels = {'alpha', 'beta'};
%               options.bands.intervals = [8 12; 12 30];
%   .robust     set to perform robust averaging of the epochs. Otherwise regular
%               averaging.

%   #2019.03.08 Jorne Laton#

cat_check('parpool');

if nargin < 2
  options = [];
end

E = [];

if isfield(options, 'bands') 
  if isfield(options.bands, 'labels') && isfield(options.bands, 'intervals')
    E.bands = options.bands;
  else
    warning(['Field ''bands'' in options does not contain the necessary fields'...
      '''labels'' and ''intervals''. These can still be set at a later stage.']);
    E.bands.labels = [];
    E.bands.intervals = [];
  end
end

if ~isfield(options, 'robust')
  options.robust = false;
end

if strcmp(options.eegtype, 'continuous')
  loadfile = @cat_set_loadfile_continuous;
  leastepochs = @cat_set_leastepochs_continuous;
else
  if strcmp(options.eegtype, 'epoched')
    loadfile = @cat_set_loadfile_epoched;
    leastepochs = @cat_set_leastepochs_epoched;
  else
    error('The field eegtype should either be ''continuous'' or ''epoched''');
  end
end

[filepaths, E.filenames] = listfiles(setfolder, '*.set');
n_files = length(E.filenames);

% If not in options, find minimum number of epochs over all files
if ~isfield(options, 'n_epochs')
  options.n_epochs = leastepochs(setfolder, options);
end

% Get common fields and data dimensions from first file
[eeg, E.fs, chanlabels, chanpositions] = cat_set_loadfile(filepaths{1}, options);
if ~isfield(options, 'epoch_len')
    options.epoch_len = eeg.pnts;
end

% Get epochs
if strcmp(options.n_epochs, 'all')
  options = rmfield(options, 'n_epochs');
  epochs = cell(n_files, 1);
  parfor f = 1 : n_files
    temp = loadfile(filepaths{f, 1}, options);
    epochs{f} = zeros(size(temp));
    epochs{f}(:, :, :) = temp;
    epochs{f} = permute(epochs{f}, [2 1 3]);
  end
else
  epochs = zeros(length(chanlabels), options.epoch_len, options.n_epochs, n_files);
  parfor f = 1 : n_files
      temp = loadfile(filepaths{f}, options);
      epochs(:, :, :, f) = temp;
  end
  epochs = permute(epochs, [2 1 3 4]);
end

E.timeseries.epochs = epochs;
E.timeseries.changed = true;
E.timeseries.times = eeg.times';
% E = cat_time_average(E, options.robust);
E.channels.labels = chanlabels;
E.channels.positions = chanpositions;

end