function action = CS4300_hybrid_agent(percept)
% CS4300_hybrid_agent - hybrid random and logic-based agent
% On input:
% percept( 1x5 Boolean vector): percepts
% On output:
% action (int): action selected by agent
% Call:
% a = CS4300_hybrid_agent([0,0,0,0,0]);
% Author:
% Haochen Zhang & Tim Wei
% UU
% Fall 2017
%

persistent plan board agent safe visited have_arrow W_pos

if isempty(board)
    plan = [];
    board = [-1,-1,-1,-1; -1,-1,-1,-1;-1,-1,-1,-1;0,-1,-1,-1];
    agent.x = 1;
    agent.y = 1;
    agent.dir = 0;
    visited = zeros(4,4);
    visited(4,1) = 1;
    safe = -ones(4,4);
    safe(4,1) = 1;
    have_arrow = 1;
    % Wampus position unknown
    W_pos = [-1,-1];
end

FORWARD = 1;
RIGHT = 2;
LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

% Update KB
sentence = CS4300_make_percept_sentence(percept,agent.x,agent.y);
KB = CS4300_Tell(KB, sentence);

% Update safe
for celly = 1:length(safe(:,1))
    for cellx = 1:length(safe(1,:))
        if safe(cellx,celly) == -1
            check_no_pit =  CS4300_Ask(KB, -(0 + cellx + 4 * (celly - 1)));
            check_no_W = CS4300_Ask(KB, -(64 + cellx + 4 * (celly - 1)));
            if check_no_pit && check_no_W
                safe(cellx,celly) = 1;
            end
            
            check_pit =  CS4300_Ask(KB, (0 + cellx + 4 * (celly - 1)));
            if check_pit
                safe(cellx,celly) = 0;
            end
            
            % Locate the Wampus if not alocated
            if W_pos(:,1) ~= -1
                check_W = CS4300_Ask(KB, (64 + cellx + 4 * (celly - 1)));
                if check_W
                    safe(cellx,celly) = 0;
                    W_pos = [cellx, celly];
                end
            end
        end
    end
end

% Ask KB if the current has glitter.
check_g =  CS4300_Ask(KB, (16 + x + 4 * (y - 1)));
if check_g
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [GRAB;so(2:end,end);CLIMB];
end

% Plan a route to the closest safe square that it has not visited yet
if isempty(plan)
    safe_close = CS4300_choose_closest(safe,visited, [agent.x,agent.y],1);
    if ~isempty(safe_close)
        [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [safe_close(1),safe_close(2),0],'CS4300_A_star_Man');
        plan = [so(2:end,end)];
    end
end

% See if still have arrow
if isempty(plan)
    if have_arrow && W_pos(:,1) ~= -1
        valid_pos = [W_pos];
        
        for celly = 1:length(safe(:,1))
            if celly ~= W_pos(1,:) && safe(W_pos(:,1), celly) == 1
                valid_pos(end+1) = [W_pos(:,1), celly];
            end
        end
        
        for cellx = 1:length(safe(1,:))
            if cellx ~= W_pos(:,1) && safe(cellx, W_pos(1,:)) == 1
                valid_pos(end+1) = [cellx, W_pos(1,:)];
            end
        end
        valid_pos = valid_pos(2:end);
        
        closest = [];
        if ~isempty(valid_pos)
            % find the closest square
            closest_dis = 99;
            for i = 1:length(valid_pos(:,1))
                temp = [valid_pos(i),4-rows(i)+1];
                if CS4300_A_star_Man(current_pos, temp) < closest_dis
                    closest = temp;
                    closest_dis = CS4300_A_star_Man(current_pos, closest);
                end
            end
        end
        
        %SHOOT
        if ~isempty(closest)
            [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
                [closest(1),closest(2),0],'CS4300_A_star_Man');
            % TODO: TRUN_SEQUENCE
            plan = [so(2:end,end), TRUN_SEQUENCE, SHOOT];
        end
    end
end

% Looks for a square to explore that is not provably unsafe
% Take a risk
if isempty(plan)
    OK_close = CS4300_choose_closest(safe,visited, [agent.x,agent.y],0);
    if ~isempty(OK_close)
        [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [OK_close(1),OK_close(2),0],'CS4300_A_star_Man');
        plan = [so(2:end,end)];
    end
end

% The mission is impossible, retreats to [1,1]
if isempty(plan)
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [so(2:end,end), CLIMB];
end

% Execute the action from the plan one by one
action = plan(1);
plan = plan(2:end);

if action==FORWARD
    [x_new,y_new] = CS4300_move(agent.x,agent.y,agent.dir);
    agent.x = x_new;
    agent.y = y_new;
    visited(4-y_new+1,x_new) = 1;
    board(4-y_new+1,x_new) = 0;
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
