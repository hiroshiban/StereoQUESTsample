% ************************************************************
% This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% Oblique3D_QUEST.m
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2018-10-29 13:49:42 ban"
% ************************************************************

% "sparam" means "stimulus generation parameters"

%%% load the common parameters
run(fullfile(fileparts(mfilename('fullpath')),'oblique3d_stimulus_common'));

%%% overwrite some parameters specific to this configuration.

sparam.mask_orient_deg  = 90; % for masking, tilted orientation of the slant in deg, from right horizontal meridian, CCW

sparam.theta_deg    = [-52.5,  37.5];
sparam.orient_deg   = [   90,    90];
sparam.mask_type    = { 'XY',  'XY'};
sparam.mask_orient_id=[    1,     1];
