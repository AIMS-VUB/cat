function cat_plot_spect_ordered(E, channel)
%CAT_PLOT_SPECT_ORDERED - Spectral plot in ascending order of peak frequency
%
%   Plots the spectra of all instances in E in the specified channel. The
%   instances are ordered on their peak frequencies. Every instance's
%   spectrum is rescaled by the amplitude of this peak. Only the band in
%   which the peak was detected is shown.
%
%   CAT_PLOT_SPECT_ORDERED(E, channel)
%
%   E       is a struct containing spectra and spectral peaks
%   channel is a channel index or channel label. Other possible value is
%           'maxpeak', for which the channel with the largest peak for each
%           patient will be selected
%
%   See also CAT_SPECT, CAT_SPECTPEAKS, CAT_MAXPEAK

%   #2018.11.27 Jorne Laton#

name = [E.group ' channel ' channel];

subset = E.spect.freqs > E.spect.peaks.band(1) & E.spect.freqs < E.spect.peaks.band(2);
E.spect.freqs = E.spect.freqs(subset);
cols = sum(subset);

ind = find(strcmp(E.channels.labels, channel));
if ~isempty(ind)
	channel = ind;
end
if isnumeric(channel)
	E.spect.peaks.freq = E.spect.peaks.freq(:, channel);
	E.spect.average = squeeze(E.spect.average(channel, subset, :))';
	E.spect.average = E.spect.average./repmat(E.spect.peaks.amp(:, channel), 1, cols);
else
	if strcmp(channel, 'maxpeak')
		E.spect.peaks.freq = E.spect.peaks.max.freq;
		E.spect.average = permute(E.spect.average, [2, 1, 3]);
		s = size(E.spect.average);
		% Select channel with largest peak for each patient, instead of the
		% same channel for all, convert indices to linear on dimension 2 and 3
		ind = sub2ind(s(2:3), E.spect.peaks.max.ind, (1:length(E.spect.peaks.max.ind))');
		E.spect.average = E.spect.average(subset, ind)';
		E.spect.average = E.spect.average./repmat(E.spect.peaks.max.amp, 1, cols);
    else
        error(['Wrong value for parameter channel, optional values are '...
			'channel index, channel label or "maxpeak".']);
	end
end

[~, ind] = sort(E.spect.peaks.freq);

imagesc(E.spect.freqs, 1:size(E.spect.average, 1), ...
  E.spect.average(ind, :), [0 1.5])
xlabel('Frequency (Hertz)');
ylabel('Subject (Index)');
title(name);
colorbar
colormap('jet')