function n = findfile(path, values)
%FINDFILE sort of find for files
%   n = FINDFILE(path, values) returns the number of occurences of any of
%   the values in the file.
%
%   values is a string or a cell array of strings
%
%   See also TEXTSCAN, FINDCELL.

fileID = fopen(path);
triggers = textscan(fileID, '%s');
triggers = triggers{:};
n = length(findcell(triggers, values));
fclose(fileID);