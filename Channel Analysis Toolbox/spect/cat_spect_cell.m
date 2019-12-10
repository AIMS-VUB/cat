function E = cat_spect_cell(E, options)
%CAT_SPECT_CELL - Frequency spectrum of the time signals in E
%
%   Calculates the frequency spectrum of the time signals (columns) in
%   E.timeseries.epochs. Adds the field 'spect' with subfields 'freqs' and
%   'epochs' to E. The epoch spectra are averaged into one spectrum per channel
%   per subject into another field 'average'.
%
%   E = CAT_SPECT_CELL(E)
%   E = CAT_SPECT_CELL(E, options)
%
%   E         struct containing the fields 'timeseries.epochs' and 'fs', epochs is a
%             cell array, containing a subject's 3 or 4D EEG data matrix in
%             every cell, with signals in the dim 1, locations in dim 2,
%             epochs in dim 3, and, possibly, bands in dim 4.
%   options   struct containing the following fields:
%   .method   'fft' or 'pwelch'. Only 'pwelch' supported currently.
%   .NFFT     fft signal length used by both fft and pwelch, signal is padded with
%             zeros if NFFT > length(signal). Default empty.
%   .window   window length for pwelch. Default empty.
%   .noverlap number of overlapped samples, used by pwelch. Default empty.
%
%   See also SPECT_FFT and SPECT_PWELCH.

%   #2018.11.27 Jorne Laton#

if E.epochs_filtered_in_bands
  error('This function is not recommended for band-filtered data.')
end

if nargin < 2
  options = [];
end
if ~isfield(options, 'method')
  options.method = 'pwelch';
end

E.spect.method = options.method;
n_subj = length(E.filenames);

switch options.method
%   case 'fft'
%     [E.spect.epochs, E.spect.freqs] = spect_fft(E.epochs, E.fs, options);
%     E.spect.average = squeeze(mean(E.spect.epochs, 3));
  case 'pwelch'
    if ~isfield(options, 'resolution')
      options.resolution = 1;
    end
    [options.window, n_chan, ~] = size(E.timeseries.epochs{1});
    options.noverlap = 0;
    options.NFFT = options.window*options.resolution;
    E.spect.average = zeros(options.NFFT/2 + 1, n_chan, n_subj);
    for s = 1 : n_subj
      epochs = permute(E.timeseries.epochs{s}, [2 1 3]);
      epochs = epochs(:, :);
      epochs = epochs';
      [E.spect.average(:, :, s), E.spect.freqs] = spect_pwelch(epochs, E.fs, options);
    end
end