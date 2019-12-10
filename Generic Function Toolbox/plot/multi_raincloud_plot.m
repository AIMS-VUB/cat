%% multi_raincloud_plot - plots a combination of half-violin, boX1plot,  and raw
% datapoints (n x 1d scatter).
% Use as h = raincloud_plot(X1, cl1, X2, cl2), where X is a data vector and cl is an
% RGB value. h is a cell array of handles for the various figure parts.
% Based on https://micahallen.org/2018/03/15/introducing-raincloud-plots/
% Inspired by https://m.Xkcd.com/1967/
% Thanks to Jacob Bellmund for some improvements
% Made by Tom Rhys Marshall
% adapted by Johan Baijot 

function h = multi_raincloud_plot(varargin)
if mod(nargin,2)
    disp('invalid input: give data vector then a RGB value repeat for multiple inputs');
else
    hi=1;
    n=nargin/2;
   for i=1:n
    X=varargin{i*2-1};
    cl=varargin{i*2};
    % calculate kernel density
    [f, Xi] = ksdensity(X);
    % density plot
    h{hi} = area(Xi, f); hold on
    set(h{hi}, 'FaceColor', cl, 'FaceAlpha',.4);
    set(h{hi}, 'EdgeColor', [0.1 0.1 0.1],'EdgeAlpha',.4);
    set(h{hi}, 'LineWidth', 2);
    hi=hi+1;   
   end
    % make some space under the density plot for the boX1plot
    yl = get(gca, 'YLim');
    set(gca, 'YLim', [-yl(2)/2 yl(2)]);
    yl(2)=yl(2)/2;
    % width of boX1plot
    wdth = yl(2)*1/(n+1);
   for i=1:n
    X=varargin{i*2-1};
    cl=varargin{i*2};
    % jitter for raindrops
    jit = (rand(size(X)) - 0.5) * wdth;
    % info for making boxplot
    Y = quantile(X, [0.25 0.75 0.5 0.02 0.98]);
    % raindrops
    h{hi} = scatter(X, jit - yl(2)*i/(n+1));
    h{hi}.SizeData = 10;
    h{hi}.MarkerFaceColor = cl;
    h{hi}.MarkerEdgeColor = 'none';
    hi=hi+1; 
    % 'box' of 'boxplot' X1
    h{hi} = rectangle('Position', [Y(1) -yl(2)*i/(n+1)-(wdth*0.5) Y(2)-Y(1) wdth]);
    set(h{hi}, 'EdgeColor', 'k')
    set(h{hi}, 'LineWidth', 2);
    hi=hi+1; 
    % could also set 'FaceColor' here as Micah does, but I prefer without
    
    % mean line
    h{hi} = line([Y(3) Y(3)], [-yl(2)*i/(n+1)-(wdth*0.5) -yl(2)*i/(n+1)+(wdth*0.5)], 'col', 'k', 'LineWidth', 2);
    hi=hi+1; 

    % whiskers
    h{hi} = line([Y(2) Y(5)], [-yl(2)*i/(n+1) -yl(2)*i/(n+1)], 'col', 'k', 'LineWidth', 2);
    hi=hi+1; 
    h{hi} = line([Y(1) Y(4)], [-yl(2)*i/(n+1) -yl(2)*i/(n+1)], 'col', 'k', 'LineWidth', 2);
    hi=hi+1; 
   end   
end
