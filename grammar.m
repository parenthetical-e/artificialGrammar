function [finishedSeq, workingSeq] = grammar(E, minLen, maxLen, chunk, verbose, debug)
% Artificial grammar sequence generator (EJP, 5/15/2008).
% See grammar_README.m for use instructions.

%intialize
workingSeq = [];
finishedSeq = [];
% For some reason is seams far more logical to 
% manipulate rows instead of columns, 
% thus the transpose
Ep = E';
len = length(Ep);

if verbose,
	disp('Script requires an matrix, E, whose composition is decribed in gramGen_README'),
	disp('Edges detected:'),
	disp(Ep),
	disp('Starting sequence generation ...'),
end



% test for A/Z
if Ep(1,1) ~= 'A',
	error('Initializer node, "A", not found.  You fail!  Please try again, this time try not to be so incompetant.');
end

if Ep(len,2) ~= 'Z',
	error('No termination character (Z) found.  You fail!  Please try again, this time try not to be so incompetant.');
end

% ::::::::::::::
% SORT THE EDGES
% ::::::::::::::
if debug,
	disp('******************************************************')
	disp('SORT loop starting.')
end

% START SORT LOOP
for mainSortC = 1:(len-2),
	
	if debug,
		mainSortC
	end
	
	% test for MULTIPLE START, start
	% requires that the first entry is an A.
	if mainSortC == 1,

		% The first entry in Ep will be a start
		% so go ahead and assign it
		tempE = Ep(1,:);

		% now if there are mult starts ...
		ii = 1;
		while ( Ep(ii,1) && Ep(ii+1,1) ) == 'A',

			tempE = cat( 1, tempE, Ep( (ii+1),: ));
			ii = ii + 1;

			if debug,
				disp('tempE for the MULT starting assignemt:')
				disp(tempE)
			end
		end
	
		if debug,
			disp('tempE for the starting assignemt:')
			disp(tempE)
		end	
	end	

	% FIND THE CONTIGUOUS NODE
	if debug && mainSortC > 1,
		disp('Starting Another round of contig detect')
	end

	ii = mainSortC;
	while (ii <= len),
		ii
		% does the end node, match the begining
		% node of the next edge?
		% Keep going till it does
		% mainSortC is the current
		% yy is used in the search FOR THE NEXT
		if Ep(mainSortC,2) == Ep(ii,1),
		
			tempE = cat(1, tempE, Ep(ii,:) );

			if debug,
				disp('tempE for each contig sort iteration')
				disp(tempE)
			end	
		end
		ii = ii + 1;
	end	

	% ANY SELF-LOOPS are not yet sorted, unless they are 'A' loops
	% detect self-loops, and put them in the proper place
	if Ep(mainSortC,1) == Ep(mainSortC,2),
		ii = 1;
		while ii <= length(tempE),
			if Ep(mainSortC,1) == tempE(ii,2)
				shelf = tempE(1:ii,:);
				shelf = cat(1,shelf,Ep(mainSortC,:));
				tempE = cat(1,shelf, tempE(ii+1:end,:));
				break,
			end
			ii = ii + 1;
		end
	end
% END SORT LOOP	
end

% Check to make sure that no edges were left behind
diffInLengths = length(Ep) - length(tempE);
if diffInLengths,
	disp('ERROR @ Iteration')
	disp(mainSortC)
	disp('The sorted edge-list was a different size than the original.'),
	disp('It is likely that some discontiguous edges were entered.')
	disp('The two differed by (Orig - Sort):'),
	disp(diffInLengths),
	disp('The sorted list:')
	disp(tempE)
	error('Die!')
end

if debug,
	disp('Sorting finished wwithout error.')
	disp('Sorted edge-list:')
	disp(tempE)
	disp('*****************************************************')
	disp('STARTING to PARSE "E"')
end

% :::::::::::::::
% PARSE the edges
% :::::::::::::::

% Parses E, one edge at a time.
% Some tests are redundant with 
% the sort above.  I thought it better
% to s run some of this twice than. 
% create a database of these terms
% This is perhaps more modular ...

% Assign tempE to Ep
% convert the wieghts from char to num simplifying later work
Ep = tempE;

for mainParseC = 1:len,

	% Check for self loops\
	if Ep(mainParseC,1) == Ep(mainParseC,2),
		selfLoops(mainParseC) = 1; %#ok<AGROW>
	else
		selfLoops(mainParseC) = 0;
	end

	% Check for branch points
	% short circuit ('&') to prevent overflow
	if (mainParseC ~= len) && ( Ep(mainParseC,1) == Ep(mainParseC+1,1) ),
		branchPoints(mainParseC) = 1;
	else
		branchPoints(mainParseC) = 0;
	end

	% Check for End Marker(s) (Z)
	if Ep(mainParseC,2) == 'Z',
		deathPoints(mainParseC) = 1;
	else
		deathPoints(mainParseC) = 0;
	end

	% Check for multiple entry points
	% relies on pre-sorting
	if mainParseC == 1 && ( Ep(mainParseC,1) == Ep(mainParseC+1,1) ),
		multEntry(mainParseC) = 1;
	else
		multEntry(mainParseC) = 0;
	end


	numSelfLoops = sum(selfLoops);
	numBranchPoints = sum(branchPoints);
	numDeaths = sum(deathPoints);
	numEntries = sum(multEntry);

	if debug,
		disp('-----------')
		disp('Which pair:')
		disp(mainParseC)
		disp('Number of pairs:')
		disp(len)
		disp('Self-loop?')
		disp(selfLoops)
		disp('Branch points:')
		disp(branchPoints)
		disp('Die here?')
		disp(deathPoints)
		disp('-----------')
	end
end

% :::::::::::
% STRING GEN
% :::::::::::
if debug,
	disp('PARSING complete.')
	disp('**************************************************')
	disp('Starting STRING GEN')
end

for mainGenC = 1:maxLen,

	if debug,
		mainGenC
	end

	% ---------------
	% STARTING VALUES
	% ---------------

	% if mult starts, n > 1
	if (mainGenC == 1) && (sum(multEntry) > 1),

		if debug,
			disp(['Mult-entry start']);
		end

		ii = multEntry;

		while ii,
			workingSeq = cat( 1, workingSeq, Ep(mainGenC,3) );
			ii = ii - 1;
		end,

	% if a single start
	elseif mainGenC == 1,

		if debug,
			disp(['Single-entry start']);
		end

		% corrent assignment assumes that maingenC = 1
		workingSeq = Ep(mainGenC,3);
	end 

	if debug && mainGenC ==1,
		disp('Starting seqs are:');
		disp(workingSeq);
	end

	% ----------------
	% BRANCH/CHAIN GEN 
	% ----------------

	if mainGenC > 1 && ~(selfLoops(:,mainGenC)),

		if debug,
			disp('branch/chain gen start.')
		end

% FUCKED >>

		% how many limbs in the branch?
		% if we are on the last interation there cannot be a branch
		if mainGenC ~= maxLen,
			
			% ii is the maximum number of branches
			% possible at the current interation
			ii = sum(branchPoints(mainGenC:end,:)) + 1;

			while (ii >= 1)
				
				% declare branchCount. '1' means no branches,
				% that is to say,a continuos chain.
				branchCount = 1;
			
				% do the current
				if (branchPoints(mainGenC,:)) && (branchPoints(mainGenC+1,:)) == 1,
	
					branchCount = branchCount + 1;
					ii = ii - 1;
					
				elseif branchPoints(mainGenC,:),
					branchCount = 2;
			end
		end
		
		if debug,
			disp('branchCount:')
			disp(branchCount)
		end

		% intialize the temp storage array, will store the additions
		% from each branch and is recombined at the end
		arrayShelf = cell(1,branchCount);

		% second counter, steps through the branch points 
		% (that were detected above)
		jj = mainGenC;		

% END FUCKED >>

		% now gen the branch sequences.
		for ii = 1:branchCount,
			% get the current size of workingSeq

			lenWork = size(workingSeq); 
			lenWork = lenWork(1);

			% use that lenWork to gen a 1d matrix of wieghts(@ii),
			% that is the proper length
			% repmat gens gols by default;
			% want to add a col to the seq rows.
			weightsList = repmat(Ep(jj,3),lenWork,1);

			% combine the new wieghts with the old, and stick the 
			% result in an array
			arrayShelf{1,ii} = cat(2,workingSeq,weightsList);
			jj = jj + 1;
		end

		if debug,
			disp('arrayShelf:')
			for ii = 1:branchCount,
				disp(arrayShelf{1,ii})
			end
		end

		workingSeq = cell2mat(arrayShelf');
		if debug,
			disp('workingSeq after brach loop done:')
			disp(workingSeq)
		end
	
	end
	% -----------------
	% SELF-LOOP SEQ GEN	
	% -----------------

	if selfLoops(:,mainGenC),

		% find  all distances to Z
		% create seqs, store these in a seqOut
		% add sep cond if ii = 1
		maxRepeats = maxLen - mainGenC -1;
		for ii = 1:maxRepeats,

		end
	end

	% ------------
	% DEATH POINTS
	% ------------

	if deathPoints(:,mainGenC),
		% look for Zs, if Zs tranfer to finalSqes
			% transfer the Zs to finishedSeq, do not test for proper lengths
			% will do that to the total finishedSeq at the end
	end
% END SEQ GEN		
end

% ------------
% SEQ ANALYSIS
% ------------

% find the Z wieghts
% numDeaths = sum(deathPoints);
if debug,
	disp('Seq generation complete.')
	disp('********************************************************')
	disp('Starting Seq analysis.')
end

if numDeaths == 1,
	deathWeights = Ep(len,3);

	if debug,
		disp(['Number of deaths was one - deathWeights:'])
		disp(deathWeights)
	end
end	

if numDeaths > 1
	%intialize
	deathWeights = 0;

	% find all the deathpoint wieght values
	for ii = 1:len,
		if deathPoints(:,ii),
			deathWeights = cat(1,deathWeights,Ep(ii,3));
		end
	end

	if debug,
		disp(['Number of deaths > one - deathWeights:'])
		disp(deathWeights)
	end
end

numSeq = size(workingSeq); numSeq = numSeq(1);

if debug,
	numSeq
end

for ii = 1:numSeq,

	% get the length of the _current_ seq
	lenSeq = length(workingSeq(ii,:));

	if debug,
		lenSeq
	end
	% now loop through the possible deathWeights
	% to see if the end of the current workingSeq
	% is a known end weight ADD the seq is 
	% within the max/min limits add it to the finishedSeq
	% if not then move on.  workingSeq will be saved
	% for any possible comparisons.
	for jj = 1:length(deathWeights),

		if (workingSeq(ii,lenSeq) == deathWeights(jj)),
			if maxLen <= workingSeq(ii,:) >= minLen,
				finishedSeq = cat(1,finishedSeq,workingSeq(ii,:));

				if debug,
					disp('Seq analysis complete.')
				end
			end
		end
	end
end

if debug,
	workingSeq
	finishedSeq
end






if debug,
	disp('Done!')
end

% END OF FXN
end






















