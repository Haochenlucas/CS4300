function [KB,KBi,vars] = BR_gen_KB
% BR_gen_KB - generate Wumpus World logic in KB
% On input:
% N/A
% On output:
% KB (CNF KB): KB with Wumpus logic (atom symbols)
% (k).clauses (string): string form of disjunction
% KBi (CNF KB): KB with Wumpus logic (integers)
% (k).clauses (1xp vector): integer form of disjunction
% vars(struct: vector of strings): list of atom strings
% (k).var (string): name of atom
% Call:
% [KB,KBi,vars] = CS4300_gen_KB;
% Author:
% Tim Wei, Haochen Zhang
% UU
% Fall 2017
%

% The string form and integer form of the symbols are generated as
% the following:
%   String form will be in the form of [variable type][x][y]
%   Where there are 5 variable types:
%       P (pit), B (breeze), G (gold), S (stench), and W (Wumpus)
%   and x and y are numbers from 1 to 4 representing the index of a cell.
%   Each variable type has 16 variables, making 80 total variables.
%   e.g.: P11, B43
%
%   Integer form will be the encoded version of each variables.
%   Each variable is represented as a int from 1 to 80, ordered by
%   variable types (as listed above), x, and then y (both in
%   ascending order).
%   If the string forms of the variables is ordered by its value in 
%   integer form, the list will be:
%       P11, P21, P31, P41, P12,
%       P22,...,P44,B11,B21,...,G11,...,S11,...,W44
%

vars = 1:80;

% The 4 cells around a P have B

% The 4 cells around a Wampus have S

% There is at most 1 Wampus

% There is exactly 1 gold