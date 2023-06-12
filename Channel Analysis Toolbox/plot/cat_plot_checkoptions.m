function [options] = cat_plot_checkoptions(E, options)
%CAT_CHECKPLOTOPTIONS Fills in default values for non-existing fields in options
%   
%   options = CAT_CHECKPLOTOPTIONS(options) creates and initialises the following
%   fields in the struct options so that it can be used by the various plot
%   functions.
%
%Input
%   E             'CAT' object, with default fields filenames and channels.labels
%   options       option struct containing the following fields:
%   Field         Value
%   .plottype     'matrix', 'headinhead' or 'network'. For headinhead and network, E needs to
%                 contain channels.positions.
%   .subject      scalar, index of specific subject of whom to show the plot, or
%                 empty to show the group average.
%   .band         scalar, index of band to plot, or string, name of band in
%                   bands.labels
%   .chanindices  vector, selection of channels to plot. Default all channel
%                 indices
%   .chanlabels   custom X and Y axis labels, use together with ticks. Default
%                 all channel labels
%   .ticks        tick locations. Default at every channel
%   .scale        color scale, values: 'maxmin' = ± max absolute value
%                   found in data
%                   'maxmin' = min and max value found in data
%                   [min max] = custom min and max value
%   .fontsize     figure font size, default 14
%   .linewidth    line width, default 2
%   .colormap     default 'hot'
%   .colorbar     set to false to hide the colorbar. Default true.
%   .showtitle    set to false to hide the title. Default true.
%   .save         path to folder to save the figure to. Default empty = no save
%   .savetype     type of file to save to. Default 'pdf'

if ~isfield(options, 'subject') || isempty(options.subject)
  options.subject = 1 : length(E.filenames);
end
if ~isfield(options, 'band')
  options.band = 1;
else
  if ischar(options.band)
    options.band = find(ismember(E.bands.labels, options.band));
  end
end
if ~isfield(options, 'chanlabels')
  options.ticks = 1:length(E.channels.labels);
  options.chanlabels = E.channels.labels;
else
  if iscell(options.chanlabels) || ...
    (~strcmp(options.chanlabels, 'average') && ~strcmp(options.chanlabels, 'median'))
    options.chanindices = ismember(E.channels.labels, options.chanlabels);
  end
end
if ~isfield(options, 'chanindices')
  options.chanindices = 1:length(E.channels.labels);
end
if ~isfield(options, 'fontsize')
  options.fontsize = 20;
end
if ~isfield(options, 'linewidth')
  options.linewidth = 2;
end
if ~isfield(options, 'scale')
  options.scale = 'maxmin';
end
if ~isfield(options, 'colormap')
  options.colormap = 'hot';
end
if ~isfield(options, 'colorbar')
  options.colorbar = true;
end
if ~isfield(options, 'showtitle')
  options.showtitle = true;
end
if ~isfield(options, 'plottype')
  options.plottype = 'matrix';
end
if ~isfield(options, 'save')
  options.save = [];
else
  if ~isfield(options, 'savetype')
    options.savetype = 'pdf';
  end
end

end