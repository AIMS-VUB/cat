function E = cat_time_regionpeak(E, regions)
%CAT_TIME_REGIONPEAK - Amplitude, time and channel of the largest peak within a region
%
%   Detects amplitude, time and channel of the largest peak, over all channels in a region
%   defined in regions. For each subject, 3*n_regions values are stored in the substruct
%   peaks.regions in E.spect.
%
%   E = CAT_TIME_REGIONPEAK(E, regions)
%
%   E is a struct containing the field 'spect.peaks' and its subfields 'ampls' and
%   'freqs'.
%
%   See also CAT_SPECT_PEAKS

%   #20240613 Jorne Laton#

n_subj = length(E.filenames);
n_region = length(regions.labels);
n_peak = length(E.timeseries.peaks.labels);

E.timeseries.peaks.regions.times = zeros(n_subj, n_region, n_peak);
E.timeseries.peaks.regions.ampls = E.timeseries.peaks.regions.times;

for r = 1 : n_region
    for p = 1 : n_peak
      ch_ind = ismember(E.channels.labels, regions.channels{r});
      ampls = E.timeseries.peaks.ampls(:, ch_ind, p);
      times = E.timeseries.peaks.times(:, ch_ind, p);
      [amp, ind] = max(ampls, [], 2);

      % Calculate linear indices in whole matrix from row-only indices
      ind_lin = sub2ind(size(times), (1:length(ind))', ind);  
      time = times(ind_lin);

    %   if 
    %     OPTIONAL TODO: verify median/mode time equal to max
    %   end

      E.timeseries.peaks.regions.times(:, r, p) = time;
      E.timeseries.peaks.regions.ampls(:, r, p) = amp;
    end
end

E.timeseries.peaks.regions.channels = regions.channels;
E.timeseries.peaks.regions.labels = regions.labels;

