%% Folder path setup
% Change according to your situation
raw_folder = '~/Documents/Testdata/0.Source';
conv_folder = '~/Documents/Testdata/1.Converted';
proc_folder = '~/Documents/Testdata/2.Preprocessed';
epoch_folder = '~/Documents/Testdata/3.Epochs';
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
options.type = 'full'; % in this example, we are using resting-state EEG with no markers
options.margin = 10;
options.eventcode = 'EyesClosed'; % we will mark the epochs 'EyesClosed'
options.interval = 4.096; % the length of the epochs

cat_eeg_epoch(proc_folder, epoch_folder, options);