function E = cat_edge_clustering(E, edge)
%CAT_EDGE_CLUSTERING Clustering coefficient of a network stored in E
%
% E = CAT_EDGE_CLUSTERING(E, edge)
%
% Input
%   E     CAT struct containing at least one edge matrix
%   edge  string denoted which edge matrix to use, equal to the name of the field in E.edges
%
% Output
%   E     CAT struct with clustering coefficient added for every subject in every band
%
% See also clustering_dir.

% Last edit: 20200310 Jorne Laton - created
% Authors:   Jorne Laton

cat_check('parpool');

if isfield(E, 'bands')
  n_band = length(E.bands.labels);
else
  n_band = 1;
end
n_subj = length(E.filenames);

C = zeros(n_subj, n_band);
M = E.edges.(edge).average;
subjects = E.filenames;

parfor s = 1 : n_subj
  disp(['Computing clustering coefficients for subject ' subjects{s}]);
  for b = 1 : n_band
    C(s, b) = clustering_dir(M(:, :, b, s));
  end
end

E.edges.(edge).clustering = C;