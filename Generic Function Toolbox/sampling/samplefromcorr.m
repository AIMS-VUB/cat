function [X, Y] = samplefromcorr(ro, n_samp, n_iter, uniform)
%SAMPLEFROMCORR sample from preset correlation
%
% [X, Y] = SAMPLEFROMCORR(ro, n_samp)
% [X, Y] = SAMPLEFROMCORR(ro, n_samp, n_iter)
% [X, Y] = SAMPLEFROMCORR(ro, n_samp, n_iter, uniform)
%
%Input
% ro		desired correlation between X and Y
% n_samp	number of samples in one draw
% n_iter	number of iterations, every column in X corresponds to the same column in Y
% uniform 	boolean for choosing standardised uniform distribution (true) or
%			standard normal distribution (false). Default false.
%
%Output
% X and Y are vectors or matrices with a per-column correlation of approximately ro
%
% #2018.02.09 Jorne Laton#

if nargin < 3
  n_iter = 1;
end
if exist('uniform', 'var') && uniform
% X is drawn from standardised uniform distribution
  X = zscore(rand(n_samp, n_iter));
else
% X is drawn from standard normal distribution
  X = randn(n_samp, n_iter);
end

S = randn(n_samp, n_iter);
Y = ro*X + sqrt(1 - ro^2)*S;