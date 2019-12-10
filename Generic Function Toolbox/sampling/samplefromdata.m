function samples = samplefromdata(data, N)
% SAMPLEFROMDATA samples variables from given data
%
%	samples = SAMPLEFROMDATA(data, N)
%
%	data is the original data to sample from
%	N is the number of samples to draw, or a vector of such numbers
%
%	samples is a cell array containing vectors of samples drawn
%
%	See also: SAMPLE.
%
%	#Jorne Laton#
%	#v2017.10.12#

[r, c] = size(data);
N_length = length(N);
samples = cell(N_length, 1);

for i = 1:N_length
    n = N(i);
    I = sample(r, c, n);
    samples{i} = data(I);
end