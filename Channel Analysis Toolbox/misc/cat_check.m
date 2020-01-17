function cat_check(type)
%CAT_CHECK Perform check before starting to execute
%
%   CAT_CHECK(type)
%
% Input
%   type  string
%           Options: 'parpool' = check if a parallel pool is active, warn if not.

% Last edit:  20191218 Jorne Laton: Added help
% Authors:    Jorne Laton

switch type
  case 'parpool'
    try
      if isempty(gcp('nocreate'))
        warning(['This function is optimised for parallel use. '...
          'It is recommended to start a parallel pool prior to running it.']);
      end
    catch
      warning(['This function is optimised for parallel use, but '...
        'you do not seem to have the Parallel Toolbox installed.'...
        'You can install this with the Matlab installer, provided you have the license.']);
    end
end