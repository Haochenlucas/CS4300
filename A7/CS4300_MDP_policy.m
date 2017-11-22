function policy = CS4300_MDP_policy(S,A,P,U)
% CS4300_MDP_policy - generate a policy from utilities
% See p. 648 Russell & Norvig
% On input:
%       S (vector): states (1 to n)
%       A (vector): actions (1 to k)
%       P (nxk struct array): transition model
%         (s,a).probs (a vector with n transition probabilities
%         from s to s_prime, given action a)
%       U (vector): state utilities
% On output:
%       policy (vector): actions per state
% Call:
%       p = CS4300_MDP_policy(S,A,P,U);
% Author:
%       Haochen Zhang & Tim Wei
%       UU
%       Fall 2017
%

len_A = length(A);
len_S = length(S);
policy = zeros(1,16);

for i = 1:len_S
    action = -1;
    U_max = -intmax;
    for j = 1:len_A
        probs = P(i,j).probs;
        U_matrix = U.*probs;
        U_prime = sum(U_matrix);
        if (U_max <= U_prime)
            U_max = U_prime;
            action = j;
        end
    end
    policy(i) = action;
end