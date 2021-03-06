function [filepaths, filenames] = listfiles(folder, pattern, recursive, filter)
%LISTFILES lists files in a folder
%   [filepaths, filenames] = listfiles(folder, pattern, recursive) is a wrapper
%   around the built-in non-recursive Matlab function dir and the recursive
%   subdir function and works in a similar way.
%
%   folder      folder to search
%   pattern     simple pattern to select particular files, or descend one
%               level. Usage examples:
%               '*.mat' selects all .mat files directly under folder
%               '*\*.mat' selects only .mat files in subfolders directly under
%               folder
%   recursive   set to find files in all subfolders, on all levels
%   filter      regular expression used to filter files. If filename does
%               not match the file is ommitted from the list (see REGEXP)
%
%   filepaths   list of full filenames
%   filenames   list of filenames, without containing folders. Is the same
%               as filepaths when recursive is set.
%
%   See also DIR and SUBDIR.
%
%   # 2021.03.06 Alexander De Cock #

% set default arguments
if ~exist('recursive','var') || isempty(recursive)
    recursive = false;
end

if ~exist('filter','var') || isempty(filter)
    filter = '.*';
end

if ~exist('pattern','var') || isempty(pattern)
    pattern = '*.*';
end

% switch recursive on/off
if recursive
    f = @subdir;
else
    f= @dir;
end

% list all files which contain the pattern
files = f(fullfile(folder, pattern));
files = files(~ [files.isdir]);
filenames = {files.name}';

% filter filenames with regexp
filter = ~cellfun(@isempty,regexp(filenames, filter,'match', 'once'));

% apply filter
filenames = filenames(filter);
files = files(filter);

if recursive
  filepaths = filenames;
else
  filepaths = fullfile({files.folder}', filenames);
end