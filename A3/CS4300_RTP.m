function Sip = CS4300_RTP(sentences,thm,vars)
% CS4300_RTP - resolution theorem prover
% On input:
% sentences (CNF data structure): array of conjuctive clauses
% (i).clauses
% each clause is a list of integers (- for negated literal)
% thm (CNF datastructure): a disjunctive clause to be tested
% vars (1xn vector): list of variables (positive integers)
% On output:
% Sip (CNF data structure): results of resolution
% []: proved sentence |- thm
% not []: thm does not follow from sentences
% Call: (example from Russell & Norvig, p. 252)
% DP(1).clauses = [-1,2,3,4];
% DP(2).clauses = [-2];
% DP(3).clauses = [-3];
% DP(4).clauses = [1];
% thm(1).clauses = [4];
% vars = [1,2,3,4];
% Sr = CS4300_RTP(DP,thm,vars);
% Author:
% Tim Wei, Haochen Zhang
% UU
% Fall 2017
%

% this function implements the algorithm from p. 255 of the book
%{
function PL-RESOLUTION(KB,?) returns true or false
inputs: KB, the knowledge base, a sentence in propositional logic
        ?, the query, a sentence in propositional logic
clauses ? the set of clauses in the CNF representation of KB ? ¬?
new ?{}
loop do
    for each pair of clauses Ci, Cj in clauses do
        resolvents ? PL-RESOLVE(Ci, Cj )
        if resolvents contains the empty clause then return true
        new ? new ? resolvents
    if new ? clauses then return false
    clauses ? clauses ?new
%}

% clauses ? the set of clauses in the CNF representation of KB ? ¬?
for newclause = thm
    sentences(end+1) = -newclause;
end

% new ?{}
new = [];

% loop do
while 1
    
    %for each pair of clauses Ci, Cj in clauses do
    for i = 1:length(sentences)
        ci = sentences(i).clauses;
        for j = i:length(sentences)
            cj = sentences(j).clauses;
            
            % resolvents ? PL-RESOLVE(Ci, Cj)
            resolvents = ci;
            isnew = 0;
            for v = cj
                k = find(resolvents==-v)
                if ~isempty(k)
                    isnew = 1;
                    resolvents(k) = [];
                else
                    resolvents = [resolvents,v];
                end
            end
            resolvents = unique(resolvents);
            
            % if resolvents contains the empty clause then return true
            if isempty(resolvents)
                Sip = resolvents;
                return;
            end
            
            % new ? new ? resolvents
            if isnew
                for other = new
                    oc = other.clauses;
                    if length(oc) == length(resolvents)
                        if all(oc == resolvents)
                            isnew = 0;
                            break;
                        end
                    end
                end
                if isnew
                    new(end+1).clauses = resolvents;
                end
            end            
        end
    end
    % if new ? clauses then return false
    for i = 1:length(new)
    end
    % clauses ? clauses ? new
end
