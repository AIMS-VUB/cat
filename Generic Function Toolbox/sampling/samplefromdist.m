function samples = samplefromdist(M, N, S)
% SAMPLEFROMDIST samples from distribution
%
%	samples = SAMPLEFROMDIST(M, N, S)
%	
%	M is the mean of the distribution, or a vector of such means
%	N is the number of samples to draw, or a vector of such numbers, to repeat
%		sampling. Per value in N, an extra cell in samples is generated,
%		containing N(i) samples.
%	S is the standard deviation, or a vector of such standard deviations.
%		Defaults to 1, when omitted.
%
%	samples is a cell array containing vectors of samples drawn from the normal
%	distribution M +/- S
%
%	#Jorne Laton#
%	#v2017.10.12#

N_length = length(N);
M_length = length(M);
if nargin < 3
  S = 1;
end

samples = cell(N_length, 1);

for i = 1:N_length
    n = N(i);
    samples{i} = repmat(M, n, 1) + randn(n, M_length)*S;
end