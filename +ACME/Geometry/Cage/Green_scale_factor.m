function [S] = Green_scale_factor(P,T,PP)
I  = T(:,1);
J  = T(:,2);
K  = T(:,3);
U  = P(J,:)-P(I,:);
V  = P(K,:)-P(I,:);
UU = PP(J,:)-PP(I,:);
VV = PP(K,:)-PP(I,:);
A  = sqrt(8) .* triangle_area(P,T);
S = ( ...
    vecnorm3(UU).^2 .* vecnorm3(V).^2 ...
    - 2 .* (dot(UU,VV,2) .* dot(U,V,2) ...
    + vecnorm3(U).^2 .* vecnorm3(VV).^2).^0.5 ...
    ) ./ A;
end