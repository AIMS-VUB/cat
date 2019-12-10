function subjects = cat_extractsubjects(E, edgetype, options)
% Select connection matrix over all epochs and subjects, average or select other
% properties, such as delay in mutualinfo or band in coherence or imagcoh

if ~isfield(options, 'subject') || isempty(options.subject)
  options.subject = 1 : length(E.filenames);
end
if ~isfield(options, 'band')
  options.band = 1;
end

subjects = E.edges.(edgetype);

if ~isfield(options, 'getepochs') || ~options.getepochs
  switch edgetype
    case 'mutualinfo'
      % Average over delays
      s = size(subjects.average);
      subjects = mean(subjects.average(:, :, :, options.band, options.subject), 3);
      subjects = reshape(subjects, [s([1:2 4:end]), 3]); % Robust squeeze
    case 'correlation'
      subjects = subjects.average(:, :, options.subject);
    otherwise
      subjects = subjects.average(:, :, options.band, options.subject);
  end
else
  switch edgetype
    case 'mutualinfo'
      % Average over delays
      s = size(subjects.epochs);
      subjects = mean(subjects.epochs(:, :, :, :, options.band, options.subject), 3);
      subjects = reshape(subjects, [s([1:2 4:end]), 3]); % Robust squeeze
    otherwise
      subjects = subjects.epochs(:, :, :, options.band, options.subject);
  end
end

if isfield(options, 'abs') && options.abs
  subjects = abs(subjects);
end