function [S,A,R,P,U,Ut] = CS4300_run_value_iteration(gamma,max_iter)

S = 1:16;
A = 1:4;
P = transition_probability_table;
R = -ones(4);
R(:,3) = -1000*ones(1,4);
R(1,3) = -1;
R(1,4) = 1000;
R = [R(4,:),R(3,:),R(2,:),R(1,:)];
[U,Ut] = CS4300_MDP_value_iteration(S,A,P,R,gamma,0.1,max_iter);