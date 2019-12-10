function E = cat_spect(E, options)
%CAT_SPECT - Frequency spectrum of the time signals in E
%
%   Calculates the frequency spectrum of the time signals (rows) in
%   E.epochs. Adds the field 'spect' with subfields 'freqs' and 'epochs' to
%   E. The epoch spectra are averaged into one spectrum per channel per
%   subject into another field 'average'.
%
%   E = CAT_SPECT(E)
%   E = CAT_SPECT(E, options)
%
%   E         struct containing the fields 'timeseries.epochs' and 'fs', epochs is a
%             5D-matrix , with signals in the dim 1, locations in dim 2, epochs in
%             dim 3, subjects in dim 4 and bands in dim 5.
%   options   struct containing the following fields:
%   .method   'fft' or 'pwelch'. Default 'fft'.
%   .NFFT     fft signal length used by both fft and pwelch, signal is padded with
%             zeros if NFFT > length(signal). Default empty.
%   .window   window length for pwelch. Default empty.
%   .noverlap number of overlapped samples, used by pwelch. Default empty.
%
%   See also SPECT_FFT and SPECT_PWELCH.

%   #2018.11.27 Jorne Laton#

if nargin < 2
  options = [];
end
if ~isfield(options, 'method')
  options.method = 'fft';
end

E.spect.method = options.method;

switch options.method
  case 'fft'
    [E.spect.epochs, E.spect.freqs] = spect_fft(E.timeseries.epochs, E.fs, options);
    E.spect.average = squeeze(mean(E.spect.epochs, 3));
  case 'pwelch'
    if ~isfield(options, 'resolution')
      options.resolution = 1;
    end
    [options.window, n_chan, n_epoch, n_subj] = size(E.timeseries.epochs);
    options.noverlap = 0;
    options.NFFT = options.window*options.resolution;
    E.spect.epochs = zeros(options.NFFT/2 + 1, n_epoch, n_chan, n_subj);
    E.spect.average = zeros(options.NFFT/2 + 1, n_chan, n_subj);
    epochs_average = permute(E.timeseries.epochs, [2, 4, 1, 3]);
    epochs_average = epochs_average(:, :, :);
    epochs_average = permute(epochs_average, [3, 1, 2]);
    for s = 1 : length(E.filenames)
      for c = 1 : length(E.channels.labels)
        [E.spect.epochs(:, :, c, s), E.spect.freqs] = ...
          spect_pwelch(squeeze(E.timeseries.epochs(:, c, :, s)), E.fs, options);
      end
      E.spect.average(:, :, s) = spect_pwelch(epochs_average(:, :, s), E.fs, options);
    end
    E.spect.epochs = permute(E.spect.epochs, [1, 3, 2, 4]);
end