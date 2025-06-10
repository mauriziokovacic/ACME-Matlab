function [ID] = region_border( T, R, r )
I = T(:,1);
J = T(:,2);
K = T(:,3);

ID = [I( (R(I)~=r) & ( (R(J)==r) | ( R(K)==r) ) );...
      J( (R(J)~=r) & ( (R(K)==r) | ( R(I)==r) ) );...
      K( (R(K)~=r) & ( (R(I)==r) | ( R(J)==r) ) ) ];
ID = unique(ID,'rows');
end