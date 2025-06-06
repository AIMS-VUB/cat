function cm = blueorange(mid_white)
if nargin < 1 || ~mid_white
  red = [zeros(1, 32) 0.08:0.08:0.24 0.28:0.04:0.60 0.62:0.02:1]';
  blue = [1: - 0.02:0.62 0.60: - 0.04:0.28 0.24:-0.08:0.08 zeros(1, 32)]';
  green = (red + blue)*0.6;
else
  red = [zeros(1, 21), 0:0.1:1, 1:-0.01:0.81 0.8:-0.02:0.68 0.66:-0.04:0.5]';
  blue = [0.5:0.04:0.66, 0.68:0.02:0.8, 0.81:0.01:1, 1:-0.1:0, zeros(1, 21)]';
  green = [0.3:0.02:0.40, 0.41:0.01:0.48, 0.49:0.03:1, ...
    1:-0.03:0.49, 0.48:-0.01:0.41, 0.40:-0.02:0.3]';
end

cm = [red green blue];

%%
% red = [zeros(1, 21), 0:0.1:1, 1:-0.01:0.81 0.8:-0.02:0.68 0.66:-0.04:0.5]';
% blue = [0.5:0.04:0.66, 0.68:0.02:0.8, 0.81:0.01:1, 1:-0.1:0, zeros(1, 21)]';
% green = [0.3:0.02:0.40, 0.41:0.01:0.48, 0.49:0.03:1, ...
%           1:-0.03:0.49, 0.48:-0.01:0.41, 0.40:-0.02:0.3]';
% 
% map_bluewhiteorange = [red green blue];
