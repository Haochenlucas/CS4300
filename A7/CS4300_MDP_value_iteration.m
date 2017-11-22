function [U,U_trace] = CS4300_MDP_value_iteration(S,A,P,R,gamma,...
eta,max_iter)
% CS4300_MDP_value_iteration - compute policy using value iteration
% On input:
%       S (vector): states (1 to n)
%       A (vector): actions (1 to k)
%       P (nxk struct array): transition model
%         (s,a).probs (a vector with n transition probabilities
%         (from s to s_prime, given action a)
%       R (vector): state rewards
%       gamma (float): discount factor
%       eta (float): termination threshold
%       max_iter (int): max number of iterations
% On output:
%       U (vector): state utilities
%       U_trace (iterxn): trace of utility values during iteration
% Call:
%       [U,Ut] = CS4300_MDP_value_iteration(S,A,P,R,0.999999,0.1,100);
%
%       Set up a driver function, CS_4300_run_value_iteration (see
%       below), which sets up the Markov Decision Problem and calls this
%       function.
%
%       Chapter 17 Russell and Norvig (Table p. 651)
%       [S,A,R,P,U,Ut] = CS4300_run_value_iteration(0.999999,1000)
%
%       U’ = 0.7053 0.6553 0.6114 0.3879 0.7616 0 0.6600 -1.0000
%       0.8116 0.8678 0.9178 1.0000
%
%       Layout:                1
%          13 14 15 16         ˆ
%           9 10 11 12         |
%           5  6  7  8     2 <- -> 4
%           1  2  3  4         |
%                              V
%                              3
% Author:
%       Haochen Zhang & Tim Wei
%       UU
%       Fall 2017
%

len_S = length(S);
len_A = length(A);
U = zeros(16,1);
Up = zeros(16,1);
U_trace = [U];
delta = 0;
iter = 0;

while (delta >= eta*(1-gamma)/gamma || iter < max_iter)
    % Up: U'
    U = Up;
    delta = 0;
    for i = 1:len_S
        max_P_U = -intmax;
        for j = 1:len_A
            P_U = sum(P(i,j).probs.*U);
            if P_U >= max_P_U
                max_P_U = P_U;
            end
        end
        
        Up(i) = R(i) + gamma * max_P_U;
        if (Up(i) - U(i)) > delta
            delta = abs(Up(i) - U(i));
        end
    end
    U_trace = [U_trace; Up];
    iter = iter + 1;
end
