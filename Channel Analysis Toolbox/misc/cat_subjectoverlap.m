function [E1, E2] = cat_subjectoverlap(E1, E2)
%CAT_SUBJECTOVERLAP Select the overlapping subjects from two CAT structs
%
  function E = selectsubjects(E, ind)
    E.filenames = E.filenames(ind);
    
    if ~iscell(E.timeseries.epochs)
      E.timeseries.epochs = E.timeseries.epochs(:, :, :, ind, :);
      if isfield(E.timeseries, 'average')
        E.timeseries.average = E.timeseries.average(:, :, ind, :);
      end
    else
      E.timeseries.epochs = E.timeseries.epochs(ind);
      if isfield(E.timeseries, 'average')
        E.timeseries.average = E.timeseries.average(ind);
      end
    end
    
    if isfield(E.timeseries, 'peaks')
      E.timeseries.peaks.times = E.timeseries.peaks.times(ind, :, :);
      E.timeseries.peaks.ampls = E.timeseries.peaks.ampls(ind, :, :);
    end
    
    if isfield(E, 'spect')
      if isfield(E.spect, 'epochs')
        E.spect.epochs = E.spect.epochs(:, :, :, ind, :);
      end
      if isfield(E.spect, 'peaks')
        E.spect.peaks.amp = E.spect.peaks.amp(ind, :);
        E.spect.peaks.freq = E.spect.peaks.freq(ind, :);
        if isfield(E.spect.peaks, 'max')
          E.spect.peaks.max.freq = E.spect.peaks.max.freq(ind);
          E.spect.peaks.max.amp = E.spect.peaks.max.amp(ind);
          E.spect.peaks.max.ind = E.spect.peaks.max.ind(ind);
          E.spect.peaks.max.chan = E.spect.peaks.max.chan(ind);
        end
      end
      E.spect.average = E.spect.average(:, :, ind, :);
    end
    
    if isfield(E, 'edges')
      edgenames = fieldnames(E.edges)';
      for e = edgenames
        E.edges.(e{1}).epochs = E.edges.(e{1}).epochs(:, :, :, ind, :);
        E.edges.(e{1}).average = E.edges.(e{1}).average(:, :, ind, :);
      end
    end    
  end

ind1 = ismember(E1.filenames, E2.filenames);
[~, ind2] = ismember(E2.filenames, E1.filenames);

E1 = selectsubjects(E1, ind1);
E2 = selectsubjects(E2, find(ind2));

end