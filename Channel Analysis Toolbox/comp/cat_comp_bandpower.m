function D = cat_comp_bandpower(E1, E2, options)
%CAT_COMP_BANDPOWER Subtract E1 bandpower from E2
%
%   Calculates the difference between the spectral power in different bands
%   in two measurements of the same participant. The same number of
%   measurements and the same order is assumed in E1 and E2.
%
%   D = CAT_COMP_BANDPOWER(E1, E2, options)
%
%Input
%   E1, E2      struct containing the field spect.bandpower
%   options     optional struct containing the following optional fields:
%   Field       Value
%   type        Possible values: 'average' (default) or 'percentage'
%
%Output
%   D           matrix with differences between E2 and E1 per participant

%

if nargin < 3
    options = [];
end
if (~isfield(options, 'type'))
    options.type = 'average';
end

D = E2.spect.bandpower.(options.type) - E1.spect.bandpower.(options.type);

end

