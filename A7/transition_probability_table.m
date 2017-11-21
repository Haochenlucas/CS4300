function P = transition_probability_table()
% transition_probability_table - return destination cell and their...
%        probabilities
% On output:
%       P (nxk struct array): transition model
%           (s,a).probs (a vector with n transition probabilities
%           (from s to s_prime, given action a)
%
%       Layout:                1
%          13 14 15 16         ˆ
%           9 10 11 12         |
%           5  6  7  8     2 <- -> 4
%           1  2  3  4         |
%                              V
%                              3
% Call:
%       cell = [1,1];
%       cell_p = transition_probability_table(cell, 1);
% Author:
%       Haochen Zhang & Tim Wei
%       UU
%       Fall 2017
%
P = [];
x = S(1);
y = S(2);
neis = BR_Wumpus_neighbors(x,y);
len_neis = length(neis);
possible_dirs = [];
for i = 1:len_neis
    % neighbors that are below
    if neis(i,1) == x && neis(i,2) == (y - 1)
        possible_dirs = [possible_dirs; 0];
    % neighbors that are above
    elseif neis(i,1) == x && neis(i,2) == (y + 1)
        possible_dirs = [possible_dirs; 1];
    % neighbors that are at left
    elseif neis(i,2) == y && neis(i,1) == (x - 1)
        possible_dirs = [possible_dirs; 2];
    % neighbors that are at right
    elseif neis(i,2) == y && neis(i,1) == (x + 1)
        possible_dirs = [possible_dirs; 3];
    end
end

switch action
    % Action: Up
    case 1
        % UP
        if ismember(1,possible_dirs)
            P = [P; x, y+1, 0.8];
        else
            P = [P; x, y, 0.8];
        end
        % Left
        if ismember(2,possible_dirs)
            P = [P; x-1, y, 0.1];
        else
            P = [P; x, y, 0.1];
        end
        % Right
        if ismember(3,possible_dirs)
            P = [P; x+1, y, 0.1];
        else
            P = [P; x, y, 0.1];
        end
        
    % Action: Left
    case 2
        % Left
        if ismember(2,possible_dirs)
            P = [P; x-1, y, 0.8];
        else
            P = [P; x, y, 0.8];
        end
        % Up
        if ismember(1,possible_dirs)
            P = [P; x, y+1, 0.1];
        else
            P = [P; x, y, 0.1];
        end
        % Down
        if ismember(0,possible_dirs)
            P = [P; x, y-1, 0.1];
        else
            P = [P; x, y, 0.1];
        end
        
    % Action: Down
    case 3
        % Down
        if ismember(0,possible_dirs)
            P = [P; x, y-1, 0.8];
        else
            P = [P; x, y, 0.8];
        end
        % Left
        if ismember(2,possible_dirs)
            P = [P; x-1, y, 0.1];
        else
            P = [P; x, y, 0.1];
        end
        % Right
        if ismember(3,possible_dirs)
            P = [P; x+1, y, 0.1];
        else
            P = [P; x, y, 0.1];
        end
    % Action: Right
    case 4
        % Right
        if ismember(4,possible_dirs)
            P = [P; x+1, y, 0.8];
        else
            P = [P; x, y, 0.8];
        end
        % UP
        if ismember(1,possible_dirs)
            P = [P; x, y+1, 0.1];
        else
            P = [P; x, y, 0.1];
        end
        % Down
        if ismember(0,possible_dirs)
            P = [P; x, y-1, 0.1];
        else
            P = [P; x, y, 0.1];
        end
end

% Combine deplicated cell
% do it backwards
len_cell_p = length(P(:,1));
for i = 0:len_cell_p - 2
    if (P(len_cell_p - i,1) == P(1,1) &&...
            P(len_cell_p - i,2) == P(1,2))
        P(1,3) = P(len_cell_p - i,3) + P(1,3);
        P(len_cell_p - i,:) = [];
    end
end

