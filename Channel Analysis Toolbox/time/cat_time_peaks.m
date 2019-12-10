function E = cat_time_peaks(E, peaks)
%CAT_TIME_PEAKS - Time series peak extraction
%
%   Extracts a peak in the specified interval and stores it in the struct E.
%   The field 'peaks' and its subfields 'times', 'ampls' and 'interval' are added
%   to E.timeseries to store the results of this function.
%
%   E = CAT_TIME_PEAKS(E, options)
%
%   E is a struct containing the field 'timeseries' and its subfields 'average'
%   and 'times'.
%
%   See also MULTIFINDPEAK

%   #2018.11.28 Jorne Laton#

n_peaks = length(peaks);

[times, ampls] = multifindpeak(E.timeseries.times, E.timeseries.average, peaks(1));
E.timeseries.peaks.times = zeros([size(times), n_peaks]);
E.timeseries.peaks.ampls = E.timeseries.peaks.times;
E.timeseries.peaks.times(:, :, 1) = times;
E.timeseries.peaks.ampls(:, :, 1) = ampls;

for p = 2 : n_peaks
  [E.timeseries.peaks.times(:, :, p), E.timeseries.peaks.ampls(:, :, p)] = ...
    multifindpeak(E.timeseries.times, E.timeseries.average, peaks(p));
  E.timeseries.peaks.intervals(p, :) = peaks(p).interval;
end

E.timeseries.peaks.labels = {peaks.label};