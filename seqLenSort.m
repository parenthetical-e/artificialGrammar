% The aftermath of excell seq gen
% paste the seq into txtMt, use find/replace to create a csv file
% import into matlab with:
%
% seqraw = textread('gramA_allSeqs.csv', '%s');
%
% which create an array cell for each line
% in the test file, however each entry will still have the commas
% (using a 'delimeter',',' swicth leads to all of bieng imported 
% as a single line - I could not resolve this)
% 
% % getting rid of the commas
%  $ saved as 'excelImportClean.m'
% seq = cell(1);
%
% for ii = 1:length(seqraw),
% 	seq{ii,1} = str2num(seqraw{ii,1});
% end
%  	was:  1,4,6,1,4,2,3,4,0
%  	now:   1     4     6     1     4     2     3     4     0
% access each num in seq via (x)
% seq{1,1}(x);
%
% 
% Once this is done run the below.

% USER VARS:
seqLenRange = [6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 48 40];
showAllSeq = 1;
seqOut = struct;
numStr = 0;
% seq = [] (already defined, see note above);

% build the outgoing data structure ahead, prevent annoying assignmet
% errors
for lenRange = 1:length(seqLenRange),
	% seqOut.(name) for this iteration of seqRangeCount
	namedLen{1,lenRange} = strcat('length', num2str(seqLenRange(lenRange)));
	currentName = namedLen{1,lenRange};
	seqOut.(currentName) = [];
end

% Sort!
for lenRange = 1:length(seqLenRange),
	% target length for this iteration
	searchLen = seqLenRange(lenRange);

	% loop though seq{1,x}
	for mm = 1:length(seq),
			% the current string, and its length
			strCurrent = seq{mm,1};
			lenStrCurrent = length(strCurrent);

			if (lenStrCurrent-1) == searchLen,
				% combine the current str with the array, and drop the '0'
				% from terminal (Z)
				seqOut.(namedLen{1,lenRange}) = [seqOut.(namedLen{1,lenRange}); strCurrent(1:(lenStrCurrent-1))];
				numStr = numStr+1;	
			end
	end
end


% % Do not bother to save all the seq ...
% if ~(showAllSeq),
% 	seq = [];
% end