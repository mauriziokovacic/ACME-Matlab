function [M] = spiral_matrix(V)
M = V(1);
V = V(2:end);

f = {@col, @row};
g = {@down, @right, @up, @left};
i = 1;
j = 1;
while(~isempty(V))
    M = g{j}(M, V(1:f{i}(M)));
    V = V(f{i}(M)+1:end);
    i = mod(i,2)+1;
    j = mod(j,4)+1;
end

end


function [X] = up(A,B)
X = [fliplr(B);A];
end

function [X] = down(A,B)
X = [A;B];
end

function [X] = left(A,B)
X = [B',A];
end

function [X] = right(A,B)
X = [A,fliplr(B)'];
end