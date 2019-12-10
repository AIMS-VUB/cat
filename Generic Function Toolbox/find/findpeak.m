function [xpeak, ypeak, forced] = findpeak(x, y, options)
%FINDPEAK search interval for peak
%
%   [xpeak, ypeak, forced] = FINDPEAK(x, y, options)
%     looks for the largest upward peak in y.
%
% Input
%   x, y      data vectors
%   options   optional parameter struct, with the following optional fields
%   interval  interval in x to search for the peak in y.
%             Searches the complete vector if omitted.
%   direction +1 for a positive (default) and -1 for a negative peak
%   force     if set to 'smallestderivative' and there are no peaks found with
%							the regular method, then the interval is halved with the same
%							center and the point with the	smallest derivative is returned.
%							This point will have the closest resemblance to a peak.
%							If set to 'weightedcentre', the x value is returned, for which the
%							sum of the y values corresponding to a smaller x value is as close
%							as possible to the sum of the y values with a larger x value.
%
% Output
%   xpeak, ypeak  coordinates of the peak
%   forced    whether the peak was forced using one of the force methods. Equal
%             to 1 for smallestderivative, 2 for weightedcentre.
%
%   See also FINDPEAKS.

% #2018.07.17 Jorne Laton#

if nargin < 3
  options = [];
end

if ~isfield(options, 'force')
  options.force = 'none';
end
if ~isfield(options, 'direction')
  options.direction = 1;
end
if ~isfield(options, 'interval')
  options.interval = [-Inf, +Inf];
end
if ~isfield(options, 'deviation')
  options.deviation = 1;
end

options.direction = sign(options.direction);
subset = x > options.interval(1) & x < options.interval(2);
subset_x = x(subset);
subset_y = y(subset);

[peaks, locs] = findpeaks(options.direction*subset_y);

forced = false;
[ypeak, ind] = max(peaks);
if ~isempty(ypeak) && ypeak > options.deviation*mean(options.direction*subset_y)
  ypeak = options.direction*ypeak;
  xpeak = subset_x(locs(ind));
else
  switch options.force
    case 'smallestderivative'
      forced = 1;
      i_start = round(length(subset_x)/4);
      subset_x = subset_x(i_start : 3*i_start);
      subset_y = subset_y(i_start : 3*i_start);
      d = diff(subset_y)./diff(subset_x);
      [~, i] = min(d);
      ypeak = subset_y(i);
      xpeak = subset_x(i);
    case 'weightedcentre'
      forced = 2;
      c = weightedcentre(subset_y);
      ypeak = subset_y(c);
      xpeak = subset_x(c);
    otherwise
      ypeak = NaN;
      xpeak = NaN;
  end
end
