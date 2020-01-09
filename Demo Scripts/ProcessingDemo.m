raw_folder = '~/Documents/Testdata/0.Source';
conv_folder = '~/Documents/Testdata/1.Converted';
type = 'edf'; % or 'spm' or 'fif'

% Creates a pool if none yet
if isempty(gcp('nocreate'))
  parpool;
end

%% Convert from EDF to EEGlab format
cat_eeg_conv(raw_folder, conv_folder, type);

%%
load('chanlabels19.mat');
proc_folder = '~/Documents/Testdata/2.Preprocessed';
options.chanlabels = chanlabels19;
options.chanpos_lookup = 'Libraries/eeglab2019_1/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp';
options.ref = [];

cat_eeg_preprocess(conv_folder, proc_folder, options);