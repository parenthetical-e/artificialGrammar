 function [seqMut, positionLog] = mutate(base, numMutate, numIterations, dbg)
% Mutation generator: takes a matrix of artificial grammar sequences 
% (arranged in rows) and inserts one of the intergers from 1-6 randomly throughout each sequence.
%
% Output: two matrices ,one with the mutant sequences ('seqMut') and
% one with the postion of the mutations (smae order as seqMut).
% 
% Only sequences that are NOT an exact match for the base sequences
% are included.

tmpIter=[]; tmpOut=[]; 
seqMut = [];
positionLog = [];
tmpPosLogIter = [];
tmpOut=[];
tmpPosLog=[];
tmpIter=[];


lenBase = size(base); lenBase = lenBase(1);
for mainCounter = 1:lenBase,
	
	currentSeq = base(mainCounter,:);
	lenCurrentSeq = length(currentSeq);	
	
	if dbg,
		disp('mainCounter (which seq num?):')
		disp(mainCounter)
		disp('currentSeq, the length:')
		disp(currentSeq)
		disp(lenCurrentSeq)
	end

	for mutateCounter = 1:numIterations,
		mutateCounter;
		% if dbg,
		% 		if mutateCounter == numIterations/4,
		% 			disp('1/4 done with the current mutation iteration')
		% 		end
		% 		if mutateCounter == numIterations/2,
		% 			disp('1/2 done with the current mutation iteration')
		% 		end
		% 		if mutateCounter == (numIterations/4) * 3,
		% 			disp('3/4 done with the current mutation iteration')
		% 		end
		% 	end
		
		% where to mutate (create a 1d matrix) ans what to mutate to:
		% use of randperm prevents overlapping mutation point selection
		% and ensures that is you want to mutate the whole string
		% (execpt for the first element) you can do so.
		% the mutations ...	

		% where
		ii = 1;
		possiblePostions = randperm(lenCurrentSeq);
		
		% find and elimante the '1' in possiblePostions
		tmp=[];
		for bb = 1:length(possiblePostions),
			if possiblePostions(bb) ~=1,
				tmp = [tmp possiblePostions(bb)];
			end
		end
		possiblePostions = tmp;
		position(1:numMutate) = possiblePostions(1:numMutate);
		
		if dbg,
			disp('At:')
			disp(position)
		end
		
		% what:
		for ss = 1:length(position),
			tmp = randperm(6);
			mutation(ss) = tmp(1);
		end
		
		if dbg,
		 	disp('THe mutations are:')
			disp(mutation)
		end		
		
		% insert the mutation(s)
		tmpSeq = currentSeq;
		for jj = 1:numMutate,
			tmpSeq(position(jj)) = mutation(jj);
		end
		
		if dbg,
			disp('the mutatedSeq:')
			disp(tmpSeq)
			disp('Assigning tmp* to tmpOuts')
		end
		
		tmpIter = [tmpIter; tmpSeq];
		tmpPosLogIter = [tmpPosLogIter; position];

		if dbg,
			disp('Done with that')
		end
	end
	% cat this current seqs mutants with the rest
	tmpOut = [tmpOut; tmpIter];
	tmpPosLog = [tmpPosLog; tmpPosLogIter];

	% clear working vars just in case
	tmpIter = []; tmpPosLogIter =[];
end 
	
% test seqMut sequences to see if they match any in base.
% If they do reject them, if they do not add the mutant sequences
% to the return var.
% if dbg,
% 	disp('Done with mutation generation, assembling the final results ...')
% 	disp('tmpOut')
% 	disp(tmpOut)
% 	disp('tmpPosLog')
% 	disp(tmpPosLog)
% end

lenTmpOut = size(tmpOut); lenTmpOut = lenTmpOut(1);
for kk = 1:lenTmpOut,
	baseMatch = 0;

	for pp = 1:lenBase,
		matchSum = sum(tmpOut(kk,:) == base(pp,:));
		if matchSum == lenBase,
			baseMatch = 1;
		end
	end
	
	if ~(baseMatch),
		seqMut = [seqMut; tmpOut(kk,:)];
		positionLog = [positionLog; tmpPosLog(kk,:)];
	end
	
end	


% remove redundant seqs from seqMut	
lenSeqMut = size(seqMut); lenSeqMut = lenSeqMut(1);
tmp = [];
tmpPos = [];

for kk = 1:lenSeqMut,
	mutMatch = 0;

	for pp = 1:lenSeqMut,
		matchSum = sum(seqMut(kk,:) == seqMut(pp,:));
		if matchSum == lenSeqMut,
			mutMatch =1;
		end
	end

 	if ~(mutMatch),
		tmp = [tmp; seqMut(kk,:)];
		tmpPos = [tmpPos; positionLog(kk,:)];
	end
end
if dbg,
	disp('The final seqs are done! Saving ...')
end

seqMut = tmp;
positionLog = tmpPos;

if dbg,
	disp('All Done!')
end
%EOF
end

