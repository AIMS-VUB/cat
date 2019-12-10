function M = cat_edge_selectconnections(E, edgetype, connectionlist, options)
%CAT_EDGE_SELECTCONNECTIONS Select specific connections for one edge type
%
%   M = CAT_EDGE_SELECTCONNECTIONS(E, edgetype, connectionlist, options)
%
%

%   #2018.11.27 Jorne Laton#

% Prepare options.band if options given and options.band is a string
if nargin < 4
  options = [];
end
if ~isfield(options, 'band')
  options.band = 1;
else
  if ischar(options.band)
    options.band = find(ismember(E.bands.labels, options.band));
  end
end

M.band = E.bands.labels{options.band};
M.edgetype = edgetype;
M.connections = E.channels.labels;
M.epochs = E.edges.(edgetype).epochs;
M.average = E.edges.(edgetype).average;
switch edgetype
  case 'mutualinfo'
    % Average over delays
    se = size(M.epochs);
    sa = size(M.average);
    M.epochs = mean(M.epochs(:, :, :, :, :, options.band), 3);
    M.epochs = reshape(M.epochs, [se([1:2 4:end]), 3]); % Robust squeeze
    M.average = mean(M.average(:, :, :, :, options.band), 3);
    M.average = reshape(M.average, [sa([1:2 4:end]), 3]); % Robust squeeze
  otherwise
    M.epochs = M.epochs(:, :, :, :, options.band);
    M.average = M.average(:, :, :, options.band);
end

% Select connections if connectionlist is given
if nargin > 2 && ~isempty(connectionlist)
  if iscell(connectionlist)
    [~, chan1] = ismember(connectionlist(:, 1), E.channels.labels);
    [~, chan2] = ismember(connectionlist(:, 2), E.channels.labels);
  else
    chan1 = connectionlist(:, 1);
    chan2 = connectionlist(:, 2);
  end
  n_conn = length(chan1);
  C = zeros(n_conn, size(M.epochs, 3), size(M.epochs, 4));
  A = zeros(n_conn, size(M.average, 3));
  for c = 1 : n_conn
    C(c, :, :) = M.epochs(chan1(c), chan2(c), :, :);
    A(c, :) = M.average(chan1(c), chan2(c), :);
  end
  M.epochs = C;
  M.average = A;
  M.connections = connectionlist;
end