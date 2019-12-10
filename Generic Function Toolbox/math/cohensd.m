function d = cohensd(m1, m2, s1, s2, n1, n2)
%COHENSD calculates Cohen's d between two datasets
%
% d = COHENSD(m1, m2, s1, s2, n1, n2)
%
% Calculates Cohen's d value between two datasets with known mean, standard
% deviation and number. The means m1 and m2, and the standard deviations s1 and
% s2 can be either scalars, vectors or any-D matrices, but all must have the
% same size. The scalars n1 and n2 are the number of elements over which the
% mean and standard deviation were calculated.
%
%Input
% m1, m2	means
% s1, s2	standard deviations
% n1, n2	number of elements over which the mean and standard deviation were calculated

% #2017.02.21 Jorne Laton#

d = (m1 - m2)./sqrt(((n1 - 1)*s1.^2 + (n2 - 1)*s2.^2)/(n1 + n2 - 2));