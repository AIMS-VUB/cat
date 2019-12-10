function cat_plot_edges(E, edgetype, options)
%CAT_PLOT_EDGES plots the edges in an adjacency matrix or head-in-head plot
%
%   CAT_PLOT_EDGES(E, options) plots one of the edge types calculated and
%   stored in E, in an adjacency matrix or a head-in-head plot together with the
%   channel labels in their order as stored in E. Plot options can be given
%   through the struct options.
%
% Input
%   E         standard CAT struct, with a field name equal to edgetype
%   edgetype  any of the following:
%             String name   Type                        Function         
%             'correlation' Pearson correlation         cat_edge_correlation
%             'mutualinfo'  mutual information          cat_edge_mutualinfo
%             'pli'         phase lag index             cat_edge_pli
%             'coherence'   absolute coherency          cat_edge_coherence
%             'imagcoh'     imaginary coherency         cat_edge_imagcoh
%             'dtf'         directed transfer function	cat_edge_dtf
%   options   see CAT_PLOT_CHECKOPTIONS for all general plotting fields
%
%   See also CAT_PLOT_CHECKOPTIONS.

%   #2019.03.15 Jorne Laton#

% Prepare all required optional settings and set defaults
if nargin < 3
  options = [];
end
options = cat_plot_checkoptions(E, options);

M = cat_extractsubjects(E, edgetype, options);
M = mean(M, 4);
if isfield(options, 'smooth_auto') && options.smooth_auto
  M(logical(eye(size(M)))) = mean(M);
end

if isfield(options, 'remove_auto') && options.remove_auto
  M(logical(eye(size(M)))) = 0;
end

if isfield(options, 'edge_threshold')
  M(M < options.edge_threshold) = 0;
end

if length(options.subject) > 1
  subjectname = [E.group ' Average'];
else
  subjectname = E.filenames{options.subject}(1:end-4);
end

bandlabel = [E.bands.labels{options.band} ' '];


options.mytext = {[subjectname ' ' E.event], [bandlabel edgetype]};

switch options.plottype
  case 'headinhead'
    if ~isfield(options, 'head_right')
      options.head_right = 0;
    end
    if isempty(options.scale)
      m = max(max(abs(M)));
      options.scale = [-m, m];
    end
    showcs(M, E.channels.positions, options);
  case 'network'
    hold on
    if strcmp(edgetype, 'dtf')
      G = digraph(M', E.channels.labels, 'omitselfloops');
    else
      G = graph(M', E.channels.labels, 'omitselfloops');
    end
    p = plot(G, 'XData', E.channels.positions(:, 1), 'YData', E.channels.positions(:, 2));
    p.LineWidth = 2;
%     cm = whitejet_symm;
%     cm = cm(end/2:end, :);
    colormap(options.colormap);
    colorbar
%     lim = max(abs(G.Edges.Weight));
    caxis(options.scale);
    p.EdgeCData = G.Edges.Weight;
    p.EdgeAlpha = 0.9;
%     p.EdgeColor = [G.Edges.Weight>0, zeros(height(G.Edges), 1), G.Edges.Weight<0];
    p.NodeFontSize = options.fontsize;
    try
      p.ArrowSize = 15;
    catch
    end
    text(-0.5, 0.45, options.mytext);
    hold off
    axis off
    format_figure(options);
  otherwise
    if ~isempty(options.scale)
      imagesc(M, options.scale)
    else
      imagesc(M)
    end
    colorbar
    set(gca, 'XTick', options.ticks, 'XTickLabel', options.chanlabels)
    set(gca, 'YTick', options.ticks, 'YTickLabel', options.chanlabels)
    xtickangle(90)
    set(gca, 'FontSize', options.fontsize)
    set(findall(gcf, 'type', 'text'), 'fontSize', options.fontsize)
    axis square
    colormap(options.colormap)
    title(options.mytext)
end

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