%% Folder path setup
cat_folder = 'D:\AD-EP-HS v2\CAT\';
filepaths = listfiles(cat_folder, '*.mat');

%% Load CAT structs
LHS = cat_load(filepaths{1});
RHS = cat_load(filepaths{2});

%% Calculate spectrum
options = [];
options.resolution = 4; % increase spectral resolution (4 times finer) by interpolation
LHS = cat_spect(LHS, options);
RHS = cat_spect(RHS, options);

%% Plot average spectrum
plotoptions = [];
plotoptions.interval = [0, 30];
figure, cat_plot_spect(LHS, plotoptions);
figure, cat_plot_spect(RHS, plotoptions);

%% Plot individual spectra
figure
for s = 1 : length(LHS.filenames)
  plotoptions.subject = s;
  clf
  cat_plot_spect(LHS, plotoptions);
  pause
end
for s = 1 : length(RHS.filenames)
  plotoptions.subject = s;
  clf
  cat_plot_spect(RHS, plotoptions);
  pause
end