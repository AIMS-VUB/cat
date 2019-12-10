function cat_plot_signif_leftright(E, edgetype, options)
%CAT_PLOT_SIGNIF_LEFTRIGHT Plot significance of left-right difference
%
%   M = CAT_PLOT_SIGNIF_LEFTRIGHT(E, options)
%
%   This function assumes that the electrodes are sorted: the electrodes on the
%   left, followed by their symmetrical electrodes on the right.

%   #2018.05.29 Jorne Laton#

if ~isfield(options, 'colormap')
  options.colormap = 'hot';
end
options = cat_plot_checkoptions(E, options);
options.getepochs = true;

M = cat_extractsubjects(E, edgetype, options);
left = M(1 : end/2, 1 : end/2, :, :, :);
right = M(end/2 + 1 : end, end/2 + 1 : end, :, :, :);

subjectname = E.filenames{options.subject}(1:end-4);
plottitle = [subjectname ' ' E.bands.labels{options.band} ' ' edgetype ' significance'];

[~, P] = ttest2(left, right, 'dim', 3);

if ~isempty(options.scale)
  imagesc(-log10(P), options.scale)
else
  imagesc(-log10(P))
end
colorbar

leftrightlabels = strcat(options.chanlabels(1:end/2), '|', options.chanlabels(end/2 + 1 : end));

set(gca, 'XTick', options.ticks, 'XTickLabel', leftrightlabels)
set(gca, 'YTick', options.ticks, 'YTickLabel', leftrightlabels)
xtickangle(90)

set(gca, 'FontSize', options.fontsize)
set(findall(gcf, 'type', 'text'), 'fontSize', options.fontsize)
axis square
title(plottitle);
if isfield(options, 'ax')
  colormap(options.ax, options.colormap)
else
  colormap(options.colormap)
end

%% Save it
if options.save
  if ~isfield(E, 'paradigm')
    E.paradigm = '';
  else
    E.paradigm = [E.paradigm '_'];
  end
  if ~isfield(E, 'event')
    E.event = '';
  else
    E.event = [E.event '_'];
  end
  save2pdf(fullfile(options.save, [E.paradigm E.event E.group '-' E2.group ...
    '_' E.bands.labels{options.band} '_' edgetype '_signif']));
end

end