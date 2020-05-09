function l = pathlength_av(adj)
%PATHLENGTH_AV Average shortest path length for a network
%
% l = PATHLENGTH_AV(adj)
%
% Returns the average shortest path from all nodes to all other nodes in directed/undirected
% networks.
%
% Input
%   adj   matrix of weights/distances between nodes
%
% Output
%   l     average path length: the average of the shortest paths between every two edges

% Last edit: 20200310 Jorne Laton - based on existing code, optimised code and help
% Authors:   Jorne Laton

n = size(adj, 1);

dij = zeros(n);

parfor i = 1 : n
  dij(i, :) = dijkstra_simple(adj, i);
end

l = sum(sum(dij)) / (n^2 - n); % sum and average across everything but the diagonal
