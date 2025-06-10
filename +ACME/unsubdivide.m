function [P,T,I] = unsubdivide(P,T,iter)
I = T;
for n = 1 : iter
    I = reshape(I(:,1),4,row(I)/4)';
    if(istri(T))
        I = I(:,1:3);
    end
    if(col(I)==1)
        I = I';
    end
end
P = P(unique(I),:);
T = reindex(I);
I = unique(I);
end