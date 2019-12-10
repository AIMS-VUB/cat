function I = findcell(X, K)
%FINDCELL Find for cell arrays
%   Works like Matlab's find for matrices.
%
%	X is a cell array which is to be searched
%	K is a string or a cell array of strings which are to be found in X
%
%   See also FIND and ISMEMBER.

I = find(ismember(X, K));