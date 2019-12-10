function COR = correlation( X, fs, options )

if ~isfield( options, 'windowlength' ), options.windowlength = size( X, 1 ); end

X = sliding_window( X, fs, options );

[~, n_chan, n_epoch] = size( X );

COR = zeros( n_chan, n_chan, n_epoch );

for e = 1 : n_epoch
  COR( :, :, e ) = permute( H_xcorr( X( :, :, e ), 0, 'coeff' ), [ 2 3 1 ] );
end
    
% Averages over epochs
COR  = mean( COR, 3 );