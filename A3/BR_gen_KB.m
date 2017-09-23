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
for i = 1:16
    index = length(KB) + 1;
    cur_i = index;
    
    % There must exist a -Bxy ^ ... no matter what.
    KB(index).clauses(end+1) = "-B" + (mod(i, 4)) + (floor(i/4) + 1);
    KBi(index).clauses(end+1) = -(16 + i);
    
    % Cells not on the left edge
    if mod(i, 4) == 1
        cur_i = index + 1;
        KB(index).clauses(end+1) =  "P" + (mod(i, 4) + 1) + (floor(i/4) + 1);
        KB(cur_i).clauses(end+1) = "-P" + (mod(i, 4) + 1) + (floor(i/4) + 1);
        KB(cur_i).clauses(end+1) =  "B" + (mod(i, 4)) + (floor(i/4) + 1);
        
        KBi(index).clauses(end+1) = i + 1;
        KBi(cur_i).clauses(end+1) = -(i + 1);
        KBi(cur_i).clauses(end+1) =  16 + i;
    end
    
    % Cells not on the right edge
    if mod(i, 4) ~= 0
        cur_i = index + 1;
        KB(index).clauses(end+1) =  "P" + (mod(i, 4) - 1) + (floor(i/4) + 1);
        KB(cur_i).clauses(end+1) = "-P" + (mod(i, 4) - 1) + (floor(i/4) + 1);
        KB(cur_i).clauses(end+1) =  "B" + (mod(i, 4)) + (floor(i/4) + 1);
        
        KBi(index).clauses(end+1) = i - 1;
        KBi(cur_i).clauses(end+1) = -(i - 1);
        KBi(cur_i).clauses(end+1) =  16 + i;
    end
    
    % Cells not on the bottom edge
    if i > 4
        cur_i = index + 1;
        KB(index).clauses(end+1) =  "P" + (mod(i, 4)) + (floor(i/4));
        KB(cur_i).clauses(end+1) = "-P" + (mod(i, 4)) + (floor(i/4));
        KB(cur_i).clauses(end+1) =  "B" + (mod(i, 4)) + (floor(i/4) + 1);
        
        KBi(index).clauses(end+1) = i - 4;
        KBi(cur_i).clauses(end+1) = -(i - 4);
        KBi(cur_i).clauses(end+1) =  16 + i;
    end
    
    % Cells not on the top edge
    if i < 13
        cur_i = index + 1;
        KB(index).clauses(end+1) =  "P" + (mod(i, 4)) + (floor(i/4) + 2);
        KB(cur_i).clauses(end+1) = "-P" + (mod(i, 4)) + (floor(i/4) + 2);
        KB(cur_i).clauses(end+1) =  "B" + (mod(i, 4)) + (floor(i/4) + 1);
        
        KBi(index).clauses(end+1) = i + 4;
        KBi(cur_i).clauses(end+1) = -(i + 4);
        KBi(cur_i).clauses(end+1) =  16 + i;
    end
end

% The 4 cells around a Wampus have S
for i = 1:16
    index = length(KB) + 1;
    cur_i = index;
    
    % There must exist a -Sxy ^ ... no matter what.
    KB(index).clauses(end+1) = "-S" + (mod(i, 4)) + (floor(i/4) + 1);
    KBi(index).clauses(end+1) = -(16 + i + 32);
    
    % Cells not on the left edge
    if mod(i, 4) == 1
        cur_i = index + 1;
        KB(index).clauses(end+1) =  "W" + (mod(i, 4) + 1) + (floor(i/4) + 1);
        KB(cur_i).clauses(end+1) = "-W" + (mod(i, 4) + 1) + (floor(i/4) + 1);
        KB(cur_i).clauses(end+1) =  "S" + (mod(i, 4)) + (floor(i/4) + 1);
        
        KBi(index).clauses(end+1) = i + 1 + 64;
        KBi(cur_i).clauses(end+1) = -(i + 1 + 64);
        KBi(cur_i).clauses(end+1) =  16 + i + 32;
    end
    
    % Cells not on the right edge
    if mod(i, 4) ~= 0
        cur_i = index + 1;
        KB(index).clauses(end+1) =  "W" + (mod(i, 4) - 1) + (floor(i/4) + 1);
        KB(cur_i).clauses(end+1) = "-W" + (mod(i, 4) - 1) + (floor(i/4) + 1);
        KB(cur_i).clauses(end+1) =  "S" + (mod(i, 4)) + (floor(i/4) + 1);
        
        KBi(index).clauses(end+1) = i - 1 + 64;
        KBi(cur_i).clauses(end+1) = -(i - 1 + 64);
        KBi(cur_i).clauses(end+1) =  16 + i + 32;
    end
    
    % Cells not on the bottom edge
    if i > 4
        cur_i = index + 1;
        KB(index).clauses(end+1) =  "w" + (mod(i, 4)) + (floor(i/4));
        KB(cur_i).clauses(end+1) = "-W" + (mod(i, 4)) + (floor(i/4));
        KB(cur_i).clauses(end+1) =  "S" + (mod(i, 4)) + (floor(i/4) + 1);
        
        KBi(index).clauses(end+1) = i - 4 + 64;
        KBi(cur_i).clauses(end+1) = -(i - 4 + 64);
        KBi(cur_i).clauses(end+1) =  16 + i + 32;
    end
    
    % Cells not on the top edge
    if i < 13
        cur_i = index + 1;
        KB(index).clauses(end+1) =  "W" + (mod(i, 4)) + (floor(i/4) + 2);
        KB(cur_i).clauses(end+1) = "-W" + (mod(i, 4)) + (floor(i/4) + 2);
        KB(cur_i).clauses(end+1) =  "S" + (mod(i, 4)) + (floor(i/4) + 1);
        
        KBi(index).clauses(end+1) = i + 4 + 64;
        KBi(cur_i).clauses(end+1) = -(i + 4 + 64);
        KBi(cur_i).clauses(end+1) =  16 + i + 32;
    end
end

% There is at most 1 Wampusfor i = 1:16
for i = 1:16
    KB(end + 1).clauses(end+1) = "-W" + (mod(i, 4)) + (floor(i/4) + 2);
    KB(end).clauses(end+1) =  "-W" + (mod(i, 4)) + (floor(i/4) + 1);

    KBi(end + 1).clauses(end+1) = -(i + 64);
    KBi(end).clauses(end+1) = -(i + 64);
end

% There is exactly 1 gold
for i = 1:16
    
end
