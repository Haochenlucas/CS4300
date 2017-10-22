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

P_offset = 0;
G_offset = 16;
B_offset = 32;
S_offset = 48;
W_offset = 64;

KB = [];
KBi = [];
vars = cell(80, 1);

% Build the vars array. P: 1~16; B: 17~32; G: 33~ 48; S: 49~64; W: 65~80
for a = 1:5
    label = "";
    switch a
    case 1
        label = "P";
    case 2
        label = "B";
    case 3
        label = "G";
    case 4
        label = "S";
    case 5
        label = "W";
    end
    
    for i = 1:16
        vars{16 * (a - 1) + i} = label + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
    end
end

% The 4 cells around a P have B
for i = 1:16
    index = length(KB) + 1;
    cur_i = index;
    
    % There must exist a -Bxy or ... no matter what.
    KB(index).clauses(1) = "-B" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
    KBi(index).clauses(1) = -(B_offset + i);
    
    % Cells not on the left edge
    if mod(i-1, 4)+1 ~= 1
        cur_i = cur_i + 1;
        KB(index).clauses(end+1) =  "P" + (mod(i-1, 4)+1 - 1) + (floor((i-1)/4)+1);
        KB(cur_i).clauses(1) = "-P" + (mod(i-1, 4)+1 - 1) + (floor((i-1)/4)+1);
        KB(cur_i).clauses(end+1) =  "B" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
        
        KBi(index).clauses(end+1) = P_offset + i - 1;
        KBi(cur_i).clauses(1) = -(P_offset + i - 1);
        KBi(cur_i).clauses(end+1) =  B_offset + i;
    end
    
    % Cells not on the right edge
    if mod(i, 4) ~= 0
        cur_i = cur_i + 1;
        KB(index).clauses(end+1) =  "P" + (mod(i-1, 4)+1 + 1) + (floor((i-1)/4)+1);
        KB(cur_i).clauses(1) = "-P" + (mod(i-1, 4)+1 + 1) + (floor((i-1)/4)+1);
        KB(cur_i).clauses(end+1) =  "B" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
        
        KBi(index).clauses(end+1) = P_offset + i + 1;
        KBi(cur_i).clauses(1) = -(P_offset + i + 1);
        KBi(cur_i).clauses(end+1) =  B_offset + i;
    end
    
    % Cells not on the bottom edge
    if i > 4
        cur_i = cur_i + 1;
        KB(index).clauses(end+1) =  "P" + (mod(i-1, 4)+1) + (floor((i-1)/4));
        KB(cur_i).clauses(1) = "-P" + (mod(i-1, 4)+1) + (floor((i-1)/4));
        KB(cur_i).clauses(end+1) =  "B" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
        
        KBi(index).clauses(end+1) = P_offset + i - 4;
        KBi(cur_i).clauses(1) = -(P_offset + i - 4);
        KBi(cur_i).clauses(end+1) =  B_offset + i;
    end
    
    % Cells not on the top edge
    if i < 13
        cur_i = cur_i + 1;
        KB(index).clauses(end+1) =  "P" + (mod(i-1, 4)+1) + (floor((i-1)/4)+2);
        KB(cur_i).clauses(1) = "-P" + (mod(i-1, 4)+1) + (floor((i-1)/4)+2);
        KB(cur_i).clauses(end+1) =  "B" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
        
        KBi(index).clauses(end+1) = P_offset + i + 4;
        KBi(cur_i).clauses(1) = -(P_offset + i + 4);
        KBi(cur_i).clauses(end+1) =  B_offset + i;
    end
end

% The 4 cells around a Wampus have S
for i = 1:16
    index = length(KB) + 1;
    cur_i = index;
    
    % There must exist a -Sxy or ... no matter what.
    KB(index).clauses(1) = "-S" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
    KBi(index).clauses(1) = -(S_offset + i);
    
    % Cells not on the left edge
    if mod(i-1, 4)+1 ~= 1
        cur_i = cur_i + 1;
        KB(index).clauses(end+1) =  "W" + (mod(i-1, 4)+1 - 1) + (floor((i-1)/4)+1);
        KB(cur_i).clauses(1) = "-W" + (mod(i-1, 4)+1 - 1) + (floor((i-1)/4)+1);
        KB(cur_i).clauses(end+1) =  "S" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
        
        KBi(index).clauses(end+1) = i - 1 + W_offset;
        KBi(cur_i).clauses(1) = -(i - 1 + W_offset);
        KBi(cur_i).clauses(end+1) =  S_offset + i;
    end
    
    % Cells not on the right edge
    if mod(i, 4) ~= 0
        cur_i = cur_i + 1;
        KB(index).clauses(end+1) =  "W" + (mod(i-1, 4)+1 + 1) + (floor((i-1)/4)+1);
        KB(cur_i).clauses(1) = "-W" + (mod(i-1, 4)+1 + 1) + (floor((i-1)/4)+1);
        KB(cur_i).clauses(end+1) =  "S" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
        
        KBi(index).clauses(end+1) = i + 1 + W_offset;
        KBi(cur_i).clauses(1) = -(i + 1 + W_offset);
        KBi(cur_i).clauses(end+1) =  S_offset + i;
    end
    
    % Cells not on the bottom edge
    if i > 4
        cur_i = cur_i + 1;
        KB(index).clauses(end+1) =  "w" + (mod(i-1, 4)+1) + (floor((i-1)/4));
        KB(cur_i).clauses(1) = "-W" + (mod(i-1, 4)+1) + (floor((i-1)/4));
        KB(cur_i).clauses(end+1) =  "S" + (mod(i-1, 4)+1) + (floor((i-1)/4)+1);
        
        KBi(index).clauses(end+1) = i - 4 + W_offset;
        KBi(cur_i).clauses(1) = -(i - 4 + W_offset);
        KBi(cur_i).clauses(end+1) =  S_offset + i;
    end
    
    % Cells not on the top edge
    if i < 13
        cur_i = cur_i + 1;
        KB(index).clauses(end+1) =  "W" + (mod(i-1, 4)+1) + (floor((i-1)/4)+2);
        KB(cur_i).clauses(1) = "-W" + (mod(i-1, 4)+1) + (floor((i-1)/4) + 2);
        KB(cur_i).clauses(end+1) =  "S" + (mod(i-1, 4)+1) + (floor((i-1)/4) + 1);
        
        KBi(index).clauses(end+1) = i + 4 + W_offset;
        KBi(cur_i).clauses(1) = -(i + 4 + W_offset);
        KBi(cur_i).clauses(end+1) =  S_offset + i;
    end
end

for c = KBi
    c.clauses = unique(c.clauses);
end

% No pit and Wampus at (1,1)
KBi(end + 1).clauses(1) = -(1 + P_offset);
KBi(end + 1).clauses(1) = -(1 + W_offset);
