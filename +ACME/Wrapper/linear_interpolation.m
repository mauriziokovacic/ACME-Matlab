function [Vq] = linear_interpolation(X,V,Xq)
Vq = zeros(row(Xq),col(V));
for i = 1 : col(X)
    Vq(:,i) = interp1(X,V,Xq,'linear');
end
end