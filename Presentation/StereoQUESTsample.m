function StereoQUESTsample(subjID,acq,displayfile,stimulusfile,gamma_table,overwrite_flg,force_proceed_flag)

% function StereoQUESTsample(subjID,acq,:displayfile,:stimlusfile,:gamma_table,:overwrite_flg,:force_proceed_flag)
% (: is optional)
%
% - This is a sample MATLAB Psychtoolbox-3 (PTB3) script for QUEST psychophysics experiment on 3D vision.
% - Displays 3D slant consisted of Random-Dot-Stereogram (RDS) with horizontal
%   binocular disparities.
% - Used for psychophysical measurements of perceptual oblique effects in 3D scene.
% - Participant's task is to discriminate which (the 1st or the 2nd) of the RDSs
%   is more "slanted" or "tilted" and answer by button pressing (key1 or key2).
% - Thresholds are estimated by the QUEST procedure. Here the thresholds mean
%   the minimum discriminable angles (at 82% accuracies by default) between
%   the two slaned surfaces at specific depth positions, irrelevant to the sign
%   of the depth (differences of top-near and top-far slants are inogured).
%   <ref 1>
%   King-Smith, P. E., Grigsby, S. S., Vingrys, A. J., Benes, S. C., and
%   Supowit, A. (1994) Efficient and unbiased modifications of the QUEST
%   threshold method: theory, simulations, experimental evaluation and
%   practical implementation. Vision Res, 34 (7), 885-912.
%   <ref 2>
%   Watson, A. B. and Pelli, D. G. (1983) QUEST: a Bayesian adaptive
%   psychometric method. Percept Psychophys, 33 (2), 113-20.
% - This script shoud be run with MATLAB Psychtoolbox version 3 or above.
% - Stimulus presentation timing are controled by using GetSecs() function
%   (this is internally equivalent to Windows multimedia timer), not by waiting
%   vertical blanking of the display. This is because we need to present
%   stimuli in disregard of the frame rate when MR's TR can not be divided
%   by the frame rate (e.g. when TR=3888msec, we can not calculate the fixed
%   number of frames corresponding to the TR). So we need to save delay or
%   prevent from acceleration by controling the stimulus duration in msec order).
%
% [how to run the script]
% 1. On the MATLAB shell, please change the working directory to
%    ~/StereoQUESTsample/Presentation/
% 2. Run the "run_exp" script
%    >> run_exp('subj_name',1);
%    Here, the first input variable is subject name or ID, such as 'HB' or 's01',
%    the second variable should be 1 or 2,
%
% Created    : "2018-09-26 15:22:55 ban"
% Last Update: "2021-06-13 22:27:22 ban"
%
%
% [input variables]
% sujID         : ID of subject, string, such as 'HB', 's01', etc.
%                 !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
%                 !!! if 'debug' (case insensitive) is included          !!!
%                 !!! in subjID string, this program runs as DEBUG mode; !!!
%                 !!! stimulus images are saved as *.png format at       !!!
%                 !!! ~/CurvatureShading/Presentation/images             !!!
%                 !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
% acq           : acquisition number (design file number),
%                 an integer, such as 1, 2, 3, ...
% displayfile   : (optional) display condition file,
%                 *.m file, such as 'oblique3d_display_fmri.m'
%                 the file should be located in ./subjects/(subj)/
% stimulusfile  : (optional) stimulus condition file,
%                 *.m file, such as 'oblique3d_stimulus_exp1.m'
%                 the file should be located in ./subjects/(subj)/
% gamma_table   : (optional) table(s) of gamma-corrected video input values (Color LookupTable).
%                 256(8-bits) x 3(RGB) x 1(or 2,3,... when using multiple displays) matrix
%                 or a *.mat file specified with a relative path format. e.g. '/gamma_table/gamma1.mat'
%                 The *.mat should include a variable named "gamma_table" consists of a 256x3xN matrix.
%                 if you use multiple (more than 1) displays and set a 256x3x1 gamma-table, the same
%                 table will be applied to all displays. if the number of displays and gamma tables
%                 are different (e.g. you have 3 displays and 256x3x!2! gamma-tables), the last
%                 gamma_table will be applied to the second and third displays.
%                 if empty, normalized gamma table (repmat(linspace(0.0,1.0,256),3,1)) will be applied.
% overwrite_flg : (optional) whether overwriting pre-existing result file. if 1, the previous results
%                 file with the same acquisition number will be overwritten by the previous one.
%                 if 0, the existing file will be backed-up by adding a prefix '_old' at the tail
%                 of the file. 0 by default.
% force_proceed_flag : (optional) whether proceeding stimulus presentatin without waiting for
%                 the experimenter response (e.g. presesing the ENTER key) or a trigger.
%                 if 1, the stimulus presentation will be automatically carried on.
%
%
% [output variables]
% no output matlab variable.
%
%
% [output files]
% 1. behavioral result
%    stored ./subjects/(subjID)/results/(today)
%    as ./subjects/(subjID)/results/(today)/(subjID)_Oblique3D_QUEST_results_run_(run_num).mat
%
%
% [example]
% >> StereoQUESTsample('s01',1,'oblique3d_display.m','oblique3d_stimulus_exp1.m')
%
%
% [About displayfile]
% The contents of the displayfile is as below.
% (The file includs 6 lines of headers and following display parameters)
%
% (an example of the displayfile)
%
% % ************************************************************
% % This_is_the_display_file_for_OBLIQUE3D_experiment.
% % Please_change_the_parameters_below.
% % SlantfMRI.m
% %
% % Created    : "2018-09-26 18:57:59 ban"
% % Last Update: "2021-06-10 01:37:07 ban"
% % ************************************************************
%
% % "dparam" means "display-setting parameters"
%
% %%% display mode
% % display mode, one of "mono", "dual", "dualcross", "dualparallel", "cross", "parallel", "redgreen", "greenred",
% % "redblue", "bluered", "shutter", "topbottom", "bottomtop", "interleavedline", "interleavedcolumn", "propixxmono", "propixxstereo"
% dparam.ExpMode='shutter';
%
% dparam.scrID=1; % screen ID, generally 0 for a single display setup, 1 for dual display setup
%
% %%% a method to start stimulus presentation
% % 0:ENTER/SPACE, 1:Left-mouse button, 2:the first MR trigger pulse (CiNet),
% % 3:waiting for a MR trigger pulse (BUIC) -- checking onset of pin #11 of the parallel port,
% % or 4:custom key trigger (wait for a key input that you specify as tgt_key).
% dparam.start_method=4;
%
% %%% a pseudo trigger key from the MR scanner when it starts, only valid when dparam.start_method=4;
% dparam.custom_trigger=KbName(84); % 't' is a default trigger code from MR scanner at CiNet
%
% dparam.Key1=37; % 37 is left-arrow on default Windows
% dparam.Key2=39; % 39 is right-arrow on default Windows
%
% %%% screen settings
%
% %%% whether displaying the stimuli in full-screen mode or as is (the precise resolution), true or false (true)
% dparam.fullscr=false;
%
% %%% the resolution of the screen height, integer (1024)
% dparam.ScrHeight=1200; %1024; %1200;
%
% %% the resolution of the screen width, integer (1280)
% dparam.ScrWidth=1600; %1280; %1920;
%
% % shift the screen center position along y-axis (to prevent the occlusion of the stimuli due to the coil)
% dparam.yshift=30;
%
% % whther skipping the PTB's vertical-sync signal test. if 1, the sync test is skipped
% dparam.skip_sync_test=0;
%
%
% [About stimulusfile]
% The contents of the stimulusfile is as below.
% (The file includs 6 lines of headers and following stimulus parameters)
%
% (an example of the stimulusfile)
%
% % ************************************************************
% % This_is_the_stimulus_parameter_file_for_OBLIQUE3D_experiment.
% % Please_change_the_parameters_below.
% % StereoQUESTsample.m
% %
% % Created    : "2018-09-26 18:57:59 ban"
% % Last Update: "2021-06-10 01:37:07 ban"
% % ************************************************************
%
% % "sparam" means "stimulus generation parameters"
%
% %%% stimulus presentation mode
% sparam.binocular_display=true; % true or false. if false, only left-eye images are presented to both eyes (required just to measure the effect of monocular cues in RDS)
% sparam.give_feedback=true;     % true or false. if true, feedback (whether the response is correct or not) is given
%
% %%% target image generation
% sparam.fieldSize=[12,12]; % target stimulus size in deg
%
% % [Important notes on stimulus masks]
% %
% % * the parameters required to define stimulus masks
% %
% % sparam.mask_theta_deg  : a set of slopes of the slants to be used for masking. the outer regions of the intersections of all these slants' projections on the XY-axes are masked.
% %                          for instance, if sparam.mask_orient_deg=[-22.5,-45], the -22.5 and -22.5 deg slants are first generated, their non-zero components are projected on the XY plane,
% %                          and then a stimulus mask is generated in two ways.
% %                          1. 'xy' mask: the intersection of the two projections are set to 1, while the oter regions are set to 1. The mask is used to restrict the spatial extensions
% %                             of the target slants within the common spatial extent.
% %                          2. 'z'  mask: the disparity range of the slants are restricted so that the maximum disparity values are the average of all disparities contained in all set of slants.
% %                             using this mask, we can restrict the disparity range across the different angles of the slants.
% % sparam.mask_orient_deg : tilt angles of a set of slopes of the slants. if multiple values are set, masks are generated separately for each element of sparam.mask_orient_deg.
% %                          for instance, if sparam.mask_theta_deg=[-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5]; and sparam.mask_orient_deg=[45, 90];, two masks are generated as below.
% %                          1. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 45 deg
% %                          2. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 90 deg
% %
% %
% % * how to set masks for the main slant stimuli
% %
% % to set the masks to the main slant stimuli, please use sparam.mask_type and sparam.mask_orient_id.
% % for details, please see the notes below.
%
% % for generating a mask, which is defined as a common filed of all the slants tilted by sparam.mask_theta_deg below.
% sparam.mask_theta_deg   = [-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5]; % for masking, slopes of the slant stimuli in deg, orientation: right-upper-left
% sparam.mask_orient_deg  = [0,45,90,135]; % for masking, tilted orientation of the slant in deg, from right horizontal meridian, CCW
%
% % [Important notes on angles/orientations of the slants]
% %
% % * the parameters required to define stimulus conditions (slant stimuli)
% %
% % sparam.theta_deg      : angles of the slant, negative = top is near, a [1 x N (= #conditions)] matrix
% % sparam.orient_deg     : tilted orientations of the slant in deg, a [1 x N (= #conditions)] matrix
% % sparam.mask_type      : 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent, a [1 x N (= #conditions)] cell
% % sparam.mask_orient_id : ID of the mask to be used, 1 = sparam.mask_orient_deg(1), 2 = sparam.mask_orient_deg(2), ...., a [1 x N (= #conditions)] matrix
% %
% %
% % * the number of required slants in this experiment are: 8 slants X 4 orientations = 32.
% %
% % sparam.theta_deg    = repmat([ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5],[1,4]);
% % sparam.orient_deg   = [0.*ones(1,8),45.*ones(1,8),90.*ones(1,8),135.*ones(1,8)];
% % sparam.mask_type    = {repmat('xy',[1,32]};
% % sparam.mask_orient_id=[1.*ones(1,8),2.*ones(1,8),3.*ones(1,8),4.*ones(1,8)];
%
% sparam.theta_deg    = repmat([ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5],[1,4]);
% sparam.orient_deg   = [0.*ones(1,8),45.*ones(1,8),90.*ones(1,8),135.*ones(1,8)];
% sparam.mask_type    = repmat({'xy'},[1,32]);
% sparam.mask_orient_id=[1.*ones(1,8),2.*ones(1,8),3.*ones(1,8),4.*ones(1,8)];
%
% sparam.aperture_deg = 10;   % size of circular aperture in deg
% sparam.fill_val     = 0;    % value to fill the 'hole' of the circular aperture
% sparam.outer_val    = 0;    % value to fill the outer region of slant field
%
% %%% RDS parameters
% sparam.noise_level=0;   % percentage of anti-correlated noise, [val]
% sparam.dotRadius=[0.05,0.05]; % radius of RDS's white/black ovals, [row,col]
% sparam.dotDens=2; % density of dot in RDS image (1-100)
% sparam.colors=[255,0,128]; % RDS colors [dot1,dot2,background](0-255)
% sparam.oversampling_ratio=8; % oversampling_ratio for fine scale RDS images, [val]
%
% %%% stimulus display durations etc in 'msec'
% sparam.initial_fixation_time=500; % duration in msec for initial fixation, integer (msec)
% sparam.condition_duration=500;    % duration in msec for each condition, integer (msec)
% sparam.stim_on_probe_duration=[100,100]; % durations in msec for presenting a probe before the actual stimulus presentation (msec) [duration_of_red_fixation,duration_of_waiting]. if [0,0], the probe is ignored.
% sparam.stim_on_duration=150;      % duration in msec for simulus ON period for each trial, integer (msec)
% sparam.feedback_duration=500;     % duration in msec for correct/incorrect feedback, integer (msec)
% sparam.BetweenDuration=500;       % duration in msec between trials, integer (msec)
%
% %%% background color
% sparam.bgcolor=[128,128,128];
%
% %%% fixation size and color
% sparam.fixsize=24;         % the whole size (a circular hole) of the fixation cross in pixel
% sparam.fixlinesize=[12,2]; % [height,width] of the fixation line in pixel
% sparam.fixcolor=[255,255,255];
%
% %%% RGB for background patches
% sparam.patch_size=[30,30]; % background patch size, [height,width] in pixels
% sparam.patch_num=[20,40];  % the number of background patches along vertical and horizontal axis
% sparam.patch_color1=[255,255,255];
% sparam.patch_color2=[0,0,0];
%
% %%% viewing parameters
% run(fullfile(fileparts(mfilename('fullpath')),'sizeparams'));
% %sparam.ipd=6.4;
% %sparam.pix_per_cm=57.1429;
% %sparam.vdist=65;
%
% %%% QUEST parameters
% run(fullfile(fileparts(mfilename('fullpath')),'QUESTparams'));
% %sparam.numTrials=60;
% %sparam.maxValue=15;
% %sparam.initialValue=5; tmp=shuffle(0:3); sparam.initialValue=sparam.initialValue+tmp(1);
% %sparam.tGuess=log10(sparam.initialValue/sparam.maxValue);
% %sparam.tGuessSD=4; % smaller value may be better
% %sparam.pThreshold=0.82; % 0.82 is equivalent to a 3-up-1-down standard staircase
% %sparam.beta=3.5;
% %sparam.delta=0.01;
% %sparam.gamma=0.5;
%
%
% [HOWTO create stimulus files]
% 1. All of the stimuli are created in this script in real-time
%    with MATLAB scripts & functions.
%    see ../Generation & ../Common directries.
% 2. Stimulus parameters are defined in the display & stimulus file.
%
%
% [about stimuli and task]
% Stimuli are presented by default as below
% stim 1-1(150ms) -- blank(350ms) -- stim 1-2(150ms) -- response -- blank or feedback(300ms) -- between trial duration (500-1000ms)
% stim 2-1(300ms) -- blank(200ms) -- stim 2-2(300ms) -- response -- blank or feedback(300ms) -- between trial duration (500-1000ms)
% ...(continued)...
%
% Observer's task is to discriminate which (the first or the second) stimulus is more tilted
% press key 1 (or left-mouse click) when the first slant is more tilted
% press key 2 (or right-mouse click) when the second slant is more tilted
% NOTE: Key 1 and key 2 are defined in the display parameter file.
%
% [about feedback]
% If sparam.give_feedback is set to 'true', correct/incorrect feedback is given to observer in each trial.
% Correct  : Green Fixation with a high-tone sound
% Incorrect: Blue Fixation with a low-tone sound
%
%
% [reference]
% - Ban, H. & Welchman, A.E. (2015).
%   fMRI analysis-by-synthesis reveals a dorsal hierarchy that extracts surface slant.
%   The Journal of Neuroscience, 35(27), 9823-9835.
% - for stmulus generation, see ../Generation & ../Common directories.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Check the input variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear global; clear mex;
if nargin<2, help(mfilename()); return; end
if nargin<3 || isempty(displayfile), displayfile=[]; end
if nargin<4 || isempty(stimulusfile), stimulusfile=[]; end
if nargin<5 || isempty(gamma_table), gamma_table=[]; end
if nargin<6 || isempty(overwrite_flg), overwrite_flg=0; end
if nargin<7 || isempty(force_proceed_flag), force_proceed_flag=0; end

% check the aqcuisition number.
if acq<1, error('Acquistion number must be integer and greater than zero'); end

% check the subject directory
if ~exist(fullfile(pwd,'subjects',subjID),'dir'), error('can not find subj directory. check the input variable.'); end

rootDir=fileparts(mfilename('fullpath'));

% check the display/stimulus files
if ~isempty(displayfile)
  if ~strcmpi(displayfile(end-1:end),'.m'), displayfile=[displayfile,'.m']; end
  if ~exist(fullfile(rootDir,'subjects',subjID,displayfile),'file'), error('displayfile not found. check the input variable.'); end
end

if ~isempty(stimulusfile)
  if ~strcmpi(stimulusfile(end-1:end),'.m'), stimulusfile=[stimulusfile,'.m']; end
  if ~exist(fullfile(rootDir,'subjects',subjID,stimulusfile),'file'), error('stimulusfile not found. check the input variable.'); end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Add paths to the subfunctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add paths to the subfunctions
addpath(fullfile(rootDir,'..','Common'));
addpath(fullfile(rootDir,'..','gamma_table'));
addpath(fullfile(rootDir,'..','Generation'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% For a log file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% result directry & file
resultDir=fullfile(rootDir,'subjects',num2str(subjID),'results',datestr(now,'yymmdd'));
if ~exist(resultDir,'dir'), mkdir(resultDir); end

% record the output window
logfname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'.log']);
diary(logfname);
warning off; %warning('off','MATLAB:dispatcher:InexactCaseMatch');


%%%%% try & catch %%%%%
try


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Check the PTB version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PTB_OK=CheckPTBversion(3); % check wether the PTB version is 3
if ~PTB_OK, error('Wrong version of Psychtoolbox is running. %s requires PTB ver.3',mfilename()); end

% debug level, black screen during calibration
Screen('Preference','VisualDebuglevel',3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setup random seed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

InitializeRandomSeed();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Reset display Gamma-function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isempty(gamma_table)
  gamma_table=repmat(linspace(0.0,1.0,256),3,1)'; %#ok
  GammaResetPTB(1.0);
else
  GammaLoadPTB(gamma_table);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Validate dparam (displayfile) and sparam (stimulusfile) structures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% organize dparam
dparam=struct(); % initialize
if ~isempty(displayfile), run(fullfile(rootDir,'subjects',subjID,displayfile)); end % load specific dparam parameters configured for each of the participants
dparam=ValidateStructureFields(dparam,... % validate fields and set the default values to missing field(s)
         'ExpMode','shutter',...
         'scrID',1,...
         'start_method',1,...
         'custom_trigger',KbName(84),...
         'Key1',37,...
         'Key2',39,...
         'fullscr',false,...
         'ScrHeight',1200,...
         'ScrWidth',1920,...
         'skip_sync_test',0);

% organize sparam
sparam=struct(); % initialize
if ~isempty(stimulusfile), run(fullfile(rootDir,'subjects',subjID,stimulusfile)); end % load specific sparam parameters configured for each of the participants
sparam=ValidateStructureFields(sparam,... % validate fields and set the default values to missing field(s)
         'binocular_display',true,...
         'give_feedback',false,...
         'fieldSize',[12,12,],...
         'mask_theta_deg',[-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5],...
         'mask_orient_deg',[0,45,90,135],...
         'theta_deg',repmat([ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5],[1,4]),...
         'orient_deg',[0.*ones(1,8),45.*ones(1,8),90.*ones(1,8),135.*ones(1,8)],...
         'mask_type',repmat({'xy'},[1,32]),...
         'mask_orient_id',[1.*ones(1,8),2.*ones(1,8),3.*ones(1,8),4.*ones(1,8)],...
         'aperture_deg',10,...
         'fill_val',0,...
         'outer_val',0,...
         'noise_level',0,...
         'dotRadius',[0.05,0.05],...
         'dotDens',2,...
         'colors',[255,0,128],...
         'oversampling_ratio',8,...
         'numTrials',20,...
         'initial_fixation_time',500,...
         'condition_duration',500,...
         'stim_on_probe_duration',[0,0],...
         'stim_on_duration',150,...
         'feedback_duration',500,...
         'BetweenDuration',500,...
         'bgcolor',[128,128,128],...
         'fixsize',18,...
         'fixlinesize',[9,2],...
         'fixcolor',[255,255,255],...
         'patch_size',[30,30],...
         'patch_num',[20,40],...
         'patch_color1',[255,255,255],...
         'patch_color2',[0,0,0],...
         'ipd',6.4,...
         'pix_per_cm',57.1429,...
         'vdist',65,...
         'numTrials',60,...
         'maxValue',15,...
         'initialValue',5,...
         'tGuess',log10(sparam.initialValue/sparam.maxValue),...
         'tGuessSD',4,...
         'pThreshold',0.82,...
         'beta',3.5,...
         'delta',0.01,...
         'gamma',0.5);

% change unit from msec to sec.
sparam.initial_fixation_time  = sparam.initial_fixation_time./1000;
sparam.condition_duration     = sparam.condition_duration./1000;
sparam.BetweenDuration        = sparam.BetweenDuration./1000;
sparam.stim_on_probe_duration = sparam.stim_on_probe_duration./1000;
sparam.stim_on_duration       = sparam.stim_on_duration./1000;
sparam.feedback_duration      = sparam.feedback_duration./1000;

sparam.stim_off_duration=sparam.condition_duration-sparam.stim_on_duration;

% set the other parameters
dparam.RunScript=mfilename();
sparam.RunScript=mfilename();

% set the number of conditions
sparam.numConds=numel(sparam.theta_deg);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Displaying the presentation parameters you set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('The Presentation Parameters are as below.\n\n');
fprintf('************************************************\n');
fprintf('****** Script, Subject, Acquistion Number ******\n');
fprintf('Running Script Name    : %s\n',mfilename());
fprintf('Subject ID             : %s\n',subjID);
fprintf('Acquisition Number     : %d\n',acq);
fprintf('********* Run Type, Display Image Type *********\n');
fprintf('Display Mode           : %s\n',dparam.ExpMode);
fprintf('use Full Screen Mode   : %d\n',dparam.fullscr);
fprintf('Start Method           : %d\n',dparam.start_method);
if dparam.start_method==4
  fprintf('Custom Trigger         : %s\n',dparam.custom_trigger);
end
fprintf('*************** Screen Settings ****************\n');
fprintf('Screen Height          : %d\n',dparam.ScrHeight);
fprintf('Screen Width           : %d\n',dparam.ScrWidth);
fprintf('*********** Stimulation periods etc. ***********\n');
fprintf('Fixation Time(ms)      : %.2f\n',1000*sparam.initial_fixation_time);
fprintf('Cond Duration(ms)      : %.2f\n',1000*sparam.condition_duration);
fprintf('Between Trial Dur(ms)  : %.2f\n',1000*sparam.BetweenDuration);
fprintf('Stim ON Duration(ms)   : %.2f\n',1000*sparam.stim_on_duration);
fprintf('Stim OFF Duration(ms)  : %.2f\n',1000*sparam.stim_off_duration);
fprintf('*************** QUEST parameters ***************\n');
fprintf('#conditions            : %d\n',sparam.numConds);
fprintf('#trials per condition  : %d\n',sparam.numTrials);
fprintf('max limit of threshold : %d\n',sparam.maxValue);
fprintf('initial value          : %d\n',sparam.initialValue);
fprintf('initial guess          : %.2f\n',sparam.tGuess);
fprintf('initial SD of guesss   : %.2f\n',sparam.tGuessSD);
fprintf('1-alpha of threshold   : %.2f\n',sparam.pThreshold);
fprintf('initial beta           : %.2f\n',sparam.beta);
fprintf('initial delta          : %.2f\n',sparam.delta);
fprintf('initial gamma          : %.2f\n',sparam.gamma);
fprintf('************ Response key settings *************\n');
fprintf('Reponse Key #1         : %d=%s\n',dparam.Key1,KbName(dparam.Key1));
fprintf('Reponse Key #2         : %d=%s\n',dparam.Key2,KbName(dparam.Key2));
fprintf('************************************************\n\n');
fprintf('Please carefully check before proceeding.\n\n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating stimulus presentation protocol, a design structure, and QUEST data structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Variables described below are for storing participant behaviors

% generate design matrix
% design matrix consists with 2 parameters: theta_deg, orient_deg.
% for instance,
% [theta_deg1, orient_deg1;
%  theta_deg2, orient_deg2;
%  theta_deg3, orient_deg3;
%  ...];
design=zeros(numel(sparam.theta_deg),2);
for ii=1:1:numel(sparam.theta_deg), design(ii,:)=[sparam.theta_deg(ii),sparam.orient_deg(ii)]; end

% create stimulus presentation array (sequence)
if numel(sparam.numConds)>=4
  stimulus_order=GenerateRandomDesignSequence(sparam.numConds,sparam.numTrials,2,0,1)';
elseif numel(sparam.numConds)<=2
  stimulus_order=GenerateRandomDesignSequence(sparam.numConds,sparam.numTrials,0,0,0)';
else
  stimulus_order=GenerateRandomDesignSequence(sparam.numConds,sparam.numTrials,1,0,1)';
end

%% create a QUEST data structure that stores the angle differences (stimulus intensities)
quest_data=cell(size(design,1),1);
for ii=1:1:size(design,1)
  quest_data{ii}=QuestCreate(sparam.tGuess,sparam.tGuessSD,sparam.pThreshold,sparam.beta,sparam.delta,sparam.gamma);
  quest_data{ii}.normalizePdf=1; % This adds a few ms per call to QuestUpdate, but otherwise the pdf will underflow after about 1000 trials.
end

%% create matrix to store intensity estimation flows
% estimation_matrix consists of 4 variables
% [intensity(1)(angle),response(1),estimation(mean)(1),estimation(sd)(1);
%  intensity(2)(angle),response(2),estimation(mean)(2),estimation(sd)(2);
%  intensity(3)(angle),response(3),estimation(mean)(3),estimation(sd)(3);
%  ...]
estimation_matrix=cell(size(design,1),1);

% to store numbers of the current trials
trial_counter=zeros(size(design,1),1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initialize response & event logger objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize MATLAB objects for event and response logs
event=eventlogger();
resps=responselogger([dparam.Key1,dparam.Key2]);
resps.initialize(event); % initialize responselogger


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Wait for user reponse to start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~force_proceed_flag
  [user_answer,resps]=resps.wait_to_proceed();
  if ~user_answer, diary off; return; end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initialization of Left & Right screens for binocular presenting/viewing mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if dparam.skip_sync_test, Screen('Preference','SkipSyncTests',1); end

% ************************************* IMPORTANT NOTE *****************************************
% if the console PC has been connected to two 3D displays with the expanding display setups and
% some shutter goggles (e.g. nVidia 3DVision2) are used for displaying 3D stimulus with MATLAB
% Psychtoolbox3 (PTB3), the 3D stimuli can be presented properly only when we select the first
% display (scrID=1) for stimulus presentations, while left/right images seem to be flipped if
% we select the second display (scrID=2) as the main stimulus presentation window. This may be
% a bug of PTB3. So in any case, if you run 3D vision experiments with dual monitors, it would
% be safer to always chose the first monitor for stimulus presentations. Please be careful.
% ************************************* IMPORTANT NOTE *****************************************

[winPtr,winRect,nScr,dparam.fps,dparam.ifi,initDisplay_OK]=InitializePTBDisplays(dparam.ExpMode,sparam.bgcolor,0,[],dparam.scrID);
if ~initDisplay_OK, error('Display initialization error. Please check your exp_run parameter.'); end
HideCursor();

%dparam.fps=60; % set the fixed flips/sec velue just in case, as the PTB sometimes underestimates the actual vertical sync signals.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setting the PTB runnning priority to MAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set the priority of this script to MAX
priorityLevel=MaxPriority(winPtr,'WaitBlanking');
Priority(priorityLevel);

% conserve VRAM memory: Workaround for flawed hardware and drivers
% 32 == kPsychDontShareContextRessources: Do not share ressources between
% different onscreen windows. Usually you want PTB to share all ressources
% like offscreen windows, textures and GLSL shaders among all open onscreen
% windows. If that causes trouble for some weird reason, you can prevent
% automatic sharing with this flag.
%Screen('Preference','ConserveVRAM',32);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setting the PTB OpenGL functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enable OpenGL mode of Psychtoolbox: This is crucially needed for clut animation
InitializeMatlabOpenGL();

% This script calls Psychtoolbox commands available only in OpenGL-based
% versions of the Psychtoolbox. (So far, the OS X Psychtoolbox is the
% only OpenGL-base Psychtoolbox.)  The Psychtoolbox command AssertPsychOpenGL will issue
% an error message if someone tries to execute this script on a computer without
% an OpenGL Psychtoolbox
AssertOpenGL();

% set OpenGL blend functions
Screen('BlendFunction',winPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initializing MATLAB OpenGL shader API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Not required for the current display and stimulus setups
% just call DrawTextureWithCLUT with window pointer alone
%DrawTextureWithCLUT(winPtr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Displaying 'Initializing...'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% displaying texts on the center of the screen
DisplayMessage2('Initializing...',sparam.bgcolor,winPtr,nScr,'Arial',36);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initializing variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cm per pix
sparam.cm_per_pix=1/sparam.pix_per_cm;

% pixles per degree
sparam.pix_per_deg=round( 1/( 180*atan(sparam.cm_per_pix/sparam.vdist)/pi ) );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initializing height fields & image shifts by binocular disparities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% to get stimulus image size
tmp_slant_field=sla_CreateCircularSlantField(sparam.fieldSize,sparam.theta_deg(1),sparam.orient_deg(1),...
                                             sparam.aperture_deg,sparam.fill_val,sparam.outer_val,sparam.pix_per_deg,sparam.oversampling_ratio);

% NOTE:
% the codes below are just to generate mask field.
% the actual stimuli are generated each time in the main trial loop.

if sum(strcmpi(sparam.mask_type,'xy'))~=0 || sum(strcmpi(sparam.mask_type,'z'))~=0

  % generate slant heightfields for XY- and Z- masking
  slant_field=cell(numel(sparam.mask_theta_deg),numel(sparam.mask_orient_deg));
  slant_mask=cell(numel(sparam.mask_theta_deg),numel(sparam.mask_orient_deg));
  for ii=1:1:numel(sparam.mask_theta_deg)
    for jj=1:1:numel(sparam.mask_orient_deg)
      [slant_field{ii,jj},slant_mask{ii,jj}]=sla_CreateCircularSlantField(sparam.fieldSize,sparam.mask_theta_deg(ii),sparam.mask_orient_deg(jj),...
                                                        sparam.aperture_deg,sparam.fill_val,sparam.outer_val,sparam.pix_per_deg,sparam.oversampling_ratio);
      slant_field{ii,jj}=slant_field{ii,jj}.*sparam.cm_per_pix; % convert pix to cm;
    end
  end

  % generate xy-masked slant field

  % generate a mask to extract the common spatial region
  smask=ones([size(slant_mask{1,1}),numel(sparam.mask_orient_deg)]);
  for ii=1:1:numel(sparam.mask_theta_deg)
    for jj=1:1:numel(sparam.mask_orient_deg)
      smask(:,:,jj)=smask(:,:,jj).*slant_mask{ii,jj};
    end
  end

  % generate z-masked slant field

  % get max/min height(~=disparity) from each slant_field
  max_height=zeros(numel(sparam.mask_theta_deg),numel(sparam.mask_orient_deg));
  min_height=zeros(numel(sparam.mask_theta_deg),numel(sparam.mask_orient_deg));
  for ii=1:1:numel(sparam.mask_theta_deg)
    for jj=1:1:numel(sparam.mask_orient_deg)
      max_height(ii,jj)=max(slant_field{ii,jj}(:));
      min_height(ii,jj)=min(slant_field{ii,jj}(:));
    end
  end

  clear slant_field slant_mask;

end % if sum(strcmpi(sparam.mask_type,'xy'))~=0 || sum(strcmpi(sparam.mask_type,'z'))~=0

% adjust parameters for oversampling (these adjustments shoud be done after creating heightfields)
dotDens=sparam.dotDens/sparam.oversampling_ratio;
ipd=sparam.ipd*sparam.oversampling_ratio;
vdist=sparam.vdist*sparam.oversampling_ratio;
pix_per_cm_x=sparam.pix_per_cm*sparam.oversampling_ratio;
pix_per_cm_y=sparam.pix_per_cm;

% generate ovals to be used in generating RDSs
dotSize=round(sparam.dotRadius.*[pix_per_cm_y,pix_per_cm_x]*2); % radius(cm) --> diameter(pix)
basedot=double(MakeFineOval(dotSize,[sparam.colors(1:2) 0],sparam.colors(3),1.2,2,1,0,0));
wdot=basedot(:,:,1); % get only gray scale image (white)
bdot=basedot(:,:,2); % get only gray scale image (black)
dotalpha=basedot(:,:,4)./max(max(basedot(:,:,4))); % get alpha channel value 0-1.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Debug codes
%%%% saving the stimulus images as *.png format files and enter the debug (keyboard) mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%% DEBUG codes start here. The codes below are just to get stimulus images and check the dparam and sparam parameters
% note: debug stimuli have no jitters in binocular disparities
if strfind(upper(subjID),'DEBUG')

  Screen('CloseAll');

  imgL=cell(size(design,1),1);
  imgR=cell(size(design,1),1);
  posL=cell(size(design,1),1);
  posR=cell(size(design,1),1);

  for ii=1:1:size(design,1)

    % set the current stimulus parameters
    theta_deg= design(ii,1);
    orient_deg=design(ii,2);

    % generate slant height field with sinusoidal grating
    if ~strcmpi(sparam.mask_type{ii},'xy')
      slant_field=sla_CreateCircularSlantField(sparam.fieldSize,theta_deg,orient_deg,sparam.aperture_deg,...
                                               sparam.fill_val,sparam.outer_val,sparam.pix_per_deg,sparam.oversampling_ratio);
    else
      slant_field=sla_CreatePlaneSlantField(sparam.fieldSize,theta_deg,orient_deg,sparam.pix_per_deg,sparam.oversampling_ratio);
    end
    slant_field=slant_field.*sparam.cm_per_pix;

    % put XY-mask on the slant_field
    if strcmpi(sparam.mask_type{ii},'xy')
      slant_field=slant_field.*smask(:,:,sparam.mask_orient_id(ii));
      slant_field(smask(:,:,sparam.mask_orient_id(ii))~=1)=sparam.outer_val;
    end

    % put Z-mask on the slant_field
    if strcmpi(sparam.mask_type{ii},'z')
      maxH=mean(max_height(:,sparam.mask_orient_id(ii))); %maxH=min(max_height(:,sparam.mask_orient_id(ii)));
      minH=mean(min_height(:,sparam.mask_orient_id(ii))); %minH=max(min_height(:,sparam.mask_orient_id(ii)));
      slant_field(slant_field<minH | maxH<slant_field)=sparam.outer_val;
    end

    % calculate left/right eye image shifts
    [posL{ii},posR{ii}]=RayTrace_ScreenPos_X_MEX(slant_field,ipd,vdist,pix_per_cm_x,0);

    % generate RDS images
    [imgL{ii},imgR{ii}]=sla_RDSfastest_with_noise_MEX(posL{ii},posR{ii},wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3));
    imgL{ii}=imresize(imgL{ii},[1,1/sparam.oversampling_ratio].*size(imgL{ii}),'bilinear');
    if sparam.binocular_display
      imgR{ii}=imresize(imgR{ii},[1,1/sparam.oversampling_ratio].*size(imgR{ii}),'bilinear');
    else
      imgR{ii}=imgL{ii};
    end

  end % for ii=1:1:size(design,1)

  % save stimuli as *.mat
  save_dir=fullfile(resultDir,'images');
  if ~exist(save_dir,'dir'), mkdir(save_dir); end
  save(fullfile(save_dir,'oblique3D_stimuli.mat'),'design','dparam','sparam','imgL','imgR','posL','posR','wdot','bdot','dotalpha');

  % plotting/saving figures
  for ii=1:1:size(design,1)

    % save generated figures as png
    if ~strcmpi(dparam.ExpMode,'redgreen') && ~strcmpi(dparam.ExpMode,'redblue')
      M = [imgL{ii},sparam.bgcolor(3)*ones(size(imgL{ii},1),20),imgR{ii},sparam.bgcolor(3)*ones(size(imgL{ii},1),20),imgL{ii}];
    else
      M=reshape([imgL{ii},imgR{ii},sparam.bgcolor(3)*ones(size(imgL{ii}))],[size(imgL{ii}),3]); % RGB;
    end

    figure; hold on;
    imshow(M,[0,255]);
    if ~strcmpi(dparam.ExpMode,'redgreen') && ~strcmpi(dparam.ExpMode,'redblue')
      fname=sprintf('oblique3D_cond%03d_theta%.2f_ori%.2f.png',ii,design(ii,1),design(ii,2));
    else
      fname=sprintf('oblique3D_red_green_cond%03d_theta%.2f_ori%.2f.png',ii,design(ii,1),design(ii,2));
    end
    imwrite(M,[save_dir,filesep(),fname,'.png'],'png');

  end % for ii=1:1:size(design,1)

  keyboard;
  return;

end % if strfind(upper(subjID),'DEBUG')
% %%%%%% DEBUG code ends here


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating the background image with vergence-guide grids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate the central aperture size of the background image
edgeY=mod(dparam.ScrHeight,sparam.patch_num(1)); % delete exceeded region
p_height=round((dparam.ScrHeight-edgeY)/sparam.patch_num(1)); % height in pix of patch_height + interval-Y

edgeX=mod(dparam.ScrWidth,sparam.patch_num(2)); % delete exceeded region
p_width=round((dparam.ScrWidth-edgeX)/sparam.patch_num(2)); % width in pix of patch_width + interval-X

aperture_size(1)=2*( p_height*ceil(size(tmp_slant_field,1)/2/p_height) );
aperture_size(2)=2*( p_width*ceil(size(tmp_slant_field,2)/sparam.oversampling_ratio/2/p_width) );
%aperture_size=[500,500];

bgimg=CreateBackgroundImage([dparam.ScrHeight,dparam.ScrWidth],...
          aperture_size,sparam.patch_size,sparam.bgcolor,sparam.patch_color1,sparam.patch_color2,sparam.fixcolor,sparam.patch_num,0,0,0);
background=Screen('MakeTexture',winPtr,bgimg{1});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Creating the central fixation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create fixation cross images
[fix_L,fix_R]=CreateFixationImg(sparam.fixsize,sparam.fixcolor,sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
fcross{1}=Screen('MakeTexture',winPtr,fix_L);
fcross{2}=Screen('MakeTexture',winPtr,fix_R);

[fix_L,fix_R]=CreateFixationImg(sparam.fixsize,[255,0,0],sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
probe_fcross{1}=Screen('MakeTexture',winPtr,fix_L);
probe_fcross{2}=Screen('MakeTexture',winPtr,fix_R);

[fix_L,fix_R]=CreateFixationImg(sparam.fixsize,[32,32,32],sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
wait_fcross{1}=Screen('MakeTexture',winPtr,fix_L);
wait_fcross{2}=Screen('MakeTexture',winPtr,fix_R);

if sparam.give_feedback
  [fix_L,fix_R]=CreateFixationImg(sparam.fixsize,[0,255,0],sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
  correct_fcross{1}=Screen('MakeTexture',winPtr,fix_L);
  correct_fcross{2}=Screen('MakeTexture',winPtr,fix_R);

  [fix_L,fix_R]=CreateFixationImg(sparam.fixsize,[0,0,255],sparam.bgcolor,sparam.fixlinesize(2),sparam.fixlinesize(1),0,0);
  incorrect_fcross{1}=Screen('MakeTexture',winPtr,fix_L);
  incorrect_fcross{2}=Screen('MakeTexture',winPtr,fix_R);
end
clear fix_L fix_R;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Prepare blue lines for stereo image flip sync with VPixx PROPixx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% There seems to be a blueline generation bug on some OpenGL systems.
% SetStereoBlueLineSyncParameters(winPtr, winRect(4)) corrects the
% bug on some systems, but breaks on other systems.
% We'll just disable automatic blueline, and manually draw our own bluelines!

if strcmpi(dparam.ExpMode,'propixxstereo')
  SetStereoBlueLineSyncParameters(winPtr, winRect(4)+10);
  blueRectOn(1,:)=[0, winRect(4)-1, winRect(3)/4, winRect(4)];
  blueRectOn(2,:)=[0, winRect(4)-1, winRect(3)*3/4, winRect(4)];
  blueRectOff(1,:)=[winRect(3)/4, winRect(4)-1, winRect(3), winRect(4)];
  blueRectOff(2,:)=[winRect(3)*3/4, winRect(4)-1, winRect(3), winRect(4)];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% image size adjustments to match the current display resolutions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if dparam.fullscr
  ratio_wid=( winRect(3)-winRect(1) )/dparam.ScrWidth;
  ratio_hei=( winRect(4)-winRect(2) )/dparam.ScrHeight;
  stimSize = [size(tmp_slant_field,2)*ratio_wid size(tmp_slant_field,1)*ratio_hei].*[1/sparam.oversampling_ratio,1];
  bgSize=[size(bgimg{1},2)*ratio_wid,size(bgimg{1},1)*ratio_hei];
  fixSize=[2*sparam.fixsize*ratio_wid,2*sparam.fixsize*ratio_hei];
else
  stimSize=[size(tmp_slant_field,2),size(tmp_slant_field,1)].*[1/sparam.oversampling_ratio,1];
  bgSize=[dparam.ScrWidth,dparam.ScrHeight];
  fixSize=[2*sparam.fixsize,2*sparam.fixsize];
end

% for some display modes in which one screen is splitted into two binocular displays
if strcmpi(dparam.ExpMode,'cross') || strcmpi(dparam.ExpMode,'parallel') || ...
   strcmpi(dparam.ExpMode,'topbottom') || strcmpi(dparam.ExpMode,'bottomtop')
  stimSize=stimSize./2;
  bgSize=bgSize./2;
  fixSize=fixSize./2;
end

stimRect=[0,0,stimSize]; % used to display target stimuli
bgRect=[0,0,bgSize]; % used to display background images;
fixRect=[0,0,fixSize]; % used to display the central fixation point

% set display shift along y-axis
yshift=[0,dparam.yshift,0,dparam.yshift];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Saving the current parameters temporally
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% saving the current parameters
% (this is required to analyze part of the data obtained even when the experiment is interrupted unexpectedly)
fprintf('saving the stimulus generation and presentation parameters...');
savefname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'.mat']);

% backup the old file(s)
if ~overwrite_flg
  rdir=relativepath(resultDir); rdir=rdir(1:end-1);
  BackUpObsoleteFiles(rdir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'.mat'],'_old');
  clear rdir;
end

% save the current parameters
eval(sprintf('save %s subjID acq design sparam dparam gamma_table;',savefname));

fprintf('done.\n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Displaying 'Ready to Start'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% displaying texts on the center of the screen
DisplayMessage2('Ready to Start',sparam.bgcolor,winPtr,nScr,'Arial',36);
ttime=GetSecs(); while (GetSecs()-ttime < 0.5), end  % run up the clock.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Flip the display(s) to the background image(s) and inform the ready of stimulus presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% change the screen and wait for the trigger or pressing the start button
for nn=1:1:nScr
  Screen('SelectStereoDrawBuffer',winPtr,nn-1);
  Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
  Screen('DrawTexture',winPtr,wait_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);

  % blue line for stereo sync
  if strcmpi(dparam.ExpMode,'propixxstereo')
    Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
    Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
  end
end
Screen('DrawingFinished',winPtr);
Screen('Flip', winPtr,[],[],[],1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Wait for the start of the measurement
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add time stamp (this also works to load add_event method in memory in advance of the actual displays)
fprintf('\nWaiting for the start...\n');
event=event.add_event('Experiment Start',strcat([datestr(now,'yymmdd'),' ',datestr(now,'HH:mm:ss')]),NaN);

% waiting for stimulus presentation
resps.wait_stimulus_presentation(dparam.start_method,dparam.custom_trigger);
PlaySound(1);
fprintf('\nExperiment running...\n');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Event logs and timer (!start here!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[event,the_experiment_start]=event.set_reference_time(GetSecs());
targetTime=the_experiment_start;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Initial Fixation Period
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% wait for the initial fixation period
if sparam.initial_fixation_time~=0
  event=event.add_event('Initial Fixation',[]);
  fprintf('\nfixation\n\n');

  for nn=1:1:nScr
    Screen('SelectStereoDrawBuffer',winPtr,nn-1);
    Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
    Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);

    % blue line for stereo sync
    if strcmpi(dparam.ExpMode,'propixxstereo')
      Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
      Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
    end
  end
  Screen('DrawingFinished',winPtr);
  Screen('Flip', winPtr,[],[],[],1);

  % wait for the initial fixation
  targetTime=targetTime+sparam.initial_fixation_time;
  while GetSecs()<targetTime, [resps,event]=resps.check_responses(event); end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% The Trial Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tBetweenTrial=GetSecs();
for currenttrial=1:1:numel(stimulus_order)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Stimulus generation
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % get the current stimulus ID
  stimID=stimulus_order(currenttrial);

  % set the current stimulus parameters
  theta_deg=design(stimID,1);
  orient_deg=design(stimID,2);

  trial_counter(stimID)=trial_counter(stimID)+1;

  % set recommended stimulus intensity using QUEST algorithm
  % Choose your favorite algorithm.
  angle=QuestQuantile(quest_data{stimID});  % Recommended by Pelli (1987), and still our favorite.
  % angle=QuestMean(quest_data{stimID});    % Recommended by King-Smith et al. (1994)
  % angle=QuestMode(quest_data{stimID});    % Recommended by Watson & Pelli (1983);

  % convert the log magnitude to the actual angle and scaling
  angle=sparam.maxValue*10^angle;
  angle=min(angle,sparam.maxValue);
  angle=max(angle,0);

  estimation_matrix{stimID}(trial_counter(stimID),1)=angle;

  %jitter=shuffle(-2:2); jitter=jitter(1);
  jitter=0;
  tilt_deg=zeros(2,1);
  for ii=1:1:2 % generating two slants for 2-AFC

    % add tilts to the grating_deg with jitter
    % type 1: tilted slightly clockwisely
    % type 2: tilted slightly counter-clockwisely
    tilt_deg(ii)=theta_deg+(-1).^ii*angle/2+jitter;

    % generate slant height field with sinusoidal grating
    if ~strcmpi(sparam.mask_type{stimID},'xy')
      slant_field=sla_CreateCircularSlantField(sparam.fieldSize,tilt_deg(ii),orient_deg,sparam.aperture_deg,...
                                               sparam.fill_val,sparam.outer_val,sparam.pix_per_deg,sparam.oversampling_ratio);
    else
      slant_field=sla_CreatePlaneSlantField(sparam.fieldSize,tilt_deg(ii),orient_deg,sparam.pix_per_deg,sparam.oversampling_ratio);
    end
    slant_field=slant_field.*sparam.cm_per_pix;

    % put XY-mask on the slant_field
    if strcmpi(sparam.mask_type{stimID},'xy')
      slant_field=slant_field.*smask(:,:,sparam.mask_orient_id(stimID));
      slant_field(smask(:,:,sparam.mask_orient_id(stimID))~=1)=sparam.outer_val;
    end

    % put Z-mask on the slant_field
    if strcmpi(sparam.mask_type{stimID},'z')
      maxH=mean(max_height(:,sparam.mask_orient_id(stimID))); %maxH=min(max_height(:,sparam.mask_orient_id(stimID)));
      minH=mean(min_height(:,sparam.mask_orient_id(stimID))); %minH=max(min_height(:,sparam.mask_orient_id(stimID)));
      zmask=zeros(size(slant_field));
      zmask(minH<=slant_field & slant_field<=maxH)=1;
      slant_field(slant_field<minH | maxH<slant_field)=sparam.outer_val;
    end

    % calculate left/right eye image shifts
    [posL,posR]=RayTrace_ScreenPos_X_MEX(slant_field,ipd,vdist,pix_per_cm_x,0);

    % generate RDS images with/without mask
    % if masking_the_outer_region_flg is set, mask all the dots located in the outer region
    if ~isstructmember(sparam,'masking_the_outer_region_flg'), sparam.masking_the_outer_region_flg=0; end
    if sparam.masking_the_outer_region_flg
      if strcmpi(sparam.mask_type{stimID},'n')
        [imgL,imgR]=sla_RDSfastest_with_noise_with_mask_MEX(posL,posR,wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3),smask(:,:,sparam.mask_orient_id(stimID)));
      elseif strcmpi(sparam.mask_type{stimID},'xy')
        [imgL,imgR]=sla_RDSfastest_with_noise_with_mask_MEX(posL,posR,wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3),smask(:,:,sparam.mask_orient_id(stimID)));
      elseif strcmpi(sparam.mask_type{stimID},'z')
        [imgL,imgR]=sla_RDSfastest_with_noise_with_mask_MEX(posL,posR,wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3),zmask);
      end
    else
      [imgL,imgR]=sla_RDSfastest_with_noise_MEX(posL,posR,wdot,bdot,dotalpha,dotDens,sparam.noise_level,sparam.colors(3));
    end

    stim{1}{ii}=Screen('MakeTexture',winPtr,imgL); % the first 1 = left (the first screen)
    if sparam.binocular_display % display binocular image
      stim{2}{ii}=Screen('MakeTexture',winPtr,imgR); % the first 2 = right (the second screen)
    else
      stim{2}{ii}=Screen('MakeTexture',winPtr,imgL);
    end

  end % for ii=1:1:2 % for 2-AFC

  % wait for the BetweenDuration
  tBetweenTrial=tBetweenTrial+sparam.BetweenDuration+(100*randi(6,1)-100)/1000; % (100*randi(6,1)-100)/1000 is random jitter of duration [0-500,100ms steps]
  while GetSecs()<tBetweenTrial, [resps,event]=resps.check_responses(event); end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Stimulus display & animation
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  tStimulation=GetSecs(); % current time
  torder=shuffle(1:2); % trial order, to randomize stimulus presentation order
  second_stim_flag=1;  % to omit stimulus off period after the second stimulus is presented
  for ii=torder

    %% log/display the stimulus parameters
    event=event.add_event('Start block',['ID_',num2str(stimID),'_theta_',num2str(theta_deg),'_orient_',num2str(orient_deg),...
                          '_angle_',num2str(angle),'_trials_',num2str(trial_counter(stimID),'%03d'),'_type_',num2str(ii,'%02d')]);
    fprintf('ID:%02d, THETA:% 3.2f, ORIENTATION:% 3d, ANGLE:% 3.2f, TRIALS:%03d, TYPE:%02d\n',...
            stimID,theta_deg,orient_deg,tilt_deg(ii),trial_counter(stimID),ii);
    if second_stim_flag==2, fprintf('\n'); end

    %% display a probe (a red fixation) before presenting the stimulus
    if second_stim_flag~=2
      if sparam.stim_on_probe_duration(1)~=0
        event=event.add_event('Probe',[]);
        for nn=1:1:nScr
          Screen('SelectStereoDrawBuffer',winPtr,nn-1);
          Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
          Screen('DrawTexture',winPtr,probe_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);

          % blue line for stereo sync
          if strcmpi(dparam.ExpMode,'propixxstereo')
            Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
            Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
          end
        end
        Screen('DrawingFinished',winPtr);
        Screen('Flip',winPtr,[],[],[],1);

        % wait for stim_on_probe_duration(1)
        tStimulation=tStimulation+sparam.stim_on_probe_duration(1);
        while GetSecs()<tStimulation, [resps,event]=resps.check_responses(event); end
      end

      if sparam.stim_on_probe_duration(2)~=0
        for nn=1:1:nScr
          Screen('SelectStereoDrawBuffer',winPtr,nn-1);
          Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
          Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);

          % blue line for stereo sync
          if strcmpi(dparam.ExpMode,'propixxstereo')
            Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
            Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
          end
        end
        Screen('DrawingFinished',winPtr);
        Screen('Flip',winPtr,[],[],[],1);

        % wait for stim_on_probe_duration(2)
        tStimulation=tStimulation+sparam.stim_on_probe_duration(2);
        while GetSecs()<tStimulation, [resps,event]=resps.check_responses(event); end
      end
    end % if second_stim_flag~=2

    %% stimulus ON
    for nn=1:1:nScr
      Screen('SelectStereoDrawBuffer',winPtr,nn-1);
      Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
      Screen('DrawTexture',winPtr,stim{nn}{ii},[],CenterRect(stimRect,winRect)+yshift);
      Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);

      % blue line for stereo sync
      if strcmpi(dparam.ExpMode,'propixxstereo')
        Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
        Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
      end
    end
    Screen('DrawingFinished',winPtr);
    Screen('Flip',winPtr,[],[],[],1);

    % wait for stim_on_duration
    tStimulation=tStimulation+sparam.stim_on_duration;
    while GetSecs()<tStimulation, [resps,event]=resps.check_responses(event); end

    %% stimulus OFF
    event=event.add_event('Stimulus off',[]);
    if second_stim_flag~=2
      for nn=1:1:nScr
        Screen('SelectStereoDrawBuffer',winPtr,nn-1);
        Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
        Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);

        % blue line for stereo sync
        if strcmpi(dparam.ExpMode,'propixxstereo')
          Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
          Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
        end
      end
      Screen('DrawingFinished',winPtr);
      Screen('Flip',winPtr,[],[],[],1);

      % wait for stim_off_duration
      tStimulation=tStimulation+sparam.stim_off_duration;
      while GetSecs()<tStimulation, [resps,event]=resps.check_responses(event); end
    end % if second_stim_flag~=2

    second_stim_flag=second_stim_flag+1;
  end % for ii=torder

  %% get observer response

  % display response cue
  event=event.add_event('Waiting for response',[]);
  for nn=1:1:nScr
    Screen('SelectStereoDrawBuffer',winPtr,nn-1);
    Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
    Screen('DrawTexture',winPtr,wait_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);

    % blue line for stereo sync
    if strcmpi(dparam.ExpMode,'propixxstereo')
      Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
      Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
    end
  end
  Screen('DrawingFinished',winPtr);
  Screen('Flip',winPtr,[],[],[],1);

  % get observer's response

  % the line below are just for debugging of response acquisitions and plotting results
  %respFlag=mod(randi(2,[1,1]),2);

  respFlag=0;
  while ~respFlag
    [x,y,button]=GetMouse(); %#ok
    [resps,event,keyCode]=resps.check_responses(event);
    if (keyCode(dparam.Key1) && torder(1)==1) || (keyCode(dparam.Key2) && torder(2)==1) || ...
       (button(1) && torder(1)==1) || (button(3) && torder(2)==1) % correct response
      event=event.add_event('Response','The first is more slanted.');
      respFlag=1;
    elseif (keyCode(dparam.Key1) && torder(2)==1) || (keyCode(dparam.Key2) && torder(1)==1) || ...
           (button(1) && torder(2)==1) || (button(3) && torder(1)==1) % incorrect response
      event=event.add_event('Response','The second is more slanted.');
      respFlag=-1;
    end
  end

  estimation_matrix{stimID}(trial_counter(stimID),2)=double(respFlag>0);

  % update stimulus intensity in the QUEST structure
  quest_data{stimID}=QuestUpdate(quest_data{stimID},log10(angle/sparam.maxValue),double(respFlag>0));
  estimation_matrix{stimID}(trial_counter(stimID),3)=sparam.maxValue*10^QuestMean(quest_data{stimID});
  estimation_matrix{stimID}(trial_counter(stimID),4)=sparam.maxValue*10^QuestSd(quest_data{stimID});

  %% give correct/incorrect feedback and wait for dparam.BetweenDuration (duration between trials)
  if sparam.give_feedback
    tFeedback=GetSecs();

    if respFlag==1 % correct response
      event=event.add_event('Feedback','correct');
    else % if respFlag==-1 % incorrect response
      event=event.add_event('Feedback','incorrect');
    end
    for nn=1:1:nScr
      Screen('SelectStereoDrawBuffer',winPtr,nn-1);
      Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
      if respFlag==1
        Screen('DrawTexture',winPtr,correct_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
      else
        Screen('DrawTexture',winPtr,incorrect_fcross{nn},[],CenterRect(fixRect,winRect)+yshift);
      end

      % blue line for stereo sync
      if strcmpi(dparam.ExpMode,'propixxstereo')
        Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
        Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
      end
    end
    Screen('DrawingFinished',winPtr);
    Screen('Flip',winPtr,[],[],[],1);
    PlaySound(respFlag>0);

    % wait for feedback_duration
    tFeedback=tFeedback+sparam.feedback_duration;
    while GetSecs()<tFeedback, [resps,event]=resps.check_responses(event); end
  end % if sparam.give_feedback

  %% back to the default view and wait for dparam.BetweenDuration (duration between trials)

  tBetweenTrial=GetSecs();

  for nn=1:1:nScr
    Screen('SelectStereoDrawBuffer',winPtr,nn-1);
    Screen('DrawTexture',winPtr,background,[],CenterRect(bgRect,winRect)+yshift);
    Screen('DrawTexture',winPtr,fcross{nn},[],CenterRect(fixRect,winRect)+yshift);

    % blue line for stereo sync
    if strcmpi(dparam.ExpMode,'propixxstereo')
      Screen('FillRect',winPtr,[0,0,255],blueRectOn(nn,:));
      Screen('FillRect',winPtr,[0,0,0],blueRectOff(nn,:));
    end
  end
  Screen('DrawingFinished',winPtr);
  Screen('Flip',winPtr,[],[],[],1);

  % garbage collections, clean up the current texture & release memory
  for ii=1:1:2
    for nn=1:1:nScr
      Screen('Close',stim{ii}{nn});
    end
  end

end % for currenttrial=1:1:numel(stimulus_order)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Experiment ends here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experimentDuration=GetSecs()-the_experiment_start;
event=event.add_event('End',[]);

fprintf(['\nExperiment Duration was: ', num2str(experimentDuration), ' secs\n\n']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Write experiment parameters and results into a file for post analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% calculate threshold from QUEST data structure
angle_thresholds=size(design,1);
angle_SDs=size(design,1);
for ii=1:1:size(design,1)
  angle_thresholds(ii)=sparam.maxValue*10.^QuestMean(quest_data{ii});
  angle_SDs(ii)=sparam.maxValue*10.^QuestSd(quest_data{ii});
end

% display the results
fprintf('\n****************************************\n');
fprintf('Estimated thresholds(+/-SDs) are as below\n')
fprintf('****************************************\n');
for ii=1:1:size(design,1)
  fprintf('THETA:%.2f,ORIENTATION:%.2f,thres: %.2f(+/-%.2f)\n',...
          design(ii,1),design(ii,2),angle_thresholds(ii),angle_SDs(ii));
end
fprintf('****************************************\n\n');

% saving the results
fprintf('saving data...');

savefname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'.mat']);
eval(sprintf('save -append %s angle_thresholds angle_SDs estimation_matrix quest_data event;',savefname));
fprintf('done.\n');

% tell the experimenter that the measurements are completed
try
  for ii=1:1:3, Snd('Play',sin(2*pi*0.2*(0:900)),8000); end
catch
  % do nothing
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% calculate & display task performance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% bar graph
figure; hold on;
for ii=1:1:numel(angle_thresholds)
  bar(ii,angle_thresholds(ii));
end
xlim=[0,numel(angle_thresholds)+1];
xtick=xlim(1)+1:1:xlim(2)-1;
set(gca,'XLim',xlim);
set(gca,'XTick',xtick);
title('slanted surfaces, angle discrimination performance');
xlabel('conditions');
ylabel('threshold (angle(deg))');

savefname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'_thresholds.fig']);
saveas(gcf,savefname,'fig');

%% raw estimation flow
figure; hold on;
%gcolors=rainbow(8);
gcolors=jet(8);
for ii=1:1:length(estimation_matrix)
  plot(estimation_matrix{ii}(:,3),'Color',gcolors(mod(ii,8)+1,:),'Marker','o','LineStyle','-');
  %errorbar((1:size(estimation_matrix{ii},1))',estimation_matrix{ii}(:,4),'Color',gcolors(mod(ii,8)+1,:),'LineStyle','-');
end
title('slanted surfaces discrimination, QUEST estimation against trials');
xlabel('#trials');
ylabel('threshold (angle(deg))');

savefname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'_estimations.fig']);
saveas(gcf,savefname,'fig');

%% Oblique effect in 3D space
figure;

% generate circular frames
R=7;%1.2*max(angle_thresholds);
xx=(0:0.1:2*pi+0.1)';
for ii=1:1:size(design,1)
  % affine rotation matrix for theta_deg
  rotY=[cos(design(ii,1)*pi/180) 0 sin(design(ii,1)*pi/180); 0 1 0; -sin(design(ii,1)*pi/180) 0 cos(design(ii,1)*pi/180)];
  % affine rotation matrix for orient_deg
  rotZ=[cos(-design(ii,2)*pi/180) -sin(-design(ii,2)*pi/180) 0; sin(-design(ii,2)*pi/180) cos(-design(ii,2)*pi/180) 0; 0 0 1];

  % circular frames
  circular_frames=R*[cos(xx),sin(xx),zeros(size(xx,1),1)]*rotY*rotZ;
  plot3(circular_frames(:,1),circular_frames(:,2),circular_frames(:,3),'Color',[0.3,0.3,0.3],'LineStyle',':'); hold on;

  % calculate grating angle
  theta=design(ii,1)*pi/180;
  delta=-1*design(ii,2)*pi/180;

  grating_deg=[0,45,90,135];
  for aa=1:1:numel(grating_deg)
    phi=grating_deg(aa)*pi/180; %design(ii,2)*pi/180;
    grating_angle=atan( (cos(theta)*cos(delta)*tan(phi)+cos(theta)*sin(delta))/(cos(delta)-sin(delta)*tan(phi)) );
    if design(ii,2)>90, grating_angle=pi+grating_angle; end
    if grating_angle>pi, grating_angle=grating_angle-pi; end

    % line frames
    line_frames(1,:)=R*[cos(grating_angle),sin(grating_angle),0]*rotY*rotZ;
    line_frames(2,:)=R*[cos(grating_angle+pi),sin(grating_angle+pi),0]*rotY*rotZ;
    if aa==1 % horizontal/vertical meridians
      plot3(line_frames(:,1),line_frames(:,2),line_frames(:,3),'Color',[0.5,0.0,0.0],'LineStyle',':','LineWidth',1.2); hold on;
    elseif aa==3 % horizontal/vertical meridians
      plot3(line_frames(:,1),line_frames(:,2),line_frames(:,3),'Color',[0.0,0.5,0.0],'LineStyle',':','LineWidth',1.2); hold on;
    else
      plot3(line_frames(:,1),line_frames(:,2),line_frames(:,3),'Color',[0.3,0.3,0.3],'LineStyle',':'); hold on;
    end
  end
  axis square; axis equal;
end

% plot threshold
xyz=zeros(size(design,1),3);
xyz2=zeros(size(design,1),3);
for ii=1:1:size(design,1)
  % affine rotation matrix for theta_deg
  rotY=[cos(design(ii,1)*pi/180) 0 sin(design(ii,1)*pi/180); 0 1 0; -sin(design(ii,1)*pi/180) 0 cos(design(ii,1)*pi/180)];
  % affine rotation matrix for orient_deg
  rotZ=[cos(-design(ii,2)*pi/180) -sin(-design(ii,2)*pi/180) 0; sin(-design(ii,2)*pi/180) cos(-design(ii,2)*pi/180) 0; 0 0 1];

  % calculate grating angle
  theta=design(ii,1)*pi/180;
  delta=-1*design(ii,2)*pi/180;
  phi=design(ii,2)*pi/180;
  grating_angle=atan( (cos(theta)*cos(delta)*tan(phi)+cos(theta)*sin(delta))/(cos(delta)-sin(delta)*tan(phi)) );
  if design(ii,2)>90, grating_angle=pi+grating_angle; end
  if grating_angle>pi, grating_angle=grating_angle-pi; end

  % magnitude along right horizontal meridian
  val=angle_thresholds(ii)*[cos(grating_angle),sin(grating_angle),0];
  val2=angle_thresholds(ii)*[cos(grating_angle+pi),sin(grating_angle+pi),0];

  % plotting
  xyz(ii,:)=val*rotY*rotZ;
  xyz2(ii,:)=val2*rotY*rotZ;
end

plot3([xyz(:,1);xyz2(:,1);xyz(1,1)],...
      [xyz(:,2);xyz2(:,2);xyz(1,2)],...
      [xyz(:,3);xyz2(:,3);xyz(1,3)],...
      'Color',[0,1,1],'Marker','o','LineStyle','-');
hold on;
title('3D oblique: angle discrimination performance on each slant');

savefname=fullfile(resultDir,[num2str(subjID),sprintf('_%s_run_',mfilename()),num2str(acq,'%02d'),'_oblique.fig']);
saveas(gcf,savefname,'fig');

close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Cleaning up the PTB screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('CloseAll');

% closing datapixx
if strcmpi(dparam.ExpMode,'propixxmono') || strcmpi(dparam.ExpMode,'propixxstereo')
  if Datapixx('IsViewpixx3D')
    Datapixx('DisableVideoLcd3D60Hz');
    Datapixx('RegWr');
  end
  Datapixx('Close');
end

ShowCursor();
Priority(0);
GammaResetPTB(1.0);
rmpath(genpath(fullfile(rootDir,'..','Common')));
rmpath(fullfile(rootDir,'..','gamma_table'));
rmpath(fullfile(rootDir,'..','Generation'));
clear all; clear mex; clear global;
diary off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Catch the errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

catch %#ok
  % this "catch" section executes in case of an error in the "try" section
  % above.  Importantly, it closes the onscreen window if its open.
  Screen('CloseAll');

  if exist('dparam','var')
    if isstructmember(dparam,'ExpMode')
      if strcmpi(dparam.ExpMode,'propixxmono') || strcmpi(dparam.ExpMode,'propixxstereo')
        if Datapixx('IsViewpixx3D')
          Datapixx('DisableVideoLcd3D60Hz');
          Datapixx('RegWr');
        end
        Datapixx('Close');
      end
    end
  end

  ShowCursor();
  Priority(0);
  GammaResetPTB(1.0);
  tmp=lasterror; %#ok
  if exist('event','var'), event=event.get_event(); end %#ok % just for debugging
  diary off;
  fprintf(['\nError detected and the program was terminated.\n',...
           'To check error(s), please type ''tmp''.\n',...
           'Please save the current variables now if you need.\n',...
           'Then, quit by ''dbquit''\n']);
  keyboard;
  rmpath(genpath(fullfile(rootDir,'..','Common')));
  rmpath(fullfile(rootDir,'..','gamma_table'));
  rmpath(fullfile(rootDir,'..','Generation'));
  clear all; clear mex; clear global;
  return
end % try..catch


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% That's it - we're done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return
% end % function StereoQUESTsample
