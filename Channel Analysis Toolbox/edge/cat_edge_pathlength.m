function E = cat_edge_pathlength(E, edge)
%CAT_EDGE_PATHLENGTH Average shortest path length of a network stored in E
%
% E = CAT_EDGE_PATHLENGTH(E, edge)
%
% Input
%   E     CAT struct containing at least one edge matrix
%   edge  string denoted which edge matrix to use, equal to the name of the field in E.edges
%
% Output
%   E     CAT struct with path length added for every subject in every band
%
% See also PATHLENGTH_AV.

% Last edit: 20200310 Jorne Laton - created
% Authors:   Jorne Laton

cat_check('parpool');

if isfield(E, 'bands')
  n_band = length(E.bands.labels);
else
  n_band = 1;
end
n_subj = length(E.filenames);

P = zeros(n_subj, n_band);
M = E.edges.(edge).average;
subjects = E.filenames;

parfor s = 1 : n_subj
  disp(['Computing pathlength for subject ' subjects{s}]);
  for b = 1 : n_band
    P(s, b) = pathlength_av(M(:, :, b, s));
  end
end

E.edges.(edge).pathlength = P;