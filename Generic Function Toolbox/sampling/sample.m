function I = sample(r, c, n)
%SAMPLE generates linear index to sample from data
%
% I = SAMPLE(r, c, n)
%
%Input
% r, c are the number of rows and columns in your original data
% n is the number of random samples you want to draw from these data
%
%Output
% I is an index matrix that can be used to select these samples from the data
%
% See also: SAMPLEFROMDATA.

% #2017.10.12 Jorne Laton#
	
I = 0:r:r*(c - 1);
I = repmat(I, n, 1);
I = I + randi(r, n, c);