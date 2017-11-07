function action = CS4300_MC_agent(percept)
% CS4300_hybrid_agent - hybrid random and logic-based agent
% On input:
% percept( 1x5 Boolean vector): percepts
%               stench, breeze, glitter, scream, bump
% On output:
% action (int): action selected by agent
% Call:
% a = CS4300_hybrid_agent([0,0,0,0,0]);
% Author:
% Haochen Zhang & Tim Wei
% UU
% Fall 2017
%

persistent plan board agent visited have_arrow on_new
persistent breezes stench pits Wumpus danger

if isempty(board)
    plan = [];
    board = ones(4,4);
    board(4,1) = 0;
    agent.x = 1;
    agent.y = 1;
    agent.dir = 0;
    visited = zeros(4,4);
    visited(4,1) = 1;
    danger = -ones(4,4);
    danger(4,1) = 0;
    have_arrow = 1;
    on_new = 1;
    breezes = ones(4,4);
    stench = ones(4,4);
end

FORWARD = 1;
RIGHT = 2;
LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

% Update breezes and stench
breezes(4-agent.y+1, agent.x) = percept(2);
stench(4-agent.y+1, agent.x) = percept(1);

% Update pits and Wumpus
num_trials = 50;
[pits,Wumpus] = CS4300_WP_estimates(breezes,stench,num_trials);

% Update danger
if on_new
    danger = pits + Wumpus;
end

frontiers = CS4300_frontier(visited);

% On the Gold
if isempty(plan)
    if percept(3)
        [so,~] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [1,1,0],'CS4300_A_star_Man');
        plan = [GRAB;so(2:end,end);CLIMB];
    end
end

% Plan a route to the closest safe square that it has not visited yet
if isempty(plan)
    safe_close = CS4300_choose_closest(danger, frontiers, [agent.x,agent.y],1);
    if ~isempty(safe_close)
        [so,~] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [safe_close(1),safe_close(2),0],'CS4300_A_star_Man');
        plan = so(2:end,end);
    end
end

% See if still have arrow
if isempty(plan)
    if have_arrow
        % Find the position of Wumpus
        W_pos = [-1,-1];
        for col = 1:4
            for row = 1:4
                if Wunpus(col,row) > 0.5
                    W_pos = [4-col+1,row];
                end
            end
        end
        
        if W_pos(1) ~= -1
            % Add all possible safe position that can make a shoot
            valid_pos = [];

            for celly = 1:length(visited(:,1))
                if celly ~= W_pos(1,:) && visited(celly,W_pos(1)) == 1
                    valid_pos = [valid_pos; celly,W_pos(1)];
                end
            end

            for cellx = 1:length(visited(1,:))
                if cellx ~= W_pos(:,1) && visited(W_pos(2), cellx) == 1
                    valid_pos = [valid_pos; W_pos(2), cellx];
                end
            end

            closest = [];
            if ~isempty(valid_pos)
                % find the closest square
                closest_dis = 99;
                for i = 1:length(valid_pos(:,1))
                    temp = [valid_pos(i,2),4-valid_pos(i,1)+1];
                    if CS4300_A_star_Man([agent.x,agent.y], temp) < closest_dis
                        closest = temp;
                        closest_dis = CS4300_A_star_Man([agent.x,agent.y],...
                            closest);
                    end
                end
            end

            %SHOOT
            if ~isempty(closest)
                [so,~] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,...
                    agent.dir],[closest(1),closest(2),0],'CS4300_A_star_Man');
                % Flag to show need turn sequence
                plan = [so(2:end,end), CS4300_gen_turn_seq(closest, W_pos,...
                    agent), SHOOT];
            end
            
        end
    end
end

% Looks for a square to explore that is not provably unsafe
% Take a risk
if isempty(plan)
    OK_close = CS4300_choose_closest(danger,frontiers, [agent.x,agent.y],0);
    if ~isempty(OK_close)
        board(4 - OK_close(2) + 1, OK_close(1)) = 0;
        [so,~] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [OK_close(1),OK_close(2),0],'CS4300_A_star_Man');
        plan = so(2:end,end);
    end
end

% DIE TRYING

% The mission is impossible, retreats to [1,1]
% if isempty(plan)
%     [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
%         [1,1,0],'CS4300_A_star_Man');
%     plan = [so(2:end,end), CLIMB];
% end

% Execute the action from the plan one by one
action = plan(1);
plan = plan(2:end);

on_new = 0;

if action==FORWARD
    [x_new,y_new] = CS4300_move(agent.x,agent.y,agent.dir);
    agent.x = x_new;
    agent.y = y_new;
    on_new = ~visited(4-y_new+1,x_new);
    visited(4-y_new+1,x_new) = 1;
end

if action==RIGHT
    agent.dir = rem(agent.dir+3,4);
end

if action==LEFT
    agent.dir = rem(agent.dir+1,4);
end

if action==SHOOT
    have_arrow = 0;
end