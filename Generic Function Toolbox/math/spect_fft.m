function [ X, f ] = spect_fft( x, Fs, options )
%SPECT_FFT function for convenient use of Matlab's built-in fft.
%   [ X, f ] = SPECT_FFT( x, Fs ) performs the time to frequency domain
%   transformation using the Matlab fft function, but with results that are
%   ready to plot.
%
%   x 	1D, 2D, 3D or 4D structure in which the columns are to be transformed
%   Fs 	sampling frequency
%   X 	transformed data
%   f 	frequency array
%
%   See also FFT.

%   #2018.05.25 Jorne Laton#

if nargin < 3
  options = [];
end
if ~isfield(options, 'NFFT')
  options.NFFT = [];
end

% Transform and normalise
X = fft(x, options.NFFT, 1)*2/size(x, 1);
half_length = floor(size(X, 1)/2);
% Keep only lower half and absolute value
X = abs(X(1:half_length + 1, :, :, :));
f = Fs/2*linspace(0, 1, half_length + 1)';

end

