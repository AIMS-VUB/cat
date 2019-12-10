function E = cat_spect_bandaverage(E, bands, bandlabels)
%CAT_SPECT_BANDAVERAGE - Average in different bands
%
%   Calculates the spectral average in different bands. Similar to
%   bandpower, but without squaring the data. Its result is stored in the
%   added field 'bandaverage'.
%
%   E = CAT_SPECT_BANDAVERAGE(E, bands, bandlabels)
%
%   E           struct containing the field 'spect' with subfields 'epochs',
%               'averages' and 'freqs', which are created by the function
%               CAT_SPECT.
%   bands       2D matrix containing frequency intervals in its rows for
%               which the average must be calculated
%   bandlabels  cell array containing the band labels, e.g. 'alpha'
%
%   See also INTERVALMEAN, CAT_SPECT

%   #2015.10.16 Jorne Laton#

n_bands = size(bands, 1);
E.spect.bandaverage.ampls = ...
  zeros(size(E.spect.average, 3), size(E.spect.average, 1), n_bands);
E.spect.bandaverage.bands = bands;
E.spect.bandaverage.labels = strcat(bandlabels, ' average');

for i = 1 : n_bands
  E.spect.bandaverage.ampls(:, :, i) = ...
    intervalmean(E.spect.freqs, E.spect.average, bands(i, :))';
end

end

