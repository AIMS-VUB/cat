function c = weightedcentre(W)

diff = sum(W);

for w = 2 : length(W - 1)
  prev = diff;
  diff = sum(W(w + 1 : end)) - sum(W(1 : w - 1));
  if diff <= 0
    if abs(diff) <= abs(prev)
      c = w;
    else
      c = w - 1;
    end
    return
  end
end

end