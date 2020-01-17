function options = cat_proc_checkoptions(options)

if ~isfield(options, 'save')
  options.save = '.';
end