function draw_head
grey = [0.7, 0.7, 0.7];
plot([-0.4, 0.4], [0, 0], 'LineWidth', 2, 'Color', grey)
quiver(0, -0.4, 0, 0.95, 'LineWidth', 2, 'Color', grey)
viscircles([0, 0], 0.4, 'LineWidth', 2, 'Color', grey, 'EnhanceVisibility', false);

end

