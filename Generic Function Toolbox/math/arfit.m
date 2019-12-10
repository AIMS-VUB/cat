function A = arfit ( v, p )


[n_time, n_chan, n_epoch] = size ( v );

mcor = 1;
ne   = n_epoch * ( n_time - p );
np   = n_chan * p + mcor;

if ne <= np
  error ( 'Time series too short.' )
end

% compute QR factorization for model of order pmax
[R, scale] = arqr(v, p, mcor);
% number of parameter vectors of length m
np = n_chan*p + mcor;

% decompose R for the optimal model order popt according to
%
%   | R11  R12 |
% R=|          |
%   | 0    R22 |
%
R11   = R(1:np, 1:np);
R12   = R(1:np, np+1:np+n_chan);

% get augmented parameter matrix Aaug=[w A] if mcor=1 and Aaug=A if mcor=0
if (np > 0)
    if (mcor == 1)
        % improve condition of R11 by re-scaling first column
        con 	= max(scale(2:np+n_chan)) / scale(1);
        R11(:,1)	= R11(:,1)*con;
    end
    Aaug = (R11\R12)';
    
    %  return coefficient matrix A and intercept vector w separately
    if (mcor == 1)
        % intercept vector w is first column of Aaug, rest of Aaug is
        % coefficient matrix A
        A = Aaug(:,2:np);
    else
        % return an intercept vector of zeros
        A = Aaug;
    end
else
    % no parameters have been estimated
    % => return only covariance matrix estimate and order selection
    % criteria for ``zeroth order model''
    A   = [];
end