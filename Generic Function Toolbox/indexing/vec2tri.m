function matrix = vec2tri(vector)
%VEC2TRI transforms vector into upper triangle
%
% matrix = VEC2TRI(vector)
%
% VEC2TRI transforms a vector of an appropriate length into a symmetrical
% matrix. Use VEC2TRI2 with TRILOGI, if you need this repeatedly.
%
% See also VEC2TRI2 and TRILOGI.
%
% #2017.02.20 Jorne Laton#

[ind, n] = trilogi(vector);
matrix = zeros(n);
matrix(ind) = vector;
matrix = matrix + matrix';