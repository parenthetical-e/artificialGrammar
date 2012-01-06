% For analysis of the sequences produced by mutate() (EJP; 5/26/2008)

base = [];
mutants = []; % num of mutations must be the same
positions = [];

% run chunk()
chunkWidth=2;
verbose=0;
debug=0;
transpose=0;

baseChunkDB = chunk(base);
mutantChunkDB = chunk(mutants);

% chunk calcs ....
% HERE

% Are any of the postions contiguos?  (Out: a binary of 1d matix, indexed 
% the same as mutants)
lenPos = size(postions); lenPos = lenPos(1);
for hh = 1:(lenPos-1),
	if strcmp(postions(hh),postions(hh+1)),
		contig(hh) = 1;
	else
		contig(hh) = 0;
	end
end

lenMutants = size(mutants); lenMutants = lenMutants(1);

% at the mutation postions are the mutants pairs legal or illegal?
% chunk judge ...
% There are two pairs to test for every mutation

for ii = 1:lenPos,

	currentSeq = mutants(ii);	
	for kk = 1:length(postions(ii)),
		% get the pairs to test
		currPairs = [currPairs currentSeq(postions(kk)) currentSeq(postions(kk+1))];
	end

% do the chunk match HERE
 for ...
	
end

	