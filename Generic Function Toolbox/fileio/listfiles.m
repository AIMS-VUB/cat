function [filepaths, filenames] = listfiles(folder, pattern, recursive)
%LISTFILES lists files in a folder
%   filenames = listfiles(folder, pattern, recursive) is a wrapper
%   around the built-in non-recursive Matlab function dir and the recursive
%   subdir function and works in a similar way.
%
%   folder      folder to search
%   pattern     regular expression to select particular files, or descend one
%               level. Usage examples:
%               '*.mat' selects all .mat files directly under folder
%               '*\*.mat' selects only .mat files in subfolders directly under
%               folder
%   recursive   set to find files in all subfolders, on all levels
%
%   filepaths   list of full filenames
%   filenames   list of filenames, without containing folders. Is the same
%               as filepaths when recursive is set.
%
%   See also DIR and SUBDIR.

%   # 2018.04.06 Jorne Laton #

if nargin > 2 && recursive
    f = @subdir;
else
  recursive = false;
    f = @dir;
    if nargin < 2
      pattern = '*.*';
    end
end

files = f(fullfile(folder, pattern));
files = files(~ [files.isdir]);
filenames = {files.name}';

if recursive
  filepaths = filenames;
else
  filepaths = fullfile({files.folder}', filenames);
end