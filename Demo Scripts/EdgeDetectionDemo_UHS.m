%% Folder path setup
cat_folder = 'D:\AD-EP-HS v2\CAT\';
filepaths = listfiles(cat_folder, '*.mat');

%% Load CAT structs
LHS = cat_load(filepaths{1}, 1);
RHS = cat_load(filepaths{2}, 1);

%%
bands.labels = {'delta', 'theta', 'alpha', 'lowbeta', 'highbeta'};
bands.intervals = [1 4; 4 8; 8 12; 12 20; 20 30];
LHS = cat_edge_coherence(LHS, bands);
RHS = cat_edge_coherence(RHS, bands);

%%
LHS = cat_edge_dtf(LHS);
RHS = cat_edge_dtf(RHS);

%% Save struct with edges added
cat_save(LHS); % Overwrite previously saved
cat_save(RHS);