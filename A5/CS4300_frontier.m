function frontiers = CS4300_frontier(visited)

frontiers = zeros(4,4);
row = 0;
col = 0;

for r = 1:4
    for c = 1:4
        if visited(r,c)==1
            nei = BR_Wumpus_neighbors(c,4-r+1);
            num_nei = length(nei(:,1));
            for n = 1:num_nei
                if visited(4-nei(n,2)+1,nei(n,1))==0
                    col = 4 - nei(n,2) + 1;
                    row = nei(n,1);
                    frontiers(col,row) = 1;
                end
            end
        end
    end
end