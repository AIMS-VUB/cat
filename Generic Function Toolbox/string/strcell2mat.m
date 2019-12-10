function rmat = strcell2mat(tcell)
%STRCELL2MAT smooth cell array to matrix conversion
%	rmat = STRCELL2MAT(tcell) makes sure all rows in the cell array have
%	the same length, padding it with spaces. This way it is possible to use
%	a matrix instead of a cell array.

maxSize = max(cellfun(@numel,tcell));    %# Get the maximum vector size
fcn = @(x) [x blanks(maxSize-numel(x))];  %# Create an anonymous function
rmat = cellfun(fcn,tcell,'UniformOutput',false);  %# Pad each cell with spaces
rmat = vertcat(rmat{:});                  %# Vertically concatenate cells