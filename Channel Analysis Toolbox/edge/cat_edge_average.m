function E = cat_edge_average(E, edge)

left_ind = E.channels.positions(:, 1) < median(E.channels.positions(:, 1));
right_ind = ~left_ind;
ind = [find(left_ind); find(right_ind)];

edges = E.edges.(edge).average(ind, ind, :, :);
edges = permute(edges, [4, 3, 1, 2]);
half = length(E.channels.labels) / 2;

LL = edges(:, :, 1 : half, 1 : half);
RR = edges(:, :, half + 1 : end, half + 1 : end);
LR = edges(:, :, 1 : half, half + 1 : end);
RL = edges(:, :, half + 1 : end, 1 : half);

E.edges.(edge).simple.average.left_hemisphere = mean(LL(:, :, :), 3);
E.edges.(edge).simple.standev.left_hemisphere = std(LL(:, :, :), [], 3);

E.edges.(edge).simple.average.right_hemisphere = mean(RR(:, :, :), 3);
E.edges.(edge).simple.standev.right_hemisphere = std(RR(:, :, :), [], 3);

E.edges.(edge).simple.average.intrahemispheric = mean(cat(3, LL(:, :, :), RR(:, :, :)), 3);
E.edges.(edge).simple.standev.intrahemispheric = std(cat(3, LL(:, :, :), RR(:, :, :)), [], 3);

E.edges.(edge).simple.average.interhemispheric = mean(cat(3, LR(:, :, :), RL(:, :, :)), 3);
E.edges.(edge).simple.standev.interhemispheric = std(cat(3, LR(:, :, :), RL(:, :, :)), [], 3);