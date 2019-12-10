function printtight(name, format)
%PRINTTIGHT removes annoying margins when saving plots
%
% Or should do that at least. It takes the current figure, and saves it to
% name. The format can be for instance '-dpdf' to print to pdf.
%
% See also: PRINT.
%
% #2016.08.18 Jorne Laton#

%%
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

%%
fig = gcf;

%%
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3)+0.2 fig_pos(4)+0.2];

% set(h,'Units','Inches');
% pos = get(h,'Position');
% set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3),pos(4)]);
%%
print(fig, name, format, '-r0');