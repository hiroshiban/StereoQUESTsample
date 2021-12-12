# **README on StereoQUESTsample**

<div align="right">
Created    : "2018-10-04 15:21:12 ban"<br>
Last Update: "2021-12-13 07:29:30 ban"
</div>

<br>
<div align="center">
<img src="https://img.shields.io/badge/LANGUAGE-MATLAB-brightgreen" />
<img src="https://img.shields.io/badge/DEPENDENCY-Psychtoolbox3-green" />
<img src="https://img.shields.io/badge/EDITED%20BY-EmEditor%20&%20VS%20Code-blue" />
<img src="https://img.shields.io/badge/LICENSE-BSD-red" /><br>
<img src="https://img.shields.io/badge/KEYWORDS-Vision%20Science,%203D,%20Stereo,%20Binocular,%20Perception,%20Recognition,%20fMRI,%20MEG,%20EEG,%20&%20Psychophysics-blue?style=social&logo=webauthn" /><br>
<img src="https://img.shields.io/badge/CONTACT-lightgrey" /> <img src="doc/images/ban_hiroshi_address.png" />
</div>
<br>

***

## **StereoQUESTsample**


![StereoQUESTsample](imgs/StereoQUESTsample.png)  

**Sample stimulus presentation codes for stereo vision psychophysics experiment (QUEST method) in our research group**  

- This package contains a set of sample **MATLAB and Psychtoolbox-3 (PTB3)** scripts for QUEST psychophysics experiment on 3D vision (QUEST is one of the adaptive staircase methods, that enables to estimate perceptual thresholds effectively).
- It displays tilted and/or slanted circular planes defined by binocular disparities (+/- arcmins) for testing psychophysical disparity discrimination thresholds.
- Here the "threshold" means the minimum discriminable angles (at 82% accuracies by default) between the two tilted and/or slanted planes at specific depth positions, irrelevant to the sign of the depth (differences of top-near and top-far slants are ignored).
- This script should be run with MATLAB PTB3 ver 3.0.15 or above (not tested with pervious versions of PTB3 and PTB2).
- - Please note that, in general, if we use PTB3, RDS stimuli can be easily generated with Screen('DrawDots') function. However, the dots generated with the simple PTB3 function are not antialiased, which may cause some problem due to round-offs of the fine depth structures. Therefore, in this function, I am taking a different strategy to generate RDSs by putting antialiased (Gaussian-smoothed) dots with alpha-channel (transparency) setups and by oversampling the position shift (horizontal binocular disparity). That is why the stimulus generation pipeline in this function is a bit complicated. If you don't care such the antialiased matter at all, the script can be made more concise and much simpler. Maybe there's a better way...
- ***Finally, this package is made publicly available in the hope of keeping our research group being transparent and open. Furthermore, the package is made open also for people who want to know our group's research activities, who want to join our group in the near future, and who want to learn how to create stereo stimuli for vision science. If you are interested in our research projects, please feel free to contact us.*** Anyway, to these ends, I have tried to make the samples as simple as possible (but also as real as possible so as to be available in the real experiments in the form of what this package is) with omitting any kinds of hacking-like codes to compensate stimulus presentation timings etc. If you need such routines, please check the other stimulus presentation codes in my [**Retinotopy**](https://github.com/hiroshiban/retinotopy) repository etc.).

(Matlab is a registered trademark of [***The Mathworks Inc.*** ](https://www.mathworks.com/) )  

Thank you for using our software package.  
We are happy if this sample can somehow help your research projects.  

**Stimulus presentation and tasks**

The presentation will start by pressing the start button you defined as sparam.start_method. The tilted or slanted circle made of RDS will be presented, following a 2IFC(AFC) task design.  By default, the sample script presents stimuli follow the protocol below:  
&nbsp;&nbsp; ***stim 1-1(150ms) -- blank(350ms) -- stim 1-2(150ms) -- response --***  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ***blank or feedback(300ms) -- between trial duration (500-1000ms, jittered) --***  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ***stim 2-1(300ms) -- blank(200ms) -- stim 2-2(300ms) -- response -- blank or feedback(300ms) --***  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ***between trial duration (500-1000ms, jittered) ..(continued)...***  

After each of the stimulus presentations, participants are asked to discriminate which (the first or the second) stimulus is more tilted or slanted; they are requested to press  
  - key 1 (or left-mouse click) when the first slant is more tilted or slanted  
  - key 2 (or right-mouse click) when the second slant is more tilted or slanted  
    NOTE: Key 1 and key 2 are defined in the display parameter file.  

If ***sparam.give_feedback*** is set to 'true', correct/incorrect feedback is given to observer per trial.
  - Correct  : the central fixation turns to green with a high-tone sound
  - Incorrect: the central fixation turns to blue with a low-tone sound

For more details, please read the descriptions below.  
Also please check the header comments in ~/StereoQUESTsample/Presentation/StereoQUESTsample.m.  

## **Acknowledgment**

The StereoQUESTsample package uses **Psychtoolboox** library for generating/presenting/controlling binocular disparity stimuli. We would like to express our sincere gratitude to the authors for sharing the great toolbox.  

**Psychtoolbox** : The individual Psychtoolbox core developers,  
            (c) 1996-2011, David Brainard  
            (c) 1996-2007, Denis Pelli, Allen Ingling  
            (c) 2005-2011, Mario Kleiner  
            Individual major contributors:  
            (c) 2006       Richard F. Murray  
            (c) 2008-2011  Diederick C. Niehorster  
            (c) 2008-2011  Tobias Wolf  
            [ref] [http://psychtoolbox.org/HomePage](http://psychtoolbox.org/HomePage)


## **How to run the script**

1. On the MATLAB shell, please change the working directory to  
   *~/StereoQUESTsample/Presentation/*  
2. Run the "***run_exp***" script as  

   ````MATLAB
   >> run_exp('subj_name',exp_id,acq_id);
   ````

   Here, 'run_exp' is a simple script that calls the main StereoQUESTsample function. The first input variable is subject name or ID, such as 'HB' or 's01'. The second variable should be 0 (for practice) or 1,2,3,.. (main experiment). Please prepare a stimulus_file for each of your experiment conditions and save it like stim_fname=sprintf('slant_stimulus_%02d',exp_id);. Then, by specifying the experiment condition by exp_id, you can run all the required experiment from this script. Multiple numbers (array) can be accepted. The third variable is run number, 1,2,3,...  

For more details, please see the documents in *StereoQUESTsample.m*  
Also please see the parameter files in *~/StereoQUESTsample/Presentation/subj/_DEFAULT_/*.  

For checking the routines of stimulus generations, please see  
*~/StereoQUESTsample/Generation* and *~/StereoQUESTsample/Common* directories.


## **Usage**

```Matlab
function StereoQUESTsample(subjID,acq,:displayfile,:stimlusfile,:gamma_table,:overwrite_flg,:force_proceed_flag)
(: is optional)
```


## **Example**

```Matlab
>> StereoQUESTsample('s01',1,'slant_display.m','slant_stimulus_exp1.m')
```


## **Input variables**

<pre>
sujID         : ID of subject, string, such as 's01'
                !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
                !!! if 'debug' (case insensitive) is included          !!!
                !!! in subjID string, this program runs as DEBUG mode; !!!
                !!! stimulus images are saved as *.png format at       !!!
                !!! ~/StereoQUESTsample/Presentation/images            !!!
                !!!!!!!!!!!!!!!!!! IMPORTANT NOTE !!!!!!!!!!!!!!!!!!!!!!!!
acq           : acquisition number (design file number),
                a integer, such as 1, 2, 3, ...
displayfile   : (optional) display condition file, such as 'shadow_display_fmri.m'
                as an example, please see ~/StereoQUESTsample/subjects/_DEFAULT_/nf_display.m
stimulusfile  : (optional) stimulus condition file, such as 'shadow_stimulus_exp1.m'
                all of the stimuli in this script are generated in real-time based on
                the parameters in the stimulus file. For details, please see this
                function and the other function in ../Generation and ../Common directories.
                as an example, please see ~/StereoQUESTsample/subjects/_DEFAULT_/nf_stimulus.m
gamma_table   : (optional) table(s) of gamma-corrected video input values (Color LookupTable).
                256(8-bits) x 3(RGB) x 1(or 2,3,... when using multiple displays) matrix
                or a *.mat file specified with a relative path format. e.g. '/gamma_table/gamma1.mat'
                The *.mat should include a variable named "gamma_table" consists of a 256x3xN matrix.
                if you use multiple (more than 1) displays and set a 256x3x1 gamma-table, the same
                table will be applied to all displays. if the number of displays and gamma tables
                are different (e.g. you have 3 displays and 256x3x!2! gamma-tables), the last
                gamma_table will be applied to the second and third displays.
                if empty, normalized gamma table (repmat(linspace(0.0,1.0,256),3,1)) will be applied.
overwrite_flg : (optional) whether overwriting pre-existing result file. if 1, the previous result
                file with the same acquisition number will be overwritten by the previous one.
                if 0, the existing file will be backed-up by adding a prefix '_old' at the tail
                of the file. 0 by default.
force_proceed_flag : (optional) whether proceeding stimulus presentation without waiting for
                the experimenter response (e.g. pressing the ENTER key) or a trigger.
                if 1, the stimulus presentation will be automatically carried on.

NOTE:
displayfile & stimulusfile should be located at
~/StereoQUESTsample/Presentation/subjects/(subjID)/, like
~/StereoQUESTsample/Presentation/subjects/(subjID)/slant_display.m, and
~/StereoQUESTsample/Presentation/subjects/(subjID)/slant_stimulus.m
</pre>


## **Output variable and result file** 

<pre>
no output variable. the results (stimulus presentation timings, participant responses) are saved in
~/StereoQUESTsample/Presentation/subjects/(subjID)/results/(today)
as (subjID)_StereoQUESTsample_results_run_(run_num).mat.
</pre>


## **Details of displayfile**

An example of "displayfile":  

````MATLAB
% ************************************************************
% This is the display file for StereoQUESTsample
% Please change the parameters below.
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2021-12-13 05:19:24 ban"
% ************************************************************

% display mode, one of "mono", "dual", "dualcross", "dualparallel",
% "cross", "parallel", "redgreen", "greenred", "redblue", "bluered",
% "shutter", "topbottom", "bottomtop", "interleavedline",
% "interleavedcolumn", "propixxmono", "propixxstereo"
dparam.ExpMode='shutter';%'cross';

% screen ID, generally 0 for a single display setup, 1 for dual display setup
dparam.scrID=1;

% a method to start stimulus presentation
% 0:ENTER/SPACE, 1:Left-mouse button, 2:the first MR trigger pulse (simulated key press),
% 3:waiting for a MR trigger pulse, checking onset of pin #11 of the parallel port,
% or 4:custom key trigger (wait for a key input that you specify as tgt_key).
dparam.start_method=1;

% a pseudo trigger key from the MR scanner when it starts,
% only valid when dparam.start_method=4;
dparam.custom_trigger=KbName(84);

% keyboard settings
dparam.Key1=37; % key 1 = near
dparam.Key2=39; % key 2 = far

% screen settings

% whether displaying the stimuli in full-screen mode or as is
% (the precise resolution), 'true' or 'false' (true)
dparam.fullscr=false;

% the resolution of the screen height
dparam.ScrHeight=1200;

% the resolution of the screen width
dparam.ScrWidth=1920;

% shift the screen center position along y-axis
% (to prevent the occlusion of the stimuli due to the coil)
dparam.yshift=30;

% whther skipping the PTB's vertical-sync signal test. if 1, the sync test is skipped
dparam.skip_sync_test=0;
````


## **Details of stimulusfile**

An example of "stimulusfile":  

````MATLAB
% ************************************************************
% This is the stimulus file for StereoQUESTsample
% Please change the parameters below.
%
% Created    : "2018-09-26 18:57:59 ban"
% Last Update: "2021-06-10 01:37:07 ban"
% ************************************************************

% "sparam" means "stimulus generation parameters"

% stimulus presentation mode

% true or false. if false, only left-eye images are presented to both eyes
% (required just to measure the effect of monocular cues in RDS)
sparam.binocular_display=true;

% true or false. if true, feedback (whether the response is correct or not)
% is given after each of the trials
sparam.give_feedback=true;

%%% target image generation
sparam.fieldSize=[12,12]; % target stimulus size in deg

% [Important notes on stimulus masks]
%
% * the parameters required to define stimulus masks
%
% sparam.mask_theta_deg  : a set of slopes of the slants to be used for masking.
%           the outer regions of the intersections of all these slants'
%           projections on the XY-axes are masked.
%           for instance, if sparam.mask_orient_deg=[-22.5,-45],
%           the -22.5 and -22.5 deg slants are first generated, their
%           non-zero components are projected on the XY plane,
%           and then a stimulus mask is generated in two ways.
%           1. 'xy' mask: the intersection of the two projections are
%              set to 1, while the oter regions are set to 1.
%              The mask is used to restrict the spatial extensions
%              of the target slants within the common spatial extent.
%           2. 'z'  mask: the disparity range of the slants are
%              restricted so that the maximum disparity values are
%              the average of all disparities contained in all set
%              of slants. using this mask, we can restrict the
%              disparity range across the different angles of the slants.
% sparam.mask_orient_deg : tilt angles of a set of slopes of the slants.
%           if multiple values are set, masks are generated separately
%           for each element of sparam.mask_orient_deg.
%           for instance, if
%           sparam.mask_theta_deg=[-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5];
%           and
%           sparam.mask_orient_deg=[45, 90];,
%           two masks are generated as below.
%           1. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 45 deg
%           2. -52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, and 52.5 deg slants tilted for 90 deg
%
% * how to set masks for the main slant stimuli
%
% to set the masks to the main slant stimuli, please use sparam.mask_type
% and sparam.mask_orient_id. for details, please see the notes below.

% for generating a mask, which is defined as a common filed of all
% the slants tilted by sparam.mask_theta_deg below.

% for masking, slopes of the slant stimuli in deg, orientation: right-upper-left
sparam.mask_theta_deg   = [-52.5, -37.5, -22.5, -7.5, 7.5, 22.5, 37.5, 52.5];

% for masking, tilted orientation of the slant in deg,
% from right horizontal meridian, counter-clockwise
sparam.mask_orient_deg  = [0,45,90,135];

% [Important notes on angles/orientations of the slants]
%
% * the parameters required to define stimulus conditions (slant stimuli)
%
% sparam.theta_deg
%    : angles of the slant, negative = top is near, a [1 x N (= #conditions)] matrix
% sparam.orient_deg
%    : tilted orientations of the slant in deg, a [1 x N (= #conditions)] matrix
% sparam.mask_type
%    : 'n':no mask, 'z':common disparity among slants, 'xy':common spatial extent,
%       a [1 x N (= #conditions)] cell
% sparam.mask_orient_id
%    : ID of the mask to be used, 1 = sparam.mask_orient_deg(1),
%      2 = sparam.mask_orient_deg(2), ...., a [1 x N (= #conditions)] matrix
%
%
% * the number of required slants in this experiment are: 8 slants X 4 orientations = 32.
%
% sparam.theta_deg      = repmat([ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5],[1,4]);
% sparam.orient_deg     = [0.*ones(1,8),45.*ones(1,8),90.*ones(1,8),135.*ones(1,8)];
% sparam.mask_type      = {repmat('xy',[1,32]};
% sparam.mask_orient_id = [1.*ones(1,8),2.*ones(1,8),3.*ones(1,8),4.*ones(1,8)];

sparam.theta_deg      = repmat([ -52.5, -37.5, -22.5,  -7.5,   7.5,  22.5,  37.5,  52.5],[1,4]);
sparam.orient_deg     = [0.*ones(1,8),45.*ones(1,8),90.*ones(1,8),135.*ones(1,8)];
sparam.mask_type      = repmat({'xy'},[1,32]);
sparam.mask_orient_id = [1.*ones(1,8),2.*ones(1,8),3.*ones(1,8),4.*ones(1,8)];

sparam.aperture_deg = 10; % size of circular aperture in deg
sparam.fill_val     = 0;  % value to fill the 'hole' of the circular aperture
sparam.outer_val    = 0;  % value to fill the outer region of slant field

% RDS parameters
sparam.noise_level=0;         % percentage of anti-correlated noise, [val]
sparam.dotRadius=[0.05,0.05]; % radius of RDS's white/black ovals, [row,col]
sparam.dotDens=2;             % density of dot in RDS image (1-100)
sparam.colors=[255,0,128];    % RDS colors [dot1,dot2,background](0-255)
sparam.oversampling_ratio=8;  % oversampling_ratio for fine scale RDS images, [val]

% stimulus display durations etc in 'msec'

% duration in msec for initial fixation, integer (msec)
sparam.initial_fixation_time=500;

% duration in msec for each condition, integer (msec)
sparam.condition_duration=500;

% durations in msec for presenting a probe before the actual stimulus presentation (msec)
% [duration_of_red_fixation,duration_of_waiting]. if [0,0], the probe is ignored.
sparam.stim_on_probe_duration=[100,100];

% duration in msec for simulus ON period for each trial, integer (msec)
sparam.stim_on_duration=150;

% duration in msec for correct/incorrect feedback, integer (msec)
sparam.feedback_duration=500;

% duration in msec between trials, integer (msec)
sparam.BetweenDuration=500;

% background color
sparam.bgcolor=[128,128,128];

% fixation size and color

% the whole size (a circular hole) of the fixation cross in pixel
sparam.fixsize=24;

% [height,width] of the fixation line in pixel
sparam.fixlinesize=[12,2];

% fixation color, RGB
sparam.fixcolor=[255,255,255];

% RGB for background patches

% background patch size, [height,width] in pixels, for stability of binocular viewing
sparam.patch_size=[30,30];

% the number of background patches along vertical and horizontal axis
sparam.patch_num=[20,40];

% patch colors, RGB
sparam.patch_color1=[255,255,255];
sparam.patch_color2=[0,0,0];

% viewing parameters

% loading from a separate file
run(fullfile(fileparts(mfilename('fullpath')),'sizeparams'));

% Or you can set parameters directly.
%sparam.ipd=6.4;
%sparam.pix_per_cm=57.1429;
%sparam.vdist=65;

% QUEST parameters

% loading from a separate file
run(fullfile(fileparts(mfilename('fullpath')),'QUESTparams'));

% Or you can set the parameters directly.
%sparam.numTrials=60;
%sparam.maxValue=15;
%sparam.initialValue=5; tmp=shuffle(0:3); sparam.initialValue=sparam.initialValue+tmp(1);
%sparam.tGuess=log10(sparam.initialValue/sparam.maxValue);
%sparam.tGuessSD=4;
%sparam.pThreshold=0.82; % 0.82 is equivalent to a 3-up-1-down standard staircase
%sparam.beta=3.5;
%sparam.delta=0.01;
%sparam.gamma=0.5;
````


## **License**  

<img src="https://img.shields.io/badge/LICENSE-BSD-red" /><br>

StereoQUESTsample -- Sample stimulus presentation codes for stereo vision psychophysics experiment (QUEST method) in our research group. Copyright (c) 2018 Hiroshi Ban. All rights reserved.  

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:  

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  

The views and conclusions contained in the software and documentation are those of the authors and should not be interpreted as representing official policies, either expressed or implied, of the FreeBSD Project.  
