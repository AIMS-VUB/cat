function wjs = whitejet_symm(m)

if nargin < 1
  wjs = whitejet_bright;
else
  wjs = whitejet_bright(m);
end

wjs(end/2+1 : end, 3) = wjs(end/2 : -1 : 1, 1);