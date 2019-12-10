function [normalised] = normalise(data, headers)
%NORMALISE Rescales values per column between 0 and 1.
%   [normalised] = NORMALISE(cell_array, headers) calculates the z-score,
%   after which it uses the sigmoid function to rescale all values per
%   column between 0 and 1. NaN values are ignored in the calculation.
%
%   headers is a two element logical vector, first element indicates
%   whether the cell array has row headers (to be ignored) and the second
%   indicates if the cell array has column headers (also to be ignored).
%
%   See also ZSCORE and LOGSIG.
%
%   # Jorne Laton #
%   # v2014.08.25 #

if iscell(data)
    headers = logical(headers);
    matrix = cell2mat(data(1 + headers(1) : end, 1 + headers(2) : end));
else
    matrix = data;
end
% Standardise
if any(any(isnan(matrix)))
    means = nanmean(matrix);
    means = means(ones(size(matrix, 1), 1), :);
    stds = nanstd(matrix);
    stds = stds(ones(size(matrix, 1), 1), :);
    matrix = (matrix - means)./stds;
else
    matrix = zscore(matrix);
end
% Sigmoidise
matrix = logsig(matrix);
% Reformat back to original cell
if iscell(data)
    normalised = data;
    normalised(1 + headers(1) : end, 1 + headers(2) : end) = num2cell(matrix);
end

end

