%% Folder path setup
% Change according to your situation
root_folder = 'D:\AD-EP-HS v2\SET\';
raw_folder = 'D:\AD-EP-HS v2\EDF\Modified\UHS';
conv_folder = fullfile(root_folder, '1.Converted');
proc_folder = fullfile(root_folder, '2.Preprocessed');
epoch_folder = fullfile(root_folder, '3.Epochs');
ica_folder = fullfile(root_folder, '4.ICA');
ready_folder = fullfile(root_folder, '5.Ready');
cat_folder = 'D:\AD-EP-HS v2\CAT\';
type = 'edf'; % or 'spm' or 'fif'

%% Creates a parallel pool if none yet
% This will increase the processing speed by roughly the number of physical cores in your machine.
% For this, you need the Parallel Toolbox of Matlab installed
if isempty(gcp('nocreate'))
  parpool;
end

%% Convert from EDF to EEGlab format
% This will convert the raw files into EEGlab format and store them in another folder, conv_folder.
cat_eeg_convert(raw_folder, conv_folder, type);
cat_eeg_importevents(conv_folder);

%% Pre-processing
% Channels to retain, we assume the default 19-channel setup. Other channels are removed.
load('chanlabels19.mat');
options.chanlabels = chanlabels19;

% Look up the default 3D locations of the electrodes on the scalp for visualisation
% Change the path below according to where your EEGlab folder is located
options.chanpos_lookup = 'Libraries/eeglab2019_1/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp';

% Filter to remove the DC component, more filters can be added by adding rows to the cell array.
options.filters = {0.5, 'highpass'};
% Filter specifications can be set with the extra options below, uncomment only if you need to
% change these
% options.filter_transition_bandwidth = 0.5; % (default)
% options.filter_windowtype = 'hamming'; % (default)

% Re-reference to average
options.ref = [];

% Resample
options.fs = 250; % resampling rate, do not include this field if you don't want resampling

% Do it
cat_eeg_preprocess(conv_folder, proc_folder, options);

%% Epoching
options = [];
options.car = true; % continuous artefact rejection, correct where possible with artefact subspace reconstruction
options.markertype = 'segment'; % in this example, we are using resting-state EEG with no markers
options.eventcode = {'EyesClosed'}; % we will mark the epochs 'EyesClosed'
options.interval = 4.096; % the length of the epochs

chanlocs = cat_eeg_epoch(proc_folder, epoch_folder, options);

%% ICA for Artefact rejection
options = [];
options.ica = 'binica';
% Calculate components and save the resulting files. Separate step, because computationally heavy
log = cat_eeg_ica(epoch_folder, ica_folder, options); 

%% Select artefactual components and remove them, interpolate removed bad channels
if ~exist('chanlocs', 'var')
  load('chanlocs19.mat');
end
options = [];
options.automark = 'mara'; % use mara for automatic component classification
options.marathresh = 0.9; % only remove components with a higher probability than this
options.autoremove = true; % do not only mark components for removal, remove them at the same time
options.chanlocs = chanlocs; % channels before removal of bad channels, for interpolation of these

cat_eeg_removeic(ica_folder, ready_folder, options);

%% Load all files per group into CAT struct
LHS = cat_eeg_loadfolder(ready_folder, struct('n_epochs', 'all', 'pattern', 'L*'));
RHS = cat_eeg_loadfolder(ready_folder, struct('n_epochs', 'all', 'pattern', 'R*'));
LHS.paradigm = 'Rest'; % Add this manually to the struct, will be used for saving and plotting
RHS.paradigm = 'Rest';

%% Save it all
cat_save(LHS, cat_folder);
cat_save(RHS, cat_folder);