function cat_plot_cohensd(E1, E2, edgetype, options)
%CAT_PLOT_COHENSD Plot Cohen's D between two sets' edges
%
%   CAT_PLOT_COHENSD(E1, E2, options)
%

%   #2018.11.27 Jorne Laton#

if nargin < 4
  options = [];
end
options = cat_plot_checkoptions(E1, options);

M1.subjects = cat_extractsubjects(E1, edgetype, options);
options2 = options;
options2.subject = [];
options2 = cat_plot_checkoptions(E2, options2);
M2.subjects = cat_extractsubjects(E2, edgetype, options2);

subj_dim = ndims(M1.subjects);

M1.mean = mean(M1.subjects, subj_dim);
M2.mean = mean(M2.subjects, subj_dim);
M1.std = std(M1.subjects, [], subj_dim);
M2.std = std(M2.subjects, [], subj_dim);
M1.n_subj = size(M1.subjects, subj_dim);
M2.n_subj = size(M2.subjects, subj_dim);

C = cohensd(M1.mean, M2.mean, M1.std, M2.std, M1.n_subj, M2.n_subj);
C(isnan(C)) = 0;

if isfield(options, 'corrected') && options.corrected
  [~, P] = ttest2(M1.subjects, M2.subjects, 'dim', subj_dim);

  P(isnan(P)) = 1;
  logP = -log10(P);
  logP(logP==Inf) = max(max(logP(isfinite(logP))));
  n = length(logP);
  siglevel = options.corrected * 0.05/n/(n-1);
  if isnumeric(options.corrected) && options.corrected < 1
    siglevel = options.corrected;
  end
  bonferroni = -log10(siglevel);
  C(logP < bonferroni) = 0;
end

if strcmp(edgetype, 'correlation')
  bandlabel = '';
  bandnum = '';
else
  bandlabel = [E1.bands.labels{options.band} ' '];
  bandnum = ['_' num2str(options.band)];
end

options.mytext = {[E1.group '-' E2.group ' ' E1.paradigm ' ' E1.event], [bandlabel edgetype], ...
  'Cohen''s D'};

switch options.plottype
  case 'headinhead'
    showcs(C, E1.channels.positions, options);
  case 'network'
    hold on
    if strcmp(edgetype, 'dtf')
      G = digraph(C', E1.channels.labels, 'omitselfloops');
    else
      G = graph(C', E1.channels.labels, 'omitselfloops');
    end
    p = plot(G, 'XData', E1.channels.positions(:, 1), 'YData', E1.channels.positions(:, 2));
    p.LineWidth = 2;
    colormap whitejet_symm;
    colorbar
    lim = max(abs(G.Edges.Weight));
    caxis([-lim, lim]);
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
      imagesc(C, options.scale)
    else
      imagesc(C)
    end
    if isfield(options, 'lines')
      for l = 1 : length(options.lines)
        xline(options.lines(l));
        yline(options.lines(l));
      end
    end
    colorbar
    colormap(options.colormap)
    title(options.mytext)
    set(gca, 'XTick', options.ticks, 'XTickLabel', options.chanlabels)
    set(gca, 'YTick', options.ticks, 'YTickLabel', options.chanlabels)
    xtickangle(90)
    format_figure();
end

% Save it
if options.save
  if ~isfield(E1, 'paradigm')
    E1.paradigm = '';
  else
    E1.paradigm = [E1.paradigm '_'];
  end
  if ~isfield(E1, 'event')
    E1.event = '';
  else
    E1.event = [E1.event '_'];
  end
  savepath = fullfile(options.save, [E1.paradigm E1.event E1.group '-' E2.group ...
      bandnum strrep(bandlabel, ' ', '') '_' edgetype  '_cohensd']);
  savepath = strrep(savepath, ' ', '_');
  if isfield(options, 'savetype') && ~strcmp(options.savetype, 'pdf')
    saveas(gcf, savepath, options.savetype);
  else
    save2pdf(savepath);
  end
end

end