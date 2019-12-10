function E = cat_spect_batch(E, bands, bandlabels, peakband)
%CAT_SPECT_BATCH - All different spectral processing steps in a batch
%
%   Performs all different processing steps in a batch: eeg_spect,
%   eeg_spectpeaks, eeg_maxpeak, eeg_bandpower and eeg_bandaverage.
%
%   E = CAT_SPECT_BATCH(E, bands, bandlabels, peakband)
%
%   See also CAT_SPECT, CAT_SPECT_PEAKS, CAT_SPECT_MAXPEAK and CAT_BANDPOWER

%   #2018.11.27 Jorne Laton

% Spectrum
E = cat_spect(E);

% Extract peaks in spectra
E = cat_spect_peaks(E, peakband);

% Determine largest peak's frequency, amplitude and channel
E = cat_spect_maxpeak(E);

% Calculate power in different bands
E = cat_bandpower(E, bands, strcat(bandlabels, ' power'));
