function cat_eeg_importevents(src_folder, pattern, append)
%CAT_EEG_IMPORTEVENTS - Adds events from evt files to the according set files
%
%   CAT_EEG_IMPORTEVENTS(folder) adds events stored in event files (.evt) in a folder to
%   the according set files (.set) in the same folder. The alphabetical order of these
%   two collections of files or the filenames of each pair should be the same to link the correct
%   files to each other.
%
%   src_folder  folder from which the files are retrieved
%   append      ['yes', 'no'] add the events to the existing events. Default 'yes'.
%
%   The layout of the .evt files should be as follows, with one tab between the columns, latencies
%   and durations in seconds.
%   type  latency   duration
%   EventType1  x1  y1
%   EventType2  x2  y2
%   EventType1  x3  y3
%
%   There is an example of an .evt file in /proc.
%
%   See also POP_LOADSET and POP_IMPORTEVENT.

%   #2019.04.05 Jorne Laton#

% TODO make robust against lacking event files

if nargin < 3
  append = 'yes';
  if nargin < 2
    pattern = '*.evt';
  end
end

setfiles = listfiles(src_folder, '*.set');
evtfiles = listfiles(src_folder, pattern);
n_files = length(setfiles);
eegs = cell(n_files, 1);
eventfields = {'type' 'latency' 'duration'};

%%
for f = 1 : n_files
  eegs{f} = pop_loadset(setfiles{f});
  eegs{f} = eeg_checkset(eegs{f});
  eegs{f} = pop_importevent(eegs{f}, 'event', evtfiles{f}, 'fields', eventfields, ...
    'skipline', 1, 'timeunit', 1, 'append', append);
  eegs{f} = eeg_checkset(eegs{f});
  eegs{f} = pop_saveset(eegs{f}, 'filepath', src_folder, 'filename', eegs{f}.filename);
end