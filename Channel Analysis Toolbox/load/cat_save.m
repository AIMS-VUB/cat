function cat_save(E, folder, no_renumber)
%CAT_SAVE saves a CAT object in a folder
%
%   It will be saved as follows:
%   folder/paradigm_event_groupname.mat
%   and the original time signals will be in individual files in
%   folder/data/
%
%   If folder is omitted, E is checked for a field folder where it was loaded from, overwriting the
%   previously saved struct. If such info is not available in the struct, a selection dialog will
%   pop up.
%   If no_renumber is omitted, 0 or false, the individual raw data files will be renumbered.
%
%   See also: CAT_LOAD.

if nargin < 3
  renumber = isfield(E, 'renumbered') && E.renumbered;
  if nargin < 2
    try
      folder = E.folder;
    catch
      folder = uigetdir;
    end
  end
end

savename = strrep([E.paradigm '_' E.event '_' E.group], ' ', '_');

if E.timeseries.changed && isfield(E.timeseries, 'epochs')
  timeseries_epochs = E.timeseries.epochs;
  
  [~, ~] = mkdir(fullfile(folder, 'data'));
  
  if iscell(timeseries_epochs)
    extract = @extractcell;
  else
    extract = @extractmat;
  end
  
  % Save raw individual data
  for f = 1 : length(timeseries_epochs)
    data = extract(timeseries_epochs, f);
    if no_renumber
      nr_str = E.filenames{f}(end-6 : end-4);
    else
      nr = num2str(f);
      nr_str = [repmat('0', 1, 3 - length(nr)) nr];      
    end
    
    save(fullfile(folder, 'data', [savename nr_str]), 'data');
  end
  
end

try
  E.timeseries = rmfield(E.timeseries, 'epochs');
catch
end
E.renumbered = ~no_renumber;
E.folder = folder;

% Save main struct
save(fullfile(folder, savename), 'E');

end

function data = extractcell(D, f)
  data = D{f};
end

function data = extractmat(D, f)
  data = D(:, :, :, f);
end