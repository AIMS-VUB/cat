function E = cat_spect_regionpeak(E, regions)
%CAT_SPECT_REGIONPEAK - Amplitude, frequency and channel of the largest peak within a region
%
%   Detects amplitude, frequency and channel of the largest peak, over all channels in a region
%   defined in regions. For each subject, 3*n_regions values are stored in the substruct
%   peaks.regions in E.spect.
%
%   E = CAT_SPECT_REGIONPEAK(E, regions)
%
%   E is a struct containing the field 'spect.peaks' and its subfields 'ampls' and
%   'freqs'.
%
%   See also CAT_SPECT_PEAKS

%   #2018.11.26 Jorne Laton#

n_subj = length(E.filenames);
n_region = length(regions.labels);

E.spect.peaks.regions.freqs = zeros(n_subj, n_region);
E.spect.peaks.regions.ampls = E.spect.peaks.regions.freqs;

for r = 1 : n_region
  ch_ind = ismember(E.channels.labels, regions.channels{r});
  ampls = E.spect.peaks.ampls(:, ch_ind);
  freqs = E.spect.peaks.freqs(:, ch_ind);
  [amp, ind] = max(ampls, [], 2);

  % Calculate linear indices in whole matrix from row-only indices
  ind_lin = sub2ind(size(freqs), (1:length(ind))', ind);  
  freq = freqs(ind_lin);
  
%   if 
%     OPTIONAL TODO: verify median/mode frequency equal to max
%   end
  
  E.spect.peaks.regions.freqs(:, r) = freq;
  E.spect.peaks.regions.ampls(:, r) = amp;
end

E.spect.peaks.regions.channels = regions.channels;
E.spect.peaks.regions.labels = regions.labels;

