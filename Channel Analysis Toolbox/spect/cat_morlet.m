function E = cat_morlet(E)
%CAT_MORLET - Morlet wavelet transform of the time signals in E
%
%   Calculates the Morlet wavelet transform of the time signals (columns) in
%   E.epochs. Adds the field 'morlet' to E.
%
%   E = CAT_MORLET(E)
%
%   E is a struct containing the fields 'timeseries.epochs', 'fs' and 'timeseries.average',
%   epochs is a 4D matrix , with signals in the 1st dim, location in dim 2, epochs in
%   dim 3 and subjects in dim 4.
%   average is a 3D matrix, with signals in dim 1, locations in dim 2
%   and subjects in dim 3.
%   
%   A new field morlet is added to E. This is a cell array, in which each cell
%   contains a struct with the results of the wavelet transform of one
%   signal. In this cell array, rows are patients, columns are channels.
% 
%   See also CWTFT.
% 
%   #2018.11.27 Jorne Laton#

[~, n_channel, n_patient] = size(E.timeseries.average);

E.morlet = cell(n_patient, n_channel);

for k = 1 : n_patient
    for j = 1 : n_channel
        sig.val = E.timeseries.average(:, j, k);
        sig.period = 1/E.fs;
        E.morlet{k, j} = cwtft(sig);
        E.morlet{k, j}.cfs = abs(E.morlet{k, j}.cfs);
    end
end
