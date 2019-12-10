function [Xpeaks, Ypeaks, F] = multifindpeak(X, Y, options)
%MULTIFINDPEAK - Peak search along first dimension of multidimensional matrix
%   
%   Finds the largest peak in a given interval.
%
%   [Xpeaks, Ypeaks, forced] = MULTIFINDPEAK(X, Y, options)
%
%   X is a 1D vector
%   Y is a 1, 2 or 3D structure in which the first dimension is to be searched
%     for peaks in the optional interval
%
%   See also FINDPEAK.
%
%   # Jorne Laton #
%   # v2018.07.23 #

if nargin < 3
  options = [];
end

X = X(:); % columnise X
[~, n_columns, n_slices] = size(Y);
Xpeaks = zeros(n_slices, n_columns);
Ypeaks = Xpeaks;
F = Xpeaks;

for s = 1 : n_slices
  for c = 1 : n_columns
    [Xpeaks(s, c), Ypeaks(s, c), F(s, c)] = findpeak(X, Y(:, c, s), options);
  end
end