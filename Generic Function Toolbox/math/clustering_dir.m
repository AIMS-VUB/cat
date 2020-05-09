function c = clustering_dir(A)
%CLUSTERING_DIR directed clustering coefficient

% Based on Fagiolo, 2007, reviewed in Rubinov, 2010
% 

n = length(A);
A(logical(eye(n))) = 0;

t = zeros(n, 1);
k = zeros(n, 1);
p = zeros(n, 1);

for i = 1 : n
  k(i) = sum(A(i, :)'  + A(:, i)); % in and out degree
  p(i) = sum(A(i, :)' .* A(:, i)); % pointwise product
  
  for j = 1 : n
    for h = 1 : n
      t(i) = t(i) + (A(i, j) + A(j, i)) * (A(i, h) + A(h, i)) * (A(j, h) + A(h, j));      
    end
  end
end

t = t / 2;

c = sum( t ./ (k .* (k - 1) - 2 * p) ) / n;