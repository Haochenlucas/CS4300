function trun_seq = CS4300_gen_turn_seq(initial, goal, agent)
% CS4300_Redirect_to_W - sequences of actions that makes agent to face W
% On input:
%     closest (1x2 vector): [x y] location where agent fire the arrow
%     W_pos (1x2 vector): [x y] location where W_pos are
%     agent_dir (1x3 vector): agent x, y and direction
%           Right: 0
%           Up: 1
%           Left: 2
%           Down: 3
% On output:
%     trun_seq (1x4 array): solution sequence of turning
% Call:
%     trun_seq = CS4300_Redirect_to_W([1,4], [4,4], 1);
% Author:
%     Haochen Zhang & Tim Wei
%     UU
%     Fall 2015
%

trun_seq = [];
ROTATE_RIGHT = 2;
ROTATE_LEFT = 3;

RIGHT = 0;
UP = 1;
LEFT = 2;
DOWN = 3;
goal_dir = -1;

if initial(1) == goal(1)
    if initial(2) < goal(2)
        goal_dir = UP;
    elseif initial(2) > goal(2)
        goal_dir = DOWN;
    end
end

if initial(2) == goal(2)
    if initial(1) < goal(1)
        goal_dir = RIGHT;
    elseif initial(1) > goal(1)
        goal_dir = LEFT;
    end
end

if goal_dir == -1
    return;
end

while goal_dir ~= agent.dir
    if agent.dir < goal_dir
        trun_seq = [trun_seq; ROTATE_LEFT];
    elseif agent.dir > goal_dir
        trun_seq = [trun_seq; ROTATE_RIGHT];
    end
end



