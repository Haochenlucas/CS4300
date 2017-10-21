function closest = CS4300_choose_closest(safe,visited,current_pos)
% CS4300_choose1 - choose a closest safe place to go
% On input:
%     safe (4x4 array): 1 if safe, else 0
%     visited (4x4 array): 1 if visited, else 0
% On output:
%     loc (1x2 vector): [x y] location
% Call:
%     loc = CS4300_choose1(safe,visited);
% Author:
%     Haochen Zhang & Tim Wei
%     UU
%     Fall 2015
%

closest = [];
[rows,cols] = find(safe==1&visited==0);

if ~isempty(rows)
    % find the closest square
    closest_dis = 99;
    for i = 1:length(cols(:,1))
        temp = [cols(i),4-rows(i)+1];
        if CS4300_A_star_Man(current_pos, temp) < closest_dis
            closest = temp;
            closest_dis = CS4300_A_star_Man(current_pos, closest);
        end
    end
end