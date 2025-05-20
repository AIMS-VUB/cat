function C = cat_time_peaks(C, peaks)
%CAT_TIME_PEAKS - Time series peak extraction
%
%   Extracts a peak in the specified interval and stores it in the struct E.
%   The field 'peaks' and its subfields 'times', 'ampls' and 'interval' are added
%   to E.timeseries to store the results of this function.
%
%   C = CAT_TIME_PEAKS(C, options)
%
%   C is a struct containing the field 'timeseries' and its subfields 'average'
%   and 'times'.
%
%   See also MULTIFINDPEAK

%   #2018.11.28 Jorne Laton#

n_peaks = length(peaks);

[times, ampls] = multifindpeak(C.timeseries.times, C.timeseries.average, peaks(1));
C.timeseries.peaks.times = zeros([size(times), n_peaks]);
C.timeseries.peaks.ampls = C.timeseries.peaks.times;
C.timeseries.peaks.times(:, :, 1) = times;
C.timeseries.peaks.ampls(:, :, 1) = ampls;

for p = 2 : n_peaks
  [C.timeseries.peaks.times(:, :, p), C.timeseries.peaks.ampls(:, :, p)] = ...
    multifindpeak(C.timeseries.times, C.timeseries.average, peaks(p));
  C.timeseries.peaks.intervals(p, :) = peaks(p).interval;
end

C.timeseries.peaks.labels = {peaks.label};