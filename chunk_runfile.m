% The template runfile for chunk()
% EJP, 5/20/2208
% ********************************
%
% NOTES
% -----
% Incoming matrix sequence data (SEQ) must be in ROWs.
% Mixing alpha and numerics may result in errors.
%
% If the data is arranged in columns, set transpose = 1.

% Output is a structured array chunkDB as well as two 
% text files ("chunks.out.txt" and "freqs.out.txt"; 
% if you want to save the outputed object reassign it prior to 
% running this script again.
%
% This script also writes two textfiles one 
% WARNINGS: 
% --------
% Unless renamed prior to running this script
% "chunks/freq.out.txt" will be overwritten.
%
% Set the PWD of the MATLAB console to wherever you want
% "chunks/freq.out.txt" to be written prior to running.
%
% For large numbers of sequences this script may be low.
%
%
% INPUT VARS
% ---------
SEQ = seqOut.length14;
chunkWidth = 3;
verbose = 0;
debug = 0;
transpose = 0;
CDB=struct;

clear chunkDB;

% GO!
[chunkDB] = chunk(SEQ, chunkWidth, verbose, debug, transpose);
