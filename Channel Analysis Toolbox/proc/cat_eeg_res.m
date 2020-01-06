function EEG_OUT = cat_eeg_rest(EEG, G)
% CAT_SET_REST Reference electrode standardisation technique
%
%   EEG_OUT = CAT_SET_REST(EEG, G)
%
%   EEG         eeg data containing channels x signals, referenced to average
%   G           lead-field matrix. Can be generated with Leadfield.exe and 3D
%               electrode location txt file
%   EEG_OUT   eeg data with reference transformed to reference at infinity
%
%   Based on Dong et al. 2017.

disp('Standardising average reference')

EEG_OUT = EEG;

% Leadfield matrix relative to its average
Gar = G - repmat(mean(G),size(G,1),1);

% Transformation of recordings
EEG_OUT.data = G * pinv(Gar, 0.05) * EEG.data;

EEG_OUT.data = EEG.data + repmat(mean(EEG_OUT.data),size(G,1),1); % V = V_avref + AVG(V_0)

EEG_OUT.ref = 'REST';