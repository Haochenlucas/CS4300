function a = CS4300_board_fits_percept(breezes,stench,board)

a = 0;
% loop through all cells in board
for x = 1:4
    for y = 1:4
        cell = board(x,y);
        % get neighbour of the cell
        neis = BR_Wumpus_neighbors(x,y);
        %see if the neighbous's percept fits
        for i = 1:length(neis)
            xn = neis(i,1);
            yn = neis(i,2);
            % the cell is a pit
            if cell == 1
                if ~breezes(xn,yn)
                    return;
                end
            end
            % the cell has Wampus
            if cell > 2
                if ~stench(xn,yn)
                    return;
                end
            end
        end
    end
end
% loop through all cells in breezes and stench
for x = 1:4
    for y = 1:4
        b = breezes(x,y);
        s = stench(x,y);
        % get neighbour of the cell
        neis = BR_Wumpus_neighbors(x,y);
        %see if the neighbous's percept fits
        for i = 1:length(neis)
            xn = neis(i,1);
            yn = neis(i,2);
            if b == 1 && board(xn,yn) == 1
                b = 0;
            end
            if s == 1 && board(xn,yn) > 2
                s = 0;
            end
        end
        if b > 0 || s > 0
            return;
        end
    end
end
a = 1;