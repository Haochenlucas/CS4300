[~,~,~,~,~,Ut1] = CS4300_run_value_iteration(0.9,1000);
[~,~,~,~,~,Ut2] = CS4300_run_value_iteration(0.99,1000);
[~,~,~,~,~,Ut3] = CS4300_run_value_iteration(0.999,1000);
[~,~,~,~,~,Ut4] = CS4300_run_value_iteration(0.9999,1000);
[~,~,~,~,~,Ut5] = CS4300_run_value_iteration(0.99999,1000);
[~,~,~,~,~,Ut6] = CS4300_run_value_iteration(0.999999,1000);
save("Uts.mat","Ut1","Ut2","Ut3","Ut4","Ut5","Ut6")