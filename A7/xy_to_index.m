function index = xy_to_index(x,y)
% xy_to_index - convert x, y index to single number index
% On output:
%       x (int): x index (1 to 4)
%       y (int): y index (1 to 4)
%
%       Layout:                
%          13 14 15 16         
%           9 10 11 12         
%           5  6  7  8   
%           1  2  3  4         
%                              
%                              
% Call:
%       index = xy_to_index(1, 1);
% Author:
%       Haochen Zhang & Tim Wei
%       UU
%       Fall 2017
%
index = (y - 1) * 4 + x;