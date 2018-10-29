function OK=run_exp(subj,exp_id,acq_id)

% function run_exp(subj,exp_id,acq_id)
% (: is optional)
%
% This is a batch function to run Oblique3D_QUEST function.
%
% It displays circular slant planes by binocular disparities (+/- arcmings)
% for testing psychophysical oblique effects in the 3D space.
% The script shoud be run with MATLAB Psychtoolbox version 3 or above.
%
% [input]
% subj   : subject's name, e.g. 'HB'
% exp_id : experiment ID that you want to run,
%          should be 0 (practive), or 1,2,3,...,8 (main experiments).
%          here exp_id 1 & 2:  90 deg slants (vertical)
%                      3 & 4:  90 deg slants (horizontal)
%                      5 & 6:  45 deg slants (from right-horizontal meridian, counter-clockwise)
%                      7 & 8: 135 deg slants (from right-horizontal meridian, counter-clockwise)
%          multiple numbers (array) can be accepted.
%          numel(exp_id) should be the same with numel(acq_id).
% acq_id : acquisition number (run), 1,2,3,...
%          multiple numbers (array) can be accepted
%          numel(exp_id) should be the same with numel(acq_id)
%
% [output]
% OK      : whether this script runned
%           without any error [true/false]
%
% Created    : "2018-09-27 11:47:05 ban"
% Last Update: "2018-10-29 14:06:53 ban"

% check the input variables
if nargin<3, help(mfilename()); return; end
if ~isempty(find(acq_id<1,1)), error('acq_id should be 1,2,3,... check input variable'); end

if isempty(intersect(exp_id,0:8))
  warning('MATLAB:exp_id_error',...
  'exp_id should be one of 0(practice), or 1,2,...,8 (main experiment). check the input variables');
  OK=false;
  return;
end

if length(exp_id)~=numel(acq_id), error('the numbers of exp_mode and acq_id mismatch. check input variable'); end

% check directory with subject name
%
% [NOTE]
% if the subj directory is not found, create subj directory, copy all condition
% files from DEFAULT and then run the script using DEFAULT parameters

subj_dir=fullfile(pwd,'subjects',subj);
if ~exist(subj_dir,'dir')

  disp('The subject directory was not found.');
  user_response=0;
  while ~user_response
    user_entry = input('Do you want to proceed using DEFAULT parameters? (y/n) : ', 's');
    if(user_entry == 'y')
      fprintf('Generating subj directory using DEFAULT parameters...');
      user_response=1; %#ok
      break;
    elseif (user_entry == 'n')
      disp('quiting the script...');
      if nargout, OK=false; end
      return;
    else
      disp('Please answer y or n!'); continue;
    end
  end

  %mkdir(subj_dir);
  copyfile(fullfile(pwd,'subjects','_DEFAULT_'),subj_dir);
end

% set display and stimulus file name
disp_fname='oblique3d_display';
stim_fname=sprintf('oblique3d_stimulus_%02d',exp_id);

% set the program body
run_script='StereoQUESTsample';

% ********************************************************************************************************
% *** set gamma table. please change the line below to use the actual measuments of the display gamma. ***
% ********************************************************************************************************

% loading gamma_table
load(fullfile('..','gamma_table','ASUS_ROG_Swift_PG278Q','181003','cbs','gammatablePTB.mat')); gamma_table=gammatable;
%load(fullfile('..','gamma_table','ASUS_VG278HE','181003','cbs','gammatablePTB.mat')); gamma_table=gammatable;
%load(fullfile('..','gamma_table','MEG_B1','151225','cbs','gammatablePTB.mat')); gamma_table=gammatable;
%gamma_table=repmat(linspace(0.0,1.0,256),3,1)'; %#ok % a simple linear gamma

%% run stimulus presentations
for ii=acq_id
  %% run the stimulus presentation script
  eval(sprintf('%s(''%s'',%d,''%s'',''%s'',gamma_table,0);',run_script,subj,ii,disp_fname,stim_fname));
end
OK=true;

return
