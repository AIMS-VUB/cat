function cat_set_importevents(setfolder, append)
%CAT_SET_IMPORTEVENTS - Adds events from evt files to the according set files
%
%   CAT_SET_IMPORTEVENTS(folder) adds events stored in event files in a folder to
%   the according set files in the same folder. The alphabetical order of these
%   two collections of files should be the same to link the correct files to
%   each other.
%
%   setfolder   folder from which the files are retrieved
%   append      ['yes', 'no'] add the events to the existing events. Default
%               'yes'
%
%   See also POP_LOADSET and POP_IMPORTEVENT.

%   #2019.04.05 Jorne Laton#

if nargin < 2
  append = 'yes';
end

setfiles = listfiles(setfolder, '*.set');
evtfiles = listfiles(setfolder, '*.evt');
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
  eegs{f} = pop_saveset(eegs{f}, 'filepath', setfolder, 'filename', eegs{f}.filename);
end