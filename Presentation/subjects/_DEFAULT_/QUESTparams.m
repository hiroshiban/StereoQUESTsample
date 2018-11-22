%%% QUEST parameters
sparam.numTrials=60;
sparam.maxValue=15;
sparam.initialValue=5; tmp=shuffle(0:3); sparam.initialValue=sparam.initialValue+tmp(1);
sparam.tGuess=log10(sparam.initialValue/sparam.maxValue); % you can change the line here so that the script takes over the previous estimations
sparam.tGuessSD=4; % smaller value may be better

% % update tGuess and tGuessSD based on the previous results
% if acq>=2
%   tgt=fullfile(rootDir,'subjects',num2str(subjID),'results',datestr(now,'yymmdd'),...
%                [num2str(subjID),'_Oblique3D_QUEST_run_',num2str(acq-1,'%02d'),'.mat']);
%   if exist(tgt,'file')
%     load(tgt,'angle_thresholds','angle_SDs');
%     sparam.initialValue=mean(angle_thresholds);
%     sparam.tGuess=log10(sparam.initialValue./sparam.maxValue);
%     sparam.tGuessSD=log10(mean(angle_SDs));
%   end
% end

sparam.pThreshold=0.82; % 0.82 is equivalent to a 3-up-1-down standard staircase
sparam.beta=3.5;
sparam.delta=0.01;
sparam.gamma=0.5;
