function cat_check(type)

switch type
  case 'parpool'
    if isempty(gcp('nocreate'))
      warning(['This function is optimised for parallel use. '...
        'It is recommended to start a parallel pool prior to running it.']);
    end
end