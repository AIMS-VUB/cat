function cat_plot_cohensd_leftright(E, edgetype, options)
%CAT_PLOT_COHENSD_LEFTRIGHT Plot Cohen's D between left and right connections
%
%   M = CAT_PLOT_COHENSD_LEFTRIGHT(E, options)
%
%   This function assumes that the electrodes are sorted: the electrodes on the
%   left, followed by their symmetrical electrodes on the right.

%   #2018.05.29 Jorne Laton#

if ~isfield(options, 'colormap')
  try
    options.colormap = whitejet_symm;
  catch
    warning('Cohen`s D is best viewed with the blue-black-orange colormap. Defaulting to jet.')
    options.colormap = 'jet';
  end
end
options = cat_plot_checkoptions(E, options);
options.getepochs = true;

M = cat_extractsubjects(E, edgetype, options);
left = M(1 : end/2, 1 : end/2, :, :, :);
right = M(end/2+1 : end, end/2+1 : end, :, :, :);

left_mean = mean(left, 3);
right_mean = mean(right, 3);
left_std = std(left, [], 3);
right_std = std(right, [], 3);
[~, n_chan, n_epoch] = size(M);
n_test = n_chan*(n_chan - 1)/2;

C = cohensd(left_mean, right_mean, left_std, right_std, n_epoch, n_epoch);
if isfield(options, 'signif')
  if ~isnumeric(options.signif)
    options.signif = 0.05/n_test; % Bonferroni
  end    
  H = ttest2(left, right, 'dim', 3, 'alpha', options.signif);
  C = C.*H;
end
% C(eye(size(C), 'logical')) = 0;

subjectname = E.filenames{options.subject}(1 : end-4);
plottitle = [subjectname ' ' E.bands.labels{options.band} ' ' edgetype ' Cohen`s D'];

if ~isempty(options.scale)
  imagesc(C, options.scale)
else
  imagesc(C)
end
colorbar

leftrightlabels = strcat(options.chanlabels(1 : end/2), '|', ...
  options.chanlabels(end/2+1 : end));

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
  save2pdf(fullfile(options.save, [E.paradigm E.event subjectname ...
    '_' E.bands.labels{options.band} '_' edgetype '_cohensd']));
end