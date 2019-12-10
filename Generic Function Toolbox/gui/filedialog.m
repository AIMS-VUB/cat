function path = filedialog(type, pattern, title)
%FILEDIALOG uigetfile and uiputfile in one
%
%   path = FILEDIALOG(type)
%   path = FILEDIALOG(type, pattern)
%   path = FILEDIALOG(type, pattern, title) is a wrapper around both uigetfile
%   and uiputfile and is created for convenience.
%
% Input parameters
%   type      string with possible values "open" or "o" for opening a file
%             with uigetfile and "save" or "s" for saving a file using uiputfile.
%   pattern   regular expression which can be used to specify file type, or
%             (parts of) the filename. For example: '*.txt' to show only txt files,
%             or 'example*.*' to show all files starting with 'example'.
%   title     title of the dialogue window
%
% Output parameter
%   path      full path of the eventually chosen file
%
%	See also UIGETFILE and UIPUTFILE.

% # 2018.02.13 Jorne Laton #

if nargin < 3
    title = '';
    if nargin < 2
        pattern = '';
    end
end

switch type
    case {'open', 'o'}
        f = @uigetfile;
    case {'save'; 's'}
        f = @uiputfile;
    otherwise
        error('Possible values for type: "open", "o" and "save", "s".'); 
end

[name, folder] = f(pattern, title);
if name == 0
    path = 0;
else
    path = fullfile(folder, name);
end

end