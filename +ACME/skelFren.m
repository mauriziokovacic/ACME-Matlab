function [P,T,N,B] = skelFren(S)
G = S.Graph;
n = numnodes(G);
P = referenceJointPosition(S);
x = [];
for i = 1 : n
    p = predecessors(G,i);
    s = successors(G,i);
    if(isempty(p))
        p = i;
    end
    if(isempty(s))
        s = i;
    end
    for j = 1 : numel(s)
        x = [x;p i s(j)];
    end
end
T = normr(accumarrayN(x(:,2),P(x(:,3),:)-P(x(:,1),:)));
N = normr(accumarrayN(x(:,2),T(x(:,3),:)-T(x(:,1),:)));
B = normr(cross(T,N,2));
end