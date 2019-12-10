function [ X, f ] = spect_pwelch( x, Fs, options )
%SPECT_PWELCH function for convenient use of Matlab's built-in pwelch.
%   [ X, f ] = SPECT_PWELCH( x, Fs, options ) performs the time to frequency domain
%   transformation using Matlab's built-in pwelch function.
%
%   x 	1D or 2D structure in which the columns are to be transformed
%   Fs 	sampling frequency
%   X 	transformed data
%   f 	frequency array
%
%   See also PWELCH.

%   #2018.05.25 Jorne Laton#

if nargin < 3
  options = [];
end
if ~isfield(options, 'NFFT')
  options.NFFT = [];
end
if ~isfield(options, 'window')
  options.window = [];
end
if ~isfield(options, 'noverlap')
  options.noverlap = [];
end

[X, f] = pwelch(x, options.window, options.noverlap, options.NFFT, Fs);

end

