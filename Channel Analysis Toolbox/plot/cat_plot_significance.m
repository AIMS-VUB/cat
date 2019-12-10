function cat_plot_significance(E1, E2, edgetype, options)
%CAT_PLOT_SIGNIFICANCE Plot significance of difference between two sets' edges
%
%   M = CAT_PLOT_SIGNIFICANCE(E1, E2, edgetype, options)
%
%

%   #2018.11.27 Jorne Laton#

if nargin < 4
  options = [];
end
options = cat_plot_checkoptions(E1, options);

M1 = cat_extractsubjects(E1, edgetype, options);
options2 = options;
options2.subject = [];
options2 = cat_plot_checkoptions(E2, options2);
M2 = cat_extractsubjects(E2, edgetype, options2);

if size(E1.edges.correlation.epochs, 5) == 1 && ...
    strcmp(edgetype, 'correlation')
  bandlabel = '';
else
  bandlabel = [E1.bands.labels{options.band} ' '];
end

options.mytext = {[E1.group '-' E2.group ' ' E1.event], [bandlabel edgetype], ...
  'significance'};

[~, P] = ttest2(M1, M2, 'dim', 3);
P(isnan(P)) = 1;
logP = -log10(P);
logP(logP==Inf) = max(max(logP(isfinite(logP))));

switch options.plottype
  case 'headinhead'
    if isempty(options.scale)
      n = length(logP);
      bonferroni = -log10(0.1/n/(n-1));
      m = max(max(logP));
      if bonferroni > m
        bonferroni = m/2;
      end
      options.scale = [2*bonferroni-m, m];
    end
    showcs(logP, E1.channels.positions, options);
  otherwise
    if ~isempty(options.scale)
      imagesc(logP, options.scale)
    else
      imagesc(logP)
    end
    colorbar
    set(gca, 'XTick', options.ticks, 'XTickLabel', options.chanlabels)
    set(gca, 'YTick', options.ticks, 'YTickLabel', options.chanlabels)
    xtickangle(90)
    set(gca, 'FontSize', options.fontsize)
    set(findall(gcf, 'type', 'text'), 'fontSize', options.fontsize)
    axis square
    colormap(options.colormap)
    title(options.mytext);
end

%% Save it
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
  save2pdf(fullfile(options.save, [E1.paradigm E1.event E1.group '-' E2.group ...
    '_' num2str(options.band) E1.bands.labels{options.band} '_' edgetype '_signif']));
end

end