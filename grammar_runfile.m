% Artiificial grammar sequence generator README
% Written by EJP, 5/15/2007,
% and licenced under the GPL v2.
%
% INTRODUCTION
% The syntax of grammar creation, an overview:
% -------------------------------
% Abandon the automaton perspective.  
% Instead condsider it as a graph.
% A directed and wieghted graph.
% In this view each state is a vertex or node.
% Each arrow connecting nodes is an edge.
% Each edge has a wieght; the wieght is a number 
% but also is the word
% to be arranged grammatically, based on
% the topology of the graph, 
% that is the arrangement of edges and nodes.
% The order that you specify the nodes in
% defines the direction of the graph.
% Do not worry if you want to use letters,
% or whathaveyou, as the words.  There
% is a script that accompanies this that
% will let you convert to your hearts content.

% WHAT NOW?
% ---------
% Some concrete, stones, i.e. examples

% A very simple grammar
%     1 --> 2 --> 3
% which produces the sentence
% 123
% is denoted as,
E1 = ['A';'B';'1'];
E2 = ['B';'C';'2'];
E3 = ['C';'Z';'3'];

% then to simplify the calcs
% bing all the endges into a matrix
E = [E1, E2, E3];
%
% and can be be graphically depicted as 
%
%       1           2             3
% [A] ----- > [B] ------> [C] ------> [Z]
%
% The script requires the starting node be called 'A' 
% while the final is called 'Z'.  If these are not present, 
% at least once, the the script will end and
% scold you for failing
% to include them.  Try not to fail.





% NOTES
% str2num() converts as expected.  It will liter, later.





