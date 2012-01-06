function[cStrengthOut,lawyer] = cStrength(SEQ, chunkLib, chunkWidth, dbg, prnt),
% Takes a matrix composed of numeric rows (sequences) and calculates the "chunk strength"
% for each, returning that strength val in 1d matrix (in the same order as the input).
%
% IN:
% --
% SEQ: a matrix of sequences (in rows) whose chunk strength you want to calc 
% chunkLib:  The reference chunk propabilities (from the total learning set) -- 
% chunkLib.Col1: the chunk; Col2=probabilty in test set {0,1}
% chunkWidth: the size of the chunks
% dbg: debugging on (1) or off (0)
% prnt: export the SEQ and cStrengthOut into text files (y/n:1/0)
%
% OUT:
% ---
% cStrengthOut: the chunk strengths
% lawyer: a matrix indicating whether each pair of the test sequences was .
% illegal (1) or not (0).

currSeqChunkStrength = [];
tmpChunkStrength = [];
cStrengthOut=[];
lawyer=[];

% Some useful constants
tmp = size(SEQ); 
numTestSeq = tmp(1);
lenTestSeq = tmp(2);
stepSize = chunkWidth -1;
numChunks = lenTestSeq - (chunkWidth -1);
lenChunkLib = size(chunkLib); lenChunkLib = lenChunkLib(1);

for mainC = 1:numTestSeq,
	% mainC %DEBUG
	currentSeq = SEQ(mainC,:);
	tmpChunkStrength = [];
	currSeqChunkStrength = [];
	seqlawyer = [];
	% test all off the chunks for the currentSeq (above) to see if they 
	% match an entry in the chunkLib.
	for innerC = 1:numChunks,
		
		match = 0;			
		
		% chunk to be tested this iter
		currentChunk = currentSeq(innerC:(innerC+stepSize));
		
		for innerinnerC = 1:lenChunkLib,
	
			% Go throuh each of the chunks in the chunkLib, return the pval if
			% there is a match
			sumMatch = sum(currentChunk == chunkLib(innerinnerC,1:chunkWidth));
			if sumMatch == chunkWidth,
				tmpChunkStrength = [tmpChunkStrength chunkLib(innerinnerC,(chunkWidth+1))];
				match=1;
				break;
			end
			% is there is no match (the current cunks is not in the lib)
			% then put a zero in
			if (innerinnerC == lenChunkLib) && match==0,
				tmpChunkStrength = [tmpChunkStrength 0];
			end	
		end
		
		% if it was an illegal chunk put a zero in the tmp and
		% set chunklawyer to 1 (that is to say, yes it is time 
		% to call a lawyer -HA!)	
		if (match),
			seqlawyer = [seqlawyer 0];
		else
			seqlawyer = [seqlawyer 1];
		end	
		% tabulate all the chunks so far (for this sequence)
		currSeqChunkStrength = [currSeqChunkStrength tmpChunkStrength];
	end
	% tabulate the results for the current sequence with the rest
	% of the test seqs
	cStrengthOut = [cStrengthOut; mean(currSeqChunkStrength)];
	lawyer = [lawyer; seqlawyer];
end

% write output?
if prnt,
	disp('Warning: files will be overwritten on next invocation, unless renamed.')
	filename = '0_cStrengthOut.out.txt';
	dlmwrite(filename, cStrengthOut,'');
	
	filename = '0_lawyer.out.txt';
	dlmwrite(filename, lawyer,'\t');

	filename = '0_mutSeqs.out.txt';
	dlmwrite(filename, SEQ,'\t');
end

%EOF
end