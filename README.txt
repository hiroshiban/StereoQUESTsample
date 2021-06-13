****************************************
About Oblique3D experiment

Created    : "2018-10-04 15:21:12 ban"
Last Update: "2018-10-05 13:59:23 ban"
****************************************

function StereoQUESTsample(subjID,acq,:displayfile,:stimlusfile,:gamma_table,:overwrite_flg,:force_proceed_flag)
(: is optional)

- This is a sample MATLAB Psychtoolbox-3 (PTB3) script for QUEST psychophysics experiment on 3D vision.
- Displays 3D slant consisted of Random-Dot-Stereogram (RDS) with horizontal
  binocular disparities.
- Used for psychophysical measurements of perceptual oblique effects in 3D scene.
- Participant's task is to discriminate which (the 1st or the 2nd) of the RDSs
  is more "slanted" or "tilted" and answer by button pressing (key1 or key2).
- Thresholds are estimated by the QUEST procedure. Here the thresholds mean
  the minimum discriminable angles (at 82% accuracies by default) between
  the two slaned surfaces at specific depth positions, irrelevant to the sign
  of the depth (differences of top-near and top-far slants are inogured).
  <ref 1>
  King-Smith, P. E., Grigsby, S. S., Vingrys, A. J., Benes, S. C., and
  Supowit, A. (1994) Efficient and unbiased modifications of the QUEST
  threshold method: theory, simulations, experimental evaluation and
  practical implementation. Vision Res, 34 (7), 885-912.
  <ref 2>
  Watson, A. B. and Pelli, D. G. (1983) QUEST: a Bayesian adaptive
  psychometric method. Percept Psychophys, 33 (2), 113-20.
- This script shoud be run with MATLAB Psychtoolbox version 3 or above.
- Stimulus presentation timing are controled by using GetSecs() function
  (this is internally equivalent to Windows multimedia timer), not by waiting
  vertical blanking of the display. This is because we need to present
  stimuli in disregard of the frame rate when MR's TR can not be divided
  by the frame rate (e.g. when TR=3888msec, we can not calculate the fixed
  number of frames corresponding to the TR). So we need to save delay or
  prevent from acceleration by controling the stimulus duration in msec order).

[how to run the script]
1. On the MATLAB shell, please change the working directory to
   ~/StereoQUESTsample/Presentation/
2. Run the "run_exp" script
   >> run_exp('subj_name',1);
   Here, the first input variable is subject name or ID, such as 'HB' or 's01',
   the second variable should be 1 or 2,

For more details, please see the documents in StereoQUESTsample.m
Also please see the parameter files in ~/StereoQUESTsample/Presentation/subj/_DEFAULT_

Created    : "2018-09-26 15:22:55 ban"
Last Update: "2021-06-13 22:27:02 ban"


[input variables]
sujID         : ID of subject, string, such as 'HB', 's01', etc.
                !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
                !!! if 'debug' (case insensitive) is included          !!!
                !!! in subjID string, this program runs as DEBUG mode; !!!
                !!! stimulus images are saved as *.png format at       !!!
                !!! ~/CurvatureShading/Presentation/images             !!!
                !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
acq           : acquisition number (design file number),
                an integer, such as 1, 2, 3, ...
displayfile   : (optional) display condition file,
                *.m file, such as 'oblique3d_display_fmri.m'
                the file should be located in ./subjects/(subj)/
stimulusfile  : (optional) stimulus condition file,
                *.m file, such as 'oblique3d_stimulus_exp1.m'
                the file should be located in ./subjects/(subj)/
gamma_table   : (optional) table(s) of gamma-corrected video input values (Color LookupTable).
                256(8-bits) x 3(RGB) x 1(or 2,3,... when using multiple displays) matrix
                or a *.mat file specified with a relative path format. e.g. '/gamma_table/gamma1.mat'
                The *.mat should include a variable named "gamma_table" consists of a 256x3xN matrix.
                if you use multiple (more than 1) displays and set a 256x3x1 gamma-table, the same
                table will be applied to all displays. if the number of displays and gamma tables
                are different (e.g. you have 3 displays and 256x3x!2! gamma-tables), the last
                gamma_table will be applied to the second and third displays.
                if empty, normalized gamma table (repmat(linspace(0.0,1.0,256),3,1)) will be applied.
overwrite_flg : (optional) whether overwriting pre-existing result file. if 1, the previous results
                file with the same acquisition number will be overwritten by the previous one.
                if 0, the existing file will be backed-up by adding a prefix '_old' at the tail
                of the file. 0 by default.
force_proceed_flag : (optional) whether proceeding stimulus presentatin without waiting for
                the experimenter response (e.g. presesing the ENTER key) or a trigger.
                if 1, the stimulus presentation will be automatically carried on.


[output variables]
no output matlab variable.


[output files]
1. behavioral result
   stored ./subjects/(subjID)/results/(today)
   as ./subjects/(subjID)/results/(today)/(subjID)_Oblique3D_QUEST_results_run_(run_num).mat


[example]
>> StereoQUESTsample('s01',1,'oblique3d_display.m','oblique3d_stimulus_exp1.m')


[About displayfile]
The contents of the displayfile is as below.
(The file includs 6 lines of headers and following display parameters)

(an example of the displayfile)

% ************************************************************
% This_is_the_display_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% SlantfMRI.m
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2021-06-10 01:37:07 ban"
% ************************************************************

% "dparam" means "display-setting parameters"

%%% display mode
% display mode, one of "mono", "dual", "dualcross", "dualparallel", "cross", "parallel", "redgreen", "greenred",
% "redblue", "bluered", "shutter", "topbottom", "bottomtop", "interleavedline", "interleavedcolumn", "propixxmono", "propixxstereo"
dparam.ExpMode='shutter';

dparam.scrID=1; % screen ID, generally 0 for a single display setup, 1 for dual display setup

%%% a method to start stimulus presentation
% 0:ENTER/SPACE, 1:Left-mouse button, 2:the first MR trigger pulse (CiNet),
% 3:waiting for a MR trigger pulse (BUIC) -- checking onset of pin #11 of the parallel port,
% or 4:custom key trigger (wait for a key input that you specify as tgt_key).
dparam.start_method=4;

%%% a pseudo trigger key from the MR scanner when it starts, only valid when dparam.start_method=4;
dparam.custom_trigger=KbName(84); % 't' is a default trigger code from MR scanner at CiNet

dparam.Key1=37; % 37 is left-arrow on default Windows
dparam.Key2=39; % 39 is right-arrow on default Windows

%%% screen settings

%%% whether displaying the stimuli in full-screen mode or as is (the precise resolution), true or false (true)
dparam.fullscr=false;

%%% the resolution of the screen height, integer (1024)
dparam.ScrHeight=1200; %1024; %1200;

%% the resolution of the screen width, integer (1280)
dparam.ScrWidth=1600; %1280; %1920;

% shift the screen center position along y-axis (to prevent the occlusion of the stimuli due to the coil)
dparam.yshift=30;

% whther skipping the PTB's vertical-sync signal test. if 1, the sync test is skipped
dparam.skip_sync_test=0;


[About stimulusfile]
The contents of the stimulusfile is as below.
(The file includs 6 lines of headers and following stimulus parameters)

(an example of the stimulusfile)

% ************************************************************
% This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% Please_change_the_parameters_below.
% StereoQUESTsample.m
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2021-06-10 01:37:07 ban"
% ************************************************************

% "sparam" means "stimulus generation parameters"

%%% stimulus presentation mode
sparam.binocular_display=true; % true or false. if false, only left-eye images are presented to both eyes (required just to measure the effect of monocular cues in RDS)
sparam.give_feedback=true;     % true or false. if true, feedback (whether the response is correct or not) is given

%%% target image generation
sparam.fieldSize=[12,12]; % target stimulus size in deg

% [Important notes on stimulus masks]
%
% * the parameters required to define stimulus masks
%
% sparam.mask_theta_deg  : a set of slopes of the slants to be used for masking. the outer regions of the intersections of all these slants' projections on the XY-axes are masked.
%                          for instance, if sparam.mask_orient_deg=[-22.5,-45], the -22.5 and -22.5 deg slants are first generated, their non-zero components are projected on the XY plane,
%                          and then a stimulus mask is generated in two ways.
%                          1. 'xy' mask: the intersection of the two projections are set to 1, while the oter regions are set to 1. The mask is used to restrict the spatial extensions
%                             of the target slants within the common spatial extent.
%                          2. 'z'  mask: the disparity range of the slants are restricted so that the maximum disparity values are the average of all disparities contained in all set of slants.
%                             using this mask, we can restrict the disparity range across the different angles of the slants.
% sparam.mask_orient_deg : tilt angles of a set of slopes of the slants. if multiple values are set, masks are generated separately for each element of sparam.mask_orient_deg.
%                          for instance, if sparam.mask_theta_deg=[-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5]; and sparam.mask_orient_deg=[45, 90];, two masks are generated as below.
%                          1. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 45 deg
%                          2. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 90 deg
%
%
% * how to set masks for the main slant stimuli
%
% to set the masks to the main slant stimuli, please use sparam.mask_type and sparam.mask_orient_id.
% for details, please see the notes below.

% for generating a mask, which is defined as a common filed of all the slants tilted by sparam.mask_theta_deg below.
sparam.mask_theta_deg   = [-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5]; % for masking, slopes of the slant stimuli in deg, orientation: right-upper-left
sparam.mask_orient_deg  = [0,45,90,135]; % for masking, tilted orientation of the slant in deg, from right horizontal meridian, CCW

% [Important notes on angles/orientations of the slants]
%
% * the parameters required to define stimulus conditions (slant stimuli)
%
% sparam.theta_deg      : angles of the slant, negative = top is near, a [1 x N (= #conditions)] matrix
% sparam.orient_deg     : tilted orientations of the slant in deg, a [1 x N (= #conditions)] matrix
% sparam.mask_type      : 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent, a [1 x N (= #conditions)] cell
% sparam.mask_orient_id : ID of the mask to be used, 1 = sparam.mask_orient_deg(1), 2 = sparam.mask_orient_deg(2), ...., a [1 x N (= #conditions)] matrix
%
%
% * the number of required slants in this experiment are: 8 slants X 4 orientations = 32.
%
% sparam.theta_deg    = repmat([ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5],[1,4]);
% sparam.orient_deg   = [0.*ones(1,8),45.*ones(1,8),90.*ones(1,8),135.*ones(1,8)];
% sparam.mask_type    = {repmat('xy',[1,32]};
% sparam.mask_orient_id=[1.*ones(1,8),2.*ones(1,8),3.*ones(1,8),4.*ones(1,8)];

sparam.theta_deg    = repmat([ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5],[1,4]);
sparam.orient_deg   = [0.*ones(1,8),45.*ones(1,8),90.*ones(1,8),135.*ones(1,8)];
sparam.mask_type    = repmat({'xy'},[1,32]);
sparam.mask_orient_id=[1.*ones(1,8),2.*ones(1,8),3.*ones(1,8),4.*ones(1,8)];

sparam.aperture_deg = 10;   % size of circular aperture in deg
sparam.fill_val     = 0;    % value to fill the 'hole' of the circular aperture
sparam.outer_val    = 0;    % value to fill the outer region of slant field

%%% RDS parameters
sparam.noise_level=0;   % percentage of anti-correlated noise, [val]
sparam.dotRadius=[0.05,0.05]; % radius of RDS's white/black ovals, [row,col]
sparam.dotDens=2; % density of dot in RDS image (1-100)
sparam.colors=[255,0,128]; % RDS colors [dot1,dot2,background](0-255)
sparam.oversampling_ratio=8; % oversampling_ratio for fine scale RDS images, [val]

%%% stimulus display durations etc in 'msec'
sparam.initial_fixation_time=500; % duration in msec for initial fixation, integer (msec)
sparam.condition_duration=500;    % duration in msec for each condition, integer (msec)
sparam.stim_on_probe_duration=[100,100]; % durations in msec for presenting a probe before the actual stimulus presentation (msec) [duration_of_red_fixation,duration_of_waiting]. if [0,0], the probe is ignored.
sparam.stim_on_duration=150;      % duration in msec for simulus ON period for each trial, integer (msec)
sparam.feedback_duration=500;     % duration in msec for correct/incorrect feedback, integer (msec)
sparam.BetweenDuration=500;       % duration in msec between trials, integer (msec)

%%% background color
sparam.bgcolor=[128,128,128];

%%% fixation size and color
sparam.fixsize=24;         % the whole size (a circular hole) of the fixation cross in pixel
sparam.fixlinesize=[12,2]; % [height,width] of the fixation line in pixel
sparam.fixcolor=[255,255,255];

%%% RGB for background patches
sparam.patch_size=[30,30]; % background patch size, [height,width] in pixels
sparam.patch_num=[20,40];  % the number of background patches along vertical and horizontal axis
sparam.patch_color1=[255,255,255];
sparam.patch_color2=[0,0,0];

%%% viewing parameters
run(fullfile(fileparts(mfilename('fullpath')),'sizeparams'));
%sparam.ipd=6.4;
%sparam.pix_per_cm=57.1429;
%sparam.vdist=65;

%%% QUEST parameters
run(fullfile(fileparts(mfilename('fullpath')),'QUESTparams'));
%sparam.numTrials=60;
%sparam.maxValue=15;
%sparam.initialValue=5; tmp=shuffle(0:3); sparam.initialValue=sparam.initialValue+tmp(1);
%sparam.tGuess=log10(sparam.initialValue/sparam.maxValue);
%sparam.tGuessSD=4; % smaller value may be better
%sparam.pThreshold=0.82; % 0.82 is equivalent to a 3-up-1-down standard staircase
%sparam.beta=3.5;
%sparam.delta=0.01;
%sparam.gamma=0.5;


[HOWTO create stimulus files]
1. All of the stimuli are created in this script in real-time
   with MATLAB scripts & functions.
   see ../Generation & ../Common directries.
2. Stimulus parameters are defined in the display & stimulus file.


[about stimuli and task]
Stimuli are presented by default as below
stim 1-1(150ms) -- blank(350ms) -- stim 1-2(150ms) -- response -- blank or feedback(300ms) -- between trial duration (500-1000ms)
stim 2-1(300ms) -- blank(200ms) -- stim 2-2(300ms) -- response -- blank or feedback(300ms) -- between trial duration (500-1000ms)
...(continued)...

Observer's task is to discriminate which (the first or the second) stimulus is more tilted
press key 1 (or left-mouse click) when the first slant is more tilted
press key 2 (or right-mouse click) when the second slant is more tilted
NOTE: Key 1 and key 2 are defined in the display parameter file.

[about feedback]
If sparam.give_feedback is set to 'true', correct/incorrect feedback is given to observer in each trial.
Correct  : Green Fixation with a high-tone sound
Incorrect: Blue Fixation with a low-tone sound


[reference]
- Ban, H. & Welchman, A.E. (2015).
  fMRI analysis-by-synthesis reveals a dorsal hierarchy that extracts surface slant.
  The Journal of Neuroscience, 35(27), 9823-9835.
- for stmulus generation, see ../Generation & ../Common directories.
