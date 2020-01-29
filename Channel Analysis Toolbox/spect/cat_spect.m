function E = cat_spect(E, options)
%CAT_SPECT - Frequency spectrum of the time signals in E
%
%   Calculates the frequency spectrum of the time signals (columns) in
%   E.timeseries.epochs. Adds the field 'spect' with subfields 'freqs' and
%   'epochs' to E. The epoch spectra are averaged into one spectrum per channel
%   per subject into another field 'average'.
%
%   E = CAT_SPECT(E)
%   E = CAT_SPECT(E, options)
%
%   E         struct containing the fields 'timeseries.epochs' and 'fs', epochs is a cell array,
%             containing a subject's 3 or 4D EEG data matrix in every cell, with signals in the dim
%             1, locations in dim 2 and epochs in dim 3.
%   options   struct containing the following fields:
%   .method   'fft' or 'pwelch'. Only 'pwelch' supported currently.
%   .resolution  factor to artificially increase the spectral resolution. This does not add
%             information to the spectrum, it merely interpolates it to make it smoother. Default 1.

%   .NFFT     fft signal length used by both fft and pwelch, signal is padded with
%             zeros if NFFT > length(signal). Default empty.
%   .window   window length for pwelch. Default empty.
%   .noverlap number of overlapped samples, used by pwelch. Default empty.
%
%   See also SPECT_FFT and SPECT_PWELCH.

% Last edit: 20200129 Jorne Laton - made default method and renamed
% Authors:   Jorne Laton

if nargin < 2
  options = [];
end
if ~isfield(options, 'method')
  options.method = 'pwelch';
end

E.spect.method = options.method;
n_subj = length(E.filenames);

filenames = E.filenames;
fs = E.fs;
allepochs = E.timeseries.epochs;

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
    average = zeros(options.NFFT/2 + 1, n_chan, n_subj);
    freqs = zeros(options.NFFT/2 + 1, n_subj);
    parfor s = 1 : n_subj
      disp(['Calculating spectrum for ' filenames{s}]);
      epochs = permute(allepochs{s}, [2 1 3]);
      epochs = epochs(:, :);
      epochs = epochs';
      [average(:, :, s), freqs(:, s)] = spect_pwelch(epochs, fs, options);
    end
end

disp('Done');

E.spect.average = average;
E.spect.freqs = freqs(:, 1);