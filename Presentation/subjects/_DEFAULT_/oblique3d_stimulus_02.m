% ************************************************************
% This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% Oblique3D_QUEST.m
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2018-10-29 10:09:40 ban"
% ************************************************************

% "sparam" means "stimulus generation parameters"

%%% load the common parameters
run(fullfile(fileparts(mfilename('fullpath')),'oblique3d_stimulus_common'));

%%% overwrite some parameters specific to this configuration.

param.mask_orient_deg  = 22.5; % for masking, tilted orientation of the slant in deg, from right horizontal meridian, CCW

sparam.theta_deg    = sparam.theta_deg(9:1:16);
sparam.orient_deg   = sparam.orient_deg(9:1:16);
sparam.mask_type    = sparam.mask_type(9:1:16);
sparam.mask_orient_id=ones(1,8); % since sparam.mask_orient_deg is overwritten, we have to re-set the mask_orient_id.
