%%
filepath = '/home/gnagels/M300/OAT/M300_OAT_20200411c.oat/session1_trlwise.mat';
load(filepath)

%%
spm('eeg', 'defaults')

%%
D = spm_eeg_load(trlwise.rawdat);

%%
orig_cond = conditions(D);
cond = orig_cond(trlwise.triallist);

distractor = strcmp(cond, 'Distractor');

%%
epochs = trlwise.dat(:, distractor, :);
epochs = permute(epochs, [3, 1, 2]);

%% Construct struct
E.timeseries.epochs = {epochs};
E.channels.labels = trlwise.labels; % Nog om te zetten naar zinvolle namen
E.filenames = {filepath};
E.group = 'Group A';
E.paradigm = 'M300';
E.event = 'Distractor';
E.timeseries.times = trlwise.times;
E.fs = trlwise.fsample;
E.timeseries.changed = true;

%%
folder = uigetdir;
cat_save(E, folder);

%%
file = filedialog('o', '*.mat');
E = cat_load(file);

%% Calculate spectrum
options = [];
options.resolution = 16; % increase spectral resolution (16 times finer) by interpolation
E = cat_spect(E, options);

%% Plot individual spectra group A and B
figure('Position', [50 50 1050 1050])
plotoptions = [];
plotoptions.interval = [0, 50];
plotoptions.subject = 1;
plotoptions.chanindices = 1:10;
plotoptions.save = '/home/jlaton/Documents/M300 Guy/Figuren/';
clf
cat_plot_spect(E, plotoptions);

%% Do the DTF
bands.labels = {'delta', 'theta', 'alpha', 'lowbeta', 'highbeta'};
bands.intervals = [1 4; 4 8; 8 12; 12 20; 20 30];
options.order = 6;
options.windowlength = length(E.timeseries.times);
options.baseline = 0;
options.alignment = 'epoch';

E = cat_edge_dtf(E, bands, options);

%%
E = cat_edge_coherence(E, bands, options);

%% Plot average connectivity
options = [];
options.plottype = 'matrix';
% options.scale = [0, ];
% options.edge_threshold = 0.2;
options.colormap = whitejet;
options.colormap = options.colormap(ceil(end/2):end, :);
% options.save = 'Figuren/Epilepsie';
% options.savetype = 'png';

%% Plot for all bands
figure('Position', [50 50 1050 1050])
for b = 1 : length(E.bands.labels)
  options.band = b;
  clf
  cat_plot_edges(E, 'dtf', options)
  pause
end

%% Plot for all bands
figure('Position', [50 50 1050 1050])
for b = 1 : length(E.bands.labels)
  options.band = b;
  clf
  cat_plot_edges(E, 'coherence', options)
  pause
end









