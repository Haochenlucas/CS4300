function [w,per_cor] = CS4300_perceptron_learning(X,y,alpha,max_iter,rate)
%   CS4300_perceptron_learning - find linear separating hyperplane
%       Eqn 18.7, p. 724 Russell and Norvig
%   On input:
%       X (nxm array): n independent variable samples each of length m
%       y (nx1 vector): dependent variable samples
%       alpha (float): learning rate
%       max_iter (int): max number of iterations
%       rate (Boolean): if 1 then alpha = 1000/(1000+iter), else constant
%   On output:
%       w ((m+1)x1 vector): weights for linear function
%       per_cor (kx1 array): trace of percentage correct with weight
%   Call:       
%       [w,pc] = CS4300_perceptron_learning(X,y,0.1,10000,1);
%   Author:
%       Haochen Zhang & Tim Wei
%       UU
%       Fall 2017
%

% Initialize w
w = 0.02 * rand(1,225+1) - 0.01;
iter = 0;
% Run for x epoches
for i = 1: max_iter
    % shuffle the data sets
    data = data(randperm(end), :);
    
    for j = 1 : length(data)
        y_ = y(j);
        x_ = X(j,:);
        if y_ * (w * x_' + b) <= 0
            if rate
                alpha = alpha * 1000/(1000 + iter);
            end
            
            h = 0;
            if (w * x_) >= 0
                h = 1;
            end
            w = w + (alpha * (y_ - h)) * x_;
        end
        
        iter = iter + 1;
    end
end