s = tic;
clear CS4300_hybrid_agent
[scores,traces] = CS4300_WW3(50,'CS4300_hybrid_agent');
CS4300_show_trace(traces,1);
toc(s)