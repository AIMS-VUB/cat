function cat_save(E, folder, renumber)
%CAT_SAVE saves a CAT object in a folder
%
%   It will be saved as follows:
%   folder/paradigm_event_groupname.mat
%   and the original time signals will be in individual files in
%   folder/paradigm_event_groupname/
%
%   If folder is omitted, a selection dialog will pop up.
%
%   See also: CAT_LOAD.

if nargin < 3
  renumber = isfield(E, 'renumbered') && E.renumbered;
  if nargin < 2
    folder = uigetdir;
  end
end

savename = [E.paradigm '_' E.event '_' E.group];

if E.timeseries.changed && isfield(E.timeseries, 'epochs')
  timeseries_epochs = E.timeseries.epochs;
  
  if ~isfolder(fullfile(folder, 'data'))
    mkdir(fullfile(folder, 'data'))
  end
  
  if iscell(timeseries_epochs)
    extract = @extractcell;
  else
    extract = @extractmat;
  end
  
  % Save raw individual data
  for f = 1 : length(timeseries_epochs)
    data = extract(timeseries_epochs, f); %#ok<*NASGU>
    if renumber
      nr = num2str(f);
      nr_str = [repmat('0', 1, 3 - length(nr)) nr];
    else
      nr_str = E.filenames{f}(end-6 : end-4);
    end
    
    save(fullfile(folder, 'data', [savename nr_str]), 'data');
  end
  
end

E.timeseries = rmfield(E.timeseries, 'epochs');
E.renumbered = renumber;

% Save main struct
save(fullfile(folder, savename), 'E');

end

function data = extractcell(D, f)
  data = D{f};
end

function data = extractmat(D, f)
  data = D(:, :, :, f);
end