function X_w = sliding_window( X, fs, options )
%SLIDING_WINDOW overlapping sliding windowing of data.
%   
%   X_W = SLIDING_WINDOW(X, CONFIG)
%
%   SLIDING_WINDOW performs windowing of X. X must be given as data per channel
%   per trial for correct performing.
%
%   Input value options must consist of a structure with, at least, fields:
%   - window: Window length in milliseconds.
%   - fs: Sample rate of the data.
%
%   Output data X_w is given as windowed data per channel per step per
%   trial. The number of steps is selected according to the length of the
%   data, the length of the window and the overlap selected.

% Checks the existence of all parameters.

if ~isfield( options, 'alignment' ), options.alignment = 'epoch'; end
if ~isfield( options, 'overlap' ), options.overlap = 0; end
if ~isfield( options, 'baseline' ), options.baseline = 0; end

% If the alignment is with the stimulus, cuts the initial edge.
if strcmp( options.alignment, 'stimulus' )
    shift = floor( fs*options.baseline/1000 );
    X( 1: shift, :, :, : ) = [];
end

% Calculates the length of the window and the overlap.
length  = round( options.windowlength / 1000 * fs );
overlap = round( options.windowlength / 1000 * fs * options.overlap / 100 );

% Calculates matrix size from original data, length of the window and
% number of windows.
windows = floor(( size( X, 1 ) - overlap ) /( length - overlap ) );
sizes = [length size( X, 2 ) windows size( X, 3 ) ];

% Memory reservation for the output data.
X_w = zeros( sizes );

% Fulfilment of the data.
for w = 1 : windows
    X_w( :, :, w, : ) = X(( w - 1 ) * ( length - overlap ) + ( 1 : length ), :, : );
end

% Sets zero mean and unity standard deviation.
X_w = zscore( X_w );