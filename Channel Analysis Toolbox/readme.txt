Solutions to bugs in EEGlab

To convert SPM files, comment or remove line 187 in ft_datatype_sens.m of the Fileio plugin:
  sens = ft_struct2double(sens, 1);
This line has become obsolete in Matlab versions 7 and above, as explained in the help of ft_struct2double.