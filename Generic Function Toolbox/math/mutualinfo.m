function mi = mutualinfo(X, Y, correct, m)
%MUTUALINFO Mutual info between two data vectors
%
%   mi = MUTUALINFO(X, Y, m)
%
%   Input parameters
%   X, Y      data vectors
%   m         number of bins in each direction. Default floor(sqrt(length(X)/5))
%   correct   bias correction. Default true

%   #Jorne Laton 2018.02.08#

if nargin < 4
  m = floor(sqrt(length(X)/5));
end
% if m > sqrt(length(X))
%   warning(['This value of m is too big and might introduce bias. ' ...
%     'Choose m < sqrt(length(X)) to avoid this effect.']);
% end

%%
k_yx = histcounts2(X, Y, m);
b_yx = nnz(k_yx);

k_x = sum(k_yx, 1);
k_x = repmat(k_x, size(k_yx, 1), 1);
b_x = nnz(k_x(1, :));

k_y = sum(k_yx, 2);
k_y = repmat(k_y, 1, size(k_yx, 2));
b_y = nnz(k_y(:, 1));

N = length(X);

%%
mi = log2(N) + nansum(nansum(k_yx.*(log2(k_yx) - log2(k_x) - log2(k_y))))./N;

if ~exist('correct', 'var') || correct
  mi = mi + (b_x + b_y - b_yx - 1)/2/N;
end

end

