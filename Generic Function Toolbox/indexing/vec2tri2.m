function matrix = vec2tri2(vector, ind)
%VEC2TRI2 version of vec2tri to use repeatedly
%
% matrix = VEC2TRI2(vector, ind)
% 
%Input  
% vector  to be rearranged in a symmetrical matrix
% ind 	  logical matrix which indicates where vector is inserted.
% 		  Can be made using trilogi.
%
% See also VEC2TRI and TRILOGI.
% #2017.02.20 Jorne Laton#

matrix = zeros(size(ind, 1));
matrix(ind) = vector;
matrix = matrix + matrix';