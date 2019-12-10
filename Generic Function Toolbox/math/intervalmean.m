function intmean = intervalmean(x, y, interval)
%INTERVALMEAN - Mean in interval along second dimension
%
%   intmean = INTERVALMEAN(x, y, interval)
%     calculates the mean of yvalues in the specified interval in xvalues
%
%   x         vector of the same length as the first dimension of y,
%             contains e.g. time or frequency values
%   y         vector or up to 5D matrix
%   interval  two-element vector used to obtain the indices in xvalues, to
%             be used for selection in y. The upper limit of the interval is
%             inclusive.

%   #2018.01.12 Jorne Laton#

% subset = x > interval(1) & x < interval(2);
subset = x > interval(1) & x <= interval(2);
subset_x = y(subset, :, :, :, :);

intmean = squeeze(mean(subset_x, 2));
