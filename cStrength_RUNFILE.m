% cStrength RUNFILE

% IN:
% --
% SEQ: a matrix of sequences (in rows) whose chunk strength you want to calc 
% chunkLib:  The reference chunk propabilities (from the total learning set; 
% see 'Len10-15TotalChunkCounts.xls in the gramA folder for an example') -- 
% chunkLib.Col1: the chunk; Col2=probabilty in test set {0,1}
% chunkWidth: the size of the chunks
% dbg: debugging on (1) or off (0)
% prnt: export the SEQ and cStrength into text files (y/n:1/0)
%
% OUT:
% ---
% cStrength: the chunk strengths
% lawyer: a matrix indicating whether each pair of the test sequences was .
% illegal (1) or not (0).

SEQ = ranLen14;
chunkWidth=3;
chunkLib = chunkLib_L10_15_w3;

dgb=1;
prnt=1;


%GO!
cStrengthOut=[];
lawyer=[];
[cStrengthOut, lawyer] = cStrength(SEQ, chunkLib, chunkWidth, dbg, prnt);
