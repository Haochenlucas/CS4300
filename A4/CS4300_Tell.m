function KB_out = CS4300_Tell(KB,sentence)
% CS4300_Tell - Tell function for logic KB
% On input:
% KB (KB struct): Knowledge base (CNF)
% (k).clauses (1xp vector): disjunction clause
% sentence (KB struct): query theorem (CNF)
% (k).clauses (1xq vector): disjunction
3
% On output:
% KB_out (KB struct): revised KB
% Call:
% KB = CS4300_Tell([],[1]);
% Author:
% Haochen Zhang & Tim Wei
% UU
% Fall 2017
%