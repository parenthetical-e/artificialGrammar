% Mutate() RUN FILE

% inpur vars
base=len15;
numMutate=2; % max val is length(base) - 1
numIterations =200; % must be a multiple of two
dbg=0;

% GO!
seqNum=[];
postionLog = [];

[seqMut, positionLog] = mutate(base, numMutate, numIterations, dbg);

