function [COH, freq] = coherence(X, fs, options)
% COHERENCE spectral correlation
%
%

if ~isfield( options, 'windowlength' ), options.windowlength = size( X, 1 ); end

X = sliding_window( X, fs, options );

nfft = max( 256, pow2( nextpow2( size( X, 1 ) ) ) );

% Calculates the indexes
COH = permute( H_spectra( X, 'coherence' ), [2, 3, 1]);

freq = 0 : fs/nfft : fs/2;