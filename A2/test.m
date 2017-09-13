%while 1
    clear CS4300_agent_Astar_AC;
board = [0,0,0,2;0,0,0,0;0,0,1,0;0,0,1,0];
    trace = CS4300_WW2(1000,'CS4300_agent_Astar_AC',board);
 %   if trace(end).agent.gold && ~trace(end).agent.alive
  %      break;
   % end
%end
 m = CS4300_show_trace(trace,0.01);