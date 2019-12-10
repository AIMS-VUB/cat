function table = uixlsread(mode, dialoginfo, sheet)
%   list = UIXLSREAD(mode, dialoginfo) asks to select an Excel file via a
%   dialog box.
%
%   mode is a string with possible values 'num', 'txt' and 'raw', referring
%   to the output of XLSREAD.
%   dialoginfo is short info on what is to be selected.
%
%   See also XLSREAD.
%
%   # Jorne Laton #
%   # v2015.07.02 # 

if nargin < 3
  sheet = 1;
end

filename = filedialog('open', '*.xls*', dialoginfo);

switch mode
    case 'num'
        [table, ~, ~] = xlsread(filename, sheet);
    case 'txt'
        [~, table, ~] = xlsread(filename, sheet);
    case 'raw'
        [~, ~, table] = xlsread(filename, sheet);
    otherwise
        error('mode can only take the values "num", "txt" and "raw"');
end
