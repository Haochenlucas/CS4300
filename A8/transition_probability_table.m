function P = transition_probability_table()
% transition_probability_table - Create the transition probability table 
%       for the following board.
%
%           0 0 0 2
%           0 0 1 0
%           0 0 3 0
%           0 0 1 0
%
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
%       P = transition_probability_table();
% Author:
%       Haochen Zhang & Tim Wei
%       UU
%       Fall 2017
%
Up = 1;
Left = 2;
Down = 3;
Right = 4;
for x = 1:4
    for y = 1:4
        index = xy_to_index(x,y);
        neis = BR_Wumpus_neighbors(x,y);
        len_neis = length(neis);
        possible_dirs = [];
        for i = 1:len_neis
            % neighbors that are above
            if neis(i,1) == x && neis(i,2) == (y + 1)
                possible_dirs = [possible_dirs; Up];
            % neighbors that are at left
            elseif neis(i,2) == y && neis(i,1) == (x - 1)
                possible_dirs = [possible_dirs; Left];
            % neighbors that are below
            elseif neis(i,1) == x && neis(i,2) == (y - 1)
                possible_dirs = [possible_dirs; Down];
            % neighbors that are at right
            elseif neis(i,2) == y && neis(i,1) == (x + 1)
                possible_dirs = [possible_dirs; Right];
            end
        end

        for i = 1:4
            P(index,i).probs = zeros(16,1);
        end
        if (x == 3 && y ~= 4) || (x == 4 && y == 4)
            continue;
        end

        % Action: Up
        % UP
        if ismember(Up,possible_dirs)
            sp = xy_to_index(x,y+1);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Up).probs(sp) = P(index,Up).probs(sp) + 0.8;
        % Left
        if ismember(Left,possible_dirs)
            sp = xy_to_index(x-1,y);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Up).probs(sp) = P(index,Up).probs(sp) + 0.1;
        % Right
        if ismember(Right,possible_dirs)
            sp = xy_to_index(x+1,y);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Up).probs(sp) = P(index,Up).probs(sp) + 0.1;

        % Action: Left
        % Left
        if ismember(Left,possible_dirs)
            sp = xy_to_index(x-1,y);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Left).probs(sp) = P(index,Left).probs(sp) + 0.8;
        % Up
        if ismember(Up,possible_dirs)
            sp = xy_to_index(x,y+1);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Left).probs(sp) = P(index,Left).probs(sp) + 0.1;
        % Down
        if ismember(Down,possible_dirs)
            sp = xy_to_index(x,y-1);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Left).probs(sp) = P(index,Left).probs(sp) + 0.1;

        % Action: Down
        % Down
        if ismember(Down,possible_dirs)
            sp = xy_to_index(x,y-1);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Down).probs(sp) = P(index,Down).probs(sp) + 0.8;
        % Left
        if ismember(Left,possible_dirs)
            sp = xy_to_index(x-1,y);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Down).probs(sp) = P(index,Down).probs(sp) + 0.1;
        % Right
        if ismember(Right,possible_dirs)
            sp = xy_to_index(x+1,y);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Down).probs(sp) = P(index,Down).probs(sp) + 0.1;

        % Action: Right
        % Right
        if ismember(Right,possible_dirs)
            sp = xy_to_index(x+1,y);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Right).probs(sp) = P(index,Right).probs(sp) + 0.8;
        % UP
        if ismember(Up,possible_dirs)
            sp = xy_to_index(x,y+1);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Right).probs(sp) = P(index,Right).probs(sp) + 0.1;
        % Down
        if ismember(Down,possible_dirs)
            sp = xy_to_index(x,y-1);
        else
            sp = xy_to_index(x,y);
        end
        P(index,Right).probs(sp) = P(index,Right).probs(sp) + 0.1;
    end
end