function E = cat_spect_bandpower(E, bands, bandlabels, baseline)
%CAT_SPECT_BANDPOWER - Power in different bands
%
%   Calculates the spectral power in different bands
%
%   E = CAT_SPECT_BANDPOWER(E, bands, bandlabels)
%
%   E     is a struct containing the field 'spect' with subfields 'epochs'
%         and 'freqs', which are created by the function CAT_SPECT.
%   bands is a 2D matrix containing frequency intervals in its rows for
%         which the power must be calculated
%   bandlabels is a cell array containing the band labels, e.g. 'alpha'
%   baseline   is an optional index to select a band to subtract from every other
%
%   See also INTERVALMEAN, CAT_SPECT

%   #2023.05.05 Jorne Laton#

data_spec_squared = E.spect.average.^2;
n_bands = size(bands, 1);
E.spect.bandpower = [];
E.spect.bandpower.average = zeros(size(E.spect.average, 2), n_bands, size(E.spect.average, 3));
E.spect.bandpower.bands = bands;
E.spect.bandpower.labels = bandlabels;

for i = 1 : n_bands
  E.spect.bandpower.average(:, i, :) = intervalmean(E.spect.freqs, data_spec_squared, bands(i, :));
end

if (nargin > 3)
    for i = 1 : n_bands
        if (i == baseline)
            continue
        end
        E.spect.bandpower.average(:, i, :) = E.spect.bandpower.average(:, i, :) - E.spect.bandpower.average(:, baseline, :);
    end
    E.spect.bandpower.baseline = bandlabels(baseline);
end

E.spect.bandpower.percentage = E.spect.bandpower.average ./ repmat(sum(E.spect.bandpower.average, 2), 1, n_bands);

end