function spectral(P,T,n)
M = cotangent_Laplacian(P,T);
D = spdiags(1./(2.*vertex2face(triangle_area(P,T)./3,T)),0,row(P),row(P));
L = D*M;
[U,S,V] = svd(full(L));

X = P(:,1);
Y = P(:,2);
Z = P(:,3);
X_ = zeros(numel(X),1);
Y_ = zeros(numel(Y),1);
Z_ = zeros(numel(Z),1);

for i = 1 : n
X_ = X_ + V(:,i)*V(:,i)'*X;
Y_ = Y_ + V(:,i)*V(:,i)'*Y;
Z_ = Z_ + V(:,i)*V(:,i)'*Z;
end

Q = [X_ Y_ Z_];
N = vertex_normal(Q,T);
CreateViewer3D('right');
display_mesh(Q,N,T);

end