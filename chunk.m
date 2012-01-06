function[chunkDB] = chunk(SEQ, chunkWidth, verbose, debug, transpose)
% This script will count the number of substrings (pairs, triplets, etc)
% in a list of artificial grammar sequences (EJP, 5/20/2008).
if verbose,
	disp('Incoming data must be ROWs of matrix alpha or numeric sequences.')
	disp('Mixed alpha and numeric and errors may result.');
	disp('If the data is arranged in columns, set transpose = 1.')
	disp('For large numbers of sequences this script may be low.')
	disp('Output is one object (chunkDB)')
	disp('as well as two text files ("chunks.out.txt" and "freqs.out.txt")')
end

if transpose,
	SEQ = SEQ';
end

% detect if the sequences are composed of numbers;
% strings that begin wth numbers cannot be used in
%  dynamic struct array name creation -
%  the use of which greatly simplifies this script.
if ~(isletter(SEQ(1,1))),
	numbers = 1;
else
	numbers = 0;
end

% where all the chunks and the frequencies will be stored
chunkDB = struct;
len  = size(SEQ); len = len(1);
stepWidth = chunkWidth - 1;
chunks = [];
frequency = [];
uniqueChunkCounter = 0;

for mainCount = 1:len,
	
	% find all the possible pair types
	% compare known to current
	% if new add to current,
	% and update the count matrix (which is indexed the same as pair log)
	% if not new then update count
	% do with a subroutine, where pairs (2) triplets, whatever are 
	% specififed at invocation
	
	currentSeq = SEQ(mainCount,:);
	seqLen = length(currentSeq);	
	numChunks = seqLen - (chunkWidth-1);
	
	if debug,
		disp('currentSeq:')
		disp(currentSeq)
		disp('seqLen:')
		disp(seqLen)
		disp('numChunks')
		disp(numChunks)
		disp('******************')
		disp('Start chunk eval')
	end
	
	for ii = 1:numChunks,
		
		if numbers,
			% add a 'c' to currentChunk so it can name a field
			% in chunkDB
			currentChunk = currentSeq(ii:(ii+stepWidth));
			
			% intialize/dec the fist element in currentChunk
			currentChunkName = num2str(currentChunk(1));
			% Then strcat that with all the rest of 
			for jj = 2:length(currentChunk),
				currentChunkName=strcat( currentChunkName,num2str( currentChunk(jj) ) );
			end

			currentChunkName = strcat('c',currentChunkName);			
		else
			currentChunk = currentSeq(ii:(ii+stepWidth));
			currentChunkName = currentChunk;
		end
		
		if debug,
			disp('currentChunkName:')
			disp(currentChunkName)
			disp('currentChunk')
			disp(currentChunk)
		end

		if isfield(chunkDB, currentChunkName),
			chunkDB.(currentChunkName).freq = chunkDB.(currentChunkName).freq + 1;
			if debug,
				disp('Added currentChunk to the db')
			end
			
		% if it is not already in chunkDB, add it
		% increase uniqueChunkCounter by one.
		else
			chunkDB.(currentChunkName).chunk = currentChunk;
			chunkDB.(currentChunkName).freq = 1;
			uniqueChunkCounter = uniqueChunkCounter + 1;
			if debug,
				disp('new Chunk detected')
			end
		end
		if debug,
			disp('End eval')
			disp('*******************')
		end
	end
end

% Now export the chunkDB into two lists
% The first is the strings,
% the second is the frequencies

% Convert to a cell array, so it is easier to loop through 
% that data.
cellChunkDB = struct2cell(chunkDB);
uniqueChunkCounter
% create a matrix of found unique chunks
for ii = 1:uniqueChunkCounter,
	chunks = cat(1,cellChunkDB{ii}.chunk,chunks);
end

% write chunks to a text file
disp('Warning: unless renamed previous "chunks.out.txt" will be overwritten')
filename = 'chunks.out.txt';
dlmwrite(filename, chunks,'');

% create a matrix of the frequencies, same order as chunks above
for ii = 1:uniqueChunkCounter,
	frequency = cat(1,cellChunkDB{ii}.freq,frequency);
end

% write frequency to a text file
disp('Warning: unless renamed previous "freqs.out.txt" will be overwritten')
filename = 'freqs.out.txt';
dlmwrite(filename, frequency,'');

if verbose,
	disp('Done!');
end

% EOF
end