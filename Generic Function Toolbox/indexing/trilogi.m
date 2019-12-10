function [ind, n] = trilogi(vector)
%TRILOGI generates an upper triangle index for vector
%
% ind = TRILOGI(vector)
% [ind, n] = TRILOGI(vector)
%
% This function generates the upper triangle indices in a square matrix,
% fitting all elements of vector. For use with vec2tri2.
%
%Output
% ind	square matrix of logical indices
% n		size of the matrix
%
%See also: VEC2TRI2.
%
%#2017.02.20 Jorne Laton#

n = (1+sqrt(1+8*length(vector)))/2;
ind = logical(tril(ones(n), -1));