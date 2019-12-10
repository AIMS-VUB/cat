function [DTF, freq] = dtf( X, fs, options )
% DTF Directed transfer function
%   
%   [DTF, freq] = DTF(X, options)
%
%   DTF calculates the DTF connectivity in the signals given in the columns of
%   the matrix X using a MVAR model computed using the ARFIT package.
%
%   options is a structure with fields:
%   - order   order of the MVAR model.
%   - nfft    length of the Fourier transform
%
% Inputs
%   X             time series matrix with time along first dimension
%   fs            sampling frequency
%   options       struct containing the following fields
%   .order        order of the MVAR model
%   .windowlength length of the window
%   .alignment    'epoch' for alignment with start of the epoch, 'stimulus' for
%                 alignment with stimulus
%   .baseline     length of the baseline
%
% Outputs
%   DTF   directed transfer function coefficient matrix
%   freq  frequency vector
%
%   References:
%     [1] Ernesto Pereda et al., Nonlinear multivariate analysis of
%         neurophysiological signals, Progress in Neurobiology, vol. 77,
%         pp. 1-37, 2005.

if ~isfield( options, 'order' ), options.order = 4; end
if ~isfield( options, 'windowlength' ), options.windowlength = size( X, 1 ); end

X = sliding_window( X, fs, options );

% Pad signal up to next power of two
nfft = pow2( nextpow2( size( X, 1) - options.order ));
n_freq = floor( nfft/2 ) + 1;

n_chan = size( X, 2 );
X = permute( X, [ 1 2 4 3 ] );

A = arfit( X( :, :, : ), options.order );
A = reshape( A, n_chan, n_chan, [] );
A = cat(3, zeros( n_chan ), A);

Af = fft( A, nfft, 3 );
Af = Af( :, :, 1 : n_freq );
Af = repmat( eye( n_chan ), 1, 1, n_freq ) - Af;

H = zeros( size( Af ) );
H_norm = zeros( size( Af ) );

for f = 1 : n_freq
  H( :, :, f ) = inv( Af( :, :, f ) );  
  for j = 1 : n_chan
    H_norm( j, :, f ) = norm( H( j, :, f ) );
  end
end

DTF = abs( H ) ./ H_norm;
freq = 0 : fs/nfft : fs/2;

end