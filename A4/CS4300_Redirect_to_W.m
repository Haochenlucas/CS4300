function trun_seq = CS4300_Redirect_to_W(closest, W_pos, agent);
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

trun_seq;
% Wampus are at the same COL with agent 
% The final action is moving from Left to Right
if closest(1) == W_pos(1) && agent(1) < W_pos(1)
    % Agent are BELOW Wampus
    if closest(2) < W_pos(2)
        turn_seq = LEFT;
    else % Agent are ABOVE Wampus
        turn_seq = RIGHT;
    end
    
% The final action is moving from Right to Left
elseif closest(1) == W_pos(1) && agent(1) > W_pos(1)
    % Agent are BELOW Wampus
    if closest(2) < W_pos(2)
        turn_seq = RIGHT;
    else % Agent are ABOVE Wampus
        turn_seq = LEFT;
    end
    
% Wampus are at the same ROW with agent
% The final action is moving UP
elseif closest(2) == W_pos(2) && agent(2) < W_pos(2)
    % Agent are on the LEFT side of Wampus
    if closest(1) < W_pos(1)
        turn_seq = RIGHT;
    else % Agent are on the RIGHT side of Wampus
        turn_seq = LEFT;
    end
    
% The final action is moving DOWN
elseif closest(2) == W_pos(2) && agent(2) > W_pos(2)
    % Agent are on the LEFT side of Wampus
    if closest(1) < W_pos(1)
        turn_seq = LEFT;
    else % Agent are on the RIGHT side of Wampus
        turn_seq = RIGHT;
    end
else
    % Should never be here
    dis("Finding shooting spot erro!")
end
