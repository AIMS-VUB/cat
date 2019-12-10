function E = cat_spect_maxpeak(E)
%CAT_SPECT_MAXPEAK - Amplitude, frequency and channel of the largest peak
%
%   Detects amplitude, frequency and channel of the largest peak, over all channels. For each
%   subject, 3 values are stored in the substruct peaks.max in E.spect.
%
%   E = CAT_SPECT_MAXPEAK(E)
%
%   E is a struct containing the field 'spect.peaks' and its subfields 'ampls' and
%   'freqs'.
%
%   See also CAT_SPECT_PEAKS

%   #2018.11.26 Jorne Laton#

[E.spect.peaks.max.amp, E.spect.peaks.max.ind] = max(E.spect.peaks.amp, [], 2);

% Calculate linear indices in whole matrix from row-only indices
ind_lin = sub2ind(size(E.spect.peaks.freq), (1:length(E.spect.peaks.max.ind))', ...
	E.spect.peaks.max.ind);
E.spect.peaks.max.freq = E.spect.peaks.freq(ind_lin);

E.spect.peaks.max.chan = E.channels.labels(E.spect.peaks.max.ind);
