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

persistent plan board agent safe visited have_gold pits Wumpus

if isempty(board)
    plan = [];
    board = [-1,-1,-1,-1; -1,-1,-1,-1;-1,-1,-1,-1;0,-1,-1,-1];
    pits = -ones(4,4);
    pits(4,1) = 0;
    Wumpus = -ones(4,4);
    Wumpus(4,1) = 0;
    agent.x = 1;
    agent.y = 1;
    agent.dir = 0;
    visited = zeros(4,4);
    visited(4,1) = 1;
    safe = -ones(4,4);
    safe(4,1) = 1;
    have_gold = 0;
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
            check_pit =  CS4300_Ask(KB, -(0 + cellx + 4 * (celly - 1)));
            check_W = CS4300_Ask(KB, -(64 + cellx + 4 * (celly - 1)));
            if check_pit && check_W
                safe(cellx,celly) = 1;
            else
                safe(cellx,celly) = 0;
            end
        end
    end
end

% Ask KB if the current has glitter.
check_g =  CS4300_Ask(KB, -(16 + x + 4 * (y - 1)));
if check_g
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [GRAB;so(2:end,end);CLIMB];
end

% Plan a route to the closest safe square that it has not visited yet
if isempty(plan)
    OK1 = CS4300_choose_closest(safe,visited, [agent.x,agent.y]);
    if ~isempty(OK1)
        [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [OK1(1),OK1(2),0],'CS4300_A_star_Man');
        plan = [so(2:end,end)];
    end
end

% See if still have arrow
if isempty(plan)
    goal = [];
    neighbors = CS4300_Wumpus_neighbors(agent.x,agent.y);
    num_neighbors = length(neighbors(:,1));
    for n = 1:num_neighbors
        if board(4-neighbors(n,2)+1,neighbors(n,1))<0
            goal = neighbors(n,:);
        end
    end
    if isempty(goal)
        [rows,cols] = find(board==-1);
        if isempty(rows)
            goal = [1,1];
        else
            goal = [cols(1),4-rows(1)+1];
        end
    end
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [goal,0],'CS4300_A_star_Man');
    plan = [so(2:end,end)];
end

% Looks for a square to explore that is not provably unsafe
% Take a risk
if isempty(plan)
    % Look for a square to explore
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [HERE],'CS4300_A_star_Man');
    plan = [so(2:end,end)];
end

% The mission is impossible, retreats to [1,1]
if isempty(plan)
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [so(2:end,end)];
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

if action==GRAB
    have_gold = 1;
end
