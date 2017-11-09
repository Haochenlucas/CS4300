load('A5_boards.mat');
% for i = 1:1
for i = 1:length(boards)
    clear CS4300_MC_agent;
    [scores0(i),traces0(i).trace] = ...
        CS4300_WW1(10000,"CS4300_MC_agent",boards(i).board,0);
end
for i = 1:length(boards)
    clear CS4300_MC_agent;
    [scores50(i),traces50(i).trace] = ...
        CS4300_WW1(10000,"CS4300_MC_agent",boards(i).board,50);
end
for i = 1:length(boards)
    clear CS4300_MC_agent;
    [scores100(i),traces100(i).trace] = ...
        CS4300_WW1(10000,"CS4300_MC_agent",boards(i).board,100);
end
for i = 1:length(boards)
    clear CS4300_MC_agent;
    [scores200(i),traces200(i).trace] = ...
        CS4300_WW1(10000,"CS4300_MC_agent",boards(i).board,200);
end
save('stats.mat','scores0','scores50','scores100','scores200','traces0'...
    ,'traces50','traces100','traces200')