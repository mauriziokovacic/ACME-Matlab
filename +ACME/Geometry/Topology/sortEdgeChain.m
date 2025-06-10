function [E] = sortEdgeChain(E)
e = E(1,:);
Q = E(2:end,:);
while(~isempty(Q))
    j = find(Q(:,1)==e(end,2),1);
    if(isempty(j))
        break;
    end
    e = [e;Q(j,:)];
    Q(j,:)=[];
end
E = e;
end