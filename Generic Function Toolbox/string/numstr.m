function S = numstr(string, range)
%NUMSTR Appends numbers to a string
%   S = NUMSTR(string, range) appends every number in range to string,
%   resulting in a cell array of this string with the same number of
%   elements as in range.

s = size(range);
if s(1) < s(2)
  range = range';
end

S = strcat({string}, num2str(range));
S = strrep(S, ' ', '0');

end

