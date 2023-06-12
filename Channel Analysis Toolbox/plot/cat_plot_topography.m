function cat_plot_topography(E, type, subtype, options)
%CAT_PLOT_TOPOGRAPHY topography of anything in 
%
%   CAT_PLOT_EDGES(E, options) plots one of the edge types calculated and
%   stored in E, in an adjacency matrix or a head-in-head plot together with the
%   channel labels in their order as stored in E. Plot options can be given
%   through the struct options.
%
% Input
%   E       standard CAT struct, with a field name equal to edgetype
%   type    'timeseries' or 'spect', corresponding to the fields in E
%   subtype options: 'epochs' for timeseries, 'bandpower' or 'peaks' for
%               spect
%   options see CAT_PLOT_CHECKOPTIONS for all general plotting fields
%
%   See also CAT_PLOT_CHECKOPTIONS.

%   #2023.05.03 Jorne Laton#

% Prepare all required optional settings and set defaults
if nargin < 4
  options = [];
end
options = cat_plot_checkoptions(E, options);
if (isvector(options.scale) && length(options.scale) == 2)
    options.scale = options.scale - 0.5; % little correction because topoplot fucks around
end
    
if (strcmp(type, 'timeseries'))
    subtype = 'epochs';
end

if length(options.subject) > 1
  subjectname = [E.group ' average'];
else
  subjectname = E.filenames{options.subject}(1:end-4);
end

options.mytext = strrep([subjectname ' ' E.paradigm ' ' E.event ' ' subtype], '_', ' ');
D = E.(type).(subtype);

switch subtype
    case 'peaks'
        D = D.freqs(:, options.band, options.subject);
        D = squeeze(mean(D, 3));
        bandlabel = [E.spect.peaks.bandlabels{options.band} ' '];
    case 'bandpower'
        D = D.average(:, options.band, options.subject);
        D = squeeze(mean(D, 3));
        bandlabel = [E.spect.bandpower.labels{options.band} ' '];
    otherwise % timeseries, not yet implemented
end
options.mytext = [options.mytext ' ' bandlabel];

topoplot(D, E.channels.eeglablocs, 'maplimits', options.scale);
if (options.colorbar); colorbar; end
set(gca, 'FontSize', options.fontsize)
set(findall(gcf, 'type', 'text'), 'fontSize', options.fontsize)
colormap(options.colormap)
if (options.showtitle); title(options.mytext); end

% Save it
if options.save
  filepath = fullfile(options.save, [strrep([E.paradigm '_' E.event], ' ', '_') '_' ...
    strrep(subjectname, ' ', '_') '_' num2str(options.band)...
    E.bands.labels{options.band} '_' edgetype]);
  if strcmp(options.savetype, 'pdf')
    save2pdf(filepath);
  else
    saveas(gcf, filepath, options.savetype);
  end
end