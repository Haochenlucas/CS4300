function [Sip, finished] = CS4300_RTP(sentences,thm,vars)
% CS4300_RTP - resolution theorem prover
% On input:
%     sentences (CNF data structure): array of conjuctive clauses
%       (i).clauses
%           each clause is a list of integers (- for negated literal)
%     thm (CNF data structure): 1 disjunctive clause to be tested
%     vars (1xn vector): list of variables (positive integers)
% On output:
%     Sip (CNF data structure): results of resolution
%        []: proved sentence |- thm
%        not []: thm does not follow from sentences
%     finished (boolean): this function is done in 30 sec
% Method:
%  Let S1 = S.
% Let i = 1.
% LOOP until i = n + 1.
% Discard members of Si in which a literal and its
%    complement appear, to obtain Sip.
% Let Ti be the set of parent clauses in Sip in which Pi or
%    -Pi appears.
% Let Ui be the set of resolvent clauses obtained by
%     resolving (over Pi ) every pair of clauses C U {Pi} and
%     D U {-Pi} in Ti.
% Set Si+1 equal to (Sip\Ti) U Ui . (Eliminate Pi ).
% Let i be increased by 1.
% ENDLOOP.
% Output Sn+1.
% Call:  (example from Russell & Norvig, p. 252)
%     DP(1).clauses = [-1,2,3,4];
%     DP(2).clauses = [-2];
%     DP(3).clauses = [-3];
%     DP(4).clauses = [1];
%     thm = [4];
%     vars = [1,2,3,4];
%     Sr = CS4300_RTP(DP,thm,vars);
% Author:
%     T. Henderson
%     UU
%     Summer 2014
% Modified by:
%     Haochen Zhang & Tim Wei
%     UU
%     Fall 2017
%
debug = 1;
finished = 1;
if ~debug
    s = tic;
    num_sentences = length(sentences);
    len_thm = length(thm(1).clauses);
    not_thm = -thm(1).clauses;
    for ind = 1:len_thm
        num_sentences = num_sentences + 1;
        sentences(num_sentences).clauses = [not_thm(ind)];
    end

    n = length(vars);
    Sipn = sentences;
    for i = 1:n
        Sip = CS4300_elim_L_nL(Sipn);
        Ti = CS4300_parent_clauses(Sip,vars(i));
        Ui = CS4300_resolvent_clauses(Ti,vars(i));
        if CS4300_empty_clause(Ui)
            Sip = [];
            return
        end
        [Sipn, finished] = CS4300_update_S(Sip,Ti,Ui,s);
        if ~finished
            return;
        end
    end
    Sip = Sipn;
    return;
end






s = tic;

l = length(sentences);
% sort all clauses in sentences
for i = 1:l    
    sentences(i).clauses = unique(sentences(i).clauses);
end
%% clauses <- the set of clauses in the CNF representation of KB & �alpha
for newclause = thm(1).clauses
    sentences(end+1).clauses = -newclause;
end
% put �alpha clauses in the front of the list for faster checking.
sentences = [sentences(l+1:end), sentences(1:l)];

%% new <- {}
new = [];

% index of the clauses in sentences that have not been used.
notChecked = 2;
% index of the clauses in new that have not been used.
newNotChecked = 1;

%% loop do
while 1
    
    %% for each pair of clauses Ci, Cj in clauses do
    % To compare every pair, all clauses need to be Ci.
    for i = 1:length(sentences)
        ci = sentences(i).clauses;
        % The clauses before notChecked has been checked, skip them.
        for j = notChecked:length(sentences)
            cj = sentences(j).clauses;
            %% resolvents <- PL-RESOLVE(Ci, Cj)
            % start with one clause (Ci).
            resolvent = ci;
            % flag of if a resolvent is raised.
            isnew = 0;
            for v = cj
                % find the index the complement of an element of Cj in Ci.
                k = find(resolvent==-v);
                if ~isempty(k)
                    % the is such element in Ci, a resolvent has been
                    % raised.
                    if isnew
                        % there are two pairs of complements, discard this 
                        % resolvent.
                        isnew = 0;
                        break;
                    end
                    isnew = 1;
                    % remove that element from the resolvent.
                    resolvent(k) = [];
                else
                    % there is no such element, put the element from Cj
                    % into resolvent.
                    resolvent = [resolvent,v];
                end
            end
            % remove duplicates and sort the resolvent.
            resolvent = unique(resolvent);
            
            %% if resolvents contains the empty clause then return true
            if isempty(resolvent)
                Sip = resolvent;
                return;
            end
            
            %% new <- new U resolvents
            if isnew
                % the clause is a resolvent, check if it is in the new
                % list, if not, add it into new.
                for other = new
                    % oc means other clauses
                    oc = other.clauses;
                    % if the length is different, they must be different.
                    if length(oc) == length(resolvent)
                        % compare if all the elements in oc and resolvent 
                        % are the same. 
                        % they are sorted so it's fast.
                        if all(oc == resolvent)
                            % its already in the new list, so its not
                            % actually new.
                            isnew = 0;
                            break;
                        end
                    end
                    
                    if toc(s) > 1
                        Sip = sentences;
                        finished = 0;
                        return;
                    end
                end
                % the loop was not broken the resolvent is new.
                if isnew
                    new(end+1).clauses = resolvent;
                end
            end    
            
        end
    end
    %% if new is subset of clauses then return false
    % this is done by comparing all clauses in new to all clauses in
    % sentences. If a clause in new is already in sentences, it will be
    % removed from a copy of new. If the copy is empty at the end, new is
    % a subset of sentences.
    
    % the indexes of the clauses in new that has to be removed due to
    % being a duplicate.
    oldIndexes = [];
    % the clauses before newNotChecked are all already checked
    copyNew = new(newNotChecked+1:end);
    for i = 1:length(copyNew)
        newClauses = copyNew(i).clauses;
        for sentence = sentences
            oldclauses = sentence.clauses;
            if length(newClauses) == length(oldclauses)
                if all(newClauses == oldclauses)
                    % the clause in new is in sentences.
                    % add the indexes in descending order so the will be
                    % removed correctly.
                    oldIndexes = [i, oldIndexes];
                    break;
                end
            end            
        end
    end
    % remove duplicated clauses from the copy.
    for i = oldIndexes
        copyNew(i) = [];
    end
    if isempty(copyNew)
        % new is subset of clauses, return the resolvents for checking.
        Sip = sentences;
        return;
    end
    newNotChecked = length(new);
    notChecked = length(sentences) + 1;
    %% clauses <- clauses U new
    % duplicated clauses are removed from the copy.
    sentences = [sentences,copyNew];
end
