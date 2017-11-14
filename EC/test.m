%{
pit = 0;
for i = 1:2000
    clear CS4300_agent_Astar_AC;
    board = [1,0,2,0;0,0,0,0;0,0,1,0;0,0,0,1];
    trace = CS4300_WW2(1000,'CS4300_agent_Astar_AC',board);
    if trace(end).agent.gold && ~trace(end).agent.alive
        pit = pit + 1;
    end
end
disp(pit);
%}