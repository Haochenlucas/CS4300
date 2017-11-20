function cell_p = transition_probability_table(S, action)
% transition_probability_table - return destination cell and their...
%        probabilities
% On input:
%       S (1*2 vector): state (x,y)
%       A (int): actions (1 to 4)
% On output:
%       P (nx3 double matrix): transition model
%         P(:,1): x index of cell
%         P(:,2): y index of cell
%         P(:,3): Probability
% Call:
%       cell = [1,1];
%       cell_p = transition_probability_table(cell, 1);
% Author:
%       Haochen Zhang & Tim Wei
%       UU
%       Fall 2017
%
cell_p = [];
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
            cell_p = [cell_p; x, y+1, 0.8];
        else
            cell_p = [cell_p; x, y, 0.8];
        end
        % Left
        if ismember(2,possible_dirs)
            cell_p = [cell_p; x-1, y, 0.1];
        else
            cell_p = [cell_p; x, y, 0.1];
        end
        % Right
        if ismember(3,possible_dirs)
            cell_p = [cell_p; x+1, y, 0.1];
        else
            cell_p = [cell_p; x, y, 0.1];
        end
        
    % Action: Left
    case 2
        % Left
        if ismember(2,possible_dirs)
            cell_p = [cell_p; x-1, y, 0.8];
        else
            cell_p = [cell_p; x, y, 0.8];
        end
        % Up
        if ismember(1,possible_dirs)
            cell_p = [cell_p; x, y+1, 0.1];
        else
            cell_p = [cell_p; x, y, 0.1];
        end
        % Down
        if ismember(0,possible_dirs)
            cell_p = [cell_p; x, y-1, 0.1];
        else
            cell_p = [cell_p; x, y, 0.1];
        end
        
    % Action: Down
    case 3
        % Down
        if ismember(0,possible_dirs)
            cell_p = [cell_p; x, y-1, 0.8];
        else
            cell_p = [cell_p; x, y, 0.8];
        end
        % Left
        if ismember(2,possible_dirs)
            cell_p = [cell_p; x-1, y, 0.1];
        else
            cell_p = [cell_p; x, y, 0.1];
        end
        % Right
        if ismember(3,possible_dirs)
            cell_p = [cell_p; x+1, y, 0.1];
        else
            cell_p = [cell_p; x, y, 0.1];
        end
    % Action: Right
    case 4
        % Right
        if ismember(4,possible_dirs)
            cell_p = [cell_p; x+1, y, 0.8];
        else
            cell_p = [cell_p; x, y, 0.8];
        end
        % UP
        if ismember(1,possible_dirs)
            cell_p = [cell_p; x, y+1, 0.1];
        else
            cell_p = [cell_p; x, y, 0.1];
        end
        % Down
        if ismember(0,possible_dirs)
            cell_p = [cell_p; x, y-1, 0.1];
        else
            cell_p = [cell_p; x, y, 0.1];
        end
end

% Combine deplicated cell
% do it backwards
len_cell_p = length(cell_p(:,1));
for i = 0:len_cell_p - 2
    if (cell_p(len_cell_p - i,1) == cell_p(1,1) &&...
            cell_p(len_cell_p - i,2) == cell_p(1,2))
        cell_p(1,3) = cell_p(len_cell_p - i,3) + cell_p(1,3);
        cell_p(len_cell_p - i,:) = [];
    end
end

