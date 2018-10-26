%%% QUEST parameters
sparam.numTrials=60;
sparam.maxValue=15;
sparam.initialValue=5; tmp=shuffle(0:3); sparam.initialValue=sparam.initialValue+tmp(1);
sparam.tGuess=log10(sparam.initialValue/sparam.maxValue); % you can change the line here so that the script takes over the previous estimations
sparam.tGuessSD=4; % smaller value may be better
sparam.pThreshold=0.82; % 0.82 is equivalent to a 3-up-1-down standard staircase
sparam.beta=3.5;
sparam.delta=0.01;
sparam.gamma=0.5;
