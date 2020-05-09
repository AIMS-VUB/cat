function d = dijkstra_simple(adj, s)
%DIJKSTRA_SIMPLE Simple version of the Dijkstra shortest path algorithm
%
% d = SIMPLE_DIJKSTRA(adj, s)
%
% Returns the distance from a single vertex to all others without saving the path. For use with
% weighted/directed matrices.
% 
% Input
%   adj   adjacency matrix
%   s     start node
%
% Output
%   d     shortest path length from start node to all other nodes

% Last edit: 20200310 Jorne Laton - based on existing code, improved help
% Authors:   Jorne Laton

n = length(adj);
d = inf * ones(1, n); % distance s to all nodes
d(s) = 0;     % s to s distance
T = 1 : n;    % node set with shortest paths not found

while not(isempty(T))
  [~, ind] = min(d(T));
  for j= 1 : length(T)
    if adj(T(ind), T(j)) > 0 && d(T(j)) > d(T(ind)) + adj(T(ind), T(j))
      d(T(j)) = d(T(ind)) + adj(T(ind), T(j));
    end
  end
  T = setdiff(T, T(ind));
end