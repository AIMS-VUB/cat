function E = cat_spect_cordance(E)
n_band = length(E.spect.bandpower.labels);
n_chan = length(E.channels_labels);

T = sum(E.spect.bandpower.amps, 3);

R = E.spect.bandpower.ampls./repmat(T, [1 1 n_band]);

A_max = max(E.spect.bandpower.ampls, [], 2);
R_max = max(R, [], 2);

A_norm = E.spect.bandpower.ampls./repmat(A_max, [1 n_chan 1]);
R_norm = R./repmat(R_max, [1 n_chan 1]);

concord = (R_norm > 0.5) .* (- (A_norm < 0.5) + (A_norm > 0.5));
E.spect.cordance = concord.*(abs(A_norm - 0.5) + abs(R_norm - 0.5));