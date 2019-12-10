function format_figure(options)
axis square
set(gca, 'FontSize', options.fontsize)
set(findall(gcf, 'type', 'text'), 'fontSize', options.fontsize)
end