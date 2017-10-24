function [Sn, finished] = CS4300_update_S(Sip,Ti,Ui,start_time)
% CS4300_update_S - remove Ti from S and add Ui
% On input:
%     Sip (CNF data structure): current conjuctive clauses
%       (i).clauses
%           each clause is a list of integers (- for negated literal)
%     Ti (CNF data structure): parent clauses
%     Ui (CNF data structure): resolvent clauses
%     start_time (timerVal): an absolute start time from the caller
% On output:
%     Sn (CNF data structure): results of set operations
%     finished (boolean): this function is not time-out
% Call:
%     Sn = CS4300_update_S(Sip,Ti,Ui);
% Author:
%     T. Henderson
%     UU
%     Summer 2014
% Modified by:
%     Haochen Zhang & Tim Wei
%     UU
%     Fall 2017
%

Sn = [];
finished = 1;

len_Sip = length(Sip);
len_Ti = length(Ti);
len_Ui = length(Ui);

len_Sn = 0;

found = zeros(len_Sip,1);
for ind_Ti = 1:len_Ti
    clause_Ti = Ti(ind_Ti).clauses;
    s_Ti = sort(clause_Ti);
    for ind_Sip = 1:len_Sip
        clause_Sip = Sip(ind_Sip).clauses;
        s_Sip = sort(clause_Sip);
        if (length(s_Ti)==length(s_Sip))&prod(s_Ti==s_Sip)==1
            found(ind_Sip) = 1;
        end
    end
    
%     if toc(start_time) > 0.5
%         finished = 0;
%         return;
%     end
end

indexes = find(found==0);
if ~isempty(indexes)
    len_Sn = length(indexes);
    for n = 1:len_Sn
        Sn(n).clauses = Sip(indexes(n)).clauses;
    end
end 

if isempty(Ui)
    Sn = Sip;
    return
end
for ind_Ui = 1:len_Ui
    clause_Ui = Ui(ind_Ui).clauses;
    len_Sn = len_Sn + 1;
    Sn(len_Sn).clauses = clause_Ui;
end
