% function[seqOut, seq] = gramA(seqLen, debug, verbose),
% This script generate the grammar for grammarA see gramA_diagram.pdf for a 
% description.  Max overall seq length is 20.
% final out is seqOut, a strucured array.
%
%  NOTE: '0' is reserved to denote terminal condtions
% 
% ************
% DECLARATIONS
% ************
%

% clean the workspace (debug)
clear

debug = 1;

% Edges and weights
% ================
AB = 1; %goto B*

	BC = 4; CE = 6; % goto E*
	BD = 6; % goto D*
		DC = 5; % goto C*
		DE = 3; % goto E*

EF = 1; % goto F*
	FK = 4; KF = 2; % goto F*
	FH = 3; % goto H*
		HJ = 4; Z = 0;
		HG = 3; % goto G*
		
EG = 2;
	GL = 1; LG = 6; % goto G*
	GI = 5;
		IH = 2; % goto H*
		IJ = 5; Z = 0;
%
% Range of sequences lengths desired
% -----------------------------------

seqLenRange = [9 10 11 12 13 14];
showAllSeq = 1;

% ************
% Seq Gen G0!  
% ************

% Initialize
shelf = [];
nextEdge = 'B';
seqB = cell(1);
seqC = cell(1);
seqD = cell(1);
seqE = cell(1);
seqF = cell(1);
seqFK = cell(1);
seqG = cell(1);
seqGL = cell(1);
seqH = cell(1);
seqI = cell(1);
seq = cell(1);
FKcount = 1;
GLcount = 1;5

for mainCounter = 1:(max(seqLenRange)+20),
	
	if debug,
		disp ('*******************')
		disp('mainCounter:')
		disp(mainCounter)
		disp('nextEdge:')
		disp(nextEdge)
		disp('Current case:')
		disp(nextEdge(1))
	end

	% nextEdge(1) varies dure to the nextEdge deleting behavoir
	% in each case and the order of execution is not relevant 
	% to the final results.  A hack.
	switch nextEdge(1),
		% -----
		case 'B',
			% start AB is constant
			seqB{1,1} = 1;
			
			% ---------------- simple branch ---------------			
			shelf = ['BC'; 'BD'];
			% ::::::::::::::::::: branch 1 ::::::::::::::::::::
			if strmatch('BC', shelf, 'exact'),
				seqB{1,1} = [seqB{1,1} BC CE]; 						
				% ???????????? Where to next: ????????????????
				nextEdge = 'E';
				seqE = [ seqE seqB{1,1} ];
			end
			% ::::::::::::::::::: branch 2 ::::::::::::::::::::
			if strmatch('BD', shelf, 'exact'),
				seqB{1,2} = [seqB{1,1} BD];
				% ???????????? Where to next: ????????????????
				nextEdge = [nextEdge 'D'];
				seqD = [seqD seqB{1,2}];
				% !!!!!!!!!!!!!!! Clean up !!!!!!!!!!!!!!!!!!!
				shelf = []; seqB = cell(1);
			end						

		case 'C',
			% --------------------------------
			% remove 'targ' cases from nextEdge
			targ = 'C';
			temp = [];
			lenNextEdge = length(nextEdge);

			for ii = 1:lenNextEdge,
				if nextEdge(ii) ~= targ,
					temp = [temp nextEdge(ii)];
				end
			end
			nextEdge = temp;
			org = seqC;

			% ::::::::::::::::::: branch 1 ::::::::::::::::::::
			lenC = size(org); lenC = lenC(2);
			for ii = 1:lenC,
				seqC{1,ii} = [org{1,ii} EF];
			end
			% ???????????? Where to next: ????????????????
			nextEdge = [nextEdge 'E'];			
			seqE = [seqE seqC];
			% !!!!!!!!!!!!!!! Clean up !!!!!!!!!!!!!!!!!!!
			shelf=[]; seqC= cell(1);

		% ------
		case 'D', 
			% --------------------------------		
			% remove 'targ' cases from nextEdge
			targ = 'D';
			temp = [];
			lenNextEdge = length(nextEdge);

			for ii = 1:lenNextEdge,
				if nextEdge(ii) ~= targ,
					temp = [temp nextEdge(ii)];
				end
			end
			nextEdge = temp;
			org = seqD;
			% --------------------simple branch ---------------
			shelf = ['DC'; 'DE'];
			% ::::::::::::::::::: branch 1 ::::::::::::::::::::
			if strmatch('DC', shelf, 'exact'),
				nextEdge = [nextEdge 'C'];
			
				lenD = size(seqD); lenD = lenD(2);
				for ii = 1:lenD,
					seqD{1,ii} = [org{1,1} DC];
				end
				% ???????????? Where to next: ????????????????
				nextEdge = [nextEdge 'C'];
				seqC = [seqC seqD{1,1:lenD}];
			end
			% ::::::::::::::::::: branch 2 ::::::::::::::::::::
			if strmatch('DE', shelf, 'exact'),	
				for ii = (lenD+1):(2*lenD),
					seqD{1,ii} = [org{1,1} DE];
				end
			% ???????????? Where to next: ????????????????
			nextEdge = [nextEdge 'E'];
			seqE = [seqE seqD{1,(lenD+1):(2*lenD)}]; 
			% !!!!!!!!!!!!!!! Clean up !!!!!!!!!!!!!!!!!!!
			shelf=[]; seqD= cell(1);
			end
		% ------
		case 'E',
			% --------------------------------							
			% remove 'targ' cases from nextEdge
			targ = 'E';
			temp = [];
			lenNextEdge = length(nextEdge);

			for ii = 1:lenNextEdge,
				if nextEdge(ii) ~= targ,
					temp = [temp nextEdge(ii)];
				end
			end
			nextEdge = temp;
			org = seqE;
			% --------------------------------			
			lenE = size(org); lenE = lenE(2);
			shelf = ['EF'; 'EG'];
			% --------------------simple branch ---------------
			% ::::::::::::::::::: branch 1 ::::::::::::::::::::
			if strmatch('EF', shelf, 'exact'),
				for ii = 1:lenE,
					seqE{1,ii} = [org{1,ii} EF];
				end
				% ???????????? Where to next: ????????????????
				seqF = [seqF seqE];
				nextEdge = [nextEdge 'F'];
			end
			% ::::::::::::::::::: branch 2 ::::::::::::::::::::
			if strmatch('EG', shelf, 'exact'),
				for ii = (lenE+1):(2*lenE),
					seqE{1,ii} = [org{1,1} EG];
				end
				% ???????????? Where to next: ????????????????						
				nextEdge = [nextEdge 'G'];
				seqG = [seqG seqE{1,(lenE+1):(2*lenE)}];
				% !!!!!!!!!!!!!!! Clean up !!!!!!!!!!!!!!!!!!!
				shelf=[]; seqE= cell(1);
			end

		% ------ 	
		case 'F',
			% --------------------------------
			% remove 'targ' cases from nextEdge
			targ = 'F';
			temp = [];
			lenNextEdge = length(nextEdge);

			for ii = 1:lenNextEdge,
				if nextEdge(ii) ~= targ,
					temp = [temp nextEdge(ii)];
				end
			end
			nextEdge = temp;
			org = seqF;
			% ---------------- branch with loop ---------------
			shelf = ['FK'; 'FH'];
			% :::::::::::::							
			% ::::::::::::::::::: branch 1 ::::::::::::::::::::
			% when this hits FK will not longer execute
			% as FK is never hit but from itself I get away with this
			if FKcount == 6,
				shelf = shelf(2:end);
			end
		
			if strmatch('FK', shelf, 'exact'),
				FKcount = FKcount + 1;
				seqFK = [org seqFK];				
				lenFK = size(seqFK); lenFK = lenFK(2); 					
				for jj = 1:lenFK,
					seqFK{1,jj} = [seqFK{1,jj} FK KF];
				end			
				% ???????????? Where to next: ????????????????
				nextEdge = [nextEdge, 'F'];
				seqF = [seqF seqFK];
			end
			
			% ::::::::::::::::::: branch 2 ::::::::::::::::::::
			if strmatch('FH', shelf, 'exact'),
				lenF = size(org); lenF = lenF(2);					
				for ii = 1:lenF,
					seqF{1,ii} = [org{1,ii} FH];
				end
				% ???????????? Where to next: ????????????????
				nextEdge = [nextEdge 'H']
				seqH = [seqH seqF];
				% !!!!!!!!!!!!!!! Clean up !!!!!!!!!!!!!!!!!!!
				shelf=[]; seqF = cell(1);
				end			

		case 'G',
			% --------------------------------
			% remove 'targ' cases from nextEdge
			targ = 'G';
			temp = [];
			lenNextEdge = length(nextEdge);

			for ii = 1:lenNextEdge,
				if nextEdge(ii) ~= targ,
					temp = [temp nextEdge(ii)];
				end
			end
			nextEdge = temp;
			org = seqG;
			% ---------------- branch with loop ---------------
			shelf = ['GL'; 'GI'];
			% ::::::::::::::::::: branch 1 ::::::::::::::::::::
			if GLcount == 6,
				shelf = shelf(2:end);
			end
			
			if strmatch('GL', shelf, 'exact'),
				GLcount = GLcount + 1;
				seqGL = [org seqGL];				
				lenGL = size(seqGL); lenGL = lenGL(2); 			
				for jj = 1:lenGL,
					seqGL{1,jj} = [seqGL{1,jj} GL LG];
				end
				% ???????????? Where to next: ????????????????
				seqG = [seqG seqGL];
				nextEdge = [nextEdge, 'G'];
			end
			% ::::::::::::::::::: branch 2 ::::::::::::::::::::		
			if strmatch('GI', shelf, 'exact'),
				lenG = size(seqG); lenG = lenG(2);
				for ii = 1:lenG,
					seqG{1,ii} = [seqG{1,ii}, GI]; 			
				end
				% ???????????? Where to next: ????????????????
				nextEdge = [nextEdge 'I'];
				seqI = [seqI seqG];
				% !!!!!!!!!!!!!!! Clean up !!!!!!!!!!!!!!!!!!!
				shelf=[]; seqG= cell(1);		
			end

		case 'H',
			% --------------------------------
			% remove 'targ' cases from nextEdge
			targ = 'H';
			temp = [];
			lenNextEdge = length(nextEdge);

			for ii = 1:lenNextEdge,
				if nextEdge(ii) ~= targ,
					temp = [temp nextEdge(ii)];
				end
			end
			nextEdge = temp;
			org = seqH;
			lenH = size(org); lenH = lenH(2);
			% --------------------simple branch ---------------
			shelf = ['HJ'; 'HG'];
			% ::::::::::::::::::: branch 1 ::::::::::::::::::::
			if strmatch('HJ', shelf, 'exact'),
				for ii = 1:lenH,
					seqH{1,ii} = [org{1,ii}, HJ Z];	
				end
				% ???????????? Where to next: ????????????????
				%  ------ TERMINAL --------
				seq = [seq seqH{1,1:lenH}]; 
			end
			% ::::::::::::::::::: branch 2 ::::::::::::::::::::
			if strmatch('HG', shelf, 'exact'),
				for ii = (lenH+1):(2*lenH),
					seqH{1,ii} = [org{1,1} HG];
				end		
				% ???????????? Where to next: ????????????????
				nextEdge = [nextEdge 'G'];
				seqG = [seqG seqH{1,(lenH+1):(2*lenH)}];
				% !!!!!!!!!!!!!!! Clean up !!!!!!!!!!!!!!!!!!!
				shelf=[]; seqH= cell(1);
			end				

		case 'I',
			% --------------------------------
			% remove 'targ' cases from nextEdge
			targ = 'H';
			temp = [];
			lenNextEdge = length(nextEdge);

			for ii = 1:lenNextEdge,
				if nextEdge(ii) ~= targ,
					temp = [temp nextEdge(ii)];
				end
			end
			nextEdge = temp;
			org = seqI;
			lenI = size(org); lenI = lenI(2);	
			% --------------------simple branch ---------------
			shelf = ['IH'; 'IJ'];
			% ::::::::::::::::::: branch 1 ::::::::::::::::::::
			if strmatch('IH', shelf, 'exact'),
				for ii = 1:lenI,
					seqI{1,ii} = [org{1,ii}, IH];	
				end
				% ???????????? Where to next: ????????????????
				nextEdge = [nextEdge 'H'];
				seqH = [seqH seqI];
			end
			% ::::::::::::::::::: branch 2 ::::::::::::::::::::
			if strmatch('IJ', shelf, 'exact'),
				for ii = (lenI+1):(2*lenI),
					seqI{1,ii} = [org{1,1} IJ Z];
				end		
				% ???????????? Where to next: ????????????????
				%  ------ TERMINAL --------
				seq = [seq seqI{1,(lenI+1:2*lenI)}];
				% !!!!!!!!!!!!!!! Clean up !!!!!!!!!!!!!!!!!!!
				shelf=[]; seqI= cell(1);
			end
		end
end
% deep array access
% y{1,1}{1,2} 

% I am not sure of and to lazy to calculate how many iterations are 
% necessary to get all possible strings for some desired length
% so just generated too many, and am sorting it out at the end
%
% Sort the results seq (the terminal sequences) by size
% Three nested loops:
% (1) for the diff sizes in
% (2) for seq{1,x}{} 
% (3) forseq{}{1,x}
seqOut = struct;

% build the outgoing data strucutre ahead, prevent annoying error
for lenRange = 1:length(seqLenRange),
	% seqOut.(name) for this iteration of seqRangeCount
	namedLen{1,lenRange} = strcat('length', num2str(seqLenRange(lenRange)));
	currentName = namedLen{1,lenRange};
	seqOut.(currentName) = [];
end

% !!!!!!TEST THIS with 'y' !!!!!!
for lenRange = 1:length(seqLenRange),
	% target length for this iteration
	searchLen = seqLenRange(lenRange);

	% loop though seq{1,x}{}
	for mm = 1:length(seq),
		% loop though seq{}{1,x}
		for nn = 1:length(seq{1,mm}),
			% the current string, and its length
			strCurrent = seq{1,mm}{1,nn};
			lenStrCurrent = length(seq{1,mm}{1,nn});
						
			if (lenStrCurrent-1) == searchLen,
				% combine the current str with the array, and drop the '0'
				% from terminal (Z)
				seqOut.(namedLen{1,lenRange}) = [seqOut.(namedLen{1,lenRange}); strCurrent(1:(lenStrCurrent-1))];
			end
		end
	end
end

% Do not bother to save all the seq ...
if ~(showAllSeq),
	seq = [];
end

% EOF
