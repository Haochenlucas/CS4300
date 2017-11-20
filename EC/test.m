s = tic;
board = [0,0,0,0;0,0,0,0;0,2,0,0;0,1,0,0];
clear CS4300_agent_Astar_PC;
t = CS4300_WW2(1000,'CS4300_agent_Astar_PC',board)
g = t(end).agent.gold
toc(s)
