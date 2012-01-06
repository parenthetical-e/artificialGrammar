function[recode] = gcode(dataIn, currentCode, newCode, verbose, debug, transpose, fileOut)
% This script will covert one a matrix of sequence rows from one coding scheme
% to another.  It should be quite flexible as far out datatypes are concerned.

% Written by EJP, 5/21/2007

if verbose,
	disp('Incoming data must be ROWs of matrix alpha or numeric sequences')
	disp('If the data is arranged in columns, set transpose = 1.')
	disp('Output is a single matrix - the recoded rows')
	disp('Assuming fileOut=1, a text file ("recode.out.txt") containing the recoded sequences is saved. Console PWD controls where the file is written.')

if transpose,
	dataIn = dataIn';
end

% Intialize / Dec
len  = size(dataIn); len = len(1);
lenCode = length(currentCode); 
lenCode
recode = cell(len,1);

% Start the main loop
for mainCount = 1:len,

	currentSeq = dataIn(mainCount,:);
	seqLen = length(currentSeq);	
	
	% clear out recodeSeqCurrent, to allow for different seq lengths
	recodeSeqCurrent = cell(1,seqLen);
	
	% the ii'th ros
	for ii = 1:seqLen,
	
	if debug,
		disp('Current seq num (ii):')
		disp(ii)
	end
	
		% the jj'th element (coding arrays)
		for jj = 1:lenCode,
			
			if debug,
				disp('Current seq element:')
				disp(currentSeq(ii))
				disp('Current jj:')
				disp(jj)
			end
			
			% test all of the current codes against the ii'th element in
			% currentSeq until there is a match
			if currentSeq(ii) == currentCode(jj),
				
				% Once there is a match put the corresponding recode
				% value in the same location, but in a new var 
				% recodeSeqCurrent
				recodeSeqCurrent{1,ii} = newCode(jj);
			
				% if it does not match a current code, skip it				
				
				if debug,
					disp('Match?')
					disp(newCode(jj))
				end
			end
		end
		
		% Once the recoding of the current seq is done combine
		% recodeSeqCurrent 
		% into <recode>, and go onto the next seq.
		if ii == seqLen,
			
			% cells from recodeSeqCurrent combined into a single string 
			temp = cell2mat(recodeSeqCurrent);

			% put that new string in recode
			recode{mainCount,1} = temp;
			
			if debug,
				disp('recodeSeqCurrent after this ii:')
				disp(recodeSeqCurrent)
				disp('**************************')
				disp('recode (after each iith):')
				disp(recode)
				disp('**************************')
			end
		end
	end	
end

% Saving the results
if fileOut,
	if verbose,
		disp('WARNING: unless renamed previous "recode.out.txt" files will be overwritten.')
	end
	
	filename = 'recode.out.txt';
	for ii = 1:len,
		
		% so as to avoid combining files from diff runs
		if ii == 1,
			dlmwrite(filename, recode{ii,1},'delimiter','\t');
		else,
			dlmwrite(filename, recode{ii,1},'delimiter','\t','-append');
		end
	end
end

if verbose,
	disp('Done!');
end

% EOF
end