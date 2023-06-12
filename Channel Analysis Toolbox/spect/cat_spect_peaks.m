function E = cat_spect_peaks(E, bands, bandlabels, options)
%CAT_SPECT_PEAKS - Spectral peak extraction
%
%   Extracts a peak in each of the specified bands and stores it in the struct E.
%   The field 'peaks' and its subfields 'freqs', 'ampls' and 'bands' are added
%   to E to store the results of this function.
%
%   E = CAT_SPECT_PEAKS(E, bands, bandlabels)
%
%Input
%   E           struct containing the field 'spect' and its subfields 'average'
%               and 'freqs'.
%   bands       n-by-2 matrix with a frequency interval per row, default
%               [-Inf Inf]. A peak is produced for each
%   bandlabels  cell array containing the band labels, e.g. 'alpha',
%               default 'broadband'
%
%   See also MULTIFINDPEAK, CAT_SPECT

%   #2023.05.11 Jorne Laton# Extended to multiple bands

if (nargin < 4)
    options = [];
end

if (nargin < 3 || isempty(bands) && isempty(bandlabels))
    if (nargin == 2)
        error('Bandlabels cannot be omitted if bands is passed as an argument.');
    end
    if (isfield(E, 'spect') && isfield(E, 'bandpower') && isfield(E, 'bands'))
        bands = E.spect.bandpower.bands;
        bandlabels = E.spect.bandpower.bandlabels;
    else
        bands = [-Inf Inf];
        bandlabels = {'broadband'};
    end
end

n_bands = size(bands, 1);
E.spect.peaks.freqs = zeros(length(E.channels.labels), n_bands, length(E.filenames));
E.spect.peaks.ampls = zeros(size(E.spect.peaks.freqs));
for b = 1 : n_bands
    options.interval = bands(b, :);
    [X, Y] = multifindpeak(E.spect.freqs, E.spect.average, options);
    E.spect.peaks.freqs(:, b, :) = X';
    E.spect.peaks.ampls(:, b, :) = Y';
        
end

E.spect.peaks.bands = bands;
E.spect.peaks.bandlabels = bandlabels;
