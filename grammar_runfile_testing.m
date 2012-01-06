% Artiificial grammar sequence generator README
% Written by EJP, 5/15/2007,
% and licensed under the GPL v2.
%
% INTRODUCTION
% The syntax of grammar creation, an overview:
% -------------------------------
% Abandon the automaton perspective.  
% Instead consider it as a graph.
% A directed and weighted graph.
% In this view each state is a vertex or node.
% Each arrow connecting nodes is an edge.
% Direction of the edge is specified by the 
% order of the node (i.e AB give A --> B, while
% BA give B --> A)
% Each edge has a weight; the weight is a number 
% but also is the word
% to be arranged grammatically, based on
% the topology of the graph, 
% that is the arrangement of edges and nodes.
% Do not worry if you want to use letters,
% or whathaveyou, as the words.  There
% is a script that accompanies this that
% will let you easily convert.

% WHAT NOW?
% ---------
% Some concrete, stones, i.e. examples

% A very simple grammar
%     1 --> 2 --> 3
% which produces the sentence
% 123
% is denoted as,
% E1 = ['A';'B';'1'];
% E2 = ['B';'C';'2'];
% E3 = ['C';'Z';'3'];

% then to simplify the calcs
% bing all the endges into a matrix
% E = [E1, E2, E3];
%
% and can be be graphically depicted as 
%
%       1           2             3
% [A] ----- > [B] ------> [C] ------> [Z]
%
% The script requires the starting node be called 'A' 
% while the final is called 'Z'.  ONLY A and Z may
% be used multiple times.  Usiing other chracters multiple times, 
% OHTER than for branching will lead to BAD sequences
% If A and Z are not present, 
% at least once, the the script will end and
% scold you for failing
% to include them.
2
% ------------
% Declarations
% ------------
% Some concrete, stones, i.e. examples

% A very simple grammar
%     1 --> 2 --> 3
% which produces the sentence
% 123
% is denoted as,
% E1 = ['A';'B';'1'];
% E2 = ['B';'C';'2'];
% E3 = ['C';'Z';'3'];
% E4 = ['C';'C';'3'];
% E = [E1, E2, E3];

% test 2
E1 = ['A';'B';'1'];
E2 = ['B';'C';'7'];
E3 = ['B';'D';'5'];
E4 = ['C';'E';'9'];
E5 = ['D';'E';'6'];
E6 = ['E';'Z';'3'];
E = [E1, E2, E3, E4, E5, E6];


% grammar() parameters;
% all must be valued 
minLen=1;
maxLen=6; 
chunk=0;
verbose=1;
debug=1;

% SO DO IT!
[finishedSeq, workingSeq] = grammar(E,minLen,maxLen,chunk,verbose,debug);