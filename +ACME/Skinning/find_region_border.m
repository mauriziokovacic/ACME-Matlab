function [E] = find_region_border(T,ID)
A = Adjacency([],T,'face');

[Ti,Tj] = find(A);
i = find(ID(Ti)~=ID(Tj));
Ti = Ti(i);
Tj = Tj(i);

[Ii,Ji,Ki] = tri2ind(T(Ti,:));
[Ij,Jj,Kj] = tri2ind(T(Tj,:));

E = zeros(size(Ti,1),1);

E(prod(sort([Ii Ji],2)==sort([Ij Jj],2),2)>0) = 1;
E(prod(sort([Ii Ji],2)==sort([Jj Kj],2),2)>0) = 2;
E(prod(sort([Ii Ji],2)==sort([Kj Ij],2),2)>0) = 3;

E(prod(sort([Ji Ki],2)==sort([Ij Jj],2),2)>0) = 1;
E(prod(sort([Ji Ki],2)==sort([Jj Kj],2),2)>0) = 2;
E(prod(sort([Ji Ki],2)==sort([Kj Ij],2),2)>0) = 3;

E(prod(sort([Ki Ii],2)==sort([Ij Jj],2),2)>0) = 1;
E(prod(sort([Ki Ii],2)==sort([Jj Kj],2),2)>0) = 2;
E(prod(sort([Ki Ii],2)==sort([Kj Ij],2),2)>0) = 3;

I = sub2ind(size(T),Tj,E);
J = sub2ind(size(T),Tj,mod(E,3)+1);

E = unique(sort([T(I) T(J)],2),'rows');

end