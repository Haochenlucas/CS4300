function [KB,KBi,vars] = BR_gen_KB
% BR_gen_KB - generate Wumpus World logic in KB
% On input:
% N/A
% On output:
% KB (CNF KB): KB with Wumpus logic (atom symbols)
% (k).clauses (string): string form of disjunction
% KBi (CNF KB): KB with Wumpus logic (integers)
% (k).clauses (1xp vector): integer form of disjunction
2
% vars(struct: vector of strings): list of atom strings
% (k).var (string): name of atom
% Call:
% [KB,KBi,vars] = CS4300_gen_KB;
% Author:
% Haochen Zhang, Tim Wei
% UU
% Fall 2017
%