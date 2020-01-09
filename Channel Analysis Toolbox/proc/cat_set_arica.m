function eeg = cat_set_arica(setpath, options)

%   .ica        perform ICA for artefact rejection. Optional algorithms: 'runica' or 'binica'.
%   .automark   automatically mark components for removal. Optional algorithms: 'mara'.

  eeg = pop_loadset('filename', setpath);
  eeg = eeg_checkset( eeg );
  eeg = pop_select( eeg, 'nochannel',{'EKG' 'Test'});
  eeg = eeg_checkset( eeg );

  eeg = pop_eegthresh(eeg,1,[1:12 14 15:18 20 21:64] ,-200,200,-0.199,0.79688,2,0);
  eeg = pop_rejepoch( eeg, 90,0);
  eeg = eeg_checkset( eeg );
  
  eeg = pop_runica(eeg, 'icatype', 'binica', 'extended',1);
  eeg = eeg_checkset( eeg );
  
  eeg = pop_subcomp( eeg, [1  4], 0);
  eeg = eeg_checkset( eeg );
  
  eeg = pop_select( eeg, 'nochannel',{'A1' 'A2' 'HEOG' 'VEOG'});
  eeg = eeg_checkset( eeg );
  
  % Perform ICA if requested
if isfield(options, 'ica')
    eeg = pop_runica(eeg,'icatype',options.ica,'extended',1,'verbose','off'); 
end

% Automatically mark ICA components to reject
if isfield(options, 'automark')

    switch options.automark
      case 'mara'
        % selected components are stored in EEG.reject.gcompreject
        [~,eeg] = processMARA([],eeg);
      otherwise
        [~,eeg] = processMARA([],eeg);
    end
end

end