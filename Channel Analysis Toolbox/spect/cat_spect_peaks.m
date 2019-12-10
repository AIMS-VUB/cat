function E = cat_spect_peaks(E, options)
%CAT_SPECT_PEAKS - Spectral peak extraction
%
%   Extracts a peak in the specified band and stores it in the struct E.
%   The field 'peaks' and its subfields 'freqs', 'ampls' and 'band' are added
%   to E to store the results of this function.
%
%   E = CAT_SPECT_PEAKS(E, options)
%
%   E is a struct containing the field 'spect' and its subfields 'average'
%   and 'freqs'.
%
%   See also MULTIFINDPEAK, CAT_SPECT

%   #2018.11.26 Jorne Laton#

[E.spect.peaks.freqs, E.spect.peaks.ampls] = ...
  multifindpeak(E.spect.freqs, E.spect.average, options);
E.spect.peaks.band = options.interval;