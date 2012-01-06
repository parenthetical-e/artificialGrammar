% gcode() RUNFILE
% Written by EJP, 5/21/2007

% INTRO
% -----
% This script will covert one a matrix of sequence rows from one coding scheme
% to another.  It should be quite flexible as far i/o datatypes are concerned.

% NOTES
% -----
% Incoming data must be ROWs of matrix alpha or numeric sequences OR
% a cell array
% If the data is arranged in columns, set transpose = 1.
% Output is cell array - the recoded rows
% Assuming fileOut=1, a text file ("recode.out.txt") containing the 
% recoded sequences is saved. Console PWD controls where the file is 
% written.

% WARNING: unless renamed previous "recode.out.txt" files will be overwritten.

% The variable to be recoded 
dataIn = [1 2 3; 3 2 1];



% The number of elements in each must match and the order of currentCode must 
% match the replacement order.

% Coding values by EXAMPLE
% currentCode = [1 2 4 6 7];
% newCode 	= ['A' 'B' 'C' 'D' 'E'];
% Results in the sequence '12467' becoming 'ABCDE'

% However the recoded values can be really anything, 
% and need not be of the same size or type as currentCode. 
% Recoded values could be:
% 'A' or 'image1' or 'image12.png' or '12x3456', or whatever
% you can imagine. Combinations are of the above are OK too. 

currentCode = 	[1 2 3];
newCode = 		['A' 'B' 'C'];

% behavioral switches
debug=1;
verbose=1;
transpose=0;
fileOut=1;

% GO!
[recode] = gcode(dataIn, currentCode, newCode, verbose, debug, transpose, fileOut);