function H = cat_maxpeakchanhist(E)

h = hist(E.peaks.max.ind, unique(E.peaks.max.ind));
H = zeros(1, length(E.chanlabels));
H(unique(E.peaks.max.ind)) = h;